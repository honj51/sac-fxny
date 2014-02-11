using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using DAL;

namespace BLL
{
    public class PointsBLL
    {
        PointsDAL point = new PointsDAL();
        #region 获取机组对应测点 BY  机组编码
        /// <summary>
        /// 获取机组对应测点
        /// </summary>
        /// <param name="unit">机组编号</param>
        /// <returns></returns>
        public DataTable GetPointsByUnit(string unit)
        {
            return point.GetPointsByUnit(unit);
        }
        #endregion
    }
}
