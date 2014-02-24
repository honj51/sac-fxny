using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SAC.DBOperations;
using System.Collections;

namespace SACSIS.Form
{
    public partial class InstalledPowerRatio : System.Web.UI.Page
    {
        DBLink dl = new DBLink();
        string errMsg = "";

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
            object obj = new
            {
                zjBl = zjBl
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
    }
}