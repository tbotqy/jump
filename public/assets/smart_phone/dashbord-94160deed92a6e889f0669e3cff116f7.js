$(function(){$(".list-years").find("li").mouseover(function(){var t=$(this);$(".list-years").find("a").removeClass("btn-primary selected"),t.find("a").addClass("btn-primary selected"),$("#wrap-list-months").find("ul").css("display","none"),$("#wrap-list-days").find("ul").css("display","none");var a=t.attr("data-date");$("#wrap-list-months").find("."+a).css("display","block")}),$(".list-months").find("li").mouseover(function(){var t=$(this);$(".list-months").find("li").find("a").removeClass("btn-primary selected"),t.find("a").addClass("btn-primary selected"),$("#wrap-list-days").find("ul").css("display","none");var a=t.attr("data-date");$("#wrap-list-days").find("."+a).css("display","block")}),"pushState"in history&&$("#wrap-term-selectors").find("a").click(function(t){var a=$(this);t.preventDefault();var e=a.attr("href"),s=a.attr("data-date"),i=a.attr("data-date-type"),n=$("#wrap-timeline");n.html('<div class="cover"><span>Loading</span></div>');var r=n.find(".cover");r.css("height",200),r.animate({opacity:.8},200);var d=location.pathname,l=detectActionType(d);$.ajax({type:"GET",dataType:"html",url:"/ajax/switch_term",data:{date:s,date_type:i,action_type:l},success:function(t){$("#wrap-main").html(t)},error:function(){alert("\u8aad\u307f\u8fbc\u307f\u306b\u5931\u6557\u3057\u307e\u3057\u305f\u3002\u753b\u9762\u3092\u30ea\u30ed\u30fc\u30c9\u3057\u3066\u304f\u3060\u3055\u3044")},complete:function(){$("#wrap-main").fadeIn("fast"),$("#wrap-term-selectors").find("a").button("complete"),window.history.pushState(null,null,e),updatePageTitleForTimeline(s,l)}})}),$("#wrap-list-years").find("a").click(function(){$("#wrap-list-months").find(".selected").removeClass("selected btn-primary"),$("#wrap-list-days").find(".selected").removeClass("selected btn-primary"),$(this).addClass("selected btn-primary")}),$("#wrap-list-months").find("a").click(function(){$("#wrap-list-days").find(".selected").removeClass("selected btn-primary"),$(this).addClass("selected btn-primary")}),$("#wrap-list-days").find("a").click(function(){$("#wrap-list-days").find(".selected").removeClass("selected btn-primary"),$(this).addClass("selected btn-primary")})});