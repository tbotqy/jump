$(function(){
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
        SharedFunctions.showDeleteCompleteMessage(res.deleted);
      },

      error: function(){
        showDeleteErrorMessage();
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
