using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using SAC.DBOperations;
using System.Collections;
using System.Data;

namespace DAL.Connect
{
    public class DALConnect
    {
          DBLink dl = new DBLink();
        public static PointDAL pd = new PointDAL();
        string errMsg = string.Empty;
        public DBdb2 db = new DBdb2();
        

        #region 获取指定条件的电源项目综合信息
        /// <summary>
        /// 获取指定条件的电源项目综合信息
        /// </summary>
        /// <param name="dataType">电源类型</param>
        /// <param name="area">区域</param>
        /// <param name="periodName">场站名称</param>
        /// <param name="zxType">纵向的类型（总1，区域1，场站1，机组2）机组不用分组</param>
        /// <returns></returns>
        public List<ArrayList> GetProject(string dataType,string area,string periodName,string zxType)
        {
            string sql = string.Empty;
            if (zxType == "1")
            {
                sql = " select DISTINCT PERIOD_NAME,PERIOD_RL,PERIOD_TAG,DATA_TYPE,DAYDL,T_WINTAG,T_AREA,T_ORDER from Administrator.T_INFO_UNIT GROUP BY PERIOD_NAME,PERIOD_RL,PERIOD_TAG,DATA_TYPE,DAYDL,T_WINTAG,T_AREA,T_ORDER  having  1=1";
            }
            if (zxType == "2")
            {
                sql = " select PERIOD_NAME,PERIOD_RL,PERIOD_TAG,DATA_TYPE,DAYDL,T_WINTAG,T_AREA,T_ORDER,UNIT_ID,UNIT_GL_TAG,ID_KEY from Administrator.T_INFO_UNIT  where 1=1";
            }
            
            if (!string.IsNullOrEmpty(dataType))
           {
               sql += " AND DATA_TYPE='" + dataType + "'";
           }
            if (!string.IsNullOrEmpty(area))
           {
               sql += " AND T_AREA='" + area + "'";
           }
            if (!string.IsNullOrEmpty(periodName))
           {
               sql += "  AND PERIOD_NAME='" + periodName + "'";
           }
            
           DataTable dt = new DataTable();
           dt = dl.RunDataTable(sql, out errMsg);

            List<ArrayList> s = new List<ArrayList>();
            if (dt.Rows.Count > 0)
            {
                foreach (DataRow d in dt.Rows)
                {
                    ArrayList t = new ArrayList();
                    //名称
                    t.Add(d["PERIOD_NAME"].ToString());
                    //string[] a=new string[3] ;
                    List<string> dd = new List<string>();
                    if (zxType == "1")
                    {
                        if (d["PERIOD_TAG"] != DBNull.Value)
                        {
                            dd.Add(d["PERIOD_TAG"].ToString());
                        }
                    }
                    else if (zxType == "2")
                    {
                        if (d["UNIT_GL_TAG"] != DBNull.Value)
                        {
                            dd.Add(d["UNIT_GL_TAG"].ToString());
                        }
                    }
                    dd.Add(d["DAYDL"].ToString());
                    //风速点

                    if (d["T_WINTAG"] != DBNull.Value)
                    {
                        dd.Add(d["T_WINTAG"].ToString());
                    }
                    string[] a = new string[3];
                    if (dd.Count > 0)
                    {
                        a = dd.ToArray();
                    }
                    //double[] b = pd.GetPointVal(a, DateTime.Now.ToString("yyyy-MM-dd HH:mm:00"));
                    double[] b = GetSelectValue(a);
                    //实时负荷
                    if (b.Length > 0)
                    {
                        t.Add(b[0].ToString());
                    }
                    else
                    {
                        t.Add("0");
                    }
                    //负荷率 暂时不计算
                    if (d["PERIOD_RL"] != DBNull.Value && d["PERIOD_RL"].ToString() != "" && d["PERIOD_RL"].ToString() != "0")
                    {
                        t.Add(Math.Round(((double.Parse(b[0].ToString())) / double.Parse(d["PERIOD_RL"].ToString())) * 100, 2));
                    }
                    else
                    {
                        t.Add("0");
                    }
                    //风速点
                    if (b.Length > 2)
                    {
                        t.Add(b[2].ToString());
                    }
                    else
                    {
                        t.Add("0");
                    }

                    //电量
                    if (b.Length > 1)
                    {
                        t.Add(b[1].ToString());
                    }
                    else
                    {
                        t.Add("0");
                    }
                    //类型
                    t.Add(d["DATA_TYPE"].ToString());

                    //区域
                    t.Add(d["T_AREA"].ToString());

                    //排序
                    t.Add(d["T_ORDER"].ToString());
                    if (zxType == "2")
                    {
                        t.Add(d["UNIT_ID"].ToString());
                        t.Add(d["ID_KEY"].ToString());
                    }
                    s.Add(t);
                }
            }

            return s;
        }
        #endregion
        #region  获取T_INFO_VALUE表指定测点集合的值(关系数据中的实时值)
        /// <summary>
        ///  获取T_INFO_VALUE表中所有测点集合的信息(关系数据中的实时值)
        /// </summary>
        /// <returns></returns>
        public double[] GetSelectValue(string[] points)
        {
            string[] kw = new string[] { "XCHP.1.00CE30017", "HTXL.00CE30001", "KLFD:1.00CE30001", "BEJP:00CE30001", "XCH2:00CC0001", "XCHP.3.00CE30019", "BERP.1.00CE30001" };
            string[] mw = new string[] { "LNTL:00CC0001", "DBHL:00CC0001", "JSGY.1.00CC0001", "SXGL:1.00CE30001", "CCFD:00CE30001", "MGYP:00CE30001", "MGYP:00CC0001", "SYFD:00CE30001", "NMSP:00CE30001", "JJFD:00CE30001", "NTWP:00CE30001" };
            string[] wkw = new string[] { "DAYQ:00CE30001", "DAEQ:00CE30001", "JYGP:00CE30001", "GZFD:1.00CE30001", "YMFD:1.00CE30001", "AKSP:1.00CE30001", "ZSCB:00CE30001", "FLDP:00CE30001", "DBCP:00CE30001", "QLGS:00CE30001", "HNJP:00CC0001", "HNEQ:00CE30001", "TLEQ:00CE30001", "JTFP:1.00CE30001", "YLEQ:00CE30001", "NMQT:00CE30001", "QSFD:00CE30001", "GLSQ:00CC0001" };
            double[] val = new double[points.Length];
            double v = 0;
            DataTable dtPoints =  GetAllValue();
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

                v = getDouble(v, 2);

                val[i] = v;
            }
            return val;
        }

