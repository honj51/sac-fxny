using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;
using System.Data;
using System.Diagnostics;
using System.Collections;

public partial class Datafile_Get_Chart_Data : System.Web.UI.Page
{
    public string sec_type = "", ddl_level1 = "", ddl_level2 = "", ddl_level3 = "", ddl_level4 = "", point_name = "", rating = "", chart_id="";
    StringBuilder sb = new StringBuilder();
    BLL.BLLGet_chart_Data DGD = new BLL.BLLGet_chart_Data();
    protected void Page_Load(object sender, EventArgs e)
    {
        sec_type = Request["sec_type"]; ddl_level1 = Request["ddl_level1"]; ddl_level2 = Request["ddl_level2"]; ddl_level3 = Request["ddl_level3"]; ddl_level4 = Request["ddl_level4"]; point_name = Request["point_name"]; rating = Request["rating"]; chart_id = Request["chart_id"];
        string str1 = "";
        //风电、太阳能选项改变时，绑定DropDownLIst数据
        if ((sec_type != "") && (sec_type!=null))
        {

            DataSet DS = Return_dataset("administrator."+sec_type, "LEVEL1", "11");

            DataSet DDS = Return_dataset("administrator." + sec_type, "LEVEL2", DS.Tables[0].Rows[0][0].ToString());

            DataSet DDDS = Return_dataset("administrator." + sec_type, "LEVEL3", DDS.Tables[0].Rows[0][0].ToString());
            
            if (sec_type == "T_BASE_PARAID_SUN")
            {
                DataSet DDDDS = Return_dataset("administrator." + sec_type, "LEVEL4", DDDS.Tables[0].Rows[0][0].ToString());
                //string[] str = new string[] { DS.Tables[0].Rows[0][0].ToString(), DDS.Tables[0].Rows[0][0].ToString(), DDDS.Tables[0].Rows[0][0].ToString(), DDDDS.Tables[0].Rows[0][0].ToString() };
                

                //for (int i = 0; i < DGD.Get_ChartidByLEVEL("T_BASE_PARAID_XNY_SUN", str).Tables[0].Rows.Count; i++)
                //{
                //    sb.Append(DGD.Get_ChartidByLEVEL("T_BASE_PARAID_XNY_SUN", str).Tables[0].Rows[i][0].ToString() + "," + DGD.Get_ChartidByLEVEL("T_BASE_PARAID_XNY_SUN", str).Tables[0].Rows[i][1].ToString() + ";");
                    
                //}
                //sb.Append("|");
            }
            //else if (sec_type == "T_BASE_PARAID_XNY_WIND")
            //{
            //    string[] str = new string[] { DS.Tables[0].Rows[0][0].ToString(), DDS.Tables[0].Rows[0][0].ToString(), DDDS.Tables[0].Rows[0][0].ToString()};
            //    for (int i = 0; i < DGD.Get_ChartidByLEVEL("T_BASE_PARAID_XNY_WIND", str).Tables[0].Rows.Count; i++)
            //    {
            //        sb.Append(DGD.Get_ChartidByLEVEL("T_BASE_PARAID_XNY_WIND", str).Tables[0].Rows[i][0].ToString() + "," + DGD.Get_ChartidByLEVEL("T_BASE_PARAID_XNY_WIND", str).Tables[0].Rows[i][1].ToString() + ";");
                    
            //    }
            //    sb.Append("|");
            //}
        }
        //分公司选项改变时，绑定DropDownLIst数据
        else if ((ddl_level1 != "") && (ddl_level1 !=null))
        {
            DataSet DDS = Return_dataset("administrator." + ddl_level1.Split(',')[0], "LEVEL2", ddl_level1.Split(',')[1]);

            DataSet DDDS = Return_dataset("administrator." + ddl_level1.Split(',')[0], "LEVEL3", DDS.Tables[0].Rows[0][0].ToString());

            if (ddl_level1.Split(',')[0] == "T_BASE_PARAID_SUN")
            {
                DataSet DDDDS = Return_dataset("administrator." + ddl_level1.Split(',')[0], "LEVEL4", DDDS.Tables[0].Rows[0][0].ToString());
                //string[] str = new string[] { ddl_level1.Split(',')[1], DDS.Tables[0].Rows[0][0].ToString(), DDDS.Tables[0].Rows[0][0].ToString(), DDDDS.Tables[0].Rows[0][0].ToString() };


                //for (int i = 0; i < DGD.Get_ChartidByLEVEL("T_BASE_PARAID_XNY_SUN", str).Tables[0].Rows.Count; i++)
                //{
                //    sb.Append(DGD.Get_ChartidByLEVEL("T_BASE_PARAID_XNY_SUN", str).Tables[0].Rows[i][0].ToString() + "," + DGD.Get_ChartidByLEVEL("T_BASE_PARAID_XNY_SUN", str).Tables[0].Rows[i][1].ToString() + ";");
                   
                //}
                //sb.Append("|");
            }
            //else if (ddl_level1.Split(',')[0] == "T_BASE_PARAID_XNY_WIND")
            //{
            //    string[] str = new string[] { ddl_level1.Split(',')[1], DDS.Tables[0].Rows[0][0].ToString(), DDDS.Tables[0].Rows[0][0].ToString() };
            //    for (int i = 0; i < DGD.Get_ChartidByLEVEL("T_BASE_PARAID_XNY_WIND", str).Tables[0].Rows.Count; i++)
            //    {
            //        sb.Append(DGD.Get_ChartidByLEVEL("T_BASE_PARAID_XNY_WIND", str).Tables[0].Rows[i][0].ToString() + "," + DGD.Get_ChartidByLEVEL("T_BASE_PARAID_XNY_WIND", str).Tables[0].Rows[i][1].ToString() + ";");
                    
            //    }
            //    sb.Append("|");
            //}
        }
        //电厂选项改变时，绑定DropDownLIst数据
        else if ((ddl_level2 != "") && (ddl_level2 != null))
        {
            DataSet DDDS = Return_dataset("administrator." + ddl_level2.Split(',')[0], "LEVEL3", ddl_level2.Split(',')[2]);

            if (ddl_level2.Split(',')[0] == "T_BASE_PARAID_SUN")
            {
                DataSet DDDDS = Return_dataset("administrator." + ddl_level2.Split(',')[0], "LEVEL4", DDDS.Tables[0].Rows[0][0].ToString());
               
            }
        }
        //风机选项改变时，绑定DropDownLIst数据
        else if ((ddl_level3 != "") && (ddl_level3 != null))
        {
            if (ddl_level3.Split(',')[0] == "T_BASE_PARAID_SUN")
            {
                DataSet DDDDS = Return_dataset("administrator." + ddl_level3.Split(',')[0], "LEVEL4", ddl_level3.Split(',')[3]);
               
            }
        }
            //模糊查询测点名称时绑定CheckBoxLIst
        else if ((point_name != "") && (point_name != null))
        {
            string point_name_new = point_name.Split('-')[1];
            point_name = point_name.Split('-')[0];
            if (point_name.Split(',')[1] == "T_BASE_PARAID_WIND")
            {
                string[] str = new string[] { point_name.Split(',')[2], point_name.Split(',')[3], point_name.Split(',')[4], Fuzzy_Query(point_name.Split(',')[0]) };
                DataSet DS = DGD.Get_ChartidByFuzzy_Query("T_BASE_PARAID_WIND", str);
                
                if (DS.Tables[0].Rows.Count > 0)
                {
                    PIN_CHECKBOX(DS, point_name_new);
                }
            }
            else if (point_name.Split(',')[1] == "T_BASE_PARAID_SUN")
            {
                string[] str = new string[] { point_name.Split(',')[2], point_name.Split(',')[3], point_name.Split(',')[4], Fuzzy_Query(point_name.Split(',')[0]) };
                DataSet DS = DGD.Get_ChartidByFuzzy_Query("T_BASE_PARAID_SUN", str);
                if (DS.Tables[0].Rows.Count > 0)
                {
                    PIN_CHECKBOX(DS, point_name_new);
                }
            }
        }
        else if ((rating != "") && (rating != null))
        {
            
            
        }
        //从TendManage页面编辑趋势模板跳转过来时，根据模板ID解析测点
        else if ((chart_id != "") && (chart_id != null))
        {
            DataSet DS=  DGD.GetPara_id(chart_id);
            for (int i = 0; i < DS.Tables[0].Rows.Count; i++)
            {
                sb.Append(DS.Tables[0].Rows[i]["PARAID"].ToString() + "|" + DS.Tables[0].Rows[i]["PARADESC"].ToString());
                if ((DS.Tables[0].Rows.Count == 1)||(i != DS.Tables[0].Rows.Count-1))
                {
                    sb.Append(",");
                } 
            }
        }
        Response.Clear();
        Response.Write(sb.ToString());
        Response.End();
    }


