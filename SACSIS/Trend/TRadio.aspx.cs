using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Xml;
using Newtonsoft.Json;
using System.Collections;
using BLL;
using System.Text;

namespace Web.LineAndChart
{
    public partial class TRadio : System.Web.UI.Page
    {
        private PeriodBLL _pd = new PeriodBLL();
        private PointBLL _pointbll = new PointBLL();
        private BLL_STATISCS _sta = new BLL_STATISCS();

        private WppBLL _wd = new WppBLL();
        private static string _xml = "FD";
        private string result = "";

        protected void Page_Load(object sender, EventArgs e)
        {
            string param = Request["param"];
            if (param != "")
            {

                lock (this)
                {
                    if (param == "Init")
                    {
                        GetInit();
                    }
                    else if (param == "unit")
                    {
                        string id = Request["id"];
                        GetUnit(id);
                    }
                    else if (param == "lineyear")
                    {
                        string time = Request["time"];    //查询时间
                        string zType = Request["zType"];  //指标类型
                        string tType = Request["tTtype"]; //时间类型
                        string id = HttpUtility.UrlDecode(Request["id"]);        //机组编号
                        string name = HttpUtility.UrlDecode(Request["name"]);    //机组名称
                        string gq = Request["gq"];                               //工期
                        ShowLineYear(id, zType, tType, time, gq);
                    }

                    else if (param == "org")
                    {
                        string id = Request["id"];
                        GetOrgName(id);
                    }
                    else if (param == "gq")
                    {
                        string id = Request["id"];
                        GetGQName(id);
                    }
                }
            }

            txtYear.Value = DateTime.Now.ToString("yyyy");
            txtMonth.Value = DateTime.Now.ToString("yyyy-MM");
            txtDay.Value = DateTime.Now.ToString("yyyy-MM-dd");
        }

