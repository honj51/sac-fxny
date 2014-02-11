using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using SAC.DBOperations;
using System.Collections;

namespace DAL
{
    public  class WppDAL
    {
        string sql = "";
        string errMsg = "";
        DataTable dt = new DataTable();
        DBLink db = new DBLink();

        #region 获取工期信息  根据组织机构编号
        /// <summary>
        /// 获取工期信息
        /// </summary>
        /// <param name="orgID">组织机构编号</param>
        /// <returns></returns>
        public IList<Hashtable> GetPeriod(string orgID)
        {
            IList<Hashtable> list = new List<Hashtable>();
            sql = "select T_PERIODID,T_PERIODDESC from Administrator.T_BASE_PERIOD where T_ORGID='" + orgID + "'";
            dt = DBdb2.RunDataTable(sql, out errMsg);

            list = DataTableToList(dt);
            return list;
        }
        #endregion

        #region 获取机组信息  根据工期编号
        /// <summary>
        /// 获取机组信息 
        /// </summary>
        /// <param name="periodId"></param>
        /// <returns></returns>
        public DataTable GetUnit(string periodId)
        {
            sql = "select T_UNITID,T_UNITDESC,T_MACHINEID from Administrator.T_BASE_UNIT where T_PERIODID='" + periodId + "'";

            dt = db.RunDataTable(sql, out errMsg);

            return dt;
        }
        /// <summary>
        /// 获取机组信息
        /// </summary>
        /// <param name="periodId">工期编号</param>
        /// <returns></returns>
        public IList<Hashtable> GetUnits(string periodId)
        {
            IList<Hashtable> list = new List<Hashtable>();

            dt = GetUnit(periodId);
            list = DataTableToList(dt);
            return list;
        }

        #endregion


        #region 获取风机型号ID  根据机组ID
        /// <summary>
        /// 
        /// </summary>
        /// <param name="idpt"></param>
        /// <param name="gq"></param>
        /// <returns></returns>
        public DataTable GetMachineID(string idpt,string gq)
        {
            sql = "select distinct T_MACHINEID from Administrator.T_BASE_UNIT where T_PERIODID='"+gq+"' and T_UNITID in (" + idpt + ")";

            dt = db.RunDataTable(sql, out errMsg);

            return dt;
        }
        #endregion

        #region 获取风速，功率  根据风机ID
        /// <summary>
        /// 
        /// </summary>
        /// <param name="_machineIDs"></param>
        /// <returns></returns>
        public DataTable GetWppNWSpeed(string _machineIDs)
        {
            sql = "select T_NWSPEED,T_NPOWER from Administrator.T_BASE_NORMWPP where T_MACHINEID='" + _machineIDs + "' order by ID_KEY";

            dt = db.RunDataTable(sql, out errMsg);

            return dt;
        }
        #endregion

        #region 获取风速，功率  根据机组ID，开始时间，结束实际，工期ID
        /// <summary>
        /// 
        /// </summary>
        /// <param name="idpt"></param>
        /// <param name="gq"></param>
        /// <param name="sTime"></param>
        /// <param name="eTime"></param>
        /// <returns></returns>
        public DataTable GetWppNWSpeed(string idpt, string gq, string sTime, string eTime)
        {
            sql = "select T_NWSPEED,T_NPOWER from Administrator.T_INFO_WPP where T_PERIODID='" + gq + "' and T_UNITID='"+idpt+" and T_TIME betwen '"+sTime+"' and '"+eTime+"'";

            dt = db.RunDataTable(sql, out errMsg);

            return dt;
        }
        #endregion

        #region 获取风速，功率  根据机组ID，开始时间，结束实际，工期ID
        /// <summary>
        /// 
        /// </summary>
        /// <param name="idpt"></param>
        /// <param name="gq"></param>
        /// <param name="sTime"></param>
        /// <param name="eTime"></param>
        /// <returns></returns>
        public DataTable GetPower(string gq, string unitID, string NWSpeed, string bt, string et)
        {
            sql = "select T_POWER from Administrator.T_INFO_WPP where T_PERIODID='" + gq + "' and T_UNITID= " + unitID + " and T_WDSPEED=" + NWSpeed + " and T_TIME between '" + bt + "' and '" + et + "'";
            

            dt = db.RunDataTable(sql, out errMsg);

            return dt;
        }
        #endregion

        #region 获取风速，功率  根据机组ID，开始时间，结束实际，工期ID
        /// <summary>
        /// 
        /// </summary>
        /// <param name="idpt"></param>
        /// <param name="gq"></param>
        /// <param name="sTime"></param>
        /// <param name="eTime"></param>
        /// <returns></returns>
        public DataTable GetAvgPower(string gq, string unitID, string NWSpeed, string bt, string et)
        {
            sql = "select avg(T_POWER) from Administrator.T_INFO_WPP where T_PERIODID='" + gq + "' and T_UNITID= " + unitID + " and T_WDSPEED=" + NWSpeed + " and T_TIME between '" + bt + "' and '" + et + "'";


            dt = db.RunDataTable(sql, out errMsg);

            return dt;
        }
        #endregion

        #region 获取公司信息
        public DataTable dtGetCompany()
        {
            sql = "SELECT * FROM Administrator.T_BASE_COMPANY";


            dt = db.RunDataTable(sql, out errMsg);

            return dt;
        }
        #endregion

        #region 获取风场信息  根据公司编号
       
        public DataTable GetOrg(string comID)
        {
            IList<Hashtable> list = new List<Hashtable>();
            sql = "SELECT * FROM ADMINISTRATOR.T_BASE_ORG where T_COMID='" + comID + "'";

            dt = DBdb2.RunDataTable(sql, out errMsg);

            //list = DataTableToList(dt);
            return dt;
        }


        public IList<Hashtable> GetOrgs(string comID)
        {
            IList<Hashtable> list = new List<Hashtable>();

            dt = GetOrg(comID);
            list = DataTableToList(dt);
            return list;
        }
        #endregion


        #region 从DataTable转化为List 胡进财 2013/02/27
        /// <summary>
        /// 从DataTable转化为List
        /// </summary>
        /// <param name="dt">数据集</param>
        /// <returns>List集合</returns>
        public IList<Hashtable> DataTableToList(DataTable dt)
        {
            IList<Hashtable> list = null;
            if (dt != null && dt.Rows.Count > 0)
            {
                list = new List<Hashtable>();
                Hashtable ht = null;
                foreach (DataRow row in dt.Rows)
                {
                    ht = new Hashtable();
                    foreach (DataColumn col in dt.Columns)
                    {
                        if (row[col.ColumnName] != null && !string.IsNullOrEmpty(Convert.ToString(row[col.ColumnName])))
                        {
                            ht.Add(col.ColumnName.ToUpper(), row[col.ColumnName]);
                        }
                        else
                        {
                            ht.Add(col.ColumnName.ToUpper(), "");
                        }
                    }
                    list.Add(ht);
                }
            }
            return list;
        }
        #endregion
    }

}
