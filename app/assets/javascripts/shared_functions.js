var SharedFunctions = {
  detectActionType: function(path){
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
  },
  scrollToPageTop: function(e){
    if(e){
      e.preventDefault();
    }
    $("html, body").animate(
      {scrollTop:0},
      {easing:"swing",duration:500}
    );
    return false;
  },
  hideLoader: function(parentName){
    var type = typeof(parentName);

    if(type == "string"){
      $(parentName).find(".loader").fadeOut();
    }else if(type == "object"){
      parentName.find(".loader").fadeOut();
    }
  },
  redirectToLogout: function(){
    location.href = "/logout";
  },
  showDeleteCompleteMessage: function(hasBeenSucceeded, isForPC){
    var message = "";
    if(isForPC){
      var area_status = $("#modal-delete-account").find(".status");
    }else{
      var area_status = $("#wrap-delete-account").find(".status");
    }

    if(hasBeenSucceeded){
      if(isForPC){
        message = "アカウント削除が完了しました。自動的にログアウトします。";
      }else{
        message = "アカウント削除が完了しました。<br/>自動的にログアウトします。";
      }
    }else{
      if(isForPC){
        message = "すみません！処理が完了しませんでした。画面をリロードしてもう一度お試しください。";
      }else{
        message = "すみません！処理が完了しませんでした。<br/>画面をリロードしてもう一度お試しください。";
      }
    }

    area_status.fadeOut(function(){
      if(isForPC){
        $(this).text(message);
      }else{
        $(this).html(message);
      }
    }).fadeIn();
  }
};
