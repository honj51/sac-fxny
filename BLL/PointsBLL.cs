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
        BLLHelp bh = new BLLHelp();
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

        #region  获取T_INFO_VALUE表中所有测点集合的信息
        /// <summary>
        ///  获取T_INFO_VALUE表中所有测点集合的信息
        /// </summary>
        /// <returns></returns>
        public DataTable GetAllValue()
        {
            return point.GetAllValue();
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
            return point.GetValueByPoints(pointsName);
        }

        #endregion


        #region  获取T_INFO_VALUE表指定测点集合的值
        /// <summary>
        ///  获取T_INFO_VALUE表中所有测点集合的信息
        /// </summary>
        /// <returns></returns>
        public double[] GetSelectValue(string[] points)
        {
            string[] kw = new string[] { "XCHP.1.00CE30017", "HTXL.00CE30001", "KLFD:1.00CE30001", "BEJP:00CE30001", "XCH2:00CC0001", "XCHP.3.00CE30019", "BERP.1.00CE30001" };
            string[] mw = new string[] { "LNTL:00CC0001", "DBHL:00CC0001", "JSGY.1.00CC0001", "SXGL:1.00CE30001", "CCFD:00CE30001", "MGYP:00CE30001", "MGYP:00CC0001", "SYFD:00CE30001", "NMSP:00CE30001", "JJFD:00CE30001", "NTWP:00CE30001" };
            string[] wkw = new string[] { "DAYQ:00CE30001", "DAEQ:00CE30001", "JYGP:00CE30001", "GZFD:1.00CE30001", "YMFD:1.00CE30001", "AKSP:1.00CE30001", "ZSCB:00CE30001", "FLDP:00CE30001", "DBCP:00CE30001", "QLGS:00CE30001", "HNJP:00CC0001", "HNEQ:00CE30001", "TLEQ:00CE30001", "JTFP:1.00CE30001", "YLEQ:00CE30001", "NMQT:00CE30001", "QSFD:00CE30001", "GLSQ:00CC0001" };
            double[] val = new double[points.Length];
            double v = 0;
            DataTable dtPoints = point.GetAllValue();
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

                v = bh.getDouble(v, 2);

                val[i] = v;
            }
            return val;
        }

        #endregion


        #region 根据测点获取T_INFO_VALUE表中指定测点值的集合
        /// <summary>
        /// 根据测点获取T_INFO_VALUE表中指定测点值的集合
        /// </summary>
        /// <param name="pointsName">测点集合的名称</param>
        /// <returns></returns>
        private List<double> GetValueListByPoints(string pointsName)
        {
            DataTable tmp = new DataTable();
            List<double> d = new List<double>();
            tmp = point.GetValueByPoints(pointsName);
            if (tmp != null && tmp.Rows.Count > 0)
            {
                foreach (DataRow r in tmp.Rows)
                {
                    if (r["T_VALUE"] != DBNull.Value)
                    {
                        if (!string.IsNullOrEmpty(r["T_VALUE"].ToString()))
                        {
                            d.Add(double.Parse(r["T_VALUE"].ToString()));
                        }
                        else
                        {
                            d.Add(0);
                        }
                    }
                    else
                    {
                        d.Add(0);
                    }
                }
            }
            return d;
        }

        #endregion
    }
}
