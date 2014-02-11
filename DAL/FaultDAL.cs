using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using SAC.DBOperations;
using SAC.Helper;
using System.Collections;

namespace DAL
{
    public class FaultDAL
    {
        private string sql = "";
        private object obj = null;

        DBLink dl = new DBLink();

        /// <summary>
        /// 根据风场期数获取机组ID和描述
        /// </summary>
        /// <param name="perid"></param>
        /// <param name="errMsg"></param>
        /// <returns></returns>
        public DataTable GetUnitInfoByPID(string perid, out string errMsg)
        {
            errMsg = "";

            DataTable dt = null;

            sql = " select u.T_PERIODID,u.T_UNITID,u.T_UNITDESC,u.T_MACHINEID,p.T_FAULTTYPE from Administrator.T_BASE_POINTS as p inner join Administrator.T_BASE_UNIT as u on ";

            sql += "u.T_UNITID = p.T_UNITID where u.T_PERIODID='" + perid + "'";

            dt = dl.RunDataTable(sql, out errMsg);
            return dt;
        }

        /// <summary>
        /// 获取标准故障信息[故障次数维护]
        /// </summary>
        /// <param name="fType"></param>
        /// <returns></returns>
        public DataTable GetTabFaultTypeInfo(string fType)
        {
            string errMsg = "";
            DataTable dt = null;

            // T_BASE_FAULTSection_XNY & T_BASE_FAULTTYPE_XNY 联合查出标准故障信息
            sql = "select s.ID_KEY,s.T_SectionID,s.T_SectionDesc from Administrator.T_BASE_FAULTSECTION as s inner join  Administrator.T_BASE_FAULTTYPE as t ";

            sql += "on s.T_SectionID=t.T_Section where t.T_FaultType='" + fType + "'";

            dt = dl.RunDataTable(sql, out errMsg);

            return dt;
        }

        /// <summary>
        /// 获取错误次数[故障次数维护]
        /// </summary>
        /// <param name="uintID"></param>
        /// <param name="section"></param>
        /// <param name="qsrq"></param>
        /// <param name="jsrq"></param>
        /// <param name="errMsg"></param>
        /// <returns></returns>
        public string GetFaultCount(string uintID, string section, string qsrq, string jsrq, out string errMsg)
        {

            errMsg = "";

            sql = "select sum(D_VALUE) from Administrator.T_INFO_FAULTCOUNT where t_unitid='" + uintID + "' and T_FAULTSECTION='" + section + "' and t_time between '" + qsrq + "' and '" + jsrq + "'";

            //obj = dl.RunDataTable(sql, out errMsg);
            DataTable dt1 = dl.RunDataTable(sql, out errMsg);
            if (dt1 != null)
            {
                return dt1.Rows[0][0].ToString();
            }
            else
            {
                return "";
            }
            //return obj;
        }


        /// <summary>
        /// 保存故障次数数据[故障次数维护]
        /// </summary>
        /// <param name="pId"></param>
        /// <param name="date"></param>
        /// <param name="id"></param>
        /// <param name="errMsg"></param>
        /// <returns></returns>
        public bool SavaFaultCount(string date, string keyNew, string keyOld, out string errMsg)
        {
            errMsg = "";
            bool flag = false;
            int hours = 0;
            string sqlDel = "", sqlIns = "", unitID = "", qsrq = "", jsrq = "", gzID = "", valAvg = "", valRemain = "";
            string[] nValue = null, oValue = null;

            DateTime dtNow = DateTime.Now;

            qsrq = DateTime.Parse(date).ToString("yyyy-MM-dd 0:00:00");

            if (dtNow.Year == DateTime.Parse(date).Year && dtNow.Month == DateTime.Parse(date).Month && dtNow.Day == DateTime.Parse(date).Day)
            { 
                hours = dtNow.Hour; 
                jsrq = dtNow.ToString("yyyy-MM-dd H:mm:ss"); 
            }
            else
            { 
                hours = 24; 
                jsrq = DateTime.Parse(date).ToString("yyyy-MM-dd 23:59:59"); 
            }

            //if (keyNew != "")


                if (keyNew != "")
                {
                    string[] nVal = keyNew.TrimEnd(';').Split(';');
                    string[] oVal = keyOld.TrimEnd(';').Split(';');
                    //yhg266*GZ13-TQXT+0
                    if (nVal.Length > 0)
                    {
                        for (int i = 0; i < nVal.Length; i++)
                        {
                            nValue = nVal[i].Split('+');
                            oValue = oVal[i].Split('+');

                            if (double.Parse(nValue[1]) != double.Parse(oValue[1]))
                            {
                                string[] id = nValue[0].Split('*');
                                unitID = id[0];
                                gzID = id[1];

                                sqlDel += " delete from Administrator.T_INFO_FAULTCOUNT where T_UNITID='" + unitID + "' and T_FAULTSECTION= '" + gzID + "' and T_TIME between '" + qsrq + "' and '" + jsrq + "' ;";

                                GetValue(nValue[1], hours.ToString(), out valAvg, out valRemain);

                                for (int j = 0; j < hours; j++)
                                {
                                    if (j == 5)
                                        sqlIns += "insert into Administrator.T_INFO_FAULTCOUNT (T_UNITID,T_TIME,T_FAULTSECTION,D_VALUE) values ('" + unitID + "','" + DateTime.Parse(date).AddHours(+j).ToString("yyyy-MM-dd H:00:00") + "','" + gzID + "'," + valRemain + ");";
                                    else
                                        sqlIns += "insert into Administrator.T_INFO_FAULTCOUNT (T_UNITID,T_TIME,T_FAULTSECTION,D_VALUE) values ('" + unitID + "','" + DateTime.Parse(date).AddHours(+j).ToString("yyyy-MM-dd H:00:00") + "','" + gzID + "'," + valAvg + ");";
                                }
                            }
                        }
                        //执行语句
                        
                        flag = DBdb2.RunNonQuery(sqlDel, out errMsg);
                        
                        if (flag == true)
                        {                        
                            flag = DBdb2.RunNonQuery(sqlIns, out errMsg);                    
                        }
                        else { return flag; }
                    }
                }
                else
                { flag = true; }

            return flag;
        }

        public void GetValue(string dividend, string divider, out string valAvg, out string valRemain)
        {
            valAvg = "";
            valRemain = "";

            string res = "";

            res = StrHelper.Cale(dividend + "/(" + divider + "-1)");

            if (res.Contains('.'))
            {
                string[] resVal = res.Split('.');

                valAvg = resVal[0];
                valRemain = StrHelper.Cale(dividend + "-(" + divider + "-1)*" + resVal[0]);
            }
            else
            {
                //整除
                valAvg = res;
                valRemain = "0";
            }
        }


        /// <summary>
        /// 获取风机ID和描述
        /// </summary>
        /// <param name="perid"></param>
        /// <param name="errMsg"></param>
        /// <returns></returns>
        public DataTable GetUnitTableByPerID(string perid, out string errMsg)
        {
            errMsg = "";
            sql = "select * from Administrator.T_BASE_UNIT where T_PERIODID='" + perid + "'";
            DataTable dt1 = dl.RunDataTable(sql, out errMsg);
            return dt1;
        }


        /// <summary>
        /// 获取电量
        /// </summary>
        /// <param name="orgID"></param>
        /// <param name="unitID"></param>
        /// <param name="bt"></param>
        /// <param name="et"></param>
        /// <param name="errMsg"></param>
        /// <returns></returns>
        public string GetPower(string pID,string orgID, string unitID, string bt, string et, out string errMsg)
        {
            errMsg = "";
            sql = "SELECT sum(D_VALUE) FROM Administrator.T_INFO_STATISCS where T_PERIODID='" + pID + "' and T_ORGID='" + orgID + "' and T_TJID='DL' and T_UNITID='" + unitID + "' and T_TIME between '" + bt + "' and '" + et + "'";
            //obj = DBdb2.RunSingle(sql, out errMsg);
            DataTable dt1 = dl.RunDataTable(sql, out errMsg);
            if (dt1 != null)
            {
                return dt1.Rows[0][0].ToString();
            }
            else
            {
                return "";
            }
        }


        /// <summary>
        /// 保存电量数据[故障次数维护]
        /// </summary>
        /// <param name="pId"></param>
        /// <param name="date"></param>
        /// <param name="id"></param>
        /// <param name="errMsg"></param>
        /// <returns></returns>
        public bool SavaPower(string date, string keyNew, string keyOld,string perodID,string orgID, out string errMsg)
        {
            errMsg = "";
            bool flag = false;
            int hours = 0;
            string sqlDel = "", sqlIns = "", unitID = "", qsrq = "", jsrq = "", DLvalue = ""; //valAvg = "", valRemain = "";
            string[] nValue = null, oValue = null;

            DateTime dtNow = DateTime.Now;

            qsrq = DateTime.Parse(date).ToString("yyyy-MM-dd 0:00:00");

            if (dtNow.Year == DateTime.Parse(date).Year && dtNow.Month == DateTime.Parse(date).Month && dtNow.Day == DateTime.Parse(date).Day)
            { 
                hours = dtNow.Hour; 
                jsrq = dtNow.ToString("yyyy-MM-dd H:mm:ss"); 
            }
            else
            {
                hours = 24; 
                jsrq = DateTime.Parse(date).ToString("yyyy-MM-dd 23:59:59"); 
            }
                if (keyNew != "")
                {
                    string[] nVal = keyNew.TrimEnd(';').Split(';');
                    string[] oVal = keyOld.TrimEnd('+').Split('+');
                    //yhg266*GZ13-TQXT+0
                    if (nVal.Length > 0)
                    {
                        for (int i = 0; i < nVal.Length; i++)
                        {
                            nValue = nVal[i].Split('+');
                            oValue = oVal[i].Split(':');

                            if (double.Parse(nValue[1]) != double.Parse(oValue[1]))
                            {
                                //string[] id = nValue[0].Split('*');
                                unitID = nValue[0];
                                DLvalue = nValue[1];

                                sqlDel += "delete from ADMINISTRATOR.T_INFO_STATISCS where T_UNITID='" + unitID + "'and T_PERIODID='" + perodID + "' and T_ORGID= '" + orgID + "' and T_TIME between '" + qsrq + "' and '" + jsrq + "' ;";

                                double txtnum = Convert.ToDouble(DLvalue);
                                txtnum = txtnum / hours;
                                if (txtnum < 0)
                                {
                                    txtnum = Math.Round(txtnum + 5 / Math.Pow(10, 3), 3, MidpointRounding.AwayFromZero);
                                }
                                else
                                {
                                    txtnum = Math.Round(Convert.ToDouble(txtnum), 3, MidpointRounding.AwayFromZero);
                                }
                                for (int j = 0; j < hours; j++)
                                {
                                    sqlIns += "insert into Administrator.T_INFO_STATISCS (T_UNITID,T_TIME,T_PERIODID,T_TJID,T_ORGID,D_VALUE) values ('" + unitID + "','" + DateTime.Parse(date).AddHours(+j).ToString("yyyy-MM-dd H:00:00") + "','" + perodID + "', 'DL' ,'"+ orgID + "'," +Convert.ToDouble(txtnum) + ");";
                                }
                            }
                        }
                        //执行语句

                        flag = DBdb2.RunNonQuery(sqlDel, out errMsg);

                        if (flag == true)
                        {
                            flag = DBdb2.RunNonQuery(sqlIns, out errMsg);
                        }
                        else { 
                            return flag; 
                        }
                    }
                }
                else
                { 
                    flag = true; 
                }
                return flag;
        }
    }
}
