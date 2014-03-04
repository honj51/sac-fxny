using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Newtonsoft.Json;
using BLL;
using SAC.DBOperations;
using System.Data;
using System.Collections;

namespace WebApplication2
{
    public partial class MainConnect : System.Web.UI.Page
    {
        string sql = "";
        string errMsg = "";

        DBLink dl = new DBLink();
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
                if (fncode == "initCharts")
                {
                    initCharts(Request["chartNum"]);
                }
                 if (fncode == "GetFDFHValue")
                {
                    GetFDFHValue();
                }
            }
        }

        private void init()
        {
            //获得总容量和产业容量
            double FDRL = GetRl("2", "FDRL");
            double HDRL = GetRl("2", "HDRL");
            double SDRL = GetRl("2", "SDRL");
            double TYNRL = GetRl("2", "TYNRL");
            double FBSRL = GetRl("2", "FBSRL");
            double SRZRL = GetRl("2", "SWZRL");
            double ZRL = FDRL + HDRL + SDRL + TYNRL + FBSRL + SRZRL;

            //总负荷 产业负荷
            //double FDFH = GetDlFh("'风电'", "PERIOD_TAG","");
            //double FDFH=GetFDFHValueByTime(DateTime.Now.ToString("yyyy-MM-dd HH:mm:00"));
            //double HDFH =  GetDlFh("'火电'", "PERIOD_TAG", "");
            //double SDFH =  GetDlFh("'水电'", "PERIOD_TAG", "");
            //double TYNFH = GetDlFh("'太阳能'", "PERIOD_TAG", "");
            //double FBSFH = GetDlFh("'分布式'", "PERIOD_TAG", "");
            //double SRZFH = GetDlFh("'生物质'", "PERIOD_TAG", "");
            ArrayList fh=new ArrayList();
            double tmp=0;
            int count=0;

            //火电
            double HDFH =0;
            fh =GetChartsValues("'火电'");
            foreach(var value in fh)
            {
                tmp+= double.Parse(value.ToString());
                count++;
            }
            HDFH=Math.Round(tmp/count,3);
            tmp=0;
            count=0;
             
           
            //水电
            double SDFH=0;
            fh =GetChartsValues("'水电'");
            foreach(var value in fh)
            {
                tmp+= double.Parse(value.ToString());
                count++;
            }
            SDFH=Math.Round(tmp/count,3);
            tmp=0;
            count=0;
            
            //风电
            double FDFH = 0;
            fh =GetChartsValues("'风电'");
            foreach(var value in fh)
            {
                tmp+= double.Parse(value.ToString());
                count++;
            }
            FDFH = Math.Round(tmp / count, 3);
            tmp=0;
            count=0;

            //太阳能
            double TYNFH = 0;
            fh =GetChartsValues("'太阳能'");
            foreach(var value in fh)
            {
                tmp+= double.Parse(value.ToString());
                count++;
            }
            TYNFH = Math.Round(tmp / count, 3);
            tmp=0;
            count=0;

            //分布式
            double FBSFH = 0;
            fh =GetChartsValues("'分布式'");
            foreach(var value in fh)
            {
                tmp+= double.Parse(value.ToString());
                count++;
            }
            FBSFH = Math.Round(tmp / count, 3);
            tmp = 0;
            count = 0;

            //生物质
            double SRZFH = 0;
            fh = GetChartsValues("'生物质'");
            foreach (var value in fh)
            {
                tmp += double.Parse(value.ToString());
                count++;
            }
            SRZFH = Math.Round(tmp / count, 3);
             

            double ZFH = pbll.GetPointVal(new string[] { "HDXN:00CC0001" }, DateTime.Now.ToString("yyyy-MM-dd HH:mm:00"))[0]*10;
            ZFH = Math.Round(ZFH,2);

            //日发电量 产业日电量
            double FDDDL = GetDlFh("'风电'", "DAYDL", "");
            double HDDDL = GetDlFh("'火电'", "DAYDL", "");
            double SDDDL = GetDlFh("'水电'", "DAYDL", "");
            double TYNDDL = GetDlFh("'太阳能'", "DAYDL", "");
            double FBSDDL = GetDlFh("'分布式'", "DAYDL", "");
            double SRZDDL = GetDlFh("'生物质'", "DAYDL", "");
            double DDL = pbll.GetPointVal(new string[] { "HDXN:00CE4000.1.1D" }, DateTime.Now.ToString("yyyy-MM-dd HH:mm:00"))[0];
            DDL = Math.Round(DDL, 2);

            // 月发电量
            double MDL = pbll.GetPointVal(new string[] { "HDXN:00CE4000.1.1M" }, DateTime.Now.ToString("yyyy-MM-dd HH:mm:00"))[0];
            double HDMDL = GetDlFh("'火电'", "MONTHDL", "");
            double SDMDL = GetDlFh("'水电'", "MONTHDL", "");


            MDL = Math.Round(MDL, 2);

            // 年发电量 产业年发电量
            double FDYDL = GetDlFh("'风电'", "YEARDL", "");
            double HDYDL = GetDlFh("'火电'", "YEARDL", "");
            double SDYDL = GetDlFh("'水电'", "YEARDL", "");
            double TYNYDL = GetDlFh("'太阳能'", "YEARDL", "");
            double FBSYDL = GetDlFh("'分布式'", "YEARDL", "");
            double SRZYDL = GetDlFh("'生物质'", "YEARDL", "");
            double YDL = pbll.GetPointVal(new string[] { "HDXN:00CE4000.1.1Y" }, DateTime.Now.ToString("yyyy-MM-dd HH:mm:00"))[0];
            YDL = Math.Round(YDL, 2);

            //产业发电计划
            double FDJHDL = GetJHDl("'FDRL'", DateTime.Now.ToString("yyyy-01-01 0:00:00"));
            double HDJHDL = GetJHDl("'HDRL'", DateTime.Now.ToString("yyyy-01-01 0:00:00"));
            double SDJHDL = GetJHDl("'SDRL'", DateTime.Now.ToString("yyyy-01-01 0:00:00"));
            double TYNJHDL = GetJHDl("'TYNRL'", DateTime.Now.ToString("yyyy-01-01 0:00:00"));
            double FBSJHDL = GetJHDl("'FBSRL'", DateTime.Now.ToString("yyyy-01-01 0:00:00"));
            double SRZJHDL = GetJHDl("'SWZRL'", DateTime.Now.ToString("yyyy-01-01 0:00:00"));

            object _obj = new
            {
                //总容量和产业容量
                ZRL = ZRL,
                FDRL = FDRL,
                HDRL = HDRL,
                SDRL = SDRL,
                TYNRL =TYNRL,
                FBSRL =FBSRL,
                SRZRL =SRZRL,

                //总负荷产业负荷
                ZFH=ZFH,
                //FDFH = FDFH,
                HDFH = HDFH,
                SDFH = SDFH,
                TYNFH =TYNFH,
                FBSFH =FBSFH,
                SRZFH =SRZFH,

                //日月电量
                DDL = DDL,
                FDDDL = FDDDL,
                HDDDL = HDDDL,
                SDDDL = SDDDL,
                TYNDDL = TYNDDL,
                FBSDDL = FBSDDL,
                SRZDDL = SRZDDL,

                //月电量
                MDL =MDL,
                HDMDL = HDMDL,
                SDMDL = SDMDL,

                //年电量
                YDL = YDL,
                FDYDL = FDYDL,
                HDYDL = HDYDL,
                SDYDL = SDYDL,
                TYNYDL = TYNYDL,
                FBSYDL = FBSYDL,
                SRZYDL = SRZYDL,

                //产业年完成率
                FDWCL =FDJHDL==0?0.00: Math.Round(FDYDL / FDJHDL*100,2),
                HDWCL = HDJHDL == 0 ? 0.00 : Math.Round(HDYDL / HDJHDL * 100, 2),
                SDWCL = SDJHDL == 0 ? 0.00 : Math.Round(SDYDL / SDJHDL * 100, 2),
                TYNWCL = TYNJHDL == 0 ? 0.00 : Math.Round(TYNYDL / TYNJHDL * 100, 2),
                FBSWCL = FBSJHDL == 0 ? 0.00 : Math.Round(FBSYDL / FBSJHDL * 100, 2),
                SRZWCL = SRZJHDL == 0 ? 0.00 : Math.Round(SRZYDL / SRZJHDL * 100, 2),

                //实时负荷率
                HDSS = HDFH == 0 ? 0.00 : Math.Round(HDFH / HDRL * 100, 2),
                SDSS = SDFH == 0 ? 0.00 : Math.Round(SDFH / SDRL * 100, 2),
                FDSS = FDFH == 0 ? 0.00 : Math.Round(FDFH / FDRL * 100, 2),
                FBSSS = FBSFH == 0 ? 0.00 : Math.Round(FBSFH / FBSRL * 100, 2),
                TYNSS = TYNFH == 0 ? 0.00 : Math.Round(TYNFH / TYNRL * 100, 2),
                SRZSS = SRZFH == 0 ? 0.00 : Math.Round(SRZFH / SRZRL * 100, 2)
            };


            string result = JsonConvert.SerializeObject(_obj);
            Response.Write(result);
            Response.End();
        }


        //加载负荷趋势
        private void initCharts(string chartNum)
        {
            List<Hashtable> listData = new List<Hashtable>();
            
            Hashtable ht = new Hashtable();

            if (chartNum == "1")
            {
                ht.Add("name", "火电");
                ht.Add("data", GetChartsValues("'火电'"));
                listData.Add(ht);
                ht = new Hashtable();
                ht.Add("name", "风电");
                ht.Add("data", GetChartsValues("'风电'"));
                listData.Add(ht);
                ht = new Hashtable();
                ht.Add("name", "水电");
                ht.Add("data", GetChartsValues("'水电'"));
                listData.Add(ht);
            }

            if (chartNum == "2")
            {
                ht = new Hashtable();
                ht.Add("name", "分布式");
                ht.Add("data", GetChartsValues("'分布式'"));
                listData.Add(ht);
                ht = new Hashtable();
                ht.Add("name", "太阳能");
                ht.Add("data", GetChartsValues("'太阳能'"));
                listData.Add(ht);
                ht = new Hashtable();
                ht.Add("name", "生物质");
                ht.Add("data", GetChartsValues("'生物质'"));
                listData.Add(ht);
            }

            if (chartNum == "3")
            {
                ht = new Hashtable();
                ht.Add("name", "总负荷");
                ht.Add("data", GetChartsValues("'总负荷'"));
                listData.Add(ht);
            }
            
            object _obj = new
            {
                chart = listData
            };

            Response.Write(JsonConvert.SerializeObject(_obj));
            Response.End();
        }




        //获取风电时实负荷
        private void GetFDFHValue()
        {
            object _obj = new
            {
                FDFH = GetFDFHValueByTime(DateTime.Now.ToString("yyyy-MM-dd HH:mm:00"))
            };

            Response.Write(JsonConvert.SerializeObject(_obj));
            Response.End();
        }

        /// <summary>
        /// 获得不同产业的负荷点
        /// </summary>
        /// <param name="cy"></param>
        /// <returns></returns>
        private ArrayList GetChartsValues(string cy)
        {
            ArrayList arrData = new ArrayList();

            DateTime stime = new DateTime(DateTime.Now.Year, DateTime.Now.Month, DateTime.Now.Day, 0, 0, 0);
            DateTime etime = DateTime.Now;
            TimeSpan ts = etime - stime; ;
            int span = ts.Hours;

            for (int i = 0; i <= span; i++)
            {
                if (cy == "'总负荷'")
                    arrData.Add(Math.Round(GetDlFh1(cy, "PERIOD_TAG", stime.AddHours(i).ToString("yyyy-MM-dd HH:mm:00"))*10 + GetDlFh1("'水电'", "PERIOD_TAG", stime.AddHours(i).ToString("yyyy-MM-dd HH:mm:00")) + GetDlFh1("'火电'", "PERIOD_TAG", stime.AddHours(i).ToString("yyyy-MM-dd HH:mm:00")),3));
                else
                    arrData.Add(Math.Round(GetDlFh1(cy, "PERIOD_TAG", stime.AddHours(i).ToString("yyyy-MM-dd HH:mm:00")),3));
            }
            return arrData;
        }

        /// <summary>
        /// 获得容量
        /// </summary>
        /// <param name="typ">1风场 2工期 3全部</param>
        /// <param name="id">id</param>
        /// <returns></returns>
        private double GetRl(string typ, string id)
        {
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

        //根据产业获得总电量和负荷chart 图形用
        private double GetDlFh1(string cye, string cName, string time)
        {
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
                tagValues = pbll.GetPointVal(tags, searchTime);

            if (tagValues.Length < 1)
                return 0;
            return Math.Round(tagValues.Where(a => a > 0).Sum(), 2);
        }


        /// <summary>
        /// 获取计划电量
        /// </summary>
        /// <param name="id"></param>
        /// <param name="typ"></param>
        /// <param name="p"></param>
        /// <returns></returns>
        private double GetJHDl(string cy,string time)
        {
            sql = "select 年计划发电量 from ADMINISTRATOR.T_INFO_JHDL t where t.T_ORGID in (" + cy + ") and T_TIME='" + time + "'";
            object objJHDL = dl.RunSingle(sql, out errMsg);

            if (objJHDL == null)
                return 0;
            else
                return double.Parse(objJHDL.ToString());
        }



        private double GetFDFHValueByTime(string time)
        {
            DataTable dtN = dl.RunDataTable("select DISTINCT PERIOD_TAG from ADMINISTRATOR.T_INFO_UNIT where data_type='风电'", out errMsg);
            string[] tags = new string[dtN.Rows.Count];
            double[] tagsValues = new double[dtN.Rows.Count];
            for (int s = 0; s < dtN.Rows.Count; s++)
            {
                tags[s] = dtN.Rows[s][0].ToString();
            }
            tagsValues = pbll.GetPointVal(tags, time);
            double ss = 0;
            if (tagsValues.Length > 0)
                ss = Math.Round(tagsValues.Sum(), 2);

            return ss;
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
}