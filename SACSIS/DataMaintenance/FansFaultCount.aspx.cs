using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using BLL;
using System.Collections;
using Newtonsoft.Json;
using System.Data;
using System.Text;

namespace SACSIS.DataMaintenance
{
    public partial class FansFaultCount : System.Web.UI.Page
    {
        private string result = "";
        string errMsg = "";
        private WppBLL _wd = new WppBLL();
        private FaultBLL fault = new FaultBLL();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                txtDay.Value = DateTime.Now.ToString("yyyy-MM-dd");
            }

            string param = Request["param"];
            if (param != "")
            {
                if (param == "unit")
                {
                    GetInit();
                }
                else if (param == "show")
                {
                    string id = Request["id"];
                    string time = Request["time"];
                    GetFaultTable(id, time);
                }
                else if (param == "org")
                {
                    string companyID=Request["id"];
                    GetOrgName(companyID);
                }
                else if (param == "gq")
                {
                    string orgID = Request["id"];
                    GetGQName(orgID);
                }
                else if (param == "SaveData")
                {
                    string date = Request["date"];
                    string keyNew = Request["keyValue"];
                    string keyOld = Request["key"];

                    SaveData(date, keyNew, keyOld);
                }
            }
        }

        #region 获取风场  工期  机组信息
        Hashtable _ht = null;
        private void GetInit()
        {
            DataTable _dtCompany = _wd.dtGetCompany();
            IList<Hashtable> _company = new List<Hashtable>();  //公司
            IList<Hashtable> _fgs = new List<Hashtable>();       //分公司
            IList<Hashtable> _fc = new List<Hashtable>();       //风场
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
                    if (_dtOrg.Rows[0]["T_ORGDESC"].ToString().Equals("全部 "))
                    {
                        a = 1;
                    }
                    for (int j = 0; j < _dtOrg.Rows.Count; j++)
                    {
                        _ht = new Hashtable();
                        _ht.Add("ID", _dtOrg.Rows[j]["T_ORGID"].ToString());     //风场编码
                        _ht.Add("NAME", _dtOrg.Rows[j]["T_ORGDESC"].ToString());   //风场名称
                        _fgs.Add(_ht);
                    }
                }
                string _orgid = _dtOrg.Rows[0]["T_ORGID"].ToString();
                _fc = _wd.GetPeriod(_orgid);
                object obj = new
                {
                    list = _company,
                    listC = _fgs,
                    lt = _fc,
                    intNumber=a
                };
                result = JsonConvert.SerializeObject(obj);
                Response.Write(result);
                Response.End();

            }
        }
        #endregion


        #region 根据公司名跳转下级选择框
        private void GetOrgName(string companyID)
        {
            IList<Hashtable> listOrg = new List<Hashtable>();
            IList<Hashtable> listGQ = new List<Hashtable>();
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
                if (listGQ != null)
                {
                    if (listGQ[0]["T_PERIODDESC"].ToString().Equals("全部"))
                    {
                        a = 1;
                    }           
                }
            }
            object obj = new
            {
                list1 = listOrg,
                list2 = listGQ,
                intNumber = a
            };
            result = JsonConvert.SerializeObject(obj);
            Response.Write(result);
            Response.End();
        }
        #endregion

        #region 根据风场获得工期
        private void GetGQName(string orgID)
        {
            IList<Hashtable> listOrg = new List<Hashtable>();
            listOrg = _wd.GetPeriod(orgID);

            IList<Hashtable> list = new List<Hashtable>();
            int a = 0;
            if (listOrg != null)
            {
                if (listOrg[0]["T_PERIODDESC"].ToString().Equals("全部"))
                {
                    a = 1;
                }        
            }
            object obj = new
            {
                list1 = listOrg,
                intNumber = a,
            };
            result = JsonConvert.SerializeObject(obj);
            Response.Write(result);
            Response.End();
        }
        #endregion

        /* private void GetInit()
        {
            IList<Hashtable> list = new List<Hashtable>();
            list = _pd.GetPeriod(OrgID);

            object obj = new
            {
                list = list
            };
            result = JsonConvert.SerializeObject(obj);
            Response.Write(result);
            Response.End();
        }*/
        #region 读数据
        private void GetFaultTable(string id, string time)
        {
            string id1 = "";
            int count = 0;
            string table = fault.GetFaultDataByPerId(id, time, out id1);
            if (table != "")
            {
                count = 1;
            }
            object obj = new
            {
                id=id1,
                count=count,
                list = table
            };

            result = JsonConvert.SerializeObject(obj);
            Response.Write(result);
            Response.End();
        }
        #endregion

        #region 保存数据
        private void SaveData(string date, string keyNew, string keyOld)
        {
            int count = 0;
            string res = ""; //id = "";

            bool flag = fault.SaveData(date, keyNew, keyOld, out errMsg);

            if (flag != true)
                res = errMsg;
            else
                count = 1;

            object obj = new
            {
                res = res,
                count = count
            };

            string result = Newtonsoft.Json.JsonConvert.SerializeObject(obj);
            Response.Write(result);
            Response.End();
        }
        #endregion
    }
}