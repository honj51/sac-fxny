using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SAC.DBOperations;
using System.Collections;
using System.Data;
using BLL;
using System.ComponentModel;

namespace SACSIS.Form
{
    public partial class InstalledPowerRatio : System.Web.UI.Page
    {
        DBLink dl = new DBLink();
        string errMsg = "";
        PointBLL pbll = new PointBLL();

        protected void Page_Load(object sender, EventArgs e)
        {
            string fncode = Request["funCode"];
            if (!string.IsNullOrWhiteSpace(fncode))
            {
                if (fncode == "init")
                {
                    init();
                }
            }
        }

        /// <summary>
        /// 初始化页面
        /// </summary>
        public void init()
        {
            #region  各产业装机容量比率
            //获得各产业装机容量
            double FDRL = GetRl("2", "FDRL");
            double HDRL = GetRl("2", "HDRL");
            double SDRL = GetRl("2", "SDRL");
            double TYNRL = GetRl("2", "TYNRL");
            double FBSRL = GetRl("2", "FBSRL");
            double SRZRL = GetRl("2", "SWZRL");

            //装机容量
            ArrayList listData = new ArrayList();
            Hashtable htData = new Hashtable();
            
            //风电
            htData.Add("y", FDRL);
            htData.Add("name", "风电");
            htData.Add("color", "#058DC7");
            listData.Add(htData);

            //火电
            htData = new Hashtable();
            htData.Add("y", HDRL);
            htData.Add("name", "火电");
            htData.Add("color", "#50B432");
            listData.Add(htData);

            //水电
            htData = new Hashtable();
            htData.Add("y", SDRL);
            htData.Add("name", "水电");
            htData.Add("color", "#ED561B");
            listData.Add(htData);

            //太阳能
            htData = new Hashtable();
            htData.Add("y", TYNRL);
            htData.Add("name", "太阳能");
            htData.Add("color", "#DDDF00");
            listData.Add(htData);

            //分布式
            htData = new Hashtable();
            htData.Add("y", FBSRL);
            htData.Add("name", "分布式");
            htData.Add("color", "#24CBE5");
            listData.Add(htData);

            //生物质
            htData = new Hashtable();
            htData.Add("y", SRZRL);
            htData.Add("name", "生物质");
            htData.Add("color", "#64E572");
            listData.Add(htData);

            //装机比率
            string zjBl = Newtonsoft.Json.JsonConvert.SerializeObject(listData);
            #endregion

            #region 年发电量比率

            // 年发电量 产业年发电量
            double FDYDL = GetDlFh("'风电'", "YEARDL", "");
            double HDYDL = GetDlFh("'火电'", "YEARDL", "");
            double SDYDL = GetDlFh("'水电'", "YEARDL", "");
            double TYNYDL = GetDlFh("'太阳能'", "YEARDL", "");
            double FBSYDL = GetDlFh("'分布式'", "YEARDL", "");
            double SRZYDL = GetDlFh("'生物质'", "YEARDL", "");

            listData = new ArrayList();
            htData = new Hashtable();

            //风电
            htData.Add("y", FDYDL);
            htData.Add("name", "风电");
            htData.Add("color", "#058DC7");
            listData.Add(htData);

            //火电
            htData = new Hashtable();
            htData.Add("y", HDYDL);
            htData.Add("name", "火电");
            htData.Add("color", "#50B432");
            listData.Add(htData);

            //水电
            htData = new Hashtable();
            htData.Add("y", SDYDL);
            htData.Add("name", "水电");
            htData.Add("color", "#ED561B");
            listData.Add(htData);

            //太阳能
            htData = new Hashtable();
            htData.Add("y", TYNYDL);
            htData.Add("name", "太阳能");
            htData.Add("color", "#DDDF00");
            listData.Add(htData);

            //分布式
            htData = new Hashtable();
            htData.Add("y", FBSYDL);
            htData.Add("name", "分布式");
            htData.Add("color", "#24CBE5");
            listData.Add(htData);

            //生物质
            htData = new Hashtable();
            htData.Add("y", SRZYDL);
            htData.Add("name", "生物质");
            htData.Add("color", "#64E572");
            listData.Add(htData);

            //发电量比率
            string fdlBl = Newtonsoft.Json.JsonConvert.SerializeObject(listData);

            #endregion

            #region 投产容量比率
            //string[] colors = new string[9] { "#058DC7", "#50B432", "#ED561B", "#DDDF00", "#24CBE5", "#64E572", "#FF9655", "#FFF263", "#6AF9C4" };

            //List<TcRl> list = new List<TcRl>();
            //DataTable dt = new DataTable();
            //dt = GetTcRl("2", "FDRL");
            //double[] sdArray = new double[3] { dt.Rows[0]["投产容量"] == DBNull.Value ? 0 : double.Parse(dt.Rows[0]["投产容量"].ToString()), dt.Rows[0]["在建容量"] == DBNull.Value ? 0 : double.Parse(dt.Rows[0]["在建容量"].ToString()), dt.Rows[0]["接入容量"] == DBNull.Value ? 0 : double.Parse(dt.Rows[0]["接入容量"].ToString()) };
            //TcRl sdRl = new TcRl() { y = (dt.Rows[0]["投产容量"] == DBNull.Value ? 0 : double.Parse(dt.Rows[0]["投产容量"].ToString())) + (dt.Rows[0]["在建容量"] == DBNull.Value ? 0 : double.Parse(dt.Rows[0]["在建容量"].ToString())) + (dt.Rows[0]["接入容量"] == DBNull.Value ? 0 : double.Parse(dt.Rows[0]["接入容量"].ToString())), data = sdArray };
            //list.Add(sdRl);

            //dt = GetTcRl("2", "HDRL");
            //sdArray = new double[3] { dt.Rows[0]["投产容量"] == DBNull.Value ? 0 : double.Parse(dt.Rows[0]["投产容量"].ToString()), dt.Rows[0]["在建容量"] == DBNull.Value ? 0 : double.Parse(dt.Rows[0]["在建容量"].ToString()), dt.Rows[0]["接入容量"] == DBNull.Value ? 0 : double.Parse(dt.Rows[0]["接入容量"].ToString()) };
            //sdRl = new TcRl() { y = (dt.Rows[0]["投产容量"] == DBNull.Value ? 0 : double.Parse(dt.Rows[0]["投产容量"].ToString())) + (dt.Rows[0]["在建容量"] == DBNull.Value ? 0 : double.Parse(dt.Rows[0]["在建容量"].ToString())) + (dt.Rows[0]["接入容量"] == DBNull.Value ? 0 : double.Parse(dt.Rows[0]["接入容量"].ToString())), data = sdArray };
            //list.Add(sdRl);

            //dt = GetTcRl("2", "SDRL");
            //sdArray = new double[3] { dt.Rows[0]["投产容量"] == DBNull.Value ? 0 : double.Parse(dt.Rows[0]["投产容量"].ToString()), dt.Rows[0]["在建容量"] == DBNull.Value ? 0 : double.Parse(dt.Rows[0]["在建容量"].ToString()), dt.Rows[0]["接入容量"] == DBNull.Value ? 0 : double.Parse(dt.Rows[0]["接入容量"].ToString()) };
            //sdRl = new TcRl() { y = (dt.Rows[0]["投产容量"] == DBNull.Value ? 0 : double.Parse(dt.Rows[0]["投产容量"].ToString())) + (dt.Rows[0]["在建容量"] == DBNull.Value ? 0 : double.Parse(dt.Rows[0]["在建容量"].ToString())) + (dt.Rows[0]["接入容量"] == DBNull.Value ? 0 : double.Parse(dt.Rows[0]["接入容量"].ToString())), data = sdArray };
            //list.Add(sdRl);

            //dt = GetTcRl("2", "TYNRL");
            //sdArray = new double[3] { dt.Rows[0]["投产容量"] == DBNull.Value ? 0 : double.Parse(dt.Rows[0]["投产容量"].ToString()), dt.Rows[0]["在建容量"] == DBNull.Value ? 0 : double.Parse(dt.Rows[0]["在建容量"].ToString()), dt.Rows[0]["接入容量"] == DBNull.Value ? 0 : double.Parse(dt.Rows[0]["接入容量"].ToString()) };
            //sdRl = new TcRl() { y = (dt.Rows[0]["投产容量"] == DBNull.Value ? 0 : double.Parse(dt.Rows[0]["投产容量"].ToString())) + (dt.Rows[0]["在建容量"] == DBNull.Value ? 0 : double.Parse(dt.Rows[0]["在建容量"].ToString())) + (dt.Rows[0]["接入容量"] == DBNull.Value ? 0 : double.Parse(dt.Rows[0]["接入容量"].ToString())), data = sdArray };
            //list.Add(sdRl);

            //dt = GetTcRl("2", "FBSRL");
            //sdArray = new double[3] { dt.Rows[0]["投产容量"] == DBNull.Value ? 0 : double.Parse(dt.Rows[0]["投产容量"].ToString()), dt.Rows[0]["在建容量"] == DBNull.Value ? 0 : double.Parse(dt.Rows[0]["在建容量"].ToString()), dt.Rows[0]["接入容量"] == DBNull.Value ? 0 : double.Parse(dt.Rows[0]["接入容量"].ToString()) };
            //sdRl = new TcRl() { y = (dt.Rows[0]["投产容量"] == DBNull.Value ? 0 : double.Parse(dt.Rows[0]["投产容量"].ToString())) + (dt.Rows[0]["在建容量"] == DBNull.Value ? 0 : double.Parse(dt.Rows[0]["在建容量"].ToString())) + (dt.Rows[0]["接入容量"] == DBNull.Value ? 0 : double.Parse(dt.Rows[0]["接入容量"].ToString())), data = sdArray };
            //list.Add(sdRl);

            //dt = GetTcRl("2", "SWZRL");
            //sdArray = new double[3] { dt.Rows[0]["投产容量"] == DBNull.Value ? 0 : double.Parse(dt.Rows[0]["投产容量"].ToString()), dt.Rows[0]["在建容量"] == DBNull.Value ? 0 : double.Parse(dt.Rows[0]["在建容量"].ToString()), dt.Rows[0]["接入容量"] == DBNull.Value ? 0 : double.Parse(dt.Rows[0]["接入容量"].ToString()) };
            //sdRl = new TcRl() { y = (dt.Rows[0]["投产容量"] == DBNull.Value ? 0 : double.Parse(dt.Rows[0]["投产容量"].ToString())) + (dt.Rows[0]["在建容量"] == DBNull.Value ? 0 : double.Parse(dt.Rows[0]["在建容量"].ToString())) + (dt.Rows[0]["接入容量"] == DBNull.Value ? 0 : double.Parse(dt.Rows[0]["接入容量"].ToString())), data = sdArray };
            //list.Add(sdRl);

            ////投产情况比率
            //string tcRl = Newtonsoft.Json.JsonConvert.SerializeObject(list);

            DataTable dt = new DataTable();
            //投产
            ArrayList consume = new ArrayList();
            //在建
            ArrayList construct = new ArrayList();
            //接入
            ArrayList  access= new ArrayList();
            List<string> typeCode = new List<string>() { "FDRL", "HDRL", "SDRL", "TYNRL", "FBSRL", "SWZRL" };
            foreach (string  code in typeCode)
            {
                dt = GetTcRl("2", code);
                consume.Add(dt.Rows[0]["投产容量"] == DBNull.Value ? 0 : double.Parse(dt.Rows[0]["投产容量"].ToString()));
                construct.Add(dt.Rows[0]["在建容量"] == DBNull.Value ? 0 : double.Parse(dt.Rows[0]["在建容量"].ToString()));
                access.Add(dt.Rows[0]["接入容量"] == DBNull.Value ? 0 : double.Parse(dt.Rows[0]["接入容量"].ToString()));
            }
            string consumeString = Newtonsoft.Json.JsonConvert.SerializeObject(consume);
            string constructString = Newtonsoft.Json.JsonConvert.SerializeObject(construct);
            string accessString = Newtonsoft.Json.JsonConvert.SerializeObject(access);
            
            //ArrayList sdArray = new ArrayList();
            //Hashtable sdHt = new Hashtable();
            //sdHt.Add("name","风电");
            //sdHt = new Hashtable();
            //sdHt.Add("categories", "['投产', '在建', '接入']");
            //sdHt = new Hashtable();
            //double[] sdArr = new double[3];
            //sdArr[0]=  double.Parse(dt.Rows[0]["投产容量"].ToString());
            //sdArr[1] = double.Parse(dt.Rows[0]["在建容量"].ToString());
            //sdArr[2] = double.Parse(dt.Rows[0]["接入容量"].ToString());
            //sdHt.Add("data", sdArr);
            //sdHt = new Hashtable();
            //sdHt.Add("color", colors[0]);

            #endregion

            object obj = new
            {
                zjBl = zjBl,
                fdlBl = fdlBl,
                //tcRl = tcRl,
                consumeString = consumeString,
                constructString = constructString,
                accessString = accessString
            };
            string result = Newtonsoft.Json.JsonConvert.SerializeObject(obj);
            Response.Write(result);
            Response.End();

        }
        /// <summary>
        /// 获得容量
        /// </summary>
        /// <param name="typ">1风场 2工期 3全部</param>
        /// <param name="id">id</param>
        /// <returns></returns>
        private double GetRl(string typ, string id)
        {
            string sql = string.Empty;
            if (typ == "1")
                sql = @"SELECT SUM(INT(容量)) FROM            
                (select t.T_ORGID T_PERIODID,(select p.T_ORGID from ADMINISTRATOR.T_BASE_PERIOD p where p.T_PERIODID=t.T_ORGID) T_ORGID,t.容量
                from ADMINISTRATOR.T_INFO_RL t )
                where T_ORGID='" + id + "'";
            else if (typ == "2")
                sql = "select sum(int(容量)) from ADMINISTRATOR.T_INFO_RL  where T_ORGID='" + id + "'";
            else if (typ == "3")
                sql = "select sum(int(容量)) from ADMINISTRATOR.T_INFO_RL where T_ORGID='FDRL'";
            else if (typ == "all")
                sql = "select sum(int(容量)) from ADMINISTRATOR.T_INFO_RL where T_ORGID in ('FDRL','HDRL','SDRL','TYNRL','FBSRL','SWZRL')";


            object obj = dl.RunSingle(sql, out errMsg);
            if (obj == null)
                return 0;
            else
                return double.Parse(obj.ToString());
        }


