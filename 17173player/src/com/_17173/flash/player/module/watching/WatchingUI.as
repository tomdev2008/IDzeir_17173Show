package com._17173.flash.player.module.watching
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.util.Util;
	import com._17173.flash.player.model.PlayerScope;
	import com._17173.flash.player.model.PlayerType;
	import com._17173.flash.player.ui.stream.extra.ExtraUIItemEnum;
	import com._17173.flash.player.ui.stream.extra.IExtraUIItem;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	/**
	 * 观看人数的控件.
	 *  
	 * @author shunia-17173
	 */	
	public class WatchingUI extends Sprite implements IExtraUIItem
	{
		
		private var _p:TextField = null;
		private var _icon:DisplayObject = null;
		private var _t:TextField = null;
		
		public function WatchingUI()
		{
			super();
			
			_icon = new mc_watching();
			addChild(_icon);
			
			var fmt:TextFormat = new TextFormat();
			fmt.font = Util.getDefaultFontNotSysFont();
			_p = new TextField();
			_p.textColor = 0xFDCD00;
			_p.autoSize = TextFieldAutoSize.LEFT;
			_p.text = "    0";
			_p.selectable = false;
			_p.defaultTextFormat = fmt;
			addChild(_p);
			
			_t = new TextField();
			_t.text = "人正一同观看直播";
			_t.autoSize = TextFieldAutoSize.LEFT;
			_t.textColor = 0x5C5C5C;
			_t.selectable = false;
			_t.defaultTextFormat = fmt;
			
			
			resize();
		}
		
		/**
		 * 添加说明到项目里
		 */		
		private function addDescription():void {
//			if (Context.variables["type"] == Settings.PLAYER_TYPE_STREAM_OUT_CUSTOM) {
			if (Context.variables["type"] == PlayerType.S_CUSTOM) {
				if (Context.stage.stageWidth > PlayerScope.PLAYER_WIDTH_2) {
					if (!contains(_t)) {
						addChild(_t);
					}
				} else {
					if (contains(_t)) {
						this.removeChild(_t);
					}
				}
			} else {
				if (!contains(_t)) {
					addChild(_t);
				}
			}
		}
		
		public function set num(value:int):void {
			_p.text = String(value);
			resize();
		}
		
		public function refresh(isFullScreen:Boolean=false):void
		{
//			resize();
		}
		
		public function resize():void
		{
			var t:Number = 0;
			var c:DisplayObject = null;
			addDescription();
			for (var i:int = 0; i < numChildren; i ++) {
				c = getChildAt(i);
				c.x = t;
				c.y = (height - c.height) / 2;
				t += c.width + 2;
			}
		}
		
		public function get side():Boolean
		{
			return ExtraUIItemEnum.SIDE_LEFT;
		}
	}
}