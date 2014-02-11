<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AllProjectTable.aspx.cs"
    Inherits="SACSIS.Form.AllProjectTable" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script type="text/javascript" src="../Js/jquery-1.9.1.js"></script>
    <script type="text/javascript">

        $(document).ready(function () {
            getForm();
            //每隔10秒自动调用方法，实现图表的实时更新    
            window.setInterval("getForm()", 15000);
        })
        // 与后台进行数据交互  
        function getForm() {
            $.post("AllProjectTable.aspx", { para: "loading" }, function (data) {
                $("#loading").css("display", "none");
                $("#tab").css("display", "block");
                document.getElementById("divTable").innerHTML = data.tab1;
                document.getElementById("divTable2").innerHTML = data.tab2;
            }, "json");
        };
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
            window.location.href = "../Connect/FDConnect.aspx?tag=2&type=" + type + "&area=" + area + "&periodName="+periodName;
        }   
      
    </script>
    <style type="text/css">
        .tab table, .tab table td, .tab table th
        {
            border: 1px solid black;
            border-collapse: collapse;
            text-align: center;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
    <div id="loading" style="margin-top: 150px; text-align: center;">
        <img src="../img/loading.gif" alt="" /><br />
        正在加载，请稍后... ...
    </div>
    <div style="width: 1000px;">
        <table id="tab" style="width: 1000px; display: none;">
            <tr>
                <td colspan="3">
                    <img src="../img/dlzl.jpg" alt="" height="30px" width="1000px" />
                </td>
            </tr>
            <tr>
                <td class="tab" valign="top">
                    <div runat="server" id="divTable" >
                    </div>
                </td>
                <td valign="top" class="tab">
                    <div runat="server" id="divTable2">
                    </div>
                </td>
            </tr>
        </table>
    </div>
    </form>
</body>
</html>
