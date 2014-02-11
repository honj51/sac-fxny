<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Map.aspx.cs" Inherits="SACSIS.Form.Map" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link href="../css/zTreeStyle/zTreeStyle.css" rel="stylesheet" type="text/css" />
    <script src="../Js/jquery-1.8.2.min.js" type="text/javascript"></script>
    <script src="../Js/jQueryZtree/jquery.ztree.core-3.5.js" type="text/javascript"></script>
    <%--    <script charset="utf-8" type="text/javascript" src="http://maps.google.cn/maps?file=api&amp;v=3&amp;key&amp;sensor=false&amp;hl=zh-CN"></script>--%>
    <script type="text/javascript" src="http://ditu.google.cn/maps?file=api&v=3&key=ABQIAAAAzqxfZV_KI62eXC63CWL97xS1Vavjk_vyjwBdhsJgngpb2VfMxxSfTJP7Je6yhTdEna54Kbf-XQJkVw&hl=zh-CN"></script>
    <script type="text/javascript" charset="UTF-8">
        var editWin;
        var winWidth = 800;
        var winHeight = 400;

        var yCount = 0;
        var stzoom = 10;
        var map;

        //创建图标  风场
        function WindIcon() {
            var icon = new GIcon();
            icon.image = "../img/wind_black.gif";
            icon.iconSize = new GSize(30, 40);
            icon.iconAnchor = new GPoint(6, 10);
            icon.infoWindowAnchor = new GPoint(5, 20);
            return icon;
        }

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

        //创建图标  风场
        function WindIconDJ() {
            var icon = new GIcon();
            icon.image = "../img/就绪.gif";
            icon.iconSize = new GSize(30, 40);
            icon.iconAnchor = new GPoint(6, 10);
            icon.infoWindowAnchor = new GPoint(5, 20);
            return icon;
        }

        //        //标注
        //        function CreatePointInfo(x, y, myIcon, title, tbInfo, tbImg, yId, flag, sttp, Message) {

        //            //创建一个地理坐标point
        //            var point = new GLatLng(x, y);

        //            //创建自定义的GMarker
        //            marker = new GMarker(point, { icon: myIcon, title: title });

        //            //显示自定义了图标的地标对象marker
        //            map.addOverlay(marker);
        //        }

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

        //        //输出信息
        //        function test(marker, info) {
        //            marker.openInfoWindowHtml(info);
        //        }

        //        //截取字符串
        //        String.prototype.remove = function (start, length) {
        //            var sInfo = this.slice(0, start);
        //            var eInfo = this.slice(start + length);
        //            return sInfo + eInfo;
        //        }

        //绘制坐标点
        //        function GetPoint() {

        //            var timeValue = 30;
        //            setTimeout("GetPoint()", timeValue * 1000);
        //            yCount++;
        //        }
        //        function showLine() {
        //            var posts = new Array();
        //            $.getJSON("file/GoogleJsonStr.json", function (data) {
        //                $.each(data, function (entryIndex, entry) {
        //                    posts.push(new GLatLng(entry["y"], entry["x"]));
        //                });
        //                map.addOverlay(new GPolyline(posts, "#FF00CC", 2));
        //            });
        //        }

        function init() {

            $.post("Map.aspx", { param: 'Init' }, function (data) {

                var cenx = 41.1502870; // site[1];
                var ceny = 113.3205070; // site[0];

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

                for (var i = 0; i < x.length; i++) {
                    // CreatePointInfo(x[i], y[i], WindIconSYZ(), title[i] + '   风速: ' + win[i] + 'm/s    功率: ' + power[i] + ' 万kW', '', '', '', '', '', '', '');

                    CreatePoint(x[i], y[i], WindIconSYZ(), title[i], '<div style="width:200px;height:70px;font-size:16px;color:blue;font-weight:bold;">风场名称&nbsp;：' + title[i] + '<br>风&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;速&nbsp;：' + win[i] + '&nbsp;&nbsp;m/s<br>功&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;率&nbsp;：' + power[i] + '&nbsp;MW</div>');

                    map.addOverlay(new google.maps.FocusMarker(new GLatLng(x[i] - 0.03, y[i] + 0.0013), {//pointx + 0.005, pointy - 0.003
                        innerHtml: '<div style="color: Red; font-size:15px;">' + title[i] + '</div>'
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
            $("#map_canvas").height(pageHeight() - 10);
            $("#map_canvas").width(pageWidth() - 10);
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
        <div id="map_canvas" style="float: right; width: 100%;  height: 100%;">
        </div>
    </div>
</body>
</html>
