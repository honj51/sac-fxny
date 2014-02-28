<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="InstalledPowerRatio.aspx.cs"
    Inherits="SACSIS.Form.InstalledPowerRatio" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script src="../Js/jquery-1.8.2.min.js" type="text/javascript"></script>
    <script src="../Js/jquery.easyui.min.js" type="text/javascript"></script>
    <link href="../Js/jQueryEasyUI/themes/default/easyui.css" rel="stylesheet" type="text/css" />
    <link href="../Js/jQueryEasyUI/themes/icon.css" rel="stylesheet" type="text/css" />
    <script src="../Js/highcharts.js" type="text/javascript"></script>
    <script src="../Js/exporting.js" type="text/javascript"></script>
    <script type="text/javascript">

        $(document).ready(function () {
            // $("#btn").click();
            inite();
            var highchartsOptions = Highcharts.setOptions(Highcharts.theme);
            //SetStyle();
        });
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
        var inite = function () {
            $("#imgs").css("display", "block");

            $.ajax({
                url: "InstalledPowerRatio.aspx",
                type: "GET",
                data: { funCode: 'init' },
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (data) {
                    //alert("1");
                    $("#imgs").css("display", "none");
                    //装机比率
                    $('#DivZJBL').highcharts({
                        chart: {
                            plotBackgroundColor: null,
                            plotBorderWidth: null,
                            plotShadow: false,
                            margin: [5, 80, 5, 5]
                        },
                        title: {
                            align: 'left',
                            text: '装机比率',
                            style:
                        {
                            color: '#3E576F',
                            fontSize: '14px',
                            fontFamily: '微软雅黑'
                        }
                        },
                        tooltip: {
                            pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b><br />容量:<b>{point.y}<b>',
                            percentageDecimals: 1
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
                        series: [{
                            type: 'pie',
                            name: '装机比率',
                            data: $.parseJSON(data.zjBl)
                        }],
                        exporting: {
                            enabled: false //用来设置是否显示‘打印’,'导出'等功能按钮，不设置时默认为显示 
                        },
                        legend: {
                            layout: 'vertical',
                            align: 'right',
                            itemStyle: {
                                cursor: 'pointer',
                                color: 'black',
                                fontSize: '14px',
                                fontFamily: '微软雅黑'
                            },
                            verticalAlign: 'middle'
                        }
                    });
                    //发电量比率
                    $('#DivFDLBL').highcharts({
                        chart: {
                            plotBackgroundColor: null,
                            plotBorderWidth: null,
                            plotShadow: false,
                            margin: [5, 80, 5, 5]
                        },
                        title: {
                            align: 'left',
                            text: '发电量比率',
                            style:
                                            {
                                                color: '#3E576F',
                                                fontSize: '14px',
                                                fontFamily: '微软雅黑'
                                            }
                        },
                        tooltip: {
                            pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b><br />发电量:<b>{point.y}<b>',
                            percentageDecimals: 1
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
                        series: [{
                            type: 'pie',
                            name: '发电量比率',
                            data: $.parseJSON(data.fdlBl)
                        }],
                        exporting: {
                            enabled: false //用来设置是否显示‘打印’,'导出'等功能按钮，不设置时默认为显示 
                        },
                        legend: {
                            layout: 'vertical',
                            align: 'right',
                            itemStyle: {
                                cursor: 'pointer',
                                color: 'black',
                                fontSize: '14px',
                                fontFamily: '微软雅黑'
                            },
                            verticalAlign: 'middle'
                        }
                    });

                    //投产比率
                    var colors = Highcharts.getOptions().colors;
                    categories = ['风电', '火电', '水电', '太阳能', '分布式', '生物质'];
                    name = 'Browser brands';
                    data = [{
                        y: $.parseJSON(data.tcRl)[0].y,
                        color: colors[0],
                        drilldown: {
                            name: '风电',
                            categories: ['风电投产', '风电在建', '风电接入'],
                            data: $.parseJSON(data.tcRl)[0].data,
                            color: colors[0]
                        }
                    }, {
                        y: $.parseJSON(data.tcRl)[1].y,
                        color: colors[1],
                        drilldown: {
                            name: '火电',
                            categories: ['火电投产', '火电在建', '火电接入'],
                            data: $.parseJSON(data.tcRl)[1].data,
                            color: colors[1]
                        }
                    }, {
                        y: $.parseJSON(data.tcRl)[2].y,
                        color: colors[2],
                        drilldown: {
                            name: '水电',
                            categories: ['水电投产', '水电在建', '水电接入'],
                            data: $.parseJSON(data.tcRl)[2].data,
                            color: colors[2]
                        }
                    }, {
                        y: $.parseJSON(data.tcRl)[3].y,
                        color: colors[3],
                        drilldown: {
                            name: '太阳能',
                            categories: ['太阳能投产', '太阳能在建', '太阳能接入'],
                            data: $.parseJSON(data.tcRl)[3].data,
                            color: colors[3]
                        }
                    }, {
                        y: $.parseJSON(data.tcRl)[4].y,
                        color: colors[4],
                        drilldown: {
                            name: '分布式',
                            categories: ['分布式投产', '分布式在建', '分布式接入'],
                            data: $.parseJSON(data.tcRl)[4].data,
                            color: colors[4]
                        }
                    }, {
                        y: $.parseJSON(data.tcRl)[5].y,
                        color: colors[5],
                        drilldown: {
                            name: '生物质',
                            categories: ['生物质投产', '生物质在建', '生物质接入'],
                            data: $.parseJSON(data.tcRl)[5].data,
                            color: colors[4]
                        }
                    }];


                    // Build the data arrays
                    var browserData = [];
                    var versionsData = [];
                    for (var i = 0; i < data.length; i++) {

                        // add browser data
                        browserData.push({
                            name: categories[i],
                            y: data[i].y,
                            color: data[i].color
                        });

                        // add version data
                        for (var j = 0; j < data[i].drilldown.data.length; j++) {
                            var brightness = 0.2 - (j / data[i].drilldown.data.length) / 5;
                            versionsData.push({
                                name: data[i].drilldown.categories[j],
                                y: data[i].drilldown.data[j],
                                color: Highcharts.Color(data[i].color).brighten(brightness).get()
                            });
                        }
                    }

                    // Create the chart
                    $('#DivTCBL').highcharts({
                        chart: {
                            type: 'pie'
                        },
                        title: {
                            text: '投产情况比率'
                        },
                        yAxis: {
                            title: {
                                text: '值'
                            }
                        },
                        //                        plotOptions: {
                        //                            pie: {
                        //                                shadow: true,
                        //                                center: ['50%', '50%']
                        //                            }
                        //                        },
                        plotOptions: {
                            pie: {
                                allowPointSelect: true,
                                cursor: 'pointer',
                                dataLabels: {
                                    enabled: true
                                },
                                showInLegend: true
                            }
                        },
                        tooltip: {
                            valueSuffix: '',
                            pointFormat: '值:<b>{point.y}<b><br />比例: <b>{point.percentage:.1f}%</b>',
                            percentageDecimals: 1
                        },
                        series: [{
                            name: '值',
                            data: browserData,
                            size: '60%',
                            dataLabels: {
                                formatter: function () {
                                    return this.point.name;
                                },
                                color: 'white',
                                distance: -30
                            }
                        }, {
                            name: '值',
                            data: versionsData,
                            size: '80%',
                            innerSize: '60%',
                            dataLabels: {
                                formatter: function () {
                                    // display only if larger than 1
                                    return '<b>' + this.point.name + ':</b> ' + this.y + '';
                                }
                                //enabled:false
                            }
                        }]
                    });
                }
            })
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
    <div id="imgs" style="margin-top: 150px; text-align: center; display: none;">
        <img id="imgId" alt="" src="../img/loading.gif" /><br />
        正在加载，请稍后......
    </div>
    <div style="width:100%"> 
    <!--装机比率-->
    <div id="DivZJBL" style="width: 350px; height: 180px; float: left; margin: 5px">
    </div>
    <!--发电量比率-->
    <div id="DivFDLBL" style="width: 350px; height: 180px; float: left; margin: 5px">
    </div>
    <br />
    <!--投产比率比率-->
    <div id="DivTCBL" style="width: 700px; height: 400px; float: left; margin: 5px">
    </div>
    </div>
    </form>
</body>
</html>