        private void ShowLineYear(string id, string zType, string tType, string time, string gq)
        {
            IList<Hashtable> list = new List<Hashtable>();
            IList<Hashtable> listTitle = new List<Hashtable>();
            IList<Hashtable> listDl = new List<Hashtable>();
            IList<Hashtable> listData = new List<Hashtable>();
            Hashtable hTitle = new Hashtable();
            

            Hashtable ht = new Hashtable();
            string _news = "";
            string _old = "";

            if (zType == "1" || zType == "2")
            {
                //功率  风速
                DataTable _dtPoint = _pd.GetPoints(gq, zType, "'" + id + "'");
                if (_dtPoint != null && _dtPoint.Rows.Count > 0)
                {
                    string[] ti = time.Split('-');
                    if (ti.Length == 1)
                    {
                        time = time + "-1-1 0:00:00";
                        //_news = "4.42,3.85,4.82,3.8,8.89,5.46,4.86,4.85,6.36,8.01,9.34,8.89,6.63,10.22,8.27,9.66,12.37,6.69,14.8,13.35,12.27,14.53,11.12,10.94,8.16,8.13,5.02,7.29,7.09,8.08,7.3,8.03,7.58,11.38,10.6,10.62,7.9,5.82,8.55,5.71,10.52,13.71,17.23,15.1,14.47,11.12,13.02,10.39,14.6,12.21,6.08,8.69,10.81,12.67,9.1,10.05,12.34,13.55,10.13,13.58,14.74,9.73,6.69,12.48,14.73,15.24,9.44,10.29,7.41,5.63,8.28,9.71,8.19,6.87,7.28,7.12,4.07,7.57,7.28,6.79,9.22,15.52,10.34,13.59,11.75,13.44,8.08,9.17,13.59,11.35,17.55,13.65,7.39,5.13,4.49,3.14,5.35,6.97,6.98,9.36,9.12,10.01,6.8,12.23,9.49,6.01,5.86,4.46,3.93,5.96,9.44,9.97,13,17.59,17.59,15.93,15.23,6.96,6.72,12.7,10.27,7.03,8.52,10.89,10.87,9.77,7.66,5.7,8.06,6.42,5.22,10.48,5.86,7.18,8.06,11.66,10.76,4.27,6.37,5.62,7.12,6.42,6.96,8.95,7.23,6.69,8.44,6.35,8.63,8.24,6.75,9.87,8.52,6.01,6.9,3.81,2.38,2.38,2.38,2.38,5.15,5.4,5.4,5.4,5.4,17.67,16.5,14.87,11.5,23.78,18.14,7.23,6.25,5.96,8.8,12.18,13.88,10.87,13.83,10.08,12.85,0,8.94,9.5,7.51,9.89,10.16,8.4,6.12,12.17,12.34,6.43,8.06,7.06,4.66,6.57,6.3,3.85,4.28,11.84,6.54,8.55,6.9,4.85,4.04,10.84,9.95,10.89,20.53,8.93,8.86,7.42,3.67,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,9.06";
                        //_old = "0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0";
                    }
                    else if (ti.Length == 2)
                    {
                        time = time + "-1 0:00:00";
                        //_news = "119.3,121.5,114.9,90,152.7,68.4,38,29.2,32.9,9.1,20.1,7.3,-0.300000011920929,63.3,76.1,57.4,89.3,79.4,115.3,294.4,626.2,317.8,436.5,338.7,247.1,163.3,163.6,91.5,209.1,217.5,78.3,110.5,82.7,110.2,288.9,677.4,646.3,869,704.5,669,713,728,760.6,1503.2,1486.4,1502.9,1158.3,1270,1300.7,1106.6,554.8,645.2,284.1,156.3,480.1,115.3,9.8,0,121.9,127.4,220,238.4";
                        //_old = "0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0";
                    }
                    _news = _pointbll.GetVal(_dtPoint.Rows[0][0].ToString(), time, tType);
                    _old = _pointbll.GetVal(_dtPoint.Rows[0][0].ToString(), Convert.ToDateTime(time).AddYears(-1).ToString(), tType);
                    listData = _pointbll.GetValList(_dtPoint.Rows[0][0].ToString(), time, tType);
                }

                //grid columns
                hTitle.Add("时间", "去年");
                hTitle.Add("去年", "去年");
                hTitle.Add("今年", "今年");
                listTitle.Add(hTitle);
            }
            else
            {
                //电量  停机时间
                if (tType == "1")
                {
                    //柱形图
                    DataTable newdt = _sta.GetDL(time.ToString() + "-1-1 0:00:00", time.ToString() + "-12-31 23:59:59", "'" + id + "'");
                    DataTable olddt = _sta.GetDL((int.Parse(time) - 1).ToString() + "-1-1 0:00:00", (int.Parse(time) - 1).ToString() + "-12-31 23:59:59", "'" + id + "'");

                    Hashtable h = new Hashtable();
                    Hashtable hta = new Hashtable();

                    

                    if (newdt.Rows.Count < 1)
                    {
                        h.Add("name", "今年");
                        h.Add("data", new double[1] { 0 });

                        //rows
                        hta.Add("今年", "0");
                    }
                    else
                    {
                        h.Add("name", "今年");
                        h.Add("data", new double[1] { Convert.ToDouble(newdt.Rows[0]["RESULT"]) });

                        //rows
                        hta.Add("今年", newdt.Rows[0]["RESULT"].ToString());
                    }
                    listDl.Add(h);

                    h = new Hashtable();
                    if (olddt.Rows.Count < 1)
                    {
                        h.Add("name", "去年");
                        h.Add("data", new double[1] { 0 });
                        //rows
                        hta.Add("去年", "0");
                    }
                    else
                    {
                        h.Add("name", "去年");
                        h.Add("data", new double[1] { Convert.ToDouble(olddt.Rows[0]["RESULT"]) });
                        //rows
                        hta.Add("去年", olddt.Rows[0]["RESULT"].ToString());
                    }
                    listDl.Add(h);
                    listData.Add(hta);
                    //grid columns
                    hTitle.Add("去年", "去年");
                    hTitle.Add("今年", "今年");
                    listTitle.Add(hTitle);
                }
                else if (tType == "2")
                {
                    //曲线
                    DataTable newdt = _sta.GetDlByTimeAndUnits(time + "-1 0:00:00", time + "-" + getDayCountByDate(time) + " 23:59:59", "'" + id + "'");
                    DataTable olddt = _sta.GetDlByTimeAndUnits((int.Parse(time.Split('-')[0]) - 1).ToString() + "-" + time.Split('-')[1] + "-1 0:00:00", (int.Parse(time.Split('-')[0]) - 1).ToString() + "-" + time.Split('-')[1] + "-" + getDayCountByDate(time) + " 23:59:59", "'" + id + "'");
                    Hashtable hta = new Hashtable();//存储GRID数据
                    
                    if (newdt.Rows.Count >0)
                    {
                        for (int i = 0; i < newdt.Rows.Count; i++)
                        {
                            _news += newdt.Rows[i][0].ToString() + ",";
                            hta.Add("时间", newdt.Rows[i]["T_TIME"].ToString());
                            hta.Add("今年", newdt.Rows[i]["D_VALUE"].ToString());
                            if (olddt.Rows.Count > 0)
                            {
                                DataRow[] ddr = olddt.Select("T_TIME='" + newdt.Rows[i]["T_TIME"].ToString() + "'");
                                if (ddr.Length > 0)
                                    hta.Add("去年", ddr[0]["D_VALUE"].ToString());
                                else
                                    hta.Add("去年", "0");
                            }
                            else
                            {
                                hta.Add("去年", "0");
                            }
                            listData.Add(hta);
                            hta = new Hashtable();
                        }
                        _news = _news.Substring(0, _news.Length - 1);
                    }
                    else
                    {
                        _news = "";

                        if (olddt.Rows.Count > 0)
                        {
                            for (int m = 0; m < olddt.Rows.Count; m++)
                            {
                                hta.Add("时间", olddt.Rows[m]["T_TIME"].ToString());
                                hta.Add("今年","0");
                                hta.Add("时间", olddt.Rows[m]["D_VALUE"].ToString());
                                listData.Add(hta);
                                hta = new Hashtable();
                            }
                        }
                    }


                    if (olddt.Rows.Count >0)
                    {
                        for (int j = 0; j < olddt.Rows.Count; j++)
                        {
                            _old += olddt.Rows[j][0].ToString() + ",";
                        }
                        _old = _old.Substring(0, _old.Length - 1);
                    }
                    else
                    {
                        _old = "";
                    }

                    //grid columns
                    hTitle.Add("时间", "时间");
                    hTitle.Add("去年", "去年");
                    hTitle.Add("今年", "今年");
                    listTitle.Add(hTitle);
                }
            }

            _news = "[" + _news + "]";
            _old = "[" + _old + "]";

            ht.Add("name", "今年");
            ht.Add("data", _news);
            list.Add(ht);

            ht = new Hashtable();
            ht.Add("name", "去年");
            ht.Add("data", _old);
            list.Add(ht);

            

            object obj = new
            {
                columns = ListToString(listTitle),
                rows = listData,
                list = list,
                listDl = listDl
            };

            string result = Newtonsoft.Json.JsonConvert.SerializeObject(obj);
            Response.Write(result);
            Response.End();
        }

