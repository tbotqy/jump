function facebook(d, s, id) {
  var js, fjs = d.getElementsByTagName(s)[0];
  if (d.getElementById(id)) return;
  js = d.createElement(s); js.id = id;
  js.src = "//connect.facebook.net/ja_JP/all.js#xfbml=1&appId=258025897640441";
  fjs.parentNode.insertBefore(js, fjs);
}

function getUserAgent(){

  var userAgent = window.navigator.userAgent.toLowerCase();

  if (userAgent.indexOf('opera') != -1) {
    return 'opera';
  } else if (userAgent.indexOf('msie') != -1) {
    return 'ie';
  } else if (userAgent.indexOf('chrome') != -1) {
    return 'chrome';
  } else if (userAgent.indexOf('safari') != -1) {
    return 'safari';
  } else if (userAgent.indexOf('firefox') != -1) {
    return 'firefox';
  } else {
    return false;
  }
    
}

function scrollToPageTop(e){
  
  if(e){
    e.preventDefault();
  }
  
  $("html, body").animate(
    {scrollTop:0},
    {easing:"swing",duration:500}
  );
  
  return false;
}

function scrollDownToDestination(e,distance){
  
  e.preventDefault();
  
  distance -= 160;
  
  $("html, body").animate(
    {scrollTop: distance},
    {easing:"swing",duration:500}
  );

  return false;
}

function showLoader(parentName){
  var type = typeof(parentName);

  if(type == "string"){
    $(parentName).find(".loader").fadeIn();      
  }else if(type == "object"){
    parentName.find(".loader").fadeIn();
  }
  
}

function hideLoader(parentName){
  var type = typeof(parentName);
  
  if(type == "string"){
    $(parentName).find(".loader").fadeOut();
  }else if(type == "object"){
    parentName.find(".loader").fadeOut();
  }
  
}

function checkStatusUpdate(){

  /**
   * check if there is any tweets yet to have imported
   */
  
  var doUpdate = false;
  var updated_date = "";
  var box_tweets =$("#wrap-configurations").find(".tweets");
 
  $.ajax({
      
    url:"/ajax/check_status_update",
    type:"post",
    dataType:"json",
    
    success: function(responce){
  
      doUpdate = responce.result;
      updated_date = responce.updated_date;
     
      if(doUpdate){
	
	updateStatus();
	
      }else{

	// change the view statements
	$("#update-statuses").text("処理終了");
	
	box_tweets.find(".loader").fadeOut();
	
	box_tweets.find(".additional-num").fadeOut(function(){
	  $(this).addClass("alert alert-info").text("変更はありません");
	}).fadeIn();
	
	box_tweets.find(".last-update .date").fadeOut(function(){
	  $(this).text(updated_date);
	}).fadeIn();
	
      }
      
    },
    error: function(){
      
      box_tweets.find(".additional-num").fadeOut(function(){
	$(this).addClass("alert alert-danger").text("もう一度お試しください");
      }).fadeIn();
      
      // change the view statements
      $("#update-statuses").text("エラー");
      
      box_tweets.find(".loader").fadeOut();
    }
  });
};

function checkFriendUpdate(){
 
  /**
   * checks if there is any new friend on twitter
   */
  
  var count;
  var updated;
  var updated_date;
  var area_friends = $("#wrap-configurations").find(".friends");

  $.ajax({

    url: "/ajax/check_friend_update",
    type: "post",
    dataType: "json",
  
    success: function(responce){
    
      count = responce.count_friends;
      updated = responce.updated;
      updated_date = responce.updated_date;
     
      // show the result
      if(updated){
	
	area_friends.find(".count .total-num").fadeOut(function(){
	  $(this).text(count);
	}).fadeIn();

	area_friends.find(".count .additional-num").fadeOut(function(){
	  $(this).addClass("alert alert-success").text("更新しました");
	}).fadeIn();

	$("#update-friends").text("更新完了");
	
      }else{

	area_friends.find(".count .additional-num").fadeOut(function(){
	  $(this).addClass("alert alert-info").text("変更はありません");
	}).fadeIn();
	
	$("#update-friends").text("処理終了");
      }

      area_friends.find(".last-update .date").fadeOut(function(){
	$(this).text(updated_date);
      }).fadeIn();
      
    },

    error: function(){
      
      area_friends.find(".count .additional-num").fadeOut(function(){
	$(this).addClass("alert alert-danger").text("もう一度お試しください");
      }).fadeIn();
  
      $("#update-friends").text("エラー");

    },

    complete: function(){

      // hide the loading icon
      hideLoader(".friends");

    }

  });

}

