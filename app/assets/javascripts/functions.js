function showLoader(parentName){
  var type = typeof(parentName);

  if(type == "string"){
    $(parentName).find(".loader").fadeIn();
  }else if(type == "object"){
    parentName.find(".loader").fadeIn();
  }

}

function redirect(){

  location.href="/logout";

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

  var count_so_far = $("input[name=count-so-far]").val();
  if( count_so_far != "false" ){
    total_imported_count = parseInt( count_so_far );
    $("input[name=count-so-far]").val("false");
  }

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
      SharedFunctions.scrollToPageTop();

      // show the loaded html
      $("#wrap-main").fadeIn('fast');

      // let the button say that process has been done
      $("#wrap-term-selectors").find("a").button('complete');
      if(mode == "click"){
        // record requested url in the histry
        window.history.pushState(null,null,href);
      }

      // update page title
      PageTitle.updateByDateAndAction(date,action_type);

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
