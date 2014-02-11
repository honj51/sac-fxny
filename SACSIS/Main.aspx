<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Main.aspx.cs" Inherits="Web.Main" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head id="Head1" runat="server">
    <title>华电福新能源股份有限公司</title>
    <link href="Js/jQueryEasyUI/themes/gray/easyui.css" rel="stylesheet" type="text/css" />
    <link href="css/update8.css" rel="stylesheet" type="text/css" />
    <script src="Js/jquery-1.8.2.min.js" type="text/javascript"></script>
    <style type="text/css">
        html
        {
            overflow: hidden;
        }
        body
        {
            height: 100%;
            overflow: hidden;
            margin: 0px;
            padding: 0px;
        }
        .box
        {
            height: 100%;
            background: #ff0000;
            position: absolute;
            width: 100%;
        }
        .Text1
        {
            font-size: 13px;
            font-weight: normal;
            color: #555656;
        }
        .Text2
        {
            font-size: 13px;
            font-weight: normal;
            color: #FFFFFF;
        }
        .Text3
        {
            font-size: 13px;
            font-weight: normal;
            color: Yellow;
        }
        A:link
        {
            text-decoration: none;
        }
        A:visited
        {
            text-decoration: none;
        }
        a
        {
            float: left;
            display: block;
            width: 90px;
            height: 34px;
            line-height: 34px;
            overflow: hidden;
            text-align: center;
            font-size: 13px;
            color: #ffffff;
            background: url("img/MENU_1.jpg") no-repeat;
            margin-top: 0px;
        }
        .menu01
        {
            color: #555656;
            background: url("img/MENU_1_checked.jpg") no-repeat;
        }
        .menu02
        {
            color: #ffffff;
            background: url("img/MENU_1.jpg") no-repeat;
        }
    </style>
    <script type="text/javascript">
		<!--

        $(document).ready(function () {
            $('#mu').hide();
            $('#FItem').hide();
            $("#menu1").attr("class", "menu01");

            $("#dv_connect").css("height", pageHeight() - 84);
            $("#dv_connect").css("width", pageWidth());

            //$("#dv_Menu_left").css("width", pageWidth() - 250);

            $("#frm").css("height", pageHeight() - 84);
            Menu();
        });

        function SetUrl(judge, id, url) {
            if (judge == 1) {
                //                window.frm.location.href = "Connect.aspx?id=" + id;
                window.frm.location.href = "Connect.aspx?id=" + id;
            } else if (judge == 2) {
                window.frm.location.href = "../yyzl/JZInfo.aspx?dataType=tyn";
            } else if (judge == 3) {
                window.frm.location.href = "../yyzl/JZInfo.aspx?dataType=sd";
            } else if (judge == 4) {
                window.frm.location.href = "../yyzl/JZInfo.aspx?dataType=hd";
            } else if (judge == 5) {
                window.frm.location.href = "../yyzl/JZInfo.aspx?dataType=fbs";
            } else if (judge == 6) {
                window.frm.location.href = "../yyzl/JZInfo.aspx?dataType=swz";
            }
            else {
                //                window.frm.location.href = url;
                document.getElementById("frm").src = url;
            }
        }
        function Menu() {
            window.frm.location.href = "../MainConnect.aspx";
        }

        function changeMenu(t) {
            var s = $('#mu').attr("Value");
            //alert(s);
            t = String(t);
            //alert($("#menu"+t).css("class"));
            for (i = 0; i <= s; i++) {
                if (i == t) {
                    $("#menu" + t).attr("class", "menu01");
                } else {
                    $("#menu" + i).attr("class", "menu02");
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
<body style="background: #F7F7FF;">
    <form id="form1" runat="server">
    <table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%">
        <tr>
            <td colspan="2" style="height: 50px; background-image: url(../img/banner_02.jpg);
                width: 100%">
                <div id="dv_head" style="height: 50px; margin-bottom: 0px; margin-left: 0px; margin-right: 0px;
                    margin-top: 0px;">
                    <img src="../img/banner_fx.jpg" height="50" alt="" />
                </div>
            </td>
        </tr>
        <tr style="background-image: url(../img/MENU_2_bg.gif); height: 34px;">
            <td>
                <div id="dv_Menu_left" runat="server">
                </div>
            </td>
            <td>
                <input id="mu" type="text" runat="server" size="1" /><input id="FItem" type="text"
                    runat="server" size="1" />
            </td>
            <!--<td align="right" valign="middle">
            <a class="Text3">欢迎您</a>&nbsp;&nbsp;
            <asp:Label ID="lblUserWelcome" runat="server" CssClass="Text1"></asp:Label>&nbsp;
            <asp:LinkButton ID="linkBtnLogout" runat="server" OnClick="linkBtnLogout_Click" BorderStyle="None" CssClass="Text1">注销</asp:LinkButton>&nbsp;&nbsp;
        </td>-->
        </tr>
        <tr>
            <td colspan="2">
                <div id="dv_connect">
                    <iframe width="100%" src="" id="frm" frameborder="0" name="frm" scrolling="yes">
                    </iframe>
                </div>
            </td>
        </tr>
    </table>
    </form>
</body>
</html>
