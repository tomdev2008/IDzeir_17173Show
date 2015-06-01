package com._17173.flash.player.ui
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.player.context.ContextEnum;
	import com._17173.flash.player.model.PlayerEvents;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	/**
	 * 推荐层.用于点/直播放器的前/后推荐. 
	 * @author shunia-17173
	 */	
	public class RecommendLayer extends Sprite
	{
		public function RecommendLayer()
		{
			super();
			(Context.getContext(ContextEnum.EVENT_MANAGER) as IEventManager).listen(PlayerEvents.UI_RESIZE, resize);
//			Global.eventManager.listen(PlayerEvents.UI_RESIZE, resize);
		}
		
		public function resize(data:Object = null):void {
			for (var i:int = 0; i < numChildren; i ++) {
				var child:DisplayObject = getChildAt(i);
				if (child.hasOwnProperty("resize") && child["resize"] is Function) {
					child["resize"]();
				}
			}
		}
		
		public function clear():void {
			while (numChildren) {
				removeChildAt(0);
			}
		}
		
	}
}