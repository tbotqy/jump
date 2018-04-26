$(function(){
  var wrap_progress_bar = $(".wrap-progress-bar");
  var import_button = $("#start-import");

  //click event activated when start button is clicked
  import_button.click(function(){

    import_button.button('loading');

    showLoader("#wrap-import");

    /// show the progress bar
    wrap_progress_bar.fadeIn(function(){
      // show the area displaying the status body currently saving
      $("#status").fadeIn();
    });

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

  function showLoader(parentName){
    var type = typeof(parentName);

    if(type == "string"){
      $(parentName).find(".loader").fadeIn();
    }else if(type == "object"){
      parentName.find(".loader").fadeIn();
    }
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

            SharedFunctions.hideLoader("#wrap-import");
          }
        }
      },
      error: function(){
        //show the error message
        $(".progress").removeClass("active");
        SharedFunctions.hideLoader("#wrap-import");

        $(".wrap-progress-bar").fadeOut(function(){
          $(".wrap-lower").html("<div class=\"alert alert-warning\"><p>サーバーが混み合っているようです。<br/>すみませんが、しばらくしてからもう一度お試しください。</p></div>");
          $("#start-import").text("...oops");
        });
      },
      complete: function(){
        if(noStatusAtAll){
          SharedFunctions.hideLoader("#wrap-import");
        }else{
          // animate progress bar
          setProgress(progress);

          $(".wrap-importing-status").fadeIn();
        }

        if(progress == 100){
          // when done, redirect after 2 seconds
          setTimeout(function(){
            location.href = "/your/tweets";
          }, 2000);
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
});
