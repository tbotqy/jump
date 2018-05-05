$(function(){
  var modules = [AjaxStatus, AjaxFriend, AjaxProfile];
  modules.forEach(function(module){
    module.handleWithSp = true;
    module.bindClickEvent();
  });
});
