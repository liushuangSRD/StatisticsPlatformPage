<%@ page language="java" session="false" import="java.util.*" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>

<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

    <%@include file="common.jsp" %>

    <script type="text/javascript" src="js/conditions.js"></script>
    <script type="text/javascript" src="js/userAnalysis.js"></script>

    <title>活跃用户</title>
</head>

<script type="text/javascript">
    $(function(){
        menuPosition(1,'20160912173584324732');
    })
</script>

<body>
<%@include file="head.jsp" %>
<%@include file="left.jsp" %>
<div class="right">
    <div class="shuju">
        <input id="index" type="hidden" value="2"/>
        <h3>活跃用户</h3> 查询日期：
        <input placeholder="请选择日期范围" class="laydate-icon" id="sd">
        至<input placeholder="请选择日期范围" class="laydate-icon" id="ed">
        <div class="yc">
            <a href="#none">隐藏筛选 &and;</a>
        </div>
        <div class="dls">
            <dl class="sax">
                <dt>城市：</dt>
                <dd id="condition1">
                    <a href="javascript:void(0)" class="cur">全部</a>
                </dd>
            </dl>
            <dl class="sax">
                <dt>盒子：</dt>
                <dd id="condition2">
                    <a href="javascript:void(0)" class="cur">全部</a>
                </dd>
            </dl>
            <dl class="sax">
                <dt>大厅版本：</dt>
                <dd id="condition3">
                    <a href="javascript:void(0)" class="cur">全部</a>
                </dd>
            </dl>
        </div>
            <div class="day fr" id="condition5">
                显示粒度：
                <span class="cur" val="1h">小时</span>
                <span val="1d">天</span>
                <span val="1w">周</span>
                <span val="1M">月</span>
            </div>
            <div class="subnav mgt30" id="condition4">
                <a href="javascript:void(0)" val="0" class="cur">默认</a>
                <a href="javascript:void(0)" val="1">新老用户</a>
                <a href="javascript:void(0)" val="2">是否付费</a>
            </div>
        </div>
        <div id="upperFigure">
        </div>
        <div class="mgt30">
            <div class="fuf"><strong>活跃用户明细</strong>
                <a href="#" class="btn1 fr">导出CSV</a>
            </div>
            <table width="100%" border="0" cellspacing="0" class="tabl">
                <thead>
                <tr>
                    <td width="20%" align="center">日期</td>
                    <td width="20%">城市</td>
                    <td width="20%">盒子</td>
                    <td width="20%">大厅版本</td>
                    <td width="20%">活跃用户数</td>
                </tr>
                </thead>
                <tbody id="cont">

                </tbody>
            </table>
            <div class="page tac">每页显示&nbsp;&nbsp;
                <select class="slc w100" onchange="pageSizeChange(this)">
                    <option value="10">10</option>
                    <option value="50">50</option>
                    <option value="100">100</option>
                    <option value="200">200</option>
                </select>
                <div id="p">

                </div>
            </div>
        </div>
    </div>
</div>
<%@include file="foot.jsp" %>
</body>

</html>