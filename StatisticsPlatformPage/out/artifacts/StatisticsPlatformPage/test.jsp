<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	    <%@include file="common.jsp" %>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<script type="text/javascript" src="js/common/jquery.dataTables.min.js"></script>
		<link rel="stylesheet" type="text/css" href="css/jquery.dataTables.min.css"/>

		<title>总览</title>
	</head>

	<script type="application/javascript">
        var dataSet = [
				{ "Name":"Tiger Nixon", "Position":"System Architect", "Office":"Edinburgh", "Extn":"5421", "Start date":"2011/04/25", "Salary":"$320,800" },
				{ "Name" :"Garrett Winters","Position" : "Accountant", "Office" :"Tokyo", "Extn" :"8422", "Start date":"2011/07/25", "Salary":"$170,750" }
//            [ "Ashton Cox", "Junior Technical Author", "San Francisco", "1562", "2009/01/12", "$86,000" ],
//            [ "Cedric Kelly", "Senior Javascript Developer", "Edinburgh", "6224", "2012/03/29", "$433,060" ],
//            [ "Airi Satou", "Accountant", "Tokyo", "5407", "2008/11/28", "$162,700" ],
//            [ "Brielle Williamson", "Integration Specialist", "New York", "4804", "2012/12/02", "$372,000" ],
//            [ "Herrod Chandler", "Sales Assistant", "San Francisco", "9608", "2012/08/06", "$137,500" ],
//            [ "Rhona Davidson", "Integration Specialist", "Tokyo", "6200", "2010/10/14", "$327,900" ],
//            [ "Colleen Hurst", "Javascript Developer", "San Francisco", "2360", "2009/09/15", "$205,500" ],
//            [ "Sonya Frost", "Software Engineer", "Edinburgh", "1667", "2008/12/13", "$103,600" ],
//            [ "Jena Gaines", "Office Manager", "London", "3814", "2008/12/19", "$90,560" ],
//            [ "Quinn Flynn", "Support Lead", "Edinburgh", "9497", "2013/03/03", "$342,000" ],
//            [ "Charde Marshall", "Regional Director", "San Francisco", "6741", "2008/10/16", "$470,600" ],
//            [ "Haley Kennedy", "Senior Marketing Designer", "London", "3597", "2012/12/18", "$313,500" ],
//            [ "Tatyana Fitzpatrick", "Regional Director", "London", "1965", "2010/03/17", "$385,750" ],
//            [ "Michael Silva", "Marketing Designer", "London", "1581", "2012/11/27", "$198,500" ],
//            [ "Paul Byrd", "Chief Financial Officer (CFO)", "New York", "3059", "2010/06/09", "$725,000" ],
//            [ "Gloria Little", "Systems Administrator", "New York", "1721", "2009/04/10", "$237,500" ],
//            [ "Bradley Greer", "Software Engineer", "London", "2558", "2012/10/13", "$132,000" ],
//            [ "Dai Rios", "Personnel Lead", "Edinburgh", "2290", "2012/09/26", "$217,500" ],
//            [ "Jenette Caldwell", "Development Lead", "New York", "1937", "2011/09/03", "$345,000" ],
//            [ "Yuri Berry", "Chief Marketing Officer (CMO)", "New York", "6154", "2009/06/25", "$675,000" ],
//            [ "Caesar Vance", "Pre-Sales Support", "New York", "8330", "2011/12/12", "$106,450" ],
//            [ "Doris Wilder", "Sales Assistant", "Sidney", "3023", "2010/09/20", "$85,600" ],
//            [ "Angelica Ramos", "Chief Executive Officer (CEO)", "London", "5797", "2009/10/09", "$1,200,000" ],
//            [ "Gavin Joyce", "Developer", "Edinburgh", "8822", "2010/12/22", "$92,575" ],
//            [ "Jennifer Chang", "Regional Director", "Singapore", "9239", "2010/11/14", "$357,650" ],
//            [ "Brenden Wagner", "Software Engineer", "San Francisco", "1314", "2011/06/07", "$206,850" ],
//            [ "Fiona Green", "Chief Operating Officer (COO)", "San Francisco", "2947", "2010/03/11", "$850,000" ],
//            [ "Shou Itou", "Regional Marketing", "Tokyo", "8899", "2011/08/14", "$163,000" ],
//            [ "Michelle House", "Integration Specialist", "Sidney", "2769", "2011/06/02", "$95,400" ],
//            [ "Suki Burks", "Developer", "London", "6832", "2009/10/22", "$114,500" ],
//            [ "Prescott Bartlett", "Technical Author", "London", "3606", "2011/05/07", "$145,000" ],
//            [ "Gavin Cortez", "Team Leader", "San Francisco", "2860", "2008/10/26", "$235,500" ],
//            [ "Martena Mccray", "Post-Sales support", "Edinburgh", "8240", "2011/03/09", "$324,050" ],
//            [ "Unity Butler", "Marketing Designer", "San Francisco", "5384", "2009/12/09", "$85,675" ]
        ];
		$(function() {
			// Radialize the colors
			Highcharts.getOptions().colors = Highcharts.map(Highcharts.getOptions().colors, function(color) {
				return {
					radialGradient: {
						cx: 0.5,
						cy: 0.3,
						r: 0.7
					},
					stops: [
						[0, color],
						[1, Highcharts.Color(color).brighten(-0.3).get('rgb')] // darken
					]
				};
			});
			// Build the chart
			$('#a').highcharts({
				chart: {
					plotBackgroundColor: null,
					plotBorderWidth: null,
					plotShadow: false
				},
				title: {
					text: 'Browser market shares at a specific website, 2014'
				},
				tooltip: {
					pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>'
				},
				plotOptions: {
					pie: {
						allowPointSelect: true,
						cursor: 'pointer',
						dataLabels: {
							enabled: true,
							format: '<b>{point.name}</b>: {point.percentage:.1f} %',
							style: {
								color: (Highcharts.theme && Highcharts.theme.contrastTextColor) || 'black'
							},
							connectorColor: 'silver'
						}
					}
				},
				series: [{
					type: 'pie',
					name: 'Browser share',
					data: [
						['Firefox', 45.0],
						['IE', 26.8],
//						{
							//name: 'Chrome',
//							y: 12.8,
//							sliced: true,
//							selected: true
//						},
						['Safari', 8.5],
						['Opera', 6.2],
						['Others', 0.7]
					]
				}]
			});
		});

        $(document).ready(function() {
            $('#example').DataTable( {
                "dom": 'lrtip',
                "ajax": "data/test.txt",
				"language":{
                    "emptyTable":     "暂无数据",
                    "info":           "显示 _START_ to _END_ of _TOTAL_ 条数据",
                    "infoEmpty":      "显示 0 to 0 of 0 条数据",
                    "infoFiltered":   "(filtered from _MAX_ total entries)",
                    "infoPostFix":    "",
                    "thousands":      ",",
                    "lengthMenu":     "显示 _MENU_ 条数据",
                    "loadingRecords": "加载中",
                    "processing":     "检索中",
                    "search":         "查找",
                    "zeroRecords":    "没有找到数据",
                    "paginate": {
                        "first":      "第一页",
                        "last":       "最后一页",
                        "next":       "下一页",
                        "previous":   "上一页"
                    },
                    "aria": {
                        "sortAscending":  ": activate to sort column ascending",
                        "sortDescending": ": activate to sort column descending"
                    }
                },
                "columns": [
                    { "data": "name" },
                    { "data": "position"},
                    { "data": "office"},
                    { "data": "extn"},
                    { "data": "start_date" },
                    { "data": "salary" }
                ]
            } );
        } );
	</script>

	<body>

		<div id="a"></div>
		<div>
			<table id="example" class="row-border tabl" width="70%">
				<thead>
				<tr >
					<th rowspan="2">Name</th>
					<th rowspan="2">Position</th>
					<th colspan="2">office</th>
					<th colspan="2">start_date</th>
				</tr>
				<tr>
					<th>office</th>
					<th>extn</th>
					<th>start_date</th>
					<th>salary</th>
				</tr>
				</thead>
			</table>
		</div>

	</body>

</html>