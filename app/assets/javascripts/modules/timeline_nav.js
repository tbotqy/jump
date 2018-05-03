var TimelineNav = {
  bindClickEvent: function(){
    // detect current page type and add active class to the button
    var elmTimelineNav = $("#timeline-nav");
    var currentActionName = elmTimelineNav.data("current-action-name");
    elmTimelineNav.find("."+currentActionName).addClass("active");

    // make link active when it is clicked
    elmTimelineNav.on("click","a",function(e){
      if( $(this).is(":disabled") ){
        e.preventDefault();
      }else{
        elmTimelineNav.find("a").removeClass("active");
        $(this).addClass("active");
      }
    });
  }
};
