<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CZMAP.aspx.cs" Inherits="SACSIS.Form.CZMAP" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script src="../Js/jquery-1.8.2.min.js" type="text/javascript"></script>
    <%--    <script charset="utf-8" type="text/javascript" src="http://maps.google.cn/maps?file=api&amp;v=3&amp;key&amp;sensor=false&amp;hl=zh-CN"></script>--%>
    <script type="text/javascript" src="http://ditu.google.cn/maps?file=api&v=3&key=ABQIAAAAzqxfZV_KI62eXC63CWL97xS1Vavjk_vyjwBdhsJgngpb2VfMxxSfTJP7Je6yhTdEna54Kbf-XQJkVw&hl=zh-CN"></script>
    <script type="text/javascript" charset="UTF-8">
        var editWin;
        var winWidth = 800;
        var winHeight = 400;

        var yCount = 0;
        var stzoom = 10;
        var map;

        var taImg;

        //创建图标  升压站
        function WindIconSYZ() {
            var icon = new GIcon();
            icon.image = "../img/syz.gif";
            icon.iconSize = new GSize(30, 40);
            icon.iconAnchor = new GPoint(6, 10);
            icon.infoWindowAnchor = new GPoint(5, 20);
            return icon;
        }

        //创建图标  风场
        function WindIconYX() {
            var icon = new GIcon();
            icon.image = "../img/运行.gif";
            icon.iconSize = new GSize(30, 40);
            icon.iconAnchor = new GPoint(6, 10);
            icon.infoWindowAnchor = new GPoint(5, 20);
            return icon;
        }

        //创建图标  风场
        function WindIconGZ() {
            var icon = new GIcon();
            icon.image = "../img/暂停.gif";
            icon.iconSize = new GSize(30, 40);
            icon.iconAnchor = new GPoint(6, 10);
            icon.infoWindowAnchor = new GPoint(5, 20);
            return icon;
        }

        //创建图标  风场
        function WindIconTJ() {
            var icon = new GIcon();
            icon.image = "../img/停机.gif";
            icon.iconSize = new GSize(30, 40);
            icon.iconAnchor = new GPoint(6, 10);
            icon.infoWindowAnchor = new GPoint(5, 20);
            return icon;
        }

        //创建图标  风场(标杆风机)
        function WindIconBG() {
            var icon = new GIcon();
            icon.image = "../img/停机.gif";
            icon.iconSize = new GSize(30, 40);
            icon.iconAnchor = new GPoint(6, 10);
            icon.infoWindowAnchor = new GPoint(5, 20);
            return icon;
        }

        //创建图标  风场
        function WindIconDJ() {
            var icon = new GIcon();
            icon.image = "../img/就绪.gif";
            icon.iconSize = new GSize(30, 40);
            icon.iconAnchor = new GPoint(6, 10);
            icon.infoWindowAnchor = new GPoint(5, 20);
            return icon;
        }

        //标注
        function CreatePointInfo(x, y, myIcon, title, tbInfo, tbImg, yId, flag, sttp, Message) {

            //创建一个地理坐标point
            var point = new GLatLng(x, y);

            //创建自定义的GMarker
            marker = new GMarker(point, { icon: myIcon, title: title });

            //显示自定义了图标的地标对象marker
            map.addOverlay(marker);
        }


        function CreatePoint(x, y, myIcon, title, tbInfo) {

            //创建一个地理坐标point
            var point = new GLatLng(x, y);

            //创建自定义的GMarker
            marker = new GMarker(point, { icon: myIcon, title: title });


            //显示自定义了图标的地标对象marker
            map.addOverlay(marker);

            //注册一个监听事件
            GEvent.addListener(marker, "click", function (pixel, tile) {

                map.openInfoWindow(point, tbInfo);

            });

        }

        function init() {

            $.post("CZMAP.aspx", { param: 'map' }, function (data) {
                var periodid = data.id;
                var cenx = 41.1502870;
                var ceny = 113.3205070;

                //检查浏览器的兼容性.
                if (GBrowserIsCompatible()) {
                    map = new GMap2(document.getElementById("map_canvas"));
                    //设置地图的中心坐标.
                    var loc = new GLatLng(cenx, ceny);
                    map.setCenter(loc, stzoom);
                    //设置地图的缩放工具.
                    map.setUIToDefault();
                    map.addControl(new GSmallMapControl()); //GHierarchicalMapTypeControl
                    //                    map.addControl(new GMapTypeControl());
                    //位于左上角
                    var topLeft = new GControlPosition(G_ANCHOR_TOP_LEFT, new GSize(10, 10));
                    //添加地址导航控件
                    map.addControl(new GNavLabelControl(), topLeft);
                }

                var x = eval(data.x);
                var y = eval(data.y);
                var title = eval(data.title);
                var win = eval(data.win);
                var power = eval(data.power);
                var state = eval(data.state);
                var flag = eval(data.flag);


                var w = 0;
                var p = 0;
                //玫瑰营一期
                if (periodid == 'MGYYQ-YQ') {
                    //设置地图的中心坐标.
                    var loc = new GLatLng(x[9], y[9]);
                    map.setCenter(loc, 15);
                    for (var i = 0; i < x.length; i++) {
                        //                        var pw = power[i] / 10000;
                        //                        var pwfixNum = new Number(pw + 1).toFixed(5); //四舍五入之前加1  
                        //                        var pwfixedNum = new Number(pwfixNum - 1).toFixed(5); //四舍五入之后减1，再四舍五入一下  
                        //                        pw = pwfixedNum;

                        if (Number(state[i]) == -1) {
                            //正常
                            // CreatePointInfo(x[i] + 0.00004, y[i] - 0.00009, WindIconYX(), title[i] + '   风速: ' + win[i] + 'm/s    功率: ' + power[i] + ' kW', '', '', '', '', '', '', '');
                            CreatePoint(x[i] + 0.00004, y[i] - 0.00009, WindIconYX(), title[i], '<div style="width:200px;height:70px;font-size:16px;color:blue;font-weight:bold;">机组名称&nbsp;：' + title[i] + '<br>风&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;速&nbsp;：' + win[i] + '&nbsp;&nbsp;m/s<br>功&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;率&nbsp;：' + power[i] + '&nbsp;kW</div>');
                        }
                        else if (Number(state[i]) == 0) {
                            //停机
                            //CreatePointInfo(x[i] + 0.00004, y[i] - 0.00009, WindIconTJ(), title[i] + '   风速: ' + win[i] + 'm/s    功率: ' + power[i] + ' kW', '', '', '', '', '', '', '');
                            CreatePoint(x[i] + 0.00004, y[i] - 0.00009, WindIconTJ(), title[i], '<div style="width:200px;height:70px;font-size:16px;color:blue;font-weight:bold;">机组名称&nbsp;：' + title[i] + '<br>风&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;速&nbsp;：' + win[i] + '&nbsp;&nbsp;m/s<br>功&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;率&nbsp;：' + power[i] + '&nbsp;kW</div>');
 
                        } else {
                            //通讯中断
                            //CreatePointInfo(x[i] + 0.00004, y[i] - 0.00009, WindIconGZ(), title[i] + '   风速: ' + win[i] + 'm/s    功率: ' + power[i] + ' kW', '', '', '', '', '', '', '');
                            CreatePoint(x[i] + 0.00004, y[i] - 0.00009, WindIconGZ(), title[i], '<div style="width:200px;height:70px;font-size:16px;color:blue;font-weight:bold;">机组名称&nbsp;：' + title[i] + '<br>风&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;速&nbsp;：' + win[i] + '&nbsp;&nbsp;m/s<br>功&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;率&nbsp;：' + power[i] + '&nbsp;kW</div>');
 
                        }
                        if (flag[i] == 1) {
                            map.addOverlay(new google.maps.FocusMarker(new GLatLng(x[i], y[i]), {//pointx + 0.005, pointy - 0.003
                                innerHtml: '<div style="color: #FF0000; font-size:15px;"><br /> ' + title[i] + '</div>'
                            }));
                        }
                        else {
                            map.addOverlay(new google.maps.FocusMarker(new GLatLng(x[i], y[i]), {//pointx + 0.005, pointy - 0.003
                                innerHtml: '<div style="color: blue; font-size:15px;"><br />' + title[i] + '</div>'
                            }));
                        }
                        p += Number(power[i]);

                    }
                    p = p / 10000;
                    var fixNum = new Number(p + 1).toFixed(5); //四舍五入之前加1  
                    var fixedNum = new Number(fixNum - 1).toFixed(5); //四舍五入之后减1，再四舍五入一下  
                    p = fixedNum;
                    //CreatePointInfo(x[4], y[6], WindIconSYZ(), '玫瑰营一期 功率: ' + p + ' 万kW', '', '', '', '', '', '', '');
                    CreatePoint(x[4], y[6], WindIconSYZ(), '玫瑰营一期', '<div style="width:200px;height:70px;font-size:16px;color:blue;font-weight:bold;">风场名称&nbsp;：玫瑰营一期<br><br>功&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;率&nbsp;：' + p + '&nbsp;万kW</div>');

                    map.addOverlay(new google.maps.FocusMarker(new GLatLng(x[4] - 0.000025, y[6] - 0.005 + 0.0013), {//pointx + 0.005, pointy - 0.003
                        innerHtml: '<div style="color: blue; font-size:15px;">玫瑰营一期</div>'
                    }));
                }

                //玫瑰营二期
                if (periodid == 'MGYEQ-EQ') {
                    //设置地图的中心坐标.
                    var loc = new GLatLng(x[0], y[0]);
                    map.setCenter(loc, 15);
                    for (var i = 0; i < x.length; i++) {
                        if (Number(state[i]) == 100) {
                            //正常
                            // CreatePointInfo(x[i] + 0.00004, y[i] - 0.00009, WindIconYX(), title[i] + '   风速: ' + win[i] + 'm/s    功率: ' + power[i] + ' kW', '', '', '', '', '', '', '');
                            CreatePoint(x[i] + 0.00004, y[i] - 0.00009, WindIconYX(), title[i], '<div style="width:200px;height:70px;font-size:16px;color:blue;font-weight:bold;">机组名称&nbsp;：' + title[i] + '<br>风&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;速&nbsp;：' + win[i] + '&nbsp;&nbsp;m/s<br>功&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;率&nbsp;：' + power[i] + '&nbsp;kW</div>');
 
                        } else if (Number(state[i]) == 25) {
                            //停机 待机 通讯中断
                            // CreatePointInfo(x[i] + 0.00004, y[i] - 0.00009, WindIconTJ(), title[i] + '   风速: ' + win[i] + 'm/s    功率: ' + power[i] + ' kW', '', '', '', '', '', '', '');
                            CreatePoint(x[i] + 0.00004, y[i] - 0.00009, WindIconTJ(), title[i], '<div style="width:200px;height:70px;font-size:16px;color:blue;font-weight:bold;">机组名称&nbsp;：' + title[i] + '<br>风&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;速&nbsp;：' + win[i] + '&nbsp;&nbsp;m/s<br>功&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;率&nbsp;：' + power[i] + '&nbsp;kW</div>');

                         
                        } else if (Number(state[i]) == 50 || Number(state[i]) == 75) {
                            //待机 通讯中断
                            // CreatePointInfo(x[i] + 0.00004, y[i] - 0.00009, WindIconDJ(), title[i] + '   风速: ' + win[i] + 'm/s    功率: ' + power[i] + ' kW', '', '', '', '', '', '', '');
                            CreatePoint(x[i] + 0.00004, y[i] - 0.00009, WindIconDJ(), title[i], '<div style="width:200px;height:70px;font-size:16px;color:blue;font-weight:bold;">机组名称&nbsp;：' + title[i] + '<br>风&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;速&nbsp;：' + win[i] + '&nbsp;&nbsp;m/s<br>功&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;率&nbsp;：' + power[i] + '&nbsp;kW</div>');

                           
                        } else {
                            //通讯中断
                            //通讯中断
                            // CreatePointInfo(x[i] + 0.00004, y[i] - 0.00009, WindIconGZ(), title[i] + '   风速: ' + win[i] + 'm/s    功率: ' + power[i] + ' kW', '', '', '', '', '', '', '');
                            CreatePoint(x[i] + 0.00004, y[i] - 0.00009, WindIconGZ(), title[i], '<div style="width:200px;height:70px;font-size:16px;color:blue;font-weight:bold;">机组名称&nbsp;：' + title[i] + '<br>风&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;速&nbsp;：' + win[i] + '&nbsp;&nbsp;m/s<br>功&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;率&nbsp;：' + power[i] + '&nbsp;kW</div>');

                           
                            p += Number(power[i]);
                        }
                        if (flag[i] == 1) {
                            map.addOverlay(new google.maps.FocusMarker(new GLatLng(x[i], y[i]), {//pointx + 0.005, pointy - 0.003
                                innerHtml: '<div style="color: #FF0000; font-size:15px;"><br /> ' + title[i] + '</div>'
                            }));
                        }
                        else {
                            map.addOverlay(new google.maps.FocusMarker(new GLatLng(x[i], y[i]), {//pointx + 0.005, pointy - 0.003
                                innerHtml: '<div style="color: blue; font-size:15px;"><br />' + title[i] + '</div>'
                            }));
                        }
                    }

                    p = p / 10000;
                    var fixNum = new Number(p + 1).toFixed(5); //四舍五入之前加1  
                    var fixedNum = new Number(fixNum - 1).toFixed(5); //四舍五入之后减1，再四舍五入一下  
                    p = fixedNum;

                    // CreatePointInfo(x[4], y[6], WindIconSYZ(), '玫瑰营二期 功率: ' + p + ' 万kW', '', '', '', '', '', '', '');
                    CreatePoint(x[4], y[6], WindIconSYZ(), '玫瑰营二期', '<div style="width:200px;height:70px;font-size:16px;color:blue;font-weight:bold;">风场名称&nbsp;：玫瑰营二期<br><br>功&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;率&nbsp;：' + p + '&nbsp;万kW</div>');

                    map.addOverlay(new google.maps.FocusMarker(new GLatLng(x[4] - 0.000025, y[6] + 0.0013), {//pointx + 0.005, pointy - 0.003
                        innerHtml: '<div style="color: blue; font-size:15px;">玫瑰营二期</div>'
                    }));

                }

                //三胜风场
                if (periodid == 'SDFDC-QB') {
                    //设置地图的中心坐标.
                    var loc = new GLatLng(x[8], y[8]);
                    map.setCenter(loc, 15);
                    for (var i = 0; i < x.length; i++) {
                        //                        var pw = power[i] / 10000;
                        //                        var pwfixNum = new Number(pw + 1).toFixed(5); //四舍五入之前加1  
                        //                        var pwfixedNum = new Number(pwfixNum - 1).toFixed(5); //四舍五入之后减1，再四舍五入一下  
                        //                        pw = pwfixedNum;

                        if (Number(state[i]) == 4 || Number(state[i]) == 5) {
                            //正常
                            // CreatePointInfo(x[i] + 0.00004, y[i] - 0.00009, WindIconYX(), title[i] + '   风速: ' + win[i] + 'm/s    功率: ' + power[i] + ' kW', '', '', '', '', '', '', '');
                            CreatePoint(x[i] + 0.00004, y[i] - 0.00009, WindIconYX(), title[i], '<div style="width:200px;height:70px;font-size:16px;color:blue;font-weight:bold;">机组名称&nbsp;：' + title[i] + '<br>风&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;速&nbsp;：' + win[i] + '&nbsp;&nbsp;m/s<br>功&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;率&nbsp;：' + power[i] + '&nbsp;kW</div>');
 
                        } else if (Number(state[i]) == 1) {
                            //停机 待机 通讯中断
                            // CreatePointInfo(x[i] + 0.00004, y[i] - 0.00009, WindIconTJ(), title[i] + '   风速: ' + win[i] + 'm/s    功率: ' + power[i] + ' kW', '', '', '', '', '', '', '');
                            CreatePoint(x[i] + 0.00004, y[i] - 0.00009, WindIconTJ(), title[i], '<div style="width:200px;height:70px;font-size:16px;color:blue;font-weight:bold;">机组名称&nbsp;：' + title[i] + '<br>风&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;速&nbsp;：' + win[i] + '&nbsp;&nbsp;m/s<br>功&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;率&nbsp;：' + power[i] + '&nbsp;kW</div>');

                           
                        } else if (Number(state[i]) == 0 || Number(state[i]) == 2 || Number(state[i]) == 3 || Number(state[i]) == 9) {
                            //待机 通讯中断
                            //CreatePointInfo(x[i] + 0.00004, y[i] - 0.00009, WindIconDJ(), title[i] + '   风速: ' + win[i] + 'm/s    功率: ' + power[i] + ' 千瓦', '', '', '', '', '', '', '');
                            CreatePoint(x[i] + 0.00004, y[i] - 0.00009, WindIconDJ(), title[i], '<div style="width:200px;height:70px;font-size:16px;color:blue;font-weight:bold;">机组名称&nbsp;：' + title[i] + '<br>风&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;速&nbsp;：' + win[i] + '&nbsp;&nbsp;m/s<br>功&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;率&nbsp;：' + power[i] + '&nbsp;kW</div>');

                           
                        } else {
                            //通讯中断
                            // CreatePointInfo(x[i] + 0.00004, y[i] - 0.00009, WindIconGZ(), title[i] + '   风速: ' + win[i] + 'm/s    功率: ' + power[i] + ' kW', '', '', '', '', '', '', '');
                            CreatePoint(x[i] + 0.00004, y[i] - 0.00009, WindIconGZ(), title[i], '<div style="width:200px;height:70px;font-size:16px;color:blue;font-weight:bold;">机组名称&nbsp;：' + title[i] + '<br>风&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;速&nbsp;：' + win[i] + '&nbsp;&nbsp;m/s<br>功&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;率&nbsp;：' + power[i] + '&nbsp;kW</div>');


                        }
                        if (flag[i] == 1) {
                            map.addOverlay(new google.maps.FocusMarker(new GLatLng(x[i], y[i]), {//pointx + 0.005, pointy - 0.003
                                innerHtml: '<div style="color: #FF0000; font-size:15px;"><br /> ' + title[i] + '</div>'
                            }));
                        }
                        else {
                            map.addOverlay(new google.maps.FocusMarker(new GLatLng(x[i], y[i]), {//pointx + 0.005, pointy - 0.003
                                innerHtml: '<div style="color: blue; font-size:15px;"><br />' + title[i] + '</div>'
                            }));
                        }
                        p += Number(power[i]);

                    }

                    p = p / 10000;
                    var fixNum = new Number(p + 1).toFixed(5); //四舍五入之前加1  
                    var fixedNum = new Number(fixNum - 1).toFixed(5); //四舍五入之后减1，再四舍五入一下  
                    p = fixedNum;

                    // CreatePointInfo(x[4], y[6], WindIconSYZ(), '三胜风电场 功率: ' + p + ' 万kW', '', '', '', '', '', '', '');
                    CreatePoint(x[4], y[6], WindIconSYZ(), '三胜风电场', '<div style="width:200px;height:70px;font-size:16px;color:blue;font-weight:bold;">风场名称&nbsp;：三胜风电场<br><br>功&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;率&nbsp;：' + p + '&nbsp;万kW</div>');

                    map.addOverlay(new google.maps.FocusMarker(new GLatLng(x[4] - 0.000025, y[6] + 0.0013), {//pointx + 0.005, pointy - 0.003
                        innerHtml: '<div style="color: blue; font-size:15px;">三胜风电场</div>'
                    }));
                }

                //富丽达风场
                if (periodid == 'FLDFDC-QB') {
                    //设置地图的中心坐标.
                    var loc = new GLatLng(x[20], y[20]);
                    map.setCenter(loc, 15);
                    for (var i = 0; i < x.length; i++) {

                        if (Number(state[i]) == 4 || Number(state[i]) == 5) {
                            //正常
                            // CreatePointInfo(x[i] + 0.00004, y[i] - 0.00009, WindIconYX(), title[i] + '   风速: ' + win[i] + 'm/s    功率: ' + power[i] + ' kW', '', '', '', '', '', '', '');
                            CreatePoint(x[i] + 0.00004, y[i] - 0.00009, WindIconYX(), title[i], '<div style="width:200px;height:70px;font-size:16px;color:blue;font-weight:bold;">机组名称&nbsp;：' + title[i] + '<br>风&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;速&nbsp;：' + win[i] + '&nbsp;&nbsp;m/s<br>功&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;率&nbsp;：' + power[i] + '&nbsp;kW</div>');
 
                        } else if (Number(state[i]) == 1 || Number(state[i]) == 9) {
                            //停机
                            //CreatePointInfo(x[i] + 0.00004, y[i] - 0.00009, WindIconTJ(), title[i] + '   风速: ' + win[i] + 'm/s    功率: ' + power[i] + ' kW', '', '', '', '', '', '', '');
                            CreatePoint(x[i] + 0.00004, y[i] - 0.00009, WindIconTJ(), title[i], '<div style="width:200px;height:70px;font-size:16px;color:blue;font-weight:bold;">机组名称&nbsp;：' + title[i] + '<br>风&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;速&nbsp;：' + win[i] + '&nbsp;&nbsp;m/s<br>功&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;率&nbsp;：' + power[i] + '&nbsp;kW</div>');
 
                        } else if (Number(state[i]) == 0 || Number(state[i]) == 3 || Number(state[i]) == 2) {
                            //待机
                            //CreatePointInfo(x[i] + 0.00004, y[i] - 0.00009, WindIconDJ(), title[i] + '   风速: ' + win[i] + 'm/s    功率: ' + power[i] + ' kW', '', '', '', '', '', '', '');
                            CreatePoint(x[i] + 0.00004, y[i] - 0.00009, WindIconDJ(), title[i], '<div style="width:200px;height:70px;font-size:16px;color:blue;font-weight:bold;">机组名称&nbsp;：' + title[i] + '<br>风&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;速&nbsp;：' + win[i] + '&nbsp;&nbsp;m/s<br>功&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;率&nbsp;：' + power[i] + '&nbsp;kW</div>');
 
                        } else {
                            //通讯中断
                            // CreatePointInfo(x[i] + 0.00004, y[i] - 0.00009, WindIconGZ(), title[i] + '   风速: ' + win[i] + 'm/s    功率: ' + power[i] + ' kW', '', '', '', '', '', '', '');
                            CreatePoint(x[i] + 0.00004, y[i] - 0.00009, WindIconGZ(), title[i], '<div style="width:200px;height:70px;font-size:16px;color:blue;font-weight:bold;">机组名称&nbsp;：' + title[i] + '<br>风&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;速&nbsp;：' + win[i] + '&nbsp;&nbsp;m/s<br>功&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;率&nbsp;：' + power[i] + '&nbsp;kW</div>');
 
                        }
                        if (flag[i] == 1) {
                            map.addOverlay(new google.maps.FocusMarker(new GLatLng(x[i], y[i]), {//pointx + 0.005, pointy - 0.003
                                innerHtml: '<div style="color: #FF0000; font-size:15px;"><br /> ' + title[i] + '</div>'
                            }));
                        }
                        else {
                            map.addOverlay(new google.maps.FocusMarker(new GLatLng(x[i], y[i]), {//pointx + 0.005, pointy - 0.003
                                innerHtml: '<div style="color: blue; font-size:15px;"><br />' + title[i] + '</div>'
                            }));
                        }
                        p += Number(power[i]);

                    }
                    p = p / 10000;
                    var fixNum = new Number(p + 1).toFixed(5); //四舍五入之前加1  
                    var fixedNum = new Number(fixNum - 1).toFixed(5); //四舍五入之后减1，再四舍五入一下  
                    p = fixedNum;

                    // CreatePointInfo(x[4] + 0.009, y[6] - 0.005, WindIconSYZ(), '富丽达风场 功率: ' + p + ' 万kW', '', '', '', '', '', '', '');
                    CreatePoint(x[4] + 0.009, y[6] - 0.005, WindIconSYZ(), '富丽达风场', '<div style="width:200px;height:70px;font-size:16px;color:blue;font-weight:bold;">富丽达风场&nbsp;：三胜风电场<br><br>功&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;率&nbsp;：' + p + '&nbsp;万kW</div>');

                    map.addOverlay(new google.maps.FocusMarker(new GLatLng(x[4] + 0.008, y[6] - 0.006), {//pointx + 0.005, pointy - 0.003
                        innerHtml: '<div style="color: blue; font-size:15px;">富丽达风场</div>'
                    }));

                }


            }, 'json');

        }


        google.maps.FocusMarker = function (latlng, opt) {
            this.latlng = latlng;
            this.innerHtml = opt.innerHtml || '';
            this.className = opt.className || '';
            this.css = opt.css || {};
            this.id = opt.id || '';
        }
        google.maps.FocusMarker.prototype = new google.maps.Overlay();
        google.maps.FocusMarker.prototype.initialize = function (map) {
            // 创建用于表示该矩形区域的 DIV 元素
            var div = document.createElement("div");
            div.id = this.id || '';
            div.style.width = this.css.width || 'auto';
            div.className = this.className;
            div.style.border = this.css.border || "none";
            div.style.color = this.css.color || "#000000";
            div.style.backgroundColor = this.css.backgroundColor || "";
            div.style.position = this.css.position || "absolute";
            div.style.textAlign = this.css.textAlign || "center";
            div.style.padding = this.css.padding || "0px 0px 0px 0px";
            div.style.fontSize = this.css.fontSize || "12px";
            div.style.height = this.css.height || "60px";
            div.style.cursor = this.css.cursor || "pointer";
            div.style.whiteSpace = this.css.whiteSpace || "nowrap";

            var c = map.fromLatLngToDivPixel(this.latlng);
            div.style.left = c.x + "px";
            div.style.top = c.y + "px";
            div.innerHTML = this.innerHtml;
            // 我们希望将覆盖物紧贴于地图之上，因此我们把它放置在 Z 序最小的 G_MAP_MAP_PANE 层，  
            // 事实上，这也是地图本身的 Z 顺序，即在标注的影子之下  
            map.getPane(G_MAP_MAP_PANE).appendChild(div);
            this.map = map;
            this.container = div;
        }
        google.maps.FocusMarker.prototype.remove = function () {
            this.container.parentNode.removeChild(this.container);
        }
        google.maps.FocusMarker.prototype.redraw = function (force) {
            // 只有当坐标系改变时，我们才需要重绘
            if (!force) return;

            // 根据当前显示区域的经纬度坐标，计算 DIV 元素的左上角和右下角的像素坐标
            var c = this.map.fromLatLngToDivPixel(this.latlng);
            // 根据计算得到的坐标放置我们的 DIV 元素
            this.container.style.left = c.x + "px";
            this.container.style.top = c.y + "px";
            // this.div_.style.width = "auto";
        }
        //初始化地图
        // window.onload = init;
        $(document).ready(function () {
            var Sys = {};
            var ua = navigator.userAgent.toLowerCase();
            var s;
            (s = ua.match(/msie ([\d.]+)/)) ? Sys.ie = s[1] :
            (s = ua.match(/firefox\/([\d.]+)/)) ? Sys.firefox = s[1] :
            (s = ua.match(/chrome\/([\d.]+)/)) ? Sys.chrome = s[1] :
            (s = ua.match(/opera.([\d.]+)/)) ? Sys.opera = s[1] :
            (s = ua.match(/version\/([\d.]+).*safari/)) ? Sys.safari = s[1] : 0;
            if (Sys.ie) {
                if (Sys.ie == "6.0") {

                }
                if (Sys.ie == "7.0") {
                    changeGoogleHeight();
                }
                if (Sys.ie == "8.0") {
                    changeGoogleHeight();
                }
                if (Sys.ie == "9.0") {
                    changeGoogleHeight();
                }
                if (Sys.ie == "10.0") {
                    changeGoogleHeight();
                }

            }
            if (Sys.firefox) {
                changeGoogleHeight();
            }
            if (Sys.chrome) {
                changeGoogleHeight();
            }
            if (Sys.opera) {
                changeGoogleHeight();
            }
            if (Sys.safari) {
                changeGoogleHeight();
            }
            init();
        });
        function changeGoogleHeight() {
            $("#map_canvas").height(pageHeight() - 20);
            //            $("#map_canvas").width(pageWidth() - 220);
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
<body>
    <div id="dv_body">
        <div id="map_canvas" style="float: right; width: 100%; height: 100%;">
        </div>
    </div>
</body>
</html>
