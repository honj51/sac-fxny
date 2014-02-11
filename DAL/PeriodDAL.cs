using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Collections;
using SAC.DBOperations;

namespace DAL
{
    public class PeriodDAL
    {
        string rlDBType = "";
        string rtDBType = "";
        string sql = "";
        string errMsg = "";
        object obj = null;
        bool judge = false;
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
            //sql = "select T_UNITID,T_UNITDESC,T_MACHINEID,I_FLAG from Administrator.T_BASE_UNIT where T_PERIODID='" + periodId + "'";
            sql = "select u.T_UNITID,u.T_UNITDESC,u.T_MACHINEID,u.I_FLAG,p.T_POWERTAG,p.T_WINDTAG,p.T_WUGONGGLV,p.T_ZHUANZHISUDU,p.T_STATE    from Administrator.T_BASE_UNIT u left join ADMINISTRATOR.T_BASE_POINTS p on u.T_UNITID=p.T_UNITID and u.T_PERIODID=p.T_PERIODID where u.T_PERIODID='" + periodId + "'";

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

        /// <summary>
        /// 
        /// </summary>
        /// <param name="oid"></param>
        /// <returns></returns>
        public IList<Hashtable> GetUnitByOrgId(string oid)
        {
            sql = "select * from (select  T_UNITID,T_UNITDESC,T_MACHINEID,I_FLAG,(select T_ORGID from ADMINISTRATOR.T_BASE_PERIOD p where p.T_PERIODID=t.T_PERIODID) from ADMINISTRATOR.T_BASE_UNIT t) where T_ORGID='" + oid + "'";
            dt = db.RunDataTable(sql, out errMsg);
            return DataTableToList(dt);
        }

        #endregion

        #region 获取测点集合  根据 工期编号 机组 和 曲线类型
        /// <summary>
        /// 获取测点集合
        /// </summary>
        /// <param name="prid"></param>
        /// <param name="type"></param>
        /// <param name="jz"></param>
        /// <returns></returns>
        public DataTable GetPoints(string prid, string type, string jz)
        {
            string column = "";
            if (type == "1")
                column = "T_POWERTAG";
            else if (type == "2")
                column = "T_WINDTAG";
            else if (type == "3")
                column = "T_ELECTRICTAG";
            else if (type == "4")
                column = "T_STOPTIMETAG";
            else if (type == "5")
                column = "T_USINGTIMETAG";

            sql = "select " + column + " from Administrator.T_BASE_POINTS where T_PERIODID='" + prid + "' and T_UNITID in(" + jz + ")";

            dt = db.RunDataTable(sql, out errMsg);

            return dt;
        }

        /// <summary>
        /// 获取测点集合 根据 曲线类型 和 组织机构编码
        /// </summary>
        /// <param name="type">曲线类型</param>
        /// <param name="orgID">组织机构编码</param>
        /// <returns></returns>
        public DataTable GetPoints(string type, string orgID)
        {
            string column = "";
            if (type == "1")
                column = "T_POWERTAG";
            else if (type == "2")
                column = "T_WINDTAG";
            else if (type == "3")
                column = "T_ELECTRICTAG";
            else if (type == "4")
                column = "T_STOPTIMETAG";
            else if (type == "5")
                column = "T_USINGTIMETAG";

            sql = "select " + column + " from Administrator.T_BASE_POINTS_ORG where T_ORGID in(" + orgID + ")";

            dt = db.RunDataTable(sql, out errMsg);

            return dt;
        }
        #endregion

        #region
        /// <summary>
        /// 获取测点集合
        /// </summary>
        /// <param name="orgid"></param>
        /// <returns></returns>
        public DataTable GetPoinsMap(string orgid)
        {
            sql = "select T_WINDTAG,T_POWERTAG from Administrator.T_BASE_POINTS_ORG where T_ORGID in(" + orgid + ")";

            dt = db.RunDataTable(sql, out errMsg);

            return dt;
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
