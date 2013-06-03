$(function(){

  // admin screen
  var admin = $("#wrap-admin");
  
  // ----
  var footer = $("#container-footer");
  footer.css("position","relative");
 
  // show and hide the tables
  admin.on("click",".toggler",function(e){
    
    var self = $(this);
    e.preventDefault();

    var destContentType = self.data("dest-content-type");
    if(!destContentType) return;
    
    admin.find(".area-"+destContentType).find(".content").toggle();

  });
  
  // click event handler for the button to delete each single account
  admin.find(".delete-each").click(function(){
    var self = $(this);
    var parent = self.parent();

    // show the loader
    showLoader(parent);

    // check which user id does clicked button point
    var dest_id = self.data('dest-id');
    deleteHim(dest_id);
    
    
  });
                                  
  // click event handler for the button to delete selected accounts 
  admin.find("#delete-selected").click(function(){
    var self = $(this);
    var parent = self.parent();

    // show the loader
    showLoader(parent);
    
    // array to contain the destination ids
    var dest_id;
    
    var checked_buttons = admin.find("tbody tr .chk button.active");
  
    if(checked_buttons.length > 0){
        
      checked_buttons.each(function(i,element){
        
        dest_id = $(element).data("dest-id");
        
        deleteHim(dest_id);

      },hideLoader(parent));;

    }else{
      
      // no button is selected 
      alert("nothing is selected");
      hideLoader(".wrap-button");
    }

  });

});

function deleteHim(dest_id){
  
  var admin = $("#wrap-admin");

  $.ajax({
    url:"/ajax/delete_him",
    type:"post",
    data:{"dest_id":dest_id},
    dataType: "text",
    success: function(res){
      if(res == "NG"){
        
        alert("something went wrong with deleting account");
      }else{
        // hide the element of deleted account
        admin.find("tr[data-dest-id="+dest_id+"]").fadeOut();
      }
    },
    error: function(){

      alert("Ajax error");
    }
  });
}