$(function(){
  Popstate.handleWithSp = true;
  Popstate.bindEvent();
  GlobalHeader.controlButtonState();
  Dashbord.handleWithSp = true;
  Dashbord.fetchDashbord();
  TweetCard.bindClickEvents();
  ReadMore.bindClickEvents();
});
