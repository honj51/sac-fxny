using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SAC.DBOperations;
using System.Data;
using System.Text;
using System.Collections;
using Newtonsoft.Json;
using BLL;
using System.Globalization;
using BLL.Connect;
//using BLL.Yyzl;
namespace SACSIS
{
    public partial class JZInfo : System.Web.UI.Page
    {
        string sql = "";
        string errMsg = "";

        DBLink dl = new DBLink();
        PointBLL pbll = new PointBLL();
        PointsBLL pbsll = new PointsBLL();

        BLLConnect bc = new BLLConnect();
       // BLLJZInfo bj = new BLLJZInfo();

        Dictionary<string, double> PointValues = new Dictionary<string, double>();
        Dictionary<string, double> PointValuesPerion = new Dictionary<string, double>();

        string dataType = "";
        string cyTye = "";
        string colrow = "";
        public string imgsrc = "../img/电站总览.jpg";
        string idKey = string.Empty;
        protected void Page_Load(object sender, EventArgs e)
        {
            string funCode = Request["funCode"];
            cyTye = Request["dataType"];
            //cyTye = "fd";
            switch (cyTye)
            {
                case "fd":
                    dataType = " where DATA_TYPE='风电'";
                    imgsrc = "../img/czlb.jpg";
                    colrow = "20";
                    break;
                case "tyn":
                    dataType = " where DATA_TYPE='太阳能'";
                    imgsrc = "../img/dlzl.jpg";
                    colrow = "20";
                    break;
                case "sd":
                    dataType = " where DATA_TYPE='水电'";
                    colrow = "6";
                    break;
                case "hd":
                    dataType = " where DATA_TYPE='火电'";
                    colrow = "4";
                    break;
                case "fbs":
                    dataType = " where DATA_TYPE='分布式'";
                    colrow = "2";
                    break;
                case "swz":
                    dataType = " where DATA_TYPE='生物质'";
                    colrow = "2";
                    break;
                default:
                    dataType = " where 1=1";
                    colrow = "20";
                    break;
            }

            if (!string.IsNullOrWhiteSpace(funCode))
            {
                if (funCode == "init")
                {
                    LoadPointValue();
                    LoadData();
                }
            }
            if (!string.IsNullOrEmpty(Request["idKey"]))
            {
                idKey = Request["idKey"].ToString();
            }
            string para = Request["para"];
            if (!string.IsNullOrEmpty(para))
            {
                if (para == "unit")
                {
                    BackContent(idKey);
                }
            }
        }

