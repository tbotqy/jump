var GlobalHeader = {
  controlButtonState: function(){
    if( $("#link-timeline").size() > 0 ){
      // detect current page type and add active class to the button
      var elmLinkList = $("#link-timeline");
      var currentActionName = elmLinkList.data("current-action-name");
      elmLinkList.find("."+currentActionName).addClass("active");

      // make link active on it is clicked
      elmLinkList.on("click","li",function(e){
        if( $(this).hasClass("disabled") ){
          e.preventDefault();
        }else{
          elmLinkList.find("li").removeClass("active");
          $(this).addClass("active");
        }
      });
    }
  }
};