        //根据产业获得总电量和负荷
        private double GetDlFh(string cye, string cName, string time)
        {
            string sql = string.Empty;
            string searchTime = DateTime.Now.ToString("yyyy-MM-dd HH:mm:00");
            string[] zfh = new string[] { "HDXN:00CC0001" };
            if (time != "")
                searchTime = time;

            sql = "SELECT DISTINCT " + cName + " FROM ADMINISTRATOR.T_INFO_UNIT where data_type in (" + cye + ")";
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
                tagValues = GetPointVal(tags, searchTime);

            if (tagValues.Length < 1)
                return 0;
            return Math.Round(tagValues.Where(a => a > 0).Sum(), 2);
        }

        /// <summary>
        /// 获得投产容量,在建容量,接入容量
        /// </summary>
        /// <param name="typ">1风场 2工期 3全部</param>
        /// <param name="id"></param>
        /// <returns></returns>
        private DataTable GetTcRl(string typ, string id)
        {
            string sql = string.Empty;
            DataTable dt = new DataTable();
            if (typ == "1")
                sql = @"SELECT SUM(INT(投产容量)) 投产容量,SUM(INT(在建容量)) 在建容量,SUM(INT(接入容量)) 接入容量 FROM            
                (select t.T_ORGID T_PERIODID,(select p.T_ORGID from ADMINISTRATOR.T_BASE_PERIOD p where p.T_PERIODID=t.T_ORGID) T_ORGID,t.容量
                from ADMINISTRATOR.T_INFO_RL t )
                where T_ORGID='" + id + "'";
            else if (typ == "2")
                sql = "select SUM(INT(投产容量)) 投产容量,SUM(INT(在建容量)) 在建容量,SUM(INT(接入容量)) 接入容量 from ADMINISTRATOR.T_INFO_RL  where T_ORGID='" + id + "'";
            else if (typ == "3")
                sql = "select SUM(INT(投产容量)) 投产容量,SUM(INT(在建容量)) 在建容量,SUM(INT(接入容量)) 接入容量 from ADMINISTRATOR.T_INFO_RL where T_ORGID='FDRL'";
            else if (typ == "all")
                sql = "select SUM(INT(投产容量)) 投产容量,SUM(INT(在建容量)) 在建容量,SUM(INT(接入容量)) 接入容量 from ADMINISTRATOR.T_INFO_RL where T_ORGID in ('FDRL','HDRL','SDRL','TYNRL','FBSRL','SWZRL')";
            dt = dl.RunDataTable(sql, out errMsg);
            return dt;
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
    }
    
    /// <summary>
    /// 投产容量类
    /// </summary>
    public class TcRl
    {
        [Description("Y值")]
        public double y { set; get; }
        [Description("数据")]
        public double[] data { set; get; }
    }
}