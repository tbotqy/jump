$(function(){
  Popstate.bindEvent();
  GlobalHeader.controlButtonState();
  Dashbord.fetchDashbord();
  TweetCard.bindClickEvents();
  ReadMore.bindClickEvents();
});
