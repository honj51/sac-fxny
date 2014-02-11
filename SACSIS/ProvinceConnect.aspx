<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ProvinceConnect.aspx.cs"
    Inherits="WebApplication2.ProvinceConnect" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>省份情况</title>
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
        #Table1 td
        {
            border: solid thin #6BA5BD;
        }
        #Table2 td
        {
            border: solid thin #6BA5BD;
        }
    </style>
    <script type="text/javascript" language="javascript">
        $(function () {
            LOADCHARTS();

             load();
            var int = self.setInterval("load()", 30000);

            
        });

        function load() {
            $.ajax({
                url: "ProvinceConnect.aspx?funCode=init",
                type: "POST",
                success: function (json) {
                    var json = $.parseJSON(json);
                    $("#zrl").html("装机容量</br><label>" + json.zrl + "<label style='font-size:14px'>MW</label></label>");
                    $("#zgl").html("有功功率</br><label>" + json.zgl + "<label style='font-size:14px'>MW</label></label>");
                    $("#ddl").html("日发电量</br><label>" + json.zrdl + "<label style='font-size:14px'>万kWh</label></label>");
                    $("#mdl").html("月发电量</br><label>" + json.zydl + "<label style='font-size:14px'>万kWh</label></label>");
                    $("#ydl").html("年发电量</br><label>" + json.zndl + "<label style='font-size:14px'>万kWh</label></label>");
                    $("#fdrl").html(json.zrl);
                    $("#fdrdl").html(json.zrdl);
                    $("#fd_progressbar").progressbar({
                        value: json.fdwcl
                    })

                    $("#zfh").html(json.zgl);
                    $("#fdfh").html(json.zgl);

                    $("#Td1").html(json.mgy1yxts + json.mgy2yxts + json.fldyxts + json.ssyxts);
                    $("#Td2").html(json.mgy1tjts + json.mgy2tjts + json.fldtjts + json.sstjts);
                    $("#Td3").html(json.mgy1zts + json.mgy2zts + json.fldzts + json.sszts - json.mgy1yxts - json.mgy2yxts - json.fldyxts - json.ssyxts - json.mgy1tjts - json.mgy2tjts - json.fldtjts - json.sstjts);

//                    $('#container4').highcharts({
//                        chart: {
//                            type: 'column'
//                        },
//                        title: {
//                            align: 'center',
//                            text: '装机容量',
//                            style:
//                    {
//                        color: '#3E576F',
//                        fontSize: '14px',
//                        fontFamily: '微软雅黑'
//                    }
//                        },
//                        subtitle: {
//                            text: ''
//                        },
//                        xAxis: {
//                            categories: [
//                    '风电', '太阳能'
//                ]
//                        },
//                        yAxis: {
//                            min: 0,
//                            title: {
//                                text: ''
//                            }
//                        },
//                        tooltip: {
//                            headerFormat: '<span style="font-size:10px">{point.key}</span><table>',
//                            pointFormat: '<tr><td style="color:{series.color};padding:0">{series.name}: </td>' +
//                    '<td style="padding:0"><b>{point.y:.1f} MW</b></td></tr>',
//                            footerFormat: '</table>',
//                            shared: true,
//                            useHTML: true
//                        },
//                        plotOptions: {
//                            column: {
//                                pointPadding: 0.02,
//                                borderWidth: 0
//                            }
//                        },
//                        series: [{
//                            name: '装机容量',
//                            data: [{
//                                y: json.zrl,
//                                name: '风电',
//                                color: '#023668'
//                            }, {
//                                y: 0,
//                                name: '太阳能',
//                                color: '#058DC7'
//                            }]

//                        }],
//                        exporting: {
//                            enabled: false //用来设置是否显示‘打印’,'导出'等功能按钮，不设置时默认为显示 
//                        },
//                        legend: {
//                            enabled: false
//                        }

//                    });
                    $('#container5').highcharts({
                        chart: {
                            plotBackgroundColor: null,
                            plotBorderWidth: null,
                            plotShadow: false,
                            margin: [5, 80, 5, 5]
                        },
                        title: {
                            align: 'left',
                            text: '机组状态',
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
                            name: '台数占比',
                            data: [{
                                y: json.mgy1yxts + json.mgy2yxts + json.fldyxts + json.ssyxts,
                                name: '运行',
                                color: '#0BAD00'
                            }, {
                                y: json.mgy1tjts + json.mgy2tjts + json.fldtjts + json.sstjts,
                                name: '停机',
                                color: '#CCCF00'
                            }, {
                                y: json.mgy1zts + json.mgy2zts + json.fldzts + json.sszts - json.mgy1yxts - json.mgy2yxts - json.fldyxts - json.ssyxts - json.mgy1tjts - json.mgy2tjts - json.fldtjts - json.sstjts,
                                name: '故障',
                                color: 'red'
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


                    $("#mgy1fh").html(json.mgy1fh);
                    $("#mgy2fh").html(json.mgy2fh);
                    $("#fldfh").html(json.fldfh);
                    $("#ssfh").html(json.ssfh);

                    $("#mgy1fs").html(json.mgy1fs);
                    $("#mgy2fs").html(json.mgy2fs);
                    $("#fldfs").html(json.fldfs);
                    $("#ssfs").html(json.ssfs);

                    $("#mgy1rdl").html(json.mgy1rdl);
                    $("#mgy2rdl").html(json.mgy2rdl);
                    $("#fldrdl").html(json.fldrdl);
                    $("#ssrdl").html(json.ssrdl);

                    $("#mgy1ydl").html(json.mgy1ydl);
                    $("#mgy2ydl").html(json.mgy2ydl);
                    $("#fldydl").html(json.fldydl);
                    $("#ssydl").html(json.ssydl);

                    $("#mgy1jhdl").html(json.mgy1jhdl + "%");
                    $("#mgy2jhdl").html(json.mgy2jhdl + "%");
                    $("#fldjhdl").html(json.fldjhdl + "%");
                    $("#ssjhdl").html(json.ssjhdl + "%");

                    $("#mgy1yxts").html(json.mgy1yxts);
                    $("#mgy2yxts").html(json.mgy2yxts);
                    $("#fldyxts").html(json.fldyxts);
                    $("#ssyxts").html(json.ssyxts);

                    $("#mgy1tjts").html(json.mgy1tjts);
                    $("#mgy2tjts").html(json.mgy2tjts);
                    $("#fldtjts").html(json.fldtjts);
                    $("#sstjts").html(json.sstjts);

                    $("#mgy1yxl").html(json.mgy1yxl + "%");
                    $("#mgy2yxl").html(json.mgy2yxl + "%");
                    $("#fldyxl").html(json.fldyxl + "%");
                    $("#ssyxl").html(json.ssyxl + "%");

                    $("#mgy1tjl").html(json.mgy1tjl + "%");
                    $("#mgy2tjl").html(json.mgy2tjl + "%");
                    $("#fldtjl").html(json.fldtjl + "%");
                    $("#sstjl").html(json.sstjl + "%");

                }
            });

            $.ajax({
                url: "ProvinceConnect.aspx?funCode=initCharts&chartNum=1",
                type: "POST",
                success: function (json) {
                    //json = eval("("+json+")");
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
                '#2E7FD8'
                ],
                        xAxis: {
                            type: 'datetime',
                            labels: {
                                formatter: function () {
                                    return Highcharts.dateFormat('%H:%M', this.value);
                                }
                            }
                            //            dateTimeLabelFormats:
                            //                        {
                            //                            second: '%Y-%m-%d'
                            //                        }

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
                                pointStart: Date.UTC(new Date().getYear(), new Date().getMonth(), new Date().getDay(), 0, 0, 0)
                            }
                        },
                        series: json.chart, exporting: {
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
                '#2E7FD8'
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
                                pointStart: Date.UTC(new Date().getYear(), new Date().getMonth(), new Date().getDay(), 0, 0, 0)
                            }
                        },
                        series: [{
                            name: '太阳能',
                            data: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

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
            });
            $.ajax({
                url: "ProvinceConnect.aspx?funCode=initCharts&chartNum=3",
                type: "POST",
                success: function (json) {
                    //json = eval("("+json+")");
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
                                pointStart: Date.UTC(new Date().getYear(), new Date().getMonth(), new Date().getDay(), 0, 0, 0)
                            }
                        },
                        series: json.chart, exporting: {
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
        }

        function LOADCHARTS() {

            $("#fd_progressbar").progressbar({
                value: 0
            })
            $("#tyn_progressbar").progressbar({
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
                '#2E7FD8'
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
                        pointStart: Date.UTC(new Date().getYear(), new Date().getMonth(), new Date().getDay(), 0, 0, 0)
                    }
                },
                series: [{
                    name: '风电',
                    data: [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.0, 0.3, 0.0,
                    3.0, 3.3, 4.8, 5.0, 4.8, 5.0, 3.2, 2.0, 0.9, 0.4, 0.3, 0.5, 0.4]
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
                '#2E7FD8'
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
                        pointStart: Date.UTC(new Date().getYear(), new Date().getMonth(), new Date().getDay(), 0, 0, 0)
                    }
                },
                series: [{
                    name: '太阳能',
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

//            $('#container4').highcharts({
//                chart: {
//                    type: 'column'
//                },
//                title: {
//                    align: 'center',
//                    text: '装机容量',
//                    style:
//                    {
//                        color: '#3E576F',
//                        fontSize: '14px',
//                        fontFamily: '微软雅黑'
//                    }
//                },
//                subtitle: {
//                    text: ''
//                },
//                xAxis: {
//                    categories: [
//                    '风电', '太阳能'
//                ]
//                },
//                yAxis: {
//                    min: 0,
//                    title: {
//                        text: ''
//                    }
//                },
//                tooltip: {
//                    headerFormat: '<span style="font-size:10px">{point.key}</span><table>',
//                    pointFormat: '<tr><td style="color:{series.color};padding:0">{series.name}: </td>' +
//                    '<td style="padding:0"><b>{point.y:.1f} mm</b></td></tr>',
//                    footerFormat: '</table>',
//                    shared: true,
//                    useHTML: true
//                },
//                plotOptions: {
//                    column: {
//                        pointPadding: 0.02,
//                        borderWidth: 0
//                    }
//                },
//                series: [{
//                    name: '装机容量',
//                    data: [{
//                        y: 30.94,
//                        name: '风电',
//                        color: '#023668'
//                    }, {
//                        y: 12.15,
//                        name: '太阳能',
//                        color: '#058DC7'
//                    }]

//                }],
//                exporting: {
//                    enabled: false //用来设置是否显示‘打印’,'导出'等功能按钮，不设置时默认为显示 
//                },
//                legend: {
//                    enabled: false
//                }

//            });
            $('#container5').highcharts({
                chart: {
                    plotBackgroundColor: null,
                    plotBorderWidth: null,
                    plotShadow: false,
                    margin: [5, 80, 5, 5]
                },
                title: {
                    align: 'left',
                    text: '机组状态',
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
                    name: '台数占比',
                    data: [{
                        y: 30.94,
                        name: '运行',
                        color: '#0BAD00'
                    }, {
                        y: 12.15,
                        name: '停机',
                        color: '#CCCF00'
                    }, {
                        y: 12.15,
                        name: '故障',
                        color: 'red'
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

    </script>
</head>
<body style="background-color: #F7F7FF;">
    <form id="form1">
    <div style="width: 1000px; height: 1480px; background-color: #023668; margin: 5px auto;">
        <div style="width: 990px; height: 60px; float: left; background-image: url(img/20131211142227.png);
            padding: 5px">
            <div id="zrl" style="width: 190px; height: 60px; float: left; font-size: 22px; color: White;">
                装机容量</br><label>8,888,888<label style='font-size:14px'>MW</label></label></div>
            <div id="zgl" style="width: 190px; height: 60px; float: left; font-size: 22px; color: White;">
                有功功率</br><label>8,888,888<label style='font-size:14px'>MW</label></label></div>
            <div id="ddl" style="width: 190px; height: 60px; float: left; font-size: 22px; color: White;">
                日发电量</br><label>8,888,888<label style='font-size:14px'>万kWh</label></label></div>
            <div id="mdl" style="width: 190px; height: 60px; float: left; font-size: 22px; color: White;">
                月发电量</br><label>8,888,888<label style='font-size:14px'>万kWh</label></label></div>
            <div id="ydl" style="width: 190px; height: 60px; float: left; font-size: 22px; color: White;">
                年发电量</br><label>8,888,888<label style='font-size:14px'>万kWh</label></label></div>
        </div>
        <div style="width: 477px; height: 80px; border: 1px solid #184C78; float: left; margin: 0.5px;
            padding: 10px;">
            <div style="width: 310px; margin: auto">
                <div style="width: 310px; height: 30px; float: left; font-size: 22px; color: White;
                    text-align: center">
                    风&nbsp;&nbsp;电&nbsp;<span style="font-size: 11px; color: White;">装机容量&nbsp;</span><div
                        id="fdrl" style="display: inline">
                        67945</div>
                    <span style="font-size: 11px; color: White;">&nbsp;日发电量&nbsp;</span><div id="fdrdl"
                        style="display: inline">
                        29654</div>
                </div>
                <div style="width: 310px; height: 40px; float: left; border-radius: 5px; background-color: White;
                    text-align: center; font-size: 12px; color: #002E5C; padding-top: 2px">
                    计划完成率
                    <div id="fd_progressbar" style="width: 280px; margin: auto">
                    </div>
                </div>
            </div>
        </div>
        <div style="width: 477px; height: 80px; border: 1px solid #184C78; float: left; margin: 0.5px;
            padding: 10px">
            <div style="width: 310px; margin: auto">
                <div style="width: 310px; height: 30px; float: left; font-size: 22px; color: White;
                    text-align: center;">
                    太阳能&nbsp;<span style="font-size: 11px; color: White;">装机容量&nbsp;</span>0<span
                        style="font-size: 11px; color: White;">&nbsp;日发电量&nbsp;</span>0
                </div>
                <div style="width: 310px; height: 40px; float: left; border-radius: 5px; background-color: White;
                    text-align: center; font-size: 12px; color: #002E5C; padding-top: 2px">
                    计划完成率
                    <div id="tyn_progressbar" style="width: 280px; margin: auto">
                    </div>
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
        <div style="width: 1000px; height: 230px; float: left;">
            <div style="width: 1000px; height: 35px; float: left; background-image: url(img/20131211144004.png);
                font-size: 19px; color: White; line-height: 30px">
                &nbsp;项目情况<label style="margin-left: 590px">实时负荷数据</label>
            </div>
            <div style="width: 1000px; height: 200px; float: left;">
                <div id="Div1" style="width: 320px; height: 180px; float: left; margin: 5px;">
                    <table id="Table2" style="border-collapse: collapse; background-color: White; width: 310px;
                        height: 175px; text-align: center; margin: 2px 8px" border="1">
                        <tr>
                            <td style="width: 100px;">
                                运行台数
                            </td>
                            <td id="Td1">
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 100px;">
                                停机台数
                            </td>
                            <td id="Td2">
                            </td>
                        </tr>
                        <tr>
                            <td>
                                故障台数
                            </td>
                            <td id="Td3">
                                
                            </td>
                        </tr>
                    </table>
                </div>
                <div id="container5" style="width: 320px; height: 180px; float: left; margin: 5px">
                </div>
                <div id="Div3" style="width: 320px; height: 180px; float: left; margin: 5px;">
                    <table id="tabId" style="border-collapse: collapse; background-color: White; width: 310px;
                        height: 175px; text-align: center; margin: 2px 8px" border="1">
                        <tr>
                            <td style="width: 100px;">
                                总负荷
                            </td>
                            <td id="zfh">
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 100px;">
                                风电
                            </td>
                            <td id="fdfh">
                            </td>
                        </tr>
                        <tr>
                            <td>
                                太阳能
                            </td>
                            <td>
                                0
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
        </div>
        <div style="width: 1000px; height: 650px; float: left;">
            <div style="width: 1000px; height: 35px; float: left; background-image: url(img/20131211144004.png);
                font-size: 19px; color: White; line-height: 30px">
                &nbsp;内蒙古
            </div>
            <div id="box" style="width: 1000px; height: 600px; float: left; background-image: url(img/内蒙古地图-2.jpg);">
                <a href="MainConnect.aspx" style="float: right; margin-bottom: 200px; margin-right: 70px; height: 93px;
                    width: 115px;"><img style="border: 0" src="img/back.jpg" /></a>
                <div style="float: right; margin-top: 460px; margin-right: 5px; width: 106px; height: 79px;
                    top: 1081px;">
                    <table style="color: White">
                        <tr>
                            <td>
                            <a href="Connect/FDConnect.aspx?type=2&tag=2&area=内蒙">
                                <img src="img/风电图标.png" /></a>
                            </td>
                            <td>
                                风电
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <img src="img/太阳能图标.png" />
                            </td>
                            <td>
                                太阳能
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
        </div>
        <div style="width: 1000px; height: 190px; float: left;">
            <div style="width: 1000px; height: 35px; float: left; background-image: url(img/20131211144004.png);
                font-size: 19px; color: White; line-height: 30px">
                &nbsp;省份详细数据
            </div>
            <table id="Table1" style="border-collapse: collapse; background-color: White; width: 985px;
                text-align: center; margin-left: 8px; margin-top: 2px; height: 150px" border="1">
                <tr>
                    <td style="width: 80px;">
                        类型
                    </td>
                    <td style="width: 100px;">
                        风场
                    </td>
                    <td style="width: 70px;">
                        装机容量
                    </td>
                    <td style="width: 60px;">
                        负荷
                    </td>
                    <td style="width: 60px;">
                        风速
                    </td>
                    <td style="width: 70px;">
                        日发电量
                    </td>
                    <td style="width: 80px;">
                        年累计电量
                    </td>
                    <td style="width: 70px;">
                        完成率
                    </td>
                    <td style="width: 70px;">
                        运行台数
                    </td>
                    <td style="width: 70px;">
                        停机台数
                    </td>
                    <td style="width: 70px;">
                        投运率
                    </td>
                    <td style="width: 70px;">
                        停机率
                    </td>

                </tr>
                <tr>
                    <td rowspan="4">
                        风电
                    </td>
                    <td>
                        玫瑰营一期
                    </td>
                    <td>
                        49.5
                    </td>
                    <td id="mgy1fh">
                        &nbsp;
                    </td>
                    <td id="mgy1fs">
                        &nbsp;
                    </td>
                    <td id="mgy1rdl">
                        &nbsp;
                    </td>
                    <td id="mgy1ydl">
                        &nbsp;
                    </td>
                    <td id="mgy1jhdl">
                        &nbsp;
                    </td>
                    <td id="mgy1yxts">
                        &nbsp;
                    </td>
                    <td id="mgy1tjts">
                        &nbsp;
                    </td>
                    <td id="mgy1yxl">
                        &nbsp;
                    </td>
                    <td id="mgy1tjl">
                        &nbsp;
                    </td>
                </tr>
                <tr>
                    <td>
                        玫瑰营二期
                    </td>
                    <td>
                        200
                    </td>
                    <td id="mgy2fh">
                        &nbsp;
                    </td>
                    <td id="mgy2fs">
                        &nbsp;
                    </td>
                    <td id="mgy2rdl">
                        &nbsp;
                    </td>
                    <td id="mgy2ydl">
                        &nbsp;
                    </td>
                    <td id="mgy2jhdl">
                        &nbsp;
                    </td>
                    <td id="mgy2yxts">
                        &nbsp;
                    </td>
                    <td id="mgy2tjts">
                        &nbsp;
                    </td>
                    <td id="mgy2yxl">
                        &nbsp;
                    </td>
                    <td id="mgy2tjl">
                        &nbsp;
                    </td>
                </tr>
                <tr>
                    <td>
                        富丽达风场
                    </td>
                    <td>
                        49.5
                    </td>
                    <td id="fldfh">
                        &nbsp;
                    </td>
                    <td id="fldfs">
                        &nbsp;
                    </td>
                    <td id="fldrdl">
                        &nbsp;
                    </td>
                    <td id="fldydl">
                        &nbsp;
                    </td>
                    <td id="fldjhdl">
                        &nbsp;
                    </td>
                    <td id="fldyxts">
                        &nbsp;
                    </td>
                    <td id="fldtjts">
                        &nbsp;
                    </td>
                    <td id="fldyxl">
                        &nbsp;
                    </td>
                    <td id="fldtjl">
                        &nbsp;
                    </td>
                </tr>
                <tr>
                    <td>
                        三胜风场
                    </td>
                    <td>
                        49.5
                    </td>
                    <td id="ssfh">
                        &nbsp;
                    </td>
                    <td id="ssfs">
                        &nbsp;
                    </td>
                    <td id="ssrdl">
                        &nbsp;
                    </td>
                    <td id="ssydl">
                        &nbsp;
                    </td>
                    <td id="ssjhdl">
                        &nbsp;
                    </td>
                    <td id="ssyxts">
                        &nbsp;
                    </td>
                    <td id="sstjts">
                        &nbsp;
                    </td>
                    <td id="ssyxl">
                        &nbsp;
                    </td>
                    <td id="sstjl">
                        &nbsp;
                    </td>
                </tr>
                <tr>
                    <td>
                        太阳能
                    </td>
                    <td>
                        玫瑰光伏
                    </td>
                    <td>
                        &nbsp;
                    </td>
                    <td>
                        &nbsp;
                    </td>
                    <td>
                        &nbsp;
                    </td>
                    <td>
                        &nbsp;
                    </td>
                    <td>
                        &nbsp;
                    </td>
                    <td>
                        &nbsp;
                    </td>
                </tr>
            </table>
        </div>
    </div>
    </form>
</body>
</html>
