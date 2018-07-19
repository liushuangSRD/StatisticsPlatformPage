<%@ page language="java" session="false" import="java.util.*" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>

<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

    <%@include file="common.jsp" %>

    <script type="text/javascript" src="js/conditions.js"></script>

    <title>付费趋势</title>
</head>

<script type="text/javascript">
    $(function(){
        menuPosition(1,'20161011165494848329');

        loadConditions();
        conditions(callback);

        dateSelector('sd', 'ed', callback);

        $('#sd').val('');
        $('#ed').val('');
    })

    var dataResult;

    function getCheckedVal(div){
        return $(div).find("input:checked").val();
    }

    var callback=function(){
        dataResult = new Array();
        var date1 = $("#sd").val();
        var date2 = $("#ed").val();
        var channelParam = getCurText($("#condition2"));
        var provinceParam = getCurText($("#condition1"));
        var payType=getCheckedVal($("#condition-st"));
        var type = $("#condition4 .cur").attr('val');
        if (isEmpty(type)) {
            type = 0;
        }
        var interval = $("#condition5 .cur").attr('val');
        var date;
        if (!isEmpty(date1) && !isEmpty(date2)) {
            date = new Array(date1, date2);
            var title = date1 + "至" + date2 + "数据";
            interval = '1d';
        }
        var data = {
            "channels": channelParam,
            "payType": payType,
            "provinces": provinceParam,
            "interval": interval,
            "type": type,
            "date": date
        };

        jsonpAjax("/payTrend/query", data, false, function (data) {
            dataResult = new Array();
            var result = data.result;
            var x;
            if (interval != '1h') {
                x = getKeyList(result[0].figures);
            } else {
                x = xAxisOfHours();
            }
            var data = new Array();
            for (var i = 0; i < result.length; i++) {
                for (var j = 0; j < result[i].records.length; j++) { //下方分页数据
                    if (result[i].records[j].total > 0) {
                        dataResult.push(result[i].records[j]);
                    }
                }
                var rows = result[i].figures;
                var name = result[i].key;
                var value = getValueList(rows);
                data[i] = new Figure(name, value);
            }
            if (type == 0) {
                lineChart("upperFigure", data, title, x, "人数", "人");
            } else if (type == 1) {
                stackedHistogram("upperFigure", data, title, x, '人数');
            } else if (type == 2) {
                stackedHistogram("upperFigure", data, title, x, '人数');
            }
            totalNumber = dataResult.length;
            //下方分页数据
            paginationData(1);

        })
    }

</script>

<body>
<%@include file="head.jsp" %>
<%@include file="left.jsp" %>
<div class="right">
    <div class="shuju">
        <h3>付费趋势</h3>
        查询日期：
        <input placeholder="请选择日期范围" class="laydate-icon" id="sd">
        至<input placeholder="请选择日期范围" class="laydate-icon" id="ed">
        <div class="yc"><a href="#none">隐藏筛选 &and;</a></div>
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
                <dt>支付方式：</dt>
                <dd><a href="#none">全部</a><a href="#none" class="cur">话费</a><a href="#none">支付宝</a><a
                        href="#none">微信</a><a href="#none">银联</a><a href="#none">QQ钱包</a></dd>
            </dl>
        </div>
        <div class="mgt30 f14" id="condition-st">指标：
            <input type="radio" name="RadioGroup1" checked value="1">
            付费用户&nbsp;&nbsp;&nbsp;
            <input type="radio" name="RadioGroup1" value="2">
            付费金额&nbsp;&nbsp;&nbsp;
            <input type="radio" name="RadioGroup1" value="3">
            付费渗透率&nbsp;&nbsp;&nbsp;
            <input type="radio" name="RadioGroup1" value="4">
            付费成功率&nbsp;&nbsp;&nbsp;
            <input type="radio" name="RadioGroup1" value="5">
            ARPU&nbsp;&nbsp;&nbsp;
            <input type="radio" name="RadioGroup1" value="6">
            ARPPU
        </div>
        <div>
            <div class="day fr" id="condition5">
                显示粒度：
                <span class="cur" val="1h">小时</span>
                <span val="1d">天</span>
                <span val="1w">周</span>
                <span val="1M">月</span>
            </div>
            <div class="subnav mgt30" id="condition4">
                <a href="javascript:void(0)" val="0" class="cur">全部 </a>
                <a href="javascript:void(0)" val="1">新用户</a>
                <a href="javascript:void(0)" val="2">老用户</a>
            </div>
        </div>
        <div id="upperFigure"></div>
        <div class="mgt30">
            <div class="fuf"><strong>付费用户明细</strong><a href="#" class="btn1 fr">导出CSV</a></div>
            <table width="100%" border="0" cellspacing="0" class="tabl tac">
                <thead>
                <tr>
                    <td width="10%">日期</td>
                    <td width="10%">城市</td>
                    <td width="10%">盒子</td>
                    <td width="10%">大厅版本</td>
                    <td width="10%">付费用户数</td>
                    <td width="10%">新增付费用户数</td>
                    <td width="10%">付费渗透率</td>
                    <td width="10%">付费成功率</td>
                    <td width="10%">ARPU</td>
                    <td width="10%">ARPPU</td>
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

</body>


</html>