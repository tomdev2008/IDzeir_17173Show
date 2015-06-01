package com._17173.flash.player.ui.stream
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.util.Util;
	import com._17173.flash.player.business.stream.custom.StreamCustomDataRetriver;
	import com._17173.flash.player.context.ContextEnum;
	import com._17173.flash.player.model.PlayerEvents;
	import com._17173.flash.player.model.PlayerScope;
	import com._17173.flash.player.model.RedirectData;
	import com._17173.flash.player.model.RedirectDataAction;
	import com._17173.flash.player.ui.comps.BaseRightBar;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
	public class StreamOutRightBar extends BaseRightBar
	{
		private var _share:MovieClip = null;
		private var _room:SimpleButton = null;
		private var _more:SimpleButton = null;
		private var _showResizDic:Dictionary = null;
		
		public function StreamOutRightBar()
		{
			_showResizDic = new Dictionary();
			Context.getContext(ContextEnum.EVENT_MANAGER).listen(PlayerEvents.UI_INTED, onModuleComplete);
		}
		
		private function onModuleComplete(value:Object):void {
			addListeners();
		}
		
		protected function initComp():void {
			var uiModule:Object = Context.variables["UIModuleData"];
			if (!uiModule) {
				return;
			}
			if (uiModule[StreamCustomDataRetriver.M9] && _showResizDic["share"]) {
				//分享
				_share = new mc_rightbar_share();
				_con.addChild(_share);
				if (!_share.hasEventListener("onShare")) {
					_share.addEventListener("onShare", onShareTo);
				}
			}
			if (uiModule[StreamCustomDataRetriver.M5] && _showResizDic["room"]) {
				//房间
				_room = new mc_rightbar_room();
				_con.addChild(_room);
				if (!_room.hasEventListener(MouseEvent.CLICK)) {
					_room.addEventListener(MouseEvent.CLICK, roomClick);
				}
			}
			if (uiModule[StreamCustomDataRetriver.M6] && _showResizDic["more"]) {
				//更多
				_more = new mc_rightbar_more();
				_con.addChild(_more);
				if (!_more.hasEventListener(MouseEvent.CLICK)) {
					_more.addEventListener(MouseEvent.CLICK, moreClick);
				}
			}
		}
		
//		override protected function addListeners():void {
//			var uiModule:Object = Context.variables["UIModuleData"];
//			if (!uiModule) {
//				return;
//			} else {
//				super.addListeners();
//			}
//			
//			if (_share) {
//				_share.addEventListener("onShare", onShareTo);
//			}
//			
//			if (_room) {
//				_room.addEventListener(MouseEvent.CLICK, roomClick);
//			}
//			
//			if (_more) {
//				_more.addEventListener(MouseEvent.CLICK, moreClick);
//			}
//		}
		
		private function onShareTo(e:Event):void {
			Context.getContext(ContextEnum.EVENT_MANAGER).send(PlayerEvents.UI_SHOW_SHARE);
		}
		
		private function roomClick(evt:MouseEvent):void {
			var url:String = Context.variables.url;
			if (Util.validateStr(url)) {
				url = url.split("|")[0];
			}
			//回链
			var r:RedirectData = new RedirectData();
			r.click_type = RedirectDataAction.CLICK_TYPE_REDIRECTION;
			if (Util.validateStr(url)) {
				r.url = url;
			}
			r.action = RedirectDataAction.ACTION_BACK_TO_ROOM;
			r.send();
		}
		
		private function moreClick(evt:MouseEvent):void {
			//回链
			var r:RedirectData = new RedirectData();
			r.click_type = RedirectDataAction.CLICK_TYPE_REDIRECTION;
			r.action = RedirectDataAction.ACTION_BACK_MORE;
			r.send();
		}
		
		override protected function onCheckShow(event:MouseEvent):void {
			if (event.stageX > (Context.stage.stageWidth - width - 100) && 
				Context.stage.stageWidth >= PlayerScope.PLAYER_WIDTH_5) {
				onShow();
			} else {
				onHide();
			}
		}
		
		override public function resize():void
		{
			if (this.numChildren > 0) {
				//删除当前所以内容，为了解决全屏和高端较小切换的时候背景不变化的bug
				this.removeChildren(0, this.numChildren - 1);
			}
			init();
			checkResizeDic();
			if (_con.numChildren > 0) {
				_con.removeChildren(0, _con.numChildren - 1);
			}
			initComp();
			if(_con && contains(_con))
			{
				var d:DisplayObject = null;
				var tmp:int = 50;
				for (var i:int = 0; i < _con.numChildren; i++) {
					d = _con.getChildAt(i);
					if (d) {
						d.x = 0;
						if (i == 0) {
							d.y = 0;
						} else {
							d.y = _con.getChildAt(i - 1).y + _con.getChildAt(i - 1).height;
						}
					}
				}
			}
			if(_con && contains(_con))
			{
				var height:Number = 0;
				for (var j:int = 0; j < _con.numChildren; j++) {
					height += _con.getChildAt(j).height;
				}
				_con.graphics.clear();
				_con.graphics.beginFill(0x1d1d1d, 0.8);
				_con.graphics.drawRoundRectComplex(0, 0, 58, height, 10, 0, 10, 0);
				_con.graphics.endFill();
			}
		}
		
		/**
		 * 根据当前高度计算那些组件可以被显示
		 */		
		private function checkResizeDic():void {
			var h:Number = Context.stage.stageHeight;
			_showResizDic["share"] = true;
			_showResizDic["room"] = true;
			_showResizDic["more"] = true;
			if (h < PlayerScope.PALYER_HEIGHT_4) {
				_showResizDic["share"] = false;
			}
			if (h < PlayerScope.PALYER_HEIGHT_5) {
				_showResizDic["room"] = false;
				_showResizDic["more"] = false;
			}
		}
		
	}
}