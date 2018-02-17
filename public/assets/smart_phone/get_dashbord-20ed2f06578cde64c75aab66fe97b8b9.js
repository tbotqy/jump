$(function(){

  /**
   * acquires html code for dashbord and insert it to the html
   */
  // check if dashbord should be requested
  if( $("#wrap-timeline-lower").size() == 0 ) return;

  // check if dashbord already exists
  if( $("#wrap-term-selectors").size() > 0 ) return;

  var elmWholeWrapper = $("#wrap-dashbord");
  // show the loading icon
  elmWholeWrapper.html("<img src=\"/assets/ajax-loader.gif\" alt=\"読込中\" />");

  var actionType = getDashbordType();

  var sendData = {
    action_type:actionType
  };

  var elmErrorHtml = $(document.createElement("div")).html("<p>日付ナビゲーションの生成に失敗しました。<br/>画面をリロードして下さい。");
  $.ajax({

    url:'/ajax/get_dashbord',
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
    }

  });

});
