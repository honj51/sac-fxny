using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using DAL;

namespace BLL
{
    public class FaultBLL
    {
        FaultDAL dal = new FaultDAL();

        /// <summary>
        /// 获取风场下属风机所有故障次数[故障次数维护]
        /// </summary>
        /// <param name="pId"></param>
        /// <param name="date"></param>
        /// <returns></returns>
        public string GetFaultDataByPerId(string pId, string date, out string id1)
        {
            string id = "", qsrq = "", jsrq = "", errMsg = "";
            DataTable dt = null, dtGzBJ = null;

            StringBuilder sb = new StringBuilder();

            qsrq = DateTime.Parse(date).ToString("yyyy-MM-dd 0:00:00");
            jsrq = DateTime.Parse(date).ToString("yyyy-MM-dd 23:59:59");

            dt = dal.GetUnitInfoByPID(pId, out errMsg);  //T_BASE_POINTS_XNY & T_BASE_UNIT_XNY 联合查出风场下属风机信息

            if (dt != null && dt.Rows.Count > 0)
            {
                // T_BASE_FAULTSection_XNY & T_BASE_FAULTTYPE_XNY 联合查出标准故障信息
                dtGzBJ = dal.GetTabFaultTypeInfo(dt.Rows[0]["T_FAULTTYPE"].ToString());

                sb.Append("<table class=\"admintable\">");

                for (int i = -1; i < dt.Rows.Count; i++)
                {
                    sb.Append("<tr>");
                    if (i == -1)
                    {
                        sb.Append("<td class=\"admincls1\" align=\"center\" width=\"100px\">&nbsp;&nbsp;&nbsp;</td>");
                        for (int j = 0; j < dtGzBJ.Rows.Count; j++)
                        {
                            sb.Append("<td class=\"admincls1\" align=\"center\">" + dtGzBJ.Rows[j]["T_SectionDesc"] + "</td>");
                        }
                    }
                    else
                    {
                        sb.Append("<td class=\"admincls0\" align=\"center\"><div style=\"width:100px;\">" + dt.Rows[i]["T_UNITDESC"] + "</div></td>");

                        for (int j = 0; j < dtGzBJ.Rows.Count; j++)
                        {
                            object obj = dal.GetFaultCount(dt.Rows[i]["t_unitid"].ToString(), dtGzBJ.Rows[j]["T_SectionID"].ToString(), qsrq, jsrq, out errMsg);
                            //obj = 1;
                            if (obj != null && obj.ToString() != "")
                            {
                                sb.Append("<td class=\"admincls0\" align=\"center\"><input class=\"ipt\" id=\"" + dt.Rows[i]["t_unitid"].ToString() + "*" + dtGzBJ.Rows[j]["T_SectionID"].ToString() + "\" type=\"text\" value=\"" + obj.ToString() + "\"/></td>");
                                id += dt.Rows[i]["t_unitid"].ToString() + "*" + dtGzBJ.Rows[j]["T_SectionID"].ToString() + "+" + obj.ToString() + ";";
                            }
                            else
                            {
                                sb.Append("<td class=\"admincls0\" align=\"center\"><input class=\"ipt\" id=\"" + dt.Rows[i]["t_unitid"].ToString() + "*" + dtGzBJ.Rows[j]["T_SectionID"].ToString() + "\" type=\"text\" value=0 /></td>");
                                id += dt.Rows[i]["t_unitid"].ToString() + "*" + dtGzBJ.Rows[j]["T_SectionID"].ToString() + "+0;";
                            }
                        }
                    }
                    sb.Append("</tr>");
                }

                sb.Append("</table>");
            }
            id1 = id.TrimEnd(';');
            return sb.ToString();
        }


        /// <summary>
        /// 故障次数数据保存
        /// </summary>
        /// <param name="date"></param>
        /// <param name="keyNew"></param>
        /// <param name="keyOld"></param>
        /// <param name="errMsg"></param>
        /// <returns></returns>
        public bool SaveData(string date, string keyNew, string keyOld, out string errMsg)
        {
            return dal.SavaFaultCount(date, keyNew, keyOld, out errMsg);
        }


        /// <summary>
        /// 获取风场下的所有风机电量值[电量维护] 每日总电量
        /// </summary>
        /// <param name="orgID"></param>
        /// <param name="treeID"></param>
        /// <param name="pId"></param>
        /// <param name="date"></param>
        /// <param name="id"></param>
        /// <param name="errMsg"></param>
        /// <returns></returns>
        public string GetStatiscs(string orgID, string pId, string date, out string id, out string errMsg)
        {
            id = "";
            errMsg = "";
            string qsrq = "", jsrq = "", value = "";
            DataTable dt = null;// dtGzBJ = null;
            StringBuilder sb = new StringBuilder();

            qsrq = DateTime.Parse(date).ToString("yyyy-MM-dd 0:00:00");
            jsrq = DateTime.Parse(date).ToString("yyyy-MM-dd 23:59:59");

            dt = dal.GetUnitTableByPerID(pId, out errMsg);

            if (dt != null && dt.Rows.Count > 0)
            {
                sb.Append("<table class=\"admintable\" width=\"98%\">");
                sb.Append("<tr><th class=\"adminth\" colspan=\"8\" style=\"color:black;\">电量数据维护</th></tr>");
                int count = 0;

                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    if (i % 4 == 0)
                    { sb.Append("<tr>"); }

                    value = dal.GetPower(pId, orgID, dt.Rows[i]["t_unitid"].ToString(), qsrq, jsrq, out errMsg);

                    sb.Append("<td class=\"admincls0\" align=\"center\">" + dt.Rows[i]["T_UNITDESC"] + "</td>");

                    if (value == "")
                        sb.Append("<td class=\"admincls0\" align=\"center\"><input class=\"ipt_zb\" id=\"" + dt.Rows[i]["t_unitid"] + "\" type=\"text\" value=\"0\"/></td>");
                    else
                        sb.Append("<td class=\"admincls0\" align=\"center\"><input class=\"ipt_zb\" id=\"" + dt.Rows[i]["t_unitid"] + "\" type=\"text\" value=\"" + value + "\"/></td>");

                    count++;
                    if (count % 4 == 0)
                    { sb.Append("</tr>"); }

                    if (value == "")
                        id += dt.Rows[i]["t_unitid"] + ":0+";
                    else
                        id += dt.Rows[i]["t_unitid"] + ":" + value + "+";
                }
                sb.Append("</table>");
            }
            else
            { errMsg = "此风场下无风机数据!"; }

            id = id.TrimEnd('+');

            return sb.ToString();
        }

        /// <summary>
        /// 电量数据保存
        /// </summary>
        /// <param name="date"></param>
        /// <param name="keyNew"></param>
        /// <param name="keyOld"></param>
        /// <param name="errMsg"></param>
        /// <returns></returns>
        public bool SavePower(string date, string keyNew, string keyOld,string perodID,string orgID, out string errMsg)
        {
            return dal.SavaPower(date, keyNew, keyOld, perodID, orgID, out errMsg);
        }
    }
}
