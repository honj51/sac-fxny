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
                    double[] b = pd.GetPointVal(a, DateTime.Now.ToString("yyyy-MM-dd HH:mm:00"));

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
    }
}
