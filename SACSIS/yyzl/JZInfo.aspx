<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="JZInfo.aspx.cs" Inherits="SACSIS.JZInfo" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script src="../Js/jquery-1.8.2.min.js" type="text/javascript"></script>
    <script src="../Js/jquery.easyui.min.js" type="text/javascript"></script>
    <link href="../Js/jQueryEasyUI/themes/default/easyui.css" rel="stylesheet" type="text/css" />
    <link href="../Js/jQueryEasyUI/themes/icon.css" rel="stylesheet" type="text/css" />
     <script src="../Js/highcharts.js" type="text/javascript"></script>
    <script src="../Js/exporting.js" type="text/javascript"></script>
    <script type="text/javascript" src="../Js/drawBig_highcharts.js"></script>
    <style type="text/css">
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
        $(function () {

            load();
            var int = self.setInterval("load()", 600000);
            var highchartsOptions = Highcharts.setOptions(Highcharts.theme);

        });


        function load() {
            var dataType = GetQueryString("dataType");
            $("#imgs").css("display", "block");
            $("#AllDiv").addClass("bodys");

            $.ajax({
                url: "JZInfo.aspx?funCode=init&dataType=" + dataType,
                type: "POST",
                beforeSend: function () {
                    //Handle the beforeSend event
                },
                success: function (json) {
                    //json = eval("("+json+")");
                    $("#imgs").css("display", "none");
                    var json = $.parseJSON(json);
                    $("#tabId").empty();
                    $("#tabId").append(json.data);
                    $("#AllDiv").removeClass("bodys");

                    //$("#loading").hide();
                },
                error: function (x, e) {
                    alert(x.responseText);
                },
                complete: function () {
                    //Handle the complete event
                }
            });
        
        }

        function GetQueryString(name) {
            var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)", "i");
            var r = window.location.search.substr(1).match(reg);
            if (r != null)
                return unescape(r[2]);
            return null;
        }

        //跳转
        function next(t) {

            //            alert($(t).attr("type"));
            //            alert($(t)[0].innerHTML);
            var type = $(t).attr("type");
            var area = "";
            var periodName = "";
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
            window.location.href = "../Connect/FDConnect.aspx?tag=2&type=" + type + "&area=" + area + "&periodName=" + periodName;
        }
        //弹出风机的信息图
        function tc(a) {
            $("#imgs").css("display", "block");
            $("#AllDiv").addClass("bodys");

            var idKey = $(a).attr("idkey");
            $.ajax({
                url: "JZInfo.aspx",
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
    </script>
    <style type="text/css">
        table td
        {
            border-width: 1px;
            padding: 1px;
            border-style: solid;
            border-color: #666666;
            text-align: center;
        }
        
        table
        {
            font-size: 12px;
            border-width: 1px;
            border-color: #666666;
            border-collapse: collapse;
        }
    </style>
</head>
<body>
    <form id="form1" >
   
      <div id="imgs" style="text-align: center; display: none; position: fixed; z-index: 1000; width:90%">
        <img id="imgId" alt="" src="../img/loading.gif" /><br />
        正在加载，请稍后......
    </div>
      <div id="zoomUpDiv" style="display: none;">
    </div>
     <div id="AllDiv" style="width:99%">
    <div id="tabId" style="width: 1100px">
       <%-- <div id="loading" style="margin-top: 150px; text-align: center;">
            <img src="../img/loading.gif" alt="" /><br />
            正在加载，请稍后... ...
        </div>--%>
    </div>
    </div>
   
    </form>
</body>
</html>
