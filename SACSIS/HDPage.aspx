<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="HDPage.aspx.cs" Inherits="SACSIS.HDPage" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
        <style type="text/css">
        body
        {
            font-family: 微软雅黑;
        }
        #tabId td
        {
            border: solid thin #6BA5BD;
        }
        #Table1 td
        {
            border: solid thin #6BA5BD;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
    <div style="width: 1000px; height: 650px; float: left;">
            <div style="width: 1000px; height: 35px; float: left; background-image: url(img/20131211144004.png);
                font-size: 19px; color: White; line-height: 30px">
                &nbsp;内蒙古
            </div>
            <div id="box" style="width: 1000px; height: 600px; float: left; background-image: url(img/内蒙古地图-2.jpg);">
                <a href="MainConnect.aspx" class="easyui-linkbutton" data-options="iconCls:'icon-back'"
                    style="float: right; margin-bottom: 200px; margin-right: 50px; height: 25px;
                    width: 62px;">返回</a>
                <div style="float: right; margin-top: 460px; margin-right: 5px; width: 106px; height: 79px;
                    top: 1081px;">
                    <table style="color: White">
                        <tr>
                            <td>
                                <img src="img/风电图标.png" />
                            </td>
                            <td>
                                风电
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <img src="img/太阳能图标.png" />
                            </td>
                            <td>
                                太阳能
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
        </div>
        <div style="width: 1000px; height: 190px; float: left;">
            <div style="width: 1000px; height: 35px; float: left; background-image: url(img/20131211144004.png);
                font-size: 19px; color: White; line-height: 30px">
                &nbsp;省份详细数据
            </div>
            <table id="Table1" style="border-collapse: collapse; background-color: White; width: 985px;
                text-align: center; margin-left: 8px; margin-top: 2px; height: 150px" border="1">
                <tr>
                    <td style="width: 100px;">
                        类型
                    </td>
                    <td style="width: 100px;">
                        风场
                    </td>
                    <td style="width: 100px;">
                        装机容量
                    </td>
                    <td style="width: 100px;">
                        负荷
                    </td>
                    <td style="width: 100px;">
                        风速
                    </td>
                    <td style="width: 100px;">
                        日发电量
                    </td>
                    <td style="width: 100px;">
                        年累计电量
                    </td>
                    <td style="width: 100px;">
                        完成率
                    </td>
                </tr>
                <tr>
                    <td rowspan="4">
                        风电
                    </td>
                    <td>
                        玫瑰营一期
                    </td>
                    <td>
                        49.3
                    </td>
                    <td id="mgy1fh">
                        &nbsp;
                    </td>
                    <td id="mgy1fs">
                        &nbsp;
                    </td>
                    <td id="mgy1rdl">
                        &nbsp;
                    </td>
                    <td id="mgy1ydl">
                        &nbsp;
                    </td>
                    <td id="mgy1jhdl">
                        &nbsp;
                    </td>
                </tr>
                <tr>
                    <td>
                        玫瑰营二期
                    </td>
                    <td>
                        200
                    </td>
                    <td id="mgy2fh">
                        &nbsp;
                    </td>
                    <td id="mgy2fs">
                        &nbsp;
                    </td>
                    <td id="mgy2rdl">
                        &nbsp;
                    </td>
                    <td id="mgy2ydl">
                        &nbsp;
                    </td>
                    <td id="mgy2jhdl">
                        &nbsp;
                    </td>
                </tr>
                <tr>
                    <td>
                        富丽达风场
                    </td>
                    <td>
                        49.5
                    </td>
                    <td id="fldfh">
                        &nbsp;
                    </td>
                    <td id="fldfs">
                        &nbsp;
                    </td>
                    <td id="fldrdl">
                        &nbsp;
                    </td>
                    <td id="fldydl">
                        &nbsp;
                    </td>
                    <td id="fldjhdl">
                        &nbsp;
                    </td>
                </tr>
                <tr>
                    <td>
                        三胜风场
                    </td>
                    <td>
                        49.5
                    </td>
                    <td id="ssfh">
                        &nbsp;
                    </td>
                    <td id="ssfs">
                        &nbsp;
                    </td>
                    <td id="ssrdl">
                        &nbsp;
                    </td>
                    <td id="ssydl">
                        &nbsp;
                    </td>
                    <td id="ssjhdl">
                        &nbsp;
                    </td>
                </tr>
                <tr>
                    <td>
                        太阳能
                    </td>
                    <td>
                        玫瑰光伏
                    </td>
                    <td>
                        &nbsp;
                    </td>
                    <td>
                        &nbsp;
                    </td>
                    <td>
                        &nbsp;
                    </td>
                    <td>
                        &nbsp;
                    </td>
                    <td>
                        &nbsp;
                    </td>
                    <td>
                        &nbsp;
                    </td>
                </tr>
            </table>
        </div>
    </form>
</body>
</html>
