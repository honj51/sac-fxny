<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="GLFSQX.aspx.cs" Inherits="SACSIS.Trend.GLFSQX" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>功率风速曲线</title>
    <link href="../Js/My97DatePicker/skin/WdatePicker.css" rel="stylesheet" type="text/css" />
    <link href="../Js/jQueryEasyUI/themes/default/easyui.css" rel="stylesheet" type="text/css" />
    <link href="../Js/jQueryEasyUI/themes/icon.css" rel="stylesheet" type="text/css" />
    <link href="../css/zTreeStyle/FJ.css" rel="stylesheet" type="text/css" />
    <link href="../css/zTreeStyle/zTreeStyle.css" rel="stylesheet" type="text/css" />
    <script src="../Js/WPPLine.js" type="text/javascript"></script>
    <script src="../Js/Chart.js" type="text/javascript"></script>
    <script src="../Js/jquery-1.8.2.min.js" type="text/javascript"></script>
    <script src="../Js/jquery.easyui.min.js" type="text/javascript"></script>
    <script src="../Js/jQueryZtree/jquery.ztree.core-3.5.js" type="text/javascript"></script>
    <script src="../Js/jQueryZtree/jquery.ztree.excheck-3.5.js" type="text/javascript"></script>
    <script src="../Js/My97DatePicker/WdatePicker.js" type="text/javascript"></script>
    <script src="../Js/highcharts.js" type="text/javascript"></script>
    <script src="../Js/data.js" type="text/javascript"></script>
    <script src="../Js/exporting.js" type="text/javascript"></script>
    <style type="text/css">
    .datagrid-row  td div
    {
         width:103px;
        }
    
    </style>
    <script type="text/javascript">
    	<!--

        var idpt = '';
        var namept = '';
        var settingRight = {
            view: {
                selectedMulti: false
            },
            check: {
                enable: true
            },
            data: {
                simpleData: {
                    enable: true
                }
            },
            callback: {
                beforeCheck: beforeCheck,
                onCheck: onCheckPt
            }
        };

        function beforeCheck(treeId, treeNode) {
            return (treeNode.doCheck !== false);
        }

        function onCheckPt(e, treeId, treeNode) {
            if (treeNode.checked == true) {
                idpt += "'" + treeNode.id + "',";
                namept += treeNode.name + ',';
            } else {
                idpt = idpt.replace("'" + treeNode.id + "',", '');
                namept = namept.replace("'" + treeNode.name + "',", '');
            }
        }

        $(function () {

            $("#dv_lien").css("width", pageWidth() - 30);
            $("#dv_lien").css("height", pageHeight() - 80);
            /*曲线高度 */

            $("#tt").css("width", pageWidth() - 220);
            $("#tt").css("height", pageHeight() - 80);

            $("#container").css("width", pageWidth() - 220);
            $("#container").css("height", pageHeight() - 360);

            $("#container1").css("width", pageWidth() - 220);
            $("#container1").css("height", pageHeight() - 360);

            $("#grid").css("width", pageWidth() - 225);
            $("#grid").css("height", pageHeight() - 500);

            $("#dv_pt").css("height", pageHeight() - 30);
            $("#tree_pt").css("height", pageHeight() - 40);
            /*设置风机高度*/


            $("#grid").hide();


            /*初始化数据*/
            Init();

            $("#FValue").change(function () {
                $.post("GLFSQX.aspx", {
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
                        $.fn.zTree.init($("#tree_pt"), settingRight, zNodes);
                    }
                    else {
                        $.messager.alert('选择提示', '没有风机数据', 'warning');
                        var zNodes = eval(data.list3);
                        $.fn.zTree.init($("#tree_pt"), settingRight, zNodes);
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
                $.post("GLFSQX.aspx", {
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
                            $.fn.zTree.init($("#tree_pt"), settingRight, zNodes);
                        }
                        else {
                            $.messager.alert('选择提示', '没有风机数据', 'warning');
                            var zNodes = eval(data.list2);
                            $.fn.zTree.init($("#tree_pt"), settingRight, zNodes);
                        }
                    }

                }, 'json');
            });

            $("#GValue").change(function () {
                //清空记录
                idbg = '';
                idpt == '';
                namebg = '';
                namept = '';
                $.post("GLFSQX.aspx", {
                    param: 'unit',
                    id: $("#GValue").val()
                }, function (data) {
                    if (data.infoPt != "" && data.infoPt != null) {
                        var zNodes = eval(data.infoPt);
                        $.fn.zTree.init($("#tree_pt"), settingRight, zNodes);
                    }
                    else {
                        $.messager.alert('选择提示', '没有风机数据', 'warning');
                        var zNodes = eval(data.infoPt);
                        $.fn.zTree.init($("#tree_pt"), settingRight, zNodes);

                    }
                }, 'json');

            });


            function getLine(list) {
                var highchartsOptions = Highcharts.setOptions(Highcharts.theme);
                chart = new Highcharts.Chart({
                    chart: {
                        renderTo: 'container',
                        type: 'spline'
                    },
                    title: {
                        text: list.title
                    },
                    xAxis: {
                        title: {
                            text: '风速(m/s)'
                        }
                    },
                    yAxis: {
                        title: {
                            text: '负荷(MW)'
                        },
                        labels: {
                            formatter: function () {
                                return this.value;
                            }
                        },
                        min: 0
                    },
                    tooltip: {
                        crosshairs: {
                            width: 2,
                            color: 'red'
                        },
                        shared: true,
                        xDateFormat: '<b>风速：</b>'
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
                                enabled: false
                            }
                        }
                    },
                    exporting: {
                        enabled: false
                    },
                    series: list.tableList
                });
            }

            function getLine1(list) {
                var highchartsOptions = Highcharts.setOptions(Highcharts.theme);
                chart = new Highcharts.Chart({
                    chart: {
                        renderTo: 'container1',
                        zoomType: 'xy',
                        type: 'scatter'
                    },
                    title: {
                        text: '功率风速散点图'
                    },
                    xAxis: {
                        title: {
                            text: '风速(m/s)'
                        }
                    },
                    exporting: {
                        enabled: false //用来设置是否显示‘打印’,'导出'等功能按钮，不设置时默认为显示 
                    },
                    yAxis: {
                        title: {
                            text: '负荷(MW)'
                        },
                        labels: {
                            formatter: function () {
                                return this.value;
                            }
                        },
                        min: 0
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
                                enabled: false
                            },
                            enableMouseTracking: false
                        }
                    },
                    series: list.list
                });
            }

            $("#btnSearchb").click(function () {
                if (idpt == '') {
                    $.messager.alert('选择提示', '请先选择风机再进行查询!', 'warning');
                } else {
                    $.post("GLFSQX.aspx", {
                        param: 'line',
                        id_pt: escape(idpt),
                        name_pt: escape(namept),
                        gq: $("#GValue").val(),
                        sTime: $("#txtS").val(),
                        eTime: $("#txtE").val()
                    },
                    function (data) {
                        idpt = '';
                        namept = '';
                        if (data.intNumber == 0) {
                            if (confirm('有两条标准曲线，确定显示')) {
                                var treeObj = $.fn.zTree.getZTreeObj("tree_pt");
                                treeObj.checkAllNodes(false)
                                $.messager.alert('选择提示', '确定!', 'warning');
                            }
                            else {
                                $.messager.alert('选择提示', '取消', 'warning');
                            }
                        }
                        else {
                            var treeObj = $.fn.zTree.getZTreeObj("tree_pt");
                            treeObj.checkAllNodes(false)
                            Hc();
                            getLine(data);
                            getLine1(data);
                            $("#grid").show();

                            showGrid(data);
                        }
                    }, 'json');
                }
            });
        });

        function showGrid(data) {
            if (data.rows.length == 0) {
                $.messager.alert("结果", "没有数据!", "info", null);
            }
            var options = {
                rownumbers: true//,
                //                onLoadSuccess: function (data) {
                //                    //datagrid头部 table 的第一个tr 的td们，即columns的集合
                //                    var headerTds = $(".datagrid-header-inner table tr:first-child").children();
                //                    //datagrid主体 table 的第一个tr 的td们，即第一个数据行
                //                    var bodyTds = $(".datagrid-body table tr:first-child").children();
                //                    var totalWidth = 0; //合计宽度，用来为datagrid头部和主体设置宽度
                //                    //循环设置宽度
                //                    bodyTds.each(function (i, obj) {
                //                        var headerTd = $(headerTds.get(i));
                //                        var bodyTd = $(bodyTds.get(i));
                //                        $("div:first-child", headerTds.get(i)).css("text-align", "center");
                //                        var headerTdWidth = headerTd.width(); //获取第i个头部td的宽度
                //                        //这里加5个像素 是因为数据主体我们取的是第一行数据，不能确保第一行数据宽度最宽，预留5个像素。有兴趣的朋友可以先判断最大的td宽度都在进行设置
                //                        var bodyTdWidth = bodyTd.width() + 5;
                //                        var width = 0;
                //                        //如果头部列名宽度比主体数据宽度宽，则它们的宽度都设为头部的宽度。反之亦然
                //                        if (headerTdWidth > bodyTdWidth) {
                //                            width = headerTdWidth;
                //                            bodyTd.width(width);
                //                            headerTd.width(width);
                //                            totalWidth += width;
                //                        }
                //                        else {
                //                            width = bodyTdWidth;
                //                            headerTd.width(width);
                //                            bodyTd.width(width);
                //                            totalWidth += width;
                //                        }
                //                    });
                //                    var headerTable = $(".datagrid-header-inner table:first-child");
                //                    var bodyTable = $(".datagrid-body table:first-child");
                //                    //循环完毕即能得到总得宽度设置到头部table和数据主体table中
                //                    headerTable.width(totalWidth);
                //                    bodyTable.width(totalWidth);
                //                    bodyTds.each(function (i, obj) {
                //                        var headerTd = $(headerTds.get(i));
                //                        var bodyTd = $(bodyTds.get(i));
                //                        var headerTdWidth = headerTd.width();
                //                        bodyTd.width(headerTdWidth);
                //                    });
                //                }
            };
            options.columns = eval(data.columns); //把返回的数组字符串转为对象，并赋于datagrid的column属性  
            var dataGrid = $("#grid");
            dataGrid.datagrid(options); //根据配置选项，生成datagrid
            dataGrid.datagrid("loadData", data.rows); //载入本地json格式的数据  
        }

        /*初始化页面数据   开始*/
        function Init() {
            $.post("GLFSQX.aspx", { param: 'Init' }, function (data) {
                $("#GValue").empty();
                if (data.intNumber == 1) {
                    $("#divGQ").hide();
                }
                else {
                    $("#divGQ").show();
                    var lists = data.lt;

                    if (lists != null) {
                        for (var i = 0; i < lists.length; i++) {
                            $("#GValue").append("<option value='" + lists[i].T_PERIODID + "'>" + lists[i].T_PERIODDESC + "</option>");
                        }
                        if (data.listF != "" && data.listF != null) {
                            var zNodes = eval(data.listF);
                            $.fn.zTree.init($("#tree_pt"), settingRight, zNodes);
                        }
                    }
                }
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

            }, 'json');
        }
        /*初始化页面数据   结束*/


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
<body style="font-size: 12px;">
    <div id="dv_body">
        <div id="dv_jz" style="width: 160px; float: left;">
            <div id="dv_pt" class="zTreeDemoBackground left" style="float: left;">
                <ul id="tree_pt" class="ztree">
                </ul>
            </div>
        </div>
        <div id="dv_lien">
            <div style="float: left">
                &nbsp;&nbsp;&nbsp;公&nbsp;&nbsp;&nbsp;&nbsp;司
                <select id="FValue" style="width: 130px; text-align: center;">
                </select>
            </div>
            <div style="float: left">
                &nbsp;&nbsp;&nbsp;风&nbsp;&nbsp;&nbsp;&nbsp;场&nbsp;
                <select id="CValue" style="width: 130px; text-align: center;">
                </select>
            </div>
            <div id="divGQ" style="float: left">
                &nbsp;&nbsp;&nbsp;工&nbsp;&nbsp;&nbsp;&nbsp;期&nbsp;
                <select id="GValue" style="width: 130px; text-align: center;">
                </select>
            </div>
            <br />
            <br />
            <span>开始时间</span>
            <input type="text" id="txtS" style="text-align: center; width: 180px;" runat="server"
                readonly="readonly" onfocus="WdatePicker({skin:'whyGreen',dateFmt:'yyyy-MM-dd HH:mm:ss'})"
                class="Wdate" />&nbsp; &nbsp; <span>结束时间</span>
            <input type="text" id="txtE" style="text-align: center; width: 180px;" runat="server"
                readonly="readonly" onfocus="WdatePicker({skin:'whyGreen',dateFmt:'yyyy-MM-dd HH:mm:ss'})"
                class="Wdate" />
            &nbsp;&nbsp;&nbsp;&nbsp;<a id="btnSearchb" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-ok'">查&nbsp;&nbsp;询</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <div id="tt" class="easyui-tabs" data-options="tools:'#tab-tools'" style="margin-top: 5px;">
                <div title="曲线图" id="container" data-options="tools:'#p-tools'" style="margin: 5px">
                </div>
                <div title="散点图" id="container1" data-options="tools:'#p-tools'" style="margin: 5px">
                </div>
                <table id="grid" style="margin-top: 20px; margin-left: 5px;">
                </table>
            </div>
        </div>
    </div>
</body>
</html>
