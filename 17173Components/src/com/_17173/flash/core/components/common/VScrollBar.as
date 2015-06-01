package com._17173.flash.core.components.common
{
	import flash.display.DisplayObjectContainer;
	
	/** 
	 * @author idzeir
	 * 创建时间：2014-1-23  下午4:04:02
	 */
	public class VScrollBar extends ScrollBar
	{
		/**
		 * 垂直滚动条 
		 * @param parent
		 * @param defaultHandler
		 * 
		 */		
		public function VScrollBar(parent:DisplayObjectContainer=null, defaultHandler:Function=null)
		{
			super(Slider.VERTICAL, parent, defaultHandler);
		}
	}
}