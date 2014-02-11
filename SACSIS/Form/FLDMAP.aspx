<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="FLDMAP.aspx.cs" Inherits="SACSIS.Form.FLDMAP" %>

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

        //创建图标  风场
        function WindIcon() {
            var icon = new GIcon();
            icon.image = "../img/wind_black.gif";
            icon.iconSize = new GSize(30, 40);
            icon.iconAnchor = new GPoint(6, 10);
            icon.infoWindowAnchor = new GPoint(5, 20);
            return icon;
        }

        //创建图标  风场
        function WindIconYX() {
            var icon = new GIcon();
            icon.image = "../img/wind_black.gif";
            icon.iconSize = new GSize(30, 40);
            icon.iconAnchor = new GPoint(6, 10);
            icon.infoWindowAnchor = new GPoint(5, 20);
            return icon;
        }

        //创建图标  风场
        function WindIconGZ() {
            var icon = new GIcon();
            icon.image = "../img/wind_black.gif";
            icon.iconSize = new GSize(30, 40);
            icon.iconAnchor = new GPoint(6, 10);
            icon.infoWindowAnchor = new GPoint(5, 20);
            return icon;
        }

        //创建图标  风场
        function WindIconTJ() {
            var icon = new GIcon();
            icon.image = "../img/wind_black.gif";
            icon.iconSize = new GSize(30, 40);
            icon.iconAnchor = new GPoint(6, 10);
            icon.infoWindowAnchor = new GPoint(5, 20);
            return icon;
        }

        //创建图标  风场
        function WindIconDJ() {
            var icon = new GIcon();
            icon.image = "../img/yh.gif";
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


        function init() {

            $.post("FLDMAP.aspx", { param: 'map', id: 'FLDFDC-QB' }, function (data) {
                var periodid = 'FLDFDC-QB';
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

                //设置地图的中心坐标.
                var loc = new GLatLng(x[0], y[0]);
                map.setCenter(loc, 14);

                //玫瑰营一期
                if (periodid == 'MGYYQ-YQ') {
                    for (var i = 0; i < x.length; i++) {
                        if (Number(state[i]) == -1) {
                            //正常

                        }
                        else if (Number(state[i]) == 0) {
                            //停机


                        } else {
                            //通讯中断

                        }

                        CreatePointInfo(x[i], y[i], WindIcon(), title[i] + '   风速: ' + win[i] + 'm/s    功率: ' + power[i] + ' 万千瓦', '', '', '', '', '', '', '');

                        map.addOverlay(new google.maps.FocusMarker(new GLatLng(x[i], y[i]), {//pointx + 0.005, pointy - 0.003
                            innerHtml: '<div style="color: yellow; font-size:15px;">' + title[i] + '</div>'
                        }));
                    }
                }

                //玫瑰营二期
                if (periodid == 'MGYEQ-EQ') {
                    if (Number(state[i]) == 100) {
                        //正常

                    } else if (Number(state[i]) == 25) {
                        //停机 待机 通讯中断

                    } else if (Number(state[i]) == 50 || Number(state[i]) == 75) {
                        //待机 通讯中断

                    } else {
                        //通讯中断

                    }



                }

                //三胜风场
                if (periodid == 'SDFDC-QB') {
                    for (var i = 0; i < x.length; i++) {
                        if (Number(state[i]) == 4 || Number(state[i]) == 5) {
                            //正常
                            CreatePointInfo(x[i], y[i], WindIcon(), title[i] + '   风速: ' + win[i] + 'm/s    功率: ' + power[i] + ' 万千瓦', '', '', '', '', '', '', '');
                        } else if (Number(state[i]) == 1) {
                            //停机
                            CreatePointInfo(x[i], y[i], WindIcon(), title[i] + '   风速: ' + win[i] + 'm/s    功率: ' + power[i] + ' 万千瓦', '', '', '', '', '', '', '');
                        } else if (Number(state[i]) == 0 || Number(state[i]) == 2 || Number(state[i]) == 3 || Number(state[i]) == 2) {
                            //待机
                            CreatePointInfo(x[i], y[i], WindIconDJ(), title[i] + '   风速: ' + win[i] + 'm/s    功率: ' + power[i] + ' 万千瓦', '', '', '', '', '', '', '');
                        } else {
                            //通讯中断
                            CreatePointInfo(x[i], y[i], WindIcon(), title[i] + '   风速: ' + win[i] + 'm/s    功率: ' + power[i] + ' 万千瓦', '', '', '', '', '', '', '');
                        }
                        map.addOverlay(new google.maps.FocusMarker(new GLatLng(x[i], y[i]), {//pointx + 0.005, pointy - 0.003
                            innerHtml: '<div style="color: yellow; font-size:15px;">' + title[i] + '</div>'
                        }));
                    }
                }

                //富丽达风场
                if (periodid == 'FLDFDC-QB') {
                    for (var i = 0; i < x.length; i++) {
                        if (Number(state[i]) == 4 || Number(state[i]) == 5) {
                            //正常

                        } else if (Number(state[i]) == 1 || Number(state[i]) == 9) {
                            //停机 待机 通讯中断

                        } else if (Number(state[i]) == 0 || Number(state[i]) == 3 || Number(state[i]) == 2) {
                            //待机 通讯中断

                        } else {
                            //通讯中断

                        }


                        CreatePointInfo(x[i], y[i], WindIcon(), title[i] + '   风速: ' + win[i] + 'm/s    功率: ' + Number(power[i]) / 10000 + ' 万千瓦', '', '', '', '', '', '', '');

                        map.addOverlay(new google.maps.FocusMarker(new GLatLng(x[i], y[i]), {//pointx + 0.005, pointy - 0.003
                            innerHtml: '<div style="color: yellow; font-size:15px;">' + title[i] + '</div>'
                        }));
                    }

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
            $("#map_canvas").height(pageHeight() - 16);
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
