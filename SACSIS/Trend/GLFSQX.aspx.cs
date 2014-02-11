using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml;
using System.Data;
using System.Collections;
using BLL;
using Newtonsoft.Json;
using System.Text;
using System.Reflection;

namespace SACSIS.Trend
{
    public partial class GLFSQX : System.Web.UI.Page
    {
        private static string _xml = "FD";
        //private PeriodBLL _pd = new PeriodBLL();
        private WppBLL _wd = new WppBLL();
        //private PointBLL _pb = new PointBLL();
        private string result = "";
        protected void Page_Load(object sender, EventArgs e)
        {
            string param = Request["param"];
            if (param != "")
            {
                if (param == "line")
                {
                    //string tyep = Request["type"];
                    string gq = Request["gq"];
                    string sTime = Request["sTime"];
                    string eTime = Request["eTime"];
                    string idpt = HttpUtility.UrlDecode(Request["id_pt"]);
                    string namept = HttpUtility.UrlDecode(Request["name_pt"]);
                    //GetList(idpt,namept, sTime, eTime, gq);
                    GetWPPInfo(idpt, gq, namept, sTime, eTime);
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
            /*else
            {
                _xml = "FD";// Request["XML"];
            }*/
            txtS.Value = DateTime.Now.AddDays(-1).ToString("yyyy-MM-dd 0:00:00");
            txtE.Value = DateTime.Now.ToString("yyyy-MM-dd 0:00:00");
        }

        #region 获取根据公司风场信息
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
                list3=_treePt_Info,
                intNumber = a
            };
            result = JsonConvert.SerializeObject(obj);
            Response.Write(result);
            Response.End();
        }
        #endregion


        #region 根据风场获取工期信息
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
                intNumber=a,
                list2 = _treePt_Info
            };
            result = JsonConvert.SerializeObject(obj);
            Response.Write(result);
            Response.End();
        }
        #endregion

        #region 根据工期获取机组数据
        private void GetUnit(string gq)
        {
            IList<Hashtable> list = new List<Hashtable>();
            list = _wd.GetUnits(gq);
            string _treePt_Info = "";
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
            object obj = new
            {
                infoPt = _treePt_Info
            };
            result = JsonConvert.SerializeObject(obj);
            Response.Write(result);
            Response.End();
        }
        #endregion

        //绘制曲线
        private void GetWPPInfo(string strID, string gq, string namept, string bt, string et)
        {
            string[] unitID = null;
            string[] namepts = null;
            string title = "功率风速曲线";
            IList<Hashtable> listTitle = new List<Hashtable>();
            Hashtable nameht = new Hashtable();
            //this.init();
            int intAAAA=0;
            Hashtable htLine = null;

            ArrayList list = new ArrayList();
            ArrayList listData = null;
            List<Hashtable> iList = new List<Hashtable>();

            IList<Hashtable> listData1 = new List<Hashtable>();

            Hashtable htLineBJ = new Hashtable();
            ArrayList listBJ = new ArrayList(); //标准功率曲线
            if (strID.Length > 0)
            {
                strID = strID.Substring(0, strID.Length - 1);
            }
            if (strID.TrimEnd(',').Contains(','))
            {
                unitID = strID.TrimEnd(',').Split(',');
            }
            else
            {
                unitID = new string[1];
                unitID[0] = strID.TrimEnd(',');
            }
            if (namept.TrimEnd(',').Contains(','))
            {
                namepts = namept.TrimEnd(',').Split(',');
            }
            else
            {
                namepts = new string[1];
                namepts[0] = namept.TrimEnd(',');
            }
            
            DataTable _dtMachineID = _wd.GetMachineID(strID, gq);
            DataTable dtNorm = new DataTable();
            List<string> _machineIDs = new List<string>();
            //保存表格数据
            List<Hashtable> iTableList = new List<Hashtable>();
            ArrayList tableList = new ArrayList();
            Hashtable htTableLineBJ = new Hashtable();

            if (_dtMachineID != null)
            {
                if (_dtMachineID.Rows.Count == 1)
                {
                    intAAAA = 1;
                    _machineIDs.Add(_dtMachineID.Rows[0][0].ToString());
                    dtNorm = _wd.GetWppNWSpeed(_machineIDs[0]);//T_BASE_NORMWPP 表中的数据
                }
                else 
                {
                    for (int i = 0; i < _dtMachineID.Rows.Count; i++)
                    {
                        _machineIDs.Add(_dtMachineID.Rows[0][i].ToString());
                        dtNorm = _wd.GetWppNWSpeed(_machineIDs[i]);//T_BASE_NORMWPP 表中的数据
                    }
                }
            }
            for (int i = 0; i < unitID.Length+1; i++)
            {
                htLine = new Hashtable();
                listData = new ArrayList(); //非标准功率曲线

                Hashtable htTableLine = new Hashtable();
                ArrayList listTableData = new ArrayList(); //非标准功率曲线

                if (i!= 0)
                {                 
                    htLine.Add("name", namepts[i-1]);
                    htTableLine.Add("name", namepts[i - 1]);

                    if (dtNorm != null && dtNorm.Rows.Count > 0)
                    {
                        for (int j = 0; j < dtNorm.Rows.Count; j++)
                        {
                            tableList = new ArrayList();
                            DataTable _dtTablePower = _wd.GetAvgPower(gq, unitID[i - 1], dtNorm.Rows[j]["T_NWSpeed"].ToString(), bt, et);
                            tableList.Add(float.Parse(dtNorm.Rows[j]["T_NWSpeed"].ToString()));

                            if (_dtTablePower != null && _dtTablePower.Rows[0][0] != DBNull.Value)
                                tableList.Add(Math.Round(float.Parse(_dtTablePower.Rows[0][0].ToString()),3));
                            else
                                tableList.Add(0);
                            listTableData.Add(tableList);
                                  


                            DataTable _dtAvgPower = _wd.GetPower(gq, unitID[i - 1], dtNorm.Rows[j]["T_NWSpeed"].ToString(), bt, et);
                            float Speed = float.Parse(dtNorm.Rows[j]["T_NWSpeed"].ToString());
                            if (_dtAvgPower != null && _dtAvgPower.Rows.Count > 0)
                            {
                                foreach (DataRow dr in _dtAvgPower.Rows)
                                {
                                    list = new ArrayList();
                                    list.Add(Speed);
                                    list.Add(float.Parse(dr[0].ToString()));
                                    listData.Add(list);
                                }
                            }
                            else
                            {
                                list = new ArrayList();
                                list.Add(Speed);
                                list.Add(0);
                                listData.Add(list);
                            }

                           
                        }
                        htLine.Add("data", listData);
                        iList.Add(htLine);

                        htTableLine.Add("data", listTableData);
                        iTableList.Add(htTableLine);  
                    }
                }
                else
                {
                    for (int m=0; m < _dtMachineID.Rows.Count;m++ )
                    {
                        if (dtNorm != null && dtNorm.Rows.Count > 0)
                        {
                            
                            htLineBJ.Add("name", _machineIDs[m]+"标准曲线");
                            htTableLineBJ.Add("name", _machineIDs[m] + "标准曲线");
                            for (int j = 0; j < dtNorm.Rows.Count; j++)
                            {
                                list = new ArrayList();
                                list.Add(float.Parse(dtNorm.Rows[j]["T_NWSPEED"].ToString()));
                                list.Add(Math.Round(float.Parse(dtNorm.Rows[j]["T_NPOWER"].ToString()),3));

                                listBJ.Add(list);
                            }
                            htLineBJ.Add("data", listBJ);
                            htTableLineBJ.Add("data", listBJ);

                            iList.Add(htLineBJ);
                            iTableList.Add(htTableLineBJ);
                        }
                    }
                }
            }
            
            for (int i = 0; i < unitID.Length + 1; i++)
            {
                nameht.Add(iList[i]["name"].ToString(), iList[i]["name"].ToString());
                
            }
            listTitle.Add(nameht);
            ArrayList aaa = (ArrayList)iTableList[0]["data"];
            int a = aaa.Count;
            for (int j = 0; j < a; j++)
            {
                Hashtable ht = new Hashtable();
                foreach (Hashtable htv in iTableList)
                {
                    ArrayList listD = (ArrayList)htv["data"];
                    //a=listD.Count;
                    ArrayList listV = (ArrayList)listD[j];
                    string tname = htv["name"].ToString();
                    string vname = "";
                    string speed = "";
                    if (listV.Count > 1)
                    {
                        vname = listV[1].ToString();
                        speed = listV[0].ToString();
                    }
                    else
                    {
                        vname = "0";
                    }
                    ht.Add(tname, vname);
                }
                listData1.Add(ht);
            }
            object obj = new
            {
                columns = ListToString(listTitle),
                title = title,
                rows = listData1,
                intNumber=intAAAA,
                list = iList,
                tableList = iTableList
            };
            string result = Newtonsoft.Json.JsonConvert.SerializeObject(obj);
            Response.Write(result);
            Response.End();

        }

        public static DataTable Convert2DataTable(List<Hashtable> list)
        {
            DataTable dt = new DataTable();
            if (list.Count == 0)
                return dt;

            foreach (string name in list[0].Keys)
                dt.Columns.Add(name);

            foreach (Hashtable item in list)
                dt.Rows.Add(new ArrayList(item.Values).ToArray());

            return dt;
        }
           
        public List<Hashtable> GetListTable(DataTable dt) 
        { 
            List<Hashtable> mList = new List<Hashtable>(); 
            int count = dt.Rows.Count; 
            if (count > 0) 
            { 
                for (int i = 0; i <= count - 1; i++) 
                { 
                    Hashtable ht = new Hashtable(); 
                    foreach (DataColumn col in dt.Columns) 
                    { 
                        ht.Add(col.ColumnName, dt.Rows[i][col.ColumnName]); 
                    } 
                    mList.Add(ht); 
                } 
            } 
            return mList; 
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

        #region 获取风场  工期  机组信息
        Hashtable _ht = null;
        private void GetInit()
        {
            DataTable _dtCompany = _wd.dtGetCompany();
            IList<Hashtable> _company = new List<Hashtable>();  //公司
            IList<Hashtable> _fgs = new List<Hashtable>();       //分公司
            IList<Hashtable> _fc = new List<Hashtable>();       //风场
            string _str_b = "";
            string _str_f = "";
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
                    DataTable _dtUnit = _wd.GetUnit(_pid);
                    if (_dtUnit.Rows.Count > 0)
                    {
                        _str_f += "{id:'0',pId:'00',name:'普通风机',t:'普通风机', open:true},";
                        for (int i = 0; i < _dtUnit.Rows.Count; i++)
                        {
                            _str_f += "{id:'" + _dtUnit.Rows[i]["T_UNITID"] + "',pId:'0',name:'" + _dtUnit.Rows[i]["T_UNITDESC"] + "',t:'" + _dtUnit.Rows[i]["T_UNITDESC"] + "', open:true},";
                        }
                    }
                }
            }
            if (_str_f != "")
            {
                _str_f = _str_f.Substring(0, _str_f.Length - 1);
                _str_f = "[" + _str_f + "]";
            }

            object obj = new
            {
                list = _company,
                listB = _str_b,
                listC = _fgs,
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