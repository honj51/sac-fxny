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

namespace SACSIS.Trend
{
    public partial class StatisticDiff : System.Web.UI.Page
    {
        protected PeriodBLL _pd = new PeriodBLL();
        protected Hashtable _ht = null;

        protected WppBLL _wd = new WppBLL();
        protected string result = "";

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
                    //else if (param == "unit")
                    //{
                    //    string id = Request["id"];
                    //    GetUnit(id);
                    //}
                    //else if (param == "lineyear")
                    //{
                    //    string time = Request["time"];    //查询时间
                    //    string zType = Request["zType"];  //指标类型
                    //    string tType = Request["tTtype"]; //时间类型
                    //    string id = HttpUtility.UrlDecode(Request["id"]);        //机组编号
                    //    string name = HttpUtility.UrlDecode(Request["name"]);    //机组名称
                    //    string gq = Request["gq"];                               //工期
                    //    ShowLineYear(id, zType, tType, time, gq);
                    //}

                    else if (param == "org")
                    {
                        string id = Request["id"];
                        GetOrgName(id);
                    }
                    //else if (param == "gq")
                    //{
                    //    string id = Request["id"];
                    //    GetGQName(id);
                    //}
                }
            }

            //txtYear.Value = DateTime.Now.ToString("yyyy");
            //txtMonth.Value = DateTime.Now.ToString("yyyy-MM");
            //txtDay.Value = DateTime.Now.ToString("yyyy-MM-dd");
        }

        #region 获取分公司，风场信息
        protected void GetInit()
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
                _fc = _pd.GetPeriod(_companyId);
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

                //if (_fc != null)
                //{
                //    _ht = new Hashtable();
                //    _ht = _fc[0];

                //    string _pname = _ht["T_PERIODDESC"].ToString();
                //    if (_pname.Equals("全部"))
                //    {
                //        a = 1;
                //    }

                //    string _pid = _ht["T_PERIODID"].ToString();
                   
                //}
            }

             
            object obj = new
            {
                Company = _company,
                WindStation = _fgs
            };
            result = JsonConvert.SerializeObject(obj);
            Response.Write(result);
            Response.End();

        }
        #endregion

        #region 根据分公司获取场站信息
        /// <summary>
        /// 根据分公司获取场站信息
        /// </summary>
        /// <param name="companyID">分公司标识</param>
        protected void GetOrgName(string companyID)
        {
            IList<Hashtable> listOrg = new List<Hashtable>();
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
            }
            object obj = new
            {
                WindStation = listOrg,
            };
            result = JsonConvert.SerializeObject(obj);
            Response.Write(result);
            Response.End();
        }

        #endregion
    }
}