        private string getDayCountByDate(string time)
        {
            //int year = int.Parse(time.Split('-')[0]);
            //string month = time.Split('-')[1];
            //if (month == "1" || month == "3" || month == "5" || month == "7" || month == "8" || month == "10" || month == "12")
            //{
            //    return "31";
            //}
            //else if (month == "4" || month == "6" || month == "9" || month == "11")
            //{
            //    return "30";
            //}
            //else if(month=="2")
            //{
            //    if (((0 == year % 4) && (0 != year % 100)) || (0 == year % 400))
            //    {
            //        return "29";
            //    }
            //    else
            //    {
            //    return "28";
            //    }
                
            //}

            return DateTime.DaysInMonth(Convert.ToDateTime(time).Year, Convert.ToDateTime(time).Month).ToString();
        }


        private string ListToString(IList<Hashtable> iList)
        {
            int width = 0;
            StringBuilder columns = new StringBuilder("[[");

            if (iList.Count > 0)
            {
                //Hashtable ht = iList[0];

                foreach (Hashtable ht in iList)
                {

                    ArrayList list = new ArrayList(ht.Keys);
                    foreach (string skey in list)
                    {
                        if (skey.ToString() == "时间")
                        {
                            width = 120;
                        }
                        else
                        {
                            width = 103;
                        }
                        columns.AppendFormat("{{field:'{0}',title:'{1}',align:'center',width:{2}}},", skey, skey, width);
                    }
                }
            }
            if (iList.Count > 0)
            {
                columns.Remove(columns.Length - 1, 1);//去除多余的','号  
            }
            columns.Append("]]");
            return columns.ToString();
        }