function checkProfileUpdate(){

  /**
   * checks if update is needed for current User database
   */

  var updated = false;
  var updated_date,updated_value;
  var wrap_profile = $(".wrap-profile");

  $.ajax({
    
    url: "/ajax/check_profile_update",
    type: "post",
    dataType: "json",
    
    success: function(res){
      updated = res.updated;
      updated_date = res.updated_date;
      updated_value = res.updated_value;
     
      if(updated){
        $.each(updated_value,function(key,val){
          var class_name = key.split("_").join("-");
          if($("."+class_name)[0]){
          
            if(class_name.indexOf("image") != -1){
              // update profile image area
              $("."+class_name).fadeOut(function(){
                $(this).attr("src",val.replace("_normal","_reasonably_small"));
              }).fadeIn();
              // update profile image in header area
              $("header").find(".twitter-profile img").fadeOut(function(){
                $(this).attr("src",val);
              }).fadeIn();
            }else{
              // update each value
              $("."+class_name).fadeOut(function(){
                $(this).text(val);
              }).fadeIn();
              
              if(class_name.indexOf("screen-name") != -1){
                // also update screen name in header area
                $("header").find(".twitter-profile a:last").fadeOut(function(){
                  $(this).text("@"+val);
                }).fadeIn();
              }
              
            }
            
          }
        });
      }

      $(".updated-date").fadeOut(function(){
        $(this).text(updated_date);
      }).fadeIn();
      
      hideLoader(".wrap-profile");
      
      var complete_text = updated ? "更新完了" : "処理終了";
      
      $("#update-profile").text(complete_text);

      var alert_type = updated ? "alert-success" : "alert-info";
      var alert_text = updated ? "更新しました" : "変更はありません";
      wrap_profile.find(".area-result .alert").addClass(alert_type).text(alert_text).fadeIn();
    },
  
    error: function(){

      wrap_profile.find(".area-result .alert").addClass("alert-danger").text("もう一度お試しください").fadeIn();
 
      $("#update-profile").text("エラー");
      hideLoader(".wrap-profile");
    }
    

  });
   
}      

var total_count = 0;
var oldest_id_str = "";
var continue_process = "";
var updated_date = "";

function updateStatus(){
  
  var area_tweets = $("#wrap-configurations").find(".tweets");
  var update_button = $("#update-statuses");
  
  $.ajax({
    
    url:"/ajax/update_statuses",
    type:"post",
    dataType:"json",
    data:{"oldest_id_str":oldest_id_str},
      
    success: function(responce){
      continue_process = responce.continue;
      updated_date = responce.updated_date;

      if(continue_process){
	
	total_count += responce.count_saved;
	oldest_id_str = responce.oldest_id_str;

	// show the total number of statuses that have been imported so far
	area_tweets.find(".additional-num").fadeOut(function(){
	  $(this).text("+ "+total_count);
	}).fadeIn();

	updateStatus();
	
      }else{
	  
	total_count += responce.count_saved;

	var final_total = 0;
	var current_num = parseInt($(".tweets").find(".count .total-num").text());
	
	final_total = current_num + parseInt(total_count);
	
	area_tweets.find(".total-num").fadeOut(function(){
	  $(this).text(final_total).fadeIn();
	});
	
	area_tweets.find(".additional-num").fadeOut(function(){
	  $(this).addClass("alert alert-success").text(total_count+"件追加");
	}).fadeIn();

	area_tweets.find(".last-update .date").fadeOut(function(){
	  $(this).text(updated_date);
	
	}).fadeIn();

	// change the button statement
	update_button.text("更新完了");
	
      }
      
    },
    
    error: function(){

      area_tweets.find(".additional-num").fadeOut(function(){
	$(this).addClass("alert alert-danger").text("もう一度お試しください");
      }).fadeIn();

      // change the button statement
      update_button.text("エラー");
	
      // hide the loader
      $(".loader").fadeOut();
      
    },
      
    complete: function(){
      if(!continue_process){
	
	// hide the loader
	$(".loader").fadeOut();
      }
    }
    
  });
};

