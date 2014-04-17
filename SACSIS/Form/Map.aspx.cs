using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using BLL;
using System.Data;
using System.Xml;

namespace SACSIS.Form
{
    public partial class Map : System.Web.UI.Page
    {
        private FormBLL fbll = new FormBLL();
        private string type = "", param = "";
        private static DataTable dt = new DataTable();
        //map.xml中区域ID
       

        protected void Page_Load(object sender, EventArgs e)
        {
            param = Request["param"];
            if (Request.QueryString["ID"] != null)
            {
                Session["ID"] = Request.QueryString["ID"];
            }
            if (param != "")
            {
                if (param == "Init")
                {
                    GetTreeList("风电",Session["ID"].ToString());
                }
            }
           
        }


        string PTreeNodes = "";
        private void GetTreeList(string type,string areaId)
        {
            dt = new DataTable();
            GetTreeList();
            string x = "";
            string y = "";
            string title = "";
            string id = "";

            DataRow[] dr = dt.Select("TYPE='" + type + "' and PID='"+areaId+"'");

            for (int i = 0; i < dr.Length; i++)
            {
                if (i == 0)
                {
                    PTreeNodes += "{id:'" + dr[i][0] + "',pId:'" + dr[i][2] + "',name:'" + dr[i][1] + "',t:'" + dr[i][4] + "',open:true},";
                    if (dr[i][5].ToString() != "")
                    {
                        x += dr[i][5] + ",";
                        y += dr[i][6] + ",";
                        title += "'" + dr[i][1] + "',";
                        id += "'" + dr[i][0] + "',";
                    }
                }
                else
                {
                    PTreeNodes += "{id:'" + dr[i][0] + "',pId:'" + dr[i][2] + "',name:'" + dr[i][1] + "',t:'" + dr[i][4] + "'},";
                    if (dr[i][5].ToString() != "")
                    {
                        x += dr[i][5] + ",";
                        y += dr[i][6] + ",";
                        title += "'" + dr[i][1] + "',";
                        id += "'" + dr[i][0] + "',";
                    }
                }
            }



            PTreeNodes = PTreeNodes.TrimEnd(',');
            x = x.TrimEnd(',');
            y = y.TrimEnd(',');
            title = title.TrimEnd(',');
            id = id.TrimEnd(',');

            DataTable dtp = fbll.GetPointCompanyByPeriodID(id);

            x = "[" + x + "]";
            y = "[" + y + "]";
            title = "[" + title + "]";

            double[] winval = null;
            double[] powerval = null;
            string[] winpoint = null;
            string[] powerpoint = null;
            PointBLL po = new PointBLL();
            if (dtp != null && dtp.Rows.Count > 0)
            {
                winval = new double[dtp.Rows.Count];
                powerval = new double[dtp.Rows.Count];
                winpoint = new string[dtp.Rows.Count];
                powerpoint = new string[dtp.Rows.Count];

                for (int i = 0; i < dtp.Rows.Count; i++)
                {
                    winpoint[i] = dtp.Rows[i][0].ToString();
                    powerpoint[i] = dtp.Rows[i][1].ToString();
                }

                winval = po.GetPointVal(winpoint, DateTime.Now.ToString("yyyy-MM-dd HH:mm:00"));
                powerval = po.GetPointVal(powerpoint, DateTime.Now.ToString("yyyy-MM-dd HH:mm:00"));
            }


            object obj = new
            {
                treeNode = PTreeNodes,
                x = x,
                y = y,
                win = winval,
                power = powerval,
                title = title
            };

            string result = Newtonsoft.Json.JsonConvert.SerializeObject(obj);
            Response.Write(result);
            Response.End();
        }

        #region 获取 DatTable Tree

        /// <summary>
        /// 获取 DatTable Tree
        /// </summary>
        private void GetTreeList()
        {
            XmlTextReader reader = new XmlTextReader(
              Server.MapPath("../xml/map.xml"));

            reader.WhitespaceHandling = WhitespaceHandling.None;
            XmlDocument xmlDoc = new XmlDocument();
            //将文件加载到XmlDocument对象中
            xmlDoc.Load(reader);

            //关闭连接
            reader.Close();

            XmlNode xnod = xmlDoc.DocumentElement;

            if (!dt.Columns.Contains("ID"))
                dt.Columns.Add("ID");
            if (!dt.Columns.Contains("NAME"))
                dt.Columns.Add("NAME");
            if (!dt.Columns.Contains("PID"))
                dt.Columns.Add("PID");
            if (!dt.Columns.Contains("FULLNAME"))
                dt.Columns.Add("FULLNAME");
            if (!dt.Columns.Contains("TYPE"))
                dt.Columns.Add("TYPE");
            if (!dt.Columns.Contains("X"))
                dt.Columns.Add("X");
            if (!dt.Columns.Contains("Y"))
                dt.Columns.Add("Y");

            XmlToDataTable(xnod);
        }
        private void XmlToDataTable(XmlNode xnod)
        {
            DataRow dr = dt.NewRow();
            XmlNode xnodWorking;

            //如果是元素节点，获取它的属性
            if (xnod.NodeType == XmlNodeType.Element)
            {
                XmlNamedNodeMap mapAttributes = xnod.Attributes;
                if (mapAttributes.Count > 0)
                {
                    dr[0] = mapAttributes.Item(0).Value;
                    dr[1] = mapAttributes.Item(1).Value;
                    dr[2] = mapAttributes.Item(2).Value;
                    dr[3] = mapAttributes.Item(3).Value;
                    dr[4] = mapAttributes.Item(4).Value;
                    dr[5] = mapAttributes.Item(5).Value;
                    dr[6] = mapAttributes.Item(6).Value;
                    dt.Rows.Add(dr);
                }

                //如果还有子节点，就递归地调用这个程序
                if (xnod.HasChildNodes)
                {
                    xnodWorking = xnod.FirstChild;
                    while (xnodWorking != null)
                    {
                        XmlToDataTable(xnodWorking);
                        xnodWorking = xnodWorking.NextSibling;
                    }
                }
            }
        }
        #endregion
    }
}