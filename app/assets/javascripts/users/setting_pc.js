$(function(){
  AjaxStatus.bindClickEvent();
  AjaxFriend.bindClickEvent();
  AjaxProfile.bindClickEvent();

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
        SharedFunctions.showDeleteCompleteMessage(res.deleted, true);
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
          alert("処理が完了しませんでした。");
        }
      }
    });
  });
});
