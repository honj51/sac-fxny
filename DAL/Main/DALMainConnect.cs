using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Collections;
using SAC.DBOperations;
using System.Data;

namespace DAL.Main
{
    public class DALMainConnect
    {
        string rlDBType = "";
        string rtDBType = "";
        string sql = "";
        string errMsg = "";
        object obj = null;
        bool judge = false;
        DataTable dt = new DataTable();

        DBLink db = new DBLink();

        string[] kw = new string[] { "XCHP.1.00CE30017", "HTXL.00CE30001", "KLFD:1.00CE30001", "BEJP:00CE30001", "XCH2:00CC0001", "XCHP.3.00CE30019", "BERP.1.00CE30001" };
        string[] mw = new string[] { "LNTL:00CC0001", "DBHL:00CC0001", "JSGY.1.00CC0001", "SXGL:1.00CE30001", "CCFD:00CE30001", "MGYP:00CE30001", "MGYP:00CC0001", "SYFD:00CE30001", "NMSP:00CE30001", "JJFD:00CE30001", "NTWP:00CE30001" };
        string[] wkw = new string[] { "DAYQ:00CE30001", "DAEQ:00CE30001", "JYGP:00CE30001", "GZFD:1.00CE30001", "YMFD:1.00CE30001", "AKSP:1.00CE30001", "ZSCB:00CE30001", "FLDP:00CE30001", "DBCP:00CE30001", "QLGS:00CE30001", "HNJP:00CC0001", "HNEQ:00CE30001", "TLEQ:00CE30001", "JTFP:1.00CE30001", "YLEQ:00CE30001", "NMQT:00CE30001", "QSFD:00CE30001", "GLSQ:00CC0001" };
       
        #region 从T_ORIGINAL_POINT表中得到不同类型条件的测点（实时数据读到关系数据库表T_INFO_VALUE中）
        /// <summary>
        /// 从T_ORIGINAL_POINT表中得到不同类型条件的测点（实时数据读到关系数据库表T_INFO_VALUE中）
        /// </summary>
        /// <param name="companyType">电类型（风电，水电...）</param>
        /// <param name="type">点所属层次（电厂，机组）</param>
        /// <param name="pointType">点类型（负荷，风速，日电量，月电量，年电量）</param>
        /// <param name="?"></param>
        /// <returns></returns>
        public DataTable GetTagByKind(string companyType, string type, string pointType)
        {
            sql = "select * from Administrator.T_ORIGINAL_POINT where  T_COMPANY_TYPE='"+companyType+"' and T_TYPE='"+type+"' and T_POINT_TYPE='"+pointType+"'";

            dt = DBdb2.RunDataTable(sql, out errMsg);

            return dt;

        }
        #endregion

        #region 根据测点获取T_INFO_VALUE表中指定测点的信息
        /// <summary>
        /// 根据测点获取T_INFO_VALUE表中指定测点的信息
        /// </summary>
        /// <param name="pointName">测点的名称</param>
        /// <returns></returns>
        public DataTable GetValueByPoint(string pointName)
        {
            sql = "SELECT T_POINT,T_VALUE FROM ADMINISTRATOR.T_INFO_VALUE where T_POINT='"+pointName+"'";
            dt = DBdb2.RunDataTable(sql, out errMsg);

            return dt;
        }

        #endregion

        /// <summary>
        /// 获取测点最新值
        /// </summary>
        /// <param name="points">测点集合</param>
        /// <param name="time">测点实时时间</param>
        /// <returns></returns>
        public List<double> GetPointVal(List<string> points, string time)
        {
            List<double> val = new List<double>();
            double v = 0;
            Plink pk = new Plink();
            Plink.OpenPi();
            foreach (string name in points)
            {
                pk.GetHisValue(name, time, ref v);
                if (kw.Contains(name))
                    v = v / 1000;
                //if (mw.Contains(points[i]))
                //    v = v / 10000;
                if (wkw.Contains(name))
                    v = v * 10;

                if (name == "BERP.1.00CE30001")
                    v = v / 1000;
                v = getDouble(v, 2);
                val.Add(v);
            }
            //Plink.closePi();
            return val;
        }

        #region 四舍五入
        /// <summary>
        /// 四舍五入
        /// </summary>
        /// <param name="result">要转换的数值</param>
        /// <param name="num">保留位数</param>
        /// <returns></returns>
        public double getDouble(double result, int num)
        {
            string res = result.ToString();
            string results = "";
            int index = res.IndexOf('.');

            if (res.Length - index == num + 1)
                return Convert.ToDouble(res);
            else
            {
                if (index > 0)
                {
                    index += num;
                    res = res + "000000000000000000";
                    res = res.Remove(0, index + 1);
                    results = result + "000000000000000000";
                    results = results.ToString().Substring(0, index + 1);
                    res = res.Substring(0, 1);

                    string point = "0.";

                    for (int count = 0; count < num - 1; count++)
                    {
                        point += "0";
                    }
                    point += "1";


                    if (Convert.ToInt32(res) > 4)
                    {
                        results = (Convert.ToDouble(results) + Convert.ToDouble(point)).ToString();
                        res = results;
                    }
                    else
                    {
                        res = results;
                    }
                }
                else
                {
                    res += ".";
                    for (int i = 0; i < num; i++)
                    {
                        res += "0";
                    }
                }
                return Convert.ToDouble(res);
            }
        }
        #endregion
    }
}
