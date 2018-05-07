$(function(){
  // check user's timezone
  if (!$.cookie('timezone')){
    $.cookie('timezone', $("html").get_timezone(), {expires: 1});
  }

  // make loading social plugin delayed
  setTimeout(function(){
    facebook(document, 'script', 'facebook-jssdk');
  },3000);

  $.ajaxSetup({
    data:{"authenticity_token": $("meta[name=csrf-token]").attr("content")}
  });

  function facebook(d, s, id) {
    var js, fjs = d.getElementsByTagName(s)[0];
    if (d.getElementById(id)) return;
    js = d.createElement(s); js.id = id;
    js.src = "//connect.facebook.net/ja_JP/all.js#xfbml=1&appId=258025897640441";
    fjs.parentNode.insertBefore(js, fjs);
  }

  ///////////////////////////////////////////////
  // code for the button to scroll to page top //
  ///////////////////////////////////////////////

  $(window).scroll(function() {
    var topy = $(document).scrollTop();
    var elmToPageTop = $(".to-page-top");
    if (topy >= 200) {
      elmToPageTop.fadeIn();
    }else{
      elmToPageTop.fadeOut();
    }
  });

  $(".to-page-top").find("a").click (function(e) {
    SharedFunctions.scrollToPageTop(e);
  });

});
