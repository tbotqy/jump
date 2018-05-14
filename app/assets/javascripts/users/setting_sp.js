$(function(){
  GlobalHeader.bindClickEventForDropdown();

  AjaxStatus.handleWithSp = true;
  AjaxStatus.bindClickEventOrCheckProgress();

  var modules = [AjaxFriend, AjaxProfile];
  modules.forEach(function(module){
    module.handleWithSp = true;
    module.bindClickEvent();
  });
});
