function LineStyle() {
    /*设置样式*/
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
            plotBorderWidth: 1
        },
        title: {
            style: {
                color: '#000',
                font: 'bold 16px "Trebuchet MS", Verdana, sans-serif'
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
                    fontSize: '12px',
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
                    fontSize: '12px',
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

    // Apply the theme
    var highchartsOptions = Highcharts.setOptions(Highcharts.theme);
    /*设置样式*/
}
function Hc() {
    var chart;
    Highcharts.theme = {
        colors: ['#058DC7', '#50B432', '#ED561B', '#DDDF00', '#24CBE5', '#64E572', '#FF9655', '#FFF263', '#6AF9C4'],
        chart: {
            backgroundColor: {
                linearGradient: [0, 0, 500, 500],
                stops: [
                    [0, 'rgb(255, 255, 255)'],
                    [1, 'rgb(240, 240, 255)']
                 ]
            },
            borderWidth: 2,
            plotBackgroundColor: 'rgba(255, 255, 255, .9)',
            plotShadow: true,
            plotBorderWidth: 1
        },
        title: {
            style: {
                color: '#000',
                font: 'bold 16px "Trebuchet MS", Verdana, sans-serif'
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
                    fontSize: '12px',
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
                    fontSize: '12px',
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
        }
    };
}
// Apply the theme


function getLine(list) {
    var highchartsOptions = Highcharts.setOptions(Highcharts.theme);
    chart = new Highcharts.Chart({
        chart: {
            renderTo: 'container',
            type: 'spline'
        },
        title: {
            text: list.title
        },
        //                    subtitle: {
        //                        text: 'An example of irregular time data in Highcharts JS'
        //                    },
        xAxis: {
            //            type: 'datetime',
            //            dateTimeLabelFormats:
            //                        {
            //                            second: '%H:%M:%S'
            //                        }
            title: {
                text: '风速(m/s)'
            }
            //,
            //categories: list.fs1
        },
        yAxis: {
            title: {
                text: '负荷(MW)'
            },
            labels: {
                formatter: function () {
                    return this.value;
                }
            },
            min: 0
        },
        legend: {
            layout: 'vertical',
            align: 'right',
            verticalAlign: 'middle',
            top:0,
            borderWidth: 0
        },
        tooltip: {
            crosshairs: {
                width: 2,
                color: 'red'
            },
            shared: true,
            xDateFormat: '<b>风速：</b>'
        },
        plotOptions: {
            spline: {
                lineWidth: 0.4,
                states: {
                    hover: {
                        lineWidth: 0.5
                    }
                },
                marker: {
                    enabled: false
                }//,
                //                            pointInterval: 3600000, // one hour
                //                            pointStart: Date.UTC(2009, 9, 6, 0, 0, 0)
            }
        },
        exporting: {
            enabled: false
        },
        series: list.list
    });
}
function SetLine(list) {
    var highchartsOptions = Highcharts.setOptions(Highcharts.theme);
    chart = new Highcharts.Chart({
        chart: {
            renderTo: 'container',
            type: 'spline'
        },
        title: {
            text: list.title
        },
        xAxis: {
            type: 'datetime',
            labels: {
                formatter: function () {
                    return Highcharts.dateFormat('%Y-%m-%d', this.value);
                }
            }
            //            dateTimeLabelFormats:
            //                        {
            //                            second: '%Y-%m-%d'
            //                        }
        },
        yAxis: {
            title: {
                text: list.title// 'Snow depth (m)'
            }//,
            //min: 0
        },
        tooltip: {/*设置数据显示样式及格式*/
            xDateFormat: '<b>' + '%Y-%m-%d %H:%M:%S' + '</b>',
            crosshairs: {
                width: 1,
                color: 'red'
            },
            shared: true
        },
        legend: {
            layout: 'vertical',
            align: 'right',
            verticalAlign: 'middle',
            top: 0,
            borderWidth: 0
        },
        plotOptions: {
            spline: {
                lineWidth: 0.4,
                states: {
                    hover: {
                        lineWidth: 0.5
                    }
                },
                marker: {
                    enabled: false
                }
            }
        },
        series: list.list
    });
}          