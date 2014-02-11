using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Collections;
using DAL;
using System.Data;

namespace BLL
{
    public class PeriodBLL
    {
        PeriodDAL pd = new PeriodDAL();
        #region 获取工期信息  根据组织机构编号
        /// <summary>
        /// 获取工期信息
        /// </summary>
        /// <param name="orgID">组织机构编号</param>
        /// <returns></returns>
        public IList<Hashtable> GetPeriod(string orgID)
        {
            return pd.GetPeriod(orgID);
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
            return pd.GetUnit(periodId);
        }
        /// <summary>
        /// 获取机组信息
        /// </summary>
        /// <param name="periodId">工期编号</param>
        /// <returns></returns>
        public IList<Hashtable> GetUnits(string periodId)
        {
            return pd.GetUnits(periodId);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="oid"></param>
        /// <returns></returns>
        public IList<Hashtable> GetUnitByOrgId(string oid)
        {
            return pd.GetUnitByOrgId(oid);
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
            return pd.GetPoints(prid, type, jz);
        }

        /// <summary>
        /// 获取测点集合 根据 曲线类型 和 组织机构编码
        /// </summary>
        /// <param name="type">曲线类型</param>
        /// <param name="orgID">组织机构编码</param>
        /// <returns></returns>
        public DataTable GetPoints(string type, string orgID)
        {
            return pd.GetPoints(type, orgID);
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
            return pd.GetPoinsMap(orgid);
        }
        #endregion
    }
}
