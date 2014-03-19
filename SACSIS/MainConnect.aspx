<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="MainConnect.aspx.cs" Inherits="WebApplication2.MainConnect" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>总公司情况</title>
    <link href="css/main.css" rel="stylesheet" type="text/css" />
    <link href="../Js/jQueryEasyUI/themes/default/easyui.css" rel="stylesheet" type="text/css" />
    <link href="../Js/jQueryEasyUI/themes/icon.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript">        window.onerror = function () { return true; };</script>
    <script src="Js/jquery-1.9.1.js" type="text/javascript"></script>
    <script src="../Js/jquery-1.8.2.min.js" type="text/javascript"></script>
    <script src="../Js/jquery.easyui.min.js" type="text/javascript"></script>
    <script src="../Js/highcharts.js" type="text/javascript"></script>
    <script src="../Js/highcharts-more.js" type="text/javascript"></script>
    <script src="../Js/exporting.js" type="text/javascript"></script>
    <style type="text/css">
        #tabId td
        {
            border: solid thin #6BA5BD;
        }
        
        
        #gmap
        {
            display: block;
            width: 1300px;
            height: 650px;
            background: url(img/map_1.jpg) no-repeat;
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
            width: 1000px;
            height: 650px;
            position: absolute;
            left: 0;
            top: 0;
            cursor: default;
            text-decoration: none;
        }
        * html #title2
        {
            height: 650px;
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
            left: 322px;
            top: 17px;
        }
        * html #lmg
        {
            height: 2px;
        }
        a#lmg:hover
        {
            background: transparent url(img/lm.gif) no-repeat 0 0;
        }
        body
        {
            height: 100%;
            overflow: auto;
            margin: 0px;
            padding: 0px;
            background-color: #f4f4f4;
        }
        map_all
        {
            height: 100%;
            overflow: auto;
            margin: 0px;
            padding: 0px;
            background-color: #f4f4f4;
            background-image: url(img/map_bg_1.jpg);
        }
        .div_title
        {
            background-image: url(img/map_bg_2.jpg);
            background-repeat: repeat-x;
            height: 31px;
            color: #333333;
            font-family: "微软雅黑";
            font-size: 19px;
        }
        .map
        {
            background-image: url(img/map_bg_1.jpg);
        }
        .text_1
        {
            color: #333333;
            font: Arial, Helvetica, sans-serif;
            font-size: 28px;
            position: absolute;
            top: 38px;
            left: 20px;
        }
        .text_2
        {
            color: #0189ff;
            font: "Arial Black" , Gadget, sans-serif;
            font-size: 40px;
            display: inline;
            font-weight: bold;
        }
        .div_title_1
        {
            background-image: url(img/DataZL_title_1.jpg);
            background-repeat: no-repeat;
            background-color: #0568bd;
            background-position: top left;
            width: 197px;
            height: 84px;
            position: relative;
            display: block;
        }
        .div_title_2
        {
            background-image: url(img/DataZL_title_2.jpg);
            background-repeat: no-repeat;
            background-color: #0568bd;
            background-position: top left;
            width: 192px;
            height: 84px;
            position: relative;
            display: block;
        }
        .div_title_3
        {
            background-image: url(img/DataZL_title_3.jpg);
            background-repeat: no-repeat;
            background-color: #0568bd;
            background-position: top left;
            width: 195px;
            height: 84px;
            position: relative;
            display: block;
        }
        .div_title_4
        {
            background-image: url(img/DataZL_title_4.jpg);
            background-repeat: no-repeat;
            background-color: #0568bd;
            background-position: top left;
            width: 195px;
            height: 84px;
            position: relative;
            display: block;
        }
        .div_title_5
        {
            background-image: url(img/DataZL_title_5.jpg);
            background-repeat: no-repeat;
            background-color: #0568bd;
            background-position: top left;
            width: 199px;
            height: 84px;
            position: relative;
            display: block;
        }
        .div_title_6
        {
            background-color: #f4f4f4;
            color: #333333;
            font-family: "微软雅黑";
            font-size: 22px;
            height: 27px;
        }
        .div_fg
        {
            background-image: url(img/DataZL_1.jpg);
            background-repeat: no-repeat;
            background-color: #0568bd;
            width: 4px;
            height: 84px;
        }
        .div_table_1
        {
            background-image: url(img/DataZL_2.jpg);
            background-repeat: repeat-x;
            color: #333333;
            font-family: "微软雅黑";
            font-size: 18px;
            height: 43px;
        }
        .div_table_2
        {
            background-image: url(img/DataZL_4.jpg);
            background-repeat: repeat-x;
            color: #333333;
            font-family: "微软雅黑";
            font-size: 30px;
            height: 56px;
        }
        .div_table_2_1
        {
            background-image: url(img/DataZL_4.jpg);
            background-repeat: repeat-x;
            height: 56px;
        }
    </style>
    <script type="text/javascript" language="javascript">

        $(function () {

            var highchartsOptions = Highcharts.setOptions(Highcharts.theme);

            LOADCHARTS();
            load();
            var int = self.setInterval("load()", 30000);

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
                borderWidth: 1,
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

//        Highcharts.theme = {
//            colors: ["#058dc7", "#50b432", "#ed561b", "#72727F", "#1F949A", "#82914E", "#86777F", "#42A07B"],
//            chart: {
//                className: 'skies',
//                borderWidth: 2,
//                plotShadow: false,
//                //plotBackgroundImage: 'img/skies.jpg',
////                plotBackgroundColor: {
////                    linearGradient: [0, 0, 250, 500],
////                    stops: [
////            [0, 'rgba(255, 255, 255, 1)'],
////            [1, 'rgba(255, 255, 255, 0)']
////         ]
////                },
//                plotBorderWidth: 2
//            },
//            title: {
//                style: {
//                    color: '#3E576F',
//                    font: '16px Lucida Grande, Lucida Sans Unicode, Verdana, Arial, Helvetica, sans-serif'
//                }
//            },
//            subtitle: {
//                style: {
//                    color: '#6D869F',
//                    font: '12px Lucida Grande, Lucida Sans Unicode, Verdana, Arial, Helvetica, sans-serif'
//                }
//            },
//            xAxis: {
//                gridLineWidth: 0,
//                lineColor: '#C0D0E0',
//                tickColor: '#C0D0E0',
//                labels: {
//                    style: {
//                        color: '#666',
//                        fontWeight: 'bold'
//                    }
//                },
//                title: {
//                    style: {
//                        color: '#666',
//                        font: '12px Lucida Grande, Lucida Sans Unicode, Verdana, Arial, Helvetica, sans-serif'
//                    }
//                }
//            },
//            yAxis: {
//                alternateGridColor: 'rgba(255, 255, 255, .5)',
//                lineColor: '#C0D0E0',
//                tickColor: '#C0D0E0',
//                tickWidth: 1,
//                labels: {
//                    style: {
//                        color: '#666',
//                        fontWeight: 'bold'
//                    }
//                },
//                title: {
//                    style: {
//                        color: '#666',
//                        font: '12px Lucida Grande, Lucida Sans Unicode, Verdana, Arial, Helvetica, sans-serif'
//                    }
//                }
//            },
//            legend: {
//                itemStyle: {
//                    font: '9pt Trebuchet MS, Verdana, sans-serif',
//                    color: '#3E576F'
//                },
//                itemHoverStyle: {
//                    color: 'black'
//                },
//                itemHiddenStyle: {
//                    color: 'silver'
//                }
//            },
//            labels: {
//                style: {
//                    color: '#3E576F'
//                }
//            }
        //        };
        //处理字符串
        function ControlString(tmp) {
            var tmpString = tmp.toString();
                for (var i = tmp.toString().length; i < 7; i++) {
                    tmpString = "&nbsp;&nbsp;" + tmpString;
                }
            return tmpString;
        }
        function load() {

            //alert(1);

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
                    $("#ZRL").html("<label>" + json.ZRL + "</label>");
                    $("#HDRL").html(json.HDRL);
                    $("#FDRL").html(json.FDRL);
                    $("#SDRL").html(json.SDRL);
                    $("#TYNRL").html("&nbsp;&nbsp;" + json.TYNRL);
                    $("#FBSRL").html("&nbsp;&nbsp;" + json.FBSRL);
                    $("#SRZRL").html("&nbsp;&nbsp;&nbsp;&nbsp;" + json.SRZRL);

                    //总负荷 产业负荷
                    //$("#ZFH").html("<label>" + (json.ZFH + json.SDFH + json.HDFH).toFixed(2) + "</label>");
                    $("#ZFH").html("<label>" + json.ZFH.toFixed(2) + "</label>");
                    $("#FDFH").html(ControlString(json.FDFH));
                    $("#HDFH").html(ControlString(json.HDFH));
                    $("#SDFH").html(ControlString(json.SDFH));
                    $("#TYNFH").html(ControlString(json.TYNFH));
                    $("#FBSFH").html(ControlString(json.FBSFH));
                    $("#SRZFH").html(ControlString(json.SRZFH));


                    //日发电量
                    //$("#DDL").html("<label>" + (json.DDL + json.HDDDL + json.SDDDL).toFixed(2) + "</label>");
                    $("#DDL").html("<label>" + (json.DDL).toFixed(2) + "</label>");
                    $("#FDDDL").html(ControlString(json.FDDDL));
                    $("#HDDDL").html(ControlString(json.HDDDL));
                    $("#SDDDL").html(ControlString(json.SDDDL));
                    $("#TYNDDL").html(ControlString(json.TYNDDL));
                    $("#FBSDDL").html(ControlString(json.FBSDDL));
                    $("#SRZDDL").html(ControlString(json.SRZDDL));

                    //月发电量
                    //$("#MDL").html("<label>" + ((json.MDL + json.HDMDL + json.SDMDL) / 10000).toFixed(2) + "</label>");
                    $("#MDL").html("<label>" + ((json.MDL) / 10000).toFixed(2) + "</label>");

                    //$("#YDL").html("<label>" + ((json.YDL + json.HDYDL + json.SDYDL) / 10000).toFixed(2) + "</label>");
                    $("#YDL").html("<label>" + ((json.YDL) / 10000).toFixed(2) + "</label>");

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
                    $("#hdss_progressbar").progressbar({
                        value: json.HDSS
                    })
                    $("#sdss_progressbar").progressbar({
                        value: json.SDSS
                    })
                    $("#fdss_progressbar").progressbar({
                        value: json.FDSS
                    })
                    $("#fbsss_progressbar").progressbar({
                        value: json.FBSSS
                    })
                    $("#tynss_progressbar").progressbar({
                        value: json.TYNSS
                    })
                    $("#srzss_progressbar").progressbar({
                        value: json.SRZSS
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
                '#058dc7', '#50b432', '#ed561b'
                ],
                        xAxis: {
                            type: 'datetime',
                            labels: {
                                formatter: function () {
                                    return Highcharts.dateFormat('%H:%M', this.value);
                                }
                            }
                        },
                        yAxis: {
                            title: {
                                text: ''
                            },
                            min: 0 
                        },
                        tooltip: {
                            valueSuffix: ' MW',
                            xDateFormat: '<b>时间:' + '%H:%M:%S' + '</b>',
                            crosshairs: {
                                width: 1,
                                color: 'red'
                            },
                            shared: true
                        },
                        plotOptions: {
                            spline: {
                                lineWidth: 0.5,
                                states: {
                                    hover: {
                                        lineWidth: 0.5
                                    }
                                },
                                marker: {
                                    enabled: false
                                },
                                pointInterval: 1800000, // 半小时
                                pointStart: Date.UTC(new Date().getYear(), new Date().getMonth(), new Date().getDay(), 0, 0, 0)
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
                '#058dc7', '#50b432', '#ed561b'
                ],
                        xAxis: {
                            type: 'datetime',
                            labels: {
                                formatter: function () {
                                    return Highcharts.dateFormat('%H:%M', this.value);
                                }
                            }
                        },
                        yAxis: {
                            title: {
                                text: ''
                            },
                            min: 0 
                        },
                        tooltip: {
                            valueSuffix: ' MW',
                            xDateFormat: '<b>时间:' + '%H:%M:%S' + '</b>',
                            crosshairs: {
                                width: 1,
                                color: 'red'
                            },
                            shared: true
                        },
                        plotOptions: {
                            spline: {
                                lineWidth: 0.5,
                                states: {
                                    hover: {
                                        lineWidth: 0.5
                                    }
                                },
                                marker: {
                                    enabled: false
                                },
                                pointInterval: 1800000, // 半小时
                                pointStart: Date.UTC(new Date().getYear(), new Date().getMonth(), new Date().getDay(), 0, 0, 0)
                            }
                        },
                        series: json.chart
                        , exporting: {
                            enabled: false //用来设置是否显示‘打印’,'导出'等功能按钮，不设置时默认为显示 
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
                '#058dc7', '#50b432', '#ed561b'
                ],
                        xAxis: {
                            type: 'datetime',
                            labels: {
                                formatter: function () {
                                    return Highcharts.dateFormat('%H:%M', this.value);
                                }
                            }
                        },
                        yAxis: {
                            title: {
                                text: ''
                            },
                            min: 0 
                        },
                        tooltip: {
                            valueSuffix: ' MW',
                            xDateFormat: '<b>时间:' + '%H:%M:%S' + '</b>',
                            crosshairs: {
                                width: 1,
                                color: 'red'
                            },
                            shared: true
                        },
                        plotOptions: {
                            spline: {
                                lineWidth: 0.5,
                                states: {
                                    hover: {
                                        lineWidth: 0.5
                                    }
                                },
                                marker: {
                                    enabled: false
                                },
                                //                                pointInterval: 3600000, // one hour
                                //                                pointStart: Date.UTC(2009, 9, 6, 0, 0, 0)
                                pointInterval: 1800000, // 半小时
                                pointStart: Date.UTC(new Date().getYear(), new Date().getMonth(), new Date().getDay(), 0, 0, 0)
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


//            $.ajax({
//                url: "MainConnect.aspx?funCode=GetFDFHValue",
//                type: "POST",
//                beforeSend: function () {
//                    //Handle the beforeSend event
//                },
//                success: function (json) {
//                    //json = eval("("+json+")");
//                    var json = $.parseJSON(json);
//                    $("#FDFH").html(ControlString(json.FDFH));

//                },
//                error: function (x, e) {
//                    alert(x.responseText);
//                },
//                complete: function () {
//                    //Handle the complete event
//                }
//            });


        }


        function LOADCHARTS() {

            $("#hd_progressbar").progressbar({
                value: 0
            })
            $("#sd_progressbar").progressbar({
                value: 0
            })
            $("#fd_progressbar").progressbar({
                value: 0
            })
            $("#tyn_progressbar").progressbar({
                value: 0
            })
            $("#fbs_progressbar").progressbar({
                value: 0
            })
            $("#qt_progressbar").progressbar({
                value: 0
            })
            $("#hdss_progressbar").progressbar({
                value: 0
            })
            $("#sdss_progressbar").progressbar({
                value: 0
            })
            $("#fdss_progressbar").progressbar({
                value: 0
            })
            $("#fbsss_progressbar").progressbar({
                value: 0
            })
            $("#tynss_progressbar").progressbar({
                value: 0
            })
            $("#srzss_progressbar").progressbar({
                value: 0
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
                '#058dc7', '#50b432', '#ed561b'
                ],
                xAxis: {
                    type: 'datetime',
                    labels: {
                        formatter: function () {
                            return Highcharts.dateFormat('%H:%M', this.value);
                        }
                    }
                },
                yAxis: {
                    title: {
                        text: ''
                    },
                    min: 0
                },
                tooltip: {
                    valueSuffix: ' MW',
                    xDateFormat: '<b>时间:' + '%H:%M:%S' + '</b>',
                    crosshairs: {
                        width: 1,
                        color: 'red'
                    },
                    shared: true
                },
                plotOptions: {
                    spline: {
                        lineWidth: 0.5,
                        states: {
                            hover: {
                                lineWidth: 0.5
                            }
                        },
                        marker: {
                            enabled: false
                        },
                        pointInterval: 3600000, // one hour
                        pointStart: Date.UTC(new Date().getYear(), new Date().getMonth(), new Date().getDay(), 0, 0, 0)
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
                '#058dc7', '#50b432', '#ed561b'
                ],
                xAxis: {
                    type: 'datetime',
                    labels: {
                        formatter: function () {
                            return Highcharts.dateFormat('%H:%M', this.value);
                        }
                    }
                },
                yAxis: {
                    title: {
                        text: ''
                    },
                    min: 0 
                },
                tooltip: {
                    valueSuffix: ' MW',
                    xDateFormat: '<b>时间:' + '%H:%M:%S' + '</b>',
                    crosshairs: {
                        width: 1,
                        color: 'red'
                    },
                    shared: true
                },
                plotOptions: {
                    spline: {
                        lineWidth: 0.5,
                        states: {
                            hover: {
                                lineWidth: 0.5
                            }
                        },
                        marker: {
                            enabled: false
                        },
                        pointInterval: 3600000, // one hour
                        pointStart: Date.UTC(new Date().getYear(), new Date().getMonth(), new Date().getDay(), 0, 0, 0)
                    }
                },
                series: [{
                    name: '分布式',
                    data: [4.3, 5.1, 4.3, 5.2, 5.4, 4.7, 3.5, 4.1, 5.6, 7.4, 6.9, 7.1,
                    7.1, 7.5, 8.1, 6.8, 3.4, 2.1, 1.9, 2.8, 2.9, 1.3, 4.4, 4.2,
                    3.0, 3.0]

                }, {
                    name: '太阳能',
                    data: [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.0, 0.3, 0.0,
                    3.0, 3.3, 4.8, 5.0, 4.8, 5.0, 3.2, 2.0, 0.9, 0.4, 0.3, 0.5, 0.4]
                }, {
                    name: '生物质',
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
                '#058dc7', '#50b432', '#ed561b'
                ],
                xAxis: {
                    type: 'datetime',
                    labels: {
                        formatter: function () {
                            return Highcharts.dateFormat('%H:%M', this.value);
                        }
                    }
                },
                yAxis: {
                    title: {
                        text: ''
                    },
                    min: 0 

                },
                tooltip: {
                    valueSuffix: ' MW',
                    xDateFormat: '<b>时间:' + '%H:%M:%S' + '</b>',
                    crosshairs: {
                        width: 1,
                        color: 'red'
                    },
                    shared: true
                },
                plotOptions: {
                    spline: {
                        lineWidth: 0.5,
                        states: {
                            hover: {
                                lineWidth: 0.5
                            }
                        },
                        marker: {
                            enabled: false
                        },
                        pointInterval: 3600000, // one hour
                        pointStart: Date.UTC(new Date().getYear(), new Date().getMonth(), new Date().getDay(), 0, 0, 0)
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
        }

        function Jump(p) {

            if (p == "map") {
                $("#map").hide();
                $("#top").show();
                //$("#box").show();
                $("#div1").height($("#div1").height() + 765);
                //$("#div2").height($("#div2").height() + 765);
                //$("#gmap").height($("#gmap").height() + 765);
                $("#gmap").css("display", "block");
            }
            if (p == "top") {
                $("#top").hide();
                $("#map").show();
                // $("#box").hide();
                $("#div1").height($("#div1").height() - 765);
                //$("#div2").height($("#div2").height() - 765);
                //$("#gmap").height($("#gmap").height() - 765);
                $("#gmap").css("display", "none");

            }
        }
        //跳转到风电
        function GoToFd() {
            window.location.href = 'Connect/FDConnect.aspx?tag=1';
        }
    </script>
</head>
<body style="background-color: #F7F7FF">
    <a name="A0" id="A0"></a>
    <form id="form1" runat="server">
    <%--<div id="div1" style="width: 1000px; height: 600px; background-color: #023668; margin: 5px auto;">
        <div style="width: 990px; height: 60px; float: left; background-image: url(img/20131211142227.png);
            padding: 5px">
            <div id="ZRL" style="width: 190px; height: 60px; float: left; font-size: 22px; color: White;">
                装机容量</br><label>8,888,888<label style=" font-size:14px"> MW</label></label></div>
            <div id="ZFH" style="width: 190px; height: 60px; float: left; font-size: 22px; color: White;">
                有功功率</br><label>8,888,888<label style=" font-size:14px"> MW</label></label></div>
            <div id="DDL" style="width: 190px; height: 60px; float: left; font-size: 22px; color: White;">
                日发电量</br><label>8,888,888<label style=" font-size:14px"> 万kWh</label></label></div>
            <div id="MDL" style="width: 190px; height: 60px; float: left; font-size: 22px; color: White;">
                月发电量</br><label>8,888,888<label style=" font-size:14px"> 亿kWh</label></label></div>
            <div id="YDL" style="width: 190px; height: 60px; float: left; font-size: 22px; color: White;">
                年发电量</br><label>8,888,888<label style=" font-size:14px"> 亿kWh</label></label></div>
        </div>
        <div style="width: 310px; height: 110px; border: 1px solid #184C78; float: left;margin: 0.5px; padding: 10px">
            <div style="width: 310px; height: 30px; float: left; font-size: 22px; color: White; text-align:left">
            火&nbsp;&nbsp;电&nbsp;<span style="font-size: 11px; color: White;">装机容量&nbsp;</span><div id="HDRL" style="display: inline">67945</div><span style="font-size: 11px; color: White;">&nbsp;日发电量&nbsp;</span><div id="HDDDL" style="display: inline">29654</div>
            </div>
            <div style="width: 310px; height: 30px; float: left; font-size: 22px; color: White;text-align: center">
                <span style="font-size: 11px; color: White;">&nbsp;实时负荷&nbsp;</span><div id="HDFH" style="display: inline">29654</div>
            </div>
            <div style="width: 310px; height: 40px; float: left; border-radius: 5px; background-color:#AFDFF8;
                text-align: center; font-size: 12px; color: #002E5C; padding-top: 2px">计划完成率<div id="hd_progressbar" style="width: 280px; margin: auto">
                </div>
            </div>
        </div>
        <div style="width: 310px; height: 110px; border: 1px solid #184C78; float: left;
            margin: 0.5px; padding: 10px">
            <div style="width: 310px; height: 30px; float: left; font-size: 22px; color: White;
                text-align: left">
                水&nbsp;&nbsp;电&nbsp;<span style="font-size: 11px; color: White;">装机容量&nbsp;</span><div
                    id="SDRL" style="display: inline">67945</div>
                <span style="font-size: 11px; color: White;">&nbsp;日发电量&nbsp;</span><div id="SDDDL"
                    style="display: inline">29654</div>
            </div>
            <div style="width: 310px; height: 30px; float: left; font-size: 22px; color: White;
                text-align: center">
                <span style="font-size: 11px; color: White;">&nbsp;实时负荷&nbsp;</span><div id="SDFH"
                    style="display: inline">29654</div>
            </div>
            <div style="width: 310px; height: 40px; float: left; border-radius: 5px; background-color: #AFDFF8;
                text-align: center; font-size: 12px; color: #002E5C; padding-top: 2px">
                计划完成率
                <div id="sd_progressbar" style="width: 280px; margin: auto">
                </div>
            </div>
        </div>
        <div style="width: 310px; height: 110px; border: 1px solid #184C78; float: left;
            margin: 0.5px; padding: 10px">
            <div style="width: 310px; height: 30px; float: left; font-size: 22px; color: White;
                text-align: left">
                风&nbsp;&nbsp;电&nbsp;<span style="font-size: 11px; color: White;">装机容量&nbsp;</span><div
                    id="FDRL" style="display: inline">67945</div>
                <span style="font-size: 11px; color: White;">&nbsp;日发电量&nbsp;</span><div id="FDDDL"
                    style="display: inline">29654</div>
            </div>
            <div style="width: 310px; height: 30px; float: left; font-size: 22px; color: White;
                text-align: center">
                <span style="font-size: 11px; color: White;">&nbsp;实时负荷&nbsp;</span><div id="FDFH"
                    style="display: inline">29654</div>
            </div>
            <div style="width: 310px; height: 40px; float: left; border-radius: 5px; background-color: #AFDFF8;
                text-align: center; font-size: 12px; color: #002E5C; padding-top: 2px">计划完成率<div id="fd_progressbar" style="width: 280px; margin: auto">
                </div>
            </div>
        </div>
        <div style="width: 310px; height: 110px; border: 1px solid #184C78; float: left;
            margin: 0.5px; padding: 10px">
            <div style="width: 310px; height: 30px; float: left; font-size: 22px; color: White;
                text-align: left">
                太阳能&nbsp;<span style="font-size: 11px; color: White;">装机容量&nbsp;</span><div id="TYNRL" style="display: inline">67945</div>
                <span style="font-size: 11px; color: White;">&nbsp;日发电量&nbsp;</span><div id="TYNDDL" style="display: inline">29654</div>
            </div>
            <div style="width: 310px; height: 30px; float: left; font-size: 22px; color: White;
                text-align: center">
                <span style="font-size: 11px; color: White;">&nbsp;实时负荷&nbsp;</span><div id="TYNFH" style="display: inline">29654</div>
            </div>
            <div style="width: 310px; height: 40px; float: left; border-radius: 5px; background-color: #AFDFF8;
                text-align: center; font-size: 12px; color: #002E5C; padding-top: 2px">
                计划完成率
                <div id="tyn_progressbar" style="width: 280px; margin: auto">
                </div>
            </div>
        </div>
        <div style="width: 310px; height: 110px; border: 1px solid #184C78; float: left;
            margin: 0.5px; padding: 10px">
            <div style="width: 310px; height: 30px; float: left; font-size: 22px; color: White;
                text-align: left">
                分布式&nbsp;<span style="font-size: 11px; color: White;">装机容量&nbsp;</span><div id="FBSRL" style="display: inline">67945</div>
                <span style="font-size: 11px; color: White;">&nbsp;日发电量&nbsp;</span><div id="FBSDDL" style="display: inline">29654</div>
            </div>
            <div style="width: 310px; height: 30px; float: left; font-size: 22px; color: White;
                text-align: center">
                <span style="font-size: 11px; color: White;">&nbsp;实时负荷&nbsp;</span><div id="FBSFH" style="display: inline">29654</div>
            </div>
            <div style="width: 310px; height: 40px; float: left; border-radius: 5px; background-color: #AFDFF8;
                text-align: center; font-size: 12px; color: #002E5C; padding-top: 2px">计划完成率
                <div id="fbs_progressbar" style="width: 280px; margin: auto">
                </div>
            </div>
        </div>
        <div style="width: 310px; height: 110px; border: 1px solid #184C78; float: left;
            margin: 0.5px; padding: 10px">
            <div style="width: 310px; height: 30px; float: left; font-size: 22px; color: White;
                text-align: left">
                其&nbsp;&nbsp;它&nbsp;<span style="font-size: 11px; color: White;">装机容量&nbsp;</span><div id="SRZRL" style="display: inline">67945</div>
                <span style="font-size: 11px; color: White;">&nbsp;日发电量&nbsp;</span><div id="SRZDDL"
                    style="display: inline">29654</div>
            </div>
            <div style="width: 310px; height: 30px; float: left; font-size: 22px; color: White;
                text-align: center">
                <span style="font-size: 11px; color: White;">&nbsp;实时负荷&nbsp;</span><div id="SRZFH"
                    style="display: inline">29654</div>
            </div>
            <div style="width: 310px; height: 40px; float: left; border-radius: 5px; background-color: #AFDFF8;
                text-align: center; font-size: 12px; color: #002E5C; padding-top: 2px">计划完成率
                <div id="qt_progressbar" style="width: 280px; margin: auto">
                </div>
            </div>
        </div>--%>
    <table height="100%" width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#f4f4f4">
        <tr>
            <td>
                <div>
                    <table height="100%" width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#0568bd">
                        <tr>
                            <td class="div_title_1">
                                <div class="text_1" id="ZRL">
                                    12345678</div>
                            </td>
                            <td class="div_fg">
                            </td>
                            <td class="div_title_2">
                                <div class="text_1" id="ZFH">
                                    12345678</div>
                            </td>
                            <td class="div_fg">
                            </td>
                            <td class="div_title_3">
                                <div class="text_1" id="DDL">
                                    1234567</div>
                            </td>
                            <td class="div_fg">
                            </td>
                            <td class="div_title_4">
                                <div class="text_1" id="MDL">
                                    1234567</div>
                            </td>
                            <td class="div_fg">
                            </td>
                            <td class="div_title_5">
                                <div class="text_1" id="YDL">
                                    1234567</div>
                            </td>
                        </tr>
                    </table>
                </div>
            </td>
        </tr>
        <tr>
            <td>
                <div>
                    <table height="100%" width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#ffffff">
                        <tr>
                            <td class="div_table_1">
                            </td>
                            <td class="div_table_1" align="center" valign="middle">
                                装机容量
                            </td>
                            <td class="div_table_1" align="center" valign="middle">
                                日发电量&nbsp;&nbsp;&nbsp;&nbsp;
                            </td>
                            <td class="div_table_1" align="center" valign="middle">
                                日均负荷&nbsp;&nbsp;&nbsp;&nbsp;
                            </td>
                            <td class="div_table_1" align="center" valign="middle">
                                计划完成率&nbsp;&nbsp;&nbsp;&nbsp;
                            </td>
                        </tr>
                        <tr>
                            <td class="div_table_2" align="center" valign="middle">
                                火&nbsp;&nbsp;&nbsp;电
                            </td>
                            <td class="div_table_2_1" align="center" valign="right">
                                <div class="text_2" id="HDRL">
                                    123456</div>
                                <div style="display: inline">
                                    <img src="img/DataZL_mw.jpg" /></div>
                            </td>
                            <td class="div_table_2_1" align="center" valign="right">
                                <div class="text_2" id="HDDDL">
                                    123456</div>
                                <div style="display: inline">
                                    <img src="img/DataZL_wkwh.jpg" /></div>
                            </td>
                            <td class="div_table_2_1" align="center" valign="right">
                                <div class="text_2" id="HDFH">
                                    123456</div>
                                <div style="display: inline">
                                    <img src="img/DataZL_wkw.jpg" /></div>
                            </td>
                            <td class="div_table_2_1" align="left">
                                <div id="hd_progressbar">
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td class="div_table_2" align="center" valign="middle">
                                水&nbsp;&nbsp;&nbsp;电
                            </td>
                            <td class="div_table_2_1" align="center" valign="right">
                                <div class="text_2" id="SDRL">
                                    123456</div>
                                <div style="display: inline">
                                    <img src="img/DataZL_mw.jpg" /></div>
                            </td>
                            <td class="div_table_2_1" align="center" valign="right">
                                <div class="text_2" id="SDDDL">
                                    123456</div>
                                <div style="display: inline">
                                    <img src="img/DataZL_wkwh.jpg" /></div>
                            </td>
                            <td class="div_table_2_1" align="center" valign="right">
                                <div class="text_2" id="SDFH">
                                    123456</div>
                                <div style="display: inline">
                                    <img src="img/DataZL_wkw.jpg" /></div>
                            </td>
                            <td class="div_table_2_1" align="left">
                                <div id="sd_progressbar">
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td class="div_table_2" align="center" valign="middle">
                                风&nbsp;&nbsp;&nbsp;电
                            </td>
                            <td class="div_table_2_1" align="center" valign="right">
                                <div class="text_2" id="FDRL">
                                    123456</div>
                                <div style="display: inline">
                                    <img src="img/DataZL_mw.jpg" /></div>
                            </td>
                            <td class="div_table_2_1" align="center" valign="right">
                                <div class="text_2" id="FDDDL">
                                    123456</div>
                                <div style="display: inline">
                                    <img src="img/DataZL_wkwh.jpg" /></div>
                            </td>
                            <td class="div_table_2_1" align="center" valign="right">
                                <div class="text_2" id="FDFH">
                                    123456</div>
                                <div style="display: inline">
                                    <img src="img/DataZL_wkw.jpg" /></div>
                            </td>
                            <td class="div_table_2_1" align="left">
                                <div id="fd_progressbar">
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td class="div_table_2" align="center" valign="middle">
                                太阳能
                            </td>
                            <td class="div_table_2_1" align="center" valign="right">
                                <div class="text_2" id="TYNRL">
                                    123456</div>
                                <div style="display: inline">
                                    <img src="img/DataZL_mw.jpg" /></div>
                            </td>
                            <td class="div_table_2_1" align="center" valign="right">
                                <div class="text_2" id="TYNDDL">
                                    123456</div>
                                <div style="display: inline">
                                    <img src="img/DataZL_wkwh.jpg" /></div>
                            </td>
                            <td class="div_table_2_1" align="center" valign="right">
                                <div class="text_2" id="TYNFH">
                                    123456</div>
                                <div style="display: inline">
                                    <img src="img/DataZL_wkw.jpg" /></div>
                            </td>
                            <td class="div_table_2_1" align="left">
                                <div id="tyn_progressbar">
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td class="div_table_2" align="center" valign="middle">
                                分布式
                            </td>
                            <td class="div_table_2_1" align="center" valign="right">
                                <div class="text_2" id="FBSRL">
                                    123456</div>
                                <div style="display: inline">
                                    <img src="img/DataZL_mw.jpg" /></div>
                            </td>
                            <td class="div_table_2_1" align="center" valign="right">
                                <div class="text_2" id="FBSDDL">
                                    123456</div>
                                <div style="display: inline">
                                    <img src="img/DataZL_wkwh.jpg" /></div>
                            </td>
                            <td class="div_table_2_1" align="center" valign="right">
                                <div class="text_2" id="FBSFH">
                                    123456</div>
                                <div style="display: inline">
                                    <img src="img/DataZL_wkw.jpg" /></div>
                            </td>
                            <td class="div_table_2_1" align="left">
                                <div id="fbs_progressbar">
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td class="div_table_2" align="center" valign="middle">
                                其&nbsp;&nbsp;&nbsp;他
                            </td>
                            <td class="div_table_2_1" align="center" valign="right">
                                <div class="text_2" id="SRZRL">
                                    123456</div>
                                <div style="display: inline">
                                    <img src="img/DataZL_mw.jpg" /></div>
                            </td>
                            <td class="div_table_2_1" align="center" valign="right">
                                <div class="text_2" id="SRZDDL">
                                    123456</div>
                                <div style="display: inline">
                                    <img src="img/DataZL_wkwh.jpg" /></div>
                            </td>
                            <td class="div_table_2_1" align="center" valign="right">
                                <div class="text_2" id="SRZFH">
                                    123456</div>
                                <div style="display: inline">
                                    <img src="img/DataZL_wkw.jpg" /></div>
                            </td>
                            <td class="div_table_2_1" align="left">
                                <div id="qt_progressbar">
                                </div>
                            </td>
                        </tr>
                    </table>
                </div>
            </td>
        </tr>
        <tr>
            <td>
                <div>
                    <table height="100%" width="100%" style="background-color: #f4f4f4" border="0" cellpadding="0"
                        cellspacing="0" bgcolor="#f4f4f4">
                        <tr>
                            <td colspan="3" style="background-image: url(img/DataZL_3.jpg); background-repeat: repeat-x;
                                height: 5px;">
                            </td>
                        </tr>
                        <tr>
                            <td colspan="3" align="left" valign="middle" class="div_title_6">
                                &nbsp;&nbsp;实时负荷
                            </td>
                        </tr>
                        <tr>
                            <td colspan="3" bgcolor="#f4f4f4">
                                <div style="width: 30%; height: 200px; float:left; margin-left:1%;" id="container1">
                                </div>
                                <div style="width: 30%; height: 200px;float:left;  margin-left:3%; margin-right:3%;" id="container2">
                                </div>
                                <div style="width: 30%; height: 200px;float:left;" id="container3">
                                </div>
                            </td>
                            <%--<div style="width: 1000px; height: 230px; float: left; margin-top: 1px">
            <div style="width: 1000px; height: 35px; float: left; background-image: url(img/20131211144004.png);
                font-size: 19px; color: White; line-height: 30px">
                &nbsp;负荷曲线
            </div>
            <div style="width: 1000px; height: 200px; float: left;">
                <div id="container1" style="width: 320px; height: 180px; float: left; margin: 5px">
                </div>
                <div id="container2" style="width: 320px; height: 180px; float: left; margin: 5px">
                </div>
                <div id="container3" style="width: 320px; height: 180px; float: left; margin: 5px">
                </div>
            </div>
        </div>--%>
                        </tr>
                    </table>
                </div>
            </td>
        </tr>
    </table>
    <%-- <div id="div2" style="width: 100%; height: 100%; float: left;">--%>
    <div class="div_title">
        &nbsp;项目分布<a name="A1" id="A1">&nbsp;</a> <a id="top" href="#A0" onclick="Jump('top')"
            style="display: none; float: right;">
            <img style="position: relative; margin-top: 10px; margin-right: 5px; border: 0;"
                src="img/up.png" /></a><a id="map" href="#A1" onclick="Jump('map')" style="float: right;"><img
                    style="position: relative; margin-top: 10px; margin-right: 5px; border: 0" src="img/down.png" /></a>
    </div>
    <div class="map">
    <div id="gmap" style="display: none; width:100%;">
        <div id="box" style="width: 100%; height: 100%; float: left; position: relative;">
            <dl name="gmap">
                <dt><a href="#nogo" name="title2" id="title2" onfocus="this.blur()"></a></dt>
                <dd>
                    <a href="ProvinceConnect.aspx" id="lmg" title="内蒙古" href="#" onfocus="this.blur()">
                    </a>
                </dd>
            </dl>
            <div style="position:absolute; width: 300px; height: 279px; margin-top:282px; margin-left:930px;">
                <table style="color: White">
                    <tr>
                        <td align="left">
                          <div style="width: 85px; height: 20px; float: left; border-radius: 5px; 
                                text-align: left; font-size: 12px; color: #002E5C; padding-top: 2px">
                                <div id="sdss_progressbar" style="width: 80px; margin: auto">
                                </div>
                            </div>
                            
                        </td>
                    </tr>
                    <tr>
                        <td>
                        </td>
                    </tr>
                    <tr>
                        <td>
                        </td>
                    </tr>
                    <tr>
                        <td>
                        </td>
                    </tr>
                    <tr>
                        <td align="left">
                      
                         <div onclick="GoToFd()" onmousemove=""  style="width: 85px; height: 20px;float: left; border-radius: 5px;  
                                text-align: left; font-size: 12px; color: #002E5C; padding-top: 2px">
                                <div id="fdss_progressbar" style="width: 80px; margin: auto">
                                </div>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>
                        </td>
                    </tr>
                     <tr>
                        <td>
                        </td>
                    </tr>
                    <tr>
                        <td>
                        </td>
                    </tr>
                    <tr>
                        <td>
                        </td>
                    </tr>
                    <tr>
                        <%--   <td>
                                <a href="Connect/FDConnect.aspx?tag=1">
                                     </a>
                            </td>--%>
                        <td align="left">
                           <div style="width: 85px; height: 20px; float: left; border-radius: 5px;  
                                text-align: left; font-size: 12px; color: #002E5C; padding-top: 2px">
                                <div id="hdss_progressbar" style="width: 80px; margin: auto">
                                </div>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>
                        </td>
                    </tr>
                    <tr>
                        <td>
                        </td>
                    </tr>
                    <tr>
                        <td>
                        </td>
                    </tr>
                    <tr>
                        <td align="left">
                            <div style="width: 85px; height: 20px; float: left; border-radius: 5px; 
                                text-align: left; font-size: 12px; color: #002E5C; padding-top: 2px">
                                <div id="fbsss_progressbar" style="width: 80px; margin: auto">
                                </div>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>
                        </td>
                    </tr>
                    <tr>
                        <td>
                        </td>
                    </tr>
                    <tr>
                        <td>
                        </td>
                    </tr>
                    <tr>
                        <td align="left">
                            <div style="width: 85px; height: 20px; float: left; border-radius: 5px;  
                                text-align: left; font-size: 12px; color: #002E5C; padding-top: 2px">
                                <div id="tynss_progressbar" style="width: 80px; margin: auto">
                                </div>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>
                        </td>
                    </tr>
                    <tr>
                        <td>
                        </td>
                    </tr>
                    <tr>
                        <td>
                        </td>
                    </tr>
                    <tr>
                        <td align="left">
                            <div style="width: 85px; height: 20px; float: left; border-radius: 5px; text-align: left; font-size: 12px; padding-top: 2px">
                                <div id="srzss_progressbar" style="width: 80px; margin: auto">
                                </div>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>
                        </td>
                    </tr>
                    <tr>
                        <td>
                        </td>
                    </tr>
                    <tr>
                        <td>
                        </td>
                    </tr>
                    <tr>
                        <td>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </div>
    </div>
    <%--</div>--%>
    </form>
</body>
</html>
