$(function(){
  var deleted = "";
  // click event to delete account
  $("#delete-account").click(function(){
    var wrapDeleteAccount = $("#wrap-delete-account");

    $(this).button('loading');

    wrapDeleteAccount
      .find(".status")
      .fadeOut(function(){
      $(this).html("<span class=\"now\">処理中...</span><img src=\"/assets/ajax-loader.gif\" class=\"loader\" /> ");
      })
      .fadeIn();

    $.ajax({
      url: '/ajax/deactivate_account',
      type: 'post',
      dataType: 'json',

      success: function(res){
        deleted = res.deleted;
        SharedFunctions.showDeleteCompleteMessage(res.deleted, false);
      },

      error: function(){
        alert("処理が完了しませんでした。");
      },

      complete: function(){
        if(deleted){

          setTimeout(
              function(){
                    SharedFunctions.redirectToLogout();
              }, 3000
            );

        }else{
          alert("処理がうまくいきませんでした。");
        }
      }
    });
  });
});
