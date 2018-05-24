var TermSelector = {
  handleWithSp: false,

  fetchTermSelector: function(){
    /**
     * acquires html code for term selector and insert it to the html
     */
    // check if term selector should be requested
    if( $("#wrap-timeline-lower").size() == 0 ) return;

    // check if term selector already exists
    if( $("#wrap-term-selectors").size() > 0 ) return;

    var elmWholeWrapper = $("#wrap-term-selector");
    // show the loading icon
    elmWholeWrapper.html("<img src=\"/assets/ajax-loader.gif\" alt=\"読込中\" />");

    var actionType = this.getTermSelectorType();

    var sendData = {
      action_type:actionType
    };

    var elmErrorHtml = $(document.createElement("div")).html("<p>日付ナビゲーションの生成に失敗しました。<br/>画面をリロードして下さい。");
    $.ajax({

      url:'/ajax/term_selector',
      type:'get',
      data:sendData,
      dataType:'html',
      success:function(res){

        if(res){
          elmWholeWrapper.html(res);
        }else{
          elmWholeWrapper.html(elmErrorHtml);
        }
      },
      error:function(){
      },
      complete: function(){
        TermSelector.bindEvents();
      }
    });
  },
  bindEvents: function(){
    this.MouseoverEvent.onYearSelectors();
    this.MouseoverEvent.onMonthSelectors();
    this.ClickEvent.fetchStatuses();
    this.ClickEvent.controlButtonState();
  },
  getTermSelectorType: function(){
    var ret = $("#wrap-term-selector").data('type');
    if(!ret){
      return false;
    }
    return ret;
  },
  MouseoverEvent: {
    onYearSelectors: function(){
      // mouseover action for year list in term selector
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
        $("#wrap-list-months").find(".date-"+year).css('display','block');

      });
    },
    onMonthSelectors: function(){
      // mouseover action for months list in term selector
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
        $("#wrap-list-days").find(".date-"+month).css('display','block');

      });
    }
  },

  ClickEvent: {
    fetchStatuses: function(){
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

          var action_type = SharedFunctions.detectActionType(path);

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
              if(!this.handleWithSp) SharedFunctions.scrollToPageTop(e);
              // show the loaded html
              $("#wrap-main").fadeIn('fast');
              // let the button say that process has been done
              $("#wrap-term-selectors").find("a").button('complete');
              // record requested url in the history
              window.history.pushState(null,null,href);
              // update page title
              PageTitle.updateByDateAndAction(date,action_type);
            }
          });
        });
      }
    },
    controlButtonState: function(){
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
    }
  }
};