        /// <summary>
        /// 初始化机组信息
        /// </summary>
        private void LoadData()
        {
            StringBuilder htmlTable = new StringBuilder();
            htmlTable.Append("<table cellSpacing='0' cellPadding='0' width ='1100px' border='1'>");
            string strTitle = "<tr style='background-color: #CFE6FC; line-height:35px'><td style='width:100px;'>区域</td><td style='width:100px;'>电站</td><td  style='width:120px'>出力（万kw）</td><td  style='width:100px'>机型</td><td style='width:920px' colspan='" + colrow + "'>机组</td></tr>";
            htmlTable.Append(strTitle);
            string str = "";
            string str2 = "";
            string str3 = "";
            string str4 = "";

            //sql = "select DISTINCT PERIOD_NAME,PERIOD_TAG,T_ORDER,T_AREA from (select * from ADMINISTRATOR.T_INFO_UNIT  " + dataType + ")  order by T_AREA,T_ORDER";
            //DataTable dtNames = dl.RunDataTable(sql, out errMsg);

            string sqlArea = "select DISTINCT T_AREA from (select T_AREA from ADMINISTRATOR.T_INFO_UNIT   " + dataType + ")  order by T_AREA ";
            DataTable dtArea = dl.RunDataTable(sqlArea, out errMsg);

            for (int a = 0; a < dtArea.Rows.Count; a++)
            {
                string areaSql = "select DISTINCT PERIOD_NAME,PERIOD_TAG,T_ORDER,T_AREA from (select * from ADMINISTRATOR.T_INFO_UNIT " + dataType + " and T_AREA='" + dtArea.Rows[a][0].ToString() + "')";
                DataTable dtAreas = dl.RunDataTable(areaSql, out errMsg);
                double areaRows = 0;
                //具体区域列合并多少行 根据机组数量除以机组的列数
                //for (int j = 0; j < dtAreas.Rows.Count; j++)
                //{
                sql = "select DISTINCT PERIOD_NAME,PERIOD_TAG,T_ORDER,T_AREA,UNIT_FACTORY from (select * from ADMINISTRATOR.T_INFO_UNIT  " + dataType + " and T_AREA='" + dtArea.Rows[a][0].ToString() + "')  order by T_AREA,T_ORDER";
                DataTable dtNamesa = dl.RunDataTable(sql, out errMsg);
                for (int jj = 0; jj < dtNamesa.Rows.Count; jj++)
                {
                    sql = "select DISTINCT UNIT_FACTORY from (select * from ADMINISTRATOR.T_INFO_UNIT " + dataType + " and T_AREA='" + dtArea.Rows[a][0].ToString() + "' and PERIOD_NAME='" + dtNamesa.Rows[jj][0].ToString() + "') ";

                    DataTable dtUnits = dl.RunDataTable(sql, out errMsg);

                    for (int b = 0; b < dtUnits.Rows.Count; b++)
                    {

                        if (dtUnits.Rows[b]["UNIT_FACTORY"] != DBNull.Value)
                        {
                            sql = "select * from ADMINISTRATOR.T_INFO_UNIT " + dataType + " and T_AREA='" + dtArea.Rows[a][0].ToString() + "'  and PERIOD_NAME='" + dtNamesa.Rows[jj][0].ToString() + "' and UNIT_FACTORY='" + dtUnits.Rows[b]["UNIT_FACTORY"].ToString() + "' order by INT(UNIT_ID)";
                        }
                        else
                        {
                            sql = "select * from ADMINISTRATOR.T_INFO_UNIT " + dataType + " and T_AREA='" + dtArea.Rows[a][0].ToString() + "' and PERIOD_NAME='" + dtNamesa.Rows[jj][0].ToString() + "' and UNIT_FACTORY IS NULL ";//order by INT(UNIT_ID)";

                        }
                        DataTable dtType = new DataTable();
                        dtType = dl.RunDataTable(sql, out errMsg);

                        areaRows += (Math.Ceiling((double)dtType.Rows.Count / double.Parse(colrow.ToString()))) * 2;
                    }
                }
                //}
                //风电的区域，场站 可以跳转
                if (cyTye == "fd")
                {
                    str += "<tr><td style='text-align:left' rowspan=\"" + areaRows + "\"><a type='2' href='#' onclick='next(this)'>" + dtArea.Rows[a]["T_AREA"].ToString() + "</a></td>";
                }
                else
                {
                    str += "<tr><td style='text-align:left' rowspan=\"" + areaRows + "\">" + dtArea.Rows[a]["T_AREA"].ToString() + "</td>";
                }

                sql = "select DISTINCT PERIOD_NAME,PERIOD_TAG,T_ORDER,T_AREA,UNIT_FACTORY from (select * from ADMINISTRATOR.T_INFO_UNIT  " + dataType + " and T_AREA='" + dtArea.Rows[a][0].ToString() + "')  order by T_AREA,T_ORDER";
                DataTable dtNames = dl.RunDataTable(sql, out errMsg);
                for (int jj = 0; jj < dtNames.Rows.Count; jj++)
                {
                    //sql = "select * from ADMINISTRATOR.T_INFO_UNIT " + dataType + " and T_AREA='" + dtArea.Rows[a][0].ToString() + "' and PERIOD_NAME='" + dtNames.Rows[j][0].ToString() + "' order by INT(UNIT_ID)";
                    sql = "select DISTINCT UNIT_FACTORY from (select * from ADMINISTRATOR.T_INFO_UNIT " + dataType + " and T_AREA='" + dtArea.Rows[a][0].ToString() + "' and PERIOD_NAME='" + dtNamesa.Rows[jj][0].ToString() + "') ";

                    DataTable dtUnitss = dl.RunDataTable(sql, out errMsg);
                    double rowspans = 0;
                    for (int d = 0; d < dtUnitss.Rows.Count; d++)
                    {
                        if (dtUnitss.Rows[d]["UNIT_FACTORY"] != DBNull.Value)
                        {
                            sql = "select * from ADMINISTRATOR.T_INFO_UNIT " + dataType + " and T_AREA='" + dtArea.Rows[a][0].ToString() + "' and PERIOD_NAME='" + dtNames.Rows[jj][0].ToString() + "' and UNIT_FACTORY='" + dtUnitss.Rows[d]["UNIT_FACTORY"].ToString() + "' order by INT(UNIT_ID)";
                        }
                        else
                        {
                            sql = "select * from ADMINISTRATOR.T_INFO_UNIT " + dataType + " and T_AREA='" + dtArea.Rows[a][0].ToString() + "' and PERIOD_NAME='" + dtNames.Rows[jj][0].ToString() + "' and UNIT_FACTORY IS NULL ";// order by INT(UNIT_ID)";

                        }
                        DataTable dtType = dl.RunDataTable(sql, out errMsg);

                        rowspans += (Math.Ceiling((double)dtType.Rows.Count / double.Parse(colrow.ToString()))) * 2;
                    }
                    //double rowspan = Math.Ceiling((double)dtUnits.Rows.Count / double.Parse(colrow.ToString()));

                    //出力合并行
                    if (cyTye == "fd")
                    {
                        str += "<td style='text-align:left' rowspan=\"" + rowspans + "\"><a type='3' area='" + dtNames.Rows[jj]["T_AREA"].ToString() + "' href='#' onclick='next(this)'>" + dtNames.Rows[jj][0].ToString() + "</a></td><td  style='text-align:right' rowspan=\"" + rowspans + "\">" + Math.Round(PointValuesPerion.ContainsKey(dtNames.Rows[jj][0].ToString())?PointValuesPerion[dtNames.Rows[jj][0].ToString()]:0, 3) + "</td>";
                    }
                    else
                    {
                        str += "<td style='text-align:left' rowspan=\"" + rowspans + "\">" + dtNames.Rows[jj][0].ToString() + "</td><td  style='text-align:right' rowspan=\"" + rowspans + "\">" + Math.Round(PointValuesPerion.ContainsKey(dtNames.Rows[jj][0].ToString())?PointValuesPerion[dtNames.Rows[jj][0].ToString()]:0, 3) + "</td>";
                    }



                    for (int p = 0; p < dtUnitss.Rows.Count; p++)
                    {
                        double rowspan = 0;
                        string sql2 = string.Empty;
                        if (dtUnitss.Rows[p]["UNIT_FACTORY"] != DBNull.Value)
                        {
                            sql = "select distinct  ID_KEY ,UNIT_FACTORY,PERIOD_NAME,UNIT_GL_TAG,UNIT_ID,T_WINDTAG from (select U.I_FLAG, T.*,P.T_WINDTAG from ADMINISTRATOR.T_INFO_UNIT AS T  LEFT JOIN  ADMINISTRATOR.T_BASE_POINTS AS P  ON T.UNIT_GL_TAG=P.T_POWERTAG  LEFT JOIN ADMINISTRATOR.T_BASE_UNIT AS U ON P.T_UNITID=U.T_UNITID" + dataType + " and T.T_AREA='" + dtArea.Rows[a][0].ToString() + "' and T.PERIOD_NAME='" + dtNames.Rows[jj][0].ToString() + "' and T.UNIT_FACTORY='" + dtUnitss.Rows[p]["UNIT_FACTORY"].ToString() + "' order by INT(T.UNIT_ID))";
                            sql2 = "select distinct  ID_KEY ,I_FLAG,UNIT_FACTORY,PERIOD_NAME,UNIT_GL_TAG,UNIT_ID from (select U.I_FLAG, T.* from ADMINISTRATOR.T_INFO_UNIT AS T  LEFT JOIN  ADMINISTRATOR.T_BASE_POINTS AS P  ON T.UNIT_GL_TAG=P.T_POWERTAG  LEFT JOIN ADMINISTRATOR.T_BASE_UNIT AS U ON P.T_UNITID=U.T_UNITID" + dataType + " and T.T_AREA='" + dtArea.Rows[a][0].ToString() + "' and T.PERIOD_NAME='" + dtNames.Rows[jj][0].ToString() + "' and T.UNIT_FACTORY='" + dtUnitss.Rows[p]["UNIT_FACTORY"].ToString() + "' order by INT(T.UNIT_ID))";
                        }
                        else
                        {
                            sql = "select distinct  ID_KEY,UNIT_FACTORY,PERIOD_NAME,UNIT_GL_TAG,UNIT_ID,T_WINDTAG from ( select U.I_FLAG, T.*,P.T_WINDTAG  from ADMINISTRATOR.T_INFO_UNIT AS T  LEFT JOIN  ADMINISTRATOR.T_BASE_POINTS AS P  ON T.UNIT_GL_TAG=P.T_POWERTAG  LEFT JOIN ADMINISTRATOR.T_BASE_UNIT AS U ON P.T_UNITID=U.T_UNITID" + dataType + " and T.T_AREA='" + dtArea.Rows[a][0].ToString() + "' and T.PERIOD_NAME='" + dtNames.Rows[jj][0].ToString() + "' and T.UNIT_FACTORY IS NULL order by INT(T.UNIT_ID))";
                            sql2 = "select distinct  ID_KEY ,I_FLAG,UNIT_FACTORY,PERIOD_NAME,UNIT_GL_TAG,UNIT_ID from ( select U.I_FLAG, T.*  from ADMINISTRATOR.T_INFO_UNIT AS T  LEFT JOIN  ADMINISTRATOR.T_BASE_POINTS AS P  ON T.UNIT_GL_TAG=P.T_POWERTAG  LEFT JOIN ADMINISTRATOR.T_BASE_UNIT AS U ON P.T_UNITID=U.T_UNITID" + dataType + " and T.T_AREA='" + dtArea.Rows[a][0].ToString() + "' and T.PERIOD_NAME='" + dtNames.Rows[jj][0].ToString() + "' and T.UNIT_FACTORY IS NULL order by INT(T.UNIT_ID))";
                        }
                        DataTable dtType = dl.RunDataTable(sql, out errMsg);
                        //带I_FLAG
                        DataTable dtType2 = dl.RunDataTable(sql2, out errMsg);
                        DataRow[] DDDD = dtType2.Select("I_FLAG=1");
                        //保存标杆风机的ID_KEY
                        List<string> id = new List<string>();
                        foreach (DataRow drr in DDDD)
                        {
                            id.Add(drr["ID_KEY"].ToString());
                        }

                        rowspan = Math.Ceiling(((double)dtType.Rows.Count) / double.Parse(colrow.ToString()));
                        str += "<td style='text-align:left' rowspan=\"" + rowspan * 2 + "\">" + dtUnitss.Rows[p]["UNIT_FACTORY"] + "</td>";
                        int rows = Int32.Parse((rowspan * double.Parse(colrow.ToString())).ToString());
                        for (int k = 1; k <= rows; k++)
                        {
                            if (k > dtType.Rows.Count)
                            {
                                if (k % double.Parse(colrow.ToString()) == 0 && k != 0)
                                {
                                    str += "<td  style='width:41px'>&nbsp;</td></tr>";
                                    str2 += "<td>&nbsp;</td></tr>";
                                    htmlTable.Append(str);
                                    htmlTable.Append(str2);
                                    str = "<tr>";
                                    str2 = "<tr>";
                                }
                                else
                                {
                                    str += "<td>&nbsp;</td>";
                                    str2 += "<td>&nbsp;</td>";
                                }
                            }
                            else
                            {
                                if (k % double.Parse(colrow.ToString()) == 0 && k != 0)
                                {
                                    if (dtType.Rows[k - 1]["PERIOD_NAME"].ToString() == "南宁华南城" || dtType.Rows[k - 1]["PERIOD_NAME"].ToString() == "天津北辰" || dtType.Rows[k - 1]["PERIOD_NAME"].ToString() == "九江")
                                    {
                                        str += "<td  style='width:41px'>&nbsp;</td></tr>";
                                        str2 += "<td>&nbsp;</td></tr>";
                                        htmlTable.Append(str);
                                        htmlTable.Append(str2);
                                        str = "<tr>";
                                        str2 = "<tr>";
                                    }
                                    else
                                    {
                                        //风电
                                        if (cyTye == "fd")
                                        {
                                            //风速
                                            double value = PointValues.ContainsKey(dtType.Rows[k - 1]["T_WINDTAG"].ToString())?PointValues[dtType.Rows[k - 1]["T_WINDTAG"].ToString()]:0;
                                            //是否是标杆风机
                                            if (id.Contains(dtType.Rows[k - 1]["ID_KEY"].ToString()))
                                            {
                                                if (value <= 3)
                                                {
                                                    str += "<td  style='width:41px;color:Red;background-color: #B3D6FD;'  title='风速:" + value + ";负荷:" + Math.Round(PointValues.ContainsKey(dtType.Rows[k - 1]["UNIT_GL_TAG"].ToString())?PointValues[dtType.Rows[k - 1]["UNIT_GL_TAG"].ToString()]:0, 3) + "'><a type='4' idkey='" + dtType.Rows[k - 1]["ID_KEY"].ToString() + "' href='#' style='text-decoration:none;color:Red;' onclick='tc(this)'>#" + dtType.Rows[k - 1]["UNIT_ID"] + "</a> </td></tr>";

                                                }
                                                else if (value >= 3 && value <= 12)
                                                {
                                                    str += "<td  style='width:41px;color:Red;background-color: #ACE066;'  title='风速:" + value + ";负荷:" + Math.Round(PointValues.ContainsKey(dtType.Rows[k - 1]["UNIT_GL_TAG"].ToString())?PointValues[dtType.Rows[k - 1]["UNIT_GL_TAG"].ToString()]:0, 3) + "'><a type='4' idkey='" + dtType.Rows[k - 1]["ID_KEY"].ToString() + "' href='#' style='text-decoration:none;color:Red;' onclick='tc(this)'>#" + dtType.Rows[k - 1]["UNIT_ID"] + "</a></td></tr>";
                                                }
                                                else if (value > 12 && value <= 25)
                                                {
                                                    str += "<td  style='width:41px;color:Red;background-color: #64C45C;'   title='风速:" + value + ";负荷:" + Math.Round(PointValues.ContainsKey(dtType.Rows[k - 1]["UNIT_GL_TAG"].ToString())?PointValues[dtType.Rows[k - 1]["UNIT_GL_TAG"].ToString()]:0, 3) + "'><a type='4' idkey='" + dtType.Rows[k - 1]["ID_KEY"].ToString() + "' href='#' style='text-decoration:none;color:Red;' onclick='tc(this)'>#" + dtType.Rows[k - 1]["UNIT_ID"] + "</a></td></tr>";
                                                }
                                                else if (value > 25)
                                                {
                                                    str += "<td  style='width:41px;color:Red;background-color: #9C7DC1;'  title='风速:" + value + ";负荷:" + Math.Round(PointValues.ContainsKey(dtType.Rows[k - 1]["UNIT_GL_TAG"].ToString()) ? PointValues[dtType.Rows[k - 1]["UNIT_GL_TAG"].ToString()] : 0, 3) + "'><a type='4' idkey='" + dtType.Rows[k - 1]["ID_KEY"].ToString() + "' href='#' style='text-decoration:none;color:Red;' onclick='tc(this)'>#" + dtType.Rows[k - 1]["UNIT_ID"] + "</a></td></tr>";
                                                }
                                                //str += "<td  style='width:41px;color:Red;'>#" + dtType.Rows[k - 1]["UNIT_ID"] + "</td></tr>";
                                            }
                                            else
                                            {
                                                if (value <= 3)
                                                {
                                                    str += "<td  style='width:41px; background-color: #B3D6FD;'  title='风速:" + value + ";负荷:" + Math.Round(PointValues.ContainsKey(dtType.Rows[k - 1]["UNIT_GL_TAG"].ToString())?PointValues[dtType.Rows[k - 1]["UNIT_GL_TAG"].ToString()]:0, 3) + "'><a type='4' idkey='" + dtType.Rows[k - 1]["ID_KEY"].ToString() + "' href='#' style='text-decoration:none;' onclick='tc(this)'>#" + dtType.Rows[k - 1]["UNIT_ID"] + "</a></td></tr>";

                                                }
                                                else if (value >= 3 && value <= 12)
                                                {
                                                    str += "<td  style='width:41px; background-color: #ACE066;'  title='风速:" + value + ";负荷:" + Math.Round(PointValues.ContainsKey(dtType.Rows[k - 1]["UNIT_GL_TAG"].ToString())?PointValues[dtType.Rows[k - 1]["UNIT_GL_TAG"].ToString()]:0, 3) + "'><a type='4' idkey='" + dtType.Rows[k - 1]["ID_KEY"].ToString() + "' href='#' style='text-decoration:none;' onclick='tc(this)'>#" + dtType.Rows[k - 1]["UNIT_ID"] + "</a></td></tr>";
                                                }
                                                else if (value > 12 && value <= 25)
                                                {
                                                    str += "<td  style='width:41px; background-color: #64C45C;'  title='风速:" + value + ";负荷:" + Math.Round(PointValues.ContainsKey(dtType.Rows[k - 1]["UNIT_GL_TAG"].ToString())?PointValues[dtType.Rows[k - 1]["UNIT_GL_TAG"].ToString()]:0, 3) + "'><a type='4' idkey='" + dtType.Rows[k - 1]["ID_KEY"].ToString() + "' href='#' style='text-decoration:none;' onclick='tc(this)'>#" + dtType.Rows[k - 1]["UNIT_ID"] + "</a></td></tr>";
                                                }
                                                else if (value > 25)
                                                {
                                                    str += "<td  style='width:41px; background-color: #9C7DC1;'  title='风速:" + value + ";负荷:" + Math.Round(PointValues.ContainsKey(dtType.Rows[k - 1]["UNIT_GL_TAG"].ToString()) ? PointValues[dtType.Rows[k - 1]["UNIT_GL_TAG"].ToString()] : 0, 3) + "'><a type='4' idkey='" + dtType.Rows[k - 1]["ID_KEY"].ToString() + "' href='#' style='text-decoration:none;' onclick='tc(this)'>#" + dtType.Rows[k - 1]["UNIT_ID"] + "</a></td></tr>";
                                                }
                                                //str += "<td  style='width:41px;'>#" + dtType.Rows[k - 1]["UNIT_ID"].ToString() + "</td></tr>";
                                            }
                                        }
                                        else
                                        {
                                            str += "<td  style='width:41px; ' >#" + dtType.Rows[k - 1]["UNIT_ID"] + "</td></tr>";
                                        }
                                        if (PointValues.ContainsKey(dtType.Rows[k - 1]["UNIT_GL_TAG"].ToString()))
                                        {
                                            if (PointValues[dtType.Rows[k - 1]["UNIT_GL_TAG"].ToString()] < 0)
                                                str2 += "<td style='background-color: yellow;text-align:right'>" + PointValues[dtType.Rows[k - 1]["UNIT_GL_TAG"].ToString()] + "</td></tr>";
                                            else
                                                str2 += "<td >" + Math.Round(PointValues[dtType.Rows[k - 1]["UNIT_GL_TAG"].ToString()], 3) + "</td></tr>";
                                        }
                                        else
                                        {
                                            str2 += "<td >0</td></tr>";
                                        }
                                        htmlTable.Append(str);
                                        htmlTable.Append(str2);
                                        str = "<tr>";
                                        str2 = "<tr>";
                                    }
                                }
                                else
                                {
                                    if (dtType.Rows[k - 1]["PERIOD_NAME"].ToString() == "南宁华南城" || dtType.Rows[k - 1]["PERIOD_NAME"].ToString() == "天津北辰" || dtType.Rows[k - 1]["PERIOD_NAME"].ToString() == "九江")
                                    {
                                        str += "<td  style='width:41px'>&nbsp;</td>";
                                        str2 += "<td>&nbsp;</td>";
                                    }
                                    else
                                    {
                                          //风电
                                        if (cyTye == "fd")
                                        {
                                            //风速
                                            double value = PointValues.ContainsKey(dtType.Rows[k - 1]["T_WINDTAG"].ToString())?PointValues[dtType.Rows[k - 1]["T_WINDTAG"].ToString()]:0;

                                            if (id.Contains(dtType.Rows[k - 1]["ID_KEY"].ToString()))
                                            {
                                                if (value <= 3)
                                                {
                                                    str += "<td  style='width:41px;color:Red;background-color: #B3D6FD;' title='风速:" + value + ";负荷:" + Math.Round(PointValues.ContainsKey(dtType.Rows[k - 1]["UNIT_GL_TAG"].ToString())?PointValues[dtType.Rows[k - 1]["UNIT_GL_TAG"].ToString()]:0, 3) + "'><a type='4' idkey='" + dtType.Rows[k - 1]["ID_KEY"].ToString() + "' href='#' style='text-decoration:none;color:Red;' onclick='tc(this)'>#" + dtType.Rows[k - 1]["UNIT_ID"] + "</a></td>";

                                                }
                                                else if (value >= 3 && value <= 12)
                                                {
                                                    str += "<td  style='width:41px;color:Red;background-color: #ACE066;' title='风速:" + value + ";负荷:" + Math.Round(PointValues.ContainsKey(dtType.Rows[k - 1]["UNIT_GL_TAG"].ToString())?PointValues[dtType.Rows[k - 1]["UNIT_GL_TAG"].ToString()]:0, 3) + "'><a type='4' idkey='" + dtType.Rows[k - 1]["ID_KEY"].ToString() + "' href='#' style='text-decoration:none;color:Red;' onclick='tc(this)'>#" + dtType.Rows[k - 1]["UNIT_ID"] + "</a></td>";
                                                }
                                                else if (value > 12 && value <= 25)
                                                {
                                                    str += "<td  style='width:41px;color:Red;background-color: #64C45C;' title='风速:" + value + ";负荷:" + Math.Round(PointValues.ContainsKey(dtType.Rows[k - 1]["UNIT_GL_TAG"].ToString())?PointValues[dtType.Rows[k - 1]["UNIT_GL_TAG"].ToString()]:0, 3) + "'><a type='4' idkey='" + dtType.Rows[k - 1]["ID_KEY"].ToString() + "' href='#' style='text-decoration:none;color:Red;' onclick='tc(this)'>#" + dtType.Rows[k - 1]["UNIT_ID"] + "</a></td>";
                                                }
                                                else if (value > 25)
                                                {
                                                    str += "<td  style='width:41px;color:Red;background-color: #9C7DC1;' title='风速:" + value + ";负荷:" + Math.Round(PointValues.ContainsKey(dtType.Rows[k - 1]["UNIT_GL_TAG"].ToString()) ? PointValues[dtType.Rows[k - 1]["UNIT_GL_TAG"].ToString()] : 0, 3) + "'><a type='4' idkey='" + dtType.Rows[k - 1]["ID_KEY"].ToString() + "' href='#' style='text-decoration:none;color:Red;' onclick='tc(this)'>#" + dtType.Rows[k - 1]["UNIT_ID"] + "</a></td>";
                                                }
                                                //str += "<td  style='width:41px;color:Red;'>#" + dtType.Rows[k - 1]["UNIT_ID"] + "</td>";

                                            }
                                            else
                                            {
                                                if (value <= 3)
                                                {
                                                    str += "<td  style='width:41px; background-color: #B3D6FD;'  title='风速:" + value + ";负荷:" + Math.Round(PointValues.ContainsKey(dtType.Rows[k - 1]["UNIT_GL_TAG"].ToString())?PointValues[dtType.Rows[k - 1]["UNIT_GL_TAG"].ToString()]:0, 3) + "'><a type='4' idkey='" + dtType.Rows[k - 1]["ID_KEY"].ToString() + "' href='#' style='text-decoration:none;' onclick='tc(this)'>#" + dtType.Rows[k - 1]["UNIT_ID"] + "</a></td>";

                                                }
                                                else if (value >= 3 && value <= 12)
                                                {
                                                    str += "<td  style='width:41px; background-color: #ACE066;'  title='风速:" + value + ";负荷:" + Math.Round(PointValues.ContainsKey(dtType.Rows[k - 1]["UNIT_GL_TAG"].ToString())?PointValues[dtType.Rows[k - 1]["UNIT_GL_TAG"].ToString()]:0, 3) + "'><a type='4' idkey='" + dtType.Rows[k - 1]["ID_KEY"].ToString() + "' href='#' style='text-decoration:none;' onclick='tc(this)'>#" + dtType.Rows[k - 1]["UNIT_ID"] + "</a></td>";
                                                }
                                                else if (value > 12 && value <= 25)
                                                {
                                                    str += "<td  style='width:41px; background-color: #64C45C;'  title='风速:" + value + ";负荷:" + Math.Round(PointValues.ContainsKey(dtType.Rows[k - 1]["UNIT_GL_TAG"].ToString())?PointValues[dtType.Rows[k - 1]["UNIT_GL_TAG"].ToString()]:0, 3) + "'><a type='4' idkey='" + dtType.Rows[k - 1]["ID_KEY"].ToString() + "' href='#' style='text-decoration:none;' onclick='tc(this)'>#" + dtType.Rows[k - 1]["UNIT_ID"] + "</a></td>";
                                                }
                                                else if (value > 25)
                                                {
                                                    str += "<td  style='width:41px; background-color: #9C7DC1;'  title='风速:" + value + ";负荷:" + Math.Round(PointValues.ContainsKey(dtType.Rows[k - 1]["UNIT_GL_TAG"].ToString()) ? PointValues[dtType.Rows[k - 1]["UNIT_GL_TAG"].ToString()] : 0, 3) + "'><a type='4' idkey='" + dtType.Rows[k - 1]["ID_KEY"].ToString() + "' href='#' style='text-decoration:none;' onclick='tc(this)'>#" + dtType.Rows[k - 1]["UNIT_ID"] + "</a></td>";
                                                }
                                                //str += "<td  style='width:41px;'>#" + dtType.Rows[k - 1]["UNIT_ID"] + "</td>";
                                            }
                                        }
                                        else
                                        {
                                            str += "<td  style='width:41px;' > #" + dtType.Rows[k - 1]["UNIT_ID"] + "</td>";
                                        }
                                        if (PointValues.ContainsKey(dtType.Rows[k - 1]["UNIT_GL_TAG"].ToString()))
                                        {
                                            if (PointValues[dtType.Rows[k - 1]["UNIT_GL_TAG"].ToString()] < 0)
                                                str2 += "<td style='background-color: yellow;text-align:right'>" + PointValues[dtType.Rows[k - 1]["UNIT_GL_TAG"].ToString()] + "</td>";
                                            else
                                                str2 += "<td >" + Math.Round(PointValues[dtType.Rows[k - 1]["UNIT_GL_TAG"].ToString()], 3) + "</td>";
                                        }
                                        else
                                        {
                                            str2 += "<td >0</td>";
                                        }
                                        }
                                }
                            }
                        }
                    }
                }

            }

            htmlTable.Append("</table>");

            object _obj = new
            {
                data = htmlTable.ToString()
            };
            string result = JsonConvert.SerializeObject(_obj);
            Response.Write(result);
            Response.End();
        }



