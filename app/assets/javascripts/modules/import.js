var Import = {
  bindClickEventOrCheckProgress: function(){
    if($('#working-job-exists').val() === 'true'){
      $("#start-import").button('loading');
      Import.showLoader("#wrap-import");
      $(".wrap-progress-bar").fadeIn(function(){
        // show the area displaying the status body currently saving
        $("#status").fadeIn();
      });
      Import.checkImportProgress();
    }else{
      Import.bindClickEvent();
    }
  },
  bindClickEvent: function(){
    var wrap_progress_bar = $(".wrap-progress-bar");
    var import_button = $("#start-import");
    //click event activated when start button is clicked
    import_button.click(function(){
      import_button.button('loading');
      Import.showLoader("#wrap-import");
      /// show the progress bar
      wrap_progress_bar.fadeIn(function(){
        // show the area displaying the status body currently saving
        $("#status").fadeIn();
      });
      Import.startImport();
      Import.checkImportProgress();
    });
  },
  showLoader: function(parentName){
    var type = typeof(parentName);
    if(type == "string"){
      $(parentName).find(".loader").fadeIn();
    }else if(type == "object"){
      parentName.find(".loader").fadeIn();
    }
  },
  startImport: function(){
    $.ajax({
      url: "/ajax/make_initial_import",
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
          return Import.checkImportProgressWithInterval();
        }
        Import.updateCount(response.count);
        Import.updateProgressBar(response.count);
        Import.updateTweetTextAndDate(response.tweet_text, response.tweet_date);
        if(response.finished){
          $(".wrap-progress-bar").find(".bar").html("complete!");
          var import_button = $("#start-import");
          import_button.addClass('disabled');
          import_button.text(response.count + "件取得しました");
          // stop animation
          $(".progress").removeClass("active");
          SharedFunctions.hideLoader("#wrap-import");
          setTimeout(function(){
            location.href = "/user_timeline";
          }, 2000);
        }else{
          Import.checkImportProgressWithInterval();
        }
      },
      error: function(){
        $(".progress").removeClass("active");
        SharedFunctions.hideLoader("#wrap-import");
        $(".wrap-progress-bar").fadeOut(function(){
          $(".wrap-lower").html("<div class=\"alert alert-warning\"><p>サーバーが混み合っているようです。<br/>しばらくしてからもう一度お試しください。</p></div>");
          $("#start-import").text("...oops");
        });
      }
    });
  },
  updateCount: function(count){
    var delimitedCount = SharedFunctions.numberWithDelimiter(count);
    $(".wrap-progress-bar").find(".total").find(".num").text(delimitedCount);
  },
  updateProgressBar: function(count){
    var expectedTotalImportCount = parseInt($("#expected-total-import-count").val());
    var progress = (count / expectedTotalImportCount) * 100;
    $(".progress").find(".bar").css("width", progress + "%");
  },
  updateTweetTextAndDate: function(text, date){
    var wrap_importing_status = $(".wrap-importing-status")
    wrap_importing_status.fadeOut(function(){
      $(".wrap-tweet").find(".body").html(text);
      $(".wrap-tweet").find(".date").html(date);
    });
    wrap_importing_status.fadeIn();
  },
  checkImportProgressWithInterval: function(){
    setTimeout(function(){
      Import.checkImportProgress();
    }, 2000);
  }
};
