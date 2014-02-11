<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ProductionOverview.aspx.cs" Inherits="SACSIS.ProductionOverview" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <script src="Js/jquery-1.8.2.min.js" type="text/javascript"></script>
    <script src="Js/highcharts.js" type="text/javascript"></script>
    <script src="Js/exporting.js" type="text/javascript"></script>
    <script src="Js/data.js" type="text/javascript"></script>
    <script src="Js/Chart.js" type="text/javascript"></script>
    <script src="Js/highcharts-more.js" type="text/javascript"></script>
    <title></title>
        <script type="text/javascript" language="javascript">

        $(document).ready(function () {
            SetChartData1(div_chart_one);
            SetChartData1(div_chart_two);
            SetChartData1(div_chart_three);
            SetChartData1(div_chart_four);
            SetChartDataBing("pi");//饼图
            SetChartDataBing("pi1");
            SetChartDataZhu("zhu1");
            SetChartDataZhu("zhu2");
            window.setInterval(GetHisData, 10000);

            
            initChart();

        });
        //仪表图
        var SetChartData1 = function (a) {
            var chart = new Highcharts.Chart({
                chart: {
                    renderTo: a,
                    type: 'gauge',
                    backgroundColor: 'rgba(255, 255, 255, 0)',
                    plotBorderColor: null,
                    plotBackgroundColor: null,
                    plotBackgroundImage: null,
                    plotBorderWidth: null,
                    plotShadow: false,
                    borderWidth: 0,
                    plotBorderWidth: 0,
                    spacingTop: 0,            //图表上方的空白(好用)
                    spacingRight: 0,
                    spacingBottom: 0,
                    spacingLeft: 0
 
                },

                title: {
                    text: ''
                },

                pane: {
                    startAngle: -150,
                    endAngle: 150,
                    background: [{
                        backgroundColor: {
                            linearGradient: { x1: 0, y1: 0, x2: 0, y2: 1 },
                            stops: [
	                    [0, '#FFF'],
	                    [1, '#333']
	                ]
                        },
                        borderWidth: 0,
                        outerRadius: '109%'
                    }, {
                        backgroundColor: {
                            linearGradient: { x1: 0, y1: 0, x2: 0, y2: 1 },
                            stops: [
	                    [0, '#333'],
	                    [1, '#FFF']
	                ]
                        },
                        borderWidth: 1,
                        outerRadius: '107%'
                    }, {
                    // default background
                }, {
                    backgroundColor: '#DDD',
                    borderWidth: 0,
                    outerRadius: '105%',
                    innerRadius: '103%'
                }]
            },

            // the value axis
            yAxis: {
                min: 0,
                max: 15,

                minorTickInterval: 'auto',
                minorTickWidth: 1,
                minorTickLength: 10,
                minorTickPosition: 'inside',
                minorTickColor: '#666',

                tickPixelInterval: 30,
                tickWidth: 2,
                tickPosition: 'inside',
                tickLength: 10,
                tickColor: '#666',
                labels: {
                    step: 2,
                    rotation: 'auto'
                },
                title: {
                    text: ''
                },
                plotBands: [{
                    from: 0,
                    to: 15,
                    color: '#2cc248' // red
                }]
            },

            series: [{
                name: '负荷',
                data: [11],
                tooltip: {
                    valueSuffix: '万千瓦时'
                }
            }],
            exporting: {
                enabled: false //用来设置是否显示‘打印’,'导出'等功能按钮，不设置时默认为显示 
            }

        });
    }
    // 曲线图
         $(function () {
            $('#qxt').highcharts({
                chart: {
                    type: 'area'
                },
                title: {
                    text: ''
                },
                subtitle: {
                    text: ''
                },
                xAxis: {
                    labels: {
                        formatter: function () {
                            return this.value; // clean, unformatted number for year
                        }
                    }
                },
                yAxis: {
                    title: {
                        text: ''
                    },
                    labels: {
                        formatter: function () {
                            return this.value / 10000;
                        }
                    }
                },
                tooltip: {
                    pointFormat: '总发电量:{point.y:,.0f}'
                },
                plotOptions: {
                    area: {
                        pointStart: 1,
                        marker: {
                            enabled: false,
                            symbol: 'circle',
                            radius: 2,
                            states: {
                                hover: {
                                    enabled: true
                                }
                            }
                        }
                    }
                },
                exporting: {
                enabled: false //用来设置是否显示‘打印’,'导出'等功能按钮，不设置时默认为显示 
            },
                series: [{
                    name: '总电量',
                    data: [12144, 11009, 10950, 10871, 10824, 10577, 10527, 10475, 10421, 10358, 10295, 10104]
                }, {
                    name: '发电量',
                    data: [660, 869, 1060, 1605, 2471, 3322, 4238, 5221, 6129, 7089, 8339, 9399]
                }]
            });
        });

    
    <%--饼图--%>
    var SetChartDataBing = function (a) {
       var  chart = new Highcharts.Chart({
                    chart: {
                        renderTo: a,
                        backgroundColor: '#e7ebef',
                        plotBackgroundColor: '#f3f6f8',
                        plotBackgroundColor:  null,
                        plotBorderWidth: null,
                        plotShadow: false,
                        spacingTop: 0,            //图表上方的空白(好用)
                        spacingRight: 0,
                        spacingBottom: 0,
                        spacingLeft: 0
                    },                   
                    width: 400,//图框（最外层）宽(默认800)
                    height: 250,                  
                    title: {
                        text: ''
                    },
                    tooltip: {
                        formatter: function () {
                            return '<b>' + this.point.name + '</b>: ' + this.percentage + ' %';
                        }
                    },
                    plotOptions: {
                        pie: {
                            allowPointSelect: true,
                            cursor: 'pointer',
                            dataLabels: {
                                enabled: false,
                                color: '#000000',
                                connectorColor: '#000000',
                                formatter: function () {
                                    return '';
                                }
                            },
                            showInLegend: true
                        }
                    },
                    legend: {
                        layout: 'vertical',
                        backgroundColor: '#FFFFFF',
                        align: 'left',
                        verticalAlign: 'top',
                        x: 10,
                        y: 0,
                        floating: true,
                        shadow: true
                    },
                    exporting: {
                enabled: false //用来设置是否显示‘打印’,'导出'等功能按钮，不设置时默认为显示 
            },
                    series: [{
                        type: 'pie',
                        name: '完成计划情况',
                        data: [
                                ['在建容量', 35.0],
                                ['月计划投产', 65.0],
                                ['月实际投产', 65.0]                  
                            ]
                    }]
                });

}

