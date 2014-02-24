<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CZInfo.aspx.cs" Inherits="SACSIS.WebForm1" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script src="../Js/jquery-1.8.2.min.js" type="text/javascript"></script>
    <script src="../Js/jquery.easyui.min.js" type="text/javascript"></script>
    <link href="../Js/jQueryEasyUI/themes/default/easyui.css" rel="stylesheet" type="text/css" />
    <link href="../Js/jQueryEasyUI/themes/icon.css" rel="stylesheet" type="text/css" />

    <script type="text/javascript" language="javascript">
        $(function () {

            load();
            var int = self.setInterval("load()", 30000);
        });


        function load() {
            $.ajax({
                url: "CZInfo.aspx?funCode=init",
                type: "POST",
                beforeSend: function () {
                    //Handle the beforeSend event
                },
                success: function (json) {
                    //json = eval("("+json+")");
                    var json = $.parseJSON(json);
                    $("#tabId").empty();
                    $("#tabId").append(json.data);
                    $("#loading").hide();

                    var cll = json.cll;
                    var ywcl = json.ywcl;
                    var nwcl = json.nwcl;
                    var jzgzl = json.jzgzl;
                    for (var i = 0; i < cll.length; i++) {
                        $("#cll_" + i).progressbar({
                            value: cll[i]
                        })
                    };
                    for (var i = 0; i < ywcl.length; i++) {
                        $("#ywcl_" + i).progressbar({
                            value: ywcl[i]
                        })
                    };
                    for (var i = 0; i < nwcl.length; i++) {
                        $("#nwcl_" + i).progressbar({
                            value: nwcl[i]
                        })
                    };
                    //                    for (var i = 0; i < jzgzl.length; i++) {
                    //                        $("#jzgzl_" + i).progressbar({
                    //                            value: jzgzl[i]
                    //                        })
                    //                    };

                    //默认收缩二级单位
                    $('#tabId tr').each(function (i, o) {
                        HidenShowTr(o);
                    });

                    var zrl = json.zrl;
                    var zgl = json.zgl;
                    var zrdl = json.zrdl;
                    var zydl = json.zydl;
                    var zndl = json.zndl;
                    $("#Div1").html("装机容量:" + zrl + "MW");
                    $("#Div2").html("有功功率:" + zgl + "MW");
                    $("#Div3").html("日发电量:" + zrdl + "万kWh");
                    $("#Div4").html("月发电量:" + zydl + "万kWh");
                    $("#Div5").html("年发电量:" + zndl + "万kWh");

                },
                error: function (x, e) {
                    alert(x.responseText);
                },
                complete: function () {
                    //Handle the complete event
                }
            });
        
        }

        //二级单位隐藏显示切换
        function HidenShowTr(obj) {
            var T_ORGID = obj.getAttribute("T_ORGID");
            var trs = $("tr[T_ORGID='" + T_ORGID + "']");
            //隐藏二级行
            trs.each(function (i, o) {
                if (o.getAttribute("T_PERIODID") != "") {
                    if (o.getAttribute("style") == "display:inline;")
                        o.setAttribute("style", "display:none;");
                    else
                        o.setAttribute("style", "display:inline;");
                }
            });

            //切换图标
            var img = $("#" + T_ORGID + "_img");
            if (img.attr("src") == "../img/bg09.png") {
                if (trs.length > 1)//没有二级时，不切换图标
                    img.attr("src", "../img/bg10.png");
            }
            else
                img.attr("src", "../img/bg09.png");
        }

//        //鼠标悬停
//        function MouseAct(obj, opt) {
//            if (opt == 1)
//                $(obj).addClass("over");
//            else
//                $(obj).removeClass("out");
//        }

//        //打印
//        function Print() {
//            var aaa = document.all.tabId.innerHTML; // document.all.dvShow.innerHTML;
//            var ddd = document.body.innerHTML;
//            document.body.innerHTML = aaa;
//            window.print();
//            document.body.innerHTML = ddd;
//            return false;
//        }

    </script>

    <style type="text/css">
    table td
    {
        border-width: 1px;
	    border-style: solid;
	    border-color: #666666;
	    background-color: #ffffff;
	    text-align:center;
	}

    table
    {
        font-size:13px;
	    color:#333333;
	    border-width: 1px;
	    border-color: #666666;
	    border-collapse: collapse;
	}
	
    .over 
    {
    	cursor:hand;
    }
    	
    .out 
    {
    	cursor:hand;
    }
    </style>
</head>
<body>
    <form id="form1">
    <div style="width:1000px; border:1px">
        <div id="Div1" style="width: 20%; float: left; text-align:left">
            
        </div>
        <div id="Div2" style="width: 20%; float: left; text-align:left">
             
        </div>
        <div id="Div3" style="width: 20%; float: left; text-align:center">
             
        </div>
        <div id="Div4" style="width: 20%; float: left; text-align:right">
            
        </div>
        <div id="Div5" style="width: 20%; float: left; text-align:right">
             
        </div>
    </div>
   <%-- <a id="btnPrint" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-ok'" onclick="Print()">打&nbsp;&nbsp;印</a>--%>
    <div id="tabId" style=" width:100%; ">
    <div id="loading" style="margin-top: 150px; text-align: center;">
            <img src="../img/loading.gif" alt="" /><br />
            正在加载，请稍后... ...
        </div>
    </div>
    </form>
</body>
</html>
