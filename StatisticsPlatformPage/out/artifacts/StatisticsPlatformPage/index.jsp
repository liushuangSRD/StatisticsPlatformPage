<%@ page language="java" session="false" import="java.util.*" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>

<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

    <%@include file="common.jsp" %>

    <title>总览</title>
</head>
<script type="text/javascript">
    var x = new Array(
            "00:00",
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
            "23:00"
    );

    var dates = new Array();//存上部折线图已选择的时间


    function addDate(val) {
        if (isEmpty(val)) {
            return false;
        }
        val = val.replace("-", "/");
        dates.push(val);
    }

    //初始化dates
    function initDateArray() {
        dates = new Array();
        dates.push(DateAdd('d', 0, new Date()));
        dates.push(DateAdd('d', -1, new Date()));
    }

    $(function () {

        menuPosition(1,'20160912172432135432');

        chartOptions();//图标样式
        initDateArray();//初始化dates
        loadMainData();//载入上部统计数字

        //点击li载入对应折线图
        $("#figureList li").click(function () {
            //				initDateArray();
            upperListClick(this);
        });

        //点击a标签载入对应饼图
        $("#pieList1 a").click(function () {
            pieListClick(this);
        });

        //点击a标签载入对应饼图
        $("#pieList2 a").click(function () {
            pieListClick(this);
        });

        $("#bottomList a").click(function () {
            $("#sd").val('');
            $("#ed").val('');
            var type = $(this).attr("val");
            var date1, date2;
            var title = "";
            if (type == 1) { //近一周
                date1 = DateAdd('d', -7, new Date());
                date2 = DateAdd('d', 0, new Date());
                title = "近一周数据";
            } else if (type == 2) { //近三十天
                date1 = DateAdd('d', -30, new Date());
                date2 = DateAdd('d', 0, new Date());
                title = "近三十天数据";
            } else {
                date1 = "";
                date2 = "";
                title = "全部数据";
            }
            bottomFigure(date1, date2, title);//载入底部柱状图数据
        })
        upperListClick($("#figureList li").eq(0));
        pieListClick($("#pieList1 a").eq(0));
        pieListClick($("#pieList2 a").eq(0));
        $("#bottomList a").eq(0).click();

        //对比时间段 按钮添加日期到dates 加载折线图
        laydate({
            elem: '#dateinp',
            format: 'YYYY/MM/DD',
            festival: true,
            istime: true,
            min: '2015/01/01',
            max: laydate.now(),
            choose: function (a) {
                addDate(a);
                upperListClick($("#figureList .cur"));
            }
        });


        dateSelector('sd', 'ed', bottomFigure);//选择日期区间之后自动调用载入柱状图的方法

        $("#sd").val('');
        $("#ed").val('');
    });

    //折线图部分 li点击触发
    function upperListClick(li) {
        var method = $(li).attr("val");
        var title = $(li).find("p:eq(0)").text();
        var param = {
            "method": method,
            "dates": dates
        };
        jsonpAjax("/index/figure", param, true, function (data) {
            var result = data.result;
            var data = new Array();

            data[0] = new Figure("今天", getArrayValue(result[0]));
            data[1] = new Figure("昨天", getArrayValue(result[1]));
            for (var i = 2; i < result.length; i++) {
                data[i] = new Figure(dates[i], getArrayValue(result[i]));
            }
            if("incomeFigure"==method){
                lineChart("upperFigure", data, title, x, "金额", "元");
            }else{
                lineChart("upperFigure", data, title, x, "人数", "人");
            }
        });
    }

    //获取figuremodel的objval属性，拼成数组
    function getArrayValue(list) {
        var result = new Array();
        for (var i = 0; i < list.length; i++) {
            result[i] = ~~(list[i].objVal);
        }
        return result;
    }

    //a点击触发
    function pieListClick(a) {
        var method = $(a).attr("val");
        var title = $(a).text();
        var param = {
            "method": method,
            "dates": new Array(dates[0])
        };
        jsonpAjax("/index/figure", param, true, function (data) {
            var result = data.result[0];
            var data = null;
            if(result!=null){
                data = new Array();
                for (var i = 0; i < result.length; i++) {
                    data[i] = new Array(result[i].key, ~~(result[i].objVal));
                }
            }
            var pieId=$(a).parents(".pie").find(".pieFigure").attr("id");
            pieChart(pieId, data, title);
        })
    }

    var bottomFigure = function bottomListClick() {

        var date1 = $("#sd").val();
        var date2 = $("#ed").val();
        var param;
        var title = "";
        if (!isEmpty(date1) && !isEmpty(date2)) {
            param = {
                "date1": date1,
                "date2": date2
            };
            title = date1 + "至" + date2 + "数据";
        }

        jsonpAjax("/index/versionFigure", param, true, function (data) {
            var result = data.result;
            var data = new Array();
            $.each(result, function (i, r) {
                if (r.objVal == '' || ~~r.objVal == 0) {
                } else {
                    data[i] = new Array(r.key, ~~r.objVal);
                }
            });
            histogram('versionFigure', data, title, '使用人数', '人');
        })
    }

    //载入上半部分统计数量
    function loadMainData() {

        jsonpAjax("/index/mainData", "", false, function (data) {
            var result = data.result;

            $(".upperNum").eq(0).text(result.totalUser);
            $(".upperNum").eq(1).text(result.totalPayUser);
            $(".upperNum").eq(2).text(result.activeUserOfWeek);
            $(".upperNum").eq(3).text(result.userLossAmount);
            $(".upperNum").eq(4).text(result.aliveUserOfWeek+"%");

            $(".upperNum").eq(5).text(result.onlineUserNumber[0]);
            setRate($(".upperNum").eq(5).next(), result.onlineUserNumber[1]);
            $(".upperNum").eq(6).text(result.newUserNumber[0]);
            setRate($(".upperNum").eq(6).next(), result.newUserNumber[1]);
            $(".upperNum").eq(7).text(result.loginUserNumber[0]);
            setRate($(".upperNum").eq(7).next(), result.loginUserNumber[1]);
            $(".upperNum").eq(8).text(result.gameUserNumber[0]);
            setRate($(".upperNum").eq(8).next(), result.gameUserNumber[1]);
            $(".upperNum").eq(9).text(result.newUserOfPay[0]);
            setRate($(".upperNum").eq(9).next(), result.newUserOfPay[1]);
            $(".upperNum").eq(10).text(result.incomeOfDay[0]);
            setRate($(".upperNum").eq(10).next(), result.incomeOfDay[1]);
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
        <h3>平台概况</h3>
        <ul class="gaik">
            <li class="cur">
                <p class="f12">累计用户数
                    <a href="#" title="累计启动过应用程序的用户数量（以IPTV业务账号去重）"><img src="images/qt.png" width="15" height="15"
                                                                          alt=""/></a>
                </p>
                <p class="f28 upperNum">...</p>
            </li>
            <li class="cur">
                <p class="f12">付费用户数
                    <a href="#" title="累积在沃家游戏大厅支付成功的用户数量(以IPTV业务账号去重)"><img src="images/qt.png" width="15" height="15" alt=""/></a>
                </p>
                <p class="f28 upperNum">...</p>
            </li>
            <li class="cur">
                <p class="f12">周活跃用户数
                    <a href="#" title="最近七天活跃的沃家游戏大厅用户数(以IPTV业务账号去重)"><img src="images/qt.png" width="15" height="15" alt=""/></a>
                </p>
                <p class="f28 upperNum">...</p>
            </li>
            <li class="cur">
                <p class="f12">昨日新增用户流失数
                    <a href="#" title="前日新增的沃家游戏大厅用户在昨日未活跃的用户数(去重)"><img src="images/qt.png" width="15" height="15" alt=""/></a>
                </p>
                <p class="f28 upperNum">...</p>
            </li>
            <li class="cur">
                <p class="f12">周留存率
                    <a href="#" title="第一周来的并且在第二周也来的用户数/第一周来的用户数"><img src="images/qt.png" width="15" height="15" alt=""/></a>
                </p>
                <p class="f28 upperNum">...</p>
            </li>
        </ul>
    </div>
    <div class="shuju">
        <h3>实时数据</h3>
        <ul class="sjx sjx1" id="figureList">
            <li class="cur" val="onlineUserFigure">
                <p class="f14">在线用户数</p>
                <p class="f28 upperNum">...</p>
                <p><img src="images/jts.png" width="9" height="14" alt=""/><span>NaN</span></p>
            </li>
            <li val="newUserFigure">
                <p class="f14">新增用户数</p>
                <p class="f28 upperNum">...</p>
                <p><img src="images/jts.png" width="9" height="14" alt=""/><span>NaN</span></p>
            </li>
            <li val="loginUserFigure">
                <p class="f14">登录用户数</p>
                <p class="f28 upperNum">...</p>
                <p><img src="images/jts.png" width="9" height="14" alt=""/><span>NaN</span></p>
            </li>
            <li val="gameUserFigure">
                <p class="f14">游戏用户数</p>
                <p class="f28 upperNum">...</p>
                <p><img src="images/jts.png" width="9" height="14" alt=""/><span>NaN</span></p>
            </li>
            <li val="newUserOfPay">
                <p class="f14">新增付费用户数</p>
                <p class="f28 upperNum">...</p>
                <p><img src="images/jts.png" width="9" height="14" alt=""/><span>NaN</span></p>
            </li>
            <li val="incomeFigure">
                <p class="f14">当日收入</p>
                <p class="f28 upperNum">...</p>
                <p><img src="images/jts.png" width="9" height="14" alt=""/><span>NaN</span></p>
            </li>
        </ul>
        <div class="mgt20" id="upperFigure">
        </div>
        <a href="javascript:void(0)" class="btn1 fr" onclick="showLaydate()" id="chooseBtn">对比时间段</a>
        <input type="text" style="opacity: 0 ;float: right; height: 40px;" id="dateinp"/>
    </div>
    <div class="shuju shuju1">
        <div class="b1 pie">
            <h3>Top渠道-用户</h3>
            <div class="subnav" id="pieList1">
                <a href="javascript:void(0)" val="newUserOfChannel" class="cur">新增用户</a>
                <a href="javascript:void(0)" val="activeUserOfChannel">活跃用户</a>
                <a href="javascript:void(0)" val="payUserOfChannel">付费用户</a>
                <a href="javascript:void(0)" val="totalUserOfChannel">累计用户</a>
            </div>
            <div class="pieFigure" id="pieFigure1">

            </div>
        </div>
        <div class="b2 pie">
            <h3>Top渠道-付费</h3>
            <div class="subnav" id="pieList2">
                <a href="javascript:void(0)" val="todayFeeOfChannel" class="cur">当日付费</a>
                <a href="javascript:void(0)" val="propsFeeOfChannel">道具收费</a>
                <a href="javascript:void(0)" val="otherFeeOfChannel">非道具收费</a>
                <a href="javascript:void(0)" val="totalIncomeOfChannel">累计收费</a>
            </div>
            <div class="pieFigure" id="pieFigure2">

            </div>
        </div>
    </div>
    <div class="shuju" style="height: 550px;">
        <h3>大厅版本</h3>
        <div class="subnav fl" id="bottomList">
            <a href="javascript:void(0)" val="1" class="cur">近一周</a>
            <a href="javascript:void(0)" val="2">近一月</a>
            <a href="javascript:void(0)" val="3">全部时间</a>
        </div>
        　　自定义： <input placeholder="请选择日期范围" class="laydate-icon" id="sd"> 至 <input placeholder="请选择日期范围"
                                                                                   class="laydate-icon" id="ed">
        <div id="versionFigure">
        </div>
    </div>
</div>
<%@include file="foot.jsp" %>
</body>

</html>