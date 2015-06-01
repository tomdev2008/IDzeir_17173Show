package com._17173.flash.player.module.otherLogo
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.skin.ISkinObject;
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.player.context.ContextEnum;
	import com._17173.flash.player.model.PlayerType;
	import com._17173.flash.player.ui.comps.SkinsEnum;
	import com._17173.flash.player.ui.stream.extra.ExtraUIItemEnum;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	
	/**
	 * 合作logo
	 */	
	public class OtherLogo extends Sprite
	{
		private var _logo:LogoUI;
		private var _w:Number = 80;
		private var _h:Number = 23;
		
		public function OtherLogo()
		{
			super();
			init();
		}
		
		private function init():void {
			var ver:String = "1.0.6";
			Debugger.log(Debugger.INFO, "[otherLogo]", "合作Logo模块[版本:" + ver + "]初始化!");
			var uiData:Object = Context.variables["UIModuleData"];
			var currentType:String = "";
//			if (Context.variables["type"] == Settings.PLAYER_TYPE_STREAM_OUT_CUSTOM) {
			if (Context.variables["type"] == PlayerType.S_CUSTOM) {
				currentType = "m2";
			} else {
				currentType = "m3";
			}
			if (_logo) {
				_logo.removeEventListener("loadComplete", loadComplete);
				_logo = null;
			}
			if (uiData.hasOwnProperty(currentType) && uiData[currentType] == true) {
				if (uiData.hasOwnProperty("otherLogo") && uiData["otherLogo"] != "") {
					var j:String = "";
					if (uiData.hasOwnProperty("j")) {
						j = uiData["j"]
					}
					_logo = new LogoUI(_w, _h);
					_logo.name = "otherLogo";
					_logo.addUrl(uiData["otherLogo"], j);
					_logo.addEventListener("loadComplete", loadComplete);
				}
			}
		}
		
		private function loadComplete(evt:Event):void {
			addToBar();
		}
		
		/**
		 * 将logo添加到bar上
		 */		
		public function addToBar():void {
//			if (Context.variables["type"] == Settings.PLAYER_TYPE_STREAM_OUT_CUSTOM) {
			if (Context.variables["type"] == PlayerType.S_CUSTOM) {
				var streamBar:ISkinObject = Context.getContext(ContextEnum.SKIN_MANAGER).getSkin(SkinsEnum.STREAM_EXTRA_BAR);
				if (streamBar) {
					streamBar.call("addItem", _logo, ExtraUIItemEnum.OUT_LOGO);
				}
//			} else if (Context.variables["type"] == Settings.PLAYER_TYPE_FILE_OUT_CUSTOM) {
			} else if (Context.variables["type"] == PlayerType.F_CUSTOM) {
				var right:ISkinObject = Context.getContext(ContextEnum.SKIN_MANAGER).getSkin(SkinsEnum.CONTROL_BAR);
				if (right) {
					right.call("addOtherLogo", _logo);
				}
			}
		}
		
		override public function set visible(value:Boolean):void {
			if (_logo) {
				_logo.visible = value;
			}
		}
		
	}
}