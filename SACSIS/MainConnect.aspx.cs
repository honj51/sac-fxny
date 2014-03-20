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
using BLL.BLLMainConnect;

namespace WebApplication2
{
    public partial class MainConnect : System.Web.UI.Page
    {
        string sql = "";
        string errMsg = "";

        DBLink dl = new DBLink();
        PointBLL pbll = new PointBLL();
        BLLMainConnect bm = new BLLMainConnect();

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
                 if (fncode == "Burden")
                 {
                     GetBurdenValue();
                 }
            }
        }

        /// <summary>
        /// 获得各产业不同场站功率点不同时间断(至当前)的日均负荷（半小时取一次）(供日均负荷及趋势图使用)
        /// </summary>
        /// <param name="points">产业场站测点</param>
        /// <param name="chartLists">产业不同时间的数据集合</param>
        /// <returns></returns>
        private double GetValues(List<string> points,out ArrayList chartLists)
        {
            double value = 0;
            chartLists = new ArrayList();
            DateTime stime = new DateTime(DateTime.Now.Year, DateTime.Now.Month, DateTime.Now.Day, 0, 0, 0);
            DateTime etime = DateTime.Now;
            TimeSpan ts = etime - stime; 
            int span = (ts.Hours) * 2;
            List<double> doubleList = new List<double>();
            for (int i = 0; i <= span; i++)
            {
                doubleList = bm.GetPointVal(points, stime.AddHours(i * 0.5).ToString("yyyy-MM-dd HH:mm:00"));
                value += doubleList.Where(v=>v>0).Sum();
                chartLists.Add(doubleList.Where(v => v > 0).Sum());
            }
            value = value / span;
            return value;
        }

        /// <summary>
        /// 获取各产业实时日发电量
        /// </summary>
        /// <param name="companyType">电类型（风电，水电...）</param>
        /// <param name="type">点所属层次（电厂，机组）</param>
        /// <param name="pointType">点类型（负荷，风速，日电量，月电量，年电量）</param>
        /// <returns></returns>
        private double GetRValue(string companyType, string type, string pointType)
        {
            double v = 0;
            List<string> fdRPoint = bm.GetTagByKind(companyType, type, pointType);
            string fdRString = string.Empty;
            foreach (string name in fdRPoint)
            {
                fdRString += "'" + name + "'" + ",";
            }
            v = Math.Round(bm.GetValueByPoints(fdRString.Remove(fdRString.Length - 1)), 2);
            return v;
        }

        /// <summary>
        /// 获得各产业不同场站功率点不同时间的负荷（半小时取一次）（供趋势图使用）
        /// </summary>
        /// <param name="points">产业场站测点</param>
        /// <returns></returns>
        private ArrayList GetChartValues(List<string> points)
        {
            ArrayList value = new ArrayList ();
            DateTime stime = new DateTime(DateTime.Now.Year, DateTime.Now.Month, DateTime.Now.Day, 0, 0, 0);
            DateTime etime = DateTime.Now;
            TimeSpan ts = etime - stime;
            int span = (ts.Hours) * 2;
            List<double> doubleList = new List<double>();
            for (int i = 0; i <= span; i++)
            {
                doubleList = bm.GetPointVal(points, stime.AddHours(i * 0.5).ToString("yyyy-MM-dd HH:mm:00"));
                 value.Add(doubleList.Where(v => v > 0).Sum());
            }
            return value;
        }

        /// <summary>
        /// 获取日平均负荷及趋势图
        /// </summary>
        private void GetBurdenValue()
        {
            #region  产业负荷及趋势图
            ArrayList fh = new ArrayList();
            Hashtable ht = new Hashtable();

            //第一幅趋势图
            List<Hashtable> listDataFirst = new List<Hashtable>();
            //第二幅趋势图
            List<Hashtable> listDataSecond = new List<Hashtable>();
            //第三幅趋势图
            List<Hashtable> listDataThird = new List<Hashtable>();

            //日均负荷及趋势图 获取场站测点，获取实时数据库中的历史平均值
            //火电 日均负荷
            double HDFH = 0;
            ArrayList chart1 = new ArrayList();
            List<string> hdPoint = bm.GetTagByKind("火电", "电厂", "功率");
            HDFH = Math.Round(GetValues(hdPoint, out chart1) / 10, 2);
            //火电 趋势图
            ht.Add("name", "火电");
            ht.Add("data", chart1);
            listDataFirst.Add(ht);

            //水电
            double SDFH = 0;
            ht = new Hashtable();
            ArrayList chart2 = new ArrayList();
            List<string> sdPoint = bm.GetTagByKind("水电", "电厂", "功率");
            SDFH = Math.Round(GetValues(sdPoint, out chart2) / 10, 2);
            //水电 趋势图
            ht.Add("name", "水电");
            ht.Add("data", chart2);
            listDataFirst.Add(ht);

            //风电
            double FDFH = 0;
            ht = new Hashtable();
            ArrayList chart3 = new ArrayList();
            List<string> fdPoint = bm.GetTagByKind("风电", "电厂", "功率");
            FDFH = Math.Round(GetValues(fdPoint, out chart3) / 10, 2);
            //风电 趋势图
            ht.Add("name", "风电");
            ht.Add("data", chart3);
            listDataFirst.Add(ht);
             

            //太阳能
            double TYNFH = 0;
            ht = new Hashtable();
            ArrayList chart4 = new ArrayList();
            List<string> tynPoint = bm.GetTagByKind("太阳能", "电厂", "功率");
            TYNFH = Math.Round(GetValues(tynPoint, out chart4) / 10, 2);
            //太阳能 趋势图
            ht.Add("name", "太阳能");
            ht.Add("data", chart4);
            listDataSecond.Add(ht);
             
            //分布式
            double FBSFH = 0;
            ht = new Hashtable();
            ArrayList chart5 = new ArrayList();
            List<string> fbsPoint = bm.GetTagByKind("分布式", "电厂", "功率");
            FBSFH = Math.Round(GetValues(fbsPoint, out chart5) / 10, 2);
            //分布式 趋势图
            ht.Add("name", "分布式");
            ht.Add("data", chart5);
            listDataSecond.Add(ht);
             
            //生物质
            double SRZFH = 0;
            ht = new Hashtable();
            ArrayList chart6 = new ArrayList();
            List<string> swzPoint = bm.GetTagByKind("生物质", "电厂", "功率");
            SRZFH = Math.Round(GetValues(swzPoint, out chart6) / 10, 2);
            //生物质 趋势图
            ht.Add("name", "生物质");
            ht.Add("data", chart6);
            listDataSecond.Add(ht);
             

            //总负荷
            double ZFH = Math.Round(HDFH + FDFH + SDFH + TYNFH + FBSFH + SRZFH, 2);
            //总趋势图
            ArrayList allChart = new ArrayList();
            ht = new Hashtable();
            for (int i = 0; i < chart1.Count; i++)
            {
               double v=double.Parse(chart1[i].ToString()) + double.Parse(chart2[i].ToString()) + double.Parse(chart3[i].ToString()) + double.Parse(chart4[i].ToString()) + double.Parse(chart5[i].ToString()) + double.Parse(chart6[i].ToString());
               allChart.Add(Math.Round(v, 2));
            }
            ht.Add("name", "总负荷");
            ht.Add("data", allChart); 
            listDataThird.Add(ht);
             object _obj = new
            {
              //总负荷产业负荷
                ZFH=ZFH,
                FDFH = FDFH,
                HDFH = HDFH,
                SDFH = SDFH,
                TYNFH =TYNFH,
                FBSFH =FBSFH,
                SRZFH =SRZFH,
                chartFirst=listDataFirst,
                chartSecond=listDataSecond,
                chartThird=listDataThird
            };

             string result = JsonConvert.SerializeObject(_obj);
             Response.Write(result);
             Response.End();
            #endregion
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


            //#region  产业负荷
            ////总负荷 产业负荷
            ////double FDFH = GetDlFh("'风电'", "PERIOD_TAG","");
            ////double FDFH=GetFDFHValueByTime(DateTime.Now.ToString("yyyy-MM-dd HH:mm:00"));
            ////double HDFH =  GetDlFh("'火电'", "PERIOD_TAG", "");
            ////double SDFH =  GetDlFh("'水电'", "PERIOD_TAG", "");
            ////double TYNFH = GetDlFh("'太阳能'", "PERIOD_TAG", "");
            ////double FBSFH = GetDlFh("'分布式'", "PERIOD_TAG", "");
            ////double SRZFH = GetDlFh("'生物质'", "PERIOD_TAG", "");
            //ArrayList fh=new ArrayList();
            //double tmp=0;
            //int count=0;

            ////负荷 获取场站测点，获取实时数据库中的历史平均值
            ////火电
            //double HDFH =0;
            ////fh =Session["hd"]==null? GetChartsValues("'火电'"):(ArrayList)Session["hd"];
            ////foreach(var value in fh)
            ////{
            ////    tmp+= double.Parse(value.ToString());
            ////    count++;
            ////}
            ////HDFH=Math.Round((tmp/count)/10,2);
            ////tmp=0;
            ////count=0;
            //List<string> hdPoint = bm.GetTagByKind("火电", "电厂", "功率");
            //HDFH = Math.Round(GetValues(hdPoint)/10,2);
           
            ////水电
            //double SDFH=0;
            ////fh =Session["sd"]==null? GetChartsValues("'水电'"):(ArrayList)Session["sd"];
            ////foreach(var value in fh)
            ////{
            ////    tmp+= double.Parse(value.ToString());
            ////    count++;
            ////}
            ////SDFH=Math.Round((tmp/count)/10,2);
            ////tmp=0;
            ////count=0;
            //List<string> sdPoint = bm.GetTagByKind("水电", "电厂", "功率");
            //SDFH = Math.Round(GetValues(sdPoint) / 10, 2);

            ////风电
            //double FDFH = 0;
            ////fh =Session["fd"]==null?GetChartsValues("'风电'"): (ArrayList)Session["fd"];
            ////foreach(var value in fh)
            ////{
            ////    if (double.Parse(value.ToString()) < 2100)
            ////    {
            ////        tmp += double.Parse(value.ToString());
            ////        count++;
            ////    }
            ////}
            ////FDFH = Math.Round((tmp / count)/10, 2);
            ////tmp=0;
            ////count=0;
            //List<string> fdPoint = bm.GetTagByKind("风电", "电厂", "功率");
            //FDFH = Math.Round(GetValues(fdPoint) / 10, 2);


            ////太阳能
            //double TYNFH = 0;
            ////fh =Session["tyn"]==null?GetChartsValues("'太阳能'"):(ArrayList)Session["tyn"];
            ////foreach(var value in fh)
            ////{
            ////    tmp+= double.Parse(value.ToString());
            ////    count++;
            ////}
            ////TYNFH = Math.Round((tmp / count)/10, 2);
            ////tmp=0;
            ////count=0;
            //List<string> tynPoint = bm.GetTagByKind("太阳能", "电厂", "功率");
            //TYNFH = Math.Round(GetValues(tynPoint) / 10, 2);


            ////分布式
            //double FBSFH = 0;
            ////fh =Session["fbs"]==null?GetChartsValues("'分布式'"):(ArrayList)Session["fbs"];
            ////foreach(var value in fh)
            ////{
            ////    tmp+= double.Parse(value.ToString());
            ////    count++;
            ////}
            ////FBSFH = Math.Round((tmp / count)/10, 2);
            ////tmp = 0;
            ////count = 0;
            //List<string> fbsPoint = bm.GetTagByKind("分布式", "电厂", "功率");
            //FBSFH = Math.Round(GetValues(fbsPoint) / 10, 2);

            ////生物质
            //double SRZFH = 0;
            ////fh = Session["swz"]==null?GetChartsValues("'生物质'"):(ArrayList)Session["swz"];
            ////foreach (var value in fh)
            ////{
            ////    tmp += double.Parse(value.ToString());
            ////    count++;
            ////}
            ////SRZFH = Math.Round((tmp / count)/10, 2);
            //List<string> swzPoint = bm.GetTagByKind("生物质", "电厂", "功率");
            //SRZFH = Math.Round(GetValues(swzPoint) / 10, 2);

            ////double ZFH = pbll.GetPointVal(new string[] { "HDXN:00CC0001" }, DateTime.Now.ToString("yyyy-MM-dd HH:mm:00"))[0]*10;
            ////ZFH = Math.Round(ZFH,2);
            //double ZFH = Math.Round(HDFH + FDFH + SDFH + TYNFH + FBSFH + SRZFH, 2);


            //#endregion

            #region 日发电量
            //日发电量 产业日电量(实时)
            //double FDDDL = GetDlFh("'风电'", "DAYDL", "");
            //double HDDDL = GetDlFh("'火电'", "DAYDL", "");
            //double SDDDL = GetDlFh("'水电'", "DAYDL", "");
            //double TYNDDL = GetDlFh("'太阳能'", "DAYDL", "");
            //double FBSDDL = GetDlFh("'分布式'", "DAYDL", "");
            //double SRZDDL = GetDlFh("'生物质'", "DAYDL", "");
            
            double FDDDL = GetRValue("风电","电厂","日电量");
            double HDDDL = GetRValue("火电", "电厂", "日电量");
            double SDDDL = GetRValue("水电", "电厂", "日电量");
            double TYNDDL = GetRValue("太阳能", "电厂", "日电量");
            double FBSDDL = GetRValue("分布式", "电厂", "日电量");
            double SRZDDL = GetRValue("生物质", "电厂", "日电量"); 
            //double DDL = pbll.GetPointVal(new string[] { "HDXN:00CE4000.1.1D" }, DateTime.Now.ToString("yyyy-MM-dd HH:mm:00"))[0];
            //DDL = Math.Round(DDL, 2);
            double DDL = Math.Round(FDDDL + HDDDL + SDDDL + TYNDDL + FBSDDL + SRZDDL, 2);

            #endregion

            // 月发电量  是各场站累加。总的华电福新PI点废掉
            //double MDL = pbll.GetPointVal(new string[] { "HDXN:00CE4000.1.1M" }, DateTime.Now.ToString("yyyy-MM-dd HH:mm:00"))[0];
            //double HDMDL = GetDlFh("'火电'", "MONTHDL", "");
            //double SDMDL = GetDlFh("'水电'", "MONTHDL", "");
            double HDMDL = GetRValue("火电", "电厂", "月电量");
            double SDMDL = GetRValue("水电", "电厂", "月电量");
            double FDMDL=GetRValue("风电", "电厂", "月电量");
            double TYNMDL=GetRValue("太阳能", "电厂", "月电量");
            double FBSMDL=GetRValue("分布式", "电厂", "月电量");
            double SWZMDL = GetRValue("生物质", "电厂", "月电量");
            double MDL = HDMDL + SDMDL + FDMDL + TYNMDL+ FBSMDL+ SWZMDL;

            MDL = Math.Round(MDL, 2);

            // 年发电量 产业年发电量 是各场站累加 
            //double FDYDL = GetDlFh("'风电'", "YEARDL", "");
            //double HDYDL = GetDlFh("'火电'", "YEARDL", "");
            //double SDYDL = GetDlFh("'水电'", "YEARDL", "");
            //double TYNYDL = GetDlFh("'太阳能'", "YEARDL", "");
            //double FBSYDL = GetDlFh("'分布式'", "YEARDL", "");
            //double SRZYDL = GetDlFh("'生物质'", "YEARDL", "");
            double FDYDL = GetRValue("风电", "电厂", "年电量");
            double HDYDL = GetRValue("火电", "电厂", "年电量");
            double SDYDL = GetRValue("水电", "电厂", "年电量");
            double TYNYDL = GetRValue("太阳能", "电厂", "年电量");
            double FBSYDL = GetRValue("分布式", "电厂", "年电量");
            double SRZYDL = GetRValue("生物质", "电厂", "年电量");
            //double YDL = pbll.GetPointVal(new string[] { "HDXN:00CE4000.1.1Y" }, DateTime.Now.ToString("yyyy-MM-dd HH:mm:00"))[0];
            //YDL = Math.Round(YDL, 2);
            double YDL = FDYDL + HDYDL + SDYDL + TYNYDL + FBSYDL + SRZYDL;

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

                ////总负荷产业负荷
                //ZFH=ZFH,
                //FDFH = FDFH,
                //HDFH = HDFH,
                //SDFH = SDFH,
                //TYNFH =TYNFH,
                //FBSFH =FBSFH,
                //SRZFH =SRZFH,

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
                //HDMDL = HDMDL,
                //SDMDL = SDMDL,

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

                //实时负荷率(地图旁边的负荷进度条)
                //HDSS = HDFH == 0 ? 0.00 : Math.Round(HDFH / HDRL * 100, 2),
                //SDSS = SDFH == 0 ? 0.00 : Math.Round(SDFH / SDRL * 100, 2),
                //FDSS = FDFH == 0 ? 0.00 : Math.Round(FDFH / FDRL * 100, 2),
                //FBSSS = FBSFH == 0 ? 0.00 : Math.Round(FBSFH / FBSRL * 100, 2),
                //TYNSS = TYNFH == 0 ? 0.00 : Math.Round(TYNFH / TYNRL * 100, 2),
                //SRZSS = SRZFH == 0 ? 0.00 : Math.Round(SRZFH / SRZRL * 100, 2)
                //HDSS = Math.Round(GetDlFh("'风电'", "PERIOD_TAG", "") / FDRL * 100, 2),
                //SDSS = Math.Round(GetDlFh("'火电'", "PERIOD_TAG", "") / HDRL * 100, 2),
                //FDSS = Math.Round(GetDlFh("'水电'", "PERIOD_TAG", "") / SDRL * 100, 2),
                //FBSSS = Math.Round(GetDlFh("'太阳能'", "PERIOD_TAG", "") / TYNRL * 100, 2),
                //TYNSS = Math.Round(GetDlFh("'分布式'", "PERIOD_TAG", "") / FBSRL * 100, 2),
                //SRZSS = Math.Round(GetDlFh("'生物质'", "PERIOD_TAG", "") / SRZRL * 100, 2)
                HDSS = Math.Round(GetRValue("风电", "电厂", "功率") / FDRL * 100, 2),
                SDSS = Math.Round(GetRValue("火电", "电厂", "功率") / HDRL * 100, 2),
                FDSS = Math.Round(GetRValue("水电", "电厂", "功率") / SDRL * 100, 2),
                FBSSS = Math.Round(GetRValue("太阳能", "电厂", "功率") / TYNRL * 100, 2),
                TYNSS = Math.Round(GetRValue("分布式", "电厂", "功率") / FBSRL * 100, 2),
                SRZSS = Math.Round(GetRValue("生物质", "电厂", "功率") / SRZRL * 100, 2)
            };


            string result = JsonConvert.SerializeObject(_obj);
            Response.Write(result);
            Response.End();
        }


        //加载负荷趋势(废弃)
        private void initCharts(string chartNum)
        {
            List<Hashtable> listData = new List<Hashtable>();
            
            //缓存数据供日均负荷使用
            ArrayList tmpSession = new ArrayList();
            Hashtable ht = new Hashtable();

            if (chartNum == "1")
            {
                ht.Add("name", "火电");
                //tmpSession=GetChartsValues("'火电'");
                //Session["hd"] = tmpSession;
                tmpSession = GetChartValues(bm.GetTagByKind("水电", "电厂", "功率"));
                ht.Add("data", tmpSession);

                listData.Add(ht);
                ht = new Hashtable();
                ht.Add("name", "风电");
                //tmpSession=GetChartsValues("'风电'");
                //ht.Add("data", tmpSession);
                tmpSession = GetChartValues(bm.GetTagByKind("风电", "电厂", "功率"));

                //Session["fd"] = tmpSession;
                listData.Add(ht);
                ht = new Hashtable();
                ht.Add("name", "水电");
                //tmpSession = GetChartsValues("'水电'");
                tmpSession = GetChartValues(bm.GetTagByKind("水电", "电厂", "功率"));

                ht.Add("data",tmpSession );
                //Session["sd"] = tmpSession;

                listData.Add(ht);

            }

            if (chartNum == "2")
            {
                ht = new Hashtable();
                ht.Add("name", "分布式");
                //tmpSession=GetChartsValues("'分布式'");
                tmpSession = GetChartValues(bm.GetTagByKind("分布式", "电厂", "功率"));
                ht.Add("data", tmpSession);
               // Session["fbs"] = tmpSession;
                
                listData.Add(ht);
                ht = new Hashtable();
                ht.Add("name", "太阳能");
                //tmpSession = GetChartsValues("'太阳能'");
                tmpSession = GetChartValues(bm.GetTagByKind("太阳能", "电厂", "功率"));
                ht.Add("data", tmpSession);
               // Session["tyn"] = tmpSession;

                listData.Add(ht);
                ht = new Hashtable();
                ht.Add("name", "生物质");
                //tmpSession = GetChartsValues("'生物质'");
                tmpSession = GetChartValues(bm.GetTagByKind("生物质", "电厂", "功率"));
                ht.Add("data", tmpSession);
               // Session["swz"] = tmpSession;

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
            int span = (ts.Hours)*2;

            for (int i = 0; i <= span; i++)
            {
                if (cy == "'总负荷'")
                    arrData.Add(Math.Round(GetDlFh1(cy, "PERIOD_TAG", stime.AddHours(i*0.5).ToString("yyyy-MM-dd HH:mm:00"))*10 + GetDlFh1("'水电'", "PERIOD_TAG", stime.AddHours(i).ToString("yyyy-MM-dd HH:mm:00")) + GetDlFh1("'火电'", "PERIOD_TAG", stime.AddHours(i).ToString("yyyy-MM-dd HH:mm:00")),3));
                else
                    arrData.Add(Math.Round(GetDlFh1(cy, "PERIOD_TAG", stime.AddHours(i * 0.5).ToString("yyyy-MM-dd HH:mm:00")), 3));
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


        //根据产业获得总电量和负荷(机组累加)
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
                ss = Math.Round(tagsValues.Sum()/10, 2);

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