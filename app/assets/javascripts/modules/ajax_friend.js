var AjaxFriend = {
  handleWithSp: false,

  bindClickEvent: function(){
    $("#update-friends").click(function(){
      var self = $(this);

      // change the button's statement
      self.button('loading');

      // show the loading icon
      self.after("<img class=\"loader\" src=\"/assets/ajax-loader.gif\" />");
      $(".friends").find(".loader").fadeIn();

      AjaxFriend.checkFriendUpdate();

    });
  },

  checkFriendUpdate: function(){
    /**
     * checks if there is any new friend on twitter
     */

    var count;
    var updated;
    var updated_date;
    var area_friends = AjaxFriend.friendsWrapper().find(".friends");

    $.ajax({
      url: "/ajax/check_friend_update",
      type: "post",
      dataType: "json",

      success: function(responce){
        area_friends.find(".count .total-num").fadeOut(function(){
          $(this).text(responce.friends_count);
        }).fadeIn();

        area_friends.find(AjaxFriend.additionalNumClassStr()).fadeOut(function(){
          $(this).addClass("alert alert-success").text("更新しました");
        }).fadeIn();

        $("#update-friends").text("更新完了");

        area_friends.find(".last-update .date").fadeOut(function(){
          $(this).text(responce.updated_date);
        }).fadeIn();
      },

      error: function(){
        area_friends.find(AjaxFriend.additionalNumClassStr()).fadeOut(function(){
          $(this).addClass("alert alert-danger").text("もう一度お試しください");
        }).fadeIn();

        $("#update-friends").text("エラー");
      },

      complete: function(){
        // hide the loading icon
        SharedFunctions.hideLoader(".friends");
      }
    });
  },

  friendsWrapper: function(){
    if(AjaxFriend.handleWithSp){
      return $("#wrap-setting-lower");
    }else{
      return $("#wrap-setting");
    }
  },

  additionalNumClassStr: function(){
    if(AjaxFriend.handleWithSp){
      return ".additional-num";
    }else{
      return ".count .additional-num";
    }
  }
};
