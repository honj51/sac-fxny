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

        $(function () {

            var highchartsOptions = Highcharts.setOptions(Highcharts.theme);

            LOADCHARTS();
            load();
            var int = self.setInterval("load()", 30000);

        });
        Highcharts.theme = {
            colors: ["#514F78", "#42A07B", "#9B5E4A", "#72727F", "#1F949A", "#82914E", "#86777F", "#42A07B"],
            chart: {
                className: 'skies',
                borderWidth: 0,
                plotShadow: true,
                plotBackgroundImage: 'img/skies.jpg',
                plotBackgroundColor: {
                    linearGradient: [0, 0, 250, 500],
                    stops: [
            [0, 'rgba(255, 255, 255, 1)'],
            [1, 'rgba(255, 255, 255, 0)']
         ]
                },
                plotBorderWidth: 1
            },
            title: {
                style: {
                    color: '#3E576F',
                    font: '16px Lucida Grande, Lucida Sans Unicode, Verdana, Arial, Helvetica, sans-serif'
                }
            },
            subtitle: {
                style: {
                    color: '#6D869F',
                    font: '12px Lucida Grande, Lucida Sans Unicode, Verdana, Arial, Helvetica, sans-serif'
                }
            },
            xAxis: {
                gridLineWidth: 0,
                lineColor: '#C0D0E0',
                tickColor: '#C0D0E0',
                labels: {
                    style: {
                        color: '#666',
                        fontWeight: 'bold'
                    }
                },
                title: {
                    style: {
                        color: '#666',
                        font: '12px Lucida Grande, Lucida Sans Unicode, Verdana, Arial, Helvetica, sans-serif'
                    }
                }
            },
            yAxis: {
                alternateGridColor: 'rgba(255, 255, 255, .5)',
                lineColor: '#C0D0E0',
                tickColor: '#C0D0E0',
                tickWidth: 1,
                labels: {
                    style: {
                        color: '#666',
                        fontWeight: 'bold'
                    }
                },
                title: {
                    style: {
                        color: '#666',
                        font: '12px Lucida Grande, Lucida Sans Unicode, Verdana, Arial, Helvetica, sans-serif'
                    }
                }
            },
            legend: {
                itemStyle: {
                    font: '9pt Trebuchet MS, Verdana, sans-serif',
                    color: '#3E576F'
                },
                itemHoverStyle: {
                    color: 'black'
                },
                itemHiddenStyle: {
                    color: 'silver'
                }
            },
            labels: {
                style: {
                    color: '#3E576F'
                }
            }
        };

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
                    $("#ZRL").html("装机容量</br><label>" + json.ZRL + "<label style='font-size:14px'>MW</label></label>");
                    $("#HDRL").html(json.HDRL);
                    $("#FDRL").html(json.FDRL);
                    $("#SDRL").html(json.SDRL);
                    $("#TYNRL").html(json.TYNRL);
                    $("#FBSRL").html(json.FBSRL);
                    $("#SRZRL").html(json.SRZRL);

                    //总负荷 产业负荷
                    $("#ZFH").html("有功功率</br><label>" + (json.ZFH + json.SDFH + json.HDFH).toFixed(2) + "<label style='font-size:14px'>MW</label></label>");
                    //$("#FDFH").html(json.FDFH);
                    $("#HDFH").html(json.HDFH);
                    $("#SDFH").html(json.SDFH);
                    $("#TYNFH").html(json.TYNFH);
                    $("#FBSFH").html(json.FBSFH);
                    $("#SRZFH").html(json.SRZFH);


                    //日月电量
                    $("#DDL").html("日发电量</br><label>" + (json.DDL + json.HDDDL + json.SDDDL).toFixed(2) + "<label style='font-size:14px'>万kWh</label></label>");
                    $("#FDDDL").html(json.FDDDL);
                    $("#HDDDL").html(json.HDDDL);
                    $("#SDDDL").html(json.SDDDL);
                    $("#TYNDDL").html(json.TYNDDL);
                    $("#FBSDDL").html(json.FBSDDL);
                    $("#SRZDDL").html(json.SRZDDL);

                    $("#MDL").html("月发电量</br><label>" + ((json.MDL + json.HDMDL + json.SDMDL) / 10000).toFixed(2) + "<label style='font-size:14px'>亿kWh</label></label>");

                    $("#YDL").html("年发电量</br><label>" + ((json.YDL + json.HDYDL + json.SDYDL) / 10000).toFixed(2) + "<label style='font-size:14px'>亿kWh</label></label>");

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
                '#32E1FC', '#0E91C9', '#023668'
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
                            min: 0,
                            minorGridLineWidth: 0,
                            gridLineWidth: 0,
                            alternateGridColor: null 
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
                                pointInterval: 3600000, // one hour
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
                '#32E1FC', '#0E91C9', '#023668'
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
                '#32E1FC', '#0E91C9', '#023668'
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
                '#2F7FD8', '#0E91C9', '#023668'
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


        function transfor() {
            alert(1111);
        }


        function Jump(p) {

            if (p == "map") {
                $("#map").hide();
                $("#top").show();
                $("#box").show();
                $("#div1").height($("#div1").height() + 765);
                $("#div2").height($("#div2").height() + 765);
            }
            if (p == "top") {
                $("#top").hide();
                $("#map").show();
                $("#box").hide();
                $("#div1").height($("#div1").height() - 765);
                $("#div2").height($("#div2").height() - 765);
            }
        }
    </script>
