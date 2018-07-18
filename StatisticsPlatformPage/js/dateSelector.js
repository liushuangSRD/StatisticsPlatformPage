
var startdate,enddate;

function dateSelector(startDateDiv, endDateDiv, callback) {

	var sd = {
		elem: '#' + startDateDiv,
		format: 'YYYY/MM/DD hh:mm:ss',
		min: '2015/01/01 00:00:00', //设定最小日期为当前日期
		max: '2099/06/16 23:59:59', //最大日期
		istime: true,
		istoday: false,
		choose: function(datas) {
			ed.min = datas; //开始日选好后，重置结束日的最小日期
			ed.start = datas; //将结束日的初始值设定为开始日
			startdate=datas;
			chooseDate(callback);
		}
	};
	laydate(sd);

	var ed = {
		elem: '#' + endDateDiv,
		format: 'YYYY/MM/DD hh:mm:ss',
		min: '2015/01/01 00:00:00',
		max: '2099/06/16 23:59:59',
		istime: true,
		istoday: false,
		choose: function(datas) {
			sd.max = datas; //结束日选好后，重置开始日的最大日期
			enddate=datas;
			chooseDate(callback);
		}
	};
	laydate(ed);

}

function chooseDate(callback) {
	if(isEmpty(startdate) || isEmpty(enddate)) {
		return false;
	}
	callback();
}