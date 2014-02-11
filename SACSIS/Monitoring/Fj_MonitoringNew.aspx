<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Fj_MonitoringNew.aspx.cs"
    Inherits="SACSIS.Monitoring.Fj_MonitoringNew" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>风机监控</title>
    <link href="../Js/jQueryEasyUI/themes/default/easyui.css" rel="stylesheet" type="text/css" />
    <link href="../Js/jQueryEasyUI/themes/icon.css" rel="stylesheet" type="text/css" />
    <link href="../css/update8.css" rel="stylesheet" type="text/css" />
    <script src="../Js/jquery-1.8.2.min.js" type="text/javascript"></script>
    <script src="../Js/jquery.easyui.min.js" type="text/javascript"></script>
    <script type="text/javascript">
    	<!--
        var num = 0;
        $(function () {
            /*初始化数据*/
            Init();
            setInterval(function () {
                Init();
            }, 1000 * 10);


            var num;
            $("#btnFirst").click(function () {
                if ($("#txtHide").val() == "1") {
                    $.messager.alert('风机监控', '已经是第1页,不能进行跳转!', 'warning');
                } else {
                    num = 1;
                    $.post("Fj_MonitoringNew.aspx", { param: 'fy', num: num }, function (data) {
                        $("#dv_show").html(data.tb);
                        $("#sp_now").text(num);
                        $("#txtHide").val(num);
                    }, 'json');
                }

            });
            $("#btnUp").click(function () {
                if ($("#txtHide").val() == "1") {
                    $.messager.alert('风机监控', '已经是第1页,不能进行跳转!', 'warning');
                } else {
                    num = Number($("#txtHide").val() - 1);
                    $.post("Fj_MonitoringNew.aspx", { param: 'fy', num: num }, function (data) {
                        $("#dv_show").html(data.tb);
                        $("#sp_now").text(num);
                        $("#txtHide").val(num);
                    }, 'json');
                }
            });
            $("#btnDown").click(function () {
                var next = (Number($("#txtHide").val()));
                var all = Number($("#sp_num").text());
                if (next >= all) {
                    $.messager.alert('风机监控', '跳转的页数不能大于总页数!', 'warning');
                } else {
                    num = next + 1;
                    $.post("Fj_MonitoringNew.aspx", { param: 'fy', num: num }, function (data) {
                        $("#dv_show").html(data.tb);
                        $("#sp_now").text(num);
                        $("#txtHide").val(num);
                    }, 'json');
                }
            });
            $("#btnLost").click(function () {
                num = $("#sp_num").text();
                $.post("Fj_MonitoringNew.aspx", { param: 'fy', num: num }, function (data) {
                    $("#dv_show").html(data.tb);
                    $("#sp_now").text(num);
                    $("#txtHide").val(num);
                }, 'json');
            });
            $("#btnBack").click(function () {
                if ($("#txtNum").val() == null || $("#txtNum").val() == '') {
                    $.messager.alert('风机监控', '跳转页数不能为空!', 'warning');
                } else {
                    var now = $("#txtHide").val();
                    num = $("#txtNum").val();
                    if (Number(num) > Number(now)) {
                        $.messager.alert('风机监控', '跳转的页数不能大于总页数!', 'warning');
                    } else if (Number(num) == Number(now)) {
                        $.messager.alert('风机监控', '要跳转的页数为当前页，不需要跳转!', 'warning');
                    } else {

                        $.post("Fj_MonitoringNew.aspx", { param: 'fy', num: num }, function (data) {
                            $("#dv_show").html(data.tb);
                            $("#sp_now").text(num);
                            $("#txtHide").val(num);
                        }, 'json');
                    }
                }
            });
        });

        //显示分页数据
        function Show(num) {

        }

        function ShowInfo(id, name) {
            $.post("Fj_MonitoringNew.aspx", { param: 'point', id: id }, function (data) {
                $("#sp_1").text(name);
                if (data.val.length > 0) {
                    $("#sp_2").text(data.val[1]); //风速
                    $("#sp_3").text(data.val[0]); //有功功率
                    $("#sp_4").text(data.val[2]); //无功功率
                    $("#sp_5").text(data.val[3]); //功率因数
                    $("#sp_6").text(data.val[4]); //功率因数设定值
                    $("#sp_7").text(data.val[5]); //转子速度
                    $("#sp_8").text(data.val[6]); //母线频率
                    $("#sp_9").text(data.val[7]); //发电机速度(CPU)
                    $("#sp_10").text(data.val[8]); //发电机速度(PLC)
                    $("#sp_11").text(data.val[9]); //塔筒偏转角度
                    $("#sp_12").text(data.val[10]); //机舱位置

                    $("#sp_13").text(data.val[15]); //液压预压
                    $("#sp_14").text(data.val[16]); //机舱转动
                    $("#sp_15").text(data.val[17]); //10秒风向差值
                    $("#sp_16").text(data.val[19]); //转距实际差值
                    $("#sp_17").text(data.val[18]); //1秒风向差值
                    $("#sp_18").text(data.val[20]); //转距设定值

                    $("#sp_19").text(data.val[21]); //环境温度
                    $("#sp_20").text(data.val[13]); //机舱温度                
                    $("#sp_22").text(data.val[12]); //齿轮箱温度
                    $("#sp_23").text(data.val[11]); //齿轮箱轴承温度
                    $("#sp_24").text(data.val[22]); //尾轴轴承温度
                    $("#sp_25").text(data.val[23]); //发电机1点温度
                    $("#sp_26").text(data.val[24]); //发电机2点温度
                    $("#sp_27").text(data.val[25]); //发电机冷却空气温度
                    $("#sp_28").text(data.val[26]); //轴承As点温度
                    $("#sp_29").text(data.val[27]); //轴承B点温度
                    $("#sp_30").text(data.val[14]); //流压预压
                }
                $("#sp_num").text(data.total);
                $("#showPointInfo").show();
                $('#showPointInfo').dialog({});

            }, 'json');
        }


        /*初始化页面数据   开始*/
        function Init() {
            $.post("Fj_MonitoringNew.aspx", { param: 'Init' }, function (data) {
                $("#sp_num").text(data.total);
                $("#txtHide").val('1');
                $("#sp_now").text('1');
                $("#dv_show").html(data.tb);
                num = data.num;
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
<body style="background-color: #1c7ab0; text-align: center;">
    <div id="dv_show" style="text-align: center; float: inherit;">
    </div>
    <div id="dv_btn" style="text-align: center; float: inherit;">
        <a id="btnFirst" href="#" class="easyui-linkbutton">首&nbsp;&nbsp;页</a> <a id="btnUp"
            href="#" class="easyui-linkbutton">上&nbsp;一&nbsp;页</a> <a id="btnDown" href="#" class="easyui-linkbutton">
                下&nbsp;一&nbsp;页</a> <a id="btnLost" href="#" class="easyui-linkbutton">尾&nbsp;&nbsp;页</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;共<span
                    id="sp_num"></span>页&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;当前为第<span id="sp_now"></span>页&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;跳转到<input
                        id="txtNum" style="width: 20px;" value="" /><input id="txtHide" style="display: none;"
                            value="" />页&nbsp;<a id="btnBack" href="#" class="easyui-linkbutton">跳&nbsp;&nbsp;转</a>
    </div>
    <div id="showPointInfo" title="风机详细信息" data-options="iconCls:'icon-save'" style="padding: 5px;
        width: 890px; height: 490px; display: none;">
        <div id="dv_info" style="background-image: url(../img/fjjk_dt_bg.jpg); width: 890px;
            height: 450px; font-size: 12px; color: White;">
            <table style="position: absolute; left: 150px; background-image: url(../img/fjjk_dt_tb3.png);
                width: 160px; height: 45px;">
                <tr>
                    <td>
                        <span id="sp_1"></span>
                    </td>
                </tr>
            </table>
            <table style="position: absolute; left: 10px; top: 120px;">
                <tr>
                    <td>
                        <table style="background-image: url(../img/fjjk_dt_tb1.png); height: 372px; width: 240px;">
                            <tr>
                                <td align="right" valign="middle" width="120px">
                                    风速：
                                </td>
                                <td align="left" valign="middle">
                                    &nbsp;&nbsp;&nbsp;&nbsp;<span id="sp_2"></span>
                                </td>
                            </tr>
                            <tr>
                                <td align="right" valign="middle" width="120px">
                                    有功功率：
                                </td>
                                <td align="left" valign="middle">
                                    &nbsp;&nbsp;&nbsp;&nbsp; <span id="sp_3"></span>
                                </td>
                            </tr>
                            <tr>
                                <td align="right" valign="middle" width="120px">
                                    无功功率：
                                </td>
                                <td align="left" valign="middle">
                                    &nbsp;&nbsp;&nbsp;&nbsp; <span id="sp_4"></span>
                                </td>
                            </tr>
                            <tr>
                                <td align="right" valign="middle" width="120px">
                                    功率因数：
                                </td>
                                <td align="left" valign="middle">
                                    &nbsp;&nbsp;&nbsp;&nbsp; <span id="sp_5"></span>
                                </td>
                            </tr>
                            <tr>
                                <td align="right" valign="middle" width="120px">
                                    功率因数设定值：
                                </td>
                                <td align="left" valign="middle">
                                    &nbsp;&nbsp;&nbsp;&nbsp; <span id="sp_6"></span>
                                </td>
                            </tr>
                            <tr>
                                <td align="right" valign="middle" width="120px">
                                    转子速度：
                                </td>
                                <td align="left" valign="middle">
                                    &nbsp;&nbsp;&nbsp;&nbsp; <span id="sp_7"></span>
                                </td>
                            </tr>
                            <tr>
                                <td align="right" valign="middle" width="120px">
                                    母线频率：
                                </td>
                                <td align="left" valign="middle">
                                    &nbsp;&nbsp;&nbsp;&nbsp; <span id="sp_8"></span>
                                </td>
                            </tr>
                            <tr>
                                <td align="right" valign="middle" width="120px">
                                    发电机速度(CPU)：
                                </td>
                                <td align="left" valign="middle">
                                    &nbsp;&nbsp;&nbsp;&nbsp; <span id="sp_9"></span>
                                </td>
                            </tr>
                            <tr>
                                <td align="right" valign="middle" width="120px">
                                    发电机速度(PLC)：
                                </td>
                                <td align="left" valign="middle">
                                    &nbsp;&nbsp;&nbsp;&nbsp; <span id="sp_10"></span>
                                </td>
                            </tr>
                            <tr>
                                <td align="right" valign="middle" width="120px">
                                    塔筒偏转角度：
                                </td>
                                <td align="left" valign="middle">
                                    &nbsp;&nbsp;&nbsp;&nbsp; <span id="sp_11"></span>
                                </td>
                            </tr>
                            <tr>
                                <td align="right" valign="middle" width="120px">
                                    机舱位置：
                                </td>
                                <td align="left" valign="middle">
                                    &nbsp;&nbsp;&nbsp;&nbsp; <span id="sp_12"></span>
                                </td>
                            </tr>
                        </table>
                    </td>
                    <td>
                        <table style="background-image: url(../img/fjjk_dt_tb2.png); margin-top: 220px; height: 132px;
                            width: 400px;">
                            <tr>
                                <td align="right" valign="middle" width="120px">
                                    液压预压：
                                </td>
                                <td align="left" valign="middle">
                                    &nbsp;&nbsp;&nbsp;&nbsp; <span id="sp_13"></span>
                                </td>
                                <td align="right" valign="middle" width="120px">
                                    机舱转动：
                                </td>
                                <td align="left" valign="middle">
                                    &nbsp;&nbsp;&nbsp;&nbsp; <span id="sp_14"></span>
                                </td>
                            </tr>
                            <tr>
                                <td align="right" valign="middle" width="120px">
                                    10秒风向差值：
                                </td>
                                <td align="left" valign="middle">
                                    &nbsp;&nbsp;&nbsp;&nbsp; <span id="sp_15"></span>
                                </td>
                                <td align="right" valign="middle" width="120px">
                                    转距实际差值：
                                </td>
                                <td align="left" valign="middle">
                                    &nbsp;&nbsp;&nbsp;&nbsp; <span id="sp_16"></span>
                                </td>
                            </tr>
                            <tr>
                                <td align="right" valign="middle" width="120px">
                                    1秒风向差值：
                                </td>
                                <td align="left" valign="middle">
                                    &nbsp;&nbsp;&nbsp;&nbsp; <span id="sp_17"></span>
                                </td>
                                <td align="right" valign="middle" width="120px">
                                    转距设定值：
                                </td>
                                <td align="left" valign="middle">
                                    &nbsp;&nbsp;&nbsp;&nbsp; <span id="sp_18"></span>
                                </td>
                            </tr>
                        </table>
                    </td>
                    <td>
                        <table style="background-image: url(../img/fjjk_dt_tb1.png); height: 372px; width: 240px;">
                            <tr>
                                <td align="right" valign="middle" width="120px">
                                    环境温度：
                                </td>
                                <td align="left" valign="middle">
                                    &nbsp;&nbsp;&nbsp;&nbsp; <span id="sp_19"></span>
                                </td>
                            </tr>
                            <tr>
                                <td align="right" valign="middle" width="120px">
                                    机舱温度：
                                </td>
                                <td align="left" valign="middle">
                                    &nbsp;&nbsp;&nbsp;&nbsp; <span id="sp_20"></span>
                                </td>
                            </tr>
                            <tr>
                                <td align="right" valign="middle" width="120px">
                                    齿轮箱温度：
                                </td>
                                <td align="left" valign="middle">
                                    &nbsp;&nbsp;&nbsp;&nbsp; <span id="sp_22"></span>
                                </td>
                            </tr>
                            <tr>
                                <td align="right" valign="middle" width="120px">
                                    齿轮箱轴承温度：
                                </td>
                                <td align="left" valign="middle">
                                    &nbsp;&nbsp;&nbsp;&nbsp; <span id="sp_23"></span>
                                </td>
                            </tr>
                            <tr>
                                <td align="right" valign="middle" width="120px">
                                    尾轴轴承温度：
                                </td>
                                <td align="left" valign="middle">
                                    &nbsp;&nbsp;&nbsp;&nbsp; <span id="sp_24"></span>
                                </td>
                            </tr>
                            <tr>
                                <td align="right" valign="middle" width="120px">
                                    发电机1点温度：
                                </td>
                                <td align="left" valign="middle">
                                    &nbsp;&nbsp;&nbsp;&nbsp; <span id="sp_25"></span>
                                </td>
                            </tr>
                            <tr>
                                <td align="right" valign="middle" width="120px">
                                    发电机2点温度：
                                </td>
                                <td align="left" valign="middle">
                                    &nbsp;&nbsp;&nbsp;&nbsp; <span id="sp_26"></span>
                                </td>
                            </tr>
                            <tr>
                                <td align="right" valign="middle" width="140px">
                                    发电机冷却空气温度：
                                </td>
                                <td align="left" valign="middle">
                                    &nbsp;&nbsp;&nbsp;&nbsp; <span id="sp_27"></span>
                                </td>
                            </tr>
                            <tr>
                                <td align="right" valign="middle" width="120px">
                                    轴承A点温度：
                                </td>
                                <td align="left" valign="middle">
                                    &nbsp;&nbsp;&nbsp;&nbsp; <span id="sp_28"></span>
                                </td>
                            </tr>
                            <tr>
                                <td align="right" valign="middle" width="120px">
                                    轴承B点温度：
                                </td>
                                <td align="left" valign="middle">
                                    &nbsp;&nbsp;&nbsp;&nbsp; <span id="sp_29"></span>
                                </td>
                            </tr>
                            <tr>
                                <td align="right" valign="middle" width="120px">
                                    流压预压：
                                </td>
                                <td align="left" valign="middle">
                                    &nbsp;&nbsp;&nbsp;&nbsp; <span id="sp_30"></span>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </div>
    </div>
</body>
</html>
