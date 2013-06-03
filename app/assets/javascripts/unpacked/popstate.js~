$(function(){

  /////////////////////////////
  // code for popstate event //
  /////////////////////////////

  if('pushState' in history){

    window.setTimeout(function(){
      $(window).bind("popstate",function(e){
        
        var white_list = ['tweets','home_timeline','public_timeline'];
        var path = location.pathname;
        
        var actionTypeOk = false;
        var slashCountOk = false;
        
        // check if requested action type is allowed to fire process on popstate
        for(var i=0;i<white_list.length;i++){
          
          if(countStr(path,white_list[i]) > 0){
            actionTypeOk = true;
            break;
          }
          
        }
        
        // check if displaying screen is showing error
        // [ToDo]
        
        // check if requested path contians 3 slashes
        /*
          if(countStr(path,"/") == 3){
          slashCountOk = true;
          }
        */    
        
        if( actionTypeOk ){
          var date;
          if(countStr(path,"/") < 3){
            date = "notSpecified";
          }else{
            date = detectDate(path);
          }
          
          var action_type = detectActionType(path);
          
          ajaxSwitchTerm(date,action_type,"pjax");
          
          // reset all the term selectors
          $("#wrap-term-selectors").find("a.selected").removeClass("btn-primary selected");
          
          console.log("popped");          

        }else{
          console.log("not popped");
        }
        
      });
    },1000);
    
  }
  
});