</head>
<body style="background-color: #F7F7FF">
    <a name="A0" id="A0"></a>
    <form id="form1" runat="server">
    <div id="div1" style="width: 1000px; height: 600px; background-color: #023668; margin: 5px auto;">
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
        </div>
        <div style="width: 1000px; height: 230px; float: left; margin-top: 1px">
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
        </div>
        <div id="div2" style="width: 1000px; height: 35px; float: left;">
            <div style="width: 1000px; height: 35px; float: left; background-image: url(img/20131211144004.png);
                font-size: 19px; color: White; line-height: 30px">
                &nbsp;项目分布<a name="A1" id="A1">&nbsp;</a> <a id="top" href="#A0" onclick="Jump('top')"
                    style="display: none; float: right;">
                    <img style="position: relative; margin-top: 10px; margin-right: 5px; border: 0;"
                        src="img/up.png" /></a><a id="map" href="#A1" onclick="Jump('map')" style="float: right;"><img
                            style="position: relative; margin-top: 10px; margin-right: 5px; border: 0" src="img/down.png" /></a>
            </div>
            <div id="box" style="width: 1000px; height: 765px; float: left; position: relative;
                display: none">
                
                <dl id="gmap" name="gmap">
                    <dt><a href="#nogo" name="title2" id="title2" onfocus="this.blur()"></a></dt>
                    <dd>
                        <a href="ProvinceConnect.aspx" id="lmg" title="内蒙古" href="#" onfocus="this.blur()">
                        </a>
                    </dd>
                </dl>
                <div style="position: absolute; width: 250px; height: 279px; top: 356px; left: 815px;">
                    <table style="color: White">
                        <tr>
                            <td>
                                <img src="img/火电图标.png" />
                            </td>
                            <td>
                                火电
                            </td>
                            <td align="left"> <div style="width: 85px; height: 20px; float: left; border-radius: 5px;background-color:#AFDFF8;
                text-align: left; font-size: 12px; color: #002E5C; padding-top: 2px"> <div id="hdss_progressbar" style="width:80px; margin: auto">
                </div>
            </div></td>
                        </tr>
                        <tr>
                            <td>
                                <img src="img/水电图标.png" />
                            </td>
                            <td>
                                水电
                            </td>
                             <td align="left"> <div style="width: 85px; height: 20px; float: left; border-radius: 5px; background-color:#AFDFF8;
                text-align: left; font-size: 12px; color: #002E5C; padding-top: 2px"> <div id="sdss_progressbar" style="width:80px; margin: auto">
                </div>
            </div></td>
                        </tr>
                        <tr>
                            <td>
                                <a href="Connect/FDConnect.aspx?tag=1">
                                    <img style="border: 0" src="img/风电图标.png" /></a>
                            </td>
                            <td>
                                风电
                            </td>
                             <td align="left"> <div style="width: 85px; height: 20px; float: left; border-radius: 5px; background-color:#AFDFF8;
                text-align: left; font-size: 12px; color: #002E5C; padding-top: 2px"> <div id="fdss_progressbar" style="width:80px; margin: auto">
                </div>
            </div></td>
                        </tr>
                        <tr>
                            <td>
                                <img src="img/分布式图标.png" />
                            </td>
                            <td>
                                分布式
                            </td>
                             <td align="left"> <div style="width: 85px; height: 20px; float: left; border-radius: 5px;  background-color:#AFDFF8;
                text-align: left; font-size: 12px; color: #002E5C; padding-top: 2px"> <div id="fbsss_progressbar" style="width:80px; margin: auto">
                </div>
            </div></td>
                        </tr>
                        <tr>
                            <td>
                                <img src="img/太阳能图标.png" />
                            </td>
                            <td>
                                太阳能
                            </td>
                             <td align="left"> <div style="width: 85px; height: 20px; float: left; border-radius: 5px;  background-color:#AFDFF8;
                text-align: left; font-size: 12px; color: #002E5C; padding-top: 2px"> <div id="tynss_progressbar" style="width:80px; margin: auto">
                </div>
            </div></td>
                        </tr>
                        <tr>
                            <td>
                                <img src="img/生物质图标.png" />
                            </td>
                            <td>
                                生物质
                            </td>
                             <td align="left"> <div style="width: 85px; height: 20px; float: left; border-radius: 5px; background-color:#AFDFF8; 
                text-align: left; font-size: 12px;   padding-top: 2px"> <div id="srzss_progressbar" style="width:80px; margin: auto">
                </div>
            </div></td>
                        </tr>
                        <tr>
                            <td>
                                <img src="img/核能图标.png" />
                            </td>
                            <td>
                                核能
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
        </div>
    </div>
    </form>
</body>
</html>