        #endregion

        #region  获取T_INFO_VALUE表中所有测点集合的信息
        /// <summary>
        ///  获取T_INFO_VALUE表中所有测点集合的信息
        /// </summary>
        /// <returns></returns>
        public DataTable GetAllValue()
        {
            string sql = "SELECT T_POINT,T_VALUE FROM ADMINISTRATOR.T_INFO_VALUE ";
            DataTable dt = dl.RunDataTable(sql, out errMsg);

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
            string sql = "SELECT T_POINT,T_VALUE FROM ADMINISTRATOR.T_INFO_VALUE where T_POINT in (" + pointsName + ")";
            DataTable dt = dl.RunDataTable(sql, out errMsg);

            return dt;
        }

        #endregion

        #region  获取指定的机组的测点
        /// <summary>
        /// 获取指定的机组的测点
        /// </summary>
        /// <param name="IdKey">T_INFO_UNIT 唯一ID标识</param>
        /// <returns></returns>
        public DataTable GetUnitMonitor(string IdKey)
        {
            string sqls = string.Empty;
            sqls = "select  * FROM  Administrator.T_INFO_UNIT AS U LEFT JOIN  Administrator.T_BASE_POINTS  AS P ON U.UNIT_GL_TAG=P.T_POWERTAG where U.ID_KEY=" + IdKey + "";
            DataTable dts = new DataTable();
            dts = dl.RunDataTable(sqls, out errMsg);

            return dts;
        }
        #endregion

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
