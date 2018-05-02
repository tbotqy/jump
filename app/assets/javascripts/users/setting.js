$(function(){
  $("#update-profile").click(function(){
    var self = $(this);
    // change the button's statement
    self.button('loading');

    // show the loading icon
    self.after("<img class=\"loader\" src=\"/assets/ajax-loader.gif\" />");
    $(".wrap-profile").find(".loader").fadeIn();

    checkProfileUpdate();

  });

  $("#update-statuses").click(function(){
    var self = $(this);
    // change the button's statement
    self.button('loading');

    // show the loading icon
    self.after("<img class=\"loader\" src=\"/assets/ajax-loader.gif\" />");
    $(".tweets").find(".loader").fadeIn();

    checkStatusUpdate();

  });

  $("#update-friends").click(function(){
    var self = $(this);

    // change the button's statement
    self.button('loading');

    // show the loading icon
    self.after("<img class=\"loader\" src=\"/assets/ajax-loader.gif\" />");
    $(".friends").find(".loader").fadeIn();

    checkFriendUpdate();

  });

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
      $(this).html("処理中...<img src=\"/assets/ajax-loader.gif\" class=\"loader\" />");
    })
    .fadeIn();

    $.ajax({

      url: '/ajax/deactivate_account',
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
              location.href = "/logout";
            }, 3000
          );
        }else{
          alert("処理がうまくいきませんでした。");
        }
      }
    });
  });

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

        SharedFunctions.hideLoader(".wrap-profile");

        var complete_text = updated ? "更新完了" : "処理終了";

        $("#update-profile").text(complete_text);

        var alert_type = updated ? "alert-success" : "alert-info";
        var alert_text = updated ? "更新しました" : "変更はありません";
        wrap_profile.find(".area-result .alert").addClass(alert_type).text(alert_text).fadeIn();
      },

      error: function(){

        wrap_profile.find(".area-result .alert").addClass("alert-danger").text("もう一度お試しください").fadeIn();

        $("#update-profile").text("エラー");
        SharedFunctions.hideLoader(".wrap-profile");
      }
    });
  }

  function checkStatusUpdate(){
    /**
     * check if there is any tweets not yet to have imported
     */

    var doUpdate = false;
    var updated_date = "";
    var box_tweets =$("#wrap-setting").find(".tweets");

    $.ajax({
      url:"/ajax/check_status_update",
      type:"post",
      dataType:"json",

      success: function(responce){
        if(responce.do_update){
          updateStatus();
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
  }

  function checkFriendUpdate(){
    /**
     * checks if there is any new friend on twitter
     */

    var count;
    var updated;
    var updated_date;
    var area_friends = $("#wrap-setting").find(".friends");

    $.ajax({
      url: "/ajax/check_friend_update",
      type: "post",
      dataType: "json",

      success: function(responce){
        count = responce.friends_count;
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
        SharedFunctions.hideLoader(".friends");
      }
    });
  }

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

  var total_count = 0;
  var oldest_id_str = "";
  var continue_process = "";
  var updated_date = "";

  function updateStatus(){
    var area_tweets = $("#wrap-setting").find(".tweets");
    var update_button = $("#update-statuses");

    $.ajax({
      url:"/ajax/update_status",
      type:"post",
      dataType:"json",
      data:{"oldest_id_str":oldest_id_str},

      success: function(responce){
        continue_process = responce.continue;
        updated_date = responce.updated_date;

        if(continue_process){
          total_count += responce.saved_count;
          oldest_id_str = responce.oldest_id_str;

          // show the total number of statuses that have been imported so far
          area_tweets.find(".additional-num").fadeOut(function(){
            $(this).text("+ "+total_count);
          }).fadeIn();

          updateStatus();
        }else{
          total_count += responce.saved_count;

          var final_total = 0;
          var current_num = parseInt(num_without_delimiter($(".tweets").find(".count .total-num").text()));

          final_total = current_num + parseInt(total_count);

          area_tweets.find(".total-num").fadeOut(function(){
            $(this).text(num_with_delimiter(final_total)).fadeIn();
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
  }

  function num_with_delimiter(num){
    return String(num).replace( /(\d)(?=(\d\d\d)+(?!\d))/g, '$1,');
  }

  function num_without_delimiter(num){
    return String(num).split(",").join("");
  }
});
