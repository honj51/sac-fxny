using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Collections;
using System.Data;
using System.Xml;
using BLL;
using Newtonsoft.Json;
using System.Text;

namespace Web.LineAndChart
{
    public partial class BGFJDB : System.Web.UI.Page
    {
        private PeriodBLL _pd = new PeriodBLL();
        private PointBLL _pb = new PointBLL();
        private BLL_STATISCS _sta = new BLL_STATISCS();

        private WppBLL _wd = new WppBLL();
        private static string _xml = "FD";
        private string result = "";

        protected void Page_Load(object sender, EventArgs e)
        {
            string param = Request["param"];
            if (param != "")
            {
                if (param == "line")
                {
                    string tyep = Request["type"];
                    string gq = Request["gq"];
                    string sTime = Request["sTime"];
                    string eTime = Request["eTime"];
                    string idbg = HttpUtility.UrlDecode(Request["id_bg"]);
                    string idpt = HttpUtility.UrlDecode(Request["id_pt"]);
                    string namebg = HttpUtility.UrlDecode(Request["name_bg"]);
                    string namept = HttpUtility.UrlDecode(Request["name_pt"]);
                    if (tyep == "1" || tyep == "2")
                    {
                        GetList(idbg, idpt, namebg, namept, tyep, sTime, eTime, gq);
                    }
                    else if (tyep == "3" || tyep == "4")
                    {
                        GetList(idbg, idpt, namebg, namept, tyep, sTime, eTime, gq);
                    }
                }
                else if (param == "Init")
                {
                    GetInit();
                }
                else if (param == "unit")
                {
                    string id = Request["id"];
                    GetUnit(id);
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
            else
            {
                _xml = "FD";// Request["XML"];
            }
            txtS.Value = DateTime.Now.AddDays(-1).ToString("yyyy-MM-dd 0:00:00");
            txtE.Value = DateTime.Now.ToString("yyyy-MM-dd 0:00:00");
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
            //string _treePt_Info = "";
            if (listOrg != null)
            {
                if (listOrg[0]["T_PERIODDESC"].ToString().Equals("全部"))
                {
                    a = 1;
                }
                //_ht = listOrg[0];
                
            }
            list = _pd.GetUnitByOrgId(orgID);

            string _treeBg_Info = "";
            string _treePt_Info = "";
            if (list != null)
            {
                _treeBg_Info += "{id:'0',pId:'00',name:'标杆风机',t:'标杆风机', open:true},";
                _treePt_Info += "{id:'0',pId:'00',name:'普通风机',t:'普通风机', open:true},";
                foreach (Hashtable ht in list)
                {
                    if (ht["I_FLAG"].ToString() == "1")
                        _treeBg_Info += "{id:'" + ht["T_UNITID"] + "',pId:'0',name:'" + ht["T_UNITDESC"] + "',t:'" + ht["T_UNITDESC"] + "'},";
                    else if (ht["I_FLAG"].ToString() == "0")
                        _treePt_Info += "{id:'" + ht["T_UNITID"] + "',pId:'0',name:'" + ht["T_UNITDESC"] + "',t:'" + ht["T_UNITDESC"] + "'},";
                }

                if (_treeBg_Info.Length > 0)
                {
                    _treeBg_Info = _treeBg_Info.Substring(0, _treeBg_Info.Length - 1);
                    _treeBg_Info = "[" + _treeBg_Info + "]";
                }

                if (_treePt_Info.Length > 0)
                {
                    _treePt_Info = _treePt_Info.Substring(0, _treePt_Info.Length - 1);
                    _treePt_Info = "[" + _treePt_Info + "]";
                }
            }
            object obj = new
            {
                list1 = listOrg,
                intNumber = a,
                list2 = _treePt_Info,
                infoBg = _treeBg_Info,
                infoPt = _treePt_Info
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

            string _treeBg_Info = "";
            string _treePt_Info = "";
            if (list != null)
            {
                _treeBg_Info += "{id:'0',pId:'00',name:'标杆风机',t:'标杆风机', open:true},";
                _treePt_Info += "{id:'0',pId:'00',name:'普通风机',t:'普通风机', open:true},";
                foreach (Hashtable ht in list)
                {
                    if (ht["I_FLAG"].ToString() == "1")
                        _treeBg_Info += "{id:'" + ht["T_UNITID"] + "',pId:'0',name:'" + ht["T_UNITDESC"] + "',t:'" + ht["T_UNITDESC"] + "'},";
                    else if (ht["I_FLAG"].ToString() == "0")
                        _treePt_Info += "{id:'" + ht["T_UNITID"] + "',pId:'0',name:'" + ht["T_UNITDESC"] + "',t:'" + ht["T_UNITDESC"] + "'},";
                }

                if (_treeBg_Info.Length > 0)
                {
                    _treeBg_Info = _treeBg_Info.Substring(0, _treeBg_Info.Length - 1);
                    _treeBg_Info = "[" + _treeBg_Info + "]";
                }

                if (_treePt_Info.Length > 0)
                {
                    _treePt_Info = _treePt_Info.Substring(0, _treePt_Info.Length - 1);
                    _treePt_Info = "[" + _treePt_Info + "]";
                }
            }
            object obj = new
            {
                infoBg = _treeBg_Info,
                infoPt = _treePt_Info
            };
            result = JsonConvert.SerializeObject(obj);
            Response.Write(result);
            Response.End();
        }
        #endregion

        private void GetList(string idbg, string idpt, string namebg, string namept, string type, string sTime, string eTime, string gq)
        {
            IList<Hashtable> listTitle = new List<Hashtable>();  //Table表格存放列名
            IList<Hashtable> listData = new List<Hashtable>();   //Table 表格具体数据
            IList<Hashtable> listZXT = new List<Hashtable>();
            IList<Hashtable> list = new List<Hashtable>();


            if (idbg.Length > 0 && idpt.Length > 0)
            {
                idbg += idpt.Substring(0, idpt.Length - 1);
                namebg += namept.Substring(0, namept.Length - 1);
            }
            else if (idbg.Length > 0)
            {
                idbg = idbg.Substring(0, idbg.Length - 1);
                namebg = namebg.Substring(0, namebg.Length - 1);
            }
            else if (idpt.Length > 0)
            {
                idbg = idpt.Substring(0, idpt.Length - 1);
                namebg = namept.Substring(0, namept.Length - 1);
            }

            Hashtable timeht = new Hashtable();
            timeht.Add("时间", "时间");
            listTitle.Add(timeht);

            for (int i = 0; i < namebg.Split(',').Length; i++)
            {
                Hashtable ht = new Hashtable();
                ht.Add(namebg.Split(',')[i], namebg.Split(',')[i]);
                listTitle.Add(ht);
            }

            DataTable _dtPoint = _pd.GetPoints(gq, type, idbg);

            if (_dtPoint != null)
            {
                string[] _points = new string[_dtPoint.Rows.Count];

                for (int i = 0; i < _dtPoint.Rows.Count; i++)
                {
                    _points[i] = _dtPoint.Rows[i][0].ToString();
                }

                if (type == "1" || type == "2")
                {
                    list = _pb.GetVal(_points, namebg.Split(','), sTime, eTime, 15 * 60);

                    if (list == null)
                    {

                    }
                    else
                    {
                        //listData = _pb.GetValToTable(_points, namebg.Split(','), sTime, eTime, 15 * 60); 

                        int day = Convert.ToDateTime(eTime).Day - Convert.ToDateTime(sTime).Day;
                        int hour = Convert.ToDateTime(eTime).Hour - Convert.ToDateTime(sTime).Hour;
                        int minute = Convert.ToDateTime(eTime).Minute - Convert.ToDateTime(sTime).Minute;
                        int second = Convert.ToDateTime(eTime).Second - Convert.ToDateTime(sTime).Second;

                        second = day * 24 * 3600 + hour * 3600 + minute * 60 * second;

                        int num = Convert.ToDateTime(eTime).Second - Convert.ToDateTime(sTime).Second;
                        num = second / 15 / 60;
                        if (second % 15 / 60 != 0)
                            num += 1;


                        for (int i = 0; i < num; i++)
                        {
                            sTime = Convert.ToDateTime(sTime).AddSeconds(15 * 60).ToString();
                            eTime = sTime;
                            Hashtable ht = new Hashtable();
                            ht.Add("时间", eTime);
                            //listData.Add(ht);

                            foreach (Hashtable htv in list)
                            {
                                ArrayList listD = (ArrayList)htv["data"];
                                ArrayList listV = (ArrayList)listD[i];
                                string tname = htv["name"].ToString();
                                string vname = "";
                                if (listV.Count > 1)
                                    vname = listV[1].ToString();
                                else
                                    vname = "0";
                                ht.Add(tname, vname);//vname is value ? wo  d  jiu shi  zheme shezhi d 
                            }

                            listData.Add(ht);
                        }
                    }
                    
                } 
                else if(type == "3" || type == "4")
                {
                    //表格数据
                    DataTable dtGrid = _sta.GetDlByTimeAndUnits(sTime, eTime, idbg);
                    List<string> liststr = new List<string>();
                    var q =
                        from t in dtGrid.AsEnumerable()
                        group t by new { t1 = t.Field<DateTime>("T_TIME") } into m
                        select new
                            {
                                T_TIME = m.Key.t1
                            };
                    q.ToList().ForEach(a => liststr.Add(a.T_TIME.ToString()));
                    for (int m = 0; m < liststr.Count; m++)
                    {
                        
                         Hashtable ht = new Hashtable();
                         ht.Add("时间",liststr[m]);
                         for (int o = 0; o < namebg.Split(',').Length; o++)
                         {
                             DataRow[] dr = dtGrid.Select("T_TIME='" + liststr[m] + "' and T_UNITDESC='" + namebg.Split(',')[o] + "'");
                             ht.Add(namebg.Split(',')[o], dr[0]["D_VALUE"].ToString());
                         }

                         listData.Add(ht);
                    }

                    //柱形图数据
                    DataTable dt = _sta.GetDL(sTime, eTime, idbg);
                    for (int i = 0; i < dt.Rows.Count; i++)
                    {
                        Hashtable ht = new Hashtable();
                        ht.Add("name", dt.Rows[i]["T_UNITDESC"]);
                        ht.Add("data", new double[1] { Convert.ToDouble(dt.Rows[i]["RESULT"]) });
                        listZXT.Add(ht);
                    }
                }
            }

            object obj = new
            {
                columns = ListToString(listTitle),
                rows = listData,
                list = list,
                listZXT = listZXT,          //柱形图
            };

            string result = Newtonsoft.Json.JsonConvert.SerializeObject(obj);
            Response.Write(result);
            Response.End();
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
                        //if (skey.ToString() == "时间")
                       // {
                            width = 120;
                        //}
                        //else
                        //{
                          //  width = 103;
                        //}
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

        #region 获取风场  工期  机组信息
        Hashtable _ht = null;
        private void GetInit()
        {
            DataTable _dtXml = GetDataTableXml(_xml);
            DataRow[] _drXml = _dtXml.Select("PID=10001");

            DataTable _dtCompany = _wd.dtGetCompany();

            IList<Hashtable> _company = new List<Hashtable>();  //公司
            IList<Hashtable> _fc = new List<Hashtable>();       //风场
            IList<Hashtable> _fgs = new List<Hashtable>();       //分公司
            IList<Hashtable> _listB = new List<Hashtable>();//标杆风机
            string _str_b = "";
            string _str_f = "";
            IList<Hashtable> _listF = new List<Hashtable>();//非标杆风机
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

                    DataRow[] _drb = _dtUnit.Select("I_FLAG=1");
                    if (_drb.Length > 0)
                    {
                        _str_b += "{id:'0',pId:'00',name:'标杆风机',t:'标杆风机', open:true},";
                        for (int i = 0; i < _drb.Length; i++)
                        {
                            //Hashtable _htb = new Hashtable();
                            //_htb.Add("ID", _drb[i]["T_UNITID"]);
                            //_htb.Add("NAME", _drb[i]["T_UNITDESC"]);
                            //_listB.Add(_htb);
                            if (i == 0)
                                _str_b += "{id:'" + _drb[i]["T_UNITID"] + "',pId:'0',name:'" + _drb[i]["T_UNITDESC"] + "',t:'" + _drb[i]["T_UNITDESC"] + "',doCheck:true},";
                            else
                                _str_b += "{id:'" + _drb[i]["T_UNITID"] + "',pId:'0',name:'" + _drb[i]["T_UNITDESC"] + "',t:'" + _drb[i]["T_UNITDESC"] + "'},";

                        }
                    }

                    DataRow[] _drf = _dtUnit.Select("I_FLAG=0");
                    if (_drf.Length > 0)
                    {
                        _str_f += "{id:'0',pId:'00',name:'普通风机',t:'普通风机', open:true},";
                        for (int i = 0; i < _drf.Length; i++)
                        {
                            //Hashtable htf = new Hashtable();
                            //htf.Add("ID", _drf[i]["T_UNITID"]);
                            //htf.Add("NAME", _drf[i]["T_UNITDESC"]);
                            //_listF.Add(htf);
                            _str_f += "{id:'" + _drf[i]["T_UNITID"] + "',pId:'0',name:'" + _drf[i]["T_UNITDESC"] + "',t:'" + _drf[i]["T_UNITDESC"] + "', open:true},";
                        }
                    }

                }
            }

            if (_str_b != "")
            {
                _str_b = _str_b.Substring(0, _str_b.Length - 1);
                _str_b = "[" + _str_b + "]";
            }
            if (_str_f != "")
            {
                _str_f = _str_f.Substring(0, _str_f.Length - 1);
                _str_f = "[" + _str_f + "]";
            }

            object obj = new
            {
                list = _company,
                listC = _fgs,
                listB = _str_b,
                listF = _str_f,
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