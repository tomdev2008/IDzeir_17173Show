package com._17173.flash.player.ui.stream.outGift
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.skin.ISkinObject;
	import com._17173.flash.core.util.Util;
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.player.context.ContextEnum;
	import com._17173.flash.player.model.RedirectData;
	import com._17173.flash.player.model.RedirectDataAction;
	import com._17173.flash.player.ui.comps.SkinsEnum;
	import com._17173.flash.player.ui.stream.extra.ExtraUIItemEnum;
	import com._17173.flash.player.ui.stream.outGift.ui.OutGiftUI;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.MouseEvent;
	
	public class OutGift extends Sprite
	{
		private var _ui:DisplayObject;
		private var streamBar:ISkinObject;
		
		/**
		 * 版本号 
		 */		
		protected var _version:String = "";
		
		public function OutGift()
		{
			super();
			_version = " 1.0.1";
			init();
		}
		
		private function init():void {
			showVersion();
			addToBar();
		}
		
		protected function showVersion():void {
			Debugger.log(Debugger.INFO, "[OutGift]", "站外礼物[版本:" + _version + "]初始化!");
		}
		
		/**
		 * 将内容添加到streamExtraBar中
		 */		
		public function addToBar():void {
			if (!_ui) {
				_ui = new OutGiftUI();
				_ui.name = "outGift";
				_ui.addEventListener(MouseEvent.CLICK, mouseClick);
			}
			var streamBar:ISkinObject = Context.getContext(ContextEnum.SKIN_MANAGER).getSkin(SkinsEnum.STREAM_EXTRA_BAR);
			if (streamBar) {
				streamBar.call("addItem", _ui, ExtraUIItemEnum.OUT_GIFT);
			}
		}
		
		/**
		 * 将内容从streamExtraBar中删除
		 */
		public function removeToBar():void {
			if (_ui) {
				var streamBar:ISkinObject = Context.getContext(ContextEnum.SKIN_MANAGER).getSkin(SkinsEnum.STREAM_EXTRA_BAR);
				if (streamBar) {
					streamBar.call("removeItem", _ui, ExtraUIItemEnum.OUT_GIFT);
				}
			}
		}
		
		private function mouseClick(evt:MouseEvent):void {
			var url:String = Context.variables.url;
			if (Util.validateStr(url)) {
				url = url.split("|")[0];
			}
			//回链
			var r:RedirectData = new RedirectData();
			r.click_type = RedirectDataAction.CLICK_TYPE_REDIRECTION;
			if (Util.validateStr(url)) {
				Context.stage.displayState = StageDisplayState.NORMAL;
				r.url = url;
			}
			r.action = RedirectDataAction.ACTION_BACK_GIFT;
			r.send();
		}
		
		public function get ui():DisplayObject
		{
			return _ui;
		}
		
		public function set ui(value:DisplayObject):void
		{
			_ui = value;
		}
		
		override public function set visible(value:Boolean):void {
			if (_ui) {
				_ui.visible = value;
			}
		}
		
	}
}


