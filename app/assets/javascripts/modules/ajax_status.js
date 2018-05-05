var AjaxStatus = {
  handleWithSp: false,

  bindClickEvent: function(){
    $("#update-statuses").click(function(){
      var self = $(this);
      // change the button's statement
      self.button('loading');

      // show the loading icon
      self.after("<img class=\"loader\" src=\"/assets/ajax-loader.gif\" />");
      $(".tweets").find(".loader").fadeIn();

      AjaxStatus.checkStatusUpdate();

    });
  },

  checkStatusUpdate: function(){
    /**
     * check if there is any tweets not yet to have imported
     */

    var doUpdate = false;
    var updated_date = "";
    var box_tweets = AjaxStatus.TweetsWrappter();

    $.ajax({
      url:"/ajax/check_status_update",
      type:"post",
      dataType:"json",

      success: function(responce){
        if(responce.do_update){
          AjaxStatus.updateStatus();
        }else{
          // change the view statements
          $("#update-statuses").text("処理終了");

          box_tweets.find(".loader").fadeOut();

          box_tweets.find(".additional-num").fadeOut(function(){
            $(this).addClass("alert alert-info").text("変更はありません");
          }).fadeIn();

          box_tweets.find(".last-update .date").fadeOut(function(){
            $(this).text(responce.checked_at);
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
  },

  totalCount: 0,
  oldestIdStr: "",
  continueProcess: "",
  updatedDate: "",

  updateStatus: function(){
    var area_tweets = AjaxStatus.TweetsWrappter();
    var update_button = $("#update-statuses");

    $.ajax({
      url:"/ajax/update_status",
      type:"post",
      dataType:"json",
      data:{"oldest_id_str": AjaxStatus.oldestIdStr},

      success: function(responce){
        AjaxStatus.continueProcess = responce.continue;
        AjaxStatus.updatedDate = responce.updated_date;

        if(AjaxStatus.continueProcess){
          console.log("t");
          AjaxStatus.totalCount += responce.saved_count;
          AjaxStatus.oldestIdStr = responce.oldest_id_str;

          // show the total number of statuses that have been imported so far
          area_tweets.find(".additional-num").fadeOut(function(){
            $(this).text("+ "+total_count);
          }).fadeIn();

          AjaxStatus.updateStatus();
        }else{
          var final_total = 0;
          var current_num = parseInt(AjaxStatus.numWithoutDelimiter($(".tweets").find(".count .total-num").text()));

          final_total = current_num + parseInt(AjaxStatus.totalCount);
          console.log(AjaxStatus.totalCount);

          area_tweets.find(".total-num").fadeOut(function(){
            $(this).text(AjaxStatus.numWithDelimiter(final_total)).fadeIn();
          });

          area_tweets.find(".additional-num").fadeOut(function(){
            $(this).addClass("alert alert-success").text(AjaxStatus.totalCount+"件追加");
          }).fadeIn();

          area_tweets.find(".last-update .date").fadeOut(function(){
            $(this).text(AjaxStatus.updatedDate);

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
        if(!AjaxStatus.continueProcess){
          // hide the loader
          $(".loader").fadeOut();
        }
      }
    });
  },

  TweetsWrappter: function(){
    if(AjaxStatus.handleWithSp){
      return $("#wrap-setting-lower").find(".tweets");
    }else{
      return $("#wrap-setting").find(".tweets");
    }
  },

  numWithDelimiter: function(num){
    return String(num).replace( /(\d)(?=(\d\d\d)+(?!\d))/g, '$1,');
  },

  numWithoutDelimiter: function(num){
    return String(num).split(",").join("");
  }
};
