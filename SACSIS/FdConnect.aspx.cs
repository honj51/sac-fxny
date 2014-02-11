using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using BLL;
using SAC.DBOperations;
using Newtonsoft.Json;
using System.Data;
using System.Collections;
using System.Text;

namespace WebApplication2
{
    public partial class FdConnect : System.Web.UI.Page
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
                //if (fncode == "initTable")
                //{
                //    initTable();
                //}
            }
        }

        //private void initTable()
        //{
        //    StringBuilder htmlTable = new StringBuilder();
        //    htmlTable.Append("<table id=\"Table1\" style=\"border-collapse: collapse; background-color: White; width: 985px; text-align: center; margin-left: 8px; margin-top: 2px; height: 150px\" border=\"1\">");


        //    string strTitle = "<tr><td style=\"width: 80px;\">类型</td><td style=\"width: 80px;\">风场</td><td style=\"width: 80px;\">装机容量</td><td style=\"width: 80px;\">负荷</td><td style=\"width: 80px;\">风速 </td> <td style=\"width: 80px;\">日发电量 </td><td style=\"width: 80px;\">年累计电量</td> <td style=\"width: 80px;\">运行台数</td><td style=\"width: 80px;\">停机台数</td><td style=\"width: 80px;\">投运率</td><td style=\"width: 80px;\">停机率</td><td style=\"width: 80px;\">完成率</td></tr>";
        //    htmlTable.Append(strTitle);







        //    htmlTable.Append("</table>");

        //    object _obj = new
        //    {
        //        data = htmlTable.ToString()
        //    };
        //    string result = JsonConvert.SerializeObject(_obj);
        //    Response.Write(result);
        //    Response.End();
        //}



        private void init()
        {

            double zrl = GetRl("3", "");
            double zgl = GetDl("", "3", 4,"");
            double zrdl = GetDl("", "3", 1, "");
            double zydl = GetDl("", "3", 2, "");
            double zndl = GetDl("", "3", 3, "");

            double fdjhdl = GetJHDl("MGYYQ-YQ", "2", 3) + GetJHDl("MGYEQ-EQ", "2", 3) + GetJHDl("SDFDC-QB", "2", 3) + GetJHDl("FLDFDC-QB", "2", 3);
            double fdwcl = Math.Round(zndl / fdjhdl * 100, 2);

            double mgy1fh = GetDl("MGYYQ-YQ", "2", 4, "");
            double mgy2fh = GetDl("MGYEQ-EQ", "2", 4, "");
            double fldfh = GetDl("FLDFDC-QB", "2", 4, "");
            double ssfh = GetDl("SDFDC-QB", "2", 4, "");

            double mgy1fs = GetDl("MGYYQ-YQ", "2", 5, "");
            double mgy2fs = GetDl("MGYEQ-EQ", "2", 5, "");
            double fldfs = GetDl("FLDFDC-QB", "2", 5, "");
            double ssfs = GetDl("SDFDC-QB", "2", 5, "");

            double mgy1rdl = GetDl("MGYYQ-YQ", "2", 1, "");
            double mgy2rdl = GetDl("MGYEQ-EQ", "2", 1, "");
            double fldrdl = GetDl("FLDFDC-QB", "2", 1, "");
            double ssrdl = GetDl("SDFDC-QB", "2", 1, "");

            double mgy1ydl = GetDl("MGYYQ-YQ", "2", 3, "");
            double mgy2ydl = GetDl("MGYEQ-EQ", "2", 3, "");
            double fldydl = GetDl("FLDFDC-QB", "2", 3, "");
            double ssydl = GetDl("SDFDC-QB", "2", 3, "");

            double mgy1jhdl = GetDl("MGYYQ-YQ", "2", 3, "")/GetJHDl("MGYYQ-YQ", "2", 3)*100;
            double mgy2jhdl = GetDl("MGYEQ-EQ", "2", 3, "") / GetJHDl("MGYEQ-EQ", "2", 3) * 100;
            double fldjhdl = GetDl("FLDFDC-QB", "2", 3, "") / GetJHDl("FLDFDC-QB", "2", 3) * 100;
            double ssjhdl = GetDl("SDFDC-QB", "2", 3, "") / GetJHDl("SDFDC-QB", "2", 3) * 100;


            double mgy1zts = GetState("MGYYQ-YQ", 0);
            double mgy2zts = GetState("MGYEQ-EQ", 0);
            double fldzts = GetState("FLDFDC-QB", 0);
            double sszts = GetState("SDFDC-QB", 0);

            double mgy1yxts = GetState("MGYYQ-YQ", 1);
            double mgy2yxts = GetState("MGYEQ-EQ", 1);
            double fldyxts = GetState("FLDFDC-QB", 1);
            double ssyxts = GetState("SDFDC-QB", 1);

            double mgy1tjts = GetState("MGYYQ-YQ", 2);
            double mgy2tjts = GetState("MGYEQ-EQ", 2);
            double fldtjts = GetState("FLDFDC-QB", 2);
            double sstjts = GetState("SDFDC-QB", 2);


            object _obj = new
            {
                zrl = zrl,
                zgl = Math.Round(zgl,3),
                zrdl = Math.Round(zrdl, 2),
                zydl = Math.Round(zydl, 2),
                zndl = Math.Round(zndl),
                fdwcl = fdwcl,

                mgy1fh = mgy1fh,
                mgy2fh = mgy2fh,
                fldfh = fldfh,
                ssfh = ssfh,

                mgy1fs = mgy1fs,
                mgy2fs = mgy2fs,
                fldfs = fldfs,
                ssfs = ssfs,

                mgy1rdl = mgy1rdl,
                mgy2rdl = mgy2rdl,
                fldrdl = fldrdl,
                ssrdl = ssrdl,

                mgy1ydl = mgy1ydl,
                mgy2ydl = mgy2ydl,
                fldydl = fldydl,
                ssydl = ssydl,

                mgy1jhdl = Math.Round(mgy1jhdl, 2),
                mgy2jhdl = Math.Round(mgy2jhdl, 2),
                fldjhdl = Math.Round(fldjhdl, 2),
                ssjhdl = Math.Round(ssjhdl, 2),


                

                mgy1yxts = mgy1yxts,
                mgy2yxts = mgy2yxts,
                fldyxts = fldyxts,
                ssyxts = ssyxts ,

                mgy1tjts = mgy1tjts,
                mgy2tjts = mgy2tjts,
                fldtjts = fldtjts,
                sstjts = sstjts,

                mgy1tjl = Math.Round(mgy1tjts / (mgy1zts == 0 ? 1 : mgy1zts) * 100, 2),
                mgy2tjl = Math.Round(mgy2tjts / (mgy2zts == 0 ? 1 : mgy2zts) * 100, 2),
                fldtjl = Math.Round(fldtjts / (fldzts == 0 ? 1 : fldzts) * 100, 2),
                sstjl = Math.Round(sstjts / (sszts == 0 ? 1 : sszts) * 100, 2),

                mgy1yxl = Math.Round(mgy1yxts / (mgy1zts == 0 ? 1 : mgy1zts) * 100, 2),
                mgy2yxl = Math.Round(mgy2yxts / (mgy2zts == 0 ? 1 : mgy2zts) * 100, 2),
                fldyxl = Math.Round(fldyxts / (fldzts == 0 ? 1 : fldzts) * 100, 2),
                ssyxl = Math.Round(ssyxts / (sszts == 0 ? 1 : sszts) * 100, 2)

            };


            Response.Write(JsonConvert.SerializeObject(_obj));
            Response.End();
        }

        //加载负荷趋势
        private void initCharts(string chartNum)
        {
            List<Hashtable> listData = new List<Hashtable>();

            Hashtable ht = new Hashtable();

            if (chartNum == "1")
            {
                ht = new Hashtable();
                ht.Add("name", "风电");
                ht.Add("data", GetChartsValues("'风电'"));
                listData.Add(ht);
            }

            if (chartNum == "2")
            {
                ht = new Hashtable();
                ht.Add("name", "太阳能");
                ht.Add("data", GetChartsValues("'太阳能'"));
                listData.Add(ht);
            }

            if (chartNum == "3")
            {
                ht = new Hashtable();
                ht.Add("name", "总负荷");
                ht.Add("data", GetChartsValues("'风电','太阳能'"));
                listData.Add(ht);
            }

            object _obj = new
            {
                chart = listData
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
                arrData.Add(Math.Round(GetDl("", "3", 4, stime.AddHours(i).ToString("yyyy-MM-dd HH:mm:00")), 3));
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
                sql = @"SELECT SUM(double(容量)) FROM            
                (select t.T_ORGID T_PERIODID,(select p.T_ORGID from ADMINISTRATOR.T_BASE_PERIOD p where p.T_PERIODID=t.T_ORGID) T_ORGID,t.容量
                from ADMINISTRATOR.T_INFO_RL t )
                where T_ORGID='" + id + "'";
            else if (typ == "2")
                sql = "select sum(double(容量)) from ADMINISTRATOR.T_INFO_RL  where T_ORGID='" + id + "'";
            else if (typ == "3")
                sql = "select sum(double(容量)) from ADMINISTRATOR.T_INFO_RL where T_ORGID in('MGYYQ-YQ','FLDFDC-QB','MGYEQ-EQ','SDFDC-QB')";

            object obj = dl.RunSingle(sql, out errMsg);
            if (obj == null)
                return 0;
            else
                return double.Parse(obj.ToString());
        }

        /// <summary>
        /// 获取电量 时实测点
        /// </summary>
        /// <param name="id"></param>
        /// <param name="typ">1：风场 2：工期</param>
        /// <param name="p">1:日 2：月 3：年</param>
        /// <returns></returns>
        private double GetDl(string id, string typ, int p,string  time)
        {
            string where = "";

            if (typ == "1")
                where = "tt.T_ORGID='" + id + "'";
            else if (typ == "2")
                where = "tt.T_PERIODID='" + id + "'";
            else if (typ == "3")
                where = "1=1";

            sql = @"select t.T_WINDTAG,t.T_POWERTAG, t.T_ORGID,t.T_DAYDL, t.T_MONTHDL, t.T_YEARDL
            
                    from ADMINISTRATOR.T_BASE_POINTS_ORG t 
                    
                    where t.T_ORGID in (select T_PERIODID from ADMINISTRATOR.T_BASE_PERIOD tt where " + where + ")";


            DataTable SSDl = dl.RunDataTable(sql, out errMsg);
            string dlTyp = "";
            string searchTime = "";
            if (p == 1)
            {
                dlTyp = "T_DAYDL";
                searchTime = DateTime.Now.ToString("yyyy-MM-dd 0:00:00");
            }
            if (p == 2)
            {
                dlTyp = "T_MONTHDL";
                searchTime = DateTime.Now.ToString("yyyy-MM-1 0:00:00");
            }
            if (p == 3)
            {
                dlTyp = "T_YEARDL";
                searchTime = DateTime.Now.ToString("yyyy-1-1 0:00:00");
            }
            if (p == 4)
            {
                dlTyp = "T_POWERTAG";
                if (time != "")
                    searchTime = time;
                else
                    searchTime = DateTime.Now.ToString("yyyy-MM-dd HH:mm:00");
            }
            if (p == 5)
            {
                dlTyp = "T_WINDTAG";
                searchTime = DateTime.Now.ToString("yyyy-MM-dd HH:mm:00");
            }


            string[] tag = new string[SSDl.Rows.Count];
            for (int aa = 0; aa < SSDl.Rows.Count; aa++)
            {
                tag[aa] = SSDl.Rows[aa][dlTyp].ToString();
            }
            double[] tagValues = pbll.GetPointVal(tag, searchTime);

            double v = 0;
            for (int bb = 0; bb < tagValues.Length; bb++)
            {
                v = v + tagValues[bb];
            }

            if (tagValues.Length < 1)
                return 0;
            else
                return v;
        }


        /// <summary>
        /// 获取计划电量
        /// </summary>
        /// <param name="id"></param>
        /// <param name="typ"></param>
        /// <param name="p"></param>
        /// <returns></returns>
        private double GetJHDl(string id, string typ, int p)
        {
            string Column = "";
            string where = "";
            if (p == 2)
                Column = "计划发电量" + DateTime.Now.Month.ToString() + " ";
            if (p == 3)
                Column = "年计划发电量 ";
            if (typ == "1")
                where = "tt.T_ORGID='" + id + "'";
            else if (typ == "2")
                where = "tt.T_PERIODID='" + id + "'";

            sql = "select SUM(double(" + Column + "))";
            sql += "from ADMINISTRATOR.T_INFO_JHDL t where t.T_ORGID in ";
            sql += "(select T_PERIODID from ADMINISTRATOR.T_BASE_PERIOD tt where " + where + ")";
            object objJHDL = dl.RunSingle(sql, out errMsg);

            if (objJHDL == null)
                return 0;
            else
                return double.Parse(objJHDL.ToString());
        }


        private double GetState(string pid, double typ)
        {
            sql = @"select count(0) from  ADMINISTRATOR.T_INFO_VALUE 
                    where T_POINT in(SELECT T_OUTTAG FROM ADMINISTRATOR.T_STATE_POINT where T_PERIODID='" + pid + "' )";
            if (typ != 0)
                sql += " and T_VALUE=" + typ;

            object allCount = dl.RunSingle(sql, out errMsg);
            if (allCount != null)
                return double.Parse(allCount.ToString());
            else
                return 0;
        }
    }
}