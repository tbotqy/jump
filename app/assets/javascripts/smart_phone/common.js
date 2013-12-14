$(function(){
      
  // check user agent
  var userAgent = getUserAgent();
  var uaWhiteList = ['chrome','safari','firefox'];
  var isValidUA = false;

  // make loading social plugin delayed
  setTimeout(function(){
    facebook(document, 'script', 'facebook-jssdk');
  },3000);


  $.ajaxSetup({
    data:{"authenticity_token":getCsrfToken()}
  });

  ////////////////////////////
  // code for timeline nav  //
  ////////////////////////////

  // detect current page type and add active class to the button
  var elmTimelineNav = $("#timeline-nav");
  var currentActionName = elmTimelineNav.data("current-action-name");
  elmTimelineNav.find("."+currentActionName).addClass("active");

  // make link active when it is clicked
  elmTimelineNav.on("click","a",function(e){
    if( $(this).is(":disabled") ){
      e.preventDefault();
    }else{
      elmTimelineNav.find("a").removeClass("active");
      $(this).addClass("active");          
    }
  });

  ////////////////////////////
  // code for global header //
  ////////////////////////////

  var containerHeader = $("#container-header");
  containerHeader.on("click",".drop-down",function(e){
    e.preventDefault();
    containerHeader.find(".drop-down-nav").slideToggle("fast");
  });
  
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
    //var distance = self.offset().top;

    // let button say 'loading'
    self.button('loading');
    var elmOldestTweetId = $(".oldest-tweet-id");
    var oldestTweetId = elmOldestTweetId.val();
    // fetch more statuses to show
    $.ajax({

      type:"POST",
      dataType:"html",
      data:{
        "oldest_tweet_id":oldestTweetId,
        "destination_action_type":detectActionType(location.pathname)
      },
      url: '/ajax/read_more',
      success: function(responce){
        // remove the element representing last status's timestamp
        elmOldestTweetId.remove();
        $("#wrap-read-more").remove();
        
        // insert loaded html code 
        $(".wrap-one-result:last").after(responce);
      },
      error: function(responce){
        alert("読み込みに失敗しました。");
      },
      complete: function(){
        //scrollDownToDestination(e,distance);
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
    var data_to_post = {};
      
    // check if id_str_oldest is specified
    var specified_id_str_oldest = $("input[name=id-oldest]").val();
    if( specified_id_str_oldest != "false"){
      data_to_post.id_str_oldest = specified_id_str_oldest;
      $("#recover-msg").fadeOut();
    }else{
      data_to_post.id_str_oldest = "";        
    }
    
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
  // code for /users/setting        //
  ////////////////////////////////////

  /**
   * the process to update profile
   */

  $("#update-profile").click(function(){
    var self = $(this);
    // change the button's statement
    self.button('loading');

    // show the loading icon 
    self.after("<img class=\"loader\" src=\"/assets/ajax-loader.gif\" />");
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
    self.after("<img class=\"loader\" src=\"/assets/ajax-loader.gif\" />");
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
    self.after("<img class=\"loader\" src=\"/assets/ajax-loader.gif\" />");
    $(".friends").find(".loader").fadeIn();

    checkFriendUpdate();
    
  });
  
  /**
   *    * the process for account deletion
   *    */

  var deleted = "";
 
  // click event to delete account
  $("#delete-account").click(function(){
    var wrapDeleteAccount = $("#wrap-delete-account");

    $(this).button('loading');
    
    wrapDeleteAccount
      .find(".status")
      .fadeOut(function(){
      $(this).html("<span class=\"now\">処理中...</span><img src=\"/assets/ajax-loader.gif\" class=\"loader\" /> "); 
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