        /// <summary>
        /// 获取时实点值
        /// </summary>
        private void LoadPointValue()
        {
            DataTable dtTags = dl.RunDataTable("select DISTINCT UNIT_GL_TAG,PERIOD_NAME,T_WINDTAG from (select * from ADMINISTRATOR.T_INFO_UNIT  as t LEFT JOIN  ADMINISTRATOR.T_BASE_POINTS AS P  ON T.UNIT_GL_TAG=P.T_POWERTAG " + dataType + ")", out errMsg);
            string[] tags = new string[dtTags.Rows.Count];
            double[] tagValues = new double[dtTags.Rows.Count];
            //添加负荷点
            for (int z = 0; z < dtTags.Rows.Count; z++)
            {
                //tags[z] = dtTags.Rows[z][0]!=DBNull.Value? dtTags.Rows[z][0].ToString():"~";
                if (dtTags.Rows[z][0] != DBNull.Value)
                {
                    if (!string.IsNullOrEmpty(dtTags.Rows[z][0].ToString()))
                    {
                        tags[z] = dtTags.Rows[z][0].ToString();
                    }
                    else
                    {
                        tags[z] = "~";
                    }
                }
                else
                {
                    tags[z] = "~";
                }
            }
            //tagValues = GetPointVal(tags, DateTime.Now.ToString("yyyy-MM-dd HH:mm:00"));
            tagValues = pbsll.GetSelectValue(tags);
            for (int y = 0; y < tagValues.Length; y++)
            {
                if (cyTye == "hd")
                    PointValues.Add(tags[y], tagValues[y] / 10);
                if (cyTye == "sd")
                    PointValues.Add(tags[y], tagValues[y] / 10);
                if (cyTye == "fd")
                    if (!PointValues.ContainsKey(tags[y]))
                    {
                        PointValues.Add(tags[y], tagValues[y]);
                    }
                if (cyTye == "tyn")
                    PointValues.Add(tags[y], tagValues[y] / 10);
                if (cyTye == "fbs")
                    PointValues.Add(tags[y], tagValues[y] / 10);
                if (cyTye == "swz")
                    PointValues.Add(tags[y], tagValues[y] / 10000);

            }
            //添加风速点
              tags = new string[dtTags.Rows.Count];
              tagValues = new double[dtTags.Rows.Count];
              for (int z = 0; z < dtTags.Rows.Count; z++)
              {

                  if (dtTags.Rows[z]["T_WINDTAG"] != DBNull.Value)
                  {
                      if (!string.IsNullOrEmpty(dtTags.Rows[z]["T_WINDTAG"].ToString()))
                      {
                          tags[z] = dtTags.Rows[z]["T_WINDTAG"].ToString();
                      }
                      else
                      {
                          tags[z] = "~";
                      }
                  }
                  else
                  {
                      tags[z] = "~";
                  }
              }
            //实时风速
            //tagValues = pbll.GetPointVal(tags, DateTime.Now.ToString("yyyy-MM-dd HH:mm:00"));
            tagValues = pbsll.GetSelectValue(tags);

            //tagValues = bj.GetSelectValue(tags);
            for (int y = 0; y < tagValues.Length; y++)
            {
                if (cyTye == "hd")
                    //PointValues.Add(tags[y], tagValues[y] );
                    if (!PointValues.ContainsKey(tags[y]))
                    {
                        PointValues.Add(tags[y], tagValues[y]);
                    }
                if (cyTye == "sd")
                    //PointValues.Add(tags[y], tagValues[y] );
                    if (!PointValues.ContainsKey(tags[y]))
                    {
                        PointValues.Add(tags[y], tagValues[y]);
                    }
                if (cyTye == "fd")
                    if (!PointValues.ContainsKey(tags[y]))
                    {
                        PointValues.Add(tags[y], tagValues[y]);
                    }
                if (cyTye == "tyn")
                    //PointValues.Add(tags[y], tagValues[y] );
                      if (!PointValues.ContainsKey(tags[y]))
                    {
                        PointValues.Add(tags[y], tagValues[y]);
                    }
                if (cyTye == "fbs")
                    //PointValues.Add(tags[y], tagValues[y] );
                      if (!PointValues.ContainsKey(tags[y]))
                    {
                        PointValues.Add(tags[y], tagValues[y]);
                    }
                if (cyTye == "swz")
                    //PointValues.Add(tags[y], tagValues[y] );
                    if (!PointValues.ContainsKey(tags[y]))
                    {
                        PointValues.Add(tags[y], tagValues[y]);
                    }
            }
            DataTable dtN = dl.RunDataTable("select DISTINCT PERIOD_NAME,PERIOD_TAG from (select * from ADMINISTRATOR.T_INFO_UNIT  " + dataType + ")", out errMsg);
            if (cyTye == "fd")
            {
                for (int s = 0; s < dtN.Rows.Count; s++)
                {
                    DataRow[] drs = dtTags.Select("PERIOD_NAME='" + dtN.Rows[s][0] + "'");
                    double v = 0;
                    for (int a = 0; a < drs.Length; a++)
                    {
                        if (PointValues[drs[a][0].ToString()] < 0)
                            continue;
                        v = v + PointValues[drs[a][0].ToString()];
                    }
                    PointValuesPerion.Add(dtN.Rows[s][0].ToString(), v / 10000);
                }
            }
            else
            {
                string[] tagsPer = new string[dtN.Rows.Count];
                double[] tagsPerValue = new double[dtN.Rows.Count];
                for (int sss = 0; sss < dtN.Rows.Count; sss++)
                {
                    tagsPer[sss] = dtN.Rows[sss][1].ToString();
                }
                 
                tagsPerValue =GetPointVal(tagsPer, DateTime.Now.ToString("yyyy-MM-dd HH:mm:00"));
                for (int w = 0; w < dtN.Rows.Count; w++)
                {
                    if (cyTye == "hd")
                        PointValuesPerion.Add(dtN.Rows[w][0].ToString(), tagsPerValue[w] / 10);
                    if (cyTye == "sd")
                        PointValuesPerion.Add(dtN.Rows[w][0].ToString(), tagsPerValue[w] / 10);
                    if (cyTye == "tyn")
                        PointValuesPerion.Add(dtN.Rows[w][0].ToString(), tagsPerValue[w] / 10);
                    if (cyTye == "fbs")
                        PointValuesPerion.Add(dtN.Rows[w][0].ToString(), tagsPerValue[w] / 10);
                    if (cyTye == "swz")
                        PointValuesPerion.Add(dtN.Rows[w][0].ToString(), tagsPerValue[w] / 10);
                }
            }
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
    }
}