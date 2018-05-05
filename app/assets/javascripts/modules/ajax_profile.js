var AjaxProfile = {
  bindClickEvent: function(){
    $("#update-profile").click(function(){
      var self = $(this);
      // change the button's statement
      self.button('loading');

      // show the loading icon
      self.after("<img class=\"loader\" src=\"/assets/ajax-loader.gif\" />");
      $(".wrap-profile").find(".loader").fadeIn();

      AjaxProfile.checkProfileUpdate();

    });
  },

  checkProfileUpdate: function(){
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
};
