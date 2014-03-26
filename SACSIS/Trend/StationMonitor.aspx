<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="StationMonitor.aspx.cs"
    Inherits="SACSIS.Trend.StationMonitor" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <%--<script src="../Js/My97DatePicker/WdatePicker.js" type="text/javascript"></script>--%>
    <%--<script type="text/javascript" src="../Js/jquery-1.9.1.js"></script>--%>
    <script src="../Js/jquery-1.8.2.min.js" type="text/javascript"></script>
    <script src="../Js/jquery.easyui.min.js" type="text/javascript"></script>
    <link href="../Js/jQueryEasyUI/themes/default/easyui.css" rel="stylesheet" type="text/css" />
    <link href="../Js/jQueryEasyUI/themes/icon.css" rel="stylesheet" type="text/css" />
    <script src="../Js/highcharts.js" type="text/javascript"></script>
    <script src="../Js/data.js" type="text/javascript"></script>
    <script src="../Js/exporting.js" type="text/javascript"></script>
    <script type="text/javascript" src="../Js/drawBig_highcharts.js" ></script>
    
    <style type="text/css">
        .b1, .b2, .b3, .b4, .b1b, .b2b, .b3b, .b4b, .b
        {
            display: block;
            overflow: hidden;
        }
        .b1, .b2, .b3, .b1b, .b2b, .b3b
        {
            height: 1px;
        }
        .b2, .b3, .b4, .b2b, .b3b, .b4b, .b
        {
            border-left: 1px solid #479AE9;
            border-right: 1px solid #479AE9;
        }
        .b1, .b1b
        {
            margin: 0 5px;
            background: #479AE9;
        }
        .b2, .b2b
        {
            margin: 0 3px;
            border-width: 2px;
        }
        .b3, .b3b
        {
            margin: 0 2px;
        }
        .b4, .b4b
        {
            height: 2px;
            margin: 0 1px;
        }
        .d1
        {
            background: #A8CAFB;
        }
        .k
        {
            height: 95%;
        }
        .chartdiv
        {
            float: left;
            margin: 5px 15px 5px 10px;
            width: 45%;
            height: 150px;
        }
        
        #zoomUpDiv
        {
            display: none;
            position: fixed;
            top: 20px;
            left: 10px;
            margin: 10px 15px 10px 10px;
            width: 1000px;
            height: 400px;
            z-index: 10000;
            padding-top: 65px;
            font-size: 14px;
            font-weight: bold;
            padding-left: 70px;
            text-align: center;
        }
        .bodys
        {
            position: relative; top: 0px; filter: alpha(opacity=20);   
            z-index: 1; left: 0px;  
            opacity:0.5; -moz-opacity:0.5;  
             
            }
    </style>
    <script type="text/javascript">
     
        $(document).ready(function () {
            // $("#btn").click();
            inite();
            var highchartsOptions = Highcharts.setOptions(Highcharts.theme);
            //SetStyle();
        });
        function SetStyle() {
            $("a").each(function (i, j) {
                //alert(i);
                $(this).attr("class", "easyui-linkbutton");
                $(this).attr("data-options", "iconCls:'icon-search'");
                
            })
        };
        function intval(v) {
            v = parseInt(v);
            return isNaN(v) ? 0 : v;
        }
        // 获取元素信息
        function getPos(e) {
            var l = 0;
            var t = 0;
            var w = intval(e.style.width);
            var h = intval(e.style.height);
            var wb = e.offsetWidth;
            var hb = e.offsetHeight;
            while (e.offsetParent) {
                l += e.offsetLeft + (e.currentStyle ? intval(e.currentStyle.borderLeftWidth) : 0);
                t += e.offsetTop + (e.currentStyle ? intval(e.currentStyle.borderTopWidth) : 0);
                e = e.offsetParent;
            }
            l += e.offsetLeft + (e.currentStyle ? intval(e.currentStyle.borderLeftWidth) : 0);
            t += e.offsetTop + (e.currentStyle ? intval(e.currentStyle.borderTopWidth) : 0);
            l = 0;
            return { x: l, y: t, w: w, h: h, wb: wb, hb: hb };
        }
        // 获取滚动条信息
        function getScroll() {
            var t, l, w, h;
            if (document.documentElement && document.documentElement.scrollTop) {
                t = document.documentElement.scrollTop;
                l = document.documentElement.scrollLeft;
                w = document.documentElement.scrollWidth;
                h = document.documentElement.scrollHeight;
            }
            else if (document.body) {
                t = document.body.scrollTop;
                l = document.body.scrollLeft;
                w = document.body.scrollWidth;
                h = document.body.scrollHeight;
            }
            
            return { t: t, l: l, w: w, h: h };
        }
        // 锚点(Anchor)间平滑跳转
        function scroller(el, duration) {
            if (typeof el != 'object') {
                el = document.getElementById(el);
            }
            if (!el) return;
            var z = this;
            z.el = el;
            z.p = getPos(el);
            z.s = getScroll();
            z.clear = function () {
                window.clearInterval(z.timer); z.timer = null
            };
            z.t = (new Date).getTime();
            z.step = function () {
                var t = (new Date).getTime();
                var p = (t - z.t) / duration;
                if (t >= duration + z.t) {
                    z.clear();
                    window.setTimeout(function () { z.scroll(z.p.y, z.p.x) }, 13);
                }
                else {
                    st = ((-Math.cos(p * Math.PI) / 2) + 0.5) * (z.p.y - z.s.t) + z.s.t;
                    sl = ((-Math.cos(p * Math.PI) / 2) + 0.5) * (z.p.x - z.s.l) + z.s.l;
                    //z.scroll(st, sl);
                    z.scroll(st, 0);
                }
            };
            z.scroll = function (t, l) { window.scrollTo(l, t) };
            z.timer = window.setInterval(function () { z.step(); }, 13);
        }
 
