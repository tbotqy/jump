var PageTitle = {
  updateByDateAndAction: function(dateWithHyphen,actionType){
    var title = "";
    var baseTitle = "";
    var dateInJapanese = this.convertDateToJapanese(dateWithHyphen);
    var name  = this.getTimelineOwnerName();
    var serviceName = "TwitJump";
    switch(actionType){
    case "tweets":
      baseTitle = " " + name +" さんのツイート";
      break;
    case "home_timeline":
      baseTitle = " " + name + " さんのホームタイムライン";
      break;
    case "public_timeline":
      baseTitle = "パブリックタイムライン";
      break;
    }

    // concatenate service name to base title
    baseTitle += " - "+serviceName;

    if(!dateInJapanese){
      title = baseTitle;
    }else{
      // concatenate date string to the head of baseTitle
      title = dateInJapanese+"の"+baseTitle;
    }

    // update page title
    $("title").text(title);
  },
  convertDateToJapanese: function(dateWithHyphen){
    // convert given date to 年月日
    if(!dateWithHyphen || dateWithHyphen == "notSpecified") return false;

    var ret = "";
    dateWithHyphen.split(/-/).forEach(function(date,index){
      switch(index){
        case 0:
        ret += date+"年";
        break;
        case 1:
        ret += date+"月";
        break;
        case 2:
        ret += date+"日";
        break;
      }
    });
    return ret;
  },
  getTimelineOwnerName: function(){
    // returns the string of name(@screen_name)
    var name = $(':hidden[name="timeline-owner-name"]').val() || "Hey!";
    var screen_name = $(':hidden[name="timeline-owner-screen-name"]').val() || "Hoo!";
    return name+"(@"+screen_name+")";
  }
};
