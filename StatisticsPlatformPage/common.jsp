<%@ page language="java" session="false" import="java.util.*" pageEncoding="UTF-8"%>

<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<link rel="stylesheet" type="text/css" href="layer/skin/layer.css"/>
<link rel="stylesheet" type="text/css" href="laydate/need/laydate.css"/>
<link rel="stylesheet" type="text/css" href="css/app.css"/>
<link rel="stylesheet" type="text/css" href="css/loading.css"/>


<script type="text/javascript" src="js/common/jquery-3.1.1.min.js"></script>
<script type="text/javascript" src="js/common/jquery.form.min.js"></script>
<script type="text/javascript" src="js/common/jquery.cookie.js"></script>
<script type="text/javascript" src="js/common/highcharts.js"></script>
<script type="text/javascript" src="js/common/highcharts-more.js"></script>
<script type="text/javascript" src="js/common/no-data-to-display.js"></script>
<script type="text/javascript" src="laydate/laydate.js"></script>
<script type="text/javascript" src="layer/layer.js"></script>
<script type="text/javascript" src="js/common/util.js"></script>
<script type="text/javascript" src="js/common/dateUtil.js"></script>
<script type="text/javascript" src="js/common/js.js"></script>
<script type="text/javascript" src="js/common/Figure.js"></script>
<script type="text/javascript" src="js/common/pagination.js"></script>
<script type="text/javascript" src="js/common/Map.js"></script>
<script type="text/javascript" src="js/menus.js"></script>
<script type="text/javascript" src="js/dateSelector.js"></script>


<script type="application/javascript">
</script>


<div id='loading' style="display:none;">
	<div class='loaded'>
		<div class='load'></div>
	</div>
</div>