        private void GetOrgName(string companyID)
        {
            IList<Hashtable> listOrg = new List<Hashtable>();
            IList<Hashtable> listGQ = new List<Hashtable>();
            string _treePt_Info = "";
            int a = 0;
            DataTable _dtOrg = _wd.GetOrg(companyID);
            if (_dtOrg.Rows.Count > 0)
            {
                for (int j = 0; j < _dtOrg.Rows.Count; j++)
                {
                    _ht = new Hashtable();
                    _ht.Add("ID", _dtOrg.Rows[j]["T_ORGID"].ToString());     //风场编码
                    _ht.Add("NAME", _dtOrg.Rows[j]["T_ORGDESC"].ToString());   //风场名称
                    listOrg.Add(_ht);
                }
                listGQ = _wd.GetPeriod(_dtOrg.Rows[0]["T_ORGID"].ToString());
                IList<Hashtable> list = new List<Hashtable>();
                //_ht = new Hashtable();

                if (listGQ != null)
                {
                    if (listGQ[0]["T_PERIODDESC"].ToString().Equals("全部"))
                    {
                        a = 1;
                    }
                    //_ht = listGQ[0];
                    string _pid = listGQ[0]["T_PERIODID"].ToString();
                    list = _wd.GetUnits(_pid);

                    if (list != null)
                    {
                        _treePt_Info += "{id:'0',pId:'00',name:'风机',t:'风机', open:true},";
                        foreach (Hashtable ht in list)
                        {
                            _treePt_Info += "{id:'" + ht["T_UNITID"] + "',pId:'0',name:'" + ht["T_UNITDESC"] + "',t:'" + ht["T_UNITDESC"] + "'},";
                        }
                        if (_treePt_Info.Length > 0)
                        {
                            _treePt_Info = _treePt_Info.Substring(0, _treePt_Info.Length - 1);
                            _treePt_Info = "[" + _treePt_Info + "]";
                        }
                    }
                }
            }
            object obj = new
            {
                list1 = listOrg,
                list2 = listGQ,
                list3 = _treePt_Info,
                intNumber = a
            };
            result = JsonConvert.SerializeObject(obj);
            Response.Write(result);
            Response.End();
        }

