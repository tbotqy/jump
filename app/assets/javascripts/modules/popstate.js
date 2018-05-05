var Popstate = {
  handleWithSp: false,

  bindEvent: function(){
    if(!this.isBindable){
      return;
    }

    if(this.handleWithSp){
      this.hasPopped = ('state' in window.history && window.history.state !== null);
      this.initialURL = location.href;
    }

    this.bindToWindow();
  },

  bindToWindow: function(){
    $(window).on("popstate",function(e){
      if(this.handleWithSp){
        var isInitialPop = !this.hasPopped && location.href == initialURL;
        this.hasPopped = true;
        if(isInitialPop){
          return;
        }
      }

      var white_list = ['tweets','home_timeline','public_timeline'];
      var path = location.pathname;

      var actionTypeOk = false;
      var slashCountOk = false;

      // check if requested action type is allowed to fire process on popstate
      for(var i=0;i<white_list.length;i++){
        if(Popstate.countStr(path,white_list[i]) > 0){
          actionTypeOk = true;
          break;
        }
      }

      if( actionTypeOk ){
        var date;
        var isPublicTimeline = path.indexOf("public_timeline") != -1;

        // count the / in path
        // change its threshold value if view is public timeline
        var threshold;
        if(isPublicTimeline){
          threshold = 2;
        }else{
          threshold = 3;
        }

        if(Popstate.countStr(path,"/") < threshold){
          date = "notSpecified";
        }else{
          date = Popstate.detectDate(path);
        }

        var action_type = SharedFunctions.detectActionType(path);
        Popstate.ajaxSwitchTerm(date,action_type,"pjax");

        // reset all the term selectors
        $("#wrap-term-selectors").find("a.selected").removeClass("btn-primary selected");
      }
    });
  },

  isBindable: function(){
    'pushState' in history;
  },

  ajaxSwitchTerm: function(date,action_type,mode){
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
        "date_type": Popstate.detectDateType(date),
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
  },

  countStr: function(str,dest){
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
  },

  detectDate: function(path){
    // check if given path contains date parameter
    var lastSlash = path.lastIndexOf("/");

    if(lastSlash == -1){
      return false;
    }

    var ret = path.substring(lastSlash + 1);
    return ret;
  },

  detectDateType: function(date){
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
};
