<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="StatisticDiff.aspx.cs" Inherits="SACSIS.Trend.StatisticDiff" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>统计标杆风机理论发电量与场站实际发电量</title>
     <link href="../js/My97DatePicker/skin/WdatePicker.css" rel="stylesheet" type="text/css" />
    <link href="../Js/jQueryEasyUI/themes/default/easyui.css" rel="stylesheet" type="text/css" />
    <link href="../Js/jQueryEasyUI/themes/icon.css" rel="stylesheet" type="text/css" />
    <script src="../js/My97DatePicker/WdatePicker.js" type="text/javascript"></script>
    <script src="../Js/jquery.easyui.min.js" type="text/javascript"></script>
    <script src="../Js/jquery-1.9.1.js" type="text/javascript"></script>
    <script src="../Js/jquery-1.8.2.min.js" type="text/javascript"></script>

    <script type="text/javascript">
        /*初始化数据*/
        function Init() {
            $.post("StatisticDiff.aspx", { param: 'Init' }, function (data) {
                var lists = $.parseJSON(data).Company;
                $("#FValue").empty();
                if (lists != null) {
                    for (var i = 0; i < lists.length; i++) {
                        $("#FValue").append("<option value='" + lists[i].ID + "'>" + lists[i].NAME + "</option>");
                    }
                } else {
                    $("#FValue").append("<option value='0'>没有分公司数据</option>");
                }

                lists = $.parseJSON(data).WindStation;
                $("#CValue").empty();
                if (lists != null) {
                    for (var i = 0; i < lists.length; i++) {
                        $("#CValue").append("<option value='" + lists[i].ID + "'>" + lists[i].NAME + "</option>");
                    }
                } else {
                    $("#CValue").append("<option value='0'>没有风场数据</option>");
                }
            })
        }



        $(function () {
            Init();
            //选择分公司
            $("#FValue").change(function () {
                $.post("StatisticDiff.aspx", {
                    param: 'org',
                    id: $("#FValue").val()
                }, function (data) {
                    //加载风场
                    var lists = data.WindStation;
                    $("#CValue").empty();
                    if (lists != null && lists.length > 0) {
                        for (var i = 0; i < lists.length; i++) {
                            $("#CValue").append("<option value='" + lists[i].ID + "'>" + lists[i].NAME + "</option>");
                        }
                    } else {
                        $("#CValue").append("<option value='0'>没有风场数据</option>");
                    }
                }, 'json');
            });
        });
       
    </script>
</head>
<body>
    <form id="form1" runat="server">
    <div>
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
    </div>
    </form>
</body>
</html>
