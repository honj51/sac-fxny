using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SACSIS
{
    public class czInfo
    {
        public string T_ORGID { get; set; }
        public string T_PERIODID { get; set; }

        public string 区域 { get; set; }
        public string 风电场 { get; set; }
        public double 装机容量 { get; set; }
        public string 机型 { get; set; }
        public double 风速 { get; set; }
        public double 功率 { get; set; }
        public double 出力率 { get; set; }
        public double 限负荷 { get; set; }
        public double 日电量 { get; set; }
        public double 日等效利用小时 { get; set; }
        public double 月电量 { get; set; }
        public double 月计划 { get; set; }
        public double 月完成率 { get; set; }
        public double 月等效利用小时 { get; set; }
        public double 年电量 { get; set; }
        public double 年计划 { get; set; }
        public double 年完成率 { get; set; }
        public double 年等效利用小时 { get; set; }
        public double 总台数 { get; set; }
        public double 运行 { get; set; }
        public double 计划检修 { get; set; }
        public double 故障 { get; set; }
        public double 待机 { get; set; }
        public double 机组故障率 { get; set; }
        public int 机组状态排名 { get; set; }
        public int 出力率排名 { get; set; }


        public czInfo()
        { 
             出力率 = new Random().Next(22, 100);
             机组故障率 = new Random().Next(0, 66);
        }
        
    }
}