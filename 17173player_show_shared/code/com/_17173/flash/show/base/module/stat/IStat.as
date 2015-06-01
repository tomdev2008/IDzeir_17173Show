package com._17173.flash.show.base.module.stat
{
	public interface IStat
	{
		
		/**
		 * 发送统计数据.
		 *  
		 * @param type 要发送的统计的事件(即类别)
		 * @param event 要发送的统计事件
		 * @param data 要发送的统计相关的数据
		 * 
		 */		
		function stat(type:String, event:String, data:Object):void;
		
	}
}