function redirect(){

  location.href="/logout";

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
