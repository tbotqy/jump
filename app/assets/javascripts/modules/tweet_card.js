var TweetCard = {
  bindClickEvents: function(){
    this.hideAndShowBottonLine();
    this.deleteStatus();
  },
  hideAndShowBottonLine: function(){
    // click action to hide and show the bottom line in each status
    $("#wrap-timeline-lower").on("click",".status-content",function(e){
      // do process only if clicked element is not <a>
      var clicked = $(e.target);
      if(!clicked.is('a') && !clicked.is('i')){
        $(this).find(".bottom").slideToggle('fast');
      }
    });
  },
  deleteStatus: function(){
    // click action to fire a delete ajax action
    $("#wrap-timeline-lower").on("click",".status-content .link-delete a",function(e){
      e.preventDefault();
      if(confirm('ツイートを削除します。よろしいですか？')){
        var status_id_to_delete = $(this).parent().data('status-id');
        $.ajax({
          url: "/ajax/delete_status",
          type: "post",
          data:{"status_id_to_delete":status_id_to_delete},
          dataType: "json",
          success: function(responce){
            // checks if the status trying to deleted is owned by logging user
            if(responce.owns){
              // checks id delete process was correctly done
              if(responce.deleted){
                $("div[data-status-id="+status_id_to_delete+"]").fadeOut();
              }else{
                alert("ごめんなさい。削除に失敗しました。画面をリロードしてもう一度お試しください。");
              }
            }else{
              // the status trying to be deleted is not owned by logging user
              alert("不正な操作です。");
            }
          },
          error: function(){
            // internal error
            alert("エラーが発生しました。");
          }
        });
      }
    });
  }
};
