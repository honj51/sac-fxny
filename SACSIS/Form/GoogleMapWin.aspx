<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="GoogleMapWin.aspx.cs" Inherits="SACSIS.Form.GoogleMapWin" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>风机分布</title>
    <style type="text/css">
        v\:*
        {
            behavior: url(#default#VML);
        }
        html, body
        {
            font-size: 12px;
            height: 100%;
            margin: 0px;
        }
        .style1
        {
            color: #FF0000;
        }
        .sec1
        {
            border-right: gray 1px solid;
            border-top: #ffffff 1px solid;
            border-left: #ffffff 1px solid;
            cursor: hand;
            color: #0000FF;
            font-size: 12px;
            border-bottom: #ffffff 1px solid;
            background-color: #eeeeee;
        }
        .wenchua div
        {
            margin: 5px 0 5px 5px;
        }
        .wenchua img
        {
            float: left;
            border: 1px solid #B1E3F9;
            cursor: pointer;
        }
        .wenchua img:hover
        {
            border-color: #D3D3D3;
        }
        .isWarn_hide
        {
            display: none;
            position: absolute;
            top: 0%;
            left: 0%;
            width: 100%;
            height: 100%;
            background-color: silver;
            z-index: 11001;
            border: 4px solid orange;
        }
        .isWarn_div
        {
            border: 4px solid orange;
            display: none;
            position: absolute;
            padding: 10px;
            right: 0px;
            bottom: 0px;
            background-color: white;
            z-index: 11002;
            overflow: auto;
        }
    </style>
    <script src="../Js/jquery-1.8.2.min.js" type="text/javascript"></script>
    <script src="../Js/jquery.easyui.min.js" type="text/javascript"></script>
    <%--    <script charset="utf-8" src="http://ditu.google.cn/maps?file=api&amp;v=2&amp;key&sensor=false&hl=zh-CN"
        type="text/javascript"></script>--%>
    <script charset="utf-8" type="text/javascript" src="http://maps.google.cn/maps?file=api&amp;v=3&amp;key&amp;sensor=false&amp;hl=zh-CN"></script>
    <script type="text/javascript" charset="UTF-8">
        var editWin;
        var winWidth = 800;
        var winHeight = 400;

        var yCount = 0;
        var stzoom = 10;
        var map;

        var taImg;

        //创建图标  雨量站
        function RainIcon() {
            var icon1 = new GIcon();
            icon1.image = "../images/IMG/_hgb.gif";
            icon1.iconSize = new GSize(10, 10);
            //            icon1.shadowSize = new GSize(16, 15);
            icon1.iconAnchor = new GPoint(6, 10);
            icon1.infoWindowAnchor = new GPoint(5, 20);
            return icon1;
        }

        //创建图标 水库站
        function WaterImg() {
            var icon2 = new GIcon();
            icon2.image = "../images/IMG/stcd_rr.gif";
            icon2.iconSize = new GSize(10, 10);
            //            icon2.shadowSize = new GSize(16, 15);
            icon2.iconAnchor = new GPoint(6, 10);
            icon2.infoWindowAnchor = new GPoint(5, 20);
            return icon2;
        }
        //创建图标 水库 雨量站
        function WaterRainImg() {
            var icon2 = new GIcon();
            icon2.image = "../images/IMG/stcd_rr.gif";
            icon2.iconSize = new GSize(10, 10);
            //            icon2.shadowSize = new GSize(16, 15);
            icon2.iconAnchor = new GPoint(6, 10);
            icon2.infoWindowAnchor = new GPoint(5, 20);
            return icon2;
        }


        //创建图标 河道站
        function RiverIcon() {
            var icon4 = new GIcon();
            icon4.image = "../images/IMG/stcd_rr.gif";
            icon4.iconSize = new GSize(10, 10);
            //            icon4.shadowSize = new GSize(16, 15);
            icon4.iconAnchor = new GPoint(6, 10);
            icon4.infoWindowAnchor = new GPoint(5, 20);
            return icon4;
        }

        //创建图标 河道 雨量站
        function RiverRainIcon() {
            var icon4 = new GIcon();
            icon4.image = "../images/IMG/stcd_rr.gif";
            icon4.iconSize = new GSize(10, 10);
            //            icon4.shadowSize = new GSize(16, 15);
            icon4.iconAnchor = new GPoint(6, 10);
            icon4.infoWindowAnchor = new GPoint(5, 20);
            return icon4;
        }


        //创建图标  警戒
        function yuJingIcon() {
            var icon3 = new GIcon();
            icon3.image = "../images/IMG/yj.gif";
            icon3.iconSize = new GSize(10, 10);
            //            icon3.shadowSize = new GSize(16, 15);
            icon3.iconAnchor = new GPoint(6, 10);
            icon3.infoWindowAnchor = new GPoint(5, 20);
            return icon3;
        }


        //创建图标 预警 级别：一级   状态：0   超警
        function yuJing11Icon(color) {
            var icon3 = new GIcon();
            icon3.image = "../images/IMG/0" + color + ".gif";
            icon3.iconSize = new GSize(10, 10);
            //            icon3.shadowSize = new GSize(16, 15);
            icon3.iconAnchor = new GPoint(6, 10);
            icon3.infoWindowAnchor = new GPoint(5, 20);
            return icon3;
        }

        //创建图标 预警 级别：一级   状态：10
        function yuJing110Icon(color) {
            var icon3 = new GIcon();
            icon3.image = "../images/IMG/10" + color + ".gif";
            icon3.iconSize = new GSize(10, 10);
            //            icon3.shadowSize = new GSize(16, 15);
            icon3.iconAnchor = new GPoint(6, 10);
            icon3.infoWindowAnchor = new GPoint(5, 20);
            return icon3;
        }

        //创建图标 预警 级别：一级   状态：20
        function yuJing120Icon(color) {
            var icon3 = new GIcon();
            icon3.image = "../images/IMG/20" + color + ".gif";
            icon3.iconSize = new GSize(10, 10);
            //            icon3.shadowSize = new GSize(16, 15);
            icon3.iconAnchor = new GPoint(6, 10);
            icon3.infoWindowAnchor = new GPoint(5, 20);
            return icon3;
        }

        //创建图标 预警 级别：一级   状态：30
        function yuJing130Icon(color) {
            var icon3 = new GIcon();
            icon3.image = "../images/IMG/30" + color + ".gif";
            icon3.iconSize = new GSize(10, 10);
            //            icon3.shadowSize = new GSize(16, 15);
            icon3.iconAnchor = new GPoint(6, 10);
            icon3.infoWindowAnchor = new GPoint(5, 20);
            return icon3;
        }

        //创建图标 预警 级别：一级   状态：40
        function yuJing140Icon(color) {
            var icon3 = new GIcon();
            icon3.image = "../images/IMG/40" + color + ".gif";
            icon3.iconSize = new GSize(10, 10);
            //            icon3.shadowSize = new GSize(16, 15);
            icon3.iconAnchor = new GPoint(6, 10);
            icon3.infoWindowAnchor = new GPoint(5, 20);
            return icon3;
        }

        //创建图标 预警 级别：一级   状态：50
        function yuJing150Icon(color) {
            var icon3 = new GIcon();
            icon3.image = "../images/IMG/50" + color + ".gif";
            icon3.iconSize = new GSize(10, 10);
            //            icon3.shadowSize = new GSize(16, 15);
            icon3.iconAnchor = new GPoint(6, 10);
            icon3.infoWindowAnchor = new GPoint(5, 20);
            return icon3;
        }

        //创建图标 预警 级别：一级   状态：60
        function yuJing160Icon(color) {
            var icon3 = new GIcon();
            icon3.image = "../images/IMG/60" + color + ".gif";
            icon3.iconSize = new GSize(10, 10);
            //            icon3.shadowSize = new GSize(16, 15);
            icon3.iconAnchor = new GPoint(6, 10);
            icon3.infoWindowAnchor = new GPoint(5, 20);
            return icon3;
        }



        //创建图标 预警 级别：二级   状态：0
        function yuJing21Icon() {
            var icon3 = new GIcon();
            icon3.image = "../images/IMG/o1.gif";
            icon3.iconSize = new GSize(10, 10);
            //            icon3.shadowSize = new GSize(16, 15);
            icon3.iconAnchor = new GPoint(6, 10);
            icon3.infoWindowAnchor = new GPoint(5, 20);
            return icon3;
        }

        //创建图标 预警 级别：二级   状态：10
        function yuJing210Icon() {
            var icon3 = new GIcon();
            icon3.image = "../images/IMG/o2.gif";
            icon3.iconSize = new GSize(10, 10);
            //            icon3.shadowSize = new GSize(16, 15);
            icon3.iconAnchor = new GPoint(6, 10);
            icon3.infoWindowAnchor = new GPoint(5, 20);
            return icon3;
        }

        //创建图标 预警 级别：二级   状态：20
        function yuJing220Icon() {
            var icon3 = new GIcon();
            icon3.image = "../images/IMG/o3.gif";
            icon3.iconSize = new GSize(10, 10);
            //            icon3.shadowSize = new GSize(16, 15);
            icon3.iconAnchor = new GPoint(6, 10);
            icon3.infoWindowAnchor = new GPoint(5, 20);
            return icon3;
        }

        //创建图标 预警 级别：二级   状态：30
        function yuJing230Icon() {
            var icon3 = new GIcon();
            icon3.image = "../images/IMG/o4.gif";
            icon3.iconSize = new GSize(10, 10);
            //            icon3.shadowSize = new GSize(16, 15);
            icon3.iconAnchor = new GPoint(6, 10);
            icon3.infoWindowAnchor = new GPoint(5, 20);
            return icon3;
        }

        //创建图标 预警 级别：二级   状态：40
        function yuJing240Icon() {
            var icon3 = new GIcon();
            icon3.image = "../images/IMG/o5.gif";
            icon3.iconSize = new GSize(10, 10);
            //            icon3.shadowSize = new GSize(16, 15);
            icon3.iconAnchor = new GPoint(6, 10);
            icon3.infoWindowAnchor = new GPoint(5, 20);
            return icon3;
        }

        //创建图标 预警 级别：二级   状态：50
        function yuJing250Icon() {
            var icon3 = new GIcon();
            icon3.image = "../images/IMG/o6.gif";
            icon3.iconSize = new GSize(10, 10);
            //            icon3.shadowSize = new GSize(16, 15);
            icon3.iconAnchor = new GPoint(6, 10);
            icon3.infoWindowAnchor = new GPoint(5, 20);
            return icon3;
        }

        //创建图标 预警 级别：二级   状态：60
        function yuJing260Icon() {
            var icon3 = new GIcon();
            icon3.image = "../images/IMG/o7.gif";
            icon3.iconSize = new GSize(10, 10);
            //            icon3.shadowSize = new GSize(16, 15);
            icon3.iconAnchor = new GPoint(6, 10);
            icon3.infoWindowAnchor = new GPoint(5, 20);
            return icon3;
        }

        function CreatePoint(x, y, myIcon, title, tbInfo, tbImg, yId, flag, sttp) {

            //            if (yCount != 0 && yCount % 10 == 0) {
            map.clearOverlays();
            //            }  

            //创建一个地理坐标point
            var point = new GLatLng(x, y);

            //创建自定义的GMarker
            marker = new GMarker(point, { icon: myIcon, title: title });


            //显示自定义了图标的地标对象marker
            map.addOverlay(marker);

            //注册一个监听事件
            GEvent.addListener(marker, "click", function (pixel, tile) {


                if (tbImg != '' && tbImg != null) {
                    var infoTabs = [
                                             new GInfoWindowTab("基本信息", tbInfo),
                                            new GInfoWindowTab("图片监测", tbImg)
                                       ];
                    map.openInfoWindow(point, infoTabs);

                } else {
                    var infoTabs = [
                                             new GInfoWindowTab("基本信息", tbInfo)
                                          ];
                    map.openInfoWindow(point, infoTabs);
                }
            });

        }

        function CreatePointInfo(x, y, myIcon, title, tbInfo, tbImg, yId, flag, sttp, Message) {

            //创建一个地理坐标point
            var point = new GLatLng(x, y);

            //创建自定义的GMarker
            marker = new GMarker(point, { icon: myIcon, title: title });

            //显示自定义了图标的地标对象marker
            map.addOverlay(marker);

            //注册一个监听事件
            GEvent.addListener(marker, "click", function (pixel, tile) {

                if (Message != '' && Message != null) {//判断是否是雨量站

                    //水库站
                    if (sttp.substring(0, 2) == "RR") {
                        var waterInfos = [
                                                 new GInfoWindowTab("实时信息", tbInfo),
                                                  new GInfoWindowTab("图片监测", tbImg),
                                                  new GInfoWindowTab("水库信息", Message)
                                           ];
                        map.openInfoWindow(point, waterInfos);
                    }

                    //河道站
                    if (sttp.substring(0, 2) == "ZZ") {

                        var riverInfos = [
                                                 new GInfoWindowTab("实时信息", tbInfo),
                                                  new GInfoWindowTab("图片监测", tbImg),
                                                  new GInfoWindowTab("河流信息", Message)
                                           ];
                        map.openInfoWindow(point, riverInfos);
                    }
                } else {
                    //雨量站
                    var rainInfos = [
                                              new GInfoWindowTab("实时信息", tbInfo),
                                                  new GInfoWindowTab("图片监测", tbImg)
                                          ];
                    map.openInfoWindow(point, rainInfos);
                }
            });
        }


        //输出信息
        function test(marker, info) {
            marker.openInfoWindowHtml(info);
        }

        //截取字符串
        String.prototype.remove = function (start, length) {
            var sInfo = this.slice(0, start);
            var eInfo = this.slice(start + length);
            return sInfo + eInfo;
        }

        function openBg(state) { //遮照打开关闭控制
            if (state == 1) {
                document.getElementById("wenchuan").style.display = "block";
                var h = document.body.offsetHeight > document.documentElement.offsetHeight ? document.body.offsetHeight : document.documentElement.offsetHeight;
                document.getElementById("wenchuan").style.height = h + "px";
            }
            else {
                document.getElementById("wenchuan").style.display = "none";
            }
        }

        function ImgShow(evt, path) {
            openBg(1);
            var imgPath = path;   //取得弹出的大图url
            var tagTop = Math.max(document.documentElement.scrollTop, document.body.scrollTop);
            var tag = document.createElement("div");
            tag.style.cssText = "width:100%;height:" + Math.max(document.body.clientHeight, document.body.offsetHeight) + "px;position:absolute;background:white;top:0;filter: Alpha(Opacity=80);Opacity:0.8;";
            tag.ondblclick = function () { var clsOK = confirm("确定要取消图片显示吗?"); if (clsOK) { closes(); } };
            var tagImg = document.createElement("div");
            tagImg.style.cssText = "font:12px /18px verdana;overflow:auto;text-align:center;position:absolute;width:200px;border:1px solid #B1E3F9;background:#B1E3F9;color:white;left:" + (parseInt(document.body.offsetWidth) / 2 - 100) + "px;top:" + (document.documentElement.clientHeight / 3 + tagTop) +
"px;"
            tagImg.innerHTML = "<div style='padding:10px;background:#cccccc;border:1px solid white'><img src='http://bbs.blueidea.com/attachment.php?aid=91156&noupdate=yes' /><br /><br /><b style='color:#999999;font-weight:normal'>Image loading...</b><br /></div>";
            var closeTag = document.createElement("div");
            closeTag.style.cssText = "display:none;position:absolute;right:10px;top:10px;cursor:pointer;border:0px solid #B1E3F9;color:red;font-size:24px;";
            closeTag.innerHTML = "<b title='关闭'>X</b>";
            closeTag.onclick = closes;

            var dataTag = document.createElement("div");
            dataTag.id = "divDetail";
            dataTag.style.cssText = "display:block;position:absolute;right:0px;bottom:0px;border:1px solid #B1E3F9; border-right-width:0; border-bottom-width:0;background:gray;color:black;";

            //dataTag.innerHTML = searchByJs.GetStcdStrHtml(stcd, stnm, stlc, "良好", lgtd, lttd, dtmel, setdate, flag, drnname, monitorname, monitorphoto2, frgrd, admauth).value;//设为空
            dataTag.innerHTML = "";

            var divShowHideTag = document.createElement("div");
            divShowHideTag.id = "divOpenColseImg";
            divShowHideTag.style.cssText = "display:none;position:absolute;right:10px;bottom:10px;border:0px solid #B1E3F9;";
            divShowHideTag.innerHTML = "<img src='../../ExtFiles/CeZhan/图标.png' title='展开' style='cursor:hand;' onclick='showDetail();'/>";

            document.body.appendChild(tag);
            document.body.appendChild(tagImg);

            var img = new Image();
            img.src = imgPath;

            img.style.cssText = "border:1px solid #cccccc;filter: Alpha(Opacity=0);Opacity:0;";
            tagImg.oncontextmenu = function () { var clsOK = confirm("确定要取消图片显示吗?"); if (clsOK) { closes(); }; return false };
            var barShow, imgTime;
            img.complete ? ImgOK() : img.onload = ImgOK;
            function ImgOK() {
                var Stop1 = false, Stop2 = false, temp = 0;
                var tx = tagImg.offsetWidth, ty = tagImg.offsetHeight;
                var ix = img.width, iy = img.height;

                var sx = document.documentElement.clientWidth, sy = Math.min(document.documentElement.clientHeight, document.body.clientHeight/*opera*/);
                var xx = ix > sx ? sx - 50 : ix + 4, yy = iy > sy ? sy - 50 : iy + 3;

                var maxTime = setInterval(function () {
                    temp += 35;
                    if ((tx + temp) < xx) {
                        tagImg.style.width = (tx + temp) + "px";
                        tagImg.style.left = (sx - (tx + temp)) / 2 + "px";
                    } else {
                        Stop1 = true;
                        tagImg.style.width = xx + "px";
                        tagImg.style.left = (sx - xx) / 2 + "px";
                    }
                    if ((ty + temp) < yy) {
                        tagImg.style.height = (ty + temp) + "px";
                        tagImg.style.top = (tagTop + ((sy - (ty + temp)) / 2)) + "px";
                    } else {
                        Stop2 = true;
                        tagImg.style.height = yy + "px";
                        tagImg.style.top = (tagTop + ((sy - yy) / 2)) + "px";
                    }
                    if (Stop1 && Stop2) {
                        clearInterval(maxTime);
                        tagImg.appendChild(img);
                        temp = 0;
                        imgOPacity();
                    }
                }, 1);
                function imgOPacity() {
                    temp += 10;
                    img.style.filter = "alpha(opacity=" + temp + ")";
                    img.style.opacity = temp / 100;
                    imgTime = setTimeout(imgOPacity, 1)
                    if (temp > 100) clearTimeout(imgTime);
                }
                tagImg.innerHTML = "";
                tagImg.appendChild(closeTag);
                tagImg.appendChild(dataTag);
                //tagImg.appendChild(divShowHideTag);//注释
                if (ix > xx || iy > yy) {
                    img.alt = "左键拖动,双击放大缩小";
                    img.ondblclick = function () {
                        if (tagImg.offsetWidth < img.offsetWidth || tagImg.offsetHeight < img.offsetHeight) {
                            img.style.width = "auto";
                            img.style.height = "100%";
                            img.alt = "双击可以放大";
                            img.onmousedown = null;
                            closeTag.style.top = "10px";
                            closeTag.style.right = "10px";

                            dataTag.style.bottom = "0px";
                            dataTag.style.right = "0px";

                            tagImg.style.overflow = "visible";
                            tagImg.style.width = img.offsetWidth + "px";
                            tagImg.style.left = ((sx - img.offsetWidth) / 2) + "px";
                        } else {
                            img.style.width = ix + "px";
                            img.style.height = iy + "px";
                            img.alt = "双击可以缩小";
                            img.onmousedown = dragDown;
                            tagImg.style.overflow = "auto";
                            tagImg.style.width = xx + "px";
                            tagImg.style.left = ((sx - xx) / 2) + "px";
                        }
                    }
                    img.onmousedown = dragDown;
                    tagImg.onmousemove = barHidden;
                    tagImg.onmouseout = moveStop;
                    document.onmouseup = moveStop;
                } else {
                    tagImg.style.overflow = "visible";
                    tagImg.onmousemove = barHidden;
                }
            }
            function dragDown(a) {
                img.style.cursor = "pointer";
                var evts = a || window.event;
                var onx = evts.clientX, ony = evts.clientY;
                var sox = tagImg.scrollLeft, soy = tagImg.scrollTop;
                var sow = img.width + 2 - tagImg.clientWidth, soh = img.height + 2 - tagImg.clientHeight;
                var xxleft, yytop;
                document.onmousemove = function (e) {
                    var evt = e || window.event;
                    xxleft = sox - (evt.clientX - onx) < 0 ? "0" : sox - (evt.clientX - onx) > sow ? sow : sox - (evt.clientX - onx);
                    yytop = soy - (evt.clientY - ony) < 0 ? "0" : soy - (evt.clientY - ony) > soh ? soh : soy - (evt.clientY - ony);

                    tagImg.scrollTop = yytop;
                    tagImg.scrollLeft = xxleft;
                    closeTag.style.top = (yytop + 10) + "px";
                    closeTag.style.right = (xxleft + 10) + "px";

                    dataTag.style.bottom = (yytop + 0) + "px";
                    dataTag.style.right = (xxleft + 0) + "px";

                    return false;
                }
                return false;
            }
            function barHidden() {
                clearTimeout(barShow);
                if (closeTag.style.display == "none") closeTag.style.display = "block";
                barShow = setTimeout(function () { closeTag.style.display = "none"; }, 2000);
            }
            function closes() {
                document.body.removeChild(tag);
                document.body.removeChild(tagImg);
                clearTimeout(barShow);
                clearTimeout(imgTime);
                document.onmouseup = null;
                tag = img = tagImg = closeTag = null;
                openBg(0);
            }
            function moveStop() {
                document.onmousemove = null;
                tagImg.onmousemove = barHidden;
                img.style.cursor = "default";
            }

        }

        function getTimes() {
            var now = new Date();
            var hours = now.getHours();
            if (hours > 8) {
                hours = hours - 8;
            } else {
                if (16 + hours < 24) {
                    hours = 16 + hours;
                } else {
                    hours = 0;
                }
            }

            return hours + '小时' + now.getMinutes() + '分';
        }

        var img1;
        var img2;
        var img3;

        function scanWin(fileUrl) {

            var width = screen.width - 150;
            var height = screen.height - 200;
            window.open(fileUrl, 'scanWin', 'height=' + height + ', width=' + width + ', top=0,  left=0, toolbar=no, menubar=no, scrollbars=yes, resizable=no,location=no, status=no');
        }

        //绘制坐标点
        function GetPoint() {

            //            if (yCount != 0) {
            //                map.clearOverlays();
            //                showLine();
            //            }

            if (yCount != 0 && yCount % 30 == 0) {
                map.clearOverlays();
                showLine();
            }

            //雨量站
            GDownloadUrl("GetData/getrainDataXml.aspx?id=" + Math.random(), function (data, responseCode) {

                if (data != null && data != "") {

                    var xml = GXml.parse(data);
                    var markers = xml.documentElement.getElementsByTagName("marker");

                    for (var i = 0; i < markers.length; i++) {

                        var pointx = markers[i].getAttribute("x") == "" ? 0 : parseFloat(markers[i].getAttribute("x"));
                        var pointy = markers[i].getAttribute("y") == "" ? 0 : parseFloat(markers[i].getAttribute("y"));
                        var stcdName = markers[i].getAttribute("stcdname");
                        var area = markers[i].getAttribute("area");
                        var name = markers[i].getAttribute("name");
                        var phone = markers[i].getAttribute("phone");
                        var drp = markers[i].getAttribute("drp");
                        if (drp == '' || drp == null) {
                            drp = '';
                        }
                        var raininfo = markers[i].getAttribute("rainInfo");
                        var sttp = markers[i].getAttribute("sttp");
                        var sTime = markers[i].getAttribute("sTime");
                        var eTime = markers[i].getAttribute("eTime");
                        var yName = markers[i].getAttribute("yName");
                        var yConnect = markers[i].getAttribute("yConnect");
                        var yFlag = markers[i].getAttribute("yFlag");
                        var stcd = markers[i].getAttribute("stcd");
                        var yId = markers[i].getAttribute("yId");
                        var state = markers[i].getAttribute("state");
                        var ifwarn = markers[i].getAttribute("ifwarn");
                        var RVNM = markers[i].getAttribute("RVNM");
                        var HNNM = markers[i].getAttribute("HNNM");
                        var BSNM = markers[i].getAttribute("BSNM");
                        var STLC = markers[i].getAttribute("STLC");
                        var ADMAUTH = markers[i].getAttribute("ADMAUTH");
                        var DRNA = markers[i].getAttribute("DRNA");
                        var grade = markers[i].getAttribute("grade");
                        var drpSum = markers[i].getAttribute("drpSum");
                        var yIconColor = markers[i].getAttribute("yIconColor");


                        img1 = markers[i].getAttribute("img");

                        var info;
                        var sumTime = getTimes();
                        var sumRain;
                        if (img1 == '') {
                            taImg = '<div style=width=350 height=320></div>';
                        } else {
                            taImg = "<img id='" + yId + "' name='" + yId + "' width=350 height=320 style='cursor:pointer;' onclick=ImgShow('0','" + img1 + "') src='" + img1 + "' />";
                        }
                        var point = new GLatLng(pointx, pointy);

                        var rInfo = '';
                        var rjudge = '';
                        if (grade != null && grade != '') {


                            if (state == '0') {
                                //                                if (ifwarn == '0') {
                                //                                    rjudge = '<br>雨量状态：超值&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;累计雨量：' + drp + 'mm<br>累计时间：' + getTimes() + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;超值：' + drpSum + 'mm<br>预警级别：' + grade + '级<br>预警时间：' + eTime;
                                //                                } else {
                                //                                if (grade == '2') {
                                //                                    rjudge = '<br><span style="color:#E98514;">雨量状态：超值</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;累计雨量：' + drp + 'mm<br>累计时间：' + getTimes() + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;超值：' + drpSum + 'mm<br>预警级别：' + grade + '级<br>预警时间：' + eTime;
                                //                                } else {
                                //                                    rjudge = '<br><span style="color:Red;">雨量状态：超值</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;累计雨量：' + drp + 'mm<br>累计时间：' + getTimes() + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;超值：' + drpSum + 'mm<br>预警级别：' + grade + '级<br>预警时间：' + eTime;
                                //                                }
                                //                                }
                                rjudge = '<br><span style="color:' + yIconColor + ';">雨量状态：超值</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;累计雨量：' + drp + 'mm<br>累计时间：' + getTimes() + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;超值：' + drpSum + 'mm<br>预警级别：' + grade + '级<br>预警时间：' + eTime;
                            } else {
                                var rainList = raininfo.split('|');
                                for (var count = 0; count < rainList.length - 1; count++) {

                                    //时段  累计雨量  超值  状态  
                                    var rain = rainList[count].split(',');
                                    if (rain[2] != '') {
                                        //                                        if (ifwarn == '0') {
                                        //                                            rjudge += '<br>雨量状态：' + rain[3] + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;累计雨量：' + rain[1] + 'mm<br>最近：' + rain[0] + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;超值：' + rain[2] + 'mm';
                                        //                                        }
                                        //                                        else {
                                        //                                        if (grade == '2') {
                                        //                                            rjudge += '<br><span style="color:#E98514;">雨量状态：' + rain[3] + '</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;累计雨量：' + rain[1] + 'mm<br>最近：' + rain[0] + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;超值：' + rain[2] + 'mm';
                                        //                                        } else {
                                        //                                            rjudge += '<br><span style="color:Red;">雨量状态：' + rain[3] + '</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;累计雨量：' + rain[1] + 'mm<br>最近：' + rain[0] + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;超值：' + rain[2] + 'mm';
                                        //                                        }
                                        rjudge += '<br><span style="color:' + yIconColor + ';">雨量状态：' + rain[3] + '</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;累计雨量：' + rain[1] + 'mm<br>最近：' + rain[0] + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;超值：' + rain[2] + 'mm';
                                        //                                        }
                                    } else {
                                        rjudge += '<br>雨量状态：' + rain[3] + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;累计雨量：' + rain[1] + 'mm<br>最近：' + rain[0];
                                    }
                                    rInfo += rjudge;
                                }

                                info = '<div style="font-size:12; color:Black; font-family:宋体;line-height:25px;">站点名称：' + stcdName + '<br>站类：雨量站<br>管理机构：' + ADMAUTH + '<br>所在经度：' + pointy + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;所在纬度：' + pointx + '<br>所属区域：' + area + '<br>所属流域：' + BSNM + '<br>所属水系：' + HNNM + '<br>所属河流：' + RVNM + rInfo + '<br>报汛人员：' + name + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;联系电话：' + phone + '<br>站址：' + STLC + '</div>';
                            }
                        } else {
                            rjudge = '<br>雨量状态：正常&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;累计雨量：' + drp + 'mm<br>最近：' + getTimes();
                        }

                        info = '<div style="font-size:12; color:Black; font-family:宋体;line-height:25px;">站点名称：' + stcdName + '<br>站类：雨量站<br>管理机构：' + ADMAUTH + '<br>所在经度：' + pointy + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;所在纬度：' + pointx + '<br>所属区域：' + area + '<br>所属流域：' + BSNM + '<br>所属水系：' + HNNM + '<br>所属河流：' + RVNM + '<br>集水量：' + DRNA + rjudge + '<br>报汛人员：' + name + '<br>联系电话：' + phone + '<br>站址：' + STLC + '</div>';


                        //判断是否已经快速处理
                        if (ifwarn == '0') {
                            WaterAlram(pointx, pointy, stcdName, info, taImg, '', yFlag, sttp, '', yIconColor);
                        } else {
                            WaterAlram(pointx, pointy, stcdName, info, taImg, '', yFlag, sttp, grade, yIconColor);
                        }

                        map.addOverlay(new google.maps.FocusMarker(new GLatLng(pointx, pointy), {//pointx + 0.005, pointy - 0.003
                            innerHtml: '<div class="style1">' + stcdName + '</div>'
                        }));
                    }

                } else {
                    alert('数据库里没有雨量站数据!');
                }
            });


            //河道站
            GDownloadUrl("GetData/getriverDataXml.aspx?id=" + Math.random(), function (data, responseCode) {

                if (data != null && data != "") {

                    var xml = GXml.parse(data);
                    var markers = xml.documentElement.getElementsByTagName("marker");
                    for (var i = 0; i < markers.length; i++) {

                        //预警状态   0：不预警  1：预警
                        var ifwarnRain = markers[i].getAttribute("ifwarnRain");
                        var ifwarnZ = markers[i].getAttribute("ifwarnZ");
                        var ifwarnQ = markers[i].getAttribute("ifwarnQ");

                        //图表状态
                        var RainFlag = markers[i].getAttribute("RainFlag");
                        var ZFlag = markers[i].getAttribute("ZFlag");
                        var QFlag = markers[i].getAttribute("QFlag");

                        var stcd = markers[i].getAttribute("stcd");
                        var stcdName = markers[i].getAttribute("stcdname");
                        var grade = markers[i].getAttribute("grade");
                        var pointx = markers[i].getAttribute("x") == "" ? 0 : parseFloat(markers[i].getAttribute("x"));
                        var pointy = markers[i].getAttribute("y") == "" ? 0 : parseFloat(markers[i].getAttribute("y"));
                        var RVNM = markers[i].getAttribute("RVNM");
                        var HNNM = markers[i].getAttribute("HNNM");
                        var BSNM = markers[i].getAttribute("BSNM");
                        var STLC = markers[i].getAttribute("STLC");
                        var ADMAUTH = markers[i].getAttribute("ADMAUTH");
                        var DRNA = markers[i].getAttribute("DRNA");
                        var sttp = "ZZ"; //markers[i].getAttribute("sttp");
                        var area = markers[i].getAttribute("area");
                        var name = markers[i].getAttribute("name");
                        var phone = markers[i].getAttribute("phone");

                        var raininfo = markers[i].getAttribute("raininfo");
                        var zinfo = markers[i].getAttribute("zinfo");
                        var qinfo = markers[i].getAttribute("qinfo");

                        var sTime = markers[i].getAttribute("sTime");
                        var eTime = markers[i].getAttribute("eTime");


                        var yRainIconColor = markers[i].getAttribute("yRainIconColor");
                        var yQWaterIconColor = markers[i].getAttribute("yQWaterIconColor");
                        var yZWaterIconColor = markers[i].getAttribute("yZWaterIconColor");

                        var info;
                        var sum;
                        img2 = markers[i].getAttribute("img");
                        if (img2 == '') {
                            taImg = '';
                        } else {

                            taImg = "<img id='" + stcd + "' name='" + stcd + "' width=350 height=320 style='cursor:pointer;' onclick=ImgShow('0','" + img2 + "') src='" + img2 + "' />";
                        }

                        var point = new GLatLng(pointx, pointy);

                        //河道信息
                        var ennmcd = markers[i].getAttribute("ennmcd");
                        var rvnm = markers[i].getAttribute("rvnm");
                        var rvpl = markers[i].getAttribute("rvpl");
                        var mnstln = markers[i].getAttribute("mnstln");
                        var ttdrbsar = markers[i].getAttribute("ttdrbsar");
                        var drbspp = markers[i].getAttribute("drbspp");
                        var mxsfds = markers[i].getAttribute("mxsfds");
                        var avtm = markers[i].getAttribute("avtm");

                        info = '<div style="font-size:12; color:Black; font-family:宋体;line-height:25px;">站点名称：' + stcdName + '<br>站类：河道站<br>管理机构：' + ADMAUTH + '<br>所在经度：' + pointy + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;所在纬度：' + pointx + '<br>所属区域：' + area + '<br>所属流域：' + BSNM + '<br>所属水系：' + HNNM + '<br>所属河流：' + RVNM + '<br>集水量：' + DRNA;

                        var zs = zinfo.split(',');
                        var qs = qinfo.split(',');

                        var grades;
                        var flag;
                        var judge; // 预警类型：  0：雨量预警  1：流量预警   2：水位预警
                        var warn;  //是否预警

                        flag = RainFlag;     //图表等级
                        //                        grades = grade;

                        var inf = '';
                        if (raininfo != '') {
                            var rs = raininfo.split('|');
                            for (var count = 0; count < rs.length - 1; count++) {
                                //时段  累计雨量  超值  状态  等级
                                var rain = rs[count].split(',');
                                if (rain[2] != '') {
                                    //                                    if (ifwarnRain == '0' || ifwarnRain == '') {
                                    //                                        inf += '<br>雨量状态：' + rain[3] + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;累计雨量：' + rain[1] + 'mm&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp <br>最近：' + rain[0] + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;超值：' + rain[2] + 'mm<br>预警等级：' + rain[4];
                                    //                                    } else {
                                    //                                    if (rain[4] == '2') {
                                    //                                        inf += '<br><span style="color:#E98514;">雨量状态：' + rain[3] + '</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;累计雨量：' + rain[1] + 'mm&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <br>最近：' + rain[0] + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;超值：' + rain[2] + 'mm<br>预警等级：' + rain[4];
                                    //                                    } else {
                                    //                                        inf += '<br><span style="color:Red;">雨量状态：' + rain[3] + '</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;累计雨量：' + rain[1] + 'mm&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<br>最近：' + rain[0] + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;超值：' + rain[2] + 'mm<br>预警等级：' + rain[4];
                                    //                                    }
                                    inf += '<br><span style="color:' + yRainIconColor + ';">雨量状态：' + rain[3] + '</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;累计雨量：' + rain[1] + 'mm&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<br>最近：' + rain[0] + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;超值：' + rain[2] + 'mm<br>预警等级：' + rain[4];
                                    //                                    }
                                } else {
                                    inf += '<br>雨量状态：正常&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;累计雨量：' + rain[1] + 'mm<br>最近：' + rain[0];
                                }

                                if (rs.length == 2) {
                                    if (rain[4] != '') {
                                        grades = rain[4];
                                    }
                                } else {
                                    if (count + 1 < rs.length) {
                                        if (Number(rs[count].split(',')[4]) < Number(rs[count + 1].split(',')[4])) {
                                            grades = rs[count + 1].split(',')[4];
                                        }
                                    }
                                }
                            }
                        }

                        info += inf;

                        if (grades == '') {
                            warn = '';
                        } else {
                            judge = 0;
                            warn = '1';
                        }
                        //累加预警信息 wjudge+=信息
                        if (zs[0] == '') {
                            warn = '';
                            wjudge = '<br>水位状态：正常&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;水位：' + zs[1] + 'm';
                        } else {
                            warn = '1';
                            if (ifwarnZ == '0') {
                                wjudge = '<br>水位状态：超警&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;超值：' + zs[2] + 'm<br>水位：' + zs[1] + 'm&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;预警级别：' + zs[0];
                            } else {
                                if (ifwarnRain == '') {
                                    grades = zs[0];
                                    flag = ZFlag;
                                    judge = 1;
                                } else {
                                    if (grades > Number(zs[0])) {
                                        grades = zs[0];
                                        flag = ZFlag;
                                        judge = 1;
                                    } else if (grades == Number(zs[0])) {
                                        if (ifwarnRain = '1' && ifwarnZ == '1') {
                                            flag = ZFlag;
                                            judge = 1;
                                        } else if (ifwarnRain = '1') {
                                            flag = RainFlag;
                                            judge = 0;
                                        } else {
                                            flag = ZFlag;
                                            judge = 1;
                                        }
                                    } else {
                                        judge = 0;
                                    }
                                }

                                //                                if (zs[0] == '2') {
                                //                                    wjudge = '<br><span style="color:#E98514;">水位状态：超警</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;水位：' + zs[1] + 'm<br>超值：' + zs[2] + 'm&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;预警级别：' + zs[0];
                                //                                } else {
                                //                                    wjudge = '<br><span style="color:Red;">水位状态：超警</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;水位：' + zs[1] + 'm<br>超值：' + zs[2] + 'm&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;预警级别：' + zs[0];
                                //                                }
                                wjudge = '<br><span style="color:' + yZWaterIconColor + ';">水位状态：超警</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;水位：' + zs[1] + 'm<br>超值：' + zs[2] + 'm&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;预警级别：' + zs[0];
                            }
                        }

                        info += wjudge + '<br>报汛人员：' + name + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;联系电话：' + phone + '<br>站址：' + STLC + '</div>';

                        var tbInfo = "<table border='1' cellpadding='0' cellspacing='0' width='380px' height='320px' style='font-size:12px'><tr><td valign='middle' align='left' >站点名称</td><td valign='middle' align='left' width='110px'>&nbsp;" + stcdName + "</td><td valign='middle' align='left'>河流名称</td><td valign='middle' align='left' width='110px'>&nbsp;" + rvnm + "&nbsp;</a></td></tr><tr><td valign='middle' align='left'>河流长度</td><td valign='middle' align='left'>&nbsp;" + mnstln + "</td><td valign='middle' align='left'>流域面积</td><td valign='middle' align='left'>&nbsp;" + ttdrbsar + "</td></tr><tr><td valign='middle' align='left' width='110px'>流域内人口数</td><td valign='middle' align='left'>&nbsp;" + drbspp + "</td><td valign='middle' align='left' width='120px'>洪水最大安全泄量</td><td valign='middle' align='left'>&nbsp;" + mxsfds + "</td></tr> <tr><td valign='middle' colspan='2' align='left' width='110px'>洪水平均传播时间</td><td valign='middle' align='left' colspan='2'>&nbsp;" + avtm + "</td></tr><tr><td valign='middle' colspan='6' align='center' onclick=\"scanWin('../jichuxinxi/gongqing/RiverInfo.aspx?id=" + encodeURIComponent(ennmcd) + "&type=0');\" >详&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;细&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;信&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;息" + "" + "</td></tr></table>";
                        //是否预警
                        if (warn != '') {
                            //预警类型
                            if (judge == 0) {
                                WaterAlram(pointx, pointy, stcdName, info, taImg, tbInfo, RainFlag, sttp, grades, yRainIconColor);
                            } else {
                                WaterAlram(pointx, pointy, stcdName, info, taImg, tbInfo, ZFlag, sttp, grades, yZWaterIconColor);
                            }
                        } else {
                            WaterAlram(pointx, pointy, stcdName, info, taImg, tbInfo, flag, sttp, grades, "");
                        }
                        //设置标注名称
                        map.addOverlay(new google.maps.FocusMarker(new GLatLng(pointx, pointy), {//pointx + 0.005, pointy - 0.003
                            innerHtml: '<div class="style1">' + stcdName + '</div>'
                        }));
                    }

                } else {
                    alert('数据库里没有河道站数据!');
                }
            });

            //水库站
            GDownloadUrl("GetData/getwaterDataXml.aspx?id=" + Math.random(), function (data, responseCode) {

                if (data != null && data != "") {

                    var xml = GXml.parse(data);
                    var markers = xml.documentElement.getElementsByTagName("marker");

                    for (var i = 0; i < markers.length; i++) {

                        //预警状态   0：不预警  1：预警
                        var ifwarnRain = markers[i].getAttribute("ifwarnRain");
                        var ifwarnZ = markers[i].getAttribute("ifwarnZ");
                        var ifwarnQ = markers[i].getAttribute("ifwarnQ");

                        //图表状态
                        var RainFlag = markers[i].getAttribute("RainFlag");
                        var ZFlag = markers[i].getAttribute("ZFlag");
                        var QFlag = markers[i].getAttribute("QFlag");

                        var stcd = markers[i].getAttribute("stcd");
                        var stcdName = markers[i].getAttribute("stcdname");
                        var grade = markers[i].getAttribute("grade");
                        var pointx = markers[i].getAttribute("x") == "" ? 0 : parseFloat(markers[i].getAttribute("x"));
                        var pointy = markers[i].getAttribute("y") == "" ? 0 : parseFloat(markers[i].getAttribute("y"));
                        var RVNM = markers[i].getAttribute("RVNM");
                        var HNNM = markers[i].getAttribute("HNNM");
                        var BSNM = markers[i].getAttribute("BSNM");
                        var STLC = markers[i].getAttribute("STLC");
                        var ADMAUTH = markers[i].getAttribute("ADMAUTH");
                        var DRNA = markers[i].getAttribute("DRNA");
                        var sttp = "RR"; //markers[i].getAttribute("sttp");
                        var area = markers[i].getAttribute("area");
                        var name = markers[i].getAttribute("name");
                        var phone = markers[i].getAttribute("phone");

                        var raininfo = markers[i].getAttribute("raininfo");
                        var zinfo = markers[i].getAttribute("zinfo");
                        var qinfo = markers[i].getAttribute("qinfo");

                        var sTime = markers[i].getAttribute("sTime");
                        var eTime = markers[i].getAttribute("eTime");

                        //水库信息
                        var ennmcd = markers[i].getAttribute("ennmcd");
                        var rname = markers[i].getAttribute("rname");
                        var dmstatpl = markers[i].getAttribute("dmstatpl");
                        var rvnm = markers[i].getAttribute("rvnm");
                        var SupeAdun = markers[i].getAttribute("SupeAdun");
                        var Engsdate = markers[i].getAttribute("Engsdate");
                        var Drbsar = markers[i].getAttribute("Drbsar");
                        var Xhst = markers[i].getAttribute("Xhst");
                        var Dsfllv = markers[i].getAttribute("Dsfllv");
                        var Nrwtlv = markers[i].getAttribute("Nrwtlv");
                        var Flz = markers[i].getAttribute("Flz");
                        var Flzst = markers[i].getAttribute("Flzst");
                        var Dmtp = markers[i].getAttribute("Dmtp");
                        var Dmtpln = markers[i].getAttribute("Dmtpln");
                        var mxdmhg = markers[i].getAttribute("mxdmhg");
                        var YhdyDmtpwd = markers[i].getAttribute("YhdyDmtpwd");
                        var FlDS = markers[i].getAttribute("FlDS");
                        var dscndtpy = markers[i].getAttribute("dscndtpy");
                        var inbtcgel = markers[i].getAttribute("inbtcgel");
                        var mxdsy = markers[i].getAttribute("mxdsy");
                        var FlCh = markers[i].getAttribute("FlCh");
                        var FlAc = markers[i].getAttribute("FlAc");
                        var XlllDsfllv = markers[i].getAttribute("XlllDsfllv");
                        var xlllChfllv = markers[i].getAttribute("xlllChfllv");
                        var Dwcnstds = markers[i].getAttribute("Dwcnstds");
                        var Power = markers[i].getAttribute("Power");
                        var Safetm = markers[i].getAttribute("Safetm");
                        var Safegrade = markers[i].getAttribute("Safegrade");
                        var Safefiles = markers[i].getAttribute("Safefiles");
                        var Dwysqn = markers[i].getAttribute("Dwysqn");
                        var Xyyjsd = markers[i].getAttribute("Xyyjsd");


                        var yRainIconColor = markers[i].getAttribute("yRainIconColor");
                        var yQWaterIconColor = markers[i].getAttribute("yQWaterIconColor");
                        var yZWaterIconColor = markers[i].getAttribute("yZWaterIconColor");



                        img3 = markers[i].getAttribute("img");

                        if (img3 == '') {
                            taImg = '';
                        } else {
                            taImg = "<img id='" + stcd + "' name='" + stcd + "' width=370 height=320 style='cursor:pointer;' onclick=ImgShow('0','" + img3 + "') src='" + img3 + "' />";
                        }
                        var WaterInfo = "<div id='isWarn_div' style='top:-10px;width:580px; height:420px;' class='isWarn_div'><table border='1' cellpadding='0' cellspacing='0' width='580px' height='420px' style='font-size:12px'><tr><td valign='middle' align='left' onclick=\"scanWin('../jichuxinxi/gongqing/ReservoirInfo.aspx?id=" + ennmcd + " ')\" >站点名称</td><td valign='middle' align='left' width='110px'>&nbsp;" + stcdName + "</td><td valign='middle' align='left'>水库名称</td><td valign='middle' align='left' width='110px'>&nbsp;" + rname + "</a></td><td valign='middle' align='left'>水库位置</td><td valign='middle' align='left'>&nbsp;" + dmstatpl + "</td></tr><tr><td valign='middle' align='left'>所在河流</td><td valign='middle' align='left'>&nbsp;" + rvnm + "</td><td valign='middle' align='left'>管理单位</td><td valign='middle' align='left'>&nbsp;" + SupeAdun + "</td><td valign='middle' align='left'>建设年份</td><td valign='middle' align='left'>&nbsp;" + Engsdate + "</td></tr><tr><td valign='middle' align='left'>集水面积</td><td valign='middle' align='left'>&nbsp;" + Drbsar + "</td><td valign='middle' align='left'>总库容</td><td valign='middle' align='left'>&nbsp;" + Xhst + "</td><td valign='middle' align='left'>设计洪水位</td><td valign='middle' align='left'>&nbsp;" + Dsfllv + "</td></tr> <tr><td valign='middle' align='left'>正常蓄水位</td><td valign='middle' align='left'>&nbsp;" + Nrwtlv + "</td><td valign='middle' align='left'>汛限水位</td><td valign='middle' align='left'>&nbsp;" + Flz + "</td><td valign='middle' align='left'>汛限库容</td><td valign='middle' align='left'>&nbsp;" + Flzst + "</td> </tr> <tr><td valign='middle' align='left'>坝体类型</td><td valign='middle' align='left'>&nbsp;" + Dmtp + "</td><td valign='middle' align='left'>坝长</td><td valign='middle' align='left'>&nbsp;" + Dmtpln + "</td><td valign='middle' align='left'>坝高</td><td valign='middle' align='left'>&nbsp;" + mxdmhg + "</td> </tr> <tr><td valign='middle' align='left'>坝顶高程</td><td valign='middle' align='left'>&nbsp;" + YhdyDmtpwd + "</td><td valign='middle' align='left'>设计洪水频率</td><td valign='middle' align='left'>&nbsp;" + FlDS + "</td><td valign='middle' align='left'>溢洪道型式</td><td valign='middle' align='left'>&nbsp;" + dscndtpy + "</td> </tr> <tr><td valign='middle' align='left'>溢洪道底高程</td><td valign='middle' align='left'>&nbsp;" + inbtcgel + "</td><td valign='middle' align='left' width='100px'>溢洪道最大泄量</td><td valign='middle' align='left'>&nbsp;" + mxdsy + "</td><td valign='middle' align='left'>校核洪水频率</td><td valign='middle' align='left'>&nbsp;" + FlCh + "</td> </tr> <tr><td valign='middle' align='left'>现状洪水频率</td><td valign='middle' align='left'>&nbsp;" + FlAc + "</td><td valign='middle' align='left'>设计泄流能力</td><td valign='middle' align='left'>&nbsp;" + XlllDsfllv + "</td><td valign='middle' align='left'>校核泄流能力</td><td valign='middle' align='left'>&nbsp;" + xlllChfllv + "</td> </tr> <tr><td valign='middle' align='left'>安全泄流能力</td><td valign='middle' align='left'>&nbsp;" + Dwcnstds + "</td><td valign='middle' align='left'>调度主管部门</td><td valign='middle' align='left'>&nbsp;" + Power + "</td><td valign='middle' align='left'>近期安全鉴定日期</td><td valign='middle' align='left'>&nbsp;" + Safetm + "</td> </tr> <tr><td valign='middle' align='left'>安全类别</td><td valign='middle' align='left'>&nbsp;" + Safegrade + "</td><td valign='middle' align='left'>水库病险情况</td><td valign='middle' align='left'>&nbsp;" + Safefiles + "</td><td valign='middle' align='left' width='110px'>影响社会经济指标</td><td valign='middle' align='left' width='110px'>&nbsp;" + Dwysqn + "</td></tr><tr><td valign='middle' align='left' width='85px'>预警设施手段</td><td valign='middle' colspan='3' align='left'>&nbsp;" + Xyyjsd + "</td><td align='center' valign='middle'' onclick=\"document.getElementById('isWarn_div').style.display='none';document.getElementById('isWarn_hide').style.display='none';\"' colspan='2'>关&nbsp;&nbsp;&nbsp;&nbsp;闭</td></tr></table></div><div id='isWarn_hide' class='isWarn_hide'></div>";


                        var tbInfo = WaterInfo + "<table border='1' cellpadding='0' cellspacing='0' width='380px' height='320px' style='font-size:12px'><tr><td valign='middle' align='left' >站点名称</td><td valign='middle' align='left' width='110px'>&nbsp;" + stcdName + "</td><td valign='middle' align='left'>水库名称</td><td valign='middle' align='left' width='110px'>&nbsp;" + rname + "</a></td></tr><tr><td valign='middle' align='left'>所在河流</td><td valign='middle' align='left'>&nbsp;" + rvnm + "</td><td valign='middle' align='left'>管理单位</td><td valign='middle' align='left'>&nbsp;" + SupeAdun + "</td></tr><tr><td valign='middle' align='left'>集水面积</td><td valign='middle' align='left'>&nbsp;" + Drbsar + "</td><td valign='middle' align='left'>总库容</td><td valign='middle' align='left'>&nbsp;" + Xhst + "</td></tr> <tr><td valign='middle' align='left'>正常蓄水位</td><td valign='middle' align='left'>&nbsp;" + Nrwtlv + "</td><td valign='middle' align='left'>汛限水位</td><td valign='middle' align='left'>&nbsp;" + Flz + "</td></tr> <tr><td valign='middle' align='left'>汛限库容</td><td valign='middle' align='left'>&nbsp;" + Flzst + "</td><td valign='middle' align='left'>坝长</td><td valign='middle' align='left'>&nbsp;" + Dmtpln + "</td></tr> <tr><td valign='middle' align='left'>坝顶高程</td><td valign='middle' align='left'>&nbsp;" + YhdyDmtpwd + "</td><td valign='middle' align='left'>设计洪水频率</td><td valign='middle' align='left'>&nbsp;" + FlDS + "</td></tr> <tr><td valign='middle' align='left'>溢洪道底高程</td><td valign='middle' align='left'>&nbsp;" + inbtcgel + "</td><td valign='middle' align='left'>设计泄流能力</td><td valign='middle' align='left'>&nbsp;" + XlllDsfllv + "</td></tr> <tr><td valign='middle' align='left' width='100px'>校核泄流能力</td><td valign='middle' align='left'>&nbsp;" + xlllChfllv + "</td><td valign='middle' align='left' width='100px'>安全泄流能力</td><td valign='middle' align='left'>&nbsp;" + Dwcnstds + "</td></tr><tr><td valign='middle' colspan='6' align='center' onclick=\"scanWin('../jichuxinxi/gongqing/ReservoirInfo.aspx?id=" + ennmcd + "&type=0');\" >详&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;细&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;信&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;息" + "" + "</td></tr></table>";

                        info = '<div style="font-size:12; color:Black; font-family:宋体;line-height:25px;">站点名称：' + stcdName + '<br>站类：水库站<br>管理机构：' + ADMAUTH + '<br>所在经度：' + pointy + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;所在纬度：' + pointx + '<br>所属区域：' + area + '<br>所属流域：' + BSNM + '<br>所属水系：' + HNNM + '<br>所属河流：' + RVNM + '<br>集水量：' + DRNA;

                        var zs = zinfo.split(',');
                        var qs = qinfo.split(',');

                        var grades;
                        var flag;
                        var judge; // 预警类型：  0：雨量预警  1：流量预警   2：水位预警
                        var warn;  //是否预警

                        flag = RainFlag;     //图表等级

                        grades = grade;

                        var inf = '';
                        if (raininfo != '') {
                            var rs = raininfo.split('|');
                            for (var count = 0; count < rs.length - 1; count++) {
                                //时段  累计雨量  超值  状态  等级
                                var rain = rs[count].split(',');
                                if (rain[2] != '') {
                                    //                                    if (ifwarnRain == '0' || ifwarnRain == '') {
                                    //                                        inf += '<br>雨量状态：' + rain[3] + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 累计雨量：' + rain[1] + 'mm&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <br>最近：' + rain[0] + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;超值：' + rain[2] + 'mm<br>预警等级：' + rain[4];
                                    //                                    } else {
                                    //                                    if (rain[4] == '2') {
                                    //                                        inf += '<br><span style="color:#E98514;">雨量状态：' + rain[3] + '</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 累计雨量：' + rain[1] + 'mm&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <br>最近：' + rain[0] + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;超值：' + rain[2] + 'mm<br>预警等级：' + rain[4];
                                    //                                    } else {
                                    //                                        inf += '<br><span style="color:Red;">雨量状态：' + rain[3] + '</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 累计雨量：' + rain[1] + 'mm&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <br>最近：' + rain[0] + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;超值：' + rain[2] + 'mm<br>预警等级：' + rain[4];
                                    //                                    }
                                    inf += '<br><span style="color:' + yRainIconColor + ';">雨量状态：' + rain[3] + '</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 累计雨量：' + rain[1] + 'mm&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <br>最近：' + rain[0] + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;超值：' + rain[2] + 'mm<br>预警等级：' + rain[4];
                                    //                                    }
                                } else {
                                    inf += '<br>雨量状态：正常&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;累计雨量：' + rain[1] + 'mm<br>最近：' + rain[0];
                                }

                                if (rs.length == 2) {
                                    if (rain[4] != '') {
                                        grades = rain[4];
                                    }
                                } else {
                                    if (count + 1 < rs.length) {
                                        if (Number(rs[count].split(',')[4]) < Number(rs[count + 1].split(',')[4])) {
                                            grades = rs[count + 1].split(',')[4];
                                        }
                                    }
                                }
                            }
                        }
                        info += inf;

                        if (grades == '') {
                            warn = '';
                        } else {
                            judge = 0;
                            warn = '1';
                        }

                        //累加预警信息 wjudge+=信息
                        if (zs[0] == '') {
                            warn = '';
                            wjudge = '<br>水位状态：正常&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;水位：' + zs[1] + 'm';
                        } else {
                            warn = '1';
                            if (ifwarnRain == '') {
                                grades = zs[0];
                                flag = ZFlag;
                                judge = 1;
                            } else {
                                if (grades > Number(zs[0])) {
                                    grades = zs[0];
                                    flag = ZFlag;
                                    judge = 1;
                                } else if (grades == Number(zs[0])) {
                                    if (ifwarnRain = '1' && ifwarnZ == '1') {
                                        flag = ZFlag;
                                        judge = 1;
                                    } else if (ifwarnRain = '1') {
                                        flag = RainFlag;
                                        judge = 0;
                                    } else {
                                        flag = ZFlag;
                                        judge = 1;
                                    }
                                } else {
                                    judge = 0;
                                }
                            }

                            //                            if (ifwarnZ == '0') {
                            //                                wjudge = '<br>水位状态：超警&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;水位：' + zs[1] + 'm<br>超值：' + zs[2] + 'm&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;预警级别：' + zs[0];
                            //                            } else {
                            //                            if (zs[0] == '2') {
                            //                                wjudge = '<br><span style="color:#E98514;">水位状态：超警</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;水位：' + zs[1] + 'm<br>超值：' + zs[2] + 'm&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;预警级别：' + zs[0];
                            //                            } else {
                            //                                wjudge = '<br><span style="color:Red;">水位状态：超警</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;水位：' + zs[1] + 'm<br>超值：' + zs[2] + 'm&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;预警级别：' + zs[0];
                            //                            }
                            //                            }
                            wjudge = '<br><span style="color:' + yZWaterIconColor + ';">水位状态：超警</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;水位：' + zs[1] + 'm<br>超值：' + zs[2] + 'm&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;预警级别：' + zs[0];
                        }
                        info += wjudge + '<br>报汛人员：' + name + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;联系电话：' + phone + '<br>站址：' + STLC + '</div>';

                        //是否预警
                        if (warn != '') {
                            //预警类型
                            if (judge == 0) {
                                WaterAlram(pointx, pointy, stcdName, info, taImg, tbInfo, RainFlag, sttp, grades, yRainIconColor);
                            } else {
                                WaterAlram(pointx, pointy, stcdName, info, taImg, tbInfo, ZFlag, sttp, grades, yZWaterIconColor);
                            }
                        } else {
                            WaterAlram(pointx, pointy, stcdName, info, taImg, tbInfo, flag, sttp, grade, "");
                        }
                        //设置标注名称
                        map.addOverlay(new google.maps.FocusMarker(new GLatLng(pointx, pointy), {//pointx + 0.005, pointy - 0.003
                            innerHtml: '<div class="style1">' + stcdName + '</div>'
                        }));

                    } //循环结束

                } else {
                    alert('数据库里没有雨量站数据!');
                }
            });

            //            //延时调用
            //            setTimeout("GetPoint()", 200000);
            //            yCount++;


            var timeValue = 30;
            //延时调用
            //            $.post("GoogleMap.aspx", { param: 'getTime' }, function(res) {
            //                timeValue = res;
            //            });
            setTimeout("GetPoint()", timeValue * 1000);
            yCount++;
        }

        function WaterAlram(pointx, pointy, stcdName, info, tbImg, tbInfo, yFlag, sttp, judge, color) {
            var myIcon;
            if (judge != '') {
                if (yFlag == '0') {
                    myIcon = yuJing11Icon(color);
                } else if (yFlag == '10') {
                    myIcon = yuJing110Icon(color);
                } else if (yFlag == '20') {
                    myIcon = yuJing120Icon(color);
                } else if (yFlag == '30') {
                    myIcon = yuJing130Icon(color);
                } else if (yFlag == '40') {
                    myIcon = yuJing140Icon(color);
                } else {
                    if (sttp.substring(0, 2) == "RR") {
                        myIcon = WaterRainImg();
                    } else if (sttp.substring(0, 2) == "ZZ") {

                        myIcon = WaterRainImg();
                    } else {
                        myIcon = RainIcon();
                    }
                }
            } else {
                if (sttp.substring(0, 2) == "RR") {
                    myIcon = WaterRainImg();
                } else if (sttp.substring(0, 2) == "ZZ") {
                    myIcon = RiverRainIcon();
                } else {
                    myIcon = RainIcon();
                }
            }
            CreatePointInfo(pointx, pointy, myIcon, stcdName, info, tbImg, '', '', sttp, tbInfo);
        }

        function showLine() {
            var posts = new Array();
            $.getJSON("file/GoogleJsonStr.json", function (data) {
                $.each(data, function (entryIndex, entry) {
                    posts.push(new GLatLng(entry["y"], entry["x"]));
                });
                map.addOverlay(new GPolyline(posts, "#FF00CC", 2));
            });

            //            var posts = new Array();
            //            var points1 = new Array();
            //            for (var i = 0; i < posts.length; i++) {
            //                points1.push(new GLatLng(posts[i][1], posts[i][0]));
            //            }
            //            map.addOverlay(new GPolyline(points1, "#FF00CC", 2));
        }

        function init() {


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
                //map.addControl(new GSmallMapControl());
                map.addControl(new GMapTypeControl());
                //位于左上角
                var topLeft = new GControlPosition(G_ANCHOR_TOP_LEFT, new GSize(10, 10));
                //添加地址导航控件
                map.addControl(new GNavLabelControl(), topLeft);
                //                GetPoint();
                // Creates a marker at the given point with the given number label
                //                showLine();

            }
            //            });
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
            $("#map_canvas").height(screen.height - 175);
        }

    </script>
</head>
<body>
    <div class="wenchua" id="wenchuan" style="position: absolute; left: 0; top: 0;">
    </div>
    <div id="map_canvas" style="width: 100%; height: 100%;">
    </div>
    <div id="message" class="style1">
    </div>
    <div id="dvShow">
    </div>
    <div id="baseInfoWin" visible="false">
    </div>
</body>
</html>
