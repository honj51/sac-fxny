using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using DAL.Connect;
using System.Collections;
using System.Data;

namespace BLL.Connect
{
    public class BLLConnect
    {
        DALConnect dc = new DALConnect();
         /// <summary>
        /// 获取指定条件的电源项目综合信息
        /// </summary>
        /// <param name="dataType">电源类型</param>
        /// <param name="area">区域</param>
        /// <param name="periodName">场站名称</param>
        /// <param name="zxType">纵向的类型（总1，区域1，场站1，机组2）机组不用分组</param>
        /// <returns></returns>
        public List<ArrayList> GetProject(string dataType, string area, string periodName, string zxType)
        {
            return dc.GetProject(dataType,area, periodName,zxType);
        }

         /// <summary>
        /// 获取指定的机组的测点
        /// </summary>
        /// <param name="IdKey">T_INFO_UNIT 唯一ID标识</param>
        /// <returns></returns>
        public DataTable GetUnitMonitor(string IdKey)
        {
            return dc.GetUnitMonitor(IdKey);
        }
    }
}
