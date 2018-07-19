var menus;

function menuPosition(topIndex,menuId){
    $.ajax({
        url:baseURL+"/roleMenu/getUserMenus",
        type:"post",
        dataType:"jsonp",
        jsonp:"callback",
        success:function(data){
            data=$.parseJSON(data);
            if(data.flag){
                menus=data.result;
                var cont='';//上部菜单内容
                for(var i=0;i<menus.length;i++){
                    var m=menus[i];
                    if(m.childMenus.length==0){
                        cont+='<a href="'+m.menuURL+'" style="display: none;" onclick="loadLeftMenus('+i+')" class="tcm" id="'+m.id+'">'+m.menuName+'</a>';
                    }else{
                        cont+='<a href="'+m.menuURL+'" onclick="loadLeftMenus('+i+')" class="tcm" id="'+m.id+'">'+m.menuName+'</a>';
                    }
                }
                $("#topMenu").html(cont);

                $("#topMenu a").eq(topIndex-1).addClass("cur");
                loadLeftMenus(topIndex-1);
                if(isEmpty(menuId)||$("#"+menuId)==undefined){//如果id是空或者id的元素不存在，选择第一个
                    $(".left a:eq(0)").addClass("cur");
                }else{
                    addClass($("#"+menuId)[0]);
                }
            }else{
                layer.alert("加载菜单失败:"+data.message);
                return false;
            }
        }
    })
}

//点击左侧菜单之后变换样式
function addClass(a){
    $(".left a").removeClass("cur");
    $(a).addClass("cur");
    var p=$(a).parents(".pm");
    if($(a).hasClass("h3a")){//说明是父菜单,给第一个子菜单加上cur
        $(p).find(".next").eq(0).addClass("cur");
    }else{
        $(p).find(".h3a").addClass("cur");
    }
}

//加载左侧菜单
function loadLeftMenus(i){
    var cm=menus[i].childMenus;
    var cont='';
    for(var j=0;j<cm.length;j++){
        cont+='<div class="pm">';
        cont+='<h3><a href="'+cm[j].menuURL+'" id="'+cm[j].id+'" class="h3a"><i class="'+cm[j].css+'"></i>'+cm[j].menuName+'</a></h3>';
        var ccm=cm[j].childMenus;
        for(var k=0;k<ccm.length;k++){
            cont+='<a href="'+ccm[k].menuURL+'" id="'+ccm[k].id+'" class="next">'+ccm[k].menuName+'</a>';
        }
        cont+="</div>";
    }
    $(".left").html(cont);
}
