package com._17173.flash.show.base.context.errorrecord
{
	public interface IErrorRecordManager
	{
		/**
		 *错误统计 
		 * @param code 统计错误类型
		 * @param data 统计的相关参数
		 * 
		 */		
		function record(code:String,info:Object):void;
	}
}