package com._17173.flash.show.module.video.app
{
	import com._17173.flash.core.components.common.VGroup;
	
	import flash.display.Sprite;
	
	public class AppPanel extends Sprite
	{
		private var _appGroup:VGroup;
		public function AppPanel()
		{
			super();
			this.graphics.clear();
			this.graphics.beginFill(0,0);
			this.graphics.drawRect(0,0,46,358);
			this.graphics.endFill();
			
			_appGroup = new VGroup();
			_appGroup.gap = 12;
			_appGroup.left = 8;
//			_appGroup.align = VGroup.CENTER;
			this.addChild(_appGroup);
		}
		
		
		public function setAppData(value:Object):void
		{
			var array:Array = value as Array;
			for each(var obj:Object in array)
			{
				var appItem:AppItem = new AppItem();
				appItem.setData(obj);
				_appGroup.addChild(appItem);
			}
		}
	}
}