function GetHisData()
{
$.post("DrawView.aspx", { rating: "test" }, function (data) {
            SetChartData(data);
        }, 'json');
}

var initChart = function () {
        var dataJson;
        var ss;
        var pName = "test";
        //pName = GetQueryString("pName");

        $.ajax({
            url: "../WebService/WebService.asmx/GetFHByTimeByFourMin",
            contentType: "application/json; charset=utf-8",
            type: "POST",
            dataType: "json",
            data: "{'pName':'" + pName + "'}", // 
            beforeSend: function () {
                //Handle the beforeSend event
            },
            success: function (json) {
                dataJson = $.parseJSON(json.d);
                SetChartData();
            },
            error: function (x, e) {
                //alert(x.responseText);
            },
            complete: function () {
                //Handle the complete event
            }
        });

        var SetChartData = function () {
            var chart = new Highcharts.Chart({
                chart: {
                    renderTo: 'glqx',
                    type: 'spline',
                    backgroundColor: '#e7ebef',
                    plotBackgroundColor: '#f3f6f8',
                    spacingTop: 0,            //图表上方的空白(好用)
                    spacingRight: 0,
                    spacingBottom: 0,
                    spacingLeft: 0
                },
                credits: {
                    enabled: false
                },


                title: {
                    text: '',
                    style: {
                        fontFamily: '"微软雅黑"',
                        fontSize: '14pt'
                    }
                },
                subtitle: {
                    enable: false
                },
                xAxis: {
                    type: 'datetime',
                    dateTimeLabelFormats: {
                        day: '00:00'
                    },
                    maxZoom: 2 * 3600 * 1000,
                    showFirstLabel: true,
                    showLastLabel: true,
                    tickWidth: 0,
                    gridLineWidth: 1

                },
                yAxis: {
                    title: {
                        text: ''
                    },
                    labels: {
                        formatter: function () {
                            return this.value;
                        }
                    }
                },
                legend: {
            },
            tooltip: {
                crosshairs: {
                    width: 2,
                    color: 'red'
                },
                shared: true,
                xDateFormat: '<b>时间：%H:%M:%S</b>'
                //xDateFormat:'<b>时间：%Y-%m-%d %H:%M:%S</b>'
            },
            plotOptions: {
                spline: {
                    lineWidth: 5,
                    marker: {
                        enabled: false,
                        radius: 4,
                        lineColor: '#666666',
                        lineWidth: 1
                    }
                }
            },
            series: [{
                name: '实时负荷',
                lineWidth: 3,
                marker: {
                    symbol: 'circle'
                },
                color: 'green',
                data: dataJson.fh,
                pointStart: Date.UTC(2012, 3, 26),
                pointInterval: 3600 * 1000 //5min
            }],
            exporting: {
                enabled: false
            }
        });
    };
}

