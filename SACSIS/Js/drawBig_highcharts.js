
/*运营总览 场站监测中图放大及隐藏*/
function gets(j, t, y, v) {
    var chartObj = {
        chart: {
            type: 'spline',
            zoomType: 'xy',
            events: {
                // 点击图表后在指定区域 zoomUpDiv 放大显示  
                click: null
            }
        },
        title: {
            text: t
        },
        xAxis: {
            type: 'datetime',
            dateTimeLabelFormats: { // don't display the dummy year
                month: '%e. %b',
                year: '%b'
            }
        },
        plotOptions: {
            series: {
                marker: {
                    radius: 1,  //曲线点半径，默认是4
                    symbol: 'circle' //曲线点类型："circle", "square", "diamond", "triangle","triangle-down"，默认是"circle"
                },
                cursor: 'pointer'

            }

        },
        yAxis: y,
        tooltip: {

            crosshairs: {
                width: 2,
                color: 'red'
            },
            shared: true,

            xDateFormat: '时间：' + '%H:%M:%S'
        },
        series: v
    };



    // 点击图表后在指定区域 zoomUpDiv 放大显示  

    chartObj.chart.events.click = function (event) {
        var zoomUpDiv = $('#zoomUpDiv');
        if (zoomUpDiv != null) {
//            $("#zoomUpDiv").css("height", $(document).height());
//            $("#zoomUpDiv").css("width", $(document).width());
            $("#zoomUpDiv").show();
            $("#AllDiv").addClass("bodys");
            //$('#zoomUpDiv').css('display', 'block');
            //$('.chartdiv').css('display', 'none');
            chartObj.chart.events.click = function (event) {
                $('#zoomUpDiv').css('display', 'none');
                $("#AllDiv").removeClass("bodys");
                //$('.chartdiv').css('display', 'block');
            };
            $('#zoomUpDiv').highcharts(chartObj);

        }
    };
    $('#Div' + j + '').highcharts(chartObj);
}

/*首页->区域->场站->机组 机组的显示与隐藏*/
function display(t,y,v) {
    var chartObj = {
        chart: {
            type: 'spline',
            zoomType: 'xy',
            events: {
                // 点击图表后在指定区域 zoomUpDiv 放大显示  
                click: null
            }
        },
        title: {
            text: t
        },
        xAxis: {
            type: 'datetime',
            dateTimeLabelFormats: { // don't display the dummy year
                month: '%e. %b',
                year: '%b'
            }
        },
        plotOptions: {
            series: {
                marker: {
                    radius: 1,  //曲线点半径，默认是4
                    symbol: 'circle' //曲线点类型："circle", "square", "diamond", "triangle","triangle-down"，默认是"circle"
                },
                cursor: 'pointer'

            }

        },
        yAxis: y,
        tooltip: {

            crosshairs: {
                width: 2,
                color: 'red'
            },
            shared: true,

            xDateFormat: '时间：' + '%H:%M:%S'
        },
        series: v
    };
    chartObj.chart.events.click = function (event) {
        var zoomUpDiv = $('#zoomUpDiv');
        if (zoomUpDiv != null) {
            $('#zoomUpDiv').css('display', 'none');
            $("#AllDiv").removeClass("bodys");
        }
    }
    $('#zoomUpDiv').highcharts(chartObj);
}

Highcharts.theme = {
    colors: ['#058DC7', '#50B432', '#ED561B', '#DDDF00', '#24CBE5', '#64E572', '#FF9655', '#FFF263', '#6AF9C4'],
    chart: {
        backgroundColor: {
            linearGradient: { x1: 0, y1: 0, x2: 1, y2: 1 },
            stops: [
            [0, 'rgb(255, 255, 255)'],
            [1, 'rgb(240, 240, 255)']
         ]
        },
        borderWidth: 2,
        plotBackgroundColor: 'rgba(255, 255, 255, .9)',
        plotShadow: true,
        plotBorderWidth: 1,
        plotBackgroundImage: '../img/skies.jpg'
    },
    title: {
        style: {
            color: '#000',
            font: 'bold 12px "Trebuchet MS", Verdana, sans-serif'
        }
    },
    subtitle: {
        style: {
            color: '#666666',
            font: 'bold 12px "Trebuchet MS", Verdana, sans-serif'
        }
    },
    xAxis: {
        gridLineWidth: 1,
        lineColor: '#000',
        tickColor: '#000',
        labels: {
            style: {
                color: '#000',
                font: '11px Trebuchet MS, Verdana, sans-serif'
            }
        },
        title: {
            style: {
                color: '#333',
                fontWeight: 'bold',
                fontSize: '10px',
                fontFamily: 'Trebuchet MS, Verdana, sans-serif'

            }
        }
    },
    yAxis: {
        minorTickInterval: 'auto',
        lineColor: '#000',
        lineWidth: 1,
        tickWidth: 1,
        tickColor: '#000',
        labels: {
            style: {
                color: '#000',
                font: '11px Trebuchet MS, Verdana, sans-serif'
            }
        },
        title: {
            style: {
                color: '#333',
                fontWeight: 'bold',
                fontSize: '10px',
                fontFamily: 'Trebuchet MS, Verdana, sans-serif'
            }
        }
    },
    legend: {
        itemStyle: {
            font: '9pt Trebuchet MS, Verdana, sans-serif',
            color: 'black'

        },
        itemHoverStyle: {
            color: '#039'
        },
        itemHiddenStyle: {
            color: 'gray'
        }
    },
    labels: {
        style: {
            color: '#99b'
        }
    },

    navigation: {
        buttonOptions: {
            theme: {
                stroke: '#CCCCCC'
            }
        }
    }
};