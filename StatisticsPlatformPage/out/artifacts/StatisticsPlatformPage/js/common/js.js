$(function(){
   "use strict";
    function rsiz(){
	var hh=$(document).height()-60,gd=$(window).height()-60;
	if(hh<gd){$(".left").css("height",gd);}else{
    $(".left").css("height",hh);}  
	}rsiz();
    $(window).resize(function() {rsiz();});
	$(".sjx li").click(function() {$(this).addClass("cur").siblings().removeClass("cur");});
	$(".subnav a").click(function() {$(this).addClass("cur").siblings().removeClass("cur");});
	function tab(id,id1){$(id+">a").click(function(){ var index=$(this).index();$(this).addClass("cur").siblings().removeClass("cur");$(id1+">li").eq(index).show().siblings().hide();});}
	tab(".tab1",".tab1x");
	$(".yc").click(function(){
		if(!$(this).hasClass("cur")){$(this).addClass("cur").find("a").html("展开筛选 ∨");$(".dls").hide(200);
		}else{$(this).removeClass("cur").find("a").html("隐藏筛选 ∧");$(".dls").show(200);}
	});
});