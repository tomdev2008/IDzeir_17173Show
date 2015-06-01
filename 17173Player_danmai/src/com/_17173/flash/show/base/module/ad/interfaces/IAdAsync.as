package  com._17173.flash.show.base.module.ad.interfaces
{
	public interface IAdAsync
	{
		/**
		 * 错误回调方法
		 *  
		 * @param value
		 */		
		function set onError(value:Function):void;
		/**
		 * 结束回调方法
		 *  
		 * @param value
		 */		
		function set onComplete(value:Function):void;
		/**
		 * 数据
		 *  
		 * @param value
		 */		
		function set data(value:Object):void;
		/**
		 * 释放 
		 */		
		function dispose():void;
	}
}