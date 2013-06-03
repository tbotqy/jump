$(function(){
      
  // check user agent
  var userAgent = getUserAgent();
  var uaWhiteList = ['chrome','safari','firefox'];
  var isValidUA = false;

  // make loading social plugin delayed
  setTimeout(function(){
    $.getScript('/js/twitter_follow_button.js');
    $.getScript('/js/twitter_tweet_button.js');
    $.getScript('//b.st-hatena.com/js/bookmark_button.js');
    facebook(document, 'script', 'facebook-jssdk');
  },3000);

  //////////////////////////
  // code for each status //
  //////////////////////////
  
  // click action to hide and show the bottom line in each status
  
  $("#wrap-timeline-lower").on("click",".status-content",function(e){
    
    // do process only if clicked element is not <a>
    var clicked = $(e.target);
    if(!clicked.is('a') && !clicked.is('i')){
      
      $(this).find(".bottom").slideToggle('fast');
      
    }
    
  });

  // click action to fire a delete ajax action
  $("#wrap-timeline-lower").on("click",".status-content .link-delete a",function(e){
    
    e.preventDefault();
    
    if(confirm('ツイートを削除します。よろしいですか？')){

      var status_id_to_delete = $(this).parent().data('status-id');
      
      $.ajax({
        
        url: "/ajax/delete_status",
        type: "post",
        data:{"status_id_to_delete":status_id_to_delete},
        dataType: "json",

        success: function(responce){

          // checks if the status trying to deleted is owned by logging user
          if(responce.owns){
            
            // checks id delete process was correctly done
            if(responce.deleted){
                
              $("div[data-status-id="+status_id_to_delete+"]").fadeOut();
            }else{
              
              alert("ごめんなさい。削除に失敗しました。画面をリロードしてもう一度お試しください。");
            
            }
          
          }else{
            // the status trying to be deleted is not owned by logging user
            alert("不正な操作です。");
          }

        },
        
        error: function(){
          // internal error
          alert("エラーが発生しました。");
        }
      });
    }
  });          
  
  // click action for read more button
  $("#wrap-timeline-lower").on("click","#read-more",function(e){
    
    var self = $(this);

    e.preventDefault();
    var distance = self.offset().top;

    // let button say 'loading'
    self.button('loading');
    var elmOldestTimestamp = $(".oldest-timestamp");
    var oldestTimestamp = elmOldestTimestamp.val();
   
    // fetch more statuses to show
    $.ajax({

      type:"POST",
      dataType:"html",
      data:{
      "oldest_timestamp":oldestTimestamp,
      "destination_action_type":detectActionType(location.pathname)
      },
      url: '/ajax/read_more',
      success: function(responce){
      // remove the element representing last status's timestamp
      elmOldestTimestamp.remove();
      
      $("#wrap-read-more").remove();

      // insert loaded html code 
      $(".wrap-one-result:last").after(responce);
      },
      error: function(responce){
      alert("読み込みに失敗しました。");
      },
      complete: function(){
      
      scrollDownToDestination(e,distance);

      }
    });
  });

  var wrap_progress_bar = $(".wrap-progress-bar");
  var import_button = $("#start-import");  

  //click event activated when start button is clicked
  import_button.click(function(){
    
    // change the button statement
    import_button.button('loading');
    
    // show the loader icon
    showLoader("#wrap-import");
    
    /// show the progress bar
    wrap_progress_bar.fadeIn(function(){

      // show the area displaying the status body currently saving
      $("#status").fadeIn();
    
    });
      
    //initialize data to post
    var data_to_post = {"id_str_oldest":""};
    
    // post ajax request 
    getStatuses(data_to_post);
    
  });
  
  ////////////////////////////////////
  // code for /users/home_timeline  //
  ////////////////////////////////////
  var elmErrorInner = $(".error-inner");
  elmErrorInner.find(".description").click(function(e){
    e.preventDefault();
    elmErrorInner.find(".invite-friends").fadeIn();
  });

  elmErrorInner.find(".invite-friends .close").click(function(e){
    e.preventDefault();
    elmErrorInner.find(".invite-friends").fadeOut();
  });

  ////////////////////////////////////
  // code for /users/configurations //
  ////////////////////////////////////

  /**
   *    * the process to update profile
   *    */

  $("#update-profile").click(function(){
    var self = $(this);
    // change the button's statement
    self.button('loading');

    // show the loading icon 
    self.after("<img class=\"loader\" src=\"/img/ajax-loader.gif\" />");
    $(".wrap-profile").find(".loader").fadeIn();

    checkProfileUpdate();

  });

  /**
   *    * the process to update tweets
   *    */

  $("#update-statuses").click(function(){
    var self = $(this);
    // change the button's statement
    self.button('loading');

    // show the loading icon 
    self.after("<img class=\"loader\" src=\"/img/ajax-loader.gif\" />");
    $(".tweets").find(".loader").fadeIn();

    checkStatusUpdate();

  });

  /**
   *    * the process to update friend list
   *    */

  $("#update-friends").click(function(){
    var self = $(this);

    // change the button's statement
    self.button('loading');

    // show the loading icon
    self.after("<img class=\"loader\" src=\"/img/ajax-loader.gif\" />");
    $(".friends").find(".loader").fadeIn();

    checkFriendUpdate();
    
  });
  
  /**
   *    * the process for account deletion
   *    */

  var deleted = "";
 
  // click event to delete account
  $("#delete-account").click(function(){
    var elmModalDeleteAccount = $("#modal-delete-account");
    // disable cancel button
    elmModalDeleteAccount.find(".modal-header .close").fadeOut();
    elmModalDeleteAccount.find(".modal-footer .cancel-delete").addClass("disabled");

    $(this).button('loading');
    
    elmModalDeleteAccount
      .find(".status")
      .fadeOut(function(){
      $(this).html("処理中...<img src=\"/img/ajax-loader.gif\" class=\"loader\" />"); 
      })
      .fadeIn();
    
    $.ajax({
      
      url: '/ajax/deactivate_account',
      type: 'post',
      dataType: 'json',
      
      success: function(res){
      deleted = res.deleted;
      showDeleteCompleteMessage(res.deleted);
      },

      error: function(){
      showDeleteErrorMessage();
      },
      
      complete: function(){
      if(deleted){

        setTimeout(
            function(){
                  redirect();
                }, 3000
          );
        
      }else{
          alert("処理がうまくいきませんでした。");
        }
      }

    });
  });


  ///////////////////////////////////////////////
  // code for the button to scroll to page top //
  ///////////////////////////////////////////////

  $(window).scroll(function() {
    var topy = $(document).scrollTop();
    var elmToPageTop = $(".to-page-top");
    if (topy >= 200) {
      elmToPageTop.fadeIn();
    }else{
      elmToPageTop.fadeOut();
    }
  });
  
  $(".to-page-top").find("a").click (function(e) {
    scrollToPageTop(e);
  });
  
});