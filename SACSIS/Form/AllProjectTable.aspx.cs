using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using BLL;
using System.Text;
using System.Collections;
using Newtonsoft.Json;

namespace SACSIS.Form
{
    public partial class AllProjectTable : System.Web.UI.Page
    {
        FormBLL fb = new FormBLL();

        protected void Page_Load(object sender, EventArgs e)
        {
            string para = Request["para"];
            if (!string.IsNullOrEmpty(para))
            {
                Initial();
            }
            if (!IsPostBack)
            {
            }
        }

        public void Initial()
        {
            StringBuilder sb = new StringBuilder();
            //表头
            sb.Append("<table style='width: 500px;font-size:13px;'>");
            //sb.Append(" <tr >");
            //sb.Append("<tr bgcolor='#CFE6FC'><td>场站</td><td>实时负荷</td><td>负荷率</td><td>日发电量</td></tr></tbody>");

            sb.Append("<tbody><tr style='width: 500px;font-size:13px;' bgcolor='#CFE6FC'><td width='70px'>  区&nbsp;&nbsp;域&nbsp;</td><td width='100px'  class='t'>场站</td><td>实时负荷(MW)</td><td>负荷率</td><td>日发电量<br>(万kWh)</td></tr></tbody>");

            List<ArrayList> info = new List<ArrayList>();
            info = fb.GetAllProject();
            List<Info> p = new List<Info>();
            p = Handle(info);
            //过滤类型（风电，火电...）
            var name = info.Select(s => s[5]).Distinct();

            StringBuilder sb1 = new StringBuilder();
            sb1.Append("<table style='width: 500px;font-size:13px;'>");
            //sb.Append(" <tr >");
            sb1.Append("<tbody><tr style='width: 500px;' bgcolor='#CFE6FC'><td width='70px'>  区&nbsp;&nbsp;域&nbsp;  </td><td width='100px' class='t'>场站</td><td>风速</td><td>实时负荷(MW)</td><td>负荷率</td><td>日发电量<br>(万kWh)</td></tr></tbody>");
            List<Info> fd = new List<Info>();
            fd = p.Where(o => o.type == "风电").ToList();
            //风电实时负荷累计
            double fdCount = fd.Sum(d => d.cl);
            double fdlCount = fd.Sum(d => d.dr);
            sb1.Append("<tr >");
            sb1.Append("<td colspan='6' align='center' style='width: 500px; background-color:#FCD209;font-size:13px;'>");
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
                sb1.Append("<td  rowspan=\"" + count + "\" style='width: 100px;text-align:left;text-overflow:ellipsis;word-break:keep-all; white-space:nowrap;font-size:13px; '  >");
                sb1.Append("<a type='2' href='#' onclick='next(this)'>" + tmp[0].area.ToString() + "</a>");
                sb1.Append("</td>");
                sb1.Append("<td style='width: 150px;text-align:left;text-overflow:ellipsis;word-break:keep-all; white-space:nowrap;font-size:13px;'  >");
                sb1.Append("<a type='3' area='" + tmp[0].area.ToString() + "' href='#' onclick='next(this)'>" + tmp[0].name.ToString() + "</a>");
                sb1.Append("</td>");
                sb1.Append("<td style='width: 100px;text-align:right;font-size:12px;'  >");
                sb1.Append(getDouble(double.Parse(tmp[0].wind.ToString()), 3).ToString());
                //sb1.Append("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;");

                sb1.Append("</td>");
                sb1.Append("<td style='width: 100px;text-align:right;font-size:12px;'  >");
                sb1.Append(getDouble(double.Parse(tmp[0].cl.ToString()), 3).ToString());
                sb1.Append("</td>");
                sb1.Append("<td style='width: 100px;text-align:right;font-size:12px;'  >");
                sb1.Append(getDouble(double.Parse(tmp[0].zb.ToString()) / 10, 2).ToString());
                sb1.Append("</td>");
                sb1.Append("<td style='width: 100px;text-align:right;font-size:12px;'  >");
                sb1.Append(getDouble(double.Parse(tmp[0].dr.ToString()), 3).ToString());
                sb1.Append("</td>");
                sb1.Append("</tr>");

                tmp.Remove(tmp[0]);
                //分割行1_2,1_3...
                foreach (var t in tmp)
                {
                    sb1.Append("<tr>");

                    sb1.Append("<td style='width: 150px;text-align:left;text-overflow:ellipsis;word-break:keep-all; white-space:nowrap;font-size:13px;'  >");
                    sb1.Append("<a type='3' area='" + t.area.ToString() + "' href='#' onclick='next(this)'>" + t.name.ToString() + "</a>");
                    sb1.Append("</td>");
                    sb1.Append("<td style='width: 100px;text-align:right;font-size:12px;'  >");
                    sb1.Append(getDouble(double.Parse(t.wind.ToString()), 3).ToString());
                    sb1.Append("</td>");
                    sb1.Append("<td style='width: 100px;text-align:right;font-size:12px;'  >");
                    sb1.Append(getDouble(double.Parse(t.cl.ToString()), 3).ToString());
                    sb1.Append("</td>");
                    sb1.Append("<td style='width: 100px;text-align:right;font-size:12px;'  >");
                    sb1.Append(getDouble(double.Parse(t.zb.ToString()) / 10, 2).ToString());
                    sb1.Append("</td>");
                    sb1.Append("<td style='width: 100px;text-align:right;font-size:12px;'  >");
                    sb1.Append(getDouble(double.Parse(t.dr.ToString()), 3).ToString());
                    sb1.Append("</td>");
                    sb1.Append("</tr>");
                }

            }
            sb1.Append("</table>");



