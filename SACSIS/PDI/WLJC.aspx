<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="WLJC.aspx.cs" Inherits="SACSIS.PDI.WebForm1" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body style="background: #F1F6FA;">
    <div style="margin: 0 auto; width: 1000px; background-color: #F1F6FA;">
        <object classid="clsid:4F26B906-2854-11D1-9597-00A0C931BFC8" id="pdiShow" width="1000px"
            height="666px" border="0" vspace="0" hspace="0" codebase="ActiveView_3_2_0_0_.exe#version=3,2,0,0">
            <param name="ServerIniURL" value="D:\Program Files (x86)\PIPC\DAT\pilogin.ini" />
            <param name="DIsplayURL" value="http://10.27.134.200/PDI/场站网络监测.PDI" />
        </object>
    </div>
</body>
</html>
