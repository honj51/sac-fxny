using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using DAL;

namespace BLL
{
    /// <summary>
    /// 电量操作类
    /// </summary>
    public class BLL_STATISCS
    {
        DAL_STATISCS dSta = new DAL_STATISCS();

        #region 获取多个测点某段时间的电量  根据测点名称 开始时间 结束时间 机组
        /// <summary>
        /// 获取多个测点某段时间的电量
        /// </summary>
        /// <param name="st">开始时间</param>
        /// <param name="et">结束时间</param>
        /// <param name="unti">机组</param>
        /// <returns></returns>
        public DataTable GetDL(string st, string et, string units)
        {
            return dSta.GetDL(st, et, units);
        }
        #endregion

        public DataTable GetDlByTimeAndUnits(string st, string et, string untis)
        {
            return dSta.GetDlByTimeAndUnits(st, et, untis);
        }
    }
}
