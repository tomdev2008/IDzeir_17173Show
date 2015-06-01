package com._17173.flash.show.base.module.broadcast
{
	import com._17173.flash.show.core.base.module.BaseModule;
	
	import flash.display.Shape;
	
	/**
	 * 房间礼物模块.
	 *  
	 * @author shunia-17173
	 */	
	public class Broadcast extends BaseModule
	{
		
		private var _bg:Shape = null;
		
		public function Broadcast()
		{
			super();
		}
		
		override protected function init():void {
			super.init();
			
			_bg = new Shape();
			_bg.graphics.beginFill(0xFF0000, 0.2);
			_bg.graphics.drawRect(0, 0, 402, 154);
			_bg.graphics.endFill();
			addChild(_bg);
		}
		
	}
}