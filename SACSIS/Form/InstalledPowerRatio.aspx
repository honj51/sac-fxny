<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="InstalledPowerRatio.aspx.cs" Inherits="SACSIS.Form.InstalledPowerRatio" %>

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
                    alert(data.zjBl);
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
    <!--装机比率-->
   <div id="DivZJBL" style="width: 320px; height: 180px; float: left; margin: 5px">
   </div>
    <!--发电量比率-->
   <div id="DivFDLBL" style="width: 320px; height: 180px; float: left; margin: 5px">
   </div>
    </form>
</body>
</html>