    private DataSet Return_dataset(string id,string level_id,string para_id)
    {
        //<option value=" + array[1].split(',')[i] + ">" + array[1].split(',')[i] + "</option>
        DataSet DS = DGD.Get_Paraid(id, level_id, para_id);
        for (int i = 0; i < DS.Tables[0].Rows.Count; i++)
        {
            sb.Append("<option value=" + DS.Tables[0].Rows[i][0].ToString() + ">" + DS.Tables[0].Rows[i][0].ToString() + "</option>");
            //sb.Append(DS.Tables[0].Rows[i][0].ToString());
            //if (i != DS.Tables[0].Rows.Count - 1)
            //{
            //    sb.Append(",");
            //}
        }
        sb.Append("|");
        return DS;
    }

    /// <summary>
    /// 模糊查询
    /// </summary>
    /// <param name="id">要查询的字符串 字符串中间以空格隔开</param>
    /// <returns></returns>
    private string Fuzzy_Query(string id)
    {
        string str = "%";
        for (int i = 0; i < id.Trim(' ').Split(' ').Length; i++)
        {
            str += id.Trim(' ').Split(' ')[i] + "%";
        }
        return str;
    }

    private void PIN_CHECKBOX(DataSet DS,string value)
    {
        int count = 0;
        sb.Append("<table><tr>");
        for (int i = 0; i < DS.Tables[0].Rows.Count; i++)
        {
            count++;
            int num = 0;
            for (int j = 0; j < value.Split(',').Length; j++)
            {
                if (DS.Tables[0].Rows[i][0].ToString() == value.Split('|')[0])
                {
                    num++;
                }
            }
            if (num == 0)
            {
                if (count % 2 == 0)
                {
                    sb.Append("<td width=\"900px\"><input type='checkbox' name='" + DS.Tables[0].Rows[i][1].ToString() + "' value='" + DS.Tables[0].Rows[i][0].ToString() + "'>&nbsp;&nbsp;&nbsp;" + DS.Tables[0].Rows[i][1].ToString() + "&nbsp;&nbsp;&nbsp;&nbsp;<br></td></tr>");
                }
                else
                {
                    sb.Append("<td width=\"900px\"><input type='checkbox' name='" + DS.Tables[0].Rows[i][1].ToString() + "' value='" + DS.Tables[0].Rows[i][0].ToString() + "'>&nbsp;&nbsp;&nbsp;" + DS.Tables[0].Rows[i][1].ToString() + "&nbsp;&nbsp;&nbsp;</td>");
                }
                if ((count % 2 != 0) && (i == DS.Tables[0].Rows.Count - 1))
                {
                    sb.Append("</tr>");
                }
            }
            else
            {
                if (count % 2 == 0)
                {
                    sb.Append("<td width=\"900px\"><input type='checkbox' name='" + DS.Tables[0].Rows[i][1].ToString() + "' checked ='checked' value='" + DS.Tables[0].Rows[i][0].ToString() + "'>&nbsp;&nbsp;&nbsp;" + DS.Tables[0].Rows[i][1].ToString() + "&nbsp;&nbsp;&nbsp;&nbsp;<br></td></tr>");
                }
                else
                {
                    sb.Append("<td width=\"900px\"><input type='checkbox' name='" + DS.Tables[0].Rows[i][1].ToString() + "' checked ='checked' value='" + DS.Tables[0].Rows[i][0].ToString() + "'>&nbsp;&nbsp;&nbsp;" + DS.Tables[0].Rows[i][1].ToString() + "&nbsp;&nbsp;&nbsp;</td>");
                }
                if ((count % 2 != 0) && (i == DS.Tables[0].Rows.Count - 1))
                {
                    sb.Append("</tr>");
                }
            }
            //sb.Append(DS.Tables[0].Rows[i][0].ToString() + "," + DS.Tables[0].Rows[i][1].ToString() + ";");
        }
        sb.Append("</table>");
    }
}