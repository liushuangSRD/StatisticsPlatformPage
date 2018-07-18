<%@ page language="java" session="false" import="java.util.*" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>

<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

    <%@include file="common.jsp" %>

    <title>总览</title>
</head>

<script type="text/javascript">
    var x = ["00:00",
            "01:00",
            "02:00",
            "03:00",
            "04:00",
            "05:00",
            "06:00",
            "07:00",
            "08:00",
            "09:00",
            "10:00",
            "11:00",
            "12:00",
            "13:00",
            "14:00",
            "15:00",
            "16:00",
            "17:00",
            "18:00",
            "19:00",
            "20:00",
            "21:00",
            "22:00",
            "23:00"];

    var dates = [];//存上部折线图已选择的时间

    function addDate(val) {
        if (isEmpty(val)) {
            return false;
        }
        val = val.replace("-", "/");
        dates.push(val);
    }

    //初始化dates
    function initDateArray() {
        dates = [];
        dates.push(DateAdd('d', 0, new Date()));
        dates.push(DateAdd('d', -1, new Date()));
    }

    $(function () {

        menuPosition(2,'20161220165415832984');

        chartOptions();
        initDateArray();
        loadMainData();
        $("#figureList li").click(function () {
            //initDateArray();
            upperListClick(this);
        });

        $(".pt a").click(function () {
            pieListClick(this);
        });

        $(".shuju select").change(function () {
            var a = $(this).parents(".shuju").find(".pt .cur");
            pieListClick(a);
        });

        laydate({
            elem: '#dateinp',
            format: 'YYYY/MM/DD', // 分隔符可以任意定义，该例子表示只显示年月
            festival: true, // 显示节日
            istime: true,
            min: '2015/01/01',
            max: laydate.now(),
            choose: function (a) { // 选择日期完毕的回调
                addDate(a);
                upperListClick($("#figureList .cur"));
            }
        });

        upperListClick($("#figureList li").eq(0));
        pieListClick($(".pt a:eq(0)"));
//        pieListClick($("#pieList1 a").eq(0));
//        $("#bottomList a").eq(0).click();

    });

    //li点击触发
    function upperListClick(li) {
        var method = $(li).attr("val");
        var title = $(li).find("p:eq(0)").text();
        var param = {
            "method": method,
            "dates": dates
        };
        jsonpAjax("/app/figure", param, true, function (data) {
            var result = data.result;
            var data = [];

            data[0] = new Figure("今天", getArrayValue(result[0]));
            data[1] = new Figure("昨天", getArrayValue(result[1]));
            for (var i = 2; i < result.length; i++) {
                data[i] = new Figure(dates[i], getArrayValue(result[i]));
            }
            lineChart("upperFigure", data, title, x, "人数", "人");
        });
    }

    //获取figuremodel的objval属性，组装成数组
    function getArrayValue(list) {
        var result = [];
        for (var i = 0; i < list.length; i++) {
            result[i] = ~~(list[i].objVal);
        }
        return result;
    }

    //a点击触发
    function pieListClick(a) {
        var method = $(a).attr("val");
        var title = $(a).text();
        var limit = $(a).parents(".shuju").find("select:eq(0) option:selected").val();
        var param = {
            "method": method,
            "limit": limit
        };
        jsonpAjax("/app/pie", param, true, function (data) {
            var result = data.result[0];
            var data = [];
            var cont = '';
            for (var i = 0; i < result.length; i++) {
                var o = result[i];
                data[i] = [o.gameName, o.pieData];
                cont += getTableHTML(o);
            }
            $(a).parents(".shuju").find("tbody").html(cont);
            var id = $(a).parents(".shuju").find(".pie").attr("id");
            pieChart(id, data, title);
        })
    }

    //拼接饼图部分的table数据
    function getTableHTML(r) {
        var cont = '<tr>';
        cont += '<td>' + r.gameName + '</td>';
        cont += '<td>' + r.gameId + '</td>';
        cont += '<td>' + r.pieData + '</td>';
        cont += '<td>' + r.rate + '%</td>';
        return cont;
    }

    //载入上半部分统计数量
    function loadMainData() {

        jsonpAjax("/app/mainData", "", false, function (data) {
            var result = data.result;

            $(".upperNum").eq(0).text(result.totalDownloadNum);
            $(".upperNum").eq(1).text(result.totalPlayDuration);
            $(".upperNum").eq(2).text(result.totalGamer);

            $(".upperNum").eq(3).text(result.gameDuration[0]);
            setRate($(".upperNum").eq(3).next(), result.gameDuration[1]);
            $(".upperNum").eq(4).text(result.activeGamerNum[0]);
            setRate($(".upperNum").eq(4).next(), result.activeGamerNum[1]);
            $(".upperNum").eq(5).text(result.startGameNum[0]);
            setRate($(".upperNum").eq(5).next(), result.startGameNum[1]);
            $(".upperNum").eq(6).text(result.newGamerNum[0]);
            setRate($(".upperNum").eq(6).next(), result.newGamerNum[1]);
            $(".upperNum").eq(7).text(result.downloadNum[0]);
            setRate($(".upperNum").eq(7).next(), result.downloadNum[1]);
            $(".upperNum").eq(8).text(NaN);
            $(".upperNum").eq(8).text("...");
        });

    }

    function showLaydate() {
        $("#dateinp").click();
    }

    //换算增长率
    function setRate(tag, rate) {
        if (rate == "N") {
            return;
        }
        if (rate < 0) {
            $(tag).children().attr("src", "images/jtx.png");
        } else {
            $(tag).children().attr("src", "images/jts.png");
        }
        rate = Math.abs(rate);
        $(tag).find("span").text(rate + "%");
    }

