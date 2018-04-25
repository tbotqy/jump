var ReadMore = {
  bindClickEvents: function(){
    // click action for read more button
    $("#wrap-timeline-lower").on("click","#read-more",function(e){

      var self = $(this);

      e.preventDefault();
      var distance = self.offset().top;

      // let button say 'loading'
      self.button('loading');
      var elmOldestTweetId = $(".oldest-tweet-id");
      var oldestTweetId = elmOldestTweetId.val();
      // fetch more statuses to show
      $.ajax({

        type:"POST",
        dataType:"html",
        data:{
          "oldest_tweet_id":oldestTweetId,
          "destination_action_type":SharedFunctions.detectActionType(location.pathname)
        },
        url: '/ajax/read_more',
        success: function(responce){
          // remove the element representing last status's timestamp
          elmOldestTweetId.remove();
          $("#wrap-read-more").remove();

          // insert loaded html code
          $(".wrap-one-result:last").after(responce);
        },
        error: function(responce){
          alert("読み込みに失敗しました。");
        },
        complete: function(){
          scrollDownToDestination(e,distance);
        }
      });
    });
  }
};