//柱状图
 function SetChartDataZhu(zhu) {
       var  chart = new Highcharts.Chart({
                    chart:  {
                    renderTo: zhu,
                type: 'column'
            },
            title: {
                text: ''
            },
            subtitle: {
                text: ''
            },
            xAxis: {
                categories: [
                   
                ]
            },
            yAxis: {
                min: 0,
                title: {
                    text: ''
                }
            },
            tooltip: {
                headerFormat: '<span style="font-size:10px">{point.key}</span><table>',
                pointFormat: '<tr><td style="color:{series.color};padding:0">{series.name}: </td>' +
                    '<td style="padding:0"><b>{point.y:.1f} 亿千瓦时</b></td></tr>',
                footerFormat: '</table>',
                shared: true,
                useHTML: true
            },
            plotOptions: {
                column: {
                    pointPadding: 0.2,
                    borderWidth: 0
                }
            },
                       exporting: {
                       enabled: false
            },
            series: [{
                name: '实际',
                data: [49.9, 71.5,50,20,30,34,12,23,43,54,123]
    
            },{
                name: '计划',
                data: [42.4, 33.2,40,40,32,54,54,42,23,43,23]
    
            }]
        });
    };
    function formatDate(now) {
    var year = now.getYear();
    var month = now.getMonth() + 1;
    var date = now.getDate();
    var hour = now.getHours();
    var minute = now.getMinutes();
    var second = now.getSeconds();
    return year + "-" + month + "-" + date + "   " + hour + ":" + minute + ":" + second;
    }
    </script>
    <style type="text/css">
        .style1
        {
            height: 35px;
        }
        .style2
        {
            height: 119px;
        }
        .style3
        {
            height: 30px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
    <div id="div" style="margin:auto; text-align:center;width:1100px">
        <div id="div1" style="width: 300px; height: 220px; border: solid 1px #8C9EB5; float: left;margin: 2px">
            <div id="div1_title" style="background-image: url(../img/20131119103518.jpg);
                width: 300px; height: 19px; background-repeat: repeat-x; border-bottom: solid 1px #8C9EB5; font-family:SimHei; font-size:14px; line-height:20px">实时负荷对比
            </div>
            <div id="qxt" style="width:300px; height:200px">
            </div>
        </div>
        <div id="div2" style="width: 500px; height: 220px; border: solid 1px #8C9EB5; float: left;
            margin: 2px">
            <div id="div7" style="background-image: url(../img/20131119103518.jpg);
                width: 500px; height: 19px; background-repeat: repeat-x; border-bottom: solid 1px #8C9EB5 ;font-family:SimHei; font-size:14px; line-height:20px">总装机量
            </div>
            <div id="d2" style="width: 503px; height: 200px">
                <table>
                    <tr>
                        <td align="center" valign="middle" style="font-size: 13px" class="style3">
                             装机容量
                        </td>
                        <td align="center" valign="middle" style="font-size: 13px" class="style3">
                            实时负荷
                        </td>
                        <td align="center" valign="middle" style="font-size: 13px" class="style3">
                            上网电量
                        </td>
                        <td align="center" valign="middle" style="font-size: 13px" class="style3">
                            发电量
                        </td>
                    </tr>
                    <tr>
                        <td align="left" valign="top" class="style2">
                            <div style="width: 120px; height: 120px; margin: 0 auto" id="div_chart_one">
                            </div>
                        </td>
                        <td align="right" valign="top" class="style2">
                            <div style="width: 120px; height: 120px; margin: 0 auto" id="div_chart_two">
                            </div>
                        </td>
                        <td align="left" valign="top" class="style2">
                            <div style="width: 120px; height: 120px; margin: 0 auto" id="div_chart_three">
                            </div>
                        </td>
                        <td align="right" valign="top" class="style2">
                            <div style="width: 120px; height: 120px; margin: 0 auto" id="div_chart_four">
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td align="center" valign="middle" style="font-size: 13px" class="style1">
                             330万千瓦时
                        </td>
                        <td align="center" valign="middle" style="font-size: 13px" class="style1">
                            350万千瓦时
                        </td>
                        <td align="center" valign="middle" style="font-size: 13px" class="style1">
                            20000万千瓦时
                        </td>
                        <td align="center" valign="middle" style="font-size: 13px" class="style1">
                            15000万千瓦时
                        </td>
                    </tr>
                </table>
            </div>
        </div>
        <div id="div3" style="width: 250px; height: 220px; border: solid 1px #8C9EB5; float: left; margin: 2px">
            <div id="div8" style=" background-image: url(../img/20131119103518.jpg);
                width: 250px; height: 19px; background-repeat: repeat-x; border-bottom: solid 1px #8C9EB5;font-family:SimHei; font-size:14px; line-height:20px">成本效益指标展示
            </div>
            <div id="d3" style="width:250px; height:200px">
            </div>
        </div>
        <div id="div4" style="width: 300px; height: 320px; border: solid 1px #8C9EB5; float: left; margin: 2px">
            <div id="div9" style="background-image: url(../img/20131119103518.jpg);
                width: 300px; height: 19px; background-repeat: repeat-x; border-bottom: solid 1px #8C9EB5;font-family:SimHei; font-size:14px; line-height:20px">发电量计划完成情况
            </div>
            <div id="d4" style="width: 300px; height: 300px">
                <div id="zhu1" style="width: 300px; height: 140px">
                </div>
                <div id="zhu2" style="width: 300px; height: 140px">
                </div>
            </div>
        </div>
        <div id="div5" style="width: 500px; height: 320px; border: solid 1px #8C9EB5; float: left;
            margin: 2px">
            <div id="div10" style="background-image: url(../img/20131119103518.jpg);
                width: 500px; height: 19px; background-repeat: repeat-x; border-bottom: solid 1px #8C9EB5;font-family:SimHei; font-size:14px; line-height:20px">项目分布图
            </div>
            <div id="d5" style="width: 500px; height: 300px">
            </div>
        </div>
        <div id="div6" style="width: 250px; height: 320px; border: solid 1px #8C9EB5; float: left;
            margin: 2px">
            <div id="div11" style=" background-image: url(../img/20131119103518.jpg);
                width: 250px; height: 19px; background-repeat: repeat-x; border-bottom: solid 1px #8C9EB5;font-family:SimHei; font-size:14px; line-height:20px">在建项目进度情况
            </div>
            <div id="d6" style="width: 250px; height: 300px">
                <div id="pi" style="width: 250px; height: 150px">
                </div>
                <div id="pi1" style="width: 250px; height: 150px">
                </div>
            </div>
        </div>
    </div>
    </form>
</body>
</html>
