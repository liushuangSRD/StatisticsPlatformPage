$(function() {
	loadConditions();
	conditions(callback);
    chartOptions();

	dateSelector('sd', 'ed', callback);

	$('#sd').val('');
	$('#ed').val('');

	$("#condition1 button:eq(0)").click();
})

var callback = function() {
	dataResult = new Array();
	var date1 = $("#sd").val();
	var date2 = $("#ed").val();

	var channelParam = getCurChannel();
	var versionParam = getCurText($("#condition3"));
	var provinceParam = getProvince();
	var type = $("#condition4 .cur").attr('val');
	if(isEmpty(type)) {
		type = 0;
	}
	var interval = $("#condition5 .cur").attr('val');
	var date;
	if(!isEmpty(date1) && !isEmpty(date2)) {
		date = new Array(date1, date2);
		var title = date1 + "至" + date2 + "数据";
		interval = '1d';
	}
	
	var index=$("#index").val();
	var data = {
		"channels": channelParam,
		"versions": versionParam,
		"provinces": provinceParam,
		"interval": interval,
		"type": type,
		"date": date,
		"index": index
	};

	jsonpAjax("/user/figure", "param="+encodeURIComponent (encodeURIComponent(JSON.stringify(data))), false, function(data) {
		dataResult = new Array();
		var result = data.result;
		var x;
		if(interval != '1h') {
			x = getKeyList(result[0].figures);
		} else {
			x = xAxisOfHours();
		}
		var data = new Array();
		for(var i = 0; i < result.length; i++) {
			for(var j = 0; j < result[i].records.length; j++) { //下方分页数据
				if(result[i].records[j].total > 0) {
					dataResult.push(result[i].records[j]);
				}
			}
			var rows = result[i].figures;
			var name = result[i].key;
			var value = getValueList(rows);
			data[i] = new Figure(name, value);
		}
		if(type == 0) {
			lineChart("upperFigure", data, title, x, "人数", "人");
		} else if(type == 1) {
			stackedHistogram("upperFigure", data, title, x, '人数');
		} else if(type == 2) {
			stackedHistogram("upperFigure", data, title, x, '人数');
		}
		totalNumber = dataResult.length;
		//下方分页数据
		paginationData(1);

	})
}

function getValueList(arr) {
	var values = new Array();
	for(var i = 0; i < arr.length; i++) {
		values.push(arr[i].objVal);
	}
	return values;
}

function getKeyList(arr) {
	var x = new Array();
	for(var i = 0; i < arr.length; i++) {
		x.push(arr[i].key);
	}
	return x;
}

function xAxisOfHours() {
	return new Array(
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
}
function getProvince(){
	var proMap = {};
	$('#condition1').find('.cur').each(function(){
		var province = $(this).text();
		if(province!="全部"){
            proMap[province] = map.get(province);
		}
	});
	return proMap;
}

function getCurChannel(){
	var channel = new Array();
	if($('#condition2').find('.cur').index()!=0){
        $('#condition2').find('.cur').each(function(){
            var channelInfo = new Array();
        	var $this = $(this);
            channelInfo.push($this.attr('val'));
            channelInfo.push($this.text());
            channel.push(channelInfo);
		})

	}
return channel;
}

function getCurText(pdiv) {
    var c = new Array();
	$(pdiv).find('.cur').each(function(){
        var p = $(this).text();
        if(p != '全部') {
            c.push(p);
        }
	});
	return c;
}

//以下是分页js
var dataResult = new Array();
var pageNo = 1;
var pageSize = 10;
var totalNumber = 0;

function paginationData(pageNo) {
	var start = (pageNo - 1) * pageSize + 1;
	var end = pageNo * pageSize;
	var cont = "";
	for(var i = start; i <= end; i++) {
		var r = dataResult[i - 1];
		cont += getHTML(r);
		if(i == dataResult.length) {
			break;
		}
	}
	$("#cont").html(cont);
	pagination("p", "paginationData", pageNo, pageSize, totalNumber);
}

function getHTML(r) {
	var cont = "";
	if(r == null || r.total == 0) {
		return '';
	}
	cont += '<tr>';
	cont += '<td>' + r.datetime + '</td>';
	cont += '<td>' + r.province + '</td>';
	cont += '<td>' + r.channel + '</td>';
	cont += '<td>' + r.version + '</td>';
	cont += '<td>' + r.total + '</td>';
	cont += '</tr>';
	return cont;
}

function pageSizeChange(select) {
	var val = $(select).val();
	pageSize = val;
	paginationData(1);
}