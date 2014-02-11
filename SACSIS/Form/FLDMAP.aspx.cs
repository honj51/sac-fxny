using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using BLL;
using System.Data;

namespace SACSIS.Form
{
    public partial class FLDMAP : System.Web.UI.Page
    {
        private FormBLL fbll = new FormBLL();
        private string type = "", param = "";
        private static DataTable dt = new DataTable();
        protected void Page_Load(object sender, EventArgs e)
        {
            param = Request["param"];
            if (param != "")
            {
                if (param == "map")
                {
                    string id = Request["id"];
                    GetMap(id);
                }
            }
        }

        private void GetMap(string id)
        {
            DataTable dtmap = new DataTable();
            dtmap = fbll.GetPointByPeriodID(id);
            double[] winval = null;
            double[] powerval = null;
            double[] stateval = null;
            string[] winpoint = null;
            string[] powerpoint = null;
            string[] statepoint = null;
            string x = "";
            string y = "";
            string title = "";

            if (dtmap != null && dtmap.Rows.Count > 0)
            {
                winval = new double[dtmap.Rows.Count];
                powerval = new double[dtmap.Rows.Count];
                stateval = new double[dtmap.Rows.Count];
                winpoint = new string[dtmap.Rows.Count];
                powerpoint = new string[dtmap.Rows.Count];
                statepoint = new string[dtmap.Rows.Count];

                for (int i = 0; i < dtmap.Rows.Count; i++)
                {
                    winpoint[i] = dtmap.Rows[i][2].ToString();
                    powerpoint[i] = dtmap.Rows[i][1].ToString();
                    statepoint[i] = dtmap.Rows[i][3].ToString();
                    x += dtmap.Rows[i][4] + ",";
                    y += dtmap.Rows[i][5] + ",";
                    title += "'" + dtmap.Rows[i][0] + "',";
                }

                x = x.TrimEnd(',');
                y = y.TrimEnd(',');
                title = title.TrimEnd(',');

                x = "[" + x + "]";
                y = "[" + y + "]";
                title = "[" + title + "]";

                PointBLL po = new PointBLL();
                winval = po.GetPointVal(winpoint, DateTime.Now.ToString("yyyy-MM-dd HH:mm:00"));
                powerval = po.GetPointVal(powerpoint, DateTime.Now.ToString("yyyy-MM-dd HH:mm:00"));
                stateval = po.GetPointVal(statepoint, DateTime.Now.ToString("yyyy-MM-dd HH:mm:00"));

            }

            object obj = new
            {
                x = x,
                y = y,
                win = winval,
                power = powerval,
                state = stateval,
                title = title
            };

            string result = Newtonsoft.Json.JsonConvert.SerializeObject(obj);
            Response.Write(result);
            Response.End();
        }
    }
}