//        function clickChart(chartObg) {
//            alert(chartObg.xAxis[0].value);
//            var zoomUpDiv = $('#zoomUpDiv');
//            if (zoomUpDiv != null) {
//                $('#zoomUpDiv').css('display', 'block');
//                $('.chartdiv').css('display', 'none');
//                chartObg.chart.events.click = function (event) {
//                    $('#zoomUpDiv').css('display', 'none');
//                    $('.chartdiv').css('display', 'block');
//                    $("#" + chartDiv).highcharts(chartObj);
//                };
//                $('#zoomUpDiv').highcharts(chartObg);
//            }

//         }
         
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
                url: "StationMonitor.aspx",
                type: "GET",
                data: { para: 'search' },
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (data) {
                    //alert("1");
                    $("#imgs").css("display", "none");
                    $("#divTitle").css("display", "block");

                    var length = data.length;
                    //alert(length);
                    length--;
                    //alert(data[length].length);
                    //区域数
                    var areaLength = data[length].length;
                    //var s = $.parseJSON(data[0]);
                    document.getElementById("title").innerHTML += ' &nbsp;';
                    for (var z = 0; z < areaLength; z++) {
                        //玫瑰营公司 添加一个table
                        document.getElementById("title").innerHTML += '<a href="javascript:void(\'0\');" class="easyui-linkbutton" data-options="iconCls:\'icon-search\'"  onclick="scroller(\'t' + z + '\',100)">' + data[length][z] + '</a><br /><br />' + '&nbsp;';
                        var trr;
                        trr = document.getElementById("all").insertRow();
                        var tdd2 = trr.insertCell();
                        tdd2.innerHTML += data[length][z];
                        //td2.innerHTML += '<a href="javascript:void("0");" onclick="scroller("test",800)">' + data[length][z] + '</a>';
                        tdd2.innerHTML += '<table id="t' + z + '"></table><br />';
                        for (var j = 0; j < length; j++) {
                            var company = $.parseJSON(data[j]).company;

                            if (company == data[length][z]) {
                                var tr1;
                                //此中的j为当前区域的DIV个数
                                var tab = document.getElementById("t" + z + "");
                                var divs;
                                divs = $(tab).find("div");
                                var divLength = divs.length;
                                if ((divLength + 3) % 3 == 0) {
                                    tr1 = document.getElementById("t" + z + "").insertRow();
                                    var td2 = tr1.insertCell();
                                    td2.innerHTML += '<div id="Div' + j + '" style="min-width:300px;height:300px" class="chartdiv" ></div>';
                                }
                                else {
                                    var td3 = tr1.insertCell();
                                    td3.innerHTML += '<div id="Div' + j + '" style="min-width:300px;height:300px" class="chartdiv" ></div>';
                                }
                                var t = $.parseJSON(data[j]).title;
                                var y = $.parseJSON(data[j]).y_data;
                                var v = $.parseJSON(data[j]).list;
                                gets(j, t, y, v);
                                //                             $('#Div' + j + '').highcharts({
                                //                                    chart: {
                                //                                        type: 'spline',
                                //                                        zoomType: 'xy'
                                //                                    },
                                //                                    title: {
                                //                                        text: t
                                //                                    },
                                //                                    xAxis: {
                                //                                        type: 'datetime',
                                //                                        dateTimeLabelFormats: { // don't display the dummy year
                                //                                            month: '%e. %b',
                                //                                            year: '%b'
                                //                                        }
                                //                                    },
                                //                                    plotOptions: {
                                //                                        series: {
                                //                                            marker: {
                                //                                                radius: 1,  //曲线点半径，默认是4
                                //                                                symbol: 'circle' //曲线点类型："circle", "square", "diamond", "triangle","triangle-down"，默认是"circle"
                                //                                            },
                                //                                            cursor: 'pointer',
                                //                                            events: {
                                //                                                click:  null
                                //                                                    //                                                location.href = e.point.url;
                                //                                                    //                                                //上面是当前页跳转，如果是要跳出新页面，那就用
                                //                                                    //                                                //window.open(e.point.url);
                                //                                                    //                                                //这里的url要后面的data里给出

                                //                                                }
                                //                                            }
                                //                                        }
                                //                                       
                                //                                    },
                                //                                    yAxis: y,
                                //                                    tooltip: {
                                //                                        //                                formatter: function () {
                                //                                        //                                    return '<b>' + this.series.name + '</b><br/>' +
                                //                                        //                    Highcharts.dateFormat('%e. %b', this.x) + ': ' + this.y + ' m/s';
                                //                                        //                                }
                                //                                        //                                formatter: function () {
                                //                                        //                                    return '<b>' + this.series.name + '</b><br/>' +
                                //                                        //                    '时间：' + Highcharts.dateFormat('%H:%M:%S', this.x) + '</b><br/> 值：' + this.y;
                                //                                        //                                },

                                //                                        crosshairs: {
                                //                                            width: 2,
                                //                                            color: 'red'
                                //                                        },
                                //                                        shared: true,

                                //                                        xDateFormat: '时间：' + '%H:%M:%S'
                                //                                        //             function () {
                                //                                        //                                    return  '时间：%H:%M:%S' ;
                                //                                        //                                }
                                //                                    },
                                //                                    series: v
                                //                                })

                            }
                        }
                    }
                }
            })
        }
    </script>
