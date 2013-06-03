$(function(){
  
  /**
   * acquires html code for dashbord and insert it to the html
   */

  var elmWholeWrapper = $("#wrap-dashbord");
  // show the loading icon
  elmWholeWrapper.html("<img src=\"/img/ajax-loader.gif\" alt=\"読込中\" />");

  var actionType = getDashbordType();

  var sendData = {
      actionType:actionType
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
        alert("");
        elmWholeWrapper.html(elmErrorHtml);
      }
    },
    error:function(){
    }

  });

});