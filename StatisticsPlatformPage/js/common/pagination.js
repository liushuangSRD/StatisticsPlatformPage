

	function pagination(division,func,currentPageNo,pageSize,totalNumber){
		var totalPage=~~(totalNumber/pageSize);
		if(totalPage<1){
			totalPage=1;
		}
		if(totalNumber<=pageSize){
			totalPage=1;
		}else if(totalNumber%pageSize!=0){
			totalPage++;
		}
		
		var cont=paginationHTML(currentPageNo,totalPage,func);
		$("#"+division+"").html(cont);		
	}
	
	function paginationHTML(currentPageNo,totalPage,func){

		var cont='<div class="page fr">';
		cont+='<a href="javascript:void(0)" onclick="'+getPageFunc(1,func)+'">首页</a>';
		if(currentPageNo==1){
			cont+='<a href="javascript:void(0)" onclick="layer.msg(\'已经是第一页了\')">上一页</a>';
		}else{
			var f=getPageFunc(currentPageNo-1,func);
			cont+='<a href="javascript:void(0)" onclick="'+f+'">上一页</a>';
		}
		
		var firstP=currentPageNo-3;
		firstP=firstP<0?1:firstP;
		var lastP=currentPageNo+3;
		lastP=lastP>=totalPage?totalPage:lastP;
		for(var i=firstP;i<=lastP;i++){
			var f=getPageFunc(i,func);
			var cur="";
			if(i==currentPageNo){
				cur='class="cur"';
			}
			cont+='<a href="javascript:void(0)" onclick="'+f+'" '+cur+'>'+i+'</a>';
		}
		if(lastP<=totalPage-1){
			cont+='<a href="javascript:void(0)">...</a>';
			cont+='<a href="javascript:void(0)" onclick="'+getPageFunc(totalPage,func)+'">'+totalPage+'</a>';
		}
		
		if(currentPageNo==totalPage){
			cont+='<a href="javascript:void(0)" onclick="layer.msg(\'已经是最后一页\')">下一页</a>';
		}else{
			var f=getPageFunc(currentPageNo+1,func);
			cont+='<a href="javascript:void(0)" onclick="'+f+'">下一页</a>';
		}
		var f=getPageFunc(totalPage,func);
		cont+='<a href="javascript:void(0)" onclick="'+f+'">末页</a>';
		cont+='</div>';
		return cont;
	}
	
	function getPageFunc(i,f){
		if(f.indexOf(")")==-1&&f.indexOf("(")==-1){
			f+="("+i+")";
		}else if(f.indexOf("(")-f.indexOf(")")==-1){
			f=f.substring(0,f.indexOf("(")-1)+"("+i+")";
		}
		return f;
	}