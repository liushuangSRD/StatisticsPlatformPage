
var map=new Map();
var versionMap = new Map();

var channels = [];
var versions = [];

function conditions(callback){
	// $(document).on("click", "#condition2 button", function() {
	// 	conditionClick(this);
	// 	callback();
	// });

	$(document).on("click", "#condition3 button", function() {
        conditionClick(this);
		//$(this).addClass("cur").siblings().removeClass("cur");
		callback();
	});

	$(document).on("click","#condition-game button",function(){
        conditionClick(this);
		//$(this).addClass("cur").siblings().removeClass("cur");
		//callback();
	});

	$("#condition4 button").click(function() {
		$(this).addClass('cur').siblings().removeClass('cur');
		//callback();
	});

	$("#condition5 span").click(function() {
		$(this).addClass('cur').siblings().removeClass('cur');
		//callback();
	});

    $(document).on("click", "#condition2 button", function() {
        if($(this).index() == 0) { //点击全部显示所有channel
            removeOthersClass(this);
            $("#condition3").html(getDefaultConditionHTML());
            var versionsSet = [];
            if($("#condition1").find('.cur').index()==0){
                $("#condition3").html(getDefaultConditionHTML);
                conditionHTMLArray($("#condition3"),versionMap.get("versionAll"));
			}else {
                $("#condition1").find(".cur").each(function () {
                    var province = $(this).text();
                    var channels = map.get(province);
                    for (var i = 0; i < channels.length; i++) {
                        var versions = versionMap.get(channels[i][0]);
                        for (var j = 0; j < versions.length; j++) {
                            if (versionsSet.indexOf(versions[j]) == -1) {
                                versionsSet.push(versions[j]);
                            }
                        }
                    }
                });
                $("#condition3").html(getDefaultConditionHTML);
                conditionHTMLArray($("#condition3"), versionsSet.sort());
            }

            if($(this).siblings('.cur').length >= 2){ // 该选项已经选了2个
                $('#condition1 button:disabled').each(function(){
                    var $this = $(this);
                    $this.removeAttr("disabled");
                });
                $('#condition3 button:disabled').each(function(){
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
          //  var channel = map.get($(this).text());
            if($(this).hasClass("cur")) { //其他元素，如果已经选中，取消当前省的channel
                $(this).find('img').remove();
                if ($(this).siblings('.cur').length == 0) { //如果是最后一个cur元素，取消后选中全部标签
                    $("#condition2 button:eq(0)").click();
                    return false;
                }
                var versionSet = [];
                $(this).siblings('.cur').each(function(){
                    var channels  = versionMap.get($(this).attr("val"));
                    for(var tt = 0;tt<channels.length;tt++){
                            if(versionSet.indexOf(channels[tt])==-1){
                                versionSet.push(channels[tt]);
                            }

                    }
                });
                $("#condition3").html(getDefaultConditionHTML);
                conditionHTMLArray($("#condition3"),versionSet.sort());

                //  //取消到少于2个
                if($(this).siblings('.cur').length ==1){
                    $('#condition1 button:disabled').each(function(){
                        var $this = $(this);
                        $this.removeAttr("disabled");
                    });
                    $('#condition3 button:disabled').each(function(){
                        var $this = $(this);
                        $this.removeAttr("disabled");
                    })
                }


            }else{ //新点击channel
                $(this).append(getCancelImg());
                if($("#condition2 button").eq(0).hasClass("cur")) {
                    $("#condition2 button").eq(0).removeClass("cur"); //取消第一个按钮的cur
                    $("#condition3").html(getDefaultConditionHTML);
                }
                var versionSet = [];
                $(this).siblings('.cur').each(function(){
					var versionsList = versionMap.get($(this).attr("val"));
					for(var jj=0;jj<versionsList.length;jj++){
						if(versionSet.indexOf(versionsList[jj])==-1){
                            versionSet.push(versionsList[jj])
						}
					}
                });
				var versionCurr = versionMap.get($(this).attr("val"));
                for(var jj=0;jj<versionCurr.length;jj++){
                    if(versionSet.indexOf(versionCurr[jj])==-1){
                        versionSet.push(versionCurr[jj])
                    }
                }
                $("#condition3").html(getDefaultConditionHTML);
                conditionHTMLArray($("#condition3"),versionSet.sort());

                if($(this).siblings('.cur').length ==1 && $(this).siblings('.cur').index()!=0){ //增加到2个
                    if($('#condition1').find('.cur').index()!=0){
                        $('#condition1').find('.cur').siblings().each(function(){
                            var $this = $(this);
                            if($this.index()!=0) {
                                $this.attr("disabled", "disabled");
                            }
                        });
                    }
                    if($('#condition3').find('.cur').index()!=0){
                        $('#condition3').find('.cur').siblings().each(function(){
                            var $this = $(this);
                            if($this.index()!=0) {
                                $this.attr("disabled", "disabled");
                            }
                        });
                    }
                }
                if($('#condition1').find('.cur').length>=2||$('#condition3').find('.cur').length>=2){
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
            $("#condition3").html(getDefaultConditionHTML);
            conditionHTMLArray($("#condition3"),versionMap.get("versionAll"));


            if($(this).siblings('.cur').length >= 2){ // 该选项已经选了2个
                $('#condition2 button:disabled').each(function(){
                    var $this = $(this);
                    $this.removeAttr("disabled");
                });
                $('#condition3 button:disabled').each(function(){
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
				var versionSet = [];
                $(this).siblings('.cur').each(function(){
                    var channels  = map.get($(this).text());
                    for(var tt = 0;tt<channels.length;tt++){
                    	var versions = versionMap.get(channels[tt][0]);
						for(var jj=0;jj<versions.length;jj++){
                    		if(versionSet.indexOf(versions[jj])==-1){
                                versionSet.push(versions[jj]);
							}
						}
					}
				});
                $("#condition3").html(getDefaultConditionHTML); //全部去掉 然后重新添加
                conditionHTMLArray($("#condition3"),versionSet.sort());

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
                    $('#condition3 button:disabled').each(function(){
                        var $this = $(this);
                        $this.removeAttr("disabled");
                    })
                }
			} else { //如果没有选中
				$(this).append(getCancelImg());
				if($("#condition1 button").eq(0).hasClass("cur")) {
					$("#condition1 button").eq(0).removeClass("cur"); //取消第一个按钮的cur
					$("#condition2").html(getDefaultConditionHTML);
                    $("#condition3").html(getDefaultConditionHTML);
				}
				conditionHTML($("#condition2"), c); //载入当前省份的信息

				var versionSet  = [];
                $(this).siblings('.cur').each(function(){
                    var channels  = map.get($(this).text());
                    for(var tt = 0;tt<channels.length;tt++){
                        var versions = versionMap.get(channels[tt][0]);
                        for(var jj=0;jj<versions.length;jj++){
                            if(versionSet.indexOf(versions[jj])==-1){
                                versionSet.push(versions[jj]);
                            }
                        }
                    }
                });
				for(var j = 0;j<c.length;j++){
                	for(var aa=0;aa<versionMap.get(c[j][0]).length;aa++){
                        if(versionSet.indexOf(versionMap.get(c[j][0])[aa])==-1){
                            versionSet.push(versionMap.get(c[j][0])[aa]);
						}
					}
				}
                $("#condition3").html(getDefaultConditionHTML);
				//如果增加都2个
                conditionHTMLArray($("#condition3"),versionSet.sort());
                if($(this).siblings('.cur').length ==1 && $(this).siblings('.cur').index()!=0){ //增加到2个
                    if($('#condition2').find('.cur').index()!=0){
                        $('#condition2').find('.cur').siblings().each(function(){
                            var $this = $(this);
                            if($this.index()!=0) {
                                $this.attr("disabled", "disabled");
                            }
                        });
                    }
                    if($('#condition3').find('.cur').index()!=0){
                        $('#condition3').find('.cur').siblings().each(function(){
                            var $this = $(this);
                            if($this.index()!=0) {
                                $this.attr("disabled", "disabled");
                            }
                        });
                    }
                }else{
                    if($('#condition2').find('.cur').length>=2||$('#condition3').find('.cur').length>=2){
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


function conditionClick(o) {
	var all = $(o).siblings().first();
	if($(o).index() == 0) { //点击全部
        if($(o).siblings('.cur').length >= 2){ // 该选项已经选了2个
			$('#condition1 button:disabled').each(function(){
				var $this = $(this);
                $this.removeAttr("disabled");
			});
			$('#condition2 button:disabled').each(function(){
				var $this = $(this);
                $this.removeAttr("disabled");
			})
		}else{
            $(o).each(function(){
                var $this = $(this);
                $this.removeAttr("disabled");
            })
		}
		removeOthersClass(o);
	} else {
		if($(o).hasClass('cur')) {
			$(o).find('img').remove();
			if($(o).siblings('.cur').length == 0) { //如果是最后一个cur元素，取消后选中全部标签
                $(all).click();
                $(o).removeAttr("disabled");
                $(o).siblings().each(function(){
                	$(this).removeAttr("disabled");
				});
				return false;
			}else if($(o).siblings('.cur').length ==1){//取消到少于2个
                $('#condition1 button:disabled').each(function(){
                    var $this = $(this);
                    $this.removeAttr("disabled");
                });
                $('#condition2 button:disabled').each(function(){
                    var $this = $(this);
                    $this.removeAttr("disabled");
                })
			}
		} else { //新点击
			$(o).append(getCancelImg());
			if($(o).siblings('.cur').length ==1 && $(o).siblings('.cur').index()!=0){ //增加到2个
				if($('#condition1').find('.cur').index()!=0){
                    $('#condition1').find('.cur').siblings().each(function(){
                    	var $this = $(this);
                    	if($this.index()!=0) {
                            $this.attr("disabled", "disabled");
                        }
					});
				}
                if($('#condition2').find('.cur').index()!=0){
                    $('#condition2').find('.cur').siblings().each(function(){
                        var $this = $(this);
                        if($this.index()!=0) {
                            $this.attr("disabled", "disabled");
                        }
                    });
                }
			}else{
                if($('#condition1').find('.cur').length>=2||$('#condition2').find('.cur').length>=2){
                    $(o).siblings().each(function(){
                    	var $this = $(this);
                    	if($this.index()!=0){
                            $this.attr("disabled","disabled");
						}
                    });
                }
			}
			if($(all).hasClass("cur")) {
				$(all).removeClass("cur"); //取消第一个按钮的cur
			}
		}
		$(o).toggleClass("cur");
	}
}
//点击全部按钮之后移除其他按钮的选中状态
function removeOthersClass(o) {
	$(o).siblings().removeClass("cur").find('img').remove();
	$(o).addClass("cur");
}

//取消图标
function getCancelImg() {
	return '<img src="images/x.jpg" alt="" width="22" height="24">';
}

//默认的全部按钮
function getDefaultConditionHTML() {
	return '<button type="button" class="cur btn2a">全部</button>';
}

function conditionHTML(o, arr) {
	for(var i = 0; i < arr.length; i++) {
		$(o).append('<button class="btn2a" type="button" val="'+arr[i][0]+'">' + arr[i][1] + '</button>');
	}
}
function conditionHTMLArray(o, arr) {
	if(!arr){
		return false;
	}
    for(var i = 0; i < arr.length; i++) {
        $(o).append('<button class="btn2a" type="button">' + arr[i] + '</button>');
    }
}

function loadConditions() {
    jsonpAjax("/common/version", "", true, function(data) {
        var obj = data.result;
        for(var i = 0; i < obj.length; i++) {
            versionMap.put(obj[i].key,obj[i].value);
        }
        var versionAll  = versionMap.get("versionAll");
        for(var j = 0;j<versionAll.length;j++){
            $("#condition3").append('<button class="btn2a" type="button">' + versionAll[j] + '</button>')
        }

    });
	jsonpAjax("/common/province", "", true, function(data) {
        var obj = data.result;
		for(var i = 0; i < obj.length; i++) {
			map.put(obj[i].key, obj[i].value);
			$("#condition1").append('<button class="btn2a" type="button" >' + obj[i].key + '</button>');
			for(var j = 0; j < obj[i].value.length; j++) {
				channels.push(obj[i].value[j]);
				$("#condition2").append('<button class="btn2a" type="button"  val="'+obj[i].value[j][0]+'">' + obj[i].value[j][1] + '</button>');
			}
		}
	});
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