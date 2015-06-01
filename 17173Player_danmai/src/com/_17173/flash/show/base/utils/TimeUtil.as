package com._17173.flash.show.base.utils
{
	import com._17173.flash.core.util.Util;

	/** 
	 * @author idzeir
	 * 创建时间：2014-2-19  上午11:18:37
	 */
	public class TimeUtil
	{
		/**
		 * 获取当时小时和分钟组成的字符串 
		 * @param splitTag 间隔字符串
		 * @return 
		 * 
		 */		
		static public function getTimeFormat(splitTag:String=":"):String
		{
			var date:Date=new Date();			
			return Util.fillStr(String(date.getHours()), "0", 2)+splitTag+Util.fillStr(String(date.getMinutes()), "0", 2);
		}
	}
}