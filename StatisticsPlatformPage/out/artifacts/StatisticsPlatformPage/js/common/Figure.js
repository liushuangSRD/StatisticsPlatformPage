function Figure(name, data) {
	this.name = name;
	this.data = data;
	return this;
}

function chartOptions() {
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
    Highcharts.setOptions({
        lang: {
            noData:"暂无数据",
            resetZoom:"还原"
        }
    });
}

function lineChart(div, data, title, xAxis, yAxisTitle, suffix) {
	$('#' + div + '').highcharts({
		chart:{
            zoomType:"x"
		},
		title: {
			text: title,
			x: -20 //center
		},
		subtitle: {
			text: '',
			x: -20
		},
        credits:{
			enabled:false
			// href:"/StatisticsPlatformPage/index.jsp",
			// text:"沃橙"
		},
		xAxis: {
			categories: xAxis
		},
		yAxis: {
			title: {
				text: yAxisTitle
			},
			plotLines: [{
				value: 0,//设置基准线
				width: 1,
				color: '#808080'
			}]
		},
		plotOptions: {
			line: {
				dataLabels: {
					enabled: true
				},
				enableMouseTracking: true
			}
		},
		tooltip: {
			valueSuffix: suffix
		},
        noData:{
            style:{ "fontSize": "20px", "fontWeight": "bold", "color": "#666666" }
        },
		series: data
	});
}

function pieChart(div, data, title) {
	$('#' + div + '').highcharts({
		chart: {
			plotBackgroundColor: null,
			plotBorderWidth: null,
			plotShadow: false
		},
        credits:{
            enabled:false
            // href:"/StatisticsPlatformPage/index.jsp",
            // text:"沃橙"
        },
		title: {
			text: title
		},
		tooltip: {
			pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>'
		},
		plotOptions: {
			pie: {
				allowPointSelect: true,
				cursor: 'pointer',
				dataLabels: {
					enabled: false
				},
				showInLegend: true
			}
		},
        noData:{
            style:{ "fontSize": "20px", "fontWeight": "bold", "color": "#666666" }
        },
		series: [{
			type: 'pie',
			name: '占比',
			data: data
		}]
	});
}

function histogram(div, data, title, yAxis, suffix) {
	$('#' + div + '').highcharts({
		chart: {
			type: 'column'
		},
        credits:{
            enabled:false
            // href:"/StatisticsPlatformPage/index.jsp",
            // text:"沃橙"
        },
		title: {
			text: title
		},
		subtitle: {
			text: ''
		},
		xAxis: {
			type: 'category',
			labels: {
				rotation: -45,
				style: {
					fontSize: '13px',
					fontFamily: 'Verdana, sans-serif'
				}
			}
		},
		yAxis: {
			min: 0,
			title: {
				text: yAxis
			}
		},
		legend: {
			enabled: false
		},
		tooltip: {
			pointFormat: yAxis + ': <b>{point.y} ' + suffix + '</b>'
		},
		series: [{
			name: 'Population',
			data: data,
			dataLabels: {
				enabled: true,
				rotation: -90,
				color: '#FFFFFF',
				align: 'right',
				format: '{point.y}', // one decimal
				y: 10, // 10 pixels down from the top
				style: {
					fontSize: '13px',
					fontFamily: 'Verdana, sans-serif'
				}
			}
		}]
	});
}

function stackedHistogram(div, data, title, x, yAxis) {
	$('#upperFigure').highcharts({
		chart: {
			type: 'column'
		},
        credits:{
            enabled:false
            // href:"/StatisticsPlatformPage/index.jsp",
            // text:"沃橙"
        },
		title: {
			text: title
		},
		xAxis: {
			categories: x
		},
		yAxis: {
			min: 0,
			title: {
				text: yAxis
			},
			stackLabels: {
				enabled: true,
				style: {
					fontWeight: 'bold',
					color: (Highcharts.theme && Highcharts.theme.textColor) || 'gray'
				}
			}
		},
		legend: {
			align: 'right',
			verticalAlign: 'top',
			floating: true,
			backgroundColor: (Highcharts.theme && Highcharts.theme.background2) || 'white',
			borderColor: '#CCC',
			borderWidth: 1,
			shadow: false
		},
		tooltip: {
			formatter: function() {
				return '<b>' + this.x + '</b><br/>' +
					this.series.name + ': ' + this.y + '<br/>' +
					'Total: ' + this.point.stackTotal;
			}
		},
		plotOptions: {
			column: {
				stacking: 'normal',
				dataLabels: {
					enabled: true,
					color: (Highcharts.theme && Highcharts.theme.dataLabelsColor) || 'white',
					style: {
						textShadow: '0 0 3px black'
					}
				}
			}
		},
		series: data
	});
}