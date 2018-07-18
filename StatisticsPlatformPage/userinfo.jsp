<%@ page language="java" session="false" import="java.util.*" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

    <%@include file="common.jsp"%>

</head>

<script type="application/javascript">

    var id="<%=request.getParameter("id")%>";

    $(function(){

        menuPosition(3,'20161220170738213812');

        loadGroup();

        if(id=="null"){
            id="";
        }
        if(!isEmpty(id)){//修改
            $("#hid").val(id);
            $("#ptr").show();
            loaddata();
            $("#email").prop("disabled","true");
        }else{//添加
            $("#pwdtr").show();
            $("#pwdtr").append('<td><input type="password" id="password" required name="password" class="inp w160"></td>');
        }

        $("form").submit(function(){

            $(this).ajaxSubmit({
                url:baseURL+"/user/save",
                type:"post",
                async:false,
                timeout:30*1000,
                data:$(this).formSerialize(),
                dataType:"jsonp",
                jsonp:"callback",
                beforeSend:function(){
                    showLoading();
                },
                success:function(data){
                    data=$.parseJSON(data);
                    if(data.flag){
                        layer.alert("修改成功",function(){
                            window.location.href="userlist.jsp";
                        });
                    }else{
                        layer.alert(data.message);
                    }
                },
                complete:function(){
                    showLoading();
                }
            });
            return false;
        })


    });

    function loaddata(){

        jsonpAjax("/user/get/"+id,"",false,function(data){
            if(data.flag){
                var obj=data.result;
                $("#workNumber").val(obj.workNumber);
                $("#descrip").val(obj.descrip.replace(/<br>/ig,"\n"));
                $("#username").val(obj.username);
                $("#email").val(obj.email);
                $("#department").val(obj.department);
                $("#position").val(obj.position);
                $("#status option").each(function(i,r){
                    if($(r).val()==r.status){
                        $(r).prop("selected","true");
                    }
                });
                $("#grouplist option").each(function(i,r){
                    if($(r).val()==obj.group.id){
                        $(r).prop("selected","true");
                    }
                })
            }
        })

    }

    function loadGroup(){

        jsonpAjax("/roleGroup/list",{"status":0},false,function(data){
            if(data.flag){
                var cont="";
                $.each(data.result, function(i,r) {
                    cont+='<option value="'+r.id+'">'+r.groupName+'</option>';
                });
                $("#grouplist").html(cont);
            }
        })
    }

    function toSubmit(){
        $("form").submit();
    }

    function updateP(obj){
        var cont='<input type="password" id="password" required name="password" class="inp w160">';
        $(obj).parents("tr").find("th").text("输入新密码");
        $(obj).parent().html(cont);
    }

</script>




<body>
    <%@include file="head.jsp"%>
    <%@include file="left.jsp"%>
    <div class="right">
        <div class="shuju">
            <form  method="post" name="form1">
                <input type="hidden" id="hid" name="id" />
                <table class="search-tab">
                    <tbody>
                    <tr>
                        <th width="70">工号</th>
                        <td><input type="text" id="workNumber" required name="workNumber" class="inp w160"></td>
                    </tr>
                    <tr>
                        <th width="70">姓名</th>
                        <td><input type="text" id="username" required name="username" class="inp w160"></td>
                    </tr>
                    <tr>
                        <th width="70">邮箱</th>
                        <td><input type="text" id="email" required name="email" class="inp w160"></td>
                    </tr>
                    <tr>
                        <th width="70">部门</th>
                        <td><input type="text" id="department" required name="department" class="inp w160"></td>
                    </tr>
                    <tr>
                        <th width="70">职位</th>
                        <td><input type="text" id="position" required name="position" class="inp w160"></td>
                    </tr>
                    <tr id="pwdtr" style="display: none;">
                        <th width="70">密码</th>
                    </tr>
                    <tr>
                        <th width="70">用户组</th>
                        <td><select class="slc w100" name="groupId" required id="grouplist">

                        </select></td>
                    </tr>
                    <tr>
                        <th width="70">状态</th>
                        <td><select class="slc w100" name="status" id="status">
                            <option value="0" selected="selected">在职</option>
                            <option value="1">休假</option>
                            <option value="2">离职</option>
                        </select></td>
                    </tr>
                    <tr>
                        <th width="70" valign="top">备注</th>
                        <td><textarea class="tare" name="descrip" id="descrip"></textarea> </td>
                    </tr>
                    <tr id="ptr" style="display: none;">
                        <th></th>
                        <td><a href="javascript:void(0)" onclick="updateP(this)" style="color: blue; text-decoration: underline;">点击修改密码</a></td>
                    </tr>
                    <tr>
                        <td colspan="2"><a href="javascript:void(0)" onclick="toSubmit()" class="btn4">保存</a><a href="javascript:document.form1.reset();" class="btn4">取消</a></td>
                    </tr>
                    </tbody>
                </table>
            </form>
        </div>
    </div>
</div>
</body>
</html>