            foreach (var type in name)
            {
                if (type.ToString() != "风电")
                {
                    List<Info> m = p.Where(o => o.type == type.ToString()).ToList();
                    double mCount = m.Sum(t => t.cl);
                    double mfdlCount = m.Sum(t => t.dr);
                    sb.Append("<tr >");
                    sb.Append("<td colspan='6' align='center' style='width: 500px; background-color:#FCD209;font-size:13px;'>");
                    sb.Append(type.ToString() + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(&nbsp;&nbsp;实时负荷：" + mCount.ToString() + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;日发电量：" + mfdlCount + "&nbsp;&nbsp;)");

                    sb.Append("</td>");
                    sb.Append("</tr>");

                    List<string> areaName2 = m.Select(d => d.area).Distinct().ToList();
                    foreach (var n in areaName2)
                    {
                        List<Info> tmp = new List<Info>();
                        tmp = m.Where(inf => inf.area == n).OrderBy(c => c.order).ToList();
                        int count = tmp.Count;
                        sb.Append("<tr>");
                        sb.Append("<td  rowspan=\"" + count + "\" style='width: 100px;text-align:left;text-overflow:ellipsis;word-break:keep-all; white-space:nowrap;font-size:13px;'  >");
                        sb.Append( tmp[0].area.ToString() );
                        sb.Append("</td>");
                        sb.Append("<td style='width: 150px;text-align:left;text-overflow:ellipsis;word-break:keep-all; white-space:nowrap;font-size:13px;'  >");
                        sb.Append( tmp[0].name.ToString());
                        sb.Append("</td>");
                        sb.Append("<td style='width: 100px;text-align:right;font-size:12px;'  >");
                        sb.Append(getDouble(double.Parse(tmp[0].cl.ToString()), 3).ToString());
                        sb.Append("</td>");
                        sb.Append("<td style='width: 100px;text-align:right;font-size:12px;'  >");
                        sb.Append(getDouble(double.Parse(tmp[0].zb.ToString()), 2).ToString());
                        sb.Append("</td>");
                        sb.Append("<td style='width: 100px;text-align:right;font-size:12px;'  >");
                        sb.Append(getDouble(double.Parse(tmp[0].dr.ToString()), 3).ToString());
                        sb.Append("</td>");
                        sb.Append("</tr>");

                        tmp.Remove(tmp[0]);
                        //分割行1_2,1_3...
                        foreach (var t in tmp)
                        {
                            sb.Append("<tr>");

                            sb.Append("<td style='width: 150px;text-align:left;text-overflow:ellipsis;word-break:keep-all; white-space:nowrap;font-size:13px;'  >");
                            sb.Append( t.name.ToString() );
                            sb.Append("</td>");
                            sb.Append("<td style='width: 100px;text-align:right;font-size:12px;'  >");
                            sb.Append(getDouble(double.Parse(t.cl.ToString()), 3).ToString());
                            sb.Append("</td>");
                            sb.Append("<td style='width: 100px;text-align:right;font-size:12px;'  >");
                            sb.Append(getDouble(double.Parse(t.zb.ToString()), 2).ToString());
                            sb.Append("</td>");
                            sb.Append("<td style='width: 100px;text-align:right;font-size:12px;'  >");
                            sb.Append(getDouble(double.Parse(t.dr.ToString()), 3).ToString());
                            sb.Append("</td>");
                            sb.Append("</tr>");
                        }
                    }
                }
            }
            sb.Append("</table>");
            //divTable2.InnerHtml = sb.ToString();

            object obj = new
            {
                tab1 = sb.ToString(),
                tab2 = sb1.ToString()

            };
            string result = JsonConvert.SerializeObject(obj);
            Response.Write(result);
            Response.End();

        }

        public List<Info> Handle(List<ArrayList> tmp)
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
                list.Add(s);
            }
            return list;
        }
        #region 四舍五入
        /// <summary>
        /// 四舍五入
        /// </summary>
        /// <param name="result">要转换的数值</param>
        /// <param name="num">保留位数</param>
        /// <returns></returns>
        public string getDouble(double result, int num)
        {
            string res = result.ToString();
            string results = "";
            int index = res.IndexOf('.');

            if (res.Length - index == num + 1)
                return res;
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
                return res;
            }
        }
        #endregion
    }



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

    }
}