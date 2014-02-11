using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using DAL;
using System.Collections;

namespace BLL
{
    public class PointBLL
    {
        PointDAL point = new PointDAL();
        /// <summary>
        /// 获取实时数据
        /// </summary>
        /// <param name="point">测点名称</param>
        /// <param name="sTime">开始时间</param>
        /// <param name="type">查询类型   日:1 月:2 年:3</param>
        /// <returns></returns>
        public string GetVal(string points, string sTime, string type)
        {
            return point.GetVal(points, sTime, type);
        }

        /// <summary>
        /// 获取实时数据
        /// </summary>
        /// <param name="point">测点名称</param>
        /// <param name="sTime">开始时间</param>
        /// <param name="type">查询类型   日:1 月:2 年:3</param>
        /// <returns></returns>
        public IList<Hashtable> GetValList(string points, string sTime, string type)
        {
            return point.GetValList(points, sTime, type);
        }

        /// <summary>
        /// 获取多个数据测点的历史值
        /// </summary>
        /// <param name="points">测点集合</param>
        /// <param name="sTime">开始时间</param>
        /// <param name="eTime">结束时间</param>
        /// <param name="seconds">间隔时间  秒</param>
        /// <returns></returns>
        public IList<Hashtable> GetVal(string[] points, string[] pointNames, string sTime, string eTime, int seconds)
        {
            return point.GetVal(points, pointNames, sTime, eTime, seconds);
        }

        /// <summary>
        /// 获取多个数据测点的历史值
        /// </summary>
        /// <param name="points">测点集合</param>
        /// <param name="sTime">开始时间</param>
        /// <param name="eTime">结束时间</param>
        /// <param name="seconds">间隔时间  秒</param>
        /// <returns></returns>
        public IList<Hashtable> GetValToTable(string[] points, string[] pointNames, string sTime, string eTime, int seconds)
        {
            return point.GetValToTable(points, pointNames, sTime, eTime, seconds);
        }

        /// <summary>
        /// 查询某段时间测点集合的历史值-刘海杰
        /// </summary>
        /// <param name="names">测点集合</param>
        /// <param name="st">开始时间</param>
        /// <param name="et">结束时间</param>
        /// <returns></returns>
        public IList<Hashtable> GetHistValAndTIme1(string[] points, DateTime st, DateTime et)
        {
            return point.GetHistValAndTIme1(points, st, et);
        }

        /// <summary>
        /// 查询某段时间测点集合的历史值,去一定数量点。
        /// </summary>
        /// <param name="names">测点集合</param>
        /// <param name="st">开始时间</param>
        /// <param name="et">结束时间</param>
        /// <returns></returns>
        public IList<Hashtable> GetHistValAndTIme3(string[] points, DateTime st, DateTime et,int count)
        {
            return point.GetHistValAndTIme3(points, st, et,count);
        }

        /// <summary>
        /// 查询某段时间测点集合的历史值-刘海杰
        /// </summary>
        /// <param name="names">测点集合</param>
        /// <param name="st">开始时间</param>
        /// <param name="et">结束时间</param>
        /// <returns></returns>
        public IList<Hashtable> GetHistValAndTIme2(string[] points, DateTime st, DateTime et, int jiange)
        {
            return point.GetHistValAndTIme2(points, st, et, jiange);
        }

        /// <summary>
        /// 获取测点最新值
        /// </summary>
        /// <param name="points"></param>
        /// <param name="time"></param>
        /// <returns></returns>
        public double[] GetPointVal(string[] points, string time)
        {
            return point.GetPointVal(points, time);
        }

    }
}
