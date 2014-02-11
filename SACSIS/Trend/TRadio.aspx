<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="TRadio.aspx.cs" Inherits="Web.LineAndChart.TRadio" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>同比</title>
    <link href="../js/My97DatePicker/skin/WdatePicker.css" rel="stylesheet" type="text/css" />
    <link href="../Js/jQueryEasyUI/themes/default/easyui.css" rel="stylesheet" type="text/css" />
    <link href="../Js/jQueryEasyUI/themes/icon.css" rel="stylesheet" type="text/css" />
    <link href="../css/zTreeStyle/FJ.css" rel="stylesheet" type="text/css" />
    <link href="../css/zTreeStyle/zTreeStyle.css" rel="stylesheet" type="text/css" />
    <script src="../Js/jquery-1.8.2.min.js" type="text/javascript"></script>
    <script src="../Js/jquery.easyui.min.js" type="text/javascript"></script>
    <script src="../js/My97DatePicker/WdatePicker.js" type="text/javascript"></script>
    <script src="../Js/jQueryZtree/jquery.ztree.core-3.5.js" type="text/javascript"></script>
    <script src="../Js/jQueryZtree/jquery.ztree.excheck-3.5.js" type="text/javascript"></script>
    <script src="../js/WPPLine.js" type="text/javascript"></script>
    <script src="../js/Chart.js" type="text/javascript"></script>
    <script type="text/javascript">
    	<!--
        var setPer = {
            data: {
                key: {
                    title: "t", checked: "isChecked"
                },
                simpleData: {
                    enable: true
                }
            },
            callback: {
                onCheck: zTreeOnCheck
            },
            check: { enable: true, chkStyle: "radio", radioType: "level"
            }
        };

        /*记录选中数据*/
        function zTreeOnCheck(event, treeId, treeNode) {
            $('#txtName').val(treeNode.name);
            $('#txtID').val(treeNode.id);
        };

        /*初始化数据*/
        function Init() {
            $.post("TRadio.aspx", { param: 'Init' }, function (data) {
                var lists = data.list;
                $("#FValue").empty();
                if (lists != null) {
                    for (var i = 0; i < lists.length; i++) {
                        $("#FValue").append("<option value='" + lists[i].ID + "'>" + lists[i].NAME + "</option>");
                    }
                } else {
                    $("#FValue").append("<option value='0'>没有分公司数据</option>");
                }

                var lists = data.listC;
                $("#CValue").empty();
                if (lists != null) {
                    for (var i = 0; i < lists.length; i++) {
                        $("#CValue").append("<option value='" + lists[i].ID + "'>" + lists[i].NAME + "</option>");
                    }
                } else {
                    $("#CValue").append("<option value='0'>没有风场数据</option>");
                }

                var lists = data.lt;
                $("#GValue").empty();
                if (lists != null) {
                    for (var i = 0; i < lists.length; i++) {
                        $("#GValue").append("<option value='" + lists[i].T_PERIODID + "'>" + lists[i].T_PERIODDESC + "</option>");
                    }
                } else {
                    $("#GValue").append("<option value='0'>没有工期数据</option>");
                }

                /*指标类型*/
                $("#ZType").empty();
                $("#ZType").append("<option value='1'>功率</option>");
                $("#ZType").append("<option value='2'>风速</option>");
                $("#ZType").append("<option value='3'>发电量</option>");
                $("#ZType").append("<option value='4'>停机时间</option>");

                Init_LineType_2();
                Init_LineType_1();
                LineTypeChange();
                Init_Time();

                if (data.listB != "" && data.listB != null) {
                    var zNodes = eval(data.listB);
                    $.fn.zTree.init($("#tree_bg"), setPer, zNodes);
                }
            }, 'json');
        }
        /*初始化数据*/
        $(function () {

            $("#dv_lien").css("width", pageWidth() - 200);
            /*设置风机高度*/
            $("#dv_bg").css("height", pageHeight() - 30);
            $("#tree_bg").css("height", pageHeight() - 40);
            /*设置风机高度*/
            $("#loading").hide();
            /*初始化数据*/
            Init();
            //            Hc();
            //            getLine("");
            /*初始化数据*/


            $("#FValue").change(function () {
                $.post("TRadio.aspx", {
                    param: 'org',
                    id: $("#FValue").val()
                }, function (data) {
                    $("#GValue").empty();
                    if (data.intNumber == 1) {
                        $("#divGQ").hide();
                    }
                    else {
                        $("#divGQ").show();

                    }
                    var lists = data.list2;
                    if (lists != null) {
                        for (var i = 0; i < lists.length; i++) {
                            $("#GValue").append("<option value='" + lists[i].T_PERIODID + "'>" + lists[i].T_PERIODDESC + "</option>");
                        }
                    }
                    if (data.list3 != "" && data.list3 != null) {
                        var zNodes = eval(data.list3);
                        $.fn.zTree.init($("#tree_bg"), setPer, zNodes);
                    }
                    else {
                        $.messager.alert('选择提示', '没有风机数据', 'warning');
                        var zNodes = eval(data.list3);
                        $.fn.zTree.init($("#tree_bg"), setPer, zNodes);
                    }
                    var lists = data.list1;
                    $("#CValue").empty();
                    if (lists != null) {
                        for (var i = 0; i < lists.length; i++) {
                            $("#CValue").append("<option value='" + lists[i].ID + "'>" + lists[i].NAME + "</option>");
                        }
                    } else {
                        $("#CValue").append("<option value='0'>没有风场数据</option>");
                    }
                }, 'json');
            });

            $("#CValue").change(function () {
                $.post("TRadio.aspx", {
                    param: 'gq',
                    id: $("#CValue").val()
                }, function (data) {
                    $("#GValue").empty();
                    if (data.intNumber == 1) {
                        $("#divGQ").hide();
                    }
                    else {
                        $("#divGQ").show();
                    }
                    var lists = data.list1;
                    if (lists != null) {
                        for (var i = 0; i < lists.length; i++) {
                            $("#GValue").append("<option value='" + lists[i].T_PERIODID + "'>" + lists[i].T_PERIODDESC + "</option>");
                        }
                        if (data.list2 != "" && data.list2 != null) {
                            var zNodes = eval(data.list2);
                            $.fn.zTree.init($("#tree_bg"), setPer, zNodes);
                        }
                        else {
                            $.messager.alert('选择提示', '没有风机数据', 'warning');
                            var zNodes = eval(data.list2);
                            $.fn.zTree.init($("#tree_bg"), setPer, zNodes);
                        }
                    }

                }, 'json');
            });

            //根据风场获取机组信息
            $("#GValue").change(function () {
                //                //清空记录
                //                idbg = '';
                //                idpt == '';
                //                namebg = '';
                //                namept = '';
                $.post("TRadio.aspx", { param: 'unit', id: $("#GValue").val() }, function (data) {
                    if (data.info != "" && data.info != null) {
                        var zNodes = eval(data.info);
                        $.fn.zTree.init($("#tree_bg"), setPer, zNodes);
                    } else {
                        //$.messager.alert('选择提示', '没有风机数据', 'warning');
                        var zNodes = eval(data.info);
                        $.fn.zTree.init($("#tree_bg"), setPer, zNodes);

                    }
                }, 'json');
            });

            $("#btnSearch").click(function () {
                $("#loading").show();
                $.ajax({
                    type: "POST",
                    dataType: "json",
                    url: "TRadio.aspx",
                    data: { param: 'lineyear', gq: $("#GValue").val(), zType: $("#ZType").val(), tTtype: $("#TType").val(), id: escape($("#txtID").val()), name: escape($("#txtName").val()), time: GetTime() },
                    success: function (data) {
                        $("#loading").hide();
                        //功率 或 风速 
                        if ($("#ZType").val() == "1" || $("#ZType").val() == "2") {
                            if ($("#TType").val() == "1" || $("#TType").val() == "2") {
                                ShowLine(data, 'container');
                            } else {
                                ShowLineDay(data, 'container');
                            }
                        }
                        else {
                            if ($("#TType").val() == "1") {
                                ShowDl(data, 'container');
                            } else { //type="2"
                                ShowLine(data, 'container');
                            }
                        }
                        $("#grid").css("width", pageWidth() - 380);
                        $("#grid").css("height", pageHeight() - 500);
                        showGrid(data);

                    },
                    eror: function (data) {
                        alert(data);
                    }
                });
            });

            function ShowLineDay(list, dv) {

                LineStyle();

                chart = new Highcharts.Chart({
                    chart: {
                        renderTo: dv,
                        type: 'spline'
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
                        maxZoom: 2 * 3600 * 100,
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
                        enabled: true
                    },
                    tooltip: {
                        crosshairs: {
                            width: 1,
                            color: 'red'
                        },
                        shared: true,
                        xDateFormat: '<b>时间：' + _hTime + '</b>'
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
                    //series: [{ name: list.list[0].name, data: $.parseJSON(list.list[0].data) }, { name: list.list[1].name, data: $.parseJSON(list.list[1].data)}],
                    series: [{
                        name: '今年',
                        lineWidth: 0.2,
                        marker: {
                            symbol: 'circle'
                        },
                        color: 'green',
                        data: $.parseJSON(list.list[0].data),
                        pointStart: Date.UTC(_year, _month, _day),
                        pointInterval: timeNum
                    }, {
                        name: '去年',
                        lineWidth: 0.2,
                        marker: {
                            symbol: 'circle'
                        },
                        color: 'blue',
                        data: $.parseJSON(list.list[1].data),
                        pointStart: Date.UTC(_year, _month, _day),
                        pointInterval: timeNum
                    }],
                    navigation: {
                        menuItemStyle: {
                            fontSize: '10px'
                        }
                    }
                });
            }

            function ShowLine(list, dv) {

                LineStyle();

                chart = new Highcharts.Chart({
                    chart: {
                        renderTo: dv, /*绑定标签*/
                        type: 'spline'
                    },
                    title: {
                        text: list.title/*标题*/
                    },
                    subtitle: {
                        text: ''/*副标题*/
                    },
                    xAxis: {
                        type: 'datetime', /*X轴时间格式*/
                        labels: {
                            formatter: function () {
                                return Highcharts.dateFormat(_timeType, this.value);
                            }
                        }
                    },
                    yAxis: {
                        title: {
                            text: ''
                        }
                    },
                    tooltip: {/*设置数据显示样式及格式*/
                        xDateFormat: '<b>' + '%Y-%m-%d %H:%M:%S' + '</b>',
                        crosshairs: {
                            width: 1,
                            color: 'red'
                        },
                        shared: true
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
                                enabled: false,
                                states: {
                                    hover: {
                                        enabled: true,
                                        symbol: 'circle',
                                        radius: 5,
                                        lineWidth: 1
                                    }
                                }
                            },
                            pointInterval: _interval, // one hour  /*X轴 间隔时间*/
                            pointStart: Date.UTC(_year, _month, _day, 0, 0, 0)/*X轴 开始时间*/
                        }
                    },
                    series: [{ name: list.list[0].name, data: $.parseJSON(list.list[0].data) }, { name: list.list[1].name, data: $.parseJSON(list.list[1].data)}],
                    navigation: {
                        menuItemStyle: {
                            fontSize: '10px'
                        }
                    }
                });
            }

            function ShowDl(data, dv) {

                LineStyle();


                chart = new Highcharts.Chart({
                    chart: {
                        renderTo: dv, /*绑定标签*/
                        type: 'column'
                    },
                    title: {
                        text: ''
                    },
                    subtitle: {
                        text: ''
                    },
                    xAxis: {
                        categories: [""
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
                    '<td style="padding:0"><b>{point.y:.1f} </b></td></tr>',
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
                    series: data.listDl
                });
            }

            function showGrid(data) {
                if (data.rows.length == 0) {
                    $.messager.alert("结果", "没有数据!", "info", null);
                }
                var options = {
                    //                width: "auto",
                    rownumbers: true,
                    columns: eval(data.columns)
                };
                var dataGrid = $("#grid");
                dataGrid.datagrid(options); //根据配置选项，生成datagrid
                dataGrid.datagrid("loadData", data.rows); //载入本地json格式的数据  
            }

        });

        var _hTime;
        var _year;
        var _month;
        var _day;
        var _interval; //间隔时间
        var _timeType; //时间类型
        var orgId = '';
        var treeId = '';
        var ids;
        var timeNum;

        var _height;
        var _width;
        //获取对比时间
        function GetTime() {
            var time = '';
            if ($("#TType").val() == "1") {
                time = $("#txtYear").val();
                _year = time.split('-')[0];
                _month = 0;
                _day = 1;
                _hTime = "";
                _interval = 24 * 60 * 60 * 1000;
                //                _interval = 3600000 / 36 * 24 * 9;
                _timeType = '%Y-%m';
                _hTime = '%Y-%m-%d';
                //                _hTime = '%Y-%m-%d %H:%M:%S';
            } else if ($("#TType").val() == "2") {
                time = $("#txtMonth").val();
                _year = time.split('-')[0];
                _month = Number(time.split('-')[1]) - 1;
                _day = 1;
                _interval = 12 * 3600 * 1000;
                //                _interval = 3600000 / 36 * 24;
                _timeType = '%Y-%m-%d';
                _hTime = '%Y-%m-%d %H:%M:%S';
            } else {
                time = $("#txtDay").val();
                _year = time.split('-')[0];
                _month = time.split('-')[1];
                _day = time.split('-')[2];
                //                timeNum = 60 * 1000;
                timeNum = 900 * 1000;
                _timeType = '%%Y-%m-%d %H:%M:%S';
                _hTime = '%H:%M:%S';
            }
            return time;
        }

        function Init_Time() {
            var num = '1';
            num = $("#TType").val();
            if (num == "1") {
                $("#txtYear").show();
                $("#txtMonth").hide();
                $("#txtDay").hide();
            } else if (num == "2") {
                $("#txtYear").hide();
                $("#txtMonth").show();
                $("#txtDay").hide();
            } else {
                $("#txtYear").hide();
                $("#txtMonth").hide();
                $("#txtDay").show();
            }
        }

        //判断显示时间
        function LineTypeChange() {
            var num = '1';
            $("#ZType").change(function () {

                num = $("#ZType").val();
                //                alert(num);
                if (num == "3" || num == "4") {
                    Init_LineType_2();
                } else {
                    Init_LineType_1();
                }
                num = $("#TType").val();
                if (num == "1") {
                    $("#txtYear").show();
                    $("#txtMonth").hide();
                    $("#txtDay").hide();
                } else if (num == "2") {
                    $("#txtYear").hide();
                    $("#txtMonth").show();
                    $("#txtDay").hide();
                } else {
                    $("#txtYear").hide();
                    $("#txtMonth").hide();
                    $("#txtDay").show();
                }
            });
            $("#TType").change(function () {
                num = $("#TType").val();
                if (num == "1") {
                    $("#txtYear").show();
                    $("#txtMonth").hide();
                    $("#txtDay").hide();
                } else if (num == "2") {
                    $("#txtYear").hide();
                    $("#txtMonth").show();
                    $("#txtDay").hide();
                } else {
                    $("#txtYear").hide();
                    $("#txtMonth").hide();
                    $("#txtDay").show();
                }
            });
        }

        function Init_Tyep() {
            $("#ZType").empty();
            $("#ZType").append("<option value='1'>功率</option>");
            $("#ZType").append("<option value='2'>风速</option>");
            $("#ZType").append("<option value='3'>发电量</option>");
            $("#ZType").append("<option value='4'>停机时间</option>");
        }
        function Init_LineType_1() {
            $("#TType").empty();
            $("#TType").append("<option value='1'>年比</option>");
            $("#TType").append("<option value='2'>月比</option>");
            $("#TType").append("<option value='3'>日比</option>");
        }
        function Init_LineType_2() {
            $("#TType").empty();
            $("#TType").append("<option value='1'>年比</option>");
            $("#TType").append("<option value='2'>月比</option>");
        }



        function pageHeight() {
            if ($.browser.msie) {
                return document.compatMode == "CSS1Compat" ? document.documentElement.clientHeight :
            document.body.clientHeight;
            } else {
                return self.innerHeight;
            }
        };

        function pageWidth() {
            if ($.browser.msie) {
                return document.compatMode == "CSS1Compat" ? document.documentElement.clientWidth :
            document.body.clientWidth;
            } else {
                return self.innerWidth;
            }
        }; 
            //-->
    </script>
</head>
<body style="font-size: 12px">
    <script src="../js/highcharts.js" type="text/javascript"></script>
    <script src="../js/data.js" type="text/javascript"></script>
    <div id="dv_jz" style="width: 160px; float: left;">
        <div id="dv_bg" class="zTreeDemoBackground left" style="float: left;">
            <ul id="tree_bg" class="ztree">
            </ul>
        </div>
    </div>
    <div id="dv_lien" style="float: right;">
        <div id="dv_d">
            <div style="float: left">
                &nbsp;&nbsp;&nbsp;公&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;司
                <select id="FValue" style="width: 120px; text-align: center;">
                </select>
            </div>
            <div style="float: left">
                &nbsp;&nbsp;&nbsp;风&nbsp;&nbsp;&nbsp;&nbsp;场&nbsp;
                <select id="CValue" style="width: 130px; text-align: center;">
                </select>
            </div>
            <div id="divGQ" style="float: left">
                &nbsp;&nbsp;&nbsp;工&nbsp;&nbsp;&nbsp;&nbsp;期&nbsp;
                <select id="GValue" style="width: 120px; text-align: center;">
                </select>
            </div>
            <div style="float: left">
                &nbsp;&nbsp;&nbsp;指标类型&nbsp;
                <select id="ZType" style="width: 120px; text-align: center;">
                </select>
            </div>
            <br />
            <br />
            &nbsp;&nbsp;&nbsp;统计类型
            <select id="TType" style="width: 120px; text-align: center;">
            </select>
            <span>&nbsp; &nbsp;时 &nbsp;&nbsp;间 &nbsp;</span>
            <input type="text" id="txtYear" style="text-align: center;" runat="server" readonly="readonly"
                onfocus="WdatePicker({skin:'whyGreen',dateFmt:'yyyy'})" class="Wdate" />
            <input type="text" id="txtMonth" style="text-align: center;" runat="server" readonly="readonly"
                onfocus="WdatePicker({skin:'whyGreen',dateFmt:'yyyy-MM'})" class="Wdate" />
            <input type="text" id="txtDay" style="text-align: center;" runat="server" readonly="readonly"
                onfocus="WdatePicker({skin:'whyGreen',dateFmt:'yyyy-MM-dd'})" class="Wdate" />
            &nbsp;&nbsp;&nbsp;&nbsp;<a id="btnSearch" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-ok'">查&nbsp;&nbsp;询</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        </div>
        <div id="loading" style="margin-top: 150px; text-align: center;">
            <img src="../img/loading.gif" alt="" /><br />
            正在加载，请稍后... ...
        </div>
        <div id="container" style="margin-top: 10px; min-width: 400px; height: 400px;">
        </div>
        <table id="grid" style="margin-top: 20px;">
        </table>
    </div>
    <input type="text" id="txtID" style="display: none;" />
    <input type="text" id="txtName" style="display: none;" />
</body>
</html>
