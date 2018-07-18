<%@ page language="java" session="false" import="java.util.*" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

    <%@include file="common.jsp"%>

</head>


<script type="text/javascript">

    var id="<%=request.getParameter("id")%>";

    $(function(){

        menuPosition(3,'20161220170303218319');

        loadmenus();

        if(id=="null"){
            id="";
        }

        $("#form").submit(function(){
            var status=$("#status option:selected").val();
            var groupName=$("#groupName").val();
            var desc=$("#desc").val();
            var ids=[];//运行操作的菜单的ID
            $(".mi").each(function(){
                ids.push($(this).attr("val"));//最上级菜单的ID
            });
            $("#ma input[type='checkbox']:checked").each(function(i,r){
                ids.push($(r).attr("val"));//被选中的菜单ID
                var val=$(r).parents(".cmi").attr("val");//被选中的菜单的父级菜单ID
                ids.push(val);
            });
            $(this).ajaxSubmit({
                url:baseURL+"/roleGroup/save",
                type:"post",
                dataType:"jsonp",
                jsonp:"callback",
                timeout:30*1000,
                async:false,
                data:{"groupName":groupName,"descrip":desc,"isDisable":status,"id":id,"ids":ids},
                success:function(data){
                    data=$.parseJSON(data);
                    if(data.flag){
                        layer.alert("修改成功，配置将在重新登陆后生效",function(){
                            window.location.href="rolelist.jsp";
                        });
                    }else{
                        layer.alert(data.message);
                        return false;
                    }
                    return false;
                }
            });
            return false;
        })
    });

    function toSubmit(){
        $("#form").submit();
    }

    function loadmenus(){
        jsonpAjax("/roleMenu/getlist","",false,function(data){
            if(data.flag){
                var result=data.result.list;
                for(var i=0;i<result.length;i++){
                    var cont='';
                    var menu=result[i];
                    cont+='<div val="'+menu.id+'" class="mi">';//最上级菜单的div
                    for(var j=0;j<menu.childMenus.length;j++){
                        var cm=menu.childMenus[j];
                        var ccm=cm.childMenus;
                        if(ccm.length>0){//如果有子菜单就填充子菜单
                            cont+='<dl val="'+cm.id+'" class="gne cmi">';//第二级菜单
                            cont+='<dt>'+cm.menuName+'</dt>';
                            for(var k=0;k<ccm.length;k++){
                                cont+='<dd><input class="cb" type="checkbox" val="'+ccm[k].id+'" >'+ccm[k].menuName+'</dd>';//第三级菜单
                            }
                            cont+='</dl>';
                        }else{//如果没有子菜单把自己作为子菜单填充进去
                            cont+='<dl class="gne cmi">';
                            cont+='<dt>'+cm.menuName+'</dt>';
                            cont+='<dd><input class="cb" type="checkbox" val="'+cm.id+'" >'+cm.menuName+'</dd>';
                        }
                    }
                    cont+='</div>';
                    $("#ma").append(cont);
                }

                if(isEmpty(id)){
                    $(".cb").attr("checked",true);
                }else{
                    jsonpAjax("/roleGroup/get/"+id,"",false,function(data){
                        if(data.flag){
                            var obj=data.result;
                            $("#groupName").val(obj.groupName);
                            $("#desc").val(obj.descrip);
                            $("#status option").each(function(i,r){
                                if(obj.isDisable==$(r).val()){
                                    $(r).prop("selected","true");
                                }
                            });
                            var menus=obj.menu;
                            $.each(menus, function(i,r) {
                                var $t=$(".right input[val='"+r.id+"']");
                                $t.prop("checked","true");
                            });
                        }
                    })
                }
            }
        });
    }



</script>


<body>
<%@include file="head.jsp"%>
<%@include file="left.jsp"%>
<div class="right">
    <div class="shuju">
        <form action="" id="form" method="post" name="form1">
            <table class="search-tab">
                <tbody>
                <tr>
                    <th width="70" valign="top">用户组</th>
                    <td><input type="text" required id="groupName" class="inp w160"></td>
                </tr>
                <tr>
                    <th width="70" valign="top">状态</th>
                    <td><select class="slc w100" id="status">
                        <option value="0" selected="selected">有效</option>
                        <option value="1">禁用</option>
                    </select></td>
                </tr>
                <tr>
                    <th width="70" valign="top">备注</th>
                    <td><textarea required class="tare" id="desc"></textarea> </td>
                </tr>
                <tr>
                    <th width="70" valign="top">可用功能</th>
                    <td id="ma">

                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        <a href="javascript:void(0)" onclick="toSubmit()" class="btn4">保存</a>
                        <a href="javascript:document.form1.reset();" class="btn4">取消</a>
                    </td>
                </tr>
                </tbody>
            </table>
        </form>
    </div>
</div>
<%@include file="foot.jsp"%>
</body>


</html>