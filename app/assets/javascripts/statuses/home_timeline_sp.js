$(function(){
  Popstate.handleWithSp = true;
  Popstate.bindEvent();
  GlobalHeader.bindClickEventForDropdown();
  Dashbord.handleWithSp = true;
  Dashbord.fetchDashbord();
  TweetCard.bindClickEvents();
  ReadMore.bindClickEvents();
});
