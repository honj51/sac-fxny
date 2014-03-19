using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using DAL.Main;
using System.Data;

namespace BLL.BLLMainConnect
{
   public  class BLLMainConnect
    {
         DALMainConnect dm = new DALMainConnect();
         DataTable dt = new DataTable();

        #region 从T_ORIGINAL_POINT表中得到不同类型条件的测点（实时数据读到关系数据库表T_INFO_VALUE中）
        /// <summary>
        /// 从T_ORIGINAL_POINT表中得到不同类型条件的测点（实时数据读到关系数据库表T_INFO_VALUE中）
        /// </summary>
        /// <param name="companyType">电类型（风电，水电...）</param>
        /// <param name="type">点所属层次（电厂，机组）</param>
        /// <param name="pointType">点类型（负荷，风速，日电量，月电量，年电量）</param>
        /// <param name="?"></param>
        /// <returns></returns>
       public List<string> GetTagByKind(string companyType, string type, string pointType)
       {
           List<string> pointName=new List<string> ();
           dt = dm.GetTagByKind(companyType, type, pointType);
           if (dt != null && dt.Rows.Count > 0)
           {
               foreach (DataRow rows in dt.Rows)
               {
                   pointName.Add(rows["T_POINT"]!=DBNull.Value?rows["T_POINT"].ToString():string.Empty);
               }
           }
           return pointName;
       }
        #endregion

       #region 根据测点获取T_INFO_VALUE表中指定测点的值
        /// <summary>
        /// 根据测点获取T_INFO_VALUE表中指定测点的值
        /// </summary>
        /// <param name="pointName">测点的名称</param>
        /// <returns></returns>
       public double GetValueByPoint(string pointName)
       {
           double pointValue = 0;
           dt = dm.GetValueByPoint(pointName);
           if (dt != null && dt.Rows.Count > 0)
           {
               if (dt.Rows[0][0] != DBNull.Value )
               {
                   if (dt.Rows[0][0].ToString() != string.Empty)
                   {
                       if (double.TryParse(dt.Rows[0][0].ToString(), out pointValue))
                       {
                           return pointValue;
                       }
                   }
               }
           }
           return pointValue;
       }
        #endregion

       #region 根据测点获取T_INFO_VALUE表中指定测点集合的信息
       /// <summary>
       /// 根据测点获取T_INFO_VALUE表中指定测点集合的信息
       /// </summary>
       /// <param name="pointsName">测点集合的名称</param>
       /// <returns></returns>
       public double GetValueByPoints(string pointsName)
       {
           double pointValue = 0;
           dt = dm.GetValueByPoints(pointsName);
           if (dt != null && dt.Rows.Count > 0)
           {
               foreach (DataRow d in dt.Rows)
               {
                   double value = 0;
                   if (double.TryParse(d["T_VALUE"].ToString(), out value))
                   {
                       if (value > 0)
                       {
                           pointValue += value;
                       }
                   }
               }
           }
           return pointValue;
       }
       #endregion

       #region 获取测点实时数据库中的值
       /// <summary>
        /// 获取测点值
        /// </summary>
        /// <param name="points">测点集合</param>
        /// <param name="time">测点实时时间</param>
        /// <returns></returns>
       public List<double> GetPointVal(List<string> points, string time)
       {
           List<double> val = new List<double>();
           val = dm.GetPointVal(points, time);
           return val;
       }

       #endregion


    }
}
