<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="FDConnect.aspx.cs" Inherits="SACSIS.Connect.FDConnect" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link href="../Js/jQueryEasyUI/themes/default/easyui.css" rel="stylesheet" type="text/css" />
    <link href="../Js/jQueryEasyUI/themes/icon.css" rel="stylesheet" type="text/css" />
    <script src="../Js/jquery-1.8.2.min.js" type="text/javascript"></script>
    <script src="../Js/jquery.easyui.min.js" type="text/javascript"></script>
    <script src="../Js/highcharts.js" type="text/javascript"></script>
    <script src="../Js/exporting.js" type="text/javascript"></script>
    <script type="text/javascript" src="../Js/drawBig_highcharts.js"></script>
    <style type="text/css">
        .data table
        {
            border: solid 1px black;
        }
        .data td
        {
            border: solid 1px black;
        }
        a
        {
            cursor: pointer;
            color: Red;
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
            position: relative;
            top: 0px;
            filter: alpha(opacity=20);
            z-index: 1;
            left: 0px;
            opacity: 0.5;
            -moz-opacity: 0.5;
        }
    </style>
    <script type="text/javascript" language="javascript">
        $(document).ready(function () {
            // $("#btn").click();
            inite("","");
            var highchartsOptions = Highcharts.setOptions(Highcharts.theme);
            //SetStyle();
        });
        function next(t) {

//            alert($(t).attr("type"));
            //            alert($(t)[0].innerHTML);
            var type = $(t).attr("type");
            var area="";
            var periodName="";
            if (type == "2") {
            //点击区域
                 area = $(t)[0].innerHTML;
            }
             if (type == "3") {
             //点击场站
                 periodName = $(t)[0].innerHTML;
                 area = $(t).attr("area");
             }
            //加载数据
             inite(type,area, periodName);
         }

        
      

        //弹出风机的信息图
        function tc(a) {
            $("#imgs").css("display", "block");
            $("#AllDiv").addClass("bodys");

            var idKey = $(a).attr("idkey");
            $.ajax({
                url: "FDConnect.aspx",
                type: "GET",
                data: { para: 'unit', idKey: idKey },
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (data) {
                    $("#imgs").css("display", "none");
                    //$("#AllDiv").removeClass("bodys");

                    var t = data.title;
                    var y = data.y_data;
                    var v = data.list;
                    $('#zoomUpDiv').css('display', 'block');
                    $("#AllDiv").addClass("bodys");
                    display(t, y, v);
                }
            });
        }

        //返回上一页
        function History() {
            window.location.href = '<%=url %>';
        }
        var inite = function (type, area, periodName) {
            $("#imgs").css("display", "block");
            $("#AllDiv").addClass("bodys");

            $.ajax({
                url: "FDConnect.aspx",
                type: "GET",
                data: { para: 'search', type:type, area: area, periodName: periodName },
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (data) {
                    $("#imgs").css("display", "none");
                    $("#AllDiv").removeClass("bodys");

                    document.getElementById('tables').innerHTML = data.tables;
                    $("#title")[0].innerHTML = data.topTitle;
                    $("#ZssFH")[0].innerHTML = data.zss;
                    $("#DayDL")[0].innerHTML = data.dayDl;
                    $("#MonthDL")[0].innerHTML = data.monthDl;
                    $("#YearDL")[0].innerHTML = data.yearDl; 

                    var t = data.title;
                    var y = data.y_data;
                    var v = data.list;
                    $('#DivData').highcharts({
                        chart: {
                            type: 'spline',
                            zoomType: 'xy'

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
                            valueSuffix: ' MW',
                            xDateFormat: '<b>时间:' + '%H:%M:%S' + '</b>',
                            crosshairs: {
                                width: 1,
                                color: 'red'
                            },
                            shared: true
                        },
                        series: v,
                        
        global: {
            useUTC: true
        }
                    });
                    //$('#DivData').highcharts(chartObj);
                }
            });
        }
    </script>
</head>
<body style="background-color: #AFDFF8;">
    <form id="form1" runat="server">
    <!--标题-->
    <div style="text-align: center; font-size: larger; font-family: @华文宋体; font-weight: bolder;">
        <span id="title" runat="server"></span>
    </div>
    <br />
      <a id="CX" href="#" class="easyui-linkbutton" onclick="History();">返&nbsp;&nbsp;回</a>
    <!--数据-->
    <div class="data" style="text-align: center; font-size: large; font-family: @华文宋体;
        font-weight: bold;">
        <table cellspacing="0" style="margin-left: 30%">
            <tr>
                <td>
                    总实时负荷<span id="ZssFH" runat="server"></span>
                </td>
                <td>
                    当日发电量<span id="DayDL" runat="server"></span>
                </td>
                <td>
                    月发电量<span id="MonthDL" runat="server"></span>
                </td>
                <td>
                    年发电量<span id="YearDL" runat="server"></span>
                </td>
            </tr>
        </table>
    </div>
    <br />
    <div id="imgs" style="text-align: center; display: none; position: fixed; z-index: 1000; width:90%">
        <img id="imgId" alt="" src="../img/loading.gif" /><br />
        正在加载，请稍后......
    </div>
    <div id="zoomUpDiv" style="display: none;">
    </div>
    <div id="AllDiv" style="width:99%">
        <table style="width:99%">
            <tr>
                <td style="float: left;width: 45%; " >
                    <!--图-->
                    <div id="DivData" style=" height: 500px">
                    </div>
                </td>
                <!--表格-->
                <td style="float: left">
                    <span id="tables" runat="server" class="data"></span>
                </td>
            </tr>
        </table>
    </div>
    </form>
</body>
</html>
