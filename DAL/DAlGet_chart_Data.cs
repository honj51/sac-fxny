using System;
using SAC.Helper;
using System.Text;
using System.Data;
using System.Linq;
using System.Collections;
using System.Collections.Generic;
using SAC.DBOperations;
using SAC.RealTimeDB;

///作者：刘海杰   
///创建日期：2013-06-08
///
namespace DAL
{
    public class DAlGet_chart_Data
    {
        int count;

        string sql = "";
        string errMsg = "";
        string rtDBType = "";   //实时数据库
        string rlDBType = "";   //关系数据库
        DBLink dl = new DBLink();
        DALPubMehtod pm = new DALPubMehtod();

 

        public ArrayList GetChartData()
        {
            ArrayList list = new ArrayList();
            return list;
        }

        /// <summary>
        /// 值报
        /// </summary>
        /// <param name="repName"></param>
        /// <param name="unit"></param>
        /// <returns></returns>
        public ArrayList GetChartData(string Trendid, string sdate,string edate)
        {
        
            double drvA = 0;
            int ret = 0;
            string pName = null;
            ArrayList list = new ArrayList();

            count = pm.GetCountByChart(Trendid);
            //countKey = pm.GetCountkey(repName, 1);

            DateTime dtNow = DateTime.Now;

            string[] de = null; //describe 趋势参数描述
            string[] un = null;//单位
            string[] dv = null; //值
            string[] ma = new string[7]; //mark   xy轴刻度


            LogHelper.WriteLog(LogHelper.EnLogType.Run, DateTime.Now.ToString("yyyy-MM-dd H:mm:ss") + " 值报开始.......");

            LogHelper.WriteLog(LogHelper.EnLogType.Run, DateTime.Now.ToString("yyyy-MM-dd H:mm:ss") + " count Value=" + count);

            try
            {
                de = new string[count];
                un = new string[count];
                dv = new string[count];

                //判断是否多y轴，判断是否自动y轴刻度，如果是则取出y轴刻度
                sql = "select MULITYAXIS, YMAX, YMIN, YAUTO from administrator.T_INFO_CHART_USERTEMPLATE where CHARTID='" + Trendid + "'";

                DataTable dtInfo = null;

                //if (rlDBType == "SQL")
                //    dtInfo = DBsql.RunDataTable(sql, out errMsg);
                //else
                //    dtInfo = DBdb2.RunDataTable(sql, out errMsg);
                dtInfo = dl.RunDataTable(sql, out errMsg);

                if (dtInfo != null && dtInfo.Rows.Count > 0)
                {
                    ma[0] = dtInfo.Rows[0]["MULITYAXIS"].ToString();
                    ma[1] = dtInfo.Rows[0]["YAUTO"].ToString();
                    ma[2] = dtInfo.Rows[0]["YMAX"].ToString();
                    ma[3] = dtInfo.Rows[0]["YMIN"].ToString();
                }
                else
                {
                    LogHelper.WriteLog(LogHelper.EnLogType.Run, DateTime.Now.ToString("yyyy-MM-dd H:mm:ss") + " 读取[xy轴刻度]信息失败......");
                }
//ID_KEY, CHARTID, PARAID, PARADESC, PARATYPE, SQL, REALTIME, PERIOD, SHIFT, YMAX, YMIN, YAUTO, UNIT
                sql = "select count(*) from administrator.T_INFO_CHART_CHARTPARA where CHARTID = '" + Trendid + "' ";

                DataTable dtLevBZ = null;
                int a=0;
                //if (rlDBType == "SQL")
                //{
                //    dtLevBZ = DBsql.RunDataTable(sql, out errMsg);
                //}
                //else
                //{
                //    dtLevBZ = DBdb2.RunDataTable(sql, out errMsg);
                //}
                dtLevBZ = dl.RunDataTable(sql, out errMsg);

                if (dtLevBZ != null &&Convert.ToInt32(dtLevBZ.Rows[0][0].ToString()) > 0)
                {
                    #region SQL

                    sql = "select * from administrator.T_INFO_CHART_CHARTPARA where CHARTID = '" + Trendid + "' and PARATYPE='SQL' ";

                    DataTable dtSQL = null;
                    DataSet dssql = null;
                    //if (rlDBType == "SQL")
                    //{
                    //    dtSQL = DBsql.RunDataTable(sql, out errMsg);
                    //}
                    //else
                    //{
                    //    dtSQL = DBdb2.RunDataTable(sql, out errMsg);
                    //}
                    dtSQL = dl.RunDataTable(sql, out errMsg);
                    if (dtSQL != null && dtSQL.Rows.Count > 0)
                    {
                        for (int i = 0; i < dtSQL.Rows.Count; i++)
                        {
                            de[a] = dtSQL.Rows[i]["PARADESC"].ToString();
                            un[a] = dtSQL.Rows[i]["UNIT"].ToString();
                            ma[4] += dtSQL.Rows[i]["YAUTO"].ToString()+",";
                            ma[5] += dtSQL.Rows[i]["YMAX"].ToString()+",";
                            ma[6] += dtSQL.Rows[i]["YMIN"].ToString()+",";
                            sql = dtSQL.Rows[i]["SQL"].ToString();

                            if (sql.Contains("&bt&") && sql.Contains("&et&"))
                            {
                                sql = sql.Replace("&bt&", DateTime.Parse(sdate).AddSeconds(Convert.ToDouble(dtSQL.Rows[i]["SHIFT"].ToString())).ToString());
                                sql = sql.Replace("&et&", DateTime.Parse(edate).AddSeconds(Convert.ToDouble(dtSQL.Rows[i]["SHIFT"].ToString())).ToString());
                            }

                            //if (rlDBType == "SQL")
                            //{
                            //    dssql = DBsql.RunDataSet(sql, out errMsg);
                            //}
                            //else
                            //{
                            //    dssql = DBdb2.RunDataSet(sql, out errMsg);
                            //}
                            dssql = dl.RunDataSet(sql, out errMsg);
                            for (int j = 0; j < dssql.Tables[0].Rows.Count; j++)
                            {
                                dv[a] += dssql.Tables[0].Rows[j][0].ToString() + "+" + dssql.Tables[0].Rows[j][1].ToString();
                                if (j != dssql.Tables[0].Rows.Count - 1)
                                {
                                    dv[a] += ",";
                                }
                                else
                                {
                                    dv[a] += ";";
                                }
                            }
                            a++;

                        }
                    }
                    #endregion

                    #region 实时数据库
                    sql = "select * from administrator.T_INFO_CHART_CHARTPARA where CHARTID = '" + Trendid + "' and PARATYPE='RT' ";

                    DataTable dtAvg = null;
                    DateTime dtsql = DateTime.Now;
                    //if (rlDBType == "SQL")
                    //{
                    //    dtAvg = DBsql.RunDataTable(sql, out errMsg);
                    //}
                    //else
                    //{
                    //    dtAvg = DBdb2.RunDataTable(sql, out errMsg);
                    //}
                    dtAvg = dl.RunDataTable(sql, out errMsg);
                    if (dtAvg != null && dtAvg.Rows.Count > 0)
                    {
                        for (int i = 0; i < dtAvg.Rows.Count; i++)
                        {
                            de[a] = dtAvg.Rows[i]["PARADESC"].ToString();
                            un[a] = dtAvg.Rows[i]["UNIT"].ToString();
                            pName = dtAvg.Rows[i]["REALTIME"].ToString();
                            
                            DateTime date =DateTime.Parse(sdate);
                            while(date<DateTime.Parse(edate))
                            {
                                if (rtDBType == "EDNA")
                                {
                                    //ek.GetHisValueByTime(pName, sdate, ref ret, ref drvA);
                                }
                                else
                                {
                                   // pk.GetHisValue(pName, sdate, ref drvA);
                                }
                                dv[a] +=sdate+"+"+ drvA.ToString() +",";

                                date =date.AddSeconds(Convert.ToDouble(dtAvg.Rows[i]["SHIFT"].ToString()));
                            }

                            a++;
                        }
                    }
                    #endregion
                }
            }
            catch (Exception ce)
            { 
                LogHelper.WriteLog(LogHelper.EnLogType.Run, DateTime.Now.ToString("yyyy-MM-dd H:mm:ss") + " 程序异常: " + ce.Message); 
            }

            list.Add(de);
            list.Add(un);
            list.Add(dv);
            list.Add(ma);

            return list;
        }
        /// <summary>
        /// 获取T_INFO_CHART_USERTEMPLATE表中USERID
        /// </summary>
        /// <returns></returns>

        public DataSet Get_Userid()
        {
            DataSet DS = new DataSet();
            string sql = "select USERID from administrator.T_INFO_CHART_USERTEMPLATE group by [USERID]";
            DS = dl.RunDataSet(sql, out errMsg);
            return DS;
        }
        /// <summary>
        /// 根据USERID从T_INFO_CHART_USERTEMPLATE获取模板ID，说明。现用于TendManage页面DataGrid呈现
        /// </summary>
        /// <param name="user_id">用户ID</param>
        /// <returns></returns>
        public DataSet Get_Chartid(string user_id)
        {
            DataSet DS = new DataSet();
            string sql = "select row_number()over(order by CHARTID )as id,CHARTID,CHARTDESC from administrator.T_INFO_CHART_USERTEMPLATE where USERID='" + user_id+"'";
            DS = dl.RunDataSet(sql, out errMsg);
            return DS;
        }
        /// <summary>
        /// 根据CHARTID到T_INFO_CHART_CHARTPARA中查询实时测点、测点名称
        /// </summary>
        /// <param name="chart_id"></param>
        /// <returns></returns>
        public DataSet GetPara_id(string chart_id)
        {
            DataSet DS = new DataSet();
            string sql = "select REALTIME,PARADESC from administrator.T_INFO_CHART_CHARTPARA where CHARTID='" + chart_id + "'";
            DS = dl.RunDataSet(sql, out errMsg);
            return DS;
        }

        //public DataSet GetChart_Id(string chart_id)
        //{
        //    DataSet DS = new DataSet();
        //    string sql = "select CHARTID from administrator.T_INFO_CHART_CHARTPARA where CHARTID='" + chart_id + "'";
        //    DS = DBsql.RunDataSet(sql, out errMsg);
        //    return DS;
        //}

        /// <summary>
        /// 根据LEVEL的集合从数据库里面获取
        /// </summary>
        /// <param name="id">表名，T_BASE_PARAID_XNY_WIND，T_BASE_PARAID_XNY_SUN</param>
        /// <param name="para_id">全部LEVEL的集合</param>
        /// <returns></returns>
        public DataSet Get_ChartidByLEVEL(string id,string[] para_id)
        {
            DataSet DS = new DataSet();
            string sql = "";
            if (id == "T_BASE_PARAID_XNY_WIND")
            {
                sql = "select REALTIME,PARADESC from administrator.T_BASE_PARAID_XNY_WIND where LEVEL1='" + para_id[0] + "' and LEVEL2 ='" + para_id[1] + "' and LEVEL3='" + para_id[2] + "'";
            }
            else if (id == "T_BASE_PARAID_XNY_SUN")
            {
                sql = "select REALTIME,PARADESC from administrator.T_BASE_PARAID_XNY_SUN where LEVEL1='" + para_id[0] + "' and LEVEL2 ='" + para_id[1] + "' and LEVEL3='" + para_id[2] + "' and LEVEL4='" + para_id[3] + "'";
            }
            DS = dl.RunDataSet(sql, out errMsg);
            return DS;
        }

        /// <summary>
        /// 根据测点名称模糊查询结果
        /// </summary>
        /// <param name="id"></param>
        /// <param name="para_id"></param>
        /// <returns></returns>
        public DataSet Get_ChartidByFuzzy_Query(string id, string[] para_id)
        {
            DataSet DS = new DataSet();
            string sql = "";
            if (id == "T_BASE_PARAID_WIND")
            {
                //string sql_query = "select PARATYPE,SQL from T_BASE_PARAID_XNY_WIND where LEVEL1='" + para_id[0] + "' and LEVEL2 ='" + para_id[1] + "' and LEVEL3='" + para_id[2] + "' and PARADESC like '" + para_id[3] + "'";
                //DataSet DS_QUERY = DBsql.RunDataSet(sql_query, out errMsg);
                //if (DS_QUERY.Tables[0].Rows[0]["PARATYPE"].ToString() == "RT")
                //{
                sql = "select REALTIME,PARADESC from administrator.T_BASE_PARAID_WIND where LEVEL1='" + para_id[0] + "' and LEVEL2 ='" + para_id[1] + "' and LEVEL3='" + para_id[2] + "' and PARADESC like '" + para_id[3] + "'";
                //}
                //else
                //{
                //    sql = DS_QUERY.Tables[0].Rows[0]["SQL"].ToString(); 
                //}
            }
            else if (id == "T_BASE_PARAID_SUN")
            {
                sql = "select REALTIME,PARADESC from administrator.T_BASE_PARAID_SUN where LEVEL1='" + para_id[0] + "' and LEVEL2 ='" + para_id[1] + "' and LEVEL3='" + para_id[2] + "' and PARADESC like '" + para_id[3] + "'";
            }
            DS = dl.RunDataSet(sql, out errMsg);
            return DS;
        }
        /// <summary>
        /// 从表中得出唯一LEVEL
        /// </summary>
        /// <param name="id">表名</param>
        /// <param name="level_id">LEVELID</param>
        /// <param name="para_id">上一级LEVELID</param>
        /// <returns></returns>
        public DataSet Get_Paraid(string id,string level_id,string para_id)
        {
            DataSet DS = new DataSet();
            string sql = "";
            if (level_id == "LEVEL1")
            {
                sql = "select distinct(" + level_id + ") from " + id;
            }
            else if (level_id == "LEVEL2")
            {
                sql = "select distinct(" + level_id + ") from " + id + " where LEVEL1='" + para_id+"'";
            }
            else if (level_id == "LEVEL3")
            {
                sql = "select distinct(" + level_id + ") from " + id + " where LEVEL2='" + para_id + "'";
            }
            else if (level_id == "LEVEL4")
            {
                sql = "select distinct(" + level_id + ") from " + id + " where LEVEL3='" + para_id + "'";
            }
            DS = dl.RunDataSet(sql, out errMsg);
            return DS;
        }

        /// <summary>
        /// 根据CHARTID删除T_INFO_CHART_CHARTPARA中相关CHARTID信息
        /// </summary>
        /// <param name="id"></param>
        public void Delete_Chart(string id)
        {
            string sql = "delete from  administrator.T_INFO_CHART_CHARTPARA where CHARTID ='" + id + "'";
            dl.RunDataSet(sql, out errMsg);
        }

        /// <summary>
        /// 根据模板ID跟测点删除T_INFO_CHART_CHARTPARA信息
        /// </summary>
        /// <param name="chart_id"></param>
        /// <param name="id"></param>
        public void Delete_Paraid(string chart_id,string id)
        {
            string sql = "delete from  administrator.T_INFO_CHART_CHARTPARA where REALTIME not in(" + id + ") and CHARTID='" + id + "'";
            dl.RunDataSet(sql, out errMsg);
        }
        /// <summary>
        /// 根据T_INFO_CHART_USERTEMPLATE最大的CHARTID生成下一个
        /// </summary>
        /// <returns></returns>
        public DataSet Select_ChartId()
        {
            string sql = "select cast(CHARTID as int)+1 from administrator.T_INFO_CHART_USERTEMPLATE  order by  cast(CHARTID as int) desc fetch   first  1   rows   only";
            return dl.RunDataSet(sql, out errMsg);
        }

        /// <summary>
        /// 向T_INFO_CHART_USERTEMPLATE，T_INFO_CHART_CHARTPARA里面插入测点数据 ，添加趋势模板用
        /// </summary>
        /// <param name="chart_id"></param>
        /// <param name="user_id"></param>
        /// <param name="chart_desc"></param>
        public void Insert_ChartId(string chart_id,string user_id,string chart_desc)
        {
            string sql = "insert into administrator.T_INFO_CHART_USERTEMPLATE(CHARTID,USERID,CHARTDESC) values('" + chart_id + "','" + user_id + "','" + chart_desc + "')";
            dl.RunDataSet(sql, out errMsg);
        }
        public void Insert_para_id(string id)
        {
            string sql = "insert into administrator.T_INFO_CHART_CHARTPARA(CHARTID,PARAID, PARADESC, PARATYPE, T_SQL, REALTIME) SELECT  a.CHARTID,PARAID ,PARADESC,PARATYPE ,SQL,REALTIME " +
  "FROM administrator.T_BASE_PARAID_WIND,(select  CHARTID from administrator.T_INFO_CHART_USERTEMPLATE order by cast(CHARTID as int) desc fetch   first  1   rows   only) as a where REALTIME ='" + id + "'";
            string sql1 = "insert into T_INFO_CHART_CHARTPARA(CHARTID,PARAID, PARADESC, PARATYPE, T_SQL, REALTIME) SELECT  a.CHARTID,PARAID ,PARADESC,PARATYPE ,SQL,REALTIME " +
  "FROM administrator.T_BASE_PARAID_SUN,(select  CHARTID  from administrator.T_INFO_CHART_USERTEMPLATE order by cast(CHARTID as int) desc   fetch   first  1   rows   only) as a where REALTIME ='" + id + "'";
            dl.RunDataSet(sql, out errMsg);
            dl.RunDataSet(sql1, out errMsg);
            
        }

        /// <summary>
        /// 向T_INFO_CHART_USERTEMPLATE，T_INFO_CHART_CHARTPARA里面插入测点数据 ，编辑趋势模板用
        /// </summary>
        /// <param name="chart_id"></param>
        /// <param name="id"></param>
        public void Insert_paraid_ByChartid(string chart_id, string id)
        {
            string sql = "insert into administrator.T_INFO_CHART_CHARTPARA(CHARTID,PARAID, PARADESC, PARATYPE, T_SQL, REALTIME) SELECT  a.CHARTID,PARAID ,PARADESC,PARATYPE ,SQL,REALTIME " +
  "FROM administrator.T_BASE_PARAID_WIND,(select  CHARTID from administrator.T_INFO_CHART_USERTEMPLATE  where CHARTID='" + chart_id + "') as a where REALTIME ='" + id + "'";
            string sql1 = "insert into administrator.T_INFO_CHART_CHARTPARA(CHARTID,PARAID, PARADESC, PARATYPE, T_SQL, REALTIME) SELECT   a.CHARTID,PARAID ,PARADESC,PARATYPE ,SQL,REALTIME " +
  "FROM administrator.T_BASE_PARAID_SUN,(select  CHARTID from administrator.T_INFO_CHART_USERTEMPLATE  where CHARTID='" + chart_id + "') as a where REALTIME ='" + id + "'";
            dl.RunDataSet(sql, out errMsg);
            dl.RunDataSet(sql1, out errMsg);

        }

        /// <summary>
        /// CHARTID,REALTIME获取T_INFO_CHART_CHARTPARA数据
        /// </summary>
        /// <param name="chart_id"></param>
        /// <param name="para_id"></param>
        /// <returns></returns>
        public DataSet Select_Para_id(string chart_id,string para_id)
        {
            string sql = "select * from administrator.T_INFO_CHART_CHARTPARA where CHARTID='" + chart_id + "' and REALTIME ='" + para_id + "'";
            return dl.RunDataSet(sql, out errMsg);
        }

        /// <summary>
        /// 根据测点ID 删除T_INFO_CHART_CHARTPARA，T_INFO_CHART_USERTEMPLATE表中所有数据
        /// </summary>
        /// <param name="id">测点ID</param>
        public void Delete_Chart_All(string id)
        {
            string sql = "delete from administrator.T_INFO_CHART_CHARTPARA where CHARTID ='" + id + "'";
            string sql1 = "delete from administrator.T_INFO_CHART_USERTEMPLATE where CHARTID ='" + id + "'";
            dl.RunDataSet(sql, out errMsg);
            dl.RunDataSet(sql1, out errMsg);
        }
    }
}