</script>

<body>
<%@include file="head.jsp" %>
<%@include file="left.jsp" %>
<div class="right">
    <div class="shuju">
        <h3>应用概况</h3>
        <ul class="gaik">
            <li class="cur">
                <p class="f12">累计下载量
                    <a href="#" title="累计下载量">
                        <img src="images/qt.png" width="15" height="15" alt=""/>
                    </a>
                </p>
                <p class="f28 upperNum">...</p>
            </li>
            <li class="cur">
                <p class="f12">累计游戏时长（时）
                    <a href="#" title="累计启动用户数量">
                        <img src="images/qt.png" width="15" height="15" alt=""/>
                    </a>
                </p>
                <p class="f28 upperNum">...</p>
            </li>
            <li class="cur">
                <p class="f12">累计游戏用户数
                    <a href="#" title="累计启动用户数量">
                        <img src="images/qt.png" width="15" height="15" alt=""/>
                    </a>
                </p>
                <p class="f28 upperNum">...</p>
            </li>
        </ul>
    </div>
    <div class="shuju">
        <h3>实时数据</h3>
        <ul class="sjx sjx1" id="figureList">
            <li class="cur" val="downloadNumFigure">
                <p class="f14">下载次数</p>
                <p class="f28 upperNum">...</p>
                <p><img src="images/jts.png" width="9" height="14" alt=""/><span>NaN</span></p>
            </li>
            <li val="newGamerFigure">
                <p class="f14">新增游戏用户</p>
                <p class="f28 upperNum">...</p>
                <p><img src="images/jtx.png" width="9" height="14" alt=""/><span>NaN</span></p>
            </li>
            <li val="startGameFigure">
                <p class="f14">启动游戏次数</p>
                <p class="f28 upperNum">...</p>
                <p><img src="images/jts.png" width="9" height="14" alt=""/><span>NaN</span></p>
            </li>
            <li val="activeGamerFigure">
                <p class="f14">活跃游戏用户</p>
                <p class="f28 upperNum">...</p>
                <p><img src="images/jts.png" width="9" height="14" alt=""/><span>NaN</span></p>
            </li>
            <li val="gameDurationFigure">
                <p class="f14">游戏总时长（时）</p>
                <p class="f28 upperNum">...</p>
                <p><img src="images/jts.png" width="9" height="14" alt=""/><span>NaN</span></p>
            </li>
            <li val="">
                <p class="f14">游戏收益（元）</p>
                <p class="f28 upperNum">...</p>
                <p><img src="images/jts.png" width="9" height="14" alt=""/><span>NaN</span></p>
            </li>
        </ul>
        <div class="mgt20" id="upperFigure">
        </div>
        <a href="javascript:void(0)" class="btn1 fr" onclick="showLaydate()" id="chooseBtn">对比时间段</a>
        <input type="text" style="opacity: 0 ;float: right; height: 40px;" id="dateinp"/>
    </div>
    <div class="shuju">
        <h3><select class="slc fr">
            <option value="10" selected="selected">TOP10</option>
            <option value="30">TOP30</option>
            <option value="50">TOP50</option>
        </select>Top 游戏-游戏时长
        </h3>
        <div class="subnav fl pt">
            <a href="javascript:void(0)" class="cur" val="totalDuration">当日总时长</a>
            <a href="javascript:void(0)" val="avgDuration">当日平均时长</a>
            <a href="javascript:void(0)" val="maxDuration">当日最长时长</a>
        </div>
        <div class=" cl">
            　
            <div class="fl w50">
                <table width="100%" border="0" cellspacing="0" class="tabl tac">
                    <thead>
                    <tr>
                        <td width="20%">序号</td>
                        <td width="20%">游戏名</td>
                        <td width="20%">游戏时长(M)</td>
                        <td width="20%">游戏时长占比</td>
                    </tr>
                    </thead>
                    <tbody>

                    </tbody>
                </table>
            </div>
            <div class="fr w50 pie" id="pieFigure1">
            </div>
        </div>
    </div>
    <div class="shuju">
        <h3><select class="slc fr">
            <option value="10" selected="selected">TOP10</option>
            <option value="30">TOP30</option>
            <option value="50">TOP50</option>
        </select>Top 游戏-游戏人数
        </h3>
        <div class="subnav fl pt">
            <a href="javascript:void(0)" val="newGamer" class="cur">新增游戏用户</a>
            <a href="javascript:void(0)" val="gamerNum">当日游戏人数</a>
            <a href="javascript:void(0)" val="startGameNum">当日游戏次数</a>
        </div>
        <div class=" cl">
            　
            <div class="fl w50">
                <table width="100%" border="0" cellspacing="0" class="tabl tac">
                    <thead>
                    <tr>
                        <td width="20%">序号</td>
                        <td width="20%">游戏名</td>
                        <td width="20%">游戏时长(M)</td>
                        <td width="20%">游戏时长占比</td>
                    </tr>
                    </thead>
                    <tbody>

                    </tbody>
                </table>
            </div>
            <div class="fr w50 pie" id="pieFigure2">
            </div>
        </div>
    </div>
    <div class="shuju">
        <h3><select class="slc fr">
            <option value="10" selected="selected">TOP10</option>
            <option value="30">TOP30</option>
            <option value="50">TOP50</option>
        </select>Top 游戏-游戏付费
        </h3>
        <div class="subnav fl pt">
            <a href="javascript:void(0)" class="cur">下载付费</a>
            <a href="javascript:void(0)">道具付费</a>
            <a href="javascript:void(0)">云游戏付费</a>
        </div>
        <div class=" cl">
            　
            <div class="fl w50">
                <table width="100%" border="0" cellspacing="0" class="tabl tac">
                    <thead>
                    <tr>
                        <td width="20%">序号</td>
                        <td width="20%">游戏名</td>
                        <td width="20%">游戏时长(M)</td>
                        <td width="20%">游戏时长占比</td>
                    </tr>
                    </thead>
                    <tbody>

                    </tbody>
                </table>
            </div>
            <div class="fr w50 pie" id="pieFigure3">

            </div>
        </div>
    </div>
</div>
<%@include file="foot.jsp" %>
</body>

</html>