function showDeleteCompleteMessage(flag){
  
  var message = "";
  var area_status = $("#modal-delete-account").find(".status");		  
  
  if(flag){
    message = "アカウント削除が完了しました。自動的にログアウトします。";
  }else{
    message = "すみません！処理が完了しませんでした。画面をリロードしてもう一度お試しください。";  
  }

  area_status.fadeOut(function(){
    $(this).text(message);
  }).fadeIn();

}

function showDeleteErrorMessage(){
  
  return showCompleteMessage(false);

}

function redirect(){
 
  location.href="/users/logout";

}

// initialize value
var total_imported_count = 0;

function getStatuses(params){

  /**
   * throw request to acquire all the statuses recursively
   */

  var wrap_progress_bar = $(".wrap-progress-bar");
  var wrap_tweet = $(".wrap-tweet");
  var import_button = $("#start-import");  
  var noStatusAtAll = "";
  var data_to_post = params;
  var progress;

  $.ajax({
    
    url: "/ajax/acquire_statuses",
    type: "POST",
    dataType:"json",
    data: data_to_post,
    
    success: function(ret){
  
      total_imported_count += ret.saved_count;
      noStatusAtAll = ret.noStatusAtAll;

      if(ret.continue){

	$(".wrap-importing-status").fadeOut(function(){

	  //show the result
	  wrap_progress_bar.find(".total").html(total_imported_count+"件");
	  wrap_tweet.find(".body").html(ret.status.text);
	  wrap_tweet.find(".date").html(ret.status.date);
	  
	});
	  
	//throw new request
	data_to_post.id_str_oldest = ret.id_str_oldest;
	progress = getPersentage(total_imported_count);
	getStatuses(data_to_post);
	
      }else{
	  
	if(total_imported_count == 0){
	  
	  import_button.text("...?");
	  
	  wrap_progress_bar.find(".progress").fadeOut(function(){
	    wrap_progress_bar.append("<div class=\"alert alert-info\"><p>取得できるツイートが無いようです</p></div>");
	    wrap_progress_bar.find(".alert").fadeIn();
	  });
	  
	}else{
	  
	  wrap_progress_bar.find(".bar").html("complete!");
	  
	  progress = 100;
	  
	  //show the result
	  import_button.addClass('disabled');
	  import_button.text(total_imported_count + "件取得しました");
	  
	  // stop animation
	  $(".progress").removeClass("active");
	  
	  hideLoader("#wrap-import");
	}
      }
    },
    
    error: function(){
      
      //show the error message
      $(".progress").removeClass("active");
      hideLoader("#wrap-import");

      $(".wrap-progress-bar").fadeOut(function(){
	$(".wrap-lower").html("<div class=\"alert alert-warning\"><p>サーバーが混み合っているようです。<br/>すみませんが、しばらくしてからもう一度お試しください。</p></div>");
      $("#start-import").text("...oops");
	
      });
      
    },
    
    complete: function(){

      if(noStatusAtAll){
	
	hideLoader("#wrap-import");
      
      }else{

	// animate progress bar
	setProgress(progress);
	
	$(".wrap-importing-status").fadeIn();
      }
      
      if(progress == 100){
	// when done, redirect after 2 seconds 
	setTimeout(function(){
          location.href = "/your/tweets";
	},2000);
      }

    }
  });
}

function getPersentage(fetched_status_count){
 
  fetched_status_count = parseInt(fetched_status_count);
  var total = parseInt($("#statuses-count").val()); 
  
  var ret = "";
  if(fetched_status_count > 3200){
    ret = (fetched_status_count / 3200) * 100;
  }else{
    ret = (fetched_status_count / total) * 100;
  }
  
  return parseInt(ret);
}

function setProgress(persentage){
  
  $(".progress").find(".bar").css("width",persentage+"%");

}

function ajaxSwitchDashbord(actionType){

  /**
   * switches dashbord according to given actionType
   * @param actionType should represent from which kind of timeline the dashbord is created
   */

  var wrap_dashbord = $("#wrap-dashbord");
  var wrap_term_selectors = $("#wrap-term-selectors");
  
  $.ajax({
    
    url: "/ajax/switch_dashbord",
    type: "post",
    dataType: "html",
    data:{"action_type":actionType},
    
    success: function(res){
      // insert new html code
      wrap_term_selectors.html(res);

      // rewrite the data attribute in parent div
      wrap_dashbord.attr('data-type',actionType);
    },

    error: function(){
      alert("ページの読み込みがうまくいきませんでした。リロードしてみて下さい。");
    }
    
  });

}

function getDashbordType(){
    
  var ret = $("#wrap-dashbord").data('type');
  
  if(!ret){
    return false;
  }
  
  return ret;

}

function ajaxSwitchTerm(date,action_type,mode){
 
  /**
   * load statuses in specified date and dataType
   * @param date : specifies the timeline's date to show in
   * @param action_type : the type of timeline
   * @param mode : the name of event which fired this function
   */
  
  if(!date || !action_type || !action_type || !mode){
    alert("required params not supplied");
    return ;
  }

  // elements
  var wrap_timeline = $("#wrap-timeline");
  
  // show the cover area
  wrap_timeline.html("<div class=\"cover\"><span>Loading</span></div>");
  var cover = wrap_timeline.find('.cover');
  cover.css("height",200);
  cover.animate({
    opacity: 0.8
  },200);
    
  // fetch statuses 
  $.ajax({
    type: 'GET',
    dataType: 'html',
    url:'/ajax/switch_term?ajax=true',
    data:{
      "date":date,
      "date_type": detectDateType(date),
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
      scrollToPageTop();
      
      // show the loaded html
      $("#wrap-main").fadeIn('fast');

      // let the button say that process has been done
      $("#wrap-term-selectors").find("a").button('complete');
	
      if(mode == "click"){
        // record requested url in the histry
        window.history.pushState(null,null,href);
      }
    
    }
  
  });
}  

function countStr(str,dest){
  
  var index;
  var count = 0;
  var searchFrom = 0;
  
  while(true){

    // search dest in str
    index = str.indexOf(dest,searchFrom);
    
    if(index != -1){
      
      // if found, count as found
      count++;
      
      // iterate search point
      searchFrom = index + 1;
      
    }else{
      break;
    }
    
  }
  
  return count;
}

function detectDate(path){
      
  // check if given path contains date parameter
  
  var lastSlash = path.lastIndexOf("/");
  
  if(lastSlash == -1){
    return false;
  }

  var ret = path.substring(lastSlash + 1);
  
  return ret;
}

function detectDateType(date){
  
  var hyphen = "-";
  var ret;
  
  if(date.indexOf(hyphen) == -1){

    if(date.length >= 4){
      ret = "year";
    }else{
      ret = false;
    }
      
  }else{
    
    if(date.indexOf(hyphen) == date.lastIndexOf(hyphen)){
      ret = "month";
    }else{
      ret = "day";
    }
    
  }
  
  return ret;
}

function detectActionType(path){
    
  /**
   * detect and get the action_type from given path
   */

  // action type exists next to the second slash
  var firstSlash = path.indexOf("/");

  if(firstSlash == -1){
    return false;
  }

  // check if current action type is public_timeline
  if(path.indexOf("public_timeline") != -1){
      return "public_timeline";
  }
  
  var secondSlash = path.indexOf("/",firstSlash+1);

  if(secondSlash == -1){
    return false;
  }
  
  // check if more slash exists
  var thirdSlash = path.indexOf("/",secondSlash+1);
  if(thirdSlash == -1){
    return path.substr(secondSlash+1);
  }else{
    // case that thirdSlash exists
    var lengthActionType = thirdSlash - secondSlash;
    return path.substr(secondSlash+1,lengthActionType-1);
  }

}
