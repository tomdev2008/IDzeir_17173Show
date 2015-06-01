package com._17173.flash.core.skin
{
	/**
	 * 要让skin comp可以接受skin manager所发出的事件,则该comp需实现此接口.
	 *  
	 * @author shunia-17173
	 */	
	public interface ISkinObjectListener
	{
		
		function listen(event:String, data:Object):void;
		
	}
}