</head>
<body style="background-color: #F7F7FF">
    <form id="form1" runat="server">
    <div id="imgs" style="margin-top: 150px; text-align: center; display: none;">
        <img id="imgId" alt="" src="../img/loading.gif" /><br />
        正在加载，请稍后......
    </div>
    <!--表头-->
    <table>
        <tr>
            <td style="width: 100px; float: left">
                <div id="divTitle" style="height: 100%; width: 10%; display: none; background-color: #F7F7FF;
                    position:  fixed; z-index: 10000; font-size: 14px; font-weight: bold;  ">
                   
                    <b class="b1"></b><b class="b2 d1"></b><b class="b3 d1"></b><b class="b4 d1"></b>
                    <div class="b d1 k">
                        <div id="title">
                        </div>
                    </div>
                    <b class="b4b d1"></b><b class="b3b d1"></b><b class="b2b d1"></b><b class="b1b">
                    </b>
                </div>
            </td>
        </tr>
    </table>
    <table style=" margin-left:130px;">
        <tr>
            <td style="float: left">
                <!--内容-->
                <div id="zoomUpDiv">
                </div>
                <div id="AllDiv" style="font-size: 14px; font-weight: bold;">
                    <table id="all">
                    </table>
                    <%--<a href="javascript:void('0');" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="scroller('t0',800)">玫瑰营公司</a>--%>
                </div>
            </td>
        </tr>
    </table>
    </form>
</body>
</html>
