$(function(){
  Popstate.handleWithSp = true;
  Popstate.bindEvent();

  TimelineNav.bindClickEvent();

  GlobalHeader.bindClickEventForDropdown();

  TermSelector.handleWithSp = true;
  TermSelector.fetchTermSelector();

  TweetCard.bindClickEvents();

  ReadMore.handleWithSp = true;
  ReadMore.bindClickEvents();
});
