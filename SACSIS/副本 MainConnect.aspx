<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="MainConnect.aspx.cs" Inherits="WebApplication2.MainConnect" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>总公司情况</title>
    <link href="css/main.css" rel="stylesheet" type="text/css" />
    <link href="../Js/jQueryEasyUI/themes/default/easyui.css" rel="stylesheet" type="text/css" />
    <link href="../Js/jQueryEasyUI/themes/icon.css" rel="stylesheet" type="text/css" />
    <script src="../Js/jquery-1.8.2.min.js" type="text/javascript"></script>
    <script src="../Js/jquery.easyui.min.js" type="text/javascript"></script>
    <script src="../Js/highcharts.js" type="text/javascript"></script>
    <script src="../Js/highcharts-more.js" type="text/javascript"></script>
    <script src="../Js/exporting.js" type="text/javascript"></script>
    <style type="text/css">
        body
        {
            font-family: 微软雅黑;
        }
        #tabId td
        {
            border: solid thin #6BA5BD;
        }
        
        
        #gmap
        {
            display: block;
            width: 996px;
            height: 765px;
            background: url(img/map.jpg) no-repeat;
            position: relative;
            margin: 0 auto;
        }
        #gmap a
        {
            color: #000;
            font-family: arial, sans-serif;
            font-size: 11px;
            text-transform: uppercase;
            text-decoration: none;
        }
        #gmap a:hover
        {
            overflow: visible;
            text-indent: -9000px;
        }
        a#title2, a#title2:visited
        {
            display: block;
            width: 996px;
            height: 765px;
            position: absolute;
            left: 0;
            top: 0;
            cursor: default;
            text-decoration: none;
        }
        * html #title2
        {
            height: 765px;
        }
        /*IE6.0以下中显示*/
        
        /*内蒙古*/
        a#lmg
        {
            display: block;
            width: 341px;
            height: 0px;
            padding-top: 302px;
            overflow: hidden;
            position: absolute;
            left: 363px;
            top: 40px;
        }
        * html #lmg
        {
            height: 2px;
        }
        a#lmg:hover
        {
            background: transparent url(img/lm.gif) no-repeat 0 0;
        }
    </style>
    <script type="text/javascript" language="javascript">
        var arr = new Array();

        var PieArr = new Array();
        $(function () {


            LOADCHARTS();

            $.ajax({
                url: "MainConnect.aspx?funCode=init",
                type: "POST",
                beforeSend: function () {
                    //Handle the beforeSend event
                },
                success: function (json) {
                    //json = eval("("+json+")");
                    var json = $.parseJSON(json);
                    //总容量 产业容量 
                    $("#ZRL").html("装机容量</br>" + json.ZRL + "MW");
                    $("#HDRL").html(json.HDRL); arr[0] = json.HDRL;
                    $("#FDRL").html(json.FDRL); arr[1] = json.FDRL;
                    $("#SDRL").html(json.SDRL); arr[2] = json.SDRL;
                    $("#TYNRL").html(json.TYNRL); arr[3] = json.TYNRL;
                    $("#FBSRL").html(json.FBSRL); arr[4] = json.FBSRL;
                    $("#SRZRL").html(json.SRZRL); arr[5] = json.SRZRL;

                    //总负荷 产业负荷
                    $("#ZFH").html("有功功率</br>" + (json.ZFH + json.SDFH + json.HDFH).toFixed(3) + "MW");
                    //$("#FDFH").html(json.FDFH);
                    $("#HDFH").html(json.HDFH);
                    $("#SDFH").html(json.SDFH);
                    $("#TYNFH").html(json.TYNFH);
                    $("#FBSFH").html(json.FBSFH);
                    $("#SRZFH").html(json.SRZFH);


                    //日月电量
                    $("#DDL").html("日发电量</br>" + (json.DDL + json.HDDDL + json.SDDDL).toFixed(3) + "万kWh");
                    $("#FDDDL").html(json.FDDDL);
                    $("#HDDDL").html(json.HDDDL);
                    $("#SDDDL").html(json.SDDDL);
                    $("#TYNDDL").html(json.TYNDDL);
                    $("#FBSDDL").html(json.FBSDDL);
                    $("#SRZDDL").html(json.SRZDDL);

                    $("#MDL").html("月发电量</br>" + ((json.MDL + json.HDMDL + json.SDMDL) / 10000).toFixed(3) + "亿kWh");

                    $("#YDL").html("年发电量</br>" + ((json.YDL + json.HDYDL + json.SDYDL) / 10000).toFixed(3) + "亿kWh");

                    PieArr[0] = json.FDYDL;
                    PieArr[1] = json.HDYDL;
                    PieArr[2] = json.SDYDL;
                    PieArr[3] = json.TYNYDL;
                    PieArr[4] = json.FBSYDL;
                    PieArr[5] = json.SRZYDL;

                    $('#container4').highcharts({
                        chart: {
                            type: 'column'
                        },
                        title: {
                            align: 'center',
                            text: '装机容量',
                            style:
                    {
                        color: '#3E576F',
                        fontSize: '14px',
                        fontFamily: '微软雅黑'
                    }
                        },
                        subtitle: {
                            text: ''
                        },
                        xAxis: {
                            categories: [
                    '火电', '水电', '风电', '太阳能', '分布式', '其他'
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
                    '<td style="padding:0"><b>{point.y:.1f} MW</b></td></tr>',
                            footerFormat: '</table>',
                            shared: true,
                            useHTML: true
                        },
                        plotOptions: {
                            column: {
                                pointPadding: 0.02,
                                borderWidth: 0
                            }
                        },
                        series: [{
                            name: '装机容量',
                            data: [{
                                y: arr[0],
                                name: '火电',
                                color: '#55BF3B'
                            }, {
                                y: arr[2],
                                name: '水电',
                                color: '#77BFBB'
                            }, {
                                y: arr[1],
                                name: '风电',
                                color: '#7799BF'
                            }, {
                                y: arr[3],
                                name: '太阳能',
                                color: '#0DDFDC'
                            }, {
                                y: arr[4],
                                name: '分布式',
                                color: '#DDE00D'
                            }, {
                                y: arr[5],
                                name: '其他',
                                color: '#DFAA0C'
                            }]

                        }],
                        exporting: {
                            enabled: false //用来设置是否显示‘打印’,'导出'等功能按钮，不设置时默认为显示 
                        },
                        legend: {
                            enabled: false
                        }

                    });

                    $('#container5').highcharts({
                        chart: {
                            plotBackgroundColor: null,
                            plotBorderWidth: null,
                            plotShadow: false,
                            margin: [5, 80, 5, 5]
                        },
                        title: {
                            align: 'left',
                            text: '发电量',
                            style:
                        {
                            color: '#3E576F',
                            fontSize: '14px',
                            fontFamily: '微软雅黑'
                        }
                        },
                        tooltip: {
                            pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>',
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
                            name: '百分比',
                            data: [{
                                y: PieArr[1],
                                name: '火电',
                                color: '#2F7ED9'
                            }, {
                                y: PieArr[2],
                                name: '水电',
                                color: '#023668'
                            }, {
                                y: PieArr[0],
                                name: '风电',
                                color: '#EC561B'
                            }, {
                                y: PieArr[3],
                                name: '太阳能',
                                color: '#DDDF00'
                            }, {
                                y: PieArr[4],
                                name: '分布式',
                                color: '#23CBE5'
                            }, {
                                y: PieArr[5],
                                name: '其他',
                                color: '#FFA200'
                            }
                        ]
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


                    $("#hd_progressbar").progressbar({
                        value: json.HDWCL
                    })
                    $("#sd_progressbar").progressbar({
                        value: json.SDWCL
                    })
                    $("#fd_progressbar").progressbar({
                        value: json.FDWCL
                    })
                    $("#tyn_progressbar").progressbar({
                        value: json.TYNWCL
                    })
                    $("#fbs_progressbar").progressbar({
                        value: json.FBSWCL
                    })
                    $("#qt_progressbar").progressbar({
                        value: json.SRZWCL
                    })
                },
                error: function (x, e) {
                    alert(x.responseText);
                },
                complete: function () {
                    //Handle the complete event
                }
            });


            $.ajax({
                url: "MainConnect.aspx?funCode=initCharts&chartNum=1",
                type: "POST",
                success: function (json) {
                    var json = $.parseJSON(json);

                    $('#container1').highcharts({
                        chart: {
                            type: 'spline'
                        },
                        title: {
                            text: ''
                        },
                        subtitle: {
                            text: ''
                        },
                        colors: [
                '#32E1FC', '#0E91C9', '#023668'
                ],
                        xAxis: {
                            type: 'datetime'
                        },
                        yAxis: {
                            title: {
                                text: ''
                            },
                            min: 0,
                            minorGridLineWidth: 0,
                            gridLineWidth: 0,
                            alternateGridColor: null,
                            plotBands: [{ // Light air
                                from: 0.3,
                                to: 1.5,
                                color: 'rgba(68, 170, 213, 0.1)',
                                label: {
                                    text: '',
                                    style: {
                                        color: '#606060'
                                    }
                                }
                            }, { // Light breeze
                                from: 1.5,
                                to: 3.3,
                                color: 'rgba(0, 0, 0, 0)',
                                label: {
                                    text: '',
                                    style: {
                                        color: '#606060'
                                    }
                                }
                            }, { // Gentle breeze
                                from: 3.3,
                                to: 5.5,
                                color: 'rgba(68, 170, 213, 0.1)',
                                label: {
                                    text: '',
                                    style: {
                                        color: '#606060'
                                    }
                                }
                            }, { // Moderate breeze
                                from: 5.5,
                                to: 8,
                                color: 'rgba(0, 0, 0, 0)',
                                label: {
                                    text: '',
                                    style: {
                                        color: '#606060'
                                    }
                                }
                            }, { // Fresh breeze
                                from: 8,
                                to: 11,
                                color: 'rgba(68, 170, 213, 0.1)',
                                label: {
                                    text: '',
                                    style: {
                                        color: '#606060'
                                    }
                                }
                            }, { // Strong breeze
                                from: 11,
                                to: 14,
                                color: 'rgba(0, 0, 0, 0)',
                                label: {
                                    text: '',
                                    style: {
                                        color: '#606060'
                                    }
                                }
                            }, { // High wind
                                from: 14,
                                to: 15,
                                color: 'rgba(68, 170, 213, 0.1)',
                                label: {
                                    text: '',
                                    style: {
                                        color: '#606060'
                                    }
                                }
                            }]
                        },
                        tooltip: {
                            valueSuffix: ' MW'
                        },
                        plotOptions: {
                            spline: {
                                lineWidth: 2,
                                states: {
                                    hover: {
                                        lineWidth: 3
                                    }
                                },
                                marker: {
                                    enabled: false
                                },
                                pointInterval: 3600000, // one hour
                                pointStart: Date.UTC(2013, 11, 23, 0, 0, 0)
                            }
                        },
                        series: json.chart

                        , exporting: {
                            enabled: false //用来设置是否显示‘打印’,'导出'等功能按钮，不设置时默认为显示 
                        }
            ,
                        navigation: {
                            menuItemStyle: {
                                fontSize: '10px'
                            }
                        }
                    });
                }
            });

            $.ajax({
                url: "MainConnect.aspx?funCode=initCharts&chartNum=2",
                type: "POST",
                success: function (json) {
                    var json = $.parseJSON(json);
                    $('#container2').highcharts({
                        chart: {
                            type: 'spline'
                        },
                        title: {
                            text: ''
                        },
                        subtitle: {
                            text: ''
                        },
                        colors: [
                '#32E1FC', '#0E91C9', '#023668'
                ],
                        xAxis: {
                            type: 'datetime'
                        },
                        yAxis: {
                            title: {
                                text: ''
                            },
                            min: 0,
                            minorGridLineWidth: 0,
                            gridLineWidth: 0,
                            alternateGridColor: null,
                            plotBands: [{ // Light air
                                from: 0.3,
                                to: 1.5,
                                color: 'rgba(68, 170, 213, 0.1)',
                                label: {
                                    text: '',
                                    style: {
                                        color: '#606060'
                                    }
                                }
                            }, { // Light breeze
                                from: 1.5,
                                to: 3.3,
                                color: 'rgba(0, 0, 0, 0)',
                                label: {
                                    text: '',
                                    style: {
                                        color: '#606060'
                                    }
                                }
                            }, { // Gentle breeze
                                from: 3.3,
                                to: 5.5,
                                color: 'rgba(68, 170, 213, 0.1)',
                                label: {
                                    text: '',
                                    style: {
                                        color: '#606060'
                                    }
                                }
                            }, { // Moderate breeze
                                from: 5.5,
                                to: 8,
                                color: 'rgba(0, 0, 0, 0)',
                                label: {
                                    text: '',
                                    style: {
                                        color: '#606060'
                                    }
                                }
                            }, { // Fresh breeze
                                from: 8,
                                to: 11,
                                color: 'rgba(68, 170, 213, 0.1)',
                                label: {
                                    text: '',
                                    style: {
                                        color: '#606060'
                                    }
                                }
                            }, { // Strong breeze
                                from: 11,
                                to: 14,
                                color: 'rgba(0, 0, 0, 0)',
                                label: {
                                    text: '',
                                    style: {
                                        color: '#606060'
                                    }
                                }
                            }, { // High wind
                                from: 14,
                                to: 15,
                                color: 'rgba(68, 170, 213, 0.1)',
                                label: {
                                    text: '',
                                    style: {
                                        color: '#606060'
                                    }
                                }
                            }]
                        },
                        tooltip: {
                            valueSuffix: ' MW'
                        },
                        plotOptions: {
                            spline: {
                                lineWidth: 2,
                                states: {
                                    hover: {
                                        lineWidth: 3
                                    }
                                },
                                marker: {
                                    enabled: false
                                },
                                pointInterval: 3600000, // one hour
                                pointStart: Date.UTC(2013, 11, 23, 0, 0, 0)
                            }
                        },
                        series: json.chart
                        , exporting: {
                            enabled: false //用来设置是否显示‘打印’,'导出'等功能按钮，不设置时默认为显示 
                        }
            ,
                        navigation: {
                            menuItemStyle: {
                                fontSize: '10px'
                            }
                        }
                    });
                }
            });

            $.ajax({
                url: "MainConnect.aspx?funCode=initCharts&chartNum=3",
                type: "POST",
                success: function (json) {
                    var json = $.parseJSON(json);
                    $('#container3').highcharts({
                        chart: {
                            type: 'spline'
                        },
                        title: {
                            text: ''
                        },
                        subtitle: {
                            text: ''
                        },
                        colors: [
                '#2F7FD8', '#0E91C9', '#023668'
                ],
                        xAxis: {
                            type: 'datetime'
                        },
                        yAxis: {
                            title: {
                                text: ''
                            },
                            min: 0,
                            minorGridLineWidth: 0,
                            gridLineWidth: 0,
                            alternateGridColor: null,
                            plotBands: [{ // Light air
                                from: 0.3,
                                to: 1.5,
                                color: 'rgba(68, 170, 213, 0.1)',
                                label: {
                                    text: '',
                                    style: {
                                        color: '#606060'
                                    }
                                }
                            }, { // Light breeze
                                from: 1.5,
                                to: 3.3,
                                color: 'rgba(0, 0, 0, 0)',
                                label: {
                                    text: '',
                                    style: {
                                        color: '#606060'
                                    }
                                }
                            }, { // Gentle breeze
                                from: 3.3,
                                to: 5.5,
                                color: 'rgba(68, 170, 213, 0.1)',
                                label: {
                                    text: '',
                                    style: {
                                        color: '#606060'
                                    }
                                }
                            }, { // Moderate breeze
                                from: 5.5,
                                to: 8,
                                color: 'rgba(0, 0, 0, 0)',
                                label: {
                                    text: '',
                                    style: {
                                        color: '#606060'
                                    }
                                }
                            }, { // Fresh breeze
                                from: 8,
                                to: 11,
                                color: 'rgba(68, 170, 213, 0.1)',
                                label: {
                                    text: '',
                                    style: {
                                        color: '#606060'
                                    }
                                }
                            }, { // Strong breeze
                                from: 11,
                                to: 14,
                                color: 'rgba(0, 0, 0, 0)',
                                label: {
                                    text: '',
                                    style: {
                                        color: '#606060'
                                    }
                                }
                            }, { // High wind
                                from: 14,
                                to: 15,
                                color: 'rgba(68, 170, 213, 0.1)',
                                label: {
                                    text: '',
                                    style: {
                                        color: '#606060'
                                    }
                                }
                            }]
                        },
                        tooltip: {
                            valueSuffix: ' 万kWh'
                        },
                        plotOptions: {
                            spline: {
                                lineWidth: 2,
                                states: {
                                    hover: {
                                        lineWidth: 3
                                    }
                                },
                                marker: {
                                    enabled: false
                                },
                                //                                pointInterval: 3600000, // one hour
                                //                                pointStart: Date.UTC(2009, 9, 6, 0, 0, 0)
                                pointInterval: 3600000, // one hour
                                pointStart: Date.UTC(2013, 11, 23, 0, 0, 0)
                            }
                        },
                        series: json.chart
                        , exporting: {
                            enabled: false //用来设置是否显示‘打印’,'导出'等功能按钮，不设置时默认为显示 
                        }
            ,
                        navigation: {
                            menuItemStyle: {
                                fontSize: '10px'
                            }
                        }
                    });
                }
            });


            $.ajax({
                url: "MainConnect.aspx?funCode=GetFDFHValue",
                type: "POST",
                beforeSend: function () {
                    //Handle the beforeSend event
                },
                success: function (json) {
                    //json = eval("("+json+")");
                    var json = $.parseJSON(json);
                    $("#FDFH").html(json.FDFH);

                },
                error: function (x, e) {
                    alert(x.responseText);
                },
                complete: function () {
                    //Handle the complete event
                }
            });

        });


        function LOADCHARTS() {

            $("#hd_progressbar").progressbar({
                value: 59
            })
            $("#sd_progressbar").progressbar({
                value: 59
            })
            $("#fd_progressbar").progressbar({
                value: 59
            })
            $("#tyn_progressbar").progressbar({
                value: 59
            })
            $("#fbs_progressbar").progressbar({
                value: 59
            })
            $("#qt_progressbar").progressbar({
                value: 59
            })


            $('#container1').highcharts({
                chart: {
                    type: 'spline'
                },
                title: {
                    text: ''
                },
                subtitle: {
                    text: ''
                },
                colors: [
                '#32E1FC', '#0E91C9', '#023668'
                ],
                xAxis: {
                    type: 'datetime'
                },
                yAxis: {
                    title: {
                        text: ''
                    },
                    min: 0,
                    minorGridLineWidth: 0,
                    gridLineWidth: 0,
                    alternateGridColor: null,
                    plotBands: [{ // Light air
                        from: 0.3,
                        to: 1.5,
                        color: 'rgba(68, 170, 213, 0.1)',
                        label: {
                            text: '',
                            style: {
                                color: '#606060'
                            }
                        }
                    }, { // Light breeze
                        from: 1.5,
                        to: 3.3,
                        color: 'rgba(0, 0, 0, 0)',
                        label: {
                            text: '',
                            style: {
                                color: '#606060'
                            }
                        }
                    }, { // Gentle breeze
                        from: 3.3,
                        to: 5.5,
                        color: 'rgba(68, 170, 213, 0.1)',
                        label: {
                            text: '',
                            style: {
                                color: '#606060'
                            }
                        }
                    }, { // Moderate breeze
                        from: 5.5,
                        to: 8,
                        color: 'rgba(0, 0, 0, 0)',
                        label: {
                            text: '',
                            style: {
                                color: '#606060'
                            }
                        }
                    }, { // Fresh breeze
                        from: 8,
                        to: 11,
                        color: 'rgba(68, 170, 213, 0.1)',
                        label: {
                            text: '',
                            style: {
                                color: '#606060'
                            }
                        }
                    }, { // Strong breeze
                        from: 11,
                        to: 14,
                        color: 'rgba(0, 0, 0, 0)',
                        label: {
                            text: '',
                            style: {
                                color: '#606060'
                            }
                        }
                    }, { // High wind
                        from: 14,
                        to: 15,
                        color: 'rgba(68, 170, 213, 0.1)',
                        label: {
                            text: '',
                            style: {
                                color: '#606060'
                            }
                        }
                    }]
                },
                tooltip: {
                    valueSuffix: ' m/s'
                },
                plotOptions: {
                    spline: {
                        lineWidth: 2,
                        states: {
                            hover: {
                                lineWidth: 3
                            }
                        },
                        marker: {
                            enabled: false
                        },
                        pointInterval: 3600000, // one hour
                        pointStart: Date.UTC(2009, 9, 6, 0, 0, 0)
                    }
                },
                series: [{
                    name: '火电',
                    data: [4.3, 5.1, 4.3, 5.2, 5.4, 4.7, 3.5, 4.1, 5.6, 7.4, 6.9, 7.1,
                    7.1, 7.5, 8.1, 6.8, 3.4, 2.1, 1.9, 2.8, 2.9, 1.3, 4.4, 4.2,
                    3.0, 3.0]

                }, {
                    name: '风电',
                    data: [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.0, 0.3, 0.0,
                    3.0, 3.3, 4.8, 5.0, 4.8, 5.0, 3.2, 2.0, 0.9, 0.4, 0.3, 0.5, 0.4]
                }, {
                    name: '水电',
                    data: [2.3, 5.1, 4.3, 5.2, 5.4, 4.7, 3.5, 4.1, 5.6, 7.4, 6.9, 7.1,
                    7.1, 7.5, 3.1, 6.8, 3.4, 2.1, 1.9, 2.8, 2.9, 1.3, 4.4, 4.2,
                    3.0, 3.0]

                }
                ], exporting: {
                    enabled: false //用来设置是否显示‘打印’,'导出'等功能按钮，不设置时默认为显示 
                }
            ,
                navigation: {
                    menuItemStyle: {
                        fontSize: '10px'
                    }
                }
            });
            $('#container2').highcharts({
                chart: {
                    type: 'spline'
                },
                title: {
                    text: ''
                },
                subtitle: {
                    text: ''
                },
                colors: [
                '#32E1FC', '#0E91C9', '#023668'
                ],
                xAxis: {
                    type: 'datetime'
                },
                yAxis: {
                    title: {
                        text: ''
                    },
                    min: 0,
                    minorGridLineWidth: 0,
                    gridLineWidth: 0,
                    alternateGridColor: null,
                    plotBands: [{ // Light air
                        from: 0.3,
                        to: 1.5,
                        color: 'rgba(68, 170, 213, 0.1)',
                        label: {
                            text: '',
                            style: {
                                color: '#606060'
                            }
                        }
                    }, { // Light breeze
                        from: 1.5,
                        to: 3.3,
                        color: 'rgba(0, 0, 0, 0)',
                        label: {
                            text: '',
                            style: {
                                color: '#606060'
                            }
                        }
                    }, { // Gentle breeze
                        from: 3.3,
                        to: 5.5,
                        color: 'rgba(68, 170, 213, 0.1)',
                        label: {
                            text: '',
                            style: {
                                color: '#606060'
                            }
                        }
                    }, { // Moderate breeze
                        from: 5.5,
                        to: 8,
                        color: 'rgba(0, 0, 0, 0)',
                        label: {
                            text: '',
                            style: {
                                color: '#606060'
                            }
                        }
                    }, { // Fresh breeze
                        from: 8,
                        to: 11,
                        color: 'rgba(68, 170, 213, 0.1)',
                        label: {
                            text: '',
                            style: {
                                color: '#606060'
                            }
                        }
                    }, { // Strong breeze
                        from: 11,
                        to: 14,
                        color: 'rgba(0, 0, 0, 0)',
                        label: {
                            text: '',
                            style: {
                                color: '#606060'
                            }
                        }
                    }, { // High wind
                        from: 14,
                        to: 15,
                        color: 'rgba(68, 170, 213, 0.1)',
                        label: {
                            text: '',
                            style: {
                                color: '#606060'
                            }
                        }
                    }]
                },
                tooltip: {
                    valueSuffix: ' m/s'
                },
                plotOptions: {
                    spline: {
                        lineWidth: 2,
                        states: {
                            hover: {
                                lineWidth: 3
                            }
                        },
                        marker: {
                            enabled: false
                        },
                        pointInterval: 3600000, // one hour
                        pointStart: Date.UTC(2009, 9, 6, 0, 0, 0)
                    }
                },
                series: [{
                    name: '太阳能',
                    data: [4.3, 5.1, 4.3, 5.2, 5.4, 4.7, 3.5, 4.1, 5.6, 7.4, 6.9, 7.1,
                    7.1, 7.5, 8.1, 6.8, 3.4, 2.1, 1.9, 2.8, 2.9, 1.3, 4.4, 4.2,
                    3.0, 3.0]

                }, {
                    name: '分布式',
                    data: [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.0, 0.3, 0.0,
                    3.0, 3.3, 4.8, 5.0, 4.8, 5.0, 3.2, 2.0, 0.9, 0.4, 0.3, 0.5, 0.4]
                }, {
                    name: '其他',
                    data: [2.3, 5.1, 4.3, 5.2, 5.4, 4.7, 3.5, 4.1, 5.6, 7.4, 6.9, 7.1,
                    7.1, 7.5, 3.1, 6.8, 3.4, 2.1, 1.9, 2.8, 2.9, 1.3, 4.4, 4.2,
                    3.0, 3.0]

                }
                ], exporting: {
                    enabled: false //用来设置是否显示‘打印’,'导出'等功能按钮，不设置时默认为显示 
                }
            ,
                navigation: {
                    menuItemStyle: {
                        fontSize: '10px'
                    }
                }
            });
            $('#container3').highcharts({
                chart: {
                    type: 'spline'
                },
                title: {
                    text: ''
                },
                subtitle: {
                    text: ''
                },
                colors: [
                '#2F7FD8', '#0E91C9', '#023668'
                ],
                xAxis: {
                    type: 'datetime'
                },
                yAxis: {
                    title: {
                        text: ''
                    },
                    min: 0,
                    minorGridLineWidth: 0,
                    gridLineWidth: 0,
                    alternateGridColor: null,
                    plotBands: [{ // Light air
                        from: 0.3,
                        to: 1.5,
                        color: 'rgba(68, 170, 213, 0.1)',
                        label: {
                            text: '',
                            style: {
                                color: '#606060'
                            }
                        }
                    }, { // Light breeze
                        from: 1.5,
                        to: 3.3,
                        color: 'rgba(0, 0, 0, 0)',
                        label: {
                            text: '',
                            style: {
                                color: '#606060'
                            }
                        }
                    }, { // Gentle breeze
                        from: 3.3,
                        to: 5.5,
                        color: 'rgba(68, 170, 213, 0.1)',
                        label: {
                            text: '',
                            style: {
                                color: '#606060'
                            }
                        }
                    }, { // Moderate breeze
                        from: 5.5,
                        to: 8,
                        color: 'rgba(0, 0, 0, 0)',
                        label: {
                            text: '',
                            style: {
                                color: '#606060'
                            }
                        }
                    }, { // Fresh breeze
                        from: 8,
                        to: 11,
                        color: 'rgba(68, 170, 213, 0.1)',
                        label: {
                            text: '',
                            style: {
                                color: '#606060'
                            }
                        }
                    }, { // Strong breeze
                        from: 11,
                        to: 14,
                        color: 'rgba(0, 0, 0, 0)',
                        label: {
                            text: '',
                            style: {
                                color: '#606060'
                            }
                        }
                    }, { // High wind
                        from: 14,
                        to: 15,
                        color: 'rgba(68, 170, 213, 0.1)',
                        label: {
                            text: '',
                            style: {
                                color: '#606060'
                            }
                        }
                    }]
                },
                tooltip: {
                    valueSuffix: ' m/s'
                },
                plotOptions: {
                    spline: {
                        lineWidth: 2,
                        states: {
                            hover: {
                                lineWidth: 3
                            }
                        },
                        marker: {
                            enabled: false
                        },
                        pointInterval: 3600000, // one hour
                        pointStart: Date.UTC(2009, 9, 6, 0, 0, 0)
                    }
                },
                series: [{
                    name: '总负荷',
                    data: [4.3, 5.1, 4.3, 5.2, 5.4, 4.7, 3.5, 4.1, 5.6, 7.4, 6.9, 7.1,
                    7.1, 7.5, 8.1, 6.8, 3.4, 2.1, 1.9, 2.8, 2.9, 1.3, 4.4, 4.2,
                    3.0, 3.0]
                }
                ], exporting: {
                    enabled: false //用来设置是否显示‘打印’,'导出'等功能按钮，不设置时默认为显示 
                }
            ,
                navigation: {
                    menuItemStyle: {
                        fontSize: '10px'
                    }
                }
            });

            $('#container4').highcharts({
                chart: {
                    type: 'column'
                },
                title: {
                    align: 'center',
                    text: '装机容量',
                    style:
                    {
                        color: '#3E576F',
                        fontSize: '14px',
                        fontFamily: '微软雅黑'
                    }
                },
                subtitle: {
                    text: ''
                },
                xAxis: {
                    categories: [
                    '火电', '水电', '风电', '太阳能', '分布式', '其他'
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
                    '<td style="padding:0"><b>{point.y:.1f} mm</b></td></tr>',
                    footerFormat: '</table>',
                    shared: true,
                    useHTML: true
                },
                plotOptions: {
                    column: {
                        pointPadding: 0.02,
                        borderWidth: 0
                    }
                },
                series: [{
                    name: '装机容量',
                    data: [{
                        y: 55.11,
                        name: '火电',
                        color: '#55BF3B'
                    }, {
                        y: 41.63,
                        name: '水电',
                        color: '#77BFBB'
                    }, {
                        y: 30.94,
                        name: '风电',
                        color: '#7799BF'
                    }, {
                        y: 12.15,
                        name: '太阳能',
                        color: '#0DDFDC'
                    }, {
                        y: 9.14,
                        name: '分布式',
                        color: '#DDE00D'
                    }, {
                        y: 8.14,
                        name: '其他',
                        color: '#DFAA0C'
                    }]

                }],
                exporting: {
                    enabled: false //用来设置是否显示‘打印’,'导出'等功能按钮，不设置时默认为显示 
                },
                legend: {
                    enabled: false
                }

            });
            $('#container5').highcharts({
                chart: {
                    plotBackgroundColor: null,
                    plotBorderWidth: null,
                    plotShadow: false,
                    margin: [5, 80, 5, 5]
                },
                title: {
                    align: 'left',
                    text: '发电量',
                    style:
                        {
                            color: '#3E576F',
                            fontSize: '14px',
                            fontFamily: '微软雅黑'
                        }
                },
                tooltip: {
                    pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>',
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
                    name: 'Browser share',
                    data: [{
                        y: 55.11,
                        name: '火电',
                        color: '#2F7ED9'
                    }, {
                        y: 41.63,
                        name: '水电',
                        color: '#023668'
                    }, {
                        y: 30.94,
                        name: '风电',
                        color: '#EC561B'
                    }, {
                        y: 12.15,
                        name: '太阳能',
                        color: '#DDDF00'
                    }, {
                        y: 9.14,
                        name: '分布式',
                        color: '#23CBE5'
                    }, {
                        y: 2.14,
                        name: '其他',
                        color: '#FFA200'
                    }
                        ]
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


        function transfor() {
            alert(1111);
        }

    </script>
</head>
<body style="background: F7F7FF;">
    <form id="form1" runat="server">
    <div style="width: 1000px; height: 1550px; background-color: #023668; margin: 5px auto;">
        <div style="width: 990px; height: 60px; float: left; background-image: url(img/20131211142227.png);
            padding: 5px">
            <div id="ZRL" style="width: 190px; height: 60px; float: left; font-size: 22px; color: White;">
                装机容量</br>8,888,888MW</div>
            <div id="ZFH" style="width: 190px; height: 60px; float: left; font-size: 22px; color: White;">
                有功功率</br>8,888,888MW</div>
            <div id="DDL" style="width: 190px; height: 60px; float: left; font-size: 22px; color: White;">
                日发电量</br>8,888,888万kWh</div>
            <div id="MDL"  style="width: 190px; height: 60px; float: left; font-size: 22px; color: White;">
                月发电量</br>8,888,888亿kWh</div>
            <div id="YDL" style="width: 190px; height: 60px; float: left; font-size: 22px; color: White;">
                年发电量</br>8,888,888亿kWh</div>
        </div>
        <div style="width: 310px; height: 80px; border: 1px solid #184C78; float: left; margin: 0.5px;
            padding: 10px">
            <div style="width: 310px; height: 30px; float: left; font-size: 22px; color: White;
                text-align: center">
                火&nbsp;&nbsp;电&nbsp;<span style="font-size: 11px; color: White;">装机容量&nbsp;</span><div id="HDRL" style="display:inline">67945</div><span
                    style="font-size: 11px; color: White;">&nbsp;日发电量&nbsp;</span><div id="HDDDL" style="display:inline">29654</div>
            </div>
            <div style="width: 310px; height: 40px; float: left; border-radius: 5px; background-color: White;
                text-align: center; font-size: 12px; color: #002E5C; padding-top: 2px">
                计划完成率
                <div id="hd_progressbar" style="width: 280px; margin: auto">
                </div>
            </div>
        </div>
        <div style="width: 310px; height: 80px; border: 1px solid #184C78; float: left; margin: 0.5px;
            padding: 10px">
            <div style="width: 310px; height: 30px; float: left; font-size: 22px; color: White;
                text-align: center">
                水&nbsp;&nbsp;电&nbsp;<span style="font-size: 11px; color: White;">装机容量&nbsp;</span><div id="SDRL" style="display:inline">67945</div><span
                    style="font-size: 11px; color: White;">&nbsp;日发电量&nbsp;</span><div id="SDDDL" style="display:inline">29654</div>
            </div>
            <div style="width: 310px; height: 40px; float: left; border-radius: 5px; background-color: White;
                text-align: center; font-size: 12px; color: #002E5C; padding-top: 2px">
                计划完成率
                <div id="sd_progressbar" style="width: 280px; margin: auto">
                </div>
            </div>
        </div>
        <div style="width: 310px; height: 80px; border: 1px solid #184C78; float: left; margin: 0.5px;
            padding: 10px">
            <div style="width: 310px; height: 30px; float: left; font-size: 22px; color: White;
                text-align: center">
                风&nbsp;&nbsp;电&nbsp;<span style="font-size: 11px; color: White;">装机容量&nbsp;</span><div id="FDRL" style="display:inline">67945</div><span
                    style="font-size: 11px; color: White;">&nbsp;日发电量&nbsp;</span><div id="FDDDL" style="display:inline">29654</div>
            </div>
            <div style="width: 310px; height: 40px; float: left; border-radius: 5px; background-color: White;
                text-align: center; font-size: 12px; color: #002E5C; padding-top: 2px">
                计划完成率
                <div id="fd_progressbar" style="width: 280px; margin: auto">
                </div>
            </div>
        </div>
        <div style="width: 310px; height: 80px; border: 1px solid #184C78; float: left; margin: 0.5px;
            padding: 10px">
            <div style="width: 310px; height: 30px; float: left; font-size: 22px; color: White;
                text-align: center">
                太阳能&nbsp;<span style="font-size: 11px; color: White;">装机容量&nbsp;</span><div id="TYNRL" style="display:inline">67945</div><span
                    style="font-size: 11px; color: White;">&nbsp;日发电量&nbsp;</span><div id="TYNDDL" style="display:inline">29654</div>
            </div>
            <div style="width: 310px; height: 40px; float: left; border-radius: 5px; background-color: White;
                text-align: center; font-size: 12px; color: #002E5C; padding-top: 2px">
                计划完成率
                <div id="tyn_progressbar" style="width: 280px; margin: auto">
                </div>
            </div>
        </div>
        <div style="width: 310px; height: 80px; border: 1px solid #184C78; float: left; margin: 0.5px;
            padding: 10px">
            <div style="width: 310px; height: 30px; float: left; font-size: 22px; color: White;
                text-align: center">
                分布式&nbsp;<span style="font-size: 11px; color: White;">装机容量&nbsp;</span><div id="FBSRL" style="display:inline">67945</div><span
                    style="font-size: 11px; color: White;">&nbsp;日发电量&nbsp;</span><div id="FBSDDL" style="display:inline">29654</div>
            </div>
            <div style="width: 310px; height: 40px; float: left; border-radius: 5px; background-color: White;
                text-align: center; font-size: 12px; color: #002E5C; padding-top: 2px">
                计划完成率
                <div id="fbs_progressbar" style="width: 280px; margin: auto">
                </div>
            </div>
        </div>
        <div style="width: 310px; height: 80px; border: 1px solid #184C78; float: left; margin: 0.5px;
            padding: 10px">
            <div style="width: 310px; height: 30px; float: left; font-size: 22px; color: White;
                text-align: center">
                其&nbsp;&nbsp;它&nbsp;<span style="font-size: 11px; color: White;">装机容量&nbsp;</span><div id="SRZRL" style="display:inline">67945</div><span
                    style="font-size: 11px; color: White;">&nbsp;日发电量&nbsp;</span><div id="SRZDDL" style="display:inline">29654</div>
            </div>
            <div style="width: 310px; height: 40px; float: left; border-radius: 5px; background-color: White;
                text-align: center; font-size: 12px; color: #002E5C; padding-top: 2px">
                计划完成率
                <div id="qt_progressbar" style="width: 280px; margin: auto">
                </div>
            </div>
        </div>
        <div style="width: 1000px; height: 230px; float: left; margin-top: 1px">
            <div style="width: 1000px; height: 35px; float: left; background-image: url(img/20131211144004.png);
                font-size: 19px; color: White; line-height: 30px">
                &nbsp;实时负荷
            </div>
            <div style="width: 1000px; height: 200px; float: left;">
                <div id="container1" style="width: 320px; height: 180px; float: left; margin: 5px">
                </div>
                <div id="container2" style="width: 320px; height: 180px; float: left; margin: 5px">
                </div>
                <div id="container3" style="width: 320px; height: 180px; float: left; margin: 5px">
                </div>
            </div>
        </div>
        <div style="width: 1000px; height: 230px; float: left;">
            <div style="width: 1000px; height: 35px; float: left; background-image: url(img/20131211144004.png);
                font-size: 19px; color: White; line-height: 30px">
                &nbsp;项目情况<label style="margin-left: 590px">实时负荷数据(MW)</label>
            </div>
            <div style="width: 1000px; height: 200px; float: left;">
                <div id="container4" style="width: 320px; height: 180px; float: left; margin: 5px">
                </div>
                <div id="container5" style="width: 320px; height: 180px; float: left; margin: 5px">
                </div>
                <div id="Div3" style="width: 320px; height: 180px; float: left; margin: 5px;">
                    <table id="tabId" style="border-collapse: collapse; background-color: White; width: 310px;
                        height: 176px; text-align: center; margin-top: 2px; margin-left: 8px" border="1">
                        <tr>
                            <td style="width: 100px;">
                                火电
                            </td>
                            <td id="HDFH">
                            </td>
                        </tr>
                        <tr>
                            <td>
                                水电
                            </td>
                            <td id="SDFH">
                            </td>
                        </tr>
                        <tr>
                            <td>
                                风电
                            </td>
                            <td id="FDFH">
                            </td>
                        </tr>
                        <tr>
                            <td>
                                太阳能
                            </td>
                            <td id="TYNFH">
                            </td>
                        </tr>
                        <tr>
                            <td>
                                分布式
                            </td>
                            <td id="FBSFH">
                            </td>
                        </tr>
                        <tr>
                            <td>
                                其他
                            </td>
                            <td id="SRZFH">
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
        </div>
        <div style="width: 1000px; height: 800px; float: left;">
            <div style="width: 1000px; height: 35px; float: left; background-image: url(img/20131211144004.png);
                font-size: 19px; color: White; line-height: 30px">
                &nbsp;项目分布
            </div>
            <div id="box" style="width: 1000px; height: 765px; float: left; position: relative;">
                <img src="img/华电logo.png" style="position: absolute; top: 229px; left: 552px; z-index: 500"
                    onclick="transfor()" />
                <dl id="gmap" name="gmap">
                    <dt><a href="#nogo" name="title2" id="title2" onfocus="this.blur()"></a></dt>
                    <dd>
                        <a href="ProvinceConnect.aspx" id="lmg" title="内蒙古" href="#" onfocus="this.blur()">
                        </a>
                    </dd>
                </dl>

                <div style="position:absolute; width:128px; height:279px; top: 356px; left: 827px;">
                <table style="color:White">
                <tr><td>
                    <img src="img/火电图标.png" /></td><td>火电</td></tr>
                <tr><td>
                    <img src="img/水电图标.png" /></td><td>水电</td></tr>
                <tr><td>
                    <a href="Form/Map.aspx"><img  style="border:0"  src="img/风电图标.png"/></a></td><td>风电</td></tr>
                <tr><td>
                    <img src="img/分布式图标.png" /></td><td>分布式</td></tr>
                <tr><td>
                    <img src="img/太阳能图标.png" /></td><td>太阳能</td></tr>
                <tr><td>
                    <img src="img/生物质图标.png" /></td><td>生物质</td></tr>
                <tr><td>
                    <img src="img/核能图标.png" /></td><td>核能</td></tr>
                </table>
                </div>
            </div>
        </div>
    </div>
    </form>
</body>
</html>
