<%@ page language="java" session="false" import="java.util.*" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>

<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

    <%@include file="common.jsp" %>

    <title>用户列表</title>
</head>


<script type="text/javascript">

    var result;
    var pageSize=10;
    var totalNumber=0;

    $(function(){

        menuPosition(3,'20161220170738213812');

        init();
        loaddata("");

        $("#search-btn").click(function(){//搜索按钮
            var i=0;
            var data='';
            $("#conditions .inp").each(function(){
                if(!isEmpty($(this).val())){
                    if(i!=0){
                        data+="&";
                    }
                    data+=$(this).attr("id")+"="+$(this).val();
                }
                i++;
            });
            $("#conditions select").each(function(i,r){
                var v=$(r).find("option:selected").val();
                if(!isEmpty(v)){
                    data+="&"+$(r).attr("id")+"="+v;
                }
            })
            loaddata(data);
        })

    })


    function loaddata(data){
        jsonpAjax("/user/list",data,false,function(data){
            if(data.flag){
                if(data.result.length>0){
                    result=data.result;
                    totalNumber=result.length;
                    paginationData(1);
                }else{
                    layer.msg("没有结果");
                    $("#cont").html("<tr><td colspan='8' align='center'><h3>no result</h3></td></tr>");
                    $("#p").html("");
                }
            }else{
                layer.alert(data.message);
                return false;
            }
        })
    }

    function init(){
        $("#conditions input").val("");
        $("#conditions select option:eq(0)").prop("selected","true");
    }

    function getHTML(r){
        var cont="";
        cont+='<tr>';
        cont+='<td>'+r.workNumber+'</td>';
        cont+='<td>'+r.username+'</td>';
        cont+='<td>'+r.department+'</td>';
        cont+='<td>'+r.position+'</td>';
        cont+='<td>'+r.email+'</td>';
        cont+='<td>'+r.status+'</td>';
        cont+='<td>'+r.group.groupName+'</td>';
        cont+='<td><a href="userinfo.jsp?id='+r.id+'" class="btn3">修改</a></td>';
        cont+='</tr>';
        return cont;
    }


    function paginationData(pageNo){
        var start=(pageNo-1)*pageSize+1;
        var end=pageNo*pageSize;
        var cont="";
        for(var i=start;i<=end;i++){
            var r=result[i-1];
            cont+=getHTML(r);
            if(i==result.length){
                break;
            }
        }
        $("#cont").html(cont);
        var h=$(".right").height();
        if(h<650){
            $(".left").height(650);
        }else{
            $(".left").height(h+60);
        }

        pagination("p","paginationData",pageNo,pageSize,totalNumber);
    }

</script>



<body>
<%@include file="head.jsp"%>
<%@include file="left.jsp"%>
<div class="right">
    <div class="shuju">
        <h3>用户列表</h3>
        <form action="#" method="post">
            <table class="search-tab" id="conditions">
                <tbody>
                <tr>
                    <th width="30">工号</th>
                    <td><input type="text" id="workNumber" class="inp"></td>
                    <th width="30">部门</th>
                    <td><input type="text" id="department" class="inp"></td>
                    <th width="30">状态</th>
                    <td>
                        <select class="slc w100" id="status">
                            <option value="">全部</option>
                            <option value="0">在职</option>
                            <option value="1">休假</option>
                            <option value="2">离职</option>
                        </select>
                    </td>
                    <th width="30">姓名</th>
                    <td><input type="text" id="username" class="inp"></td>
                    <th width="30">职位</th>
                    <td colspan="3"><input type="text" id="position" class="inp"></td>
                </tr>
                <tr>
                    <td colspan="6">
                        <a href="javascript:void(0)" id="search-btn" class="btn4">搜索</a>
                        <a href="javascript:init()" class="btn4">重置</a>
                        <a href="userinfo.jsp" class="btn4">新增</a>
                    </td>
                </tr>
                </tbody>
            </table>
        </form>
        <table width="100%" border="0" cellspacing="0" class="tabl mgt20">
            <thead>
            <tr>
                <td width="10%">工号</td>
                <td width="10%">姓名</td>
                <td width="10%">部门</td>
                <td width="10%">职位</td>
                <td width="20%">邮箱</td>
                <td width="10%">状态</td>
                <td width="10%">用户组</td>
                <td width="10%">操作</td>
            </tr>
            </thead>
            <tbody id="cont">
            </tbody>
        </table>
        <div class="fye">每页显示&nbsp;&nbsp;<select class="slc w100" onchange="pageSizeChange(this)">
            <option value="10">10</option>
            <option value="50">50</option>
            <option value="100">100</option>
            <option value="200">200</option>
        </select>

            <div id="p"></div>
        </div>
    </div>
</div>
<%@include file="foot.jsp"%>
</body>

</html>