package com._17173.flash.player.module.vi
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.player.context.ContextEnum;
	
	import flash.display.Sprite;
	import flash.ui.Keyboard;
	
	public class SM extends Sprite
	{
		private static const ver:String = "1.0.1";
		/**
		 * 视频信息面板 
		 */		
		private var _videoInfoPanel:VideoInfoPanel = null;
		
		public function SM()
		{
			super();
			
			Debugger.log(Debugger.INFO, "[monitor]", "流信息模块[版本:" + ver + "]初始化!");
			
			var k:Object = Context.getContext(ContextEnum.KEYBOARD);
			if (k && k.hasOwnProperty("registerKeymap")) {
				k.registerKeymap(showVideoInfo, Keyboard.CONTROL, Keyboard.ALTERNATE, Keyboard.NUMBER_1);
			}
		}
		
		private function showVideoInfo():void {
			if (_videoInfoPanel == null) {
				_videoInfoPanel = new VideoInfoPanel();
			}
			_videoInfoPanel.x = 20;
			_videoInfoPanel.y = 20;
			Context.stage.addChild(_videoInfoPanel);
		}
	}
}