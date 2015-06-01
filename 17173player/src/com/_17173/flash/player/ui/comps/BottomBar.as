package com._17173.flash.player.ui.comps
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.skin.ISkinManager;
	import com._17173.flash.core.skin.ISkinObject;
	import com._17173.flash.core.skin.ISkinObjectListener;
	import com._17173.flash.player.context.ContextEnum;
	import com._17173.flash.player.model.SkinEvents;
	import com.greensock.TweenLite;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	public class BottomBar extends Sprite implements ISkinObjectListener
	{
		
		protected var _controlBar:ISkinObject = null;
		protected var _mouseEnableFlag:Boolean;
		protected var _mouseChilderFlag:Boolean;
		
		public function BottomBar()
		{
			super();
			
			addControlBar();
			y = Context.stage.stageHeight - height;
		}
		
		public function resize():void {
			resetControlBar();
			//逐个更新
			var h:Number = 0;
			for (var i:int = 0; i < numChildren; i ++) {
				var child:DisplayObject = getChildAt(i);
				if (child.hasOwnProperty("resize")) {
					child["resize"]();
				}
				child.y = h;
				child.x = (Context.stage.stageWidth - child.width) / 2;
				h += child.height;
			}
		}
		
		/**
		 * 添加ControlBar
		 */		
		protected function addControlBar():void {
//			_controlBar = Global.skinManager.attachSkinByName(SkinsEnum.CONTROL_BAR, this);
			_controlBar = (Context.getContext(ContextEnum.SKIN_MANAGER) as ISkinManager).attachSkinByName(SkinsEnum.CONTROL_BAR, this);
		}
		
		/**
		 * 预留方法
		 * 根据当前的播放器宽度设置是否要显示ControlBar
		 */		
		protected function resetControlBar():void {
		}
		
		override public function get height():Number {
			var h:Number = 0;
			for (var i:int = 0; i < numChildren; i ++) {
				h += getChildAt(i).height;
			}
			return h;
		}
		
		public function listen(event:String, data:Object):void
		{
			switch (event) {
				case SkinEvents.RESIZE : 
					resize();
					TweenLite.killTweensOf(this);
					y = Context.stage.stageHeight - height;
					break;
				case SkinEvents.SHOW_FLOW : 
					if (Context.getContext(ContextEnum.SETTING).isFullScreen) {
						TweenLite.to(this, 0.5, {"y":Context.stage.stageHeight - height});
					}
					break;
				case SkinEvents.HIDE_FLOW : 
					if (Context.getContext(ContextEnum.SETTING).isFullScreen) {
						TweenLite.to(this, 0.5, {"y":Context.stage.stageHeight});
					}
					break;
			}
		}
		
		override public function set mouseEnabled(enabled:Boolean):void {
			_mouseEnableFlag = enabled;
			for (var i:int = 0; i < numChildren; i ++) {
				var item:Sprite = getChildAt(i) as Sprite;
				item.mouseEnabled = enabled;
			}
		}
		
		override public function set mouseChildren(enable:Boolean):void {
			_mouseChilderFlag = enable;
			for (var i:int = 0; i < numChildren; i ++) {
				(getChildAt(i) as Sprite).mouseChildren = enable;
			}
		}
		
	}
}