        private void GetGQName(string orgID)
        {
            IList<Hashtable> listOrg = new List<Hashtable>();
            listOrg = _wd.GetPeriod(orgID);

            IList<Hashtable> list = new List<Hashtable>();
            int a = 0;
            string _treePt_Info = "";
            if (listOrg != null)
            {
                if (listOrg[0]["T_PERIODDESC"].ToString().Equals("全部"))
                {
                    a = 1;
                }
                //_ht = listOrg[0];
                string _pid = listOrg[0]["T_PERIODID"].ToString();
                list = _wd.GetUnits(_pid);

                if (list != null)
                {
                    _treePt_Info += "{id:'0',pId:'00',name:'风机',t:'风机', open:true},";
                    foreach (Hashtable ht in list)
                    {
                        _treePt_Info += "{id:'" + ht["T_UNITID"] + "',pId:'0',name:'" + ht["T_UNITDESC"] + "',t:'" + ht["T_UNITDESC"] + "'},";
                    }
                    if (_treePt_Info.Length > 0)
                    {
                        _treePt_Info = _treePt_Info.Substring(0, _treePt_Info.Length - 1);
                        _treePt_Info = "[" + _treePt_Info + "]";
                    }
                }
            }
            object obj = new
            {
                list1 = listOrg,
                intNumber = a,
                list2 = _treePt_Info
            };
            result = JsonConvert.SerializeObject(obj);
            Response.Write(result);
            Response.End();
        }

        #region 获取机组数据
        private void GetUnit(string gq)
        {
            IList<Hashtable> list = new List<Hashtable>();
            list = _pd.GetUnits(gq);

            string _tree_Info = "";
            if (list != null)
            {
                _tree_Info += "{id:'0',pId:'00',name:'风机对比',t:'风机对比', open:true},";
                foreach (Hashtable ht in list)
                {
                    _tree_Info += "{id:'" + ht["T_UNITID"] + "',pId:'0',name:'" + ht["T_UNITDESC"] + "',t:'" + ht["T_UNITDESC"] + "'},";
                }

                if (_tree_Info.Length > 0)
                {
                    _tree_Info = _tree_Info.Substring(0, _tree_Info.Length - 1);
                    _tree_Info = "[" + _tree_Info + "]";
                }
            }
            object obj = new
            {
                info = _tree_Info
            };
            result = JsonConvert.SerializeObject(obj);
            Response.Write(result);
            Response.End();
        }
        #endregion

        #region 获取风场  工期  机组信息
        Hashtable _ht = null;
        private void GetInit()
        {
            DataTable _dtXml = GetDataTableXml(_xml);
            DataRow[] _drXml = _dtXml.Select("PID=10001");

            DataTable _dtCompany = _wd.dtGetCompany();

            IList<Hashtable> _company = new List<Hashtable>();  //公司
            IList<Hashtable> _fgs = new List<Hashtable>();       //分公司
            IList<Hashtable> _fc = new List<Hashtable>();       //风场
            string _str_b = "";                                 //风机
            int a = 0;

            if (_dtCompany.Rows.Count > 0)
            {
                for (int i = 0; i < _dtCompany.Rows.Count; i++)
                {
                    _ht = new Hashtable();
                    _ht.Add("ID", _dtCompany.Rows[i]["T_COMID"].ToString());     //公司编码
                    _ht.Add("NAME", _dtCompany.Rows[i]["T_COMDESC"].ToString());   //公司名称
                    _company.Add(_ht);
                }

                string _companyId = _dtCompany.Rows[0]["T_COMID"].ToString();
                //_fc = _pd.GetPeriod(_companyId);
                DataTable _dtOrg = _wd.GetOrg(_companyId);
                if (_dtOrg.Rows.Count > 0)
                {
                    for (int j = 0; j < _dtOrg.Rows.Count; j++)
                    {
                        _ht = new Hashtable();
                        _ht.Add("ID", _dtOrg.Rows[j]["T_ORGID"].ToString());     //风场编码
                        _ht.Add("NAME", _dtOrg.Rows[j]["T_ORGDESC"].ToString());   //风场名称
                        _fgs.Add(_ht);
                    }
                    string _orgid = _dtOrg.Rows[0]["T_ORGID"].ToString();
                    _fc = _wd.GetPeriod(_orgid);
                } 

                if (_fc != null)
                {
                    _ht = new Hashtable();
                    _ht = _fc[0];

                    string _pname = _ht["T_PERIODDESC"].ToString();
                    if (_pname.Equals("全部"))
                    {
                        a = 1;
                    }

                    string _pid = _ht["T_PERIODID"].ToString();
                    DataTable _dtUnit = _pd.GetUnit(_pid);
                    _str_b += "{id:'0',pId:'00',name:'同比风机',t:'同比风机', open:true},";
                    for (int k = 0; k < _dtUnit.Rows.Count; k++)
                    {
                        if (k == 0)
                            _str_b += "{id:'" + _dtUnit.Rows[k]["T_UNITID"] + "',pId:'0',name:'" + _dtUnit.Rows[k]["T_UNITDESC"] + "',t:'" + _dtUnit.Rows[k]["T_UNITDESC"] + "'},";
                        else
                            _str_b += "{id:'" + _dtUnit.Rows[k]["T_UNITID"] + "',pId:'0',name:'" + _dtUnit.Rows[k]["T_UNITDESC"] + "',t:'" + _dtUnit.Rows[k]["T_UNITDESC"] + "'},";
                    }
                }
            }

            if (_str_b != "")
            {
                _str_b = _str_b.Substring(0, _str_b.Length - 1);
                _str_b = "[" + _str_b + "]";
            }

            object obj = new
            {
                list = _company,
                listC = _fgs,
                listB = _str_b,
                lt = _fc,
                intNumber = a
            };
            result = JsonConvert.SerializeObject(obj);
            Response.Write(result);
            Response.End();

        }
        #endregion

