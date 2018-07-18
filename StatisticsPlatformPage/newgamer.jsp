<%@ page language="java" session="false" import="java.util.*" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>

<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

    <%@include file="common.jsp" %>

    <script type="text/javascript" src="js/conditions.js"></script>

    <title>新增用户</title>
</head>

<script type="text/javascript">

    $(function () {

        menuPosition(2,'20161220165484932840');

        loadConditions();

        $("#searchInp").val('');
        loadGameConditions();
        conditionGame();
        conditions(callback);
        dateSelector('sd', 'ed', callback);
        $('#sd').val('');
        $('#ed').val('');

        $("#condition1 a:eq(0)").click();
    });

    function searchGame(event) {
        var keyCode = event.keyCode ? event.keyCode : event.which ? event.which : event.charCode;
        if (keyCode == 13) {
            loadGameConditions();
        }
    }

    function loadGameConditions() {
        var gameName = $("#searchInp").val();
        //搜索游戏
        jsonpAjax("/common/gamelist", {"name": gameName}, false, function (data) {
            var objs = data.result;
            var cont = '<button type="button" val="" class="cur btn2a">全部</button>';
            for (var i = 0; i < objs.length; i++) {
                cont += '<button type="button" class="btn2a"  val="' + objs[i].id + '">' + objs[i].name + '</button>';
            }
            $("#gc").html(cont);
        });
    }

    var callback = function () {
        dataResult = [];
        var date1 = $("#sd").val();
        var date2 = $("#ed").val();

        var channelParam = getCurChannel();
        var provinceParam = getProvince();
        var gameParam = getCurVal($("#condition-game"));
        //var channelParam = getCurText($("#condition2"));
        //var provinceParam = getCurText($("#condition1"));
        var type = $("#condition4 .cur").attr('val');
        if (isEmpty(type)) {
            type = 0;
        }
        var interval = $("#condition5 .cur").attr('val');
        var date;
        if (!isEmpty(date1) && !isEmpty(date2)) {
            date = [date1, date2];
            var title = date1 + "至" + date2 + "数据";
            interval = '1d';
        }

        var index = $("#index").val();
        var data = {
            "channels": channelParam,
            "games": gameParam,
            "provinces": provinceParam,
            "interval": interval,
            "type": type,
            "date": date,
            "index": 1
        };

        jsonpAjax("/gamer/figure", "param="+encodeURIComponent (encodeURIComponent(JSON.stringify(data))), false, function (data) {
            dataResult = [];
            var result = data.result;
            var x;
            if (interval != '1h') {
                x = getKeyList(result[0].figures);
            } else {
                x = xAxisOfHours();
            }
            var data = [];
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
    };

    function getValueList(arr) {
        var values = [];
        for (var i = 0; i < arr.length; i++) {
            values.push(arr[i].objVal);
        }
        return values;
    }

    function getKeyList(arr) {
        var x = [];
        for (var i = 0; i < arr.length; i++) {
            var a = arr[i].key;
            if (a.length > 10) {
                a = a.substring(0, 10);
            }
            x.push(a);
        }
        return x;
    }

    function xAxisOfHours() {
        return ["00:00",
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
    }

    function getCurVal(pdiv) {
        var objs = $(pdiv).find('.cur');
        var c = [];
        for (var i = 0; i < objs.length; i++) {
            var id = $(objs[i]).attr("val");
            if (!isEmpty(id)) {
                c.push(id);
            }
        }
        return c;
    }

    function getCurText(pdiv) {
        var objs = $(pdiv).find('.cur');
        var c = [];
        for (var i = 0; i < objs.length; i++) {
            var p = $(objs[i]).text();
            if (p != '全部') {
                c.push(p);
            }
        }
        return c;
    }

    //以下是分页js
    var dataResult = [];
    var pageNo = 1;
    var pageSize = 10;
    var totalNumber = 0;

    function paginationData(pageNo) {
        var start = (pageNo - 1) * pageSize + 1;
        var end = pageNo * pageSize;
        var cont = "";
        for (var i = start; i <= end; i++) {
            var r = dataResult[i - 1];
            cont += getHTML(r);
            if (i == dataResult.length) {
                break;
            }
        }
        $("#cont").html(cont);
        pagination("p", "paginationData", pageNo, pageSize, totalNumber);
    }

    function getHTML(r) {
        var cont = "";
        if (r == null || r.total == 0) {
            return '';
        }
        cont += '<tr>';
        cont += '<td>' + r.datetime.substring(0, 10) + '</td>';
        cont += '<td>' + r.province + '</td>';
        cont += '<td>' + r.channel + '</td>';
        cont += '<td>' + r.cp + '</td>';
        cont += '<td>' + r.gameId + '</td>';
        cont += '<td>' + r.total + '</td>';
        cont += '</tr>';
        return cont;
    }

    function pageSizeChange(select) {
        var val = $(select).val();
        pageSize = val;
        paginationData(1);
    }


    function conditionGame(){
        $(document).on("click", "#condition2 button", function() {
            if($(this).index() == 0) { //点击全部显示所有channel
                removeOthersClass(this);
                if($(this).siblings('.cur').length >= 2){ // 该选项已经选了2个
                    $('#condition1 button:disabled').each(function(){
                        var $this = $(this);
                        $this.removeAttr("disabled");
                    });
                    $('#condition-game button:disabled').each(function(){
                        var $this = $(this);
                        $this.removeAttr("disabled");
                    })
                }else{
                    $('#condition2 button:disabled').each(function(){
                        var $this = $(this);
                        $this.removeAttr("disabled");
                    })
                }
            }else{
                if($(this).hasClass("cur")) { //其他元素，如果已经选中，取消当前省的channel
                    $(this).find('img').remove();
                    if ($(this).siblings('.cur').length == 0) { //如果是最后一个cur元素，取消后选中全部标签
                        $("#condition2 button:eq(0)").click();
                        return false;
                    }
                    //  //取消到少于2个
                    if($(this).siblings('.cur').length ==1){
                        $('#condition1 button:disabled').each(function(){
                            var $this = $(this);
                            $this.removeAttr("disabled");
                        });
                        $('#condition-game button:disabled').each(function(){
                            var $this = $(this);
                            $this.removeAttr("disabled");
                        })
                    }
                }else{ //新点击channel
                    $(this).append(getCancelImg());
                    if($("#condition2 button").eq(0).hasClass("cur")) {
                        $("#condition2 button").eq(0).removeClass("cur"); //取消第一个按钮的cur
                    }
                    if($(this).siblings('.cur').length ==1 && $(this).siblings('.cur').index()!=0){ //增加到2个
                        if($('#condition1').find('.cur').index()!=0){
                            $('#condition1').find('.cur').siblings().each(function(){
                                var $this = $(this);
                                if($this.index()!=0) {
                                    $this.attr("disabled", "disabled");
                                }
                            });
                        }
                        if($('#condition-game').find('.cur').index()!=0){
                            $('#condition-game').find('.cur').siblings().each(function(){
                                var $this = $(this);
                                if($this.index()!=0) {
                                    $this.attr("disabled", "disabled");
                                }
                            });
                        }
                    }
                    if($('#condition1').find('.cur').length>=2||$('#condition-game').find('.cur').length>=2){
                        $(this).siblings().each(function() {
                            var $this = $(this);
                            if ($this.index() != 0) {
                                $this.attr("disabled", "disabled");
                            }
                        });
                    }
                }
                $(this).toggleClass("cur");
            }
            callback();
        });
        $(document).on("click", "#condition1 button", function() {
            if($(this).index() == 0) { //点击全部显示所有channel
                removeOthersClass(this);
                $("#condition2").html(getDefaultConditionHTML());
                conditionHTML($("#condition2"), channels);
                if($(this).siblings('.cur').length >= 2){ // 该选项已经选了2个
                    $('#condition2 button:disabled').each(function(){
                        var $this = $(this);
                        $this.removeAttr("disabled");
                    });
                    $('#condition-game button:disabled').each(function(){
                        var $this = $(this);
                        $this.removeAttr("disabled");
                    })
                }else{
                    $('#condition1 button:disabled').each(function(){
                        var $this = $(this);
                        $this.removeAttr("disabled");
                    })
                }
            } else { //点击其他标签
                var c = map.get($(this).text());
                if($(this).hasClass("cur")) { //其他元素，如果已经选中，取消当前省的channel
                    $(this).find('img').remove();
                    if($(this).siblings('.cur').length == 0) { //如果是最后一个cur元素，取消后选中全部标签
                        $("#condition1 button:eq(0)").click();
                        return false;
                    }
                    for(var i = 0; i < c.length; i++) { //取消对应的渠道信息
                        $("#condition2 button").each(function() {
                            if($(this).text() == c[i][1]) {
                                $(this).remove();
                            }
                        });
                    }
                    //  //取消到少于2个
                    if($(this).siblings('.cur').length ==1){
                        $('#condition2 button:disabled').each(function(){
                            var $this = $(this);
                            $this.removeAttr("disabled");
                        });
                        $('#condition-game button:disabled').each(function(){
                            var $this = $(this);
                            $this.removeAttr("disabled");
                        })
                    }
                } else { //如果没有选中
                    $(this).append(getCancelImg());
                    if($("#condition1 button").eq(0).hasClass("cur")) {
                        $("#condition1 button").eq(0).removeClass("cur"); //取消第一个按钮的cur
                        $("#condition2").html(getDefaultConditionHTML);
                    }
                    conditionHTML($("#condition2"), c); //载入当前省份的信息
                    if($(this).siblings('.cur').length ==1 && $(this).siblings('.cur').index()!=0){ //增加到2个
                        if($('#condition2').find('.cur').index()!=0){
                            $('#condition2').find('.cur').siblings().each(function(){
                                var $this = $(this);
                                if($this.index()!=0) {
                                    $this.attr("disabled", "disabled");
                                }
                            });
                        }
                        if($('#condition-game').find('.cur').index()!=0){
                            $('#condition-game').find('.cur').siblings().each(function(){
                                var $this = $(this);
                                if($this.index()!=0) {
                                    $this.attr("disabled", "disabled");
                                }
                            });
                        }
                    }else{
                        if($('#condition2').find('.cur').length>=2||$('#condition-game').find('.cur').length>=2){
                            $(this).siblings().each(function(){
                                var $this = $(this);
                                if($this.index()!=0){
                                    $this.attr("disabled","disabled");
                                }
                            });
                        }
                    }
                }
                $(this).toggleClass("cur");
            }
            callback();
        });
    }
</script>


<body>
<%@include file="head.jsp" %>
<%@include file="left.jsp" %>
<div class="right">
    <div class="shuju">
        <h3>新增游戏用户</h3>
        查询日期：
        <input placeholder="请选择日期范围" class="laydate-icon" id="sd">
        至<input placeholder="请选择日期范围" class="laydate-icon" id="ed">
        <div class="yc"><a href="#none">隐藏筛选 &and;</a></div>
        <div class="dls">
            <dl class="sax">
                <dt>城市：</dt>
                <dd id="condition1">
                    <button type="button" class="cur btn2a">全部</button>
                </dd>
            </dl>
            <dl class="sax">
                <dt>盒子：</dt>
                <dd id="condition2">
                    <button type="button" class="cur btn2a">全部</button>
                </dd>
            </dl>
            <dl class="sax">
                <dt>游戏：</dt>
                <dd id="condition-game">
                    <input type="text" id="searchInp" class="saxint saxint1" placeholder="搜索游戏"
                           onkeydown="searchGame(event)"><br>
                    <div id="gc">

                    </div>
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
        <div id="upperFigure">
        </div>
        <div class="mgt30">
            <div class="fuf"><strong>新增游戏用户明细</strong><a href="#" class="btn1 fr">导出CSV</a></div>
            <table width="100%" border="0" cellspacing="0" class="tabl">
                <thead>
                <tr>
                    <td width="20%" align="center">日期</td>
                    <td width="10%">城市</td>
                    <td width="20%">盒子</td>
                    <td width="15%">CP</td>
                    <td width="20%">游戏</td>
                    <td width="15%">新增用户数</td>
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