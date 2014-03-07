using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using BLL;
using System.Data;
using System.Text;
using System.Collections;

namespace SACSIS.Trend
{
    public partial class StationMonitor : System.Web.UI.Page
    {
        //业务逻辑
        FormBLL fb = new FormBLL();
        //获取实时测点
        PointBLL pb = new PointBLL();
        protected void Page_Load(object sender, EventArgs e)
        {

            string para=Request["para"];
            if (para == "search")
            {
                GetData();
            }
            if (!IsPostBack)
            {
                //GetData();

            }
        }

        public void GetData()
        {
            StringBuilder sb = new StringBuilder();
            IList<Hashtable> h;
            ArrayList companyName = new ArrayList();
            ArrayList s = new ArrayList();
            DataTable dt = new DataTable();
              //标杆风机
             DataTable dt1=new DataTable();
            dt = fb.GetStationMonitor();
            
            if (dt.Rows.Count > 0)
            {
                ArrayList l = new ArrayList();

                foreach (DataRow r in dt.Rows)
                {

                    //几行数据出现几个图
                    IList<Hashtable> list = new List<Hashtable>();
                    Hashtable ht = new Hashtable();
                    string desc = r["T_PERIODDESC"].ToString();

                    if (desc.Trim() == "全部")
                    {
                        desc = r["T_ORGDESC"].ToString();
                    }

                    string windTag = r["T_WINDTAG"].ToString();
                    windTag += "|风速";
                    string powerTag = r["T_POWERTAG"].ToString();
                    powerTag += "|负荷";

                    //该工期的风机数量
                    DataTable dt2 = fb.GetBGCountStationMonitor(r["T_PERIODID"].ToString());
                    int countFJ = 0;
                    if (dt2 != null)
                    {
                        countFJ = int.Parse(dt2.Rows[0][0].ToString());
                    }

                    string time=DateTime.Now.ToString();
                    //list = pb.GetHistValAndTIme3(Param,DateTime.Today.Date, DateTime.Now,50);

                    //标杆风机
                    dt1 = fb.GetBGStationMonitor(r["T_PERIODID"].ToString());
                    //该工期的标杆风机数量
                    int count = dt1.Rows.Count;
                    //保存风速，负荷，标杆风机测点的信息
                    string[] Param = new string[2 + count];
                    Param[0] = powerTag;
                    Param[1] = windTag;
                    for (int d = 0; d < count; d++)
                    {
                        Param[d + 2] = dt1.Rows[d]["T_POWERTAG"] + "|标杆风机参考值";
                    }
                    list = pb.GetHistValAndTIme3(Param, DateTime.Today.Date,DateTime.Now, 50);

                    Hashtable ht1 = new Hashtable();
                    int listCount = list.Count;
                    ArrayList lt = new ArrayList();
                    for (int f = 0; f < 51; f++)
                    {
                        //标杆风机的数量
                        int counts = count;
                        ArrayList ld = new ArrayList();
                        double value = 0;
                        //从2开始计算的是标杆风机的数据 取平均值
                        for (int c = 2; c < listCount; c++)
                        {
                            ArrayList valueArray = (ArrayList)list[c]["data"];
                            double a = 0;
                            //value += ((valueArray[f]) != null && double.TryParse(((ArrayList)valueArray[f])[1].ToString(),out a)) ? a : 0;
                            if (((valueArray[f]) != null && double.TryParse(((ArrayList)valueArray[f])[1].ToString(), out a)))
                            {
                                value += a;
                            }
                            else
                            {
                                counts--;
                            }

                        }
                        double drv = count == 0 ? 0 : Math.Round(((value / counts) * countFJ) / 10000, 3);
                        //时间
                        ld.Add(((ArrayList)(((ArrayList)list[0]["data"])[f]))[0]);
                        ld.Add(drv);
                        lt.Add(ld);
                    }
                    ht1.Add("name", "标杆风机参考值");
                    ht1.Add("yAxis", 0);
                    ht1.Add("data", lt);
                    for (int ro = 0; ro <listCount-2; ro++)
                    {
                        list.Remove(list[2]);
                    }
                    list.Add(ht1);

                    ArrayList list1 = new ArrayList();
                    string[] str2 = new string[9] { "#058DC7", "#50B432", "#ED561B", "#DDDF00", "#24CBE5", "#64E572", "#FF9655", "#FFF263", "#6AF9C4" };
                    int num1 = 0;
                    foreach (Hashtable _ht in list)
                    {
                        ArrayList _data = (ArrayList)_ht["data"];
                        Hashtable _dv1 = new Hashtable();
                        _dv1.Add("lineColor", str2[num1]);

                        _dv1.Add("maxPadding", "1");
                        //string[] aa = new string[1];
                        //aa[0] = "text:'万千瓦'";
                        Hashtable hy1 = new Hashtable();
                        Hashtable hy2 = new Hashtable();
                        Hashtable hy3 = new Hashtable();


                        if (num1 == 1)
                        {
                            _dv1.Add("opposite", true);//Y轴右端显示
                            hy2.Add("text", "（S/M)速风");

                            _dv1.Add("title", hy2);
                        }
                        else if(num1==0)
                        {
                            hy1.Add("text", "负荷(万千瓦)");
                            _dv1.Add("title", hy1);
                        }
                        else if (num1 == 2)
                        {
                            //hy3.Add("text", "标杆风机参考值(万千瓦)");
                            //_dv1.Add("title", hy3);
                        }
                        _dv1.Add("lineWidth", 1);
                        if (num1 != 2)
                        {
                            list1.Add(_dv1);
                        }
                        num1++;

                    }
                    object obj = new
                    {
                        company = r["T_COMDESC"].ToString(),
                        title = desc + " 风速、负荷、标杆实时趋势",
                        y_data = list1,
                        list =  list
                    }; 
                    string result = Newtonsoft.Json.JsonConvert.SerializeObject(obj);

                    //Response.Write(result);
                    //Response.End();
                    //l.Add(list);
                    s.Add(result);
                    if (!companyName.Contains(r["T_COMDESC"].ToString()))
                    {
                        companyName.Add(r["T_COMDESC"].ToString());
                    }
                }
                //object obj = new
                //{
                //    list = l
                //};
                //string result = Newtonsoft.Json.JsonConvert.SerializeObject(obj);

                //Response.Write(result);
                //Response.End();
                s.Add(companyName);
            }

            string re = Newtonsoft.Json.JsonConvert.SerializeObject(s);

            Response.Write(re);
            Response.End();



        }


    }
}