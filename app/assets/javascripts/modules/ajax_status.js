var AjaxStatus = {
  handleWithSp: false,
  bindClickEventOrCheckProgress: function(){
    if($("#status-import-is-working").val() === 'true'){
      AjaxStatus.showLoader();
      AjaxStatus.changeButtonState("loading");
      AjaxStatus.checkImportProgress();
    }else{
      AjaxStatus.bindClickEvent();
    }
  },
  bindClickEvent: function(){
    $("#update-statuses").click(function(){
      AjaxStatus.showLoader();
      AjaxStatus.changeButtonState("loading");
      AjaxStatus.startImport();
      AjaxStatus.checkImportProgressWithInterval();
    });
  },
  startImport: function(){
    $.ajax({
      url: "/ajax/start_tweet_import",
      type: "POST"
    });
  },
  checkImportProgress: function(){
    $.ajax({
      url: "/ajax/check_import_progress",
      type: "POST",
      dataType:"json",
      success: function(response){
        if(!response.job_started){
          return AjaxStatus.checkImportProgressWithInterval();
        }
        if(response.finished){
          AjaxStatus.updateImportedStatusCountOnFinish(response.count);
          AjaxStatus.changeButtonState("finished");
          AjaxStatus.hideLoader();
        }else{
          AjaxStatus.updateImportedStatusCount(response.count);
          AjaxStatus.checkImportProgressWithInterval();
        }
      },
      error: function(){
        AjaxStatus.TweetsWrapper().find(".additional-num").fadeOut(function(){
          $(this).addClass("alert alert-danger").text("後程お試し下さい");
        }).fadeIn();
        AjaxStatus.changeButtonState("error");
        AjaxStatus.hideLoader();
      }
    });
  },
  updateImportedStatusCount: function(count){
    AjaxStatus.TweetsWrapper().find(".additional-num").fadeOut(function(){
      $(this).text("+ " + SharedFunctions.numberWithDelimiter(count));
    }).fadeIn();
  },
  updateImportedStatusCountOnFinish: function(count){
    var text = ""
    if(count === 0){
      text = "追加なし"
    }else{
      text = SharedFunctions.numberWithDelimiter(count) + "件追加";
    }
    AjaxStatus.TweetsWrapper().find(".additional-num").fadeOut(function(){
      $(this).addClass("alert alert-success").text(text);
    }).fadeIn();
  },
  checkImportProgressWithInterval: function(){
    setTimeout(function(){
      AjaxStatus.checkImportProgress();
    }, 3000);
  },
  changeButtonState: function(state){
    var button = $("#update-statuses");
    switch (state){
      case "loading":
        button.button("loading");
        break;
      case "error":
        button.text("エラー");
        break;
      case "finished":
        button.text("更新完了");
        break;
    }
  },
  showLoader: function(){
    AjaxStatus.TweetsWrapper().find(".loader").fadeIn();
  },
  hideLoader: function(){
    AjaxStatus.TweetsWrapper().find(".loader").fadeOut();
  },
  TweetsWrapper: function(){
    if(AjaxStatus.handleWithSp){
      return $("#wrap-setting-lower").find(".tweets");
    }else{
      return $("#wrap-setting").find(".tweets");
    }
  }
};
