$(function(){
  Popstate.bindEvent();
  GlobalHeader.controlButtonState();
  TermSelector.fetchTermSelector();
  TweetCard.bindClickEvents();
  ReadMore.bindClickEvents();
});
