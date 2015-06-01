package com._17173.flash.player.module.extrarecommand
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.skin.ISkinManager;
	import com._17173.flash.core.skin.ISkinObject;
	import com._17173.flash.player.context.ContextEnum;
	import com._17173.flash.player.ui.comps.SkinsEnum;
	import com._17173.flash.player.ui.stream.extra.ExtraUIItemEnum;
	import com._17173.flash.player.ui.stream.extra.IExtraUIItem;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class ToolRCView extends Sprite implements IExtraUIItem
	{
		
		private var mobileItem:MobileAppExtraItem = null;
		private var toolItem:VideoToolExtraItem = null;
		
		public function ToolRCView()
		{
			super();
			
			init();
			
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		protected function onAdded(event:Event):void {
			dispatchEvent(new Event("updated"));
		}
		
		private function init():void
		{
			mobileItem = new MobileAppExtraItem();
			toolItem = new VideoToolExtraItem();
			toolItem.x = -toolItem.width;
			mobileItem.x = toolItem.x - 10 - mobileItem.width;
			addChild(mobileItem);
			addChild(toolItem);
		}
		
		public function refresh(isFullScreen:Boolean=false):void
		{
			
			var s:ISkinManager = Context.getContext(ContextEnum.SKIN_MANAGER) as ISkinManager;
			var extraBar:ISkinObject = s.getSkin(SkinsEnum.STREAM_EXTRA_BAR);
			if (extraBar.display.width < 710) {
				mobileItem.visible = false;
			} else {
				mobileItem.visible = true;
			}
			if (extraBar.display.width < 660) {
				toolItem.visible = false;
			} else {
				toolItem.visible = true;
			}
		}
		
		public function get side():Boolean
		{
			return ExtraUIItemEnum.SIDE_RIGHT;
		}
		
	}
}