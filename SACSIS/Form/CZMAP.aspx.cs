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
    public partial class CZMAP : System.Web.UI.Page
    {
        private FormBLL fbll = new FormBLL();
        private string type = "", param = "";
        private static DataTable dt = new DataTable();

        private static string ids = "";


        protected void Page_Load(object sender, EventArgs e)
        {
            if (Request["ID"] != null)
            {
                ids = Request["ID"];
            }
            param = Request["param"];
            if (param != "")
            {
                if (param == "map")
                {
                    //string id = Request["id"];
                    GetMap(ids);
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
            //标杆
            int[] flag = null;

            string x = "";
            string y = "";
            string title = "";
            //场站名称
            string periodName = string.Empty;
            if (dtmap != null && dtmap.Rows.Count > 0)
            {
                winval = new double[dtmap.Rows.Count];
                powerval = new double[dtmap.Rows.Count];
                stateval = new double[dtmap.Rows.Count];
                winpoint = new string[dtmap.Rows.Count];
                powerpoint = new string[dtmap.Rows.Count];
                statepoint = new string[dtmap.Rows.Count];
                flag = new int[dtmap.Rows.Count];
                if (dtmap.Rows[0]["T_PERIODDESC"] != DBNull.Value)
                {
                    string name = dtmap.Rows[0]["T_PERIODDESC"].ToString();
                    if (name != "全部")
                    {
                        periodName = dtmap.Rows[0]["T_PERIODDESC"].ToString();
                    }
                    else
                    {
                        periodName = dtmap.Rows[0]["T_ORGDESC"] != DBNull.Value ? dtmap.Rows[0]["T_ORGDESC"].ToString() : string.Empty;
                    }
                }
                else
                {
                    periodName = dtmap.Rows[0]["T_ORGDESC"] != DBNull.Value ? dtmap.Rows[0]["T_ORGDESC"].ToString() : string.Empty;
                }
                for (int i = 0; i < dtmap.Rows.Count; i++)
                {
                    winpoint[i] = dtmap.Rows[i][2].ToString();
                    powerpoint[i] = dtmap.Rows[i][1].ToString();
                    statepoint[i] = dtmap.Rows[i][3].ToString();
                    flag[i] =dtmap.Rows[i][6]!=DBNull.Value?int.Parse(dtmap.Rows[i][6].ToString()):0;

                    x += dtmap.Rows[i][4] + ",";
                    y += dtmap.Rows[i][5] + ",";
                    title += dtmap.Rows[i][0] != DBNull.Value ? "'" + dtmap.Rows[i][0] + "'," : "' ',";
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
                id = ids,
                x = x,
                y = y,
                win = winval,
                power = powerval,
                state = stateval,
                title = title,
                flag=flag,
                periodName=periodName
            };

            string result = Newtonsoft.Json.JsonConvert.SerializeObject(obj);
            Response.Write(result);
            Response.End();
        }
    }
}