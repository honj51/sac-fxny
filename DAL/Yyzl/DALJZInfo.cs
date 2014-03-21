using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Collections;
using SAC.DBOperations;
using System.Data;

namespace DAL.yyzl
{
    public class DALJZInfo
    {
        string rlDBType = "";
        string rtDBType = "";
        string sql = "";
        string errMsg = "";
        object obj = null;
        bool judge = false;
        DataTable dt = new DataTable();

        DBLink db = new DBLink();

        #region  获取T_INFO_VALUE表中所有测点集合的信息
        /// <summary>
        ///  获取T_INFO_VALUE表中所有测点集合的信息
        /// </summary>
        /// <returns></returns>
        public DataTable GetAllValue()
        {
            sql = "SELECT T_POINT,T_VALUE FROM ADMINISTRATOR.T_INFO_VALUE ";
            dt = DBdb2.RunDataTable(sql, out errMsg);

            return dt;
        }

        #endregion

        #region 根据测点获取T_INFO_VALUE表中指定测点集合的信息
        /// <summary>
        /// 根据测点获取T_INFO_VALUE表中指定测点集合的信息
        /// </summary>
        /// <param name="pointsName">测点集合的名称</param>
        /// <returns></returns>
        public DataTable GetValueByPoints(string pointsName)
        {
            sql = "SELECT T_POINT,T_VALUE FROM ADMINISTRATOR.T_INFO_VALUE where T_POINT in (" + pointsName + ")";
            dt = DBdb2.RunDataTable(sql, out errMsg);

            return dt;
        }

        #endregion
    }
}