        #region XML 操作

        private static DataTable dt = new DataTable();

        #region 将XML转换成DataTable

        private DataTable GetDataTableXml(string xmlName)
        {
            dt = new DataTable();
            if (xmlName != "")
            {
                //XmlTextReader reader = new XmlTextReader(Server.MapPath("Xml/" + xmlName + ".xml"));
                XmlTextReader reader = new XmlTextReader(Server.MapPath("../Xml/" + xmlName + ".xml"));
                reader.WhitespaceHandling = WhitespaceHandling.None;
                XmlDocument xmlDoc = new XmlDocument();
                //将文件加载到XmlDocument对象中
                xmlDoc.Load(reader);

                //关闭连接
                reader.Close();

                XmlNode xnod = xmlDoc.DocumentElement;

                if (!dt.Columns.Contains("ID"))
                    dt.Columns.Add("ID");
                if (!dt.Columns.Contains("NAME"))
                    dt.Columns.Add("NAME");
                if (!dt.Columns.Contains("PID"))
                    dt.Columns.Add("PID");
                XmlToDataTable(xnod);
            }
            return dt;
        }

        /// <summary>
        /// 将XML转换成DataTable
        /// </summary>
        /// <param name="xnod"></param>
        /// <param name="intLevel"></param>
        private void XmlToDataTable(XmlNode xnod)
        {
            DataRow dr = dt.NewRow();
            XmlNode xnodWorking;

            //如果是元素节点，获取它的属性
            if (xnod.NodeType == XmlNodeType.Element)
            {
                XmlNamedNodeMap mapAttributes = xnod.Attributes;
                if (mapAttributes.Count > 0)
                {
                    dr[0] = mapAttributes.Item(0).Value;
                    dr[1] = mapAttributes.Item(1).Value;
                    dr[2] = mapAttributes.Item(2).Value;
                    dt.Rows.Add(dr);
                }

                //如果还有子节点，就递归地调用这个程序
                if (xnod.HasChildNodes)
                {
                    xnodWorking = xnod.FirstChild;
                    while (xnodWorking != null)
                    {
                        XmlToDataTable(xnodWorking);
                        xnodWorking = xnodWorking.NextSibling;
                    }
                }
            }
        }

        #endregion

        #endregion
    }
}