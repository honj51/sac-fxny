using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Collections;
using SAC.DBOperations;
using SAC.Helper;
using SAC.RealTimeDB;

namespace DAL
{
    public class PointDAL
    {
        double drv = 0;

        string val = "";
        IList<Hashtable> list = new List<Hashtable>();
        DBLink dl = new DBLink();

        string[] kw = new string[] { "XCHP.1.00CE30017", "HTXL.00CE30001", "KLFD:1.00CE30001", "BEJP:00CE30001", "XCH2:00CC0001", "XCHP.3.00CE30019", "BERP.1.00CE30001" };
        string[] mw = new string[] { "LNTL:00CC0001","DBHL:00CC0001","JSGY.1.00CC0001","SXGL:1.00CE30001","CCFD:00CE30001","MGYP:00CE30001","MGYP:00CC0001","SYFD:00CE30001","NMSP:00CE30001","JJFD:00CE30001","NTWP:00CE30001" };
        string[] wkw = new string[] { "DAYQ:00CE30001","DAEQ:00CE30001","JYGP:00CE30001","GZFD:1.00CE30001","YMFD:1.00CE30001","AKSP:1.00CE30001","ZSCB:00CE30001","FLDP:00CE30001","DBCP:00CE30001","QLGS:00CE30001","HNJP:00CC0001","HNEQ:00CE30001","TLEQ:00CE30001","JTFP:1.00CE30001","YLEQ:00CE30001","NMQT:00CE30001","QSFD:00CE30001","GLSQ:00CC0001" };
        /// <summary>
        /// 获取测点数据
        /// </summary>
        /// <param name="point">测点名称</param>
        /// <param name="sTime">开始时间</param>
        /// <param name="eTime">结束时间</param>
        /// <param name="seconds">间隔时间  秒</param>
        /// <returns></returns>
        public IList<Hashtable> GetVal(string point, string pointName, string sTime, string eTime, int seconds)
        {
            int count = Convert.ToDateTime(eTime).Second - Convert.ToDateTime(sTime).Second;

            for (int i = 0; i < count; i++)
            {

            }

            return list;
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
            if (points.Length < 1)
            {
                return null;
            }

            Plink pk = new Plink();
            //DateTime dt = new DateTime();
            int num = 0;

            int day = 0;
            int hour = 0;
            int minute = 0;
            int second = 0;

            day = Convert.ToDateTime(eTime).Day - Convert.ToDateTime(sTime).Day;
            hour = Convert.ToDateTime(eTime).Hour - Convert.ToDateTime(sTime).Hour;
            minute = Convert.ToDateTime(eTime).Minute - Convert.ToDateTime(sTime).Minute;
            second = Convert.ToDateTime(eTime).Second - Convert.ToDateTime(sTime).Second;

            second = day * 24 * 3600 + hour * 3600 + minute * 60 * second;

            num = Convert.ToDateTime(eTime).Second - Convert.ToDateTime(sTime).Second;
            num = second / seconds;
            if (second % seconds != 0)
                num += 1;

            DateTime _sTime = new DateTime(1970, 1, 1);

            Plink.OpenPi();
            //循环测点
            for (int i = 0; i < pointNames.Length; i++)
            {
                Hashtable ht = new Hashtable();
                ht.Add("name", pointNames[i]);//添加测点名称
                string _st = sTime;

                ArrayList listD = new ArrayList();
                for (int k = 0; k < num; k++)
                {
                    ArrayList listPoint = new ArrayList();
                    eTime = _st;
                    listPoint.Add(Convert.ToInt64((Convert.ToDateTime(eTime) - _sTime).TotalMilliseconds.ToString()));
                    pk.GetHisValue(points[i], eTime, ref drv);
                    if (drv > 0)
                        drv = getDouble(drv, 3);
                    listPoint.Add(drv);
                    _st = Convert.ToDateTime(eTime).AddSeconds(seconds).ToString();
                    listD.Add(listPoint);
                }
                ht.Add("data", listD);
                list.Add(ht);
            }
            //Plink.closePi();
            return list;
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
            Plink pk = new Plink();
            int num = 0;

            int day = 0;
            int hour = 0;
            int minute = 0;
            int second = 0;

            day = Convert.ToDateTime(eTime).Day - Convert.ToDateTime(sTime).Day;
            hour = Convert.ToDateTime(eTime).Hour - Convert.ToDateTime(sTime).Hour;
            minute = Convert.ToDateTime(eTime).Minute - Convert.ToDateTime(sTime).Minute;
            second = Convert.ToDateTime(eTime).Second - Convert.ToDateTime(sTime).Second;

            second = day * 24 * 3600 + hour * 3600 + minute * 60 * second;

            num = Convert.ToDateTime(eTime).Second - Convert.ToDateTime(sTime).Second;
            num = second / seconds;
            if (second % seconds != 0)
                num += 1;

            DateTime _sTime = new DateTime(1970, 1, 1);
            Hashtable ht = new Hashtable();

            for (int k = 0; k < num; k++)
            {
                sTime = Convert.ToDateTime(sTime).AddSeconds(seconds).ToString();
                eTime = sTime;

                ht = new Hashtable();

                for (int i = 0; i < pointNames.Length; i++)
                {
                    if (i == 0)
                    {
                        ht.Add("时间", eTime);
                        pk.GetHisValue(points[i], eTime, ref drv);
                        ht.Add(pointNames[i], drv);
                    }
                    else
                    {
                        pk.GetHisValue(points[i], eTime, ref drv);
                        ht.Add(pointNames[i], drv);
                    }

                }
                list.Add(ht);
            }


            return list;
        }

        /// <summary>
        /// 获取实时数据
        /// </summary>
        /// <param name="point">测点名称</param>
        /// <param name="sTime">开始时间</param>
        /// <param name="type">查询类型   日:1 月:2 年:3</param>
        /// <returns></returns>
        public string GetVal(string point, string sTime, string type)
        {
            Plink pk = new Plink();
            DateTime dt = new DateTime();
            val = "";
            Plink.OpenPi();
            if (type == "1")
            {
                dt = Convert.ToDateTime(Convert.ToDateTime(sTime).ToString("yyyy-01-01 23:59:59"));
                for (int i = 0; i < 365; i++)
                {
                    pk.GetHisValue(point, dt.ToString(), ref drv);
                    if (drv > 0)
                        drv = getDouble(drv, 3);
                    val += drv + ",";
                    dt = dt.AddDays(1);
                }
            }
            else if (type == "2")
            {
                int month = Convert.ToDateTime(sTime).Month;
                int year = Convert.ToDateTime(sTime).Year;

                dt = Convert.ToDateTime(Convert.ToDateTime(sTime).ToString("yyyy-MM-1 11:59:59"));

                if (month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12)
                {
                    for (int i = 0; i < 62; i++)
                    {
                        pk.GetHisValue(point, dt.ToString(), ref drv);
                        if (drv > 0)
                            drv = getDouble(drv, 3);
                        val += drv + ",";
                        dt = dt.AddHours(12);
                    }
                }
                else if (month == 4 || month == 6 || month == 9 || month == 11)
                {
                    for (int i = 0; i < 60; i++)
                    {
                        pk.GetHisValue(point, dt.ToString(), ref drv);
                        if (drv > 0)
                            drv = getDouble(drv, 3);
                        val += drv + ",";
                        dt = dt.AddHours(12);
                    }
                }
                else
                {
                    if (year % 4 == 0)
                    {

                        for (int i = 0; i < 58; i++)
                        {
                            pk.GetHisValue(point, dt.ToString(), ref drv);
                            if (drv > 0)
                                drv = getDouble(drv, 3);
                            val += drv + ",";
                            dt = dt.AddHours(12);
                        }
                    }
                    else
                    {

                        for (int i = 0; i < 55; i++)
                        {
                            pk.GetHisValue(point, dt.ToString(), ref drv);
                            if (drv > 0)
                                drv = getDouble(drv, 3);
                            val += drv + ",";
                            dt = dt.AddHours(12);
                        }
                    }
                }
            }
            else if (type == "3")
            {
                dt = Convert.ToDateTime(Convert.ToDateTime(sTime).ToString("yyyy-MM-dd 0:14:59"));
                for (int i = 0; i < 96; i++)
                {
                    pk.GetHisValue(point, dt.ToString(), ref drv);
                    if (drv > 0)
                        drv = getDouble(drv, 3);
                    val += drv + ",";
                    dt = dt.AddMinutes(15);
                }
            }

            if (val.Length > 0)
                //val = val.Substring(0, val.Length - 1);
                val = val.Remove(val.LastIndexOf(","), 1);
            Plink.closePi();
            return val;
        }



        /// <summary>
        /// 获取实时数据
        /// </summary>
        /// <param name="point">测点名称</param>
        /// <param name="sTime">开始时间</param>
        /// <param name="type">查询类型   年:1 月:2 日:3</param>
        /// <returns></returns>
        public IList<Hashtable> GetValList(string point, string sTime, string type)
        {
            Plink pk = new Plink();
            DateTime dt = new DateTime();
            Hashtable h = new Hashtable();
            val = "";
            Plink.OpenPi();
            if (type == "1")//年比
            {
                dt = Convert.ToDateTime(Convert.ToDateTime(sTime).ToString("yyyy-01-01 23:59:59"));
                for (int i = 0; i < 365; i++)
                {
                    h = new Hashtable();
                    h.Add("时间", dt.ToString("MM-dd HH:ss:mm"));
                    pk.GetHisValue(point, dt.AddYears(-1).ToString(), ref drv);
                    if (drv > 0)
                        drv = getDouble(drv, 3);
                    h.Add("去年", drv);
                    pk.GetHisValue(point, dt.ToString(), ref drv);
                    if (drv > 0)
                        drv = getDouble(drv, 3);
                    h.Add("今年", drv);
                    dt = dt.AddDays(1);
                    list.Add(h);
                }

            }
            else if (type == "2")//月比
            {
                int month = Convert.ToDateTime(sTime).Month;
                int year = Convert.ToDateTime(sTime).Year;

                dt = Convert.ToDateTime(Convert.ToDateTime(sTime).ToString("yyyy-MM-1 11:59:59"));

                if (month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12)
                {
                    for (int i = 0; i < 62; i++)
                    {
                        h = new Hashtable();
                        h.Add("时间", dt.ToString("MM-dd HH:ss:mm"));
                        pk.GetHisValue(point, dt.AddYears(-1).ToString(), ref drv);
                        if (drv > 0)
                            drv = getDouble(drv, 3);
                        h.Add("去年", drv);
                        pk.GetHisValue(point, dt.ToString(), ref drv);
                        if (drv > 0)
                            drv = getDouble(drv, 3);
                        h.Add("今年", drv);
                        dt = dt.AddHours(12);
                        list.Add(h);
                    }
                }
                else if (month == 4 || month == 6 || month == 9 || month == 11)
                {
                    for (int i = 0; i < 60; i++)
                    {
                        h = new Hashtable();
                        h.Add("时间", dt.ToString("MM-dd HH:ss:mm"));
                        pk.GetHisValue(point, dt.AddYears(-1).ToString(), ref drv);
                        if (drv > 0)
                            drv = getDouble(drv, 3);
                        h.Add("去年", drv);
                        pk.GetHisValue(point, dt.ToString(), ref drv);
                        if (drv > 0)
                            drv = getDouble(drv, 3);
                        h.Add("今年", drv);
                        dt = dt.AddHours(12);
                        list.Add(h);
                    }
                }
                else
                {
                    if (year % 4 == 0)
                    {

                        for (int i = 0; i < 58; i++)
                        {
                            h = new Hashtable();
                            h.Add("时间", dt.ToString("MM-dd HH:ss:mm"));
                            pk.GetHisValue(point, dt.AddYears(-1).ToString(), ref drv);
                            if (drv > 0)
                                drv = getDouble(drv, 3);
                            h.Add("去年", drv);
                            pk.GetHisValue(point, dt.ToString(), ref drv);
                            if (drv > 0)
                                drv = getDouble(drv, 3);
                            h.Add("今年", drv);
                            dt = dt.AddHours(12);
                            list.Add(h);
                        }
                    }
                    else
                    {

                        for (int i = 0; i < 55; i++)
                        {
                            h = new Hashtable();
                            h.Add("时间", dt.ToString("MM-dd HH:ss:mm"));
                            pk.GetHisValue(point, dt.AddYears(-1).ToString(), ref drv);
                            if (drv > 0)
                                drv = getDouble(drv, 3);
                            h.Add("去年", drv);
                            pk.GetHisValue(point, dt.ToString(), ref drv);
                            if (drv > 0)
                                drv = getDouble(drv, 3);
                            h.Add("今年", drv);
                            dt = dt.AddHours(12);
                            list.Add(h);
                        }
                    }
                }
            }
            else if (type == "3")//日比
            {
                dt = Convert.ToDateTime(Convert.ToDateTime(sTime).ToString("yyyy-MM-dd 0:14:59"));
                for (int i = 0; i < 96; i++)
                {
                    h = new Hashtable();
                    h.Add("时间", dt.ToString("HH:ss:mm"));
                    pk.GetHisValue(point, dt.AddYears(-1).ToString(), ref drv);
                    if (drv > 0)
                        drv = getDouble(drv, 3);
                    h.Add("去年", drv);
                    pk.GetHisValue(point, dt.ToString(), ref drv);
                    if (drv > 0)
                        drv = getDouble(drv, 3);
                    h.Add("今年", drv);
                    dt = dt.AddMinutes(15);
                    list.Add(h);
                }
            }

            Plink.closePi();
            return list;
        }


        /// <summary>
        /// 查询某段时间测点集合的历史值 -刘海杰
        /// </summary>
        /// <param name="names">测点集合</param>
        /// <param name="st">开始时间</param>
        /// <param name="et">结束时间</param>
        /// <returns></returns>
        public IList<Hashtable> GetHistValAndTIme1(string[] points, DateTime st, DateTime et)
        {
            ArrayList list = new ArrayList();
            Plink pk = new Plink();
            IList<Hashtable> listdata = new List<Hashtable>();

            Hashtable ht = new Hashtable();
            ArrayList ld = new ArrayList();
            ArrayList lt = new ArrayList();
            for (int i = 0; i < points.Length; i++)
            {
                ht = new Hashtable();
                lt = new ArrayList();
                ht.Add("name", points[i].Split('|')[1]);
                ht.Add("yAxis", i);
                DateTime _sTime = new DateTime(1970, 1, 1);
                int seconds = Convert.ToInt32((et - st).TotalSeconds) / 600;
                DateTime dtt = st;
                Plink.OpenPi();
                while (dtt < et)
                {
                    ld = new ArrayList();
                    pk.GetHisValue(points[i].Split('|')[0], dtt.ToString("yyyy-MM-dd HH:mm:ss"), ref drv);
                    if (drv > 0)
                    {
                        drv = getDouble(drv, 3);
                    }
                    string timeStamp = DateTimeToUTC(dtt).ToString();
                    DateTime dtStart = TimeZone.CurrentTimeZone.ToLocalTime(new DateTime(1970, 1, 1));
                    long lTime = long.Parse(timeStamp + "0000000");
                    TimeSpan toNow = new TimeSpan(lTime);
                    DateTime dtResult = dtStart.Add(toNow);
                    ld.Add(Convert.ToInt64((dtResult - _sTime).TotalMilliseconds.ToString()));
                    ld.Add(drv);
                    lt.Add(ld);
                    // TimeSpan toNow1 = new TimeSpan(seconds);
                    dtt = dtt.AddSeconds(seconds);
                }
                ht.Add("data", lt);
                listdata.Add(ht);
                //lt = new ArrayList();
                //ht = new Hashtable();
            }

            return listdata;
        }
        /// <summary>
        /// 查询某段时间测点集合的历史值，去一定数量点。 
        /// </summary>
        /// <param name="names">测点集合</param>
        /// <param name="st">开始时间</param>
        /// <param name="et">结束时间</param>
        /// <returns></returns>
        public IList<Hashtable> GetHistValAndTIme3(string[] points, DateTime st, DateTime et,int count)
        {
            ArrayList list = new ArrayList();
            Plink pk = new Plink();
            IList<Hashtable> listdata = new List<Hashtable>();

            Hashtable ht = new Hashtable();
            ArrayList ld = new ArrayList();
            ArrayList lt = new ArrayList();
            for (int i = 0; i < points.Length; i++)
            {
                ht = new Hashtable();
                lt = new ArrayList();
                ht.Add("name", points[i].Split('|')[1]);
                ht.Add("yAxis", i);
                DateTime _sTime = new DateTime(1970, 1, 1);
                int seconds = Convert.ToInt32((et - st).TotalSeconds) / count;
                DateTime dtt = st;
                Plink.OpenPi();
                while (dtt < et)
                {
                    ld = new ArrayList();
                    pk.GetHisValue(points[i].Split('|')[0], dtt.ToString("yyyy-MM-dd HH:mm:ss"), ref drv);
                    if (drv > 0)
                    {
                        drv = getDouble(drv, 3);
                    }
                    string timeStamp = DateTimeToUTC(dtt).ToString();
                    DateTime dtStart = TimeZone.CurrentTimeZone.ToLocalTime(new DateTime(1970, 1, 1));
                    long lTime = long.Parse(timeStamp + "0000000");
                    TimeSpan toNow = new TimeSpan(lTime);
                    DateTime dtResult = dtStart.Add(toNow);
                    ld.Add(Convert.ToInt64((dtResult - _sTime).TotalMilliseconds.ToString()));
                    ld.Add(drv);
                    lt.Add(ld);
                    // TimeSpan toNow1 = new TimeSpan(seconds);
                    dtt = dtt.AddSeconds(seconds);
                }
                ht.Add("data", lt);
                listdata.Add(ht);
                //lt = new ArrayList();
                //ht = new Hashtable();
            }

            return listdata;
        }
        //将一个事件对象转换为UTC格式的时间
        public static int DateTimeToUTC(DateTime DT)
        {
            long a = new DateTime(1970, 1, 1, 0, 0, 0, 0).Ticks;
            int rtnInt = 0;
            rtnInt = (int)((DT.Ticks - 8 * 3600 * 1e7 - a) / 1e7);
            return rtnInt;
        }
        /// <summary>
        /// 查询某段时间测点集合的历史值 -刘海杰
        /// </summary>
        /// <param name="names">测点集合</param>
        /// <param name="st">开始时间</param>
        /// <param name="et">结束时间</param>
        /// <returns></returns>
        public IList<Hashtable> GetHistValAndTIme2(string[] points, DateTime st, DateTime et, int jiange)
        {
            ArrayList list = new ArrayList();
            Plink pk = new Plink();
            IList<Hashtable> listdata = new List<Hashtable>();

            Hashtable ht = new Hashtable();
            ArrayList ld = new ArrayList();
            ArrayList lt = new ArrayList();
            for (int i = 0; i < points.Length; i++)
            {
                ht = new Hashtable();
                ht.Add("name", points[i].Split('|')[1]);
                ht.Add("yAxis", i);
                DateTime _sTime = new DateTime(1970, 1, 1);
                // int seconds = Convert.ToInt32((et - st).TotalSeconds) / 600;
                DateTime dtt = st;
                Plink.OpenPi();
                while (dtt < et)
                {
                    ld = new ArrayList();
                    pk.GetHisValue(points[i].Split('|')[0], dtt.ToString("yyyy-MM-dd HH:mm:ss"), ref drv);
                    if (drv > 0)
                    {
                        drv = getDouble(drv, 3);
                    }
                    string timeStamp = DateTimeToUTC(dtt).ToString();
                    DateTime dtStart = TimeZone.CurrentTimeZone.ToLocalTime(new DateTime(1970, 1, 1));
                    long lTime = long.Parse(timeStamp + "0000000");
                    TimeSpan toNow = new TimeSpan(lTime);
                    DateTime dtResult = dtStart.Add(toNow);
                    ld.Add(Convert.ToInt64((dtResult - _sTime).TotalMilliseconds.ToString()));
                    ld.Add(drv);
                    lt.Add(ld);
                    // TimeSpan toNow1 = new TimeSpan(seconds);
                    dtt = dtt.AddSeconds(jiange);
                }
                ht.Add("data", lt);
                listdata.Add(ht);
                //lt = new ArrayList();
                //ht = new Hashtable();
            }

            return listdata;
        }

        /// <summary>
        /// 获取测点最新值
        /// </summary>
        /// <param name="points"></param>
        /// <param name="time"></param>
        /// <returns></returns>
        public double[] GetPointVal(string[] points, string time)
        {
            double[] val = new double[points.Length];
            double v = 0;
            Plink pk = new Plink();
            Plink.OpenPi();
            for (int i = 0; i < points.Length; i++)
            {
                pk.GetHisValue(points[i], time, ref v);
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
