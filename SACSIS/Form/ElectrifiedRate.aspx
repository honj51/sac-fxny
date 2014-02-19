<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ElectrifiedRate.aspx.cs" Inherits="SACSIS.Form.ElectrifiedRate" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="asp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
     <link href="../js/jQueryEasyUI/themes/icon.css" rel="stylesheet" type="text/css" />
    <link href="../js/jQueryEasyUI/themes/default/easyui.css" rel="stylesheet" type="text/css" />
    <script language="javascript" type="text/javascript" src="../js/My97DatePicker/WdatePicker.js"></script>
    <script type="text/javascript" src="../js/jquery-1.8.2.min.js"></script>
    <script src="../js/jquery.easyui.min.js" type="text/javascript"></script>
    <style type="text/css">
        .button
        {
            width: 56px; /*图片宽带*/
            background: url(../img/button.jpg) no-repeat left top; /*图片路径*/
            border: none; /*去掉边框*/
            height: 24px; /*图片高度*/
            color: White;
            vertical-align: middle;
            text-align: center;
        }
        
        .grid-head
        {
            font-size: 12px;
            font-weight: bold;
            color: White;
            background-image: url(../img/footer.jpg);
            text-align: center;
            vertical-align: middle;
        }
    </style>
    <script type="text/javascript">

        var ihight;
        $(document).ready(function () {
            ihight = pageHeight();
            //$('#dv_add').hide();
            //Grid();
        });

        function Grid() {
           
            $('#content').datagrid({
                title: '通电率报表',
                iconCls: 'icon-search',
                nowrap: true,
                autoRowHeight: false,
                striped: true,
                height: ihight - 130,
                align: 'center',
                collapsible: true,
                url: 'ElectrifiedRate.aspx',
                sortName: 'ID_KEY',
                sortOrder: 'asc',
                remoteSort: false,
                queryParams: { param: 'seachList', area: $("#ddlArea").val(), plant: $("#ddlPlant").val(), unit: $("#ddlUnit").val(), beginTime: $("#txtTimeBegin").val(), endTime: $("#txtTimeEnd").val() },
                //idField: 'T_CODE',
                frozenColumns: [[
                { field: 'ck', checkbox: true },
                { field: 'T_PLANTDESC', title: '区域', width: 150, align: 'center' },
				{ field: 'T_UNITDESC', title: '场站', width: 100, align: 'center' } 
			    ]],
                columns: [[
				    { field: 'I_GAAG', title: '机组', width: 150, align: 'center' }
				    
			    ]],
                pagination: true,
                rownumbers: true 
            });
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

        </script>
</head>
<body style="background-color: #E3EDF8; font-size: 12px; font-family: 宋体">
    <form id="form1" runat="server">
    <asp:ToolkitScriptManager ID="ToolkitScriptManager" EnableScriptGlobalization="true"
        EnableScriptLocalization="true" runat="server">
    </asp:ToolkitScriptManager>
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
        <table height="25" border="0" cellpadding="0" cellspacing="0" width="100%" bgcolor="#e5f1f4"
                style="border-bottom: 2px solid #48BADB;">
                <tr>
                    <td>
                        <div align="left" class="title">
                            通电率报表</div>
                    </td>
                </tr>
            </table>
            <table width="100%" border="0" cellspacing="0" cellpadding="4">
                <tr>
                    <td>
                      区域<asp:DropDownList ID="ddlArea" runat="server" OnSelectedIndexChanged="ddlCompany_SelectedChanged"
                            AutoPostBack="true">
                             <asp:ListItem Selected="True"  Value="0">--请选择区域--</asp:ListItem> 
                        </asp:DropDownList>
                    &nbsp; &nbsp; &nbsp; &nbsp;
                        场站<asp:DropDownList ID="ddlPlant" runat="server" OnSelectedIndexChanged="ddlPlant_SelectedChanged"
                            AutoPostBack="true">
                            <asp:ListItem Selected="True" Value="0">--请选择场站--</asp:ListItem>
                        </asp:DropDownList>
                    &nbsp; &nbsp; &nbsp; &nbsp;
                        机组<asp:DropDownList ID="ddlUnit" runat="server" 
                            onselectedindexchanged="ddlUnit_SelectedIndexChanged">
                            <asp:ListItem Selected="True" Value="0">--请选择机组--</asp:ListItem>
                        </asp:DropDownList>
                    </td>
                </tr>
            </table>
              </ContentTemplate>
         
    </asp:UpdatePanel>
            <table width="100%" border="0" cellspacing="0" cellpadding="4">
                <tr>
                    <td>
                        查询时间段
                        <input class="Wdate" id="txtTimeBegin" runat="server" type="text" onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss ',maxDate:'%y-%M-%d'})" />
                        <input class="Wdate" id="txtTimeEnd" runat="server" type="text" onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss ',maxDate:'%y-%M-%d'})" />
                        <a id="CX" href="#" class="easyui-linkbutton" onclick="Grid();">查&nbsp;&nbsp;询</a>
                    </td>
                </tr>
            </table>
           
            <br />
           <a id="Export" href="#" class="easyui-linkbutton" onclick="Export();">导&nbsp;&nbsp;出</a>
            <table id="content">
            </table>
     
     
    </form>
</body>
</html>
