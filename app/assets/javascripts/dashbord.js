$(function(){

  ////////////////////////////////
  // code for elements/dashbord //
  ////////////////////////////////

  // mouseover action for year list in dashbord
  $(".list-years").find("li").mouseover(function(){
    var self = $(this);

    // normalize all the buttons for years
    $(".list-years").find("a").removeClass("btn-primary selected");
 
    // apply unique css feature only to focused button 
    self.find('a').addClass("btn-primary selected");
    
    // hide all the lists for months and days
    $("#wrap-list-months").find("ul").css('display','none');
    $("#wrap-list-days").find("ul").css('display','none');
    
    // get the data-date value in hovered button
    var year = self.attr('data-date');

    // show the months list whose class is equal to var year
    $("#wrap-list-months").find("."+year).css('display','block');
    
  });

  // mouseover action for months list in dashbord
  $(".list-months").find("li").mouseover(function(){
    var self = $(this);

    // normalize all the buttons for months
    $(".list-months").find("li").find("a").removeClass("btn-primary selected");
  
    // apply unique css feature only to focused button 
    self.find('a').addClass("btn-primary selected");

    // hide all the days lists
    $("#wrap-list-days").find("ul").css('display','none');

    // get the data-date value in hovered button 
    var month = self.attr('data-date');
    
    // show the days list whose class is equal to var month
    $("#wrap-list-days").find("."+month).css('display','block');
 
  });

  if('pushState' in history){

  // click action to change the term of statuses to show
  $("#wrap-term-selectors").find("a").click(function(e){
    var self = $(this);

    // prevent the page from reloading
    e.preventDefault();

    // get href attr in clicked button
    var href = self.attr('href');
    
    // acquire the date to fetch from clicked button
    var date = self.attr('data-date');
    var date_type = self.attr('data-date-type');

    // show the loading icon over the statuses area
    var wrap_timeline = $("#wrap-timeline");
 
    wrap_timeline.html("<div class=\"cover\"><span>Loading</span></div>");

    var cover = wrap_timeline.find('.cover');
 
    cover.css("height",200);
    
    cover.animate({
      opacity: 0.8
    },200);

    // check the type of data currently being shown
    var path = location.pathname;
    var action_type = detectActionType(path);
  
    // fetch statuses 
    $.ajax({
      type: 'GET',
      dataType: 'html',
      url:'/ajax/switch_term',
      data:{
        "date":date,
        "date_type":date_type,
        "action_type":action_type
      },
      success: function(responce){

      // insert recieved html
      $("#wrap-main").html(responce);
      },
      error: function(responce){
        alert("読み込みに失敗しました。画面をリロードしてください");
      },
      complete: function(){
          

        // scroll to top
        scrollToPageTop(e);

        // show the loaded html
        $("#wrap-main").fadeIn('fast');

        // let the button say that process has been done
        $("#wrap-term-selectors").find("a").button('complete');
        
        // record requested url in the histry
        window.history.pushState(null,null,href);
        
      }
    });
  });
      
  }

  // click event for year selector
  $("#wrap-list-years").find("a").click(function(){
    
    // normalize all the buttons labeled as day selector
    $("#wrap-list-months").find(".selected").removeClass("selected btn-primary");

    // normalize all the buttons labeled as day selector
    $("#wrap-list-days").find(".selected").removeClass("selected btn-primary");

    // make clicked button selected
    $(this).addClass("selected btn-primary");
    
  });

  // click event for month selector
  $("#wrap-list-months").find("a").click(function(){
    
    // normalize all the buttons labeled as day selector
    $("#wrap-list-days").find(".selected").removeClass("selected btn-primary");

    // make clicked button selected
    $(this).addClass("selected btn-primary");
    
  });

  // click event for day selector
  $("#wrap-list-days").find("a").click(function(){
    
    // normalize all the buttons labeled as day selector
    $("#wrap-list-days").find(".selected").removeClass("selected btn-primary");

    // make clicked button selected
    $(this).addClass("selected btn-primary");
    
  });


});