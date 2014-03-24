using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using SAC.DBOperations;
using BLL;
using System.Collections;
using System.Text;
using BLL.Connect;

namespace SACSIS.Connect
{
    public partial class FDConnect : System.Web.UI.Page
    {
        DBLink dl = new DBLink();
        PointBLL pbll = new PointBLL();
        //FormBLL fb = new FormBLL();
        BLLConnect bc = new BLLConnect();
        //从T_INFO_VALUE中取值（2014.3.24）
        PointsBLL pbsll = new PointsBLL();

        string errMsg = string.Empty;
        public  string url = string.Empty;

        protected void Page_Load(object sender, EventArgs e)
        {
            //根据跳转过来的类型 来进行显示图像及内容
            //纵向：总的-区域-电站-机组  横向：标题（公用）  数据（公用）  图（四个）  数据表格（拼接公用）（带跳转到本页的下一级别（纵向））
            //表示纵向的等级类型 1总的 以此类推
            string type ="1";
            //从风电图标跳转过来
            string tag = string.Empty;
            //标题
            string name =string.Empty;//(或各区域)
            //区域名
            string area = string.Empty;
            //场站名
            string periodName = string.Empty;
            //机组id
            string idKey = string.Empty;
            if (!string.IsNullOrEmpty(Request["tag"]))
            {
                tag = Request["tag"].ToString();
                if (Session["tag"] == null)
                {
                    Session["tag"] = tag;
                }
            }
            if (!string.IsNullOrEmpty(Request["type"]))
            {
                type = Request["type"].ToString();
                if (Session["type"] == null)
                {
                    Session["type"] = type;
                }
            }
            if (!string.IsNullOrEmpty(Request["area"]))
            {
                area = Request["area"].ToString();
                if (Session["area"] == null)
                {
                    Session["area"] =  area;
                }
            }
            if (!string.IsNullOrEmpty(Request["periodName"]))
            {
                periodName = Request["periodName"].ToString();
                if (Session["periodName"] == null)
                {
                    Session["periodName"] = periodName;
                }
            }
            if (!string.IsNullOrEmpty(Request["idKey"]))
            {
                idKey = Request["idKey"].ToString();
            }
            //返回路径
            url = Request.UrlReferrer.AbsoluteUri;
            string para = Request["para"];
            if (!string.IsNullOrEmpty(para))
            {
                if (para == "search")
                {
                    Initialize(Session["type"] == null ? type : Session["type"].ToString(), Session["area"] == null ? area : Session["area"].ToString(), Session["periodName"] == null ? periodName : Session["periodName"].ToString(), name);
                    
                }
                if (para == "unit")
                {
                    BackContent(idKey);
                }
            }
            if (!string.IsNullOrEmpty(tag))
            {
                //从别的页面跳转过来，不带tag的是本页面刷新
                //Page.ClientScript.RegisterStartupScript(this.GetType(), "load", "inite('1','','')", true);
            }

            if (!IsPostBack)
            {
                // Request.Url.AbsoluteUrl
            }
        }

        /// <summary>
        /// 点击机组 返回机组信息
        /// </summary>
        /// <param name="idKey">T_INFO_UNIT唯一ID</param>
        public void BackContent(string idKey)
        { 
          //返回机组的内容
            DataTable dt = new DataTable();
            dt = bc.GetUnitMonitor(idKey);
            if (dt != null && dt.Rows.Count > 0)
            {
                foreach (DataRow r in dt.Rows)
                {
                    IList<Hashtable> list = new List<Hashtable>();
                    Hashtable ht = new Hashtable();
                    string desc = r["PERIOD_NAME"].ToString() + "#" + r["UNIT_ID"].ToString();
                    string windTag = r["T_WINDTAG"].ToString();
                    windTag += "|风速";
                    string powerTag = r["UNIT_GL_TAG"].ToString();
                    powerTag += "|负荷";
                    string[] Param = new string[2];
                    Param[0] = powerTag;
                    Param[1] = windTag;
                    list = pbll.GetHistValAndTIme3(Param, DateTime.Today.Date, DateTime.Now, 50);
                    ArrayList list1 = new ArrayList();
                    string[] str2 = new string[9] { "#058DC7", "#50B432", "#ED561B", "#DDDF00", "#24CBE5", "#64E572", "#FF9655", "#FFF263", "#6AF9C4" };
                    int num1 = 0;
                    foreach (Hashtable _ht in list)
                    {
                        ArrayList _data = (ArrayList)_ht["data"];
                        Hashtable _dv1 = new Hashtable();
                        _dv1.Add("lineColor", str2[num1]);

                        _dv1.Add("maxPadding", "1");
                        
                        Hashtable hy1 = new Hashtable();
                        Hashtable hy2 = new Hashtable();


                        if (num1 == 1)
                        {
                            _dv1.Add("opposite", true);//Y轴右端显示
                            hy2.Add("text", "（S/M)速风");

                            _dv1.Add("title", hy2);
                        }
                        else if (num1 == 0)
                        {
                            hy1.Add("text", "负荷(万千瓦)");
                            _dv1.Add("title", hy1);
                        }
                    
                        _dv1.Add("lineWidth", 1);
                        if (num1 != 2)
                        {
                            list1.Add(_dv1);
                        }
                        num1++;

                    }
                    object obj = new
                    {
                        title = desc + " 风速、负荷实时趋势",
                        y_data = list1,
                        list = list
                    };
                    string result = Newtonsoft.Json.JsonConvert.SerializeObject(obj);
                    Response.Write(result);
                    Response.End();
                }
            }
        }
        /// <summary>
        /// 初始化数据
        /// </summary>
        public void Initialize(string type, string area, string periodName, string name)
        {
            //在输出结果之前 重置，防止本页使用原来的session
            Session["type"] = null;
            Session["area"] = null;
            Session["periodName"] = null;

            //标题
            
            //风电或场站总负荷（取场站或机组的功率值之和）
            double FDFH = GetFDFHValueByTime(area, periodName, DateTime.Now.ToString("yyyy-MM-dd HH:mm:00"));
            //风电或场站日发电量（取场站或机组的日发电量之和）
            double FDDDL = GetDlFh("'风电'", "DAYDL", area, periodName, "");
            //风电或场站月发电量（取场站或机组的月发电量之和）
            double MDLL = 0;
            string MDL = string.Empty;

            //风电或场站年发电量（取场站或机组的年发电量之和）
            double FDYDLL = GetDlFh("'风电'", "YEARDL", area, periodName, "");
            string FDYDL = string.Empty;

            if (type != "1")
            {
                MDLL = GetDlFh("'风电'", "MONTHDL", area, periodName, "");
                MDL = MDLL.ToString() + "MWh";
                FDYDL = FDYDLL.ToString() + "MWh";
            }
            else
            {
                FDYDL = Math.Round(FDYDLL / 10000, 2).ToString() + "亿kWh";
            }
           

            //拼接表格字符串
            StringBuilder sb1 = new StringBuilder();
            //图的标题
            string mapTitle = string.Empty;
            //数据赋值->表格赋值->输出图
            //总的
            if (type == "1")
            {
                //标题
                name = "风电";
                #region 数据赋值
                //月发电量（总的月发电量 单独计算）
                MDLL = pbll.GetPointVal(new string[] { "HDXN:00CE4000.1.1M" }, DateTime.Now.ToString("yyyy-MM-dd HH:mm:00"))[0];
                MDL = Math.Round(MDLL / 10000, 2).ToString() + "亿kWh";
                #endregion

                mapTitle = "风电";
                #region 表格赋值
                List<ArrayList> info = new List<ArrayList>();
                info = bc.GetProject("风电", area, periodName,"1");
                List<Info> p = new List<Info>();
                p = Handle(info,"1");
                sb1.Append("<table style='width: 500px;font-size:11px;height:700px;' cellspacing='0'>");
                //sb.Append(" <tr >");
                sb1.Append("<tbody><tr style='width: 500px;' bgcolor='#CFE6FC'><td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;区&nbsp;&nbsp;域&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td><td class='t'>场站</td><td>风速</td><td>实时负荷(MW)</td><td>负荷率</td><td>日发电量<br>(万kWh)</td></tr></tbody>");
                List<Info> fd = new List<Info>();
                fd = p.Where(o => o.type == "风电").ToList();
                //风电实时负荷累计
                double fdCount = fd.Sum(d => d.cl);
                double fdlCount = fd.Sum(d => d.dr);
                sb1.Append("<tr >");
                sb1.Append("<td colspan='6' align='center' style='width: 500px; background-color:#FCD209;font-size:11px;'>");
                sb1.Append("风电" + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(&nbsp;&nbsp;实时负荷：" + fdCount.ToString() + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;日发电量：" + fdlCount + "&nbsp;&nbsp;)");

                sb1.Append("</td>");
                sb1.Append("</tr>");
                //fd = fd.OrderBy(o => o.dr).ToList();
                //区域数
                List<string> areaName = fd.Select(d => d.area).Distinct().ToList();
                foreach (var n in areaName)
                {
                    List<Info> tmp = new List<Info>();
                    tmp = fd.Where(inf => inf.area == n).OrderBy(c => c.order).ToList();
                    int count = tmp.Count;
                    sb1.Append("<tr>");
                    sb1.Append("<td  rowspan=\"" + count + "\" style='width: 100px;text-align:left; font-size:15px;font-weight:bolder; '  >");
                    sb1.Append("<a type='2' href='#' onclick='next(this)'>" + tmp[0].area.ToString() + "</a>");
                    sb1.Append("</td>");
                    sb1.Append("<td style='width: 150px;text-align:left; font-size:11px;'  >");
                    sb1.Append("<a type='3' area='" + tmp[0].area.ToString() + "' href='#' onclick='next(this)'>" + tmp[0].name.ToString() + "</a>");
                    sb1.Append("</td>");
                    sb1.Append("<td style='width: 100px;text-align:right;font-size:10px;'  >");
                    sb1.Append(getDouble(double.Parse(tmp[0].wind.ToString()), 3).ToString());
                    //sb1.Append("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;");

                    sb1.Append("</td>");
                    sb1.Append("<td style='width: 100px;text-align:right;font-size:10px;'  >");
                    sb1.Append(getDouble(double.Parse(tmp[0].cl.ToString()), 3).ToString());
                    sb1.Append("</td>");
                    sb1.Append("<td style='width: 100px;text-align:right;font-size:10px;'  >");
                    sb1.Append(getDouble(double.Parse(tmp[0].zb.ToString()) / 10, 2).ToString());
                    sb1.Append("</td>");
                    sb1.Append("<td style='width: 100px;text-align:right;font-size:10px;'  >");
                    sb1.Append(getDouble(double.Parse(tmp[0].dr.ToString()), 3).ToString());
                    sb1.Append("</td>");
                    sb1.Append("</tr>");

                    tmp.Remove(tmp[0]);
                    //分割行1_2,1_3...
                    foreach (var t in tmp)
                    {
                        sb1.Append("<tr>");

                        sb1.Append("<td style='width: 150px;text-align:left; font-size:11px;'  >");
                        sb1.Append("<a type='3' area='" + t.area.ToString() + "'  href='#' onclick='next(this)'>" + t.name.ToString() + "</a>");
                        sb1.Append("</td>");
                        sb1.Append("<td style='width: 100px;text-align:right;font-size:10px;'  >");
                        sb1.Append(getDouble(double.Parse(t.wind.ToString()), 3).ToString());
                        sb1.Append("</td>");
                        sb1.Append("<td style='width: 100px;text-align:right;font-size:10px;'  >");
                        sb1.Append(getDouble(double.Parse(t.cl.ToString()), 3).ToString());
                        sb1.Append("</td>");
                        sb1.Append("<td style='width: 100px;text-align:right;font-size:10px;'  >");
                        sb1.Append(getDouble(double.Parse(t.zb.ToString()) / 10, 2).ToString());
                        sb1.Append("</td>");
                        sb1.Append("<td style='width: 100px;text-align:right;font-size:10px;'  >");
                        sb1.Append(getDouble(double.Parse(t.dr.ToString()), 3).ToString());
                        sb1.Append("</td>");
                        sb1.Append("</tr>");
                    }

                }
                sb1.Append("</table>");
                #endregion
            }
            else if (type == "2")
            {
                //标题
                name = area;
                #region 表格赋值
                //区域
                List<ArrayList> info = new List<ArrayList>();
                info = bc.GetProject("风电", area, periodName,"1");
                List<Info> p = new List<Info>();
                p = Handle(info,"1");
                //区域实时负荷累计
                double fdCount = p.Sum(d => d.cl);
                double fdlCount = p.Sum(d => d.dr);
                int count = p.Count;

                sb1.Append("<table style='width: 500px;font-size:11px;height:" + (count+2)*35+ "px;' cellspacing='0'>");
                //sb.Append(" <tr >");
                sb1.Append("<tbody><tr style='width: 500px;' bgcolor='#CFE6FC'><td class='t'>场站</td><td>风速</td><td>实时负荷(MW)</td><td>负荷率</td><td>日发电量<br>(万kWh)</td></tr></tbody>");
                sb1.Append("<tr style='height:35px;'>");
                sb1.Append("<td colspan='6' align='center' style='width: 500px; background-color:#FCD209;font-size:11px;'>");
                sb1.Append(area + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(&nbsp;&nbsp;实时负荷：" + fdCount.ToString() + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;日发电量：" + fdlCount + "&nbsp;&nbsp;)");

                sb1.Append("</td>");
                sb1.Append("</tr>");
                foreach (var t in p)
                {
                    sb1.Append("<tr  style='height:35px;'>");

                    sb1.Append("<td style='width: 150px;text-align:left; font-size:11px;'  >");
                    sb1.Append("<a type='3' area='" + t.area.ToString() + "' href='#' onclick='next(this)'>"+t.name.ToString()+"</a>");
                    sb1.Append("</td>");
                    sb1.Append("<td style='width: 100px;text-align:right;font-size:10px;'  >");
                    sb1.Append(getDouble(double.Parse(t.wind.ToString()), 3).ToString());
                    sb1.Append("</td>");
                    sb1.Append("<td style='width: 100px;text-align:right;font-size:10px;'  >");
                    sb1.Append(getDouble(double.Parse(t.cl.ToString()), 3).ToString());
                    sb1.Append("</td>");
                    sb1.Append("<td style='width: 100px;text-align:right;font-size:10px;'  >");
                    sb1.Append(getDouble(double.Parse(t.zb.ToString()) / 10, 2).ToString());
                    sb1.Append("</td>");
                    sb1.Append("<td style='width: 100px;text-align:right;font-size:10px;'  >");
                    sb1.Append(getDouble(double.Parse(t.dr.ToString()), 3).ToString());
                    sb1.Append("</td>");
                    sb1.Append("</tr>");
                }
                sb1.Append("</table>");
                #endregion
                mapTitle = area;
            }
            else if (type == "3")
            {
                //标题
                name = periodName;
                //场站 获取机组信息
                List<ArrayList> info = new List<ArrayList>();
                info = bc.GetProject("风电", area, periodName,"2");
                List<Info> p = new List<Info>();
                p = Handle(info,"2");
                //场站实时负荷累计
                double fdCount = p.Sum(d => d.cl);
                double fdlCount = p.Sum(d => d.dr);
                int count = p.Count;
                int c = count / 10;

                //一行排10个
                sb1.Append("<table style='width: 500px;font-size:11px;height:" + (c + 2) * 35 + "px;' cellspacing='0'>");
                //sb.Append(" <tr >");
                sb1.Append("<tr style='height:35px;'>");
                sb1.Append("<td colspan='11' align='center' style='width: 500px; background-color:#FCD209;font-size:11px;'>");
                sb1.Append(periodName + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(&nbsp;&nbsp;实时负荷：" + fdCount.ToString() + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;日发电量：" + fdlCount + "&nbsp;&nbsp;)");
                sb1.Append("</td>");
                sb1.Append("</tr>");
                for (int aa = 0; aa <=c; aa++)
                {
                    StringBuilder sb2 = new StringBuilder();
                    StringBuilder sb3 = new StringBuilder();
                    int b = aa * 10;
                    int cc = (aa+1)*10;
                    for (; b < cc; b++)
                    {
                        if (b < count)
                        {
                            //机组名
                            if (b % 10 == 0)
                            {
                                sb2.Append("<tr style='height:30px;'>");
                            }
                            sb2.Append("<td>");
                            sb2.Append("<a type='4' idkey='" + p[b].idKey.ToString() + "' href='#' onclick='tc(this)'>"+"#" + p[b].unitId+"</a>");//添加超链接
                            sb2.Append("</td>");

                            //实时负荷
                            if (b % 10 == 0)
                            {
                                sb3.Append("<tr style='height:30px;'>");
                            }
                            sb3.Append("<td>");
                            sb3.Append(p[b].cl.ToString());
                            sb3.Append("</td>");
                        }
                        else
                        {
                            break;
                        }
                    }
                    sb2.Append("</tr>");
                    sb3.Append("</tr>");
                    sb1.Append(sb2);
                    sb1.Append(sb3);
                }
                
                sb1.Append("</table>");

                mapTitle = periodName;
            }
            //输出图
            List<Hashtable> listData = new List<Hashtable>();
            Hashtable ht = new Hashtable();
            ht.Add("name", "风电");
            ht.Add("data", GetChartsValues("'风电'", area, periodName));
            listData.Add(ht);

            ArrayList list1 = new ArrayList();
            string[] str2 = new string[9] { "#058DC7", "#50B432", "#ED561B", "#DDDF00", "#24CBE5", "#64E572", "#FF9655", "#FFF263", "#6AF9C4" };
            int num1 = 0;
            foreach (Hashtable _ht in listData)
            {
                Hashtable _dv1 = new Hashtable();
                _dv1.Add("lineColor", str2[num1]);

                _dv1.Add("maxPadding", "1");

                Hashtable hy1 = new Hashtable();


                if (num1 == 0)
                {
                    hy1.Add("text", "负荷(万千瓦)");
                    _dv1.Add("title", hy1);
                }
                else if (num1 == 2)
                {

                }
                _dv1.Add("lineWidth", 1);
                if (num1 != 2)
                {
                    list1.Add(_dv1);
                }
                num1++;

            }
            object obj = new
            {
                topTitle = name,
                zss = FDFH,
                dayDl = FDDDL,
                monthDl = MDL,
                yearDl = FDYDL,
                tables = sb1.ToString(),
                title = mapTitle,
                y_data = list1,
                list = listData
            };
            string result = Newtonsoft.Json.JsonConvert.SerializeObject(obj);
            Response.Write(result);
            Response.End();


        }

        private double GetFDFHValueByTime(string area, string periodName, string time)
        {
            string sql = "select DISTINCT PERIOD_TAG from ADMINISTRATOR.T_INFO_UNIT where data_type='风电'";
            if (!string.IsNullOrEmpty(area))
            {
                sql += " AND T_AREA='" + area + "'";
            }
            if (!string.IsNullOrEmpty(periodName))
            {
                sql += "  AND PERIOD_NAME='" + periodName + "'";
            }
            DataTable dtN = dl.RunDataTable(sql, out errMsg);
            string[] tags = new string[dtN.Rows.Count];
            double[] tagsValues = new double[dtN.Rows.Count];
            for (int s = 0; s < dtN.Rows.Count; s++)
            {
                tags[s] = dtN.Rows[s][0].ToString();
            }
            //tagsValues = pbll.GetPointVal(tags, time);
            tagsValues = pbsll.GetSelectValue(tags);

            double ss = 0;
            if (tagsValues.Length > 0)
                ss = Math.Round(tagsValues.Sum(), 2);

            return ss;
        }

        //根据产业获得总电量和负荷
        private double GetDlFh(string cye, string cName, string area, string periodName, string time)
        {
            string searchTime = DateTime.Now.ToString("yyyy-MM-dd HH:mm:00");
            string[] zfh = new string[] { "HDXN:00CC0001" };
            if (time != "")
                searchTime = time;

            string sql = "SELECT DISTINCT " + cName + " FROM ADMINISTRATOR.T_INFO_UNIT where data_type in (" + cye + ")";
            if (!string.IsNullOrEmpty(area))
            {
                sql += " AND T_AREA='" + area + "'";
            }
            if (!string.IsNullOrEmpty(periodName))
            {
                sql += "  AND PERIOD_NAME='" + periodName + "'";
            }
            DataTable dt = dl.RunDataTable(sql, out errMsg);
            string[] tags = new string[dt.Rows.Count];
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                tags[i] = dt.Rows[i][0].ToString();
            }

            double[] tagValues = null;
            if (cye == "'总负荷'")
                tagValues = pbll.GetPointVal(zfh, searchTime);
            else
                //tagValues = GetPointVal(tags, searchTime);
                tagValues = pbsll.GetSelectValue(tags);

            if (tagValues.Length < 1)
                return 0;
            return Math.Round(tagValues.Where(a => a > 0).Sum(), 2);
        }

        public double[] GetPointVal(string[] points, string time)
        {
            string[] kw = new string[] { "XCHP.1.00CE30017", "HTXL.00CE30001", "KLFD:1.00CE30001", "BEJP:00CE30001", "XCH2:00CC0001", "XCHP.3.00CE30019", "BERP.1.00CE30001" };
            string[] mw = new string[] { "LNTL:00CC0001", "DBHL:00CC0001", "JSGY.1.00CC0001", "SXGL:1.00CE30001", "CCFD:00CE30001", "MGYP:00CE30001", "MGYP:00CC0001", "SYFD:00CE30001", "NMSP:00CE30001", "JJFD:00CE30001", "NTWP:00CE30001" };
            string[] wkw = new string[] { "DAYQ:00CE30001", "DAEQ:00CE30001", "JYGP:00CE30001", "GZFD:1.00CE30001", "YMFD:1.00CE30001", "AKSP:1.00CE30001", "ZSCB:00CE30001", "FLDP:00CE30001", "DBCP:00CE30001", "QLGS:00CE30001", "HNJP:00CC0001", "HNEQ:00CE30001", "TLEQ:00CE30001", "JTFP:1.00CE30001", "YLEQ:00CE30001", "NMQT:00CE30001", "QSFD:00CE30001", "GLSQ:00CC0001" };
            double[] val = new double[points.Length];
            double v = 0;
            DataTable dtPoints = dl.RunDataTable("SELECT T_POINT,T_VALUE FROM ADMINISTRATOR.T_INFO_VALUE", out errMsg);
            DataRow[] drPoint = null;
            for (int i = 0; i < points.Length; i++)
            {
                drPoint = dtPoints.Select("T_POINT='" + points[i] + "'");
                if (drPoint.Count() < 1)
                    v = 0;
                else
                    v = double.Parse(drPoint[0]["T_VALUE"].ToString());

                if (v == -100000)
                    v = 0;


                if (kw.Contains(points[i]))
                    v = v / 1000;
                //if (mw.Contains(points[i]))
                //    v = v / 10000;
                if (wkw.Contains(points[i]))
                    v = v * 10;

                if (points[i] == "BERP.1.00CE30001")
                    v = v / 1000;

                v = getDouble(v, 2);

                val[i] = v;
            }
            return val;
        }

        #region 四舍五入
        /// <summary>
        /// 四舍五入
        /// </summary>
        /// <param name="result">要转换的数值</param>
        /// <param name="num">保留位数</param>
        /// <returns></returns>
        public double getDouble(double result, int num)
        {
            string res = result.ToString();
            string results = "";
            int index = res.IndexOf('.');

            if (res.Length - index == num + 1)
                return Convert.ToDouble(res);
            else
            {
                if (index > 0)
                {
                    index += num;
                    res = res + "000000000000000000";
                    res = res.Remove(0, index + 1);
                    results = result + "000000000000000000";
                    results = results.ToString().Substring(0, index + 1);
                    res = res.Substring(0, 1);

                    string point = "0.";

                    for (int count = 0; count < num - 1; count++)
                    {
                        point += "0";
                    }
                    point += "1";


                    if (Convert.ToInt32(res) > 4)
                    {
                        results = (Convert.ToDouble(results) + Convert.ToDouble(point)).ToString();
                        res = results;
                    }
                    else
                    {
                        res = results;
                    }
                }
                else
                {
                    res += ".";
                    for (int i = 0; i < num; i++)
                    {
                        res += "0";
                    }
                }
                return Convert.ToDouble(res);
            }
        }
        #endregion

       /// <summary>
       /// 转化总，区域，场站，机组类
       /// </summary>
       /// <param name="tmp">数据源</param>
        /// <param name="type">需转化的类型（总，区域，场站 为1，机组为2）</param>
       /// <returns></returns>
        public List<Info> Handle(List<ArrayList> tmp,string type)
        {
            List<Info> list = new List<Info>();
            foreach (var t in tmp)
            {
                Info s = new Info();
                s.name = t[0].ToString();
                s.cl = double.Parse(t[1].ToString());
                s.zb = t[2].ToString();
                s.dr = double.Parse(t[4].ToString());
                s.type = t[5].ToString();
                s.wind = t[3].ToString();
                s.area = t[6].ToString();
                s.order = int.Parse(string.IsNullOrEmpty(t[7].ToString()) ? "100" : t[7].ToString());
                if (type == "2")
                {
                    s.unitId = t[8].ToString();
                    s.idKey =Int32.Parse(t[9].ToString());
                }
                list.Add(s);
            }
            return list;
        }

        /// <summary>
        /// 获得不同产业的负荷点
        /// </summary>
        /// <param name="cy"></param>
        /// <returns></returns>
        private ArrayList GetChartsValues(string cy, string area, string periodName)
        {
            //ArrayList arrData = new ArrayList();

            //DateTime stime = new DateTime(DateTime.Now.Year, DateTime.Now.Month, DateTime.Now.Day, 0, 0, 0);
            //DateTime etime = DateTime.Now;
            //TimeSpan ts = etime - stime; ;
            //int span = ts.Hours;

            //for (int i = 0; i <= span; i++)
            //{
            //    if (cy == "'总负荷'")
            //        arrData.Add(Math.Round(GetDlFh1(cy, "PERIOD_TAG", area, periodName, stime.AddHours(i).ToString("yyyy-MM-dd HH:mm:00")) * 10 + GetDlFh1("'水电'", "PERIOD_TAG", area, periodName, stime.AddHours(i).ToString("yyyy-MM-dd HH:mm:00")) + GetDlFh1("'火电'", "PERIOD_TAG", area, periodName, stime.AddHours(i).ToString("yyyy-MM-dd HH:mm:00")), 3));
            //    else
            //        arrData.Add(Math.Round(GetDlFh1(cy, "PERIOD_TAG", area, periodName, stime.AddHours(i).ToString("yyyy-MM-dd HH:mm:00")), 3));
            //}
            //return arrData;
            ArrayList iList = new ArrayList();
            DateTime stime = new DateTime(DateTime.Now.Year, DateTime.Now.Month, DateTime.Now.Day, 0, 0, 0);
            DateTime etime = DateTime.Now;
            TimeSpan ts = etime - stime ;
            int span = ts.Hours;
            DateTime _sTime = new DateTime(1970, 1, 1);

            //for (int i = 0; i <= span; i++)
            //{

                //stime = stime.AddHours(i);
                //arrData.Add(Convert.ToInt64((etime - stime).TotalMilliseconds));
                int seconds = Convert.ToInt32((etime - stime).TotalSeconds) / 20;
                DateTime dtt = stime;
                while (dtt < etime)
                {
                    ArrayList arrData = new ArrayList();

                    string timeStamp = DateTimeToUTC(dtt).ToString();
                    DateTime dtStart = TimeZone.CurrentTimeZone.ToLocalTime(new DateTime(1970, 1, 1));
                    long lTime = long.Parse(timeStamp + "0000000");
                    TimeSpan toNow = new TimeSpan(lTime);
                    DateTime dtResult = dtStart.Add(toNow);
                    arrData.Add(Convert.ToInt64((dtResult - _sTime).TotalMilliseconds.ToString()));
                    if (cy == "'总负荷'")
                    {
                        arrData.Add(Math.Round(GetDlFh1(cy, "PERIOD_TAG", area, periodName, dtt.ToString("yyyy-MM-dd HH:mm:ss")) * 10 + GetDlFh1("'水电'", "PERIOD_TAG", area, periodName, dtt.ToString("yyyy-MM-dd HH:mm:ss")) + GetDlFh1("'火电'", "PERIOD_TAG", area, periodName, dtt.ToString("yyyy-MM-dd HH:mm:ss")), 3));

                    }
                    else
                    {
                        arrData.Add(Math.Round(GetDlFh1(cy, "PERIOD_TAG", area, periodName, dtt.AddSeconds(seconds).ToString("yyyy-MM-dd HH:mm:ss")), 3));
                    }
                    iList.Add(arrData);
                    dtt = dtt.AddSeconds(seconds);

                }
                return iList;
        }
        //将一个事件对象转换为UTC格式的时间
        public static int DateTimeToUTC(DateTime DT)
        {
            long a = new DateTime(1970, 1, 1, 0, 0, 0, 0).Ticks;
            int rtnInt = 0;
            rtnInt = (int)((DT.Ticks - 8 * 3600 * 1e7 - a) / 1e7);
            return rtnInt;
        }
        //根据产业获得总电量和负荷chart 图形用
        private double GetDlFh1(string cye, string cName, string area, string periodName, string time)
        {
            string searchTime = DateTime.Now.ToString("yyyy-MM-dd HH:mm:00");
            string[] zfh = new string[] { "HDXN:00CC0001" };
            if (time != "")
                searchTime = time;

            string sql = "SELECT DISTINCT " + cName + " FROM ADMINISTRATOR.T_INFO_UNIT where data_type in (" + cye + ")";
            if (!string.IsNullOrEmpty(area))
            {
                sql += " AND T_AREA='" + area + "'";
            }
            if (!string.IsNullOrEmpty(periodName))
            {
                sql += "  AND PERIOD_NAME='" + periodName + "'";
            }
            DataTable dt = dl.RunDataTable(sql, out errMsg);
            string[] tags = new string[dt.Rows.Count];
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                tags[i] = dt.Rows[i][0].ToString();
            }

            double[] tagValues = null;
            if (cye == "'总负荷'")
                tagValues = pbll.GetPointVal(zfh, searchTime);
            else
                //tagValues = pbll.GetPointVal(tags, searchTime);
                tagValues = pbsll.GetSelectValue(tags);

            if (tagValues.Length < 1)
                return 0;
            return Math.Round(tagValues.Where(a => a > 0).Sum(), 2);
        }

    }
    /// <summary>
    /// 总，区域，场站，机组类
    /// </summary>
    public class Info
    {
        public string name { get; set; }
        public double cl { get; set; }
        public string zb { get; set; }
        public double dr { get; set; }
        public string type { get; set; }
        public string area { get; set; }
        public string wind { get; set; }
        public int order { get; set; }
        public string unitId { get; set; }
        public int idKey { get; set; }
    }
     

}