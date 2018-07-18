<%@ page language="java" session="false" import="java.util.*" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>

    <%@include file="common.jsp" %>

</head>

<style>
   #cont tr{
       align:center;
   }

</style>

<script type="application/javascript">

    $(function(){

        menuPosition(3,'20161220170303218319');

        init();
        loadData('');

        $("#search-btn").click(function(){
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
            });
            loadData(data);
        })

    });

    function init(){
        $("#conditions input").val("");
        $("#conditions select option:eq(0)").prop("selected","true");
    }

    function loadData(data){
        $.ajax({
            url:baseURL+"/roleGroup/list",
            dataType:"jsonp",
            data:data,
            timeout:30*1000,
            async:false,
            jsonp:"callback",
            beforeSend:function(){
                showLoading();
            },
            success:function(data){
                data=$.parseJSON(data);
                if(data.flag){
                    if(data.result.length>0&&data.result[0]!=null){
                        var cont="";
                        $.each(data.result, function(i,r) {
                            cont+='<tr style="text-align: center">';
                            cont+='<td>'+r.groupName+'</td>';
                            cont+='<td>'+r.menuNameStr+'</td>';
                            if(r.isDisable==0){
                                cont+='<td>正常</td>';
                            }else{
                                cont+='<td>禁用</td>';
                            }
                            cont+='<td>'+r.descrip+'</td>';
                            cont+='<td align="center"><a href="roleinfo.jsp?id='+r.id+'" class="btn3">修改</a></td>';
                            cont+='</tr>';
                        });
                        $("#cont").html(cont);
                    }else{
                        layer.msg("没有结果");
                        $("#cont").html("<tr><td colspan='5' align='center'><h3>no result</h3></td></tr>");
                    }
                }

            },
            complete:function(){
                showLoading();
            }
        })
    }

</script>

<body>
<%@include file="head.jsp" %>
<%@include file="left.jsp" %>
<div class="right">
    <div class="shuju">
        <h3>定义角色</h3>
        <form action="#" method="post">
            <table class="search-tab">
                <tbody id="conditions">
                <tr>
                    <th width="45">用户组</th>
                    <td><input type="text" id="groupName" class="inp"></td>
                    <th width="60">可用功能</th>
                    <td><input type="text" id="operations" class="inp"></td>
                    <th width="45">状态</th>
                    <td><select id="status" class="slc w100">
                        <option value="" selected="selected">全部</option>
                        <option value="0">正常</option>
                        <option value="1">禁用</option>
                    </select></td>
                </tr>
                </tr>
                <tr>
                    <td colspan="6">
                        <a href="javascript:void(0)" id="search-btn" class="btn4 mr25">搜索</a>
                        <a href="roleinfo.jsp" class="btn4">新增</a>
                    </td>
                </tr>
                </tbody>
            </table>
        </form>
        <table width="100%" border="0" cellspacing="0" class="tabl mgt20">
            <thead>
            <tr align="center">
                <td width="10%" align="center">用户组</td>
                <td width="20%" align="center">可用功能</td>
                <td width="20%" align="center">状态</td>
                <td width="30%" align="center">备注</td>
                <td width="10%" align="center">操作</td>
            </tr>
            </thead>
            <tbody id="cont">
            </tbody>
        </table>
    </div>
</div>
<%@include file="foot.jsp"%>
</body>

</html>