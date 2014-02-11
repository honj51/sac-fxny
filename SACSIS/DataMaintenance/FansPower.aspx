<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="FansPower.aspx.cs" Inherits="SACSIS.DataMaintenance.FansPower" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>电量维护</title>
    <link href="../Js/My97DatePicker/skin/WdatePicker.css" rel="stylesheet" type="text/css" />
    <link href="../Js/jQueryEasyUI/themes/default/easyui.css" rel="stylesheet" type="text/css" />
    <link href="../Js/jQueryEasyUI/themes/icon.css" rel="stylesheet" type="text/css" />
    <script src="../Js/jquery-1.8.2.min.js" type="text/javascript"></script>
    <script src="../Js/jquery.easyui.min.js" type="text/javascript"></script>
    <script src="../js/My97DatePicker/WdatePicker.js" type="text/javascript"></script>
     <style type="text/css">
        body
        {
            height: 100%;
            margin: 10px;
            padding: 0px;
            font-size: 12px;
        }
        #menu
        {
            border: 1px solid #2a88bb;
        }
        .ipt
        {
            width: 70px; /*  border: solid 1px black;*/
        }
        .ipt_zb
        {
            /*border: solid 1px black;*/
        }
        .tdh
        {
            width: 75px;
        }
    </style>
     <script type="text/javascript">
    	<!--

         /*初始化数据*/
         function Init() {
             //获取工期数据
             $.post("FansPower.aspx", { param: 'unit' }, function (data) {
                 $("#GValue").empty();
                 if (data.intNumber == 1) {
                     $("#divGQ").hide();
                 }
                 else {
                     $("#divGQ").show();
                 }
                 var lists = data.lt;
                 if (lists != null) {
                     for (var i = 0; i < lists.length; i++) {
                         $("#GValue").append("<option value='" + lists[i].T_PERIODID + "'>" + lists[i].T_PERIODDESC + "</option>");
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

             //显示故障信息
             //ShowPowerList();

         }

         function ShowPowerList() {
             $.post("FansPower.aspx", { param: 'show', id: $("#GValue").val(),orgID:$("#FValue").val(),time: $("#txtDay").val() }, function (data) {
                 if (Number(data.count) == 1) {
                     $("#dv_show").show();
                     $("#hidID").val(data.id);
                     $("#dv_show").html(data.list);
                 }
                 else {
                     $("#dv_show").hide();
                     $.messager.alert('查询', "没有查到数据!", 'info');

                 }
             }, 'json');
         }

         function InsertPowerList() {
             var keyValue = "";
             var key = $("#hidID").val();
             if (key != "") {
                 var id = key.split('+');

                 for (var i = 0; i < id.length; i++) {
                     var val = id[i].split(':');

                     if (val.length > 0) {
                         var value = document.getElementById(val[0]).value;
                         keyValue += val[0] + '+' + value + ';';
                     }
                 }

                 if (keyValue != "") {
                     $.post("FansPower.aspx", { param: 'SaveData', date: $("#txtDay").val(), keyValue: keyValue, key: key, id: $("#GValue").val(), orgID: $("#FValue").val() }, function (data) {
                         if (Number(data.count) == 0)
                         { $.messager.alert('保存', "数据保存错误,代码: " + data.res, 'info'); }
                         else
                         { $.messager.alert('保存', "数据保存成功!", 'info'); }
                     }, 'json');
                 } else {
                     $.messager.alert('保存', "无保存内容，请检查代码!", 'info');
                 }
             }
         }

         /*初始化数据*/
         $(function () {

             /*初始化数据*/
             Init();
             //ShowPowerList();
             $("#FValue").change(function () {
                 $.post("FansPower.aspx", {
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
                     var list2 = data.list2;
                     if (list2 != null) {
                         for (var i = 0; i < list2.length; i++) {
                             $("#GValue").append("<option value='" + list2[i].T_PERIODID + "'>" + list2[i].T_PERIODDESC + "</option>");
                         }
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
                 $.post("FansPower.aspx", {
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
                     var list2 = data.list1;
                     if (list2 != null) {
                         for (var i = 0; i < list2.length; i++) {
                             $("#GValue").append("<option value='" + list2[i].T_PERIODID + "'>" + list2[i].T_PERIODDESC + "</option>");
                         }
                     }

                 }, 'json');
             });

             $("#GValue").change(function () {
                 ShowPowerList();
             });

             $("#btnSearch").click(function () {
                 ShowPowerList();
             });

             $("#btnOK").click(function () {
                 InsertPowerList();
             });
         });

         function InsertFaultList() {
             var keyValue = "";
             var key = $("#hidID").val();
             if (key != "") {
                 var id = key.split(';');

                 for (var i = 0; i < id.length; i++) {
                     var val = id[i].split('+');

                     if (val.length > 0) {
                         var value = document.getElementById(val[0]).value;
                         keyValue += val[0] + '+' + value + ';';
                     }
                 }

                 if (keyValue != "") {
                     $.post("FansFaultCount.aspx", { param: 'SaveData', date: $("#txtDay").val(), keyValue: keyValue, key: key }, function (data) {
                         if (Number(data.count) == 0)
                         { $.messager.alert('保存', "数据保存错误,代码: " + data.res, 'info'); }
                         else
                         { $.messager.alert('保存', "数据保存成功!", 'info'); }
                     }, 'json');
                 } else {
                     $.messager.alert('保存', "无保存内容，请检查代码!", 'info');
                 }
             }
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
<body>
     <div id="dv_lien" style="margin-left: auto;margin-right: auto;">
    <input type="hidden" id="hidID" />
        <div id="dv_d">
            <div style="float:left">
            &nbsp;&nbsp;&nbsp;公&nbsp;&nbsp;司&nbsp;
            <select id="FValue" style="width: 120px; text-align: center;">
            </select>
            </div >
            <div style="float:left">
            &nbsp;&nbsp;&nbsp;风&nbsp;&nbsp;场&nbsp;
            <select id="CValue" style="width: 120px; text-align: center;">
            </select></div>
            <div id="divGQ" style="float:left">&nbsp;&nbsp;&nbsp;工&nbsp;&nbsp;期&nbsp;
            <select id="GValue" style="width: 120px; text-align: center;">
            </select></div>
            <span>&nbsp; &nbsp;时 &nbsp;&nbsp;间 &nbsp;</span>
            <input type="text" id="txtDay" style="text-align: center;" runat="server" readonly="readonly"
                onfocus="WdatePicker({skin:'whyGreen',dateFmt:'yyyy-MM-dd'})" class="Wdate" />
            &nbsp;&nbsp;&nbsp;&nbsp;<a id="btnSearch" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-ok'">查&nbsp;&nbsp;询</a>
            &nbsp;&nbsp;&nbsp;&nbsp;<a id="btnOK" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-ok'">修&nbsp;&nbsp;正</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        </div>
        <div id="dv_show" style="text-align: center; margin-top: 15px;">
        </div>       
    </div>
</body>
</html>
