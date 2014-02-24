using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SAC.DBOperations;
using System.Data;
using System.Text;
using System.Collections;
using Newtonsoft.Json;
using BLL;

namespace SACSIS
{
    public partial class WebForm1 : System.Web.UI.Page
    {
        string sql = "";
        string errMsg = "";
        double[] _cll = null;
        double[] _ywcl = null;
        double[] _nwcl = null;
        double[] _jzgzl = null;

        List<czInfo> czxxList = new List<czInfo>();
        DBLink dl = new DBLink();
        PointBLL pbll = new PointBLL();

        protected void Page_Load(object sender, EventArgs e)
        {
            string funCode = Request["funCode"];

            if (!string.IsNullOrWhiteSpace(funCode))
            {
                if (funCode == "init")
                {
                   // double[] sadsadsadsa = pbll.GetPointVal(new string[] { "NMMG.00WindSpeed" }, DateTime.Now.ToString("yyyy-MM-dd 0:00:00"));

                    LoadData();

                }
            }
        }

        /// <summary>
        /// 初始化场站信息
        /// </summary>
        private void LoadData()
        {
            //sql = @"select * from ADMINISTRATOR.T_BASE_ORG";
            sql = @"select * from ADMINISTRATOR.T_BASE_COMPANY";
            DataTable dt = dl.RunDataTable(sql, out errMsg);

            //把信息加载到czInfo类中
            GetCZInfo(dt);

            //排序
            SortCZList(czxxList);

            string data=ConvertDataTableFromList(czxxList);
           // string result = "{\"data\":" + data + "}";

            double zrl = GetRl("3", "");
            double zgl = GetDl("", "3", 4);
            double zrdl = GetDl("", "3", 1);
            double zydl = GetDl("", "3", 2);
            double zndl = GetDl("", "3", 3);
            object _obj = new
            {
                data = data,
                cll = _cll,
                ywcl = _ywcl,
                nwcl = _nwcl,
                jzgzl = _jzgzl,
                zrl = zrl,
                zgl = Math.Round(zgl,2),
                zrdl = Math.Round(zrdl,2),
                zydl = Math.Round(zydl,2),
                zndl = Math.Round(zndl,2)

            };
            string result = JsonConvert.SerializeObject(_obj);
            Response.Write(result);
            Response.End();
        }

        /// <summary>
        /// 将厂站类LIST转变为table
        /// </summary>
        /// <param name="czxxList"></param>
        /// <returns></returns>
        private string ConvertDataTableFromList(List<czInfo> czxxList)
        {
            StringBuilder htmlTable = new StringBuilder();
            htmlTable.Append("<table cellSpacing='0' cellPadding='0' width ='1200px'  border='1'>");
            //标题行
           // string strTitle = @"<tr><td rowspan='2' style='width:130px'>风电场</td><td colspan='2' style='width:60px'>装机情况</td><td colspan='4' >出力情况</td><td colspan='10' >电量情况</td><td colspan='8'>机组运行状态</td></tr>  <tr><td style='width:60px'>装机容量</td><td style='width:60px'>机型</td><td style='width:60px'>风速</td><td style='width:60px'>功率</td><td style='width:120px'>出力率</td><td style='width:60px'>限负荷</td><td style='width:60px'>日电量</td>    <td style='width:60px'>日等效利用小时</td>    <td style='width:60px'>月电量</td>    <td style='width:60px'>月计划</td>    <td style='width:120px'>月完成率</td>    <td style='width:60px'>月等效利用小时</td>    <td style='width:60px'>年累计</td>    <td style='width:60px'>年计划</td>    <td style='width:120px'>年完成率</td>    <td style='width:60px'>年等效利用小时</td>    <td style='width:60px'>总台数</td>    <td style='width:60px'>运行</td>    <td style='width:60px'>计划检修</td>    <td style='width:60px'>故障</td><td style='width:60px'>待机</td><td style='width:120px'>机组故障率</td><td style='width:60px'>机组状态排名</td><td style='width:60px'>出力率排名</td>  </tr> ";
            string strTitle = @"<tr><td rowspan='2' style='width:80px'>区域</td><td rowspan='2' style='width:100px'>风电场</td><td colspan='2' style='width:60px'>装机情况</td><td colspan='4' >出力情况</td><td colspan='10' >电量情况</td><td colspan='8'>机组运行状态</td></tr>  <tr><td style='width:60px'>装机容量</td><td style='width:60px'>机型</td><td style='width:40px'>风速</td><td style='width:40px'>功率</td><td style='width:110px'>出力率</td> <td style='width:40px'>日电量</td>    <td style='width:40px'>日等效利用小时</td>    <td style='width:40px'>月电量</td>    <td style='width:60px'>月计划</td>    <td style='width:110px'>月完成率</td>    <td style='width:40px'>月等效利用小时</td>    <td style='width:40px'>年累计</td>    <td style='width:40px'>年计划</td>    <td style='width:110px'>年完成率</td>    <td style='width:40px'>年等效利用小时</td>    <td style='width:40px'>总台数</td>    <td style='width:35px'>运行</td>  <td style='width:35px'>故障</td><td style='width:35px'>待机</td><td style='width:60px'>出力率排名</td>  </tr> ";

            string strTr = "";
            //区域数
            List<string> areaName = czxxList.Select(d => d.区域).Distinct().ToList();
            List<czInfo> tmp = czxxList;
            _cll = new double[czxxList.Count];
            _ywcl = new double[czxxList.Count];
            _nwcl = new double[czxxList.Count];
            _jzgzl = new double[czxxList.Count];
            foreach (string area in areaName)
            {
                czxxList = tmp.Where(t => t.区域 == area).ToList();
                for (int z = 0; z < czxxList.Count; z++)
                {
                    //onMouseOver="this.className='over';" onMouseOut="this.className='out';"
                    strTr += "<tr style='display:inline;' T_ORGID='" + czxxList[z].T_ORGID + "'";
                  
                    if (czxxList[z].T_PERIODID != null)
                    {
                        strTr += "T_PERIODID='" + czxxList[z].T_PERIODID + "'>";
                        if (z == 0)
                        {
                            strTr += "<td style='text-align:left;' rowspan='" + czxxList.Count + "'>&nbsp;" + area + "</td>";
                        }
                        strTr += "<td style='text-align:left;'>&nbsp;" + czxxList[z].风电场 + "</td>";
                    }
                    else
                    {
                        // strTr += " T_PERIODID='' onclick='HidenShowTr(this)' onMouseOver='MouseAct(this,1);' onMouseOut='MouseAct(this,2);'>";
                        strTr += " T_PERIODID='' onclick='HidenShowTr(this)'>";
                        if (z == 0)
                        {
                            strTr += "<td style='text-align:left;' rowspan='"+czxxList.Count+"'>&nbsp;" + area + "</td>";
                        }
                        strTr += "<td style='text-align:left;'><img id='" + czxxList[z].T_ORGID + "_img' src='../img/bg10.png'>&nbsp;" + czxxList[z].风电场 + "</td>";
                    }

                    strTr += "<td>" + czxxList[z].装机容量 + "</td>";
                    strTr += "<td>" + czxxList[z].机型 + "</td>";
                    strTr += "<td>" + czxxList[z].风速 + "</td>";
                    strTr += "<td>" + czxxList[z].功率 + "</td>";
                    _cll[z] = czxxList[z].出力率;
                    strTr += "<td><div id='cll_" + z + "'></div></td>";
                    //strTr += "<td>" + czxxList[z].限负荷 + "</td>";
                    strTr += "<td>" + czxxList[z].日电量 + "</td>";
                    strTr += "<td>" + czxxList[z].日等效利用小时 + "</td>";
                    strTr += "<td>" + czxxList[z].月电量 + "</td>";
                    strTr += "<td>" + czxxList[z].月计划 + "</td>";
                    _ywcl[z] = czxxList[z].月完成率;
                    strTr += "<td><div id='ywcl_" + z + "'></div></td>";
                    strTr += "<td>" + czxxList[z].月等效利用小时 + "</td>";
                    strTr += "<td>" + czxxList[z].年电量 + "</td>";
                    strTr += "<td>" + czxxList[z].年计划 + "</td>";
                    _nwcl[z] = czxxList[z].年完成率;
                    strTr += "<td><div id='nwcl_" + z + "'></div></td>";
                    strTr += "<td>" + czxxList[z].年等效利用小时 + "</td>";
                    strTr += "<td>" + czxxList[z].总台数 + "</td>";
                    strTr += "<td>" + czxxList[z].运行 + "</td>";
                    //strTr += "<td>" + czxxList[z].计划检修 + "</td>";
                    strTr += "<td>" + czxxList[z].故障 + "</td>";
                    strTr += "<td>" + czxxList[z].待机 + "</td>";
                    //_jzgzl[z] = czxxList[z].机组故障率;
                    //strTr += "<td><div id='jzgzl_" + z + "'></div></td>";
                    //strTr += "<td>" + czxxList[z].机组状态排名 + "</td>";
                    strTr += "<td>" + czxxList[z].出力率排名 + "</td>";
                    strTr += "</tr>";
                }
            }
            string strEnd = "<tr><td>备注</td><td  colspan='24' style='text-align:left'>单位：功率(MW),风速(M/S),功率(KWh),率(%)</td></tr>";
            htmlTable.Append(strTitle);
            htmlTable.Append(strTr);
            htmlTable.Append(strEnd);
            htmlTable.Append("</table>");
            return htmlTable.ToString();
        }

        /// <summary>
        /// 排序加上排名信息
        /// </summary>
        /// <param name="czxxList"></param>
        private void SortCZList(List<czInfo> czxxList)
        {
            List<czInfo> fzList = czxxList.FindAll(a => a.T_PERIODID == "" || a.T_PERIODID == null);
            fzList.Sort(new cllCompar());
            fzList.Reverse();
            if (fzList.Count > 0)
            {
                czxxList.Find(a => a.T_ORGID == fzList[0].T_ORGID).出力率排名 = 1;
                if (fzList.Count > 1)
                {
                    int count = 2;
                    for (int y = 1; y < fzList.Count; y++)
                    {
                        if (fzList[y-1].出力率 == fzList[y].出力率)
                        {
                            czxxList.Find(a => a.T_ORGID == fzList[y].T_ORGID).出力率排名 = count;
                        }
                        else
                        {
                            czxxList.Find(a => a.T_ORGID == fzList[y].T_ORGID).出力率排名 = count;
                            count++; 
                        }
                    }
                }
            }

            List<czInfo> gqList = czxxList.FindAll(a => a.T_PERIODID != "" && a.T_PERIODID != null);
            for (int x = 0; x < fzList.Count; x++)
            {
                List<czInfo> gqListDetail = gqList.FindAll(a => a.T_ORGID == fzList[x].T_ORGID);
                gqListDetail.Sort(new cllCompar());
                gqListDetail.Reverse();
                if (gqListDetail.Count > 0)
                {
                    czxxList.Find(a => a.T_PERIODID == gqListDetail[0].T_PERIODID).出力率排名 = 1;
                    if (gqListDetail.Count > 1)
                    {
                        int countTwo = 2;
                        for (int p = 1; p < gqListDetail.Count; p++)
                        {
                            if (gqListDetail[p - 1].出力率 == gqListDetail[p].出力率)
                            {
                                czxxList.Find(a => a.T_PERIODID == gqListDetail[p].T_PERIODID).出力率排名 = countTwo;
                            }
                            else
                            {
                                czxxList.Find(a => a.T_PERIODID == gqListDetail[p].T_PERIODID).出力率排名 = countTwo;
                                countTwo++;
                            }
                        }
                    }
                }
            }


            //机组状态排序

            List<czInfo> fzList2 = czxxList.FindAll(a => a.T_PERIODID == "" || a.T_PERIODID == null);
            fzList2.Sort(new cllCompar());
            fzList2.Reverse();
            if (fzList2.Count > 0)
            {
                czxxList.Find(a => a.T_ORGID == fzList2[0].T_ORGID).机组状态排名 = 1;
                if (fzList2.Count > 1)
                {
                    int count = 2;
                    for (int y = 1; y < fzList2.Count; y++)
                    {
                        if (fzList2[y - 1].机组故障率 == fzList2[y].机组故障率)
                        {
                            czxxList.Find(a => a.T_ORGID == fzList2[y].T_ORGID).机组状态排名 = count;
                        }
                        else
                        {
                            czxxList.Find(a => a.T_ORGID == fzList2[y].T_ORGID).机组状态排名 = count;
                            count++;
                        }
                    }
                }
            }

            List<czInfo> gqList2 = czxxList.FindAll(a => a.T_PERIODID != "" && a.T_PERIODID != null);
            for (int x = 0; x < fzList2.Count; x++)
            {
                List<czInfo> gqList2Detail2 = gqList2.FindAll(a => a.T_ORGID == fzList2[x].T_ORGID);
                gqList2Detail2.Sort(new cllCompar());
                gqList2Detail2.Reverse();
                if (gqList2Detail2.Count > 0)
                {
                    czxxList.Find(a => a.T_PERIODID == gqList2Detail2[0].T_PERIODID).机组状态排名 = 1;
                    if (gqList2Detail2.Count > 1)
                    {
                        int countTwo = 2;
                        for (int p = 1; p < gqList2Detail2.Count; p++)
                        {
                            if (gqList2Detail2[p - 1].机组故障率 == gqList2Detail2[p].机组故障率)
                            {
                                czxxList.Find(a => a.T_PERIODID == gqList2Detail2[p].T_PERIODID).机组状态排名 = countTwo;
                            }
                            else
                            {
                                czxxList.Find(a => a.T_PERIODID == gqList2Detail2[p].T_PERIODID).机组状态排名 = countTwo;
                                countTwo++;
                            }
                        }
                    }
                }
            }
        }
        
        /// <summary>
        /// 获得场站信息
        /// </summary>
        /// <param name="dt"></param>
        private void GetCZInfo(DataTable dtArea)
        {
            DataTable Sdt = null;
            DataTable dtOrg = null;
            //循环区域
            for (int area = 0; area < dtArea.Rows.Count; area++)
            {
                dtOrg = dl.RunDataTable("select * from ADMINISTRATOR.T_BASE_ORG where T_COMID='" + dtArea.Rows[area]["T_COMID"] + "'", out errMsg);

                //循环场站
                for (int a = 0; a < dtOrg.Rows.Count; a++)
                {
                    czInfo c = new czInfo();
                    Sdt = dl.RunDataTable("select * from ADMINISTRATOR.T_BASE_PERIOD where T_ORGID='" + dtOrg.Rows[a]["T_ORGID"] + "'", out errMsg);

                    if (Sdt.Rows.Count > 0)
                    {
                        if (Sdt.Rows.Count > 1)
                        {
                            c.区域 = dtArea.Rows[area]["T_COMDESC"].ToString();
                            c.T_ORGID = dtOrg.Rows[a]["T_ORGID"].ToString();
                            c.风电场 = dtOrg.Rows[a]["T_ORGDESC"].ToString();
                            GetStr(dtOrg.Rows[a]["T_ORGID"].ToString(), "1", c);
                            for (int b = 0; b < Sdt.Rows.Count; b++)
                            {
                                c = new czInfo();
                                c.区域 = dtArea.Rows[area]["T_COMDESC"].ToString();
                                c.T_ORGID = dtOrg.Rows[a]["T_ORGID"].ToString();
                                c.T_PERIODID = Sdt.Rows[b]["T_PERIODID"].ToString();
                                c.风电场 = Sdt.Rows[b]["T_PERIODDESC"].ToString();
                                GetStr(Sdt.Rows[b]["T_PERIODID"].ToString(), "2", c);
                            }
                        }
                        else
                        {
                            if (Sdt.Rows[0]["T_PERIODDESC"].ToString() == "全部")
                            {
                                //取组织机构描述
                                c = new czInfo();
                                c.区域 = dtArea.Rows[area]["T_COMDESC"].ToString();
                                c.T_ORGID = dtOrg.Rows[a]["T_ORGID"].ToString();
                                c.风电场 = dtOrg.Rows[a]["T_ORGDESC"].ToString();
                                GetStr(dtOrg.Rows[a]["T_ORGID"].ToString(), "1", c);
                            }
                            else
                            {
                                //取场站描述
                                c = new czInfo();
                                c.区域 = dtArea.Rows[area]["T_COMDESC"].ToString();
                                c.T_ORGID = dtOrg.Rows[a]["T_ORGID"].ToString();
                                c.T_PERIODID = Sdt.Rows[0]["T_PERIODID"].ToString();
                                c.风电场 = Sdt.Rows[0]["T_PERIODDESC"].ToString();
                                GetStr(Sdt.Rows[0]["T_PERIODID"].ToString(), "2", c);
                            }
                        }
                    }
                    else
                    {
                        c = new czInfo();
                        c.区域 = dtArea.Rows[area]["T_COMDESC"].ToString();
                        c.T_ORGID = dtOrg.Rows[a]["T_ORGID"].ToString();
                        c.风电场 = dtOrg.Rows[a]["T_ORGDESC"].ToString();
                        GetStr(dtOrg.Rows[a]["T_ORGID"].ToString(), "1", c);
                    }
                }
            }
        }

        /// <summary>
        /// 把信息加载到场站类
        /// </summary>
        /// <param name="id"></param>
        /// <param name="typ"></param>
        /// <param name="c"></param>
        /// <returns></returns>
        private string GetStr(string id,string typ,czInfo c)
        {
            string s = "";

            //装机容量
            double rl = GetRl(typ, id);
            c.装机容量 = rl;

            //机型 
            c.机型 = GetMachineName(typ,id);


            //风速 测点
            c.风速 = GetFS(typ, id);


            //功率 
            c.功率 = GetDl(id, typ, 4);


            //出力率
            if (rl == 0)
                c.出力率 = 0;
            else
                c.出力率 = Math.Round(c.功率 / rl * 100, 2);

            //限负荷



            //日电量
            double rdl = GetDl(id, typ, 1);
            c.日电量 = rdl;


            //日等效利用小时
            if (rl == 0)
                c.日等效利用小时 = 0;
            else
                c.日等效利用小时 = Math.Round(rdl*10 / rl, 2);


            //月电量
            double ydl = GetDl(id, typ, 2);
            c.月电量 = ydl;
 

            //月计划  
            double yjh = GetJHDl(id, typ, 2);

            c.月计划 = yjh;


            //月完成率
            if (yjh == 0)
                c.月完成率 = 0;
            else
                c.月完成率 = Math.Round(ydl / yjh * 100,2);


            //月等效利用小时
            if (rl == 0)
                c.月等效利用小时 = 0;
            else
                c.月等效利用小时 = Math.Round(ydl*10 / rl, 2);

            //年电量
            double ndl = GetDl(id, typ, 3);
            c.年电量 = ndl;

            //年计划  
            double njh = GetJHDl(id, typ, 3);
            c.年计划 = njh;

            //年完成率
            if (njh == 0)
                c.年完成率 = 0;
            else
                c.年完成率 = Math.Round(ndl / njh * 100, 2) ;


            //年等效利用小时

            if (rl == 0)
                c.年等效利用小时 = 0;
            else
                c.年等效利用小时 = Math.Round(ndl*10 / rl, 2);
            
            //总台数

            c.总台数 = GetState(id, typ, 0);
            //运行
            c.运行 = GetState(id, typ, 1);
            //计划检修

            //故障
            c.故障 = GetState(id, typ, 4);

            //待机 
            c.待机 = GetState(id, typ, 3);

            //机组故障率
            c.机组故障率 = 0;

            //机组状态排名


            //出力率排名 


            czxxList.Add(c);
            return s ;
        }

        /// <summary>
        /// 获得容量
        /// </summary>
        /// <param name="typ">1风场 2工期 3全部</param>
        /// <param name="id">id</param>
        /// <returns></returns>
        private double GetRl(string typ,string id)
        {
            if (typ == "1")
                sql = @"SELECT SUM(double(容量)) FROM            
                (select t.T_ORGID T_PERIODID,(select p.T_ORGID from ADMINISTRATOR.T_BASE_PERIOD p where p.T_PERIODID=t.T_ORGID) T_ORGID,t.容量
                from ADMINISTRATOR.T_INFO_RL t )
                where T_ORGID='" + id + "'";
            else if (typ == "2")
                sql = "select sum(double(容量)) from ADMINISTRATOR.T_INFO_RL  where T_ORGID='" + id + "'";
            else if (typ == "3")
                sql = "select sum(double(容量)) from ADMINISTRATOR.T_INFO_RL where T_ORGID in('MGYYQ-YQ','FLDFDC-QB','MGYEQ-EQ','SDFDC-QB')";

            object obj = dl.RunSingle(sql, out errMsg);
            if (obj == null)
                return 0;
            else
                return double.Parse(obj.ToString());
        }

        /// <summary>
        /// 获得机型
        /// </summary>
        /// <param name="typ"></param>
        /// <param name="id"></param>
        /// <returns></returns>
        private string GetMachineName(string typ, string id)
        {
            sql = @"select DISTINCT T_COMPANYNICK from
                    (SELECT * FROM (select t.T_MACHINEID,t.T_PERIODID,(select T_ORGID from ADMINISTRATOR.T_BASE_PERIOD p where p.T_PERIODID=t.T_PERIODID) T_ORGID,
                    (select T_COMPANYNICK from  ADMINISTRATOR.T_BASE_MACHINE m where m.T_MACHINEID=t.T_MACHINEID )
                    from ADMINISTRATOR.T_BASE_UNIT t) WHERE ";

            if (typ == "1")
                sql += "T_ORGID='" + id + "') ";
            else
                sql += "T_PERIODID='" + id + "') ";

            DataTable jxDt = dl.RunDataTable(sql, out errMsg);
            string jx = "";
            if (jxDt.Rows.Count > 0)
            {
                for (int n = 0; n < jxDt.Rows.Count; n++)
                {
                    jx += jxDt.Rows[n]["T_COMPANYNICK"].ToString() + ",";
                }
                jx = jx.Substring(0, jx.Length - 1);
            }
            return jx;
        }

        /// <summary>
        /// 获取电量 时实测点
        /// </summary>
        /// <param name="id"></param>
        /// <param name="typ">1：风场 2：工期</param>
        /// <param name="p">1:日 2：月 3：年</param>
        /// <returns></returns>
        private double GetDl(string id, string typ, int p)
        {
            string where = "";

            if (typ == "1")
                where = "tt.T_ORGID='" + id + "'";
            else if (typ == "2")
                where = "tt.T_PERIODID='" + id + "'";
            else if (typ == "3")
                where = "1=1";

            sql = @"select  t.T_POWERTAG, t.T_ORGID,t.T_DAYDL, t.T_MONTHDL, t.T_YEARDL
            
                    from ADMINISTRATOR.T_BASE_POINTS_ORG t 
                    
                    where t.T_ORGID in (select T_PERIODID from ADMINISTRATOR.T_BASE_PERIOD tt where " + where + ")";


            DataTable SSDl = dl.RunDataTable(sql, out errMsg);
            string dlTyp="";
            string searchTime = "";
            if (p == 1)
            {
                dlTyp = "T_DAYDL";
                searchTime = DateTime.Now.ToString("yyyy-MM-dd 0:00:00");
            }
            if (p == 2)
            {
                dlTyp = "T_MONTHDL";
                searchTime = DateTime.Now.ToString("yyyy-MM-1 0:00:00");
            }
            if (p == 3)
            {
                dlTyp = "T_YEARDL";
                searchTime = DateTime.Now.ToString("yyyy-1-1 0:00:00");
            }
            if (p == 4)
            {
                dlTyp = "T_POWERTAG";
                searchTime = DateTime.Now.ToString("yyyy-MM-dd 0:00:00");
            }


            string[] tag =new string[SSDl.Rows.Count];
            for (int aa = 0; aa < SSDl.Rows.Count; aa++)
            {
                tag[aa] = SSDl.Rows[aa][dlTyp].ToString();
            }
            double[] tagValues = pbll.GetPointVal(tag, searchTime);

            double v = 0;
            for (int bb = 0; bb < tagValues.Length; bb++)
            {
                v = v + tagValues[bb];
            }

            if (tagValues.Length < 1)
                return 0;
            else
                return v;
        }


        /// <summary>
        /// 获取电量 从关系库
        /// </summary>
        /// <param name="id"></param>
        /// <param name="typ">1：风场 2：工期</param>
        /// <param name="p">1:日 2：月 3：年</param>
        /// <returns></returns>
        //private object GetDl(string id, string typ, int p)
        //{
        //    sql = "select sum(D_VALUE) from ADMINISTRATOR.T_INFO_STATISCS where T_TJID='DL' and ";

        //    if (typ == "1")
        //        sql += "T_ORGID='" + id + "'";
        //    else
        //        sql += "T_PERIODID='" + id + "'";

        //    string sTime = "";
        //    string etime = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss");
        //    if (p == 1)
        //    {
        //        sTime = DateTime.Now.ToString("yyyy-MM-dd 0:00:00");
        //    }
        //    if (p == 2)
        //    {
        //        sTime = DateTime.Now.ToString("yyyy-MM-01 0:00:00");
        //    }
        //    if (p == 3)
        //    {
        //        sTime = DateTime.Now.ToString("yyyy-01-01 0:00:00");
        //    }

        //    sql += " and T_TIME>='" + sTime + "' and T_TIME<='" + etime + "'";

        //    return dl.RunSingle(sql, out errMsg);
        //}

        /// <summary>
        /// 获取计划电量
        /// </summary>
        /// <param name="id"></param>
        /// <param name="typ"></param>
        /// <param name="p"></param>
        /// <returns></returns>
        private double GetJHDl(string id, string typ, int p)
        {
            string Column = "";
            string where = "";
            if (p == 2)
                Column = "计划发电量" + DateTime.Now.Month.ToString()+" ";
            if (p == 3)
                Column = "年计划发电量 ";
            if (typ == "1")
                where = "tt.T_ORGID='" + id + "'";
            else if (typ == "2")
                where = "tt.T_PERIODID='" + id + "'";

            sql = "select SUM(double(" + Column+"))";
            sql += "from ADMINISTRATOR.T_INFO_JHDL t where t.T_ORGID in ";
            sql += "(select T_PERIODID from ADMINISTRATOR.T_BASE_PERIOD tt where " + where + ")";
            object objJHDL = dl.RunSingle(sql, out errMsg);

            if (objJHDL == null)
                return 0;
            else
                return double.Parse(objJHDL.ToString());
        }


        /// <summary>
        /// 获取计划电量
        /// </summary>
        /// <param name="id"></param>
        /// <param name="typ"></param>
        /// <param name="p"></param>
        /// <returns></returns>
//        private double GetJHDl(string id, string typ, int p)
//        {
//            sql = @"SELECT SUM(月计划电量) FROM            
//                        (select t.T_ORGID T_PERIODID,t.T_TIME,(select p.T_ORGID from ADMINISTRATOR.T_BASE_PERIOD p where p.T_PERIODID=t.T_ORGID) T_ORGID,t.月计划电量
//                        from ADMINISTRATOR.T_INFO_YJHDL t )
//                        where ";
//            if (typ == "1")
//                sql += "T_ORGID='" + id + "'";
//            else
//                sql += "T_PERIODID='" + id + "'";

//            if (p == 1)
//            {
//                sql += " and T_TIME='" + DateTime.Now.Year + "-" + DateTime.Now.Month + "-01 0:00:00'";
//            }
//            if (p == 2)
//            {
//                sql += " and T_TIME>='" + DateTime.Now.Year + "-01-01 0:00:00' and T_TIME<='" + DateTime.Now.Year + "-12-01 0:00:00'";
//            }

//            object obj = dl.RunSingle(sql, out errMsg);
//            if (obj == null)
//                return 0;
//            else
//                return double.Parse(obj.ToString());
//        }

        /// <summary>
        /// 风速
        /// </summary>
        /// <param name="typ"></param>
        /// <param name="id"></param>
        /// <returns></returns>
        private double GetFS(string typ,string id)
        {
            string where = "";

            if (typ == "1")
                where = "tt.T_ORGID='" + id + "'";
            else if (typ == "2")
                where = "tt.T_PERIODID='" + id + "'";
            else if (typ == "3")
                where = "1=1";

            sql = @"select  t.T_WINDTAG
            
                    from ADMINISTRATOR.T_BASE_POINTS_ORG t 
                    
                    where t.T_ORGID in (select T_PERIODID from ADMINISTRATOR.T_BASE_PERIOD tt where " + where + ")";


            DataTable dtFS = dl.RunDataTable(sql, out errMsg);

            string[] tag = new string[dtFS.Rows.Count];
            for (int aa = 0; aa < dtFS.Rows.Count; aa++)
            {
                tag[aa] = dtFS.Rows[aa]["T_WINDTAG"].ToString();
            }
            double[] tagValues = pbll.GetPointVal(tag, DateTime.Now.ToString("yyyy-MM-dd HH:mm:00"));

            double v = 0;
            for (int bb = 0; bb < tagValues.Length; bb++)
            {
                v = v + tagValues[bb];
            }

            if (tagValues.Length < 1)
            {
                return 0;
            }
            else
            {
                if (tagValues.Length > 1)
                {

                    return v / tagValues.Length;
                }
                else
                {
                    return v;
                }
            }
        }


        private double GetState(string id, string idType, double typ)
        {
            string where = "";
            if (idType == "1")
                where = "tt.T_ORGID='" + id + "'";
            else if (idType == "2")
                where = "tt.T_PERIODID='" + id + "'";

            sql = @"select count(0) from  ADMINISTRATOR.T_INFO_VALUE 
                    where T_POINT in (SELECT T_OUTTAG FROM ADMINISTRATOR.T_STATE_POINT where T_PERIODID in (select T_PERIODID from ADMINISTRATOR.T_BASE_PERIOD tt where " + where + "))";
            if (typ != 0)
                sql += " and T_VALUE=" + typ;

            object allCount = dl.RunSingle(sql, out errMsg);
            if (allCount != null)
                return double.Parse(allCount.ToString());
            else
                return 0;
        }

        public class jzztCompar : IComparer<czInfo>
        {
            public int Compare(czInfo x, czInfo y)
            {
                return x.机组故障率.CompareTo(y.机组故障率);
            }
        }

        public class cllCompar : IComparer<czInfo>
        {
            public int Compare(czInfo x, czInfo y)
            {
                return x.出力率.CompareTo(y.出力率);
            }
        }
    }
}