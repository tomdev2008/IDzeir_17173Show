package com._17173.flash.core.components.common
{
	import flash.display.DisplayObjectContainer;
	
	/** 
	 * @author idzeir
	 * 创建时间：2014-1-23  下午4:02:36
	 */
	public class HScrollBar extends ScrollBar
	{
		/**
		 * 水平滚动条 
		 * @param parent
		 * @param defaultHandler
		 * 
		 */	
		public function HScrollBar(parent:DisplayObjectContainer=null, defaultHandler:Function=null)
		{
			super(Slider.HORIZONTAL, parent, defaultHandler);
		}
	}
}