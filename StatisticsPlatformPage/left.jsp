<%@ page language="java" session="false" import="java.util.*" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>

<script type="text/javascript">

    $(function(){

        //登出按钮
        $("#lo").click(function(){
            layer.confirm("确认登出？",{btn:["确认","取消"]},function () {
                jsonpAjax("/logout","",false,function(){});
                window.location.href="login.jsp";
            },function(){});
        })
    })




</script>

<div class="top">
    <div class="mingc fr"><img src="images/user.png" width="13" height="13" alt="" />${aaa}，欢迎你！
        <a href="#">修改密码</a>
        <a href="javascript:void(0)" id="lo">登出</a>
    </div>
    <img class="logo" src="images/logo.png" width="50" height="24" alt="" /> <span>沃橙统计平台</span>
    <div class="menu" id="topMenu">
    </div>
</div>

<div class="left">
</div>

</html>