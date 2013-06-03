$(function () {

  showGraph("months");

  $("#show-months").click(function(){

    showGraph("months");
    
  });

  $("#show-days").click(function(){

    showGraph("days");
    
  });

  function showGraph(type){

    var graphArea = $('#container-graph');
    var graphTitle = type == "months" ? "共有ツイート数の推移[月]" : "共有ツイート数の推移[日]";
    var dataX,dataY;
    
    $.ajax({
      
      url:"/ajax/get_graph_data",
      type:"get",
      dataType:"json",
      data:{type:type},
      success:function(res){
  
        graphArea.highcharts({
          title: {
            text: graphTitle
          },
          xAxis: {
            allowDecimals:false,
            categories: res.dataX
          },
          yAxis:{
            title:{
                text:"ツイート数",
            },
            min:-10
          },
          series: [{
            data: res.dataY,
            name: '累積ツイート数'
          }]
        });
        
      }

    });
    
  }


});