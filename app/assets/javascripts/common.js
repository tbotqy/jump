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

  var wrap_progress_bar = $(".wrap-progress-bar");
  var import_button = $("#start-import");

  //click event activated when start button is clicked
  import_button.click(function(){

    // change the button statement
    import_button.button('loading');

    // show the loader icon
    showLoader("#wrap-import");

    /// show the progress bar
    wrap_progress_bar.fadeIn(function(){

      // show the area displaying the status body currently saving
      $("#status").fadeIn();

    });

    //initialize data to post
    var data_to_post = {};

    // check if id_str_oldest is specified
    var specified_id_str_oldest = $("input[name=id-oldest]").val();
    if( specified_id_str_oldest != "false"){
      data_to_post.id_str_oldest = specified_id_str_oldest;
      $("#recover-msg").fadeOut();
    }else{
      data_to_post.id_str_oldest = "";
    }

    // post ajax request
    getStatuses(data_to_post);

  });

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
