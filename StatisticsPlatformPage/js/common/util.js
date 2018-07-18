
//var host="http://172.26.59.239:8090";
var host="http://localhost:8090";
var contextPath="/StatisticsPlatform";
var baseURL=host+contextPath;

function isEmpty(strVal) {
	if (strVal == undefined || strVal == null || strVal == '') {
		return true;
	} else {
		return false;
	}
}
function refresh(){//刷新时触发
	var historyHref=$("#iframeContent").attr("src");
	if(!isEmpty(historyHref)&&historyHref!="null"){
		setCookie("url",historyHref,null,"/");//记录到cookie
	}
}


 function jsonpAjax(url, param,async,callback) {
    $.ajax({  
        type: "post",  
        url: baseURL+url,
        data: param,  
        async:async,
        dataType: "jsonp",
        timeout:20000,
        jsonp:"callback",
        xhrFields: {
            withCredentials: true
        },
        crossDomain: true,
        beforeSend:function(){
        	showLoading();
        },
        success:function(data){
        	data=$.parseJSON(data);
        	if(!data.flag){
        		layer.alert(data.message);
        		return false;
        	}
        	callback(data);
        },
        error: function (status) {  
                layer.alert(status);
        } ,
        complete:function(){
        	showLoading();
        }
    });  
}  
  


function showMask(){
	$("#timeout").show();
}

$(function(){
	//注销
	$("#logout").click(function(){
		layer.confirm('确认退出？',{btn:['确认','取消']},function(){
			$.ajax({
				url:baseURL+"/logout",
				dataType:"jsonp",
				jsonp:"callback",
				async:false,
				complete:function(){
					window.location.href="login.jsp";
				}
			})
		},function(){
		})
	});
	
	var cont='<div id="timeout" style="display:none;">';
	cont+='<div class="mask"></div>';
	cont+='<div class="yic">';
	cont+='<p class="f5">噢～网络异常</p>';
	cont+='<p class="f4">请检查您的网络连接是否正常</p>';
	cont+='<a href="#" class="btn4" id="quit">退出</a>';
	cont+='</div></div>';
	$(".wrap").append(cont);
	
	$(document).on("click","#timeout",function(){
		history.back();
	})
	
});

function setHeight(){
	 var height=$("body").height();
	 var iframe=$("#iframeContent",window.parent.document);
	 $(iframe).height(height+50);
}

function showLoading(){
	if($("#loading").is(":hidden")){
		$("#loading").show();
	}else{
		$("#loading").hide();
	}
}

//去掉字符串头尾空格   
function trim(str) {   
    return str.replace(/(^\s*)|(\s*$)/g, "");   
} 



var Wi = [ 7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2, 1 ];// 加权因子   
var ValideCode = [ 1, 0, 10, 9, 8, 7, 6, 5, 4, 3, 2 ];// 身份证验证位值.10代表X   
function IdCardValidate(idCard) {   
    idCard = trim(idCard.replace(/ /g, ""));   
    if (idCard.length == 15) {   
        return isValidityBrithBy15IdCard(idCard);   
    } else if (idCard.length == 18) {   
        var a_idCard = idCard.split("");// 得到身份证数组   
        if(isValidityBrithBy18IdCard(idCard)&&isTrueValidateCodeBy18IdCard(a_idCard)){   
            return true;   
        }else {   
            return false;   
        }   
    } else {   
        return false;   
    }   
}   

function isValidityBrithBy15IdCard(idCard15){   
    var year =  idCard15.substring(6,8);   
    var month = idCard15.substring(8,10);   
    var day = idCard15.substring(10,12);   
    var temp_date = new Date(year,parseFloat(month)-1,parseFloat(day));   
    // 对于老身份证中的你年龄则不需考虑千年虫问题而使用getYear()方法   
    if(temp_date.getYear()!=parseFloat(year)   
            ||temp_date.getMonth()!=parseFloat(month)-1   
            ||temp_date.getDate()!=parseFloat(day)){   
              return false;   
      }else{   
          return true;   
      }   
}   

function isValidityBrithBy18IdCard(idCard18){   
    var year =  idCard18.substring(6,10);   
    var month = idCard18.substring(10,12);   
    var day = idCard18.substring(12,14);   
    var temp_date = new Date(year,parseFloat(month)-1,parseFloat(day));   
    // 这里用getFullYear()获取年份，避免千年虫问题   
    if(temp_date.getFullYear()!=parseFloat(year)   
          ||temp_date.getMonth()!=parseFloat(month)-1   
          ||temp_date.getDate()!=parseFloat(day)){   
            return false;   
    }else{   
        return true;   
    }   
}   

function isTrueValidateCodeBy18IdCard(a_idCard) {   
    var sum = 0; // 声明加权求和变量   
    if (a_idCard[17].toLowerCase() == 'x') {   
        a_idCard[17] = 10;// 将最后位为x的验证码替换为10方便后续操作   
    }   
    for ( var i = 0; i < 17; i++) {   
        sum += Wi[i] * a_idCard[i];// 加权求和   
    }   
    valCodePosition = sum % 11;// 得到验证码所位置   
    if (a_idCard[17] == ValideCode[valCodePosition]) {   
        return true;   
    } else {   
        return false;   
    }   
}   

function setCookie(c_name,value,expiredays,path){
	var exdate=new Date();
	exdate.setDate(exdate.getDate()+expiredays);
	document.cookie=c_name+ "=" +escape(value)+
		((expiredays==null) ? "" : ";expires="+exdate.toGMTString())+
		((path==null) ? "" : ";path="+path);
}

function getCookie(c_name) {
if (document.cookie.length>0) {
  c_start=document.cookie.indexOf(c_name + "=");
  if (c_start!=-1) { 
    c_start=c_start + c_name.length+1 ;
    c_end=document.cookie.indexOf(";",c_start);
    if (c_end==-1) {
    	c_end=document.cookie.length;
    }
    return unescape(document.cookie.substring(c_start,c_end));
    } 
  }
return ""
}