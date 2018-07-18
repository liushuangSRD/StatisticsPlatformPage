<%@ page language="java" session="false" import="java.util.*" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>

<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

    <%@include file="common.jsp" %>

    <title>登录</title>
</head>
<script type="text/javascript">

    var desc="<%=request.getParameter("desc")%>";

    $(function(){

        if(!isEmpty(desc)&&desc!="null"){
            layer.alert(desc);
        }

        refreshCode();

        $("form").submit(function(){
            if(isEmpty($("#account").val())||isEmpty($("#password").val())){
                $("#msg span").html('账号密码不能为空');
                return false;
            }
            if(isEmpty($("#code").val())){
                $("#msg span").html('验证码不能为空');
                return false;
            }
            $(this).ajaxSubmit({
                url:baseURL+"/login",
                async:false,
                type:"post",
                dataType:"jsonp",
                jsonp:"callback",
                data:$(this).formSerialize(),
                beforeSend:function(){
                    showLoading();
                },
                success:function(data){
                    data=$.parseJSON(data);
                    if(data.flag){
                        var defaultPage=data.params;
                        var user_id = data.result;
                        $("#msg span").html("");
                        $("#msg").hide();
                        layer.msg("登陆成功");
                        window.location.href=defaultPage;
                    }else{
                        $("#msg").show();
                        $("#msg span").html(data.message);
                        $("#password").val("");
                        $("#password")[0].focus();
                        return false;
                    }
                },
                complete:function(){
                    showLoading();
                    refreshCode();
                    return false;
                }
            });
            return false;
        })

    });

    function refreshCode(){
        $("#code").val("");
        $("#codeImage").attr("src",baseURL+"/codeServlet?d="+new Date().getTime());
    }



    function resetInput(){
        $("#account").val("");
        $("#password").val("");
        $("#code").val("");
    }



</script>

<body class="dt">
<div class="w285"> <img src="images/logo2.png"  class="mga" alt=""/>
    <div class="dl">
        <form method="post" name="form1">
            <div id="inp">
                <input type="text" id="account" name="account" class="tt" required placeholder="请输入您的邮箱">
                <input type="password" id="password" name="password" class="tt" required placeholder="请输入密码">
                <div class="ttw">
                    <input type="text" id="code" name="code" class="tt" required placeholder="验证码" maxlength="4">
                    <img src="" id="codeImage"  width="74" height="38" onclick="refreshCode()" alt="" class="yzmp"/>
                </div>
                <p class="msg" id="msg"><img src="images/wrong.png" width="15" height="15" alt=""/><span>验证码错误，点击图片换一张。</span></p>
            <input type="submit" class="btn" value="登录">
            </div>
        </form>
    </div>
    <p class="tac f14">Copyright@沃橙信息 All Rights Reserved</p>
</div>
</body>
</html>