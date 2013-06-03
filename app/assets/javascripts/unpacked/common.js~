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
  
  $("#wrap-timeline").on("click",".status-content",function(e){
    
    // do process only if clicked element is not <a>
    var clicked = $(e.target);
    if(!clicked.is('a') && !clicked.is('i')){
      
      $(this).find(".bottom").slideToggle('fast');
      
    }
    
  });

  // click action to fire a delete ajax action
  $("#wrap-timeline").on("click",".status-content .link-delete a",function(e){
    
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
  $("#wrap-timeline").on("click","#read-more",function(e){
    
    var self = $(this);

    e.preventDefault();
    var distance = self.offset().top;

    // let button say 'loading'
    self.button('loading');
    var elmOldestTimestamp = $("#oldest-timestamp");
    // fetch more statuses to show
    $.ajax({

      type:"POST",
      dataType:"html",
      data:{
	"oldest_timestamp":elmOldestTimestamp.attr("value"),
	"destination_action_type":detectActionType(location.pathname)
      },
      url: '/ajax/read_more',
      success: function(responce){
	// remove the element representing last status's timestamp
	elmOldestTimestamp.remove();
	
	$("#wrap-read-more").remove();

	// insert loaded html code 
	$(".wrap-each-status:last").after(responce);
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
   * the process to update profile
   */

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
   * the process to update tweets
   */

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
   * the process to update friend list
   */

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
   * the process for account deletion
   */

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
      
      url: '/ajax/delete_account',
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
  
  ////////////////////////////////
  // code for elements/dashbord //
  ////////////////////////////////

  // mouseover action for year list in dashbord
  $(".list-years").find("li").mouseover(function(){
    var self = $(this);

    // normalize all the buttons for years
    $(".list-years").find("a").removeClass("btn-primary selected");
 
    // apply unique css feature only to focused button 
    self.find('a').addClass("btn-primary selected");
    
    // hide all the lists for months and days
    $("#wrap-list-months").find("ul").css('display','none');
    $("#wrap-list-days").find("ul").css('display','none');
    
    // get the data-date value in hovered button
    var year = self.attr('data-date');

    // show the months list whose class is equal to var year
    $("#wrap-list-months").find("."+year).css('display','block');
    
  });

  // mouseover action for months list in dashbord
  $(".list-months").find("li").mouseover(function(){
    var self = $(this);

    // normalize all the buttons for months
    $(".list-months").find("li").find("a").removeClass("btn-primary selected");
  
    // apply unique css feature only to focused button 
    self.find('a').addClass("btn-primary selected");

    // hide all the days lists
    $("#wrap-list-days").find("ul").css('display','none');

    // get the data-date value in hovered button 
    var month = self.attr('data-date');
    
    // show the days list whose class is equal to var month
    $("#wrap-list-days").find("."+month).css('display','block');
 
  });

  if('pushState' in history){

  // click action to change the term of statuses to show
  $("#wrap-term-selectors").find("a").click(function(e){
    var self = $(this);

    // prevent the page from reloading
    e.preventDefault();

    // get href attr in clicked button
    var href = self.attr('href');
    
    // acquire the date to fetch from clicked button
    var date = self.attr('data-date');
    var date_type = self.attr('data-date-type');

    // show the loading icon over the statuses area
    var wrap_timeline = $("#wrap-timeline");
 
    wrap_timeline.html("<div class=\"cover\"><span>Loading</span></div>");

    var cover = wrap_timeline.find('.cover');
 
    cover.css("height",200);
    
    cover.animate({
      opacity: 0.8
    },200);

    // check the type of data currently being shown
    var path = location.pathname;
    var action_type = detectActionType(path);
  
    // fetch statuses 
    $.ajax({
      type: 'GET',
      dataType: 'html',
      url:'/ajax/switch_term',
      data:{
        "date":date,
        "date_type":date_type,
        "action_type":action_type
      },
      success: function(responce){

	// insert recieved html
	$("#wrap-main").html(responce);
      },
      error: function(responce){
	alert("読み込みに失敗しました。画面をリロードしてください");	
      },
      complete: function(){

	// scroll to top
	scrollToPageTop(e);

	// show the loaded html
	$("#wrap-main").fadeIn('fast');

	// let the button say that process has been done
	$("#wrap-term-selectors").find("a").button('complete');
	
	// record requested url in the histry
	window.history.pushState(null,null,href);
	
      }
    });
  });
      
  }

  // click event for year selector
  $("#wrap-list-years").find("a").click(function(){
    
    // normalize all the buttons labeled as day selector
    $("#wrap-list-months").find(".selected").removeClass("selected btn-primary");

    // normalize all the buttons labeled as day selector
    $("#wrap-list-days").find(".selected").removeClass("selected btn-primary");

    // make clicked button selected
    $(this).addClass("selected btn-primary");
    
  });

  // click event for month selector
  $("#wrap-list-months").find("a").click(function(){
    
    // normalize all the buttons labeled as day selector
    $("#wrap-list-days").find(".selected").removeClass("selected btn-primary");

    // make clicked button selected
    $(this).addClass("selected btn-primary");
    
  });

  // click event for day selector
  $("#wrap-list-days").find("a").click(function(){
    
    // normalize all the buttons labeled as day selector
    $("#wrap-list-days").find(".selected").removeClass("selected btn-primary");

    // make clicked button selected
    $(this).addClass("selected btn-primary");
    
  });

});