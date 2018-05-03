$(function(){
  Popstate.handleWithSp = true;
  Popstate.bindEvent();
  TimelineNav.bindClickEvent();
  GlobalHeader.bindClickEventForDropdown();
  Dashbord.handleWithSp = true;
  Dashbord.fetchDashbord();
  TweetCard.bindClickEvents();
  ReadMore.handleWithSp = true;
  ReadMore.bindClickEvents();
});
