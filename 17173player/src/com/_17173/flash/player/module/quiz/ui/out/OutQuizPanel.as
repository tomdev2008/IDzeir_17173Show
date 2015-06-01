package com._17173.flash.player.module.quiz.ui.out
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.util.Util;
	import com._17173.flash.player.context.ContextEnum;
	import com._17173.flash.player.model.RedirectDataAction;
	import com._17173.flash.player.module.quiz.QuizDataRetriver;
	import com._17173.flash.player.module.quiz.data.DealerData;
	import com._17173.flash.player.module.quiz.data.QuizData;
	import com._17173.flash.player.module.quiz.ui.out.refactor.OutQuizBottomPanel;
	import com._17173.flash.player.module.stat.IStat;
	import com._17173.flash.player.module.stat.base.StatTypeEnum;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class OutQuizPanel extends Sprite
	{
		
		private static const H:int = 100;
		
		private var _basePanel:MovieClip =null;
		private var _qd:QuizDataRetriver = new QuizDataRetriver();
		
		public var initGovInfo:QuizData = null;
		public var initPerInfo:QuizData = null;
		private var _w:int = 0;
		private var _h:int = 0;
		private var _current:QuizData = null;
		
		private var _isFullScreen:Boolean = false;
		
//		private var _bottomPanel:OutQuizBottom = null;
		
		private var _bottomPanel:OutQuizBottomPanel = null;
		
		public var _topbar:OutQuizUITopBar = null;
		
		/**
		 * 初始默认只显示topbar 如果有任何后续操作 _onlyTopBar都会变为false
		 */
		private var _onlyTopBar:Boolean = true;
		
		public function OutQuizPanel()
		{
			super();
			init();
		}
		
		private function init():void
		{	
			_basePanel = new customGuess_panelBg();
			_basePanel.height = H;
			addChild(_basePanel);
			
			_topbar = new OutQuizUITopBar();
			//保证时序
			_topbar.addEventListener("refreshGovContainer",getGovData);
			_topbar.addEventListener("refreshPerContainer",getPerData);
			_topbar.addEventListener("close", onClose);
			addChild(_topbar);
			
			_bottomPanel = new OutQuizBottomPanel();
			addChild(_bottomPanel);
			_bottomPanel.addEventListener(MouseEvent.CLICK, onPanelClick);
			
			resize(_isFullScreen);
		}
		
		public function setQuizData(gov:QuizData, per:QuizData):void {
			initGovInfo = gov;
			initPerInfo = per;
			
			_current = null;
			parsePerInfoToDealer(null);
			
			resize(_isFullScreen);
			
			updateBottom();
		}
		
		public function set perId(value:String):void {
			if (initPerInfo && initPerInfo.id == value) {
				getPerData();
			}
		}
		
		public function set govId(value:String):void {
			if (initGovInfo && initGovInfo.id == value) {
				getGovData();
			}
		}
		
		private function onPanelClick(e:MouseEvent):void
		{
			Util.toUrl(Context.variables['url']);
			IStat(Context.getContext(ContextEnum.STAT)).stat(
				StatTypeEnum.BI, StatTypeEnum.EVENT_REDIRECT, {"action":RedirectDataAction.ACTION_QUIZ_OUT_PANEL, "click_type":RedirectDataAction.CLICK_TYPE_REDIRECTION});
		}
		
		private function getPerData(e:Object = null):void {
			_current = initPerInfo;
			if (initPerInfo) {
				_qd.getDealerByQuiz(initPerInfo.id,onGetFirstPerInfoSuccess,onGetFirstPerInfoFailed);
			}
		}
		
		private function getGovData(e:Object = null):void {
			_current = initGovInfo;
			if (initGovInfo) {
				_qd.getOfficialDealerByQuiz(initGovInfo.id,onGetFirstGovInfoSuccess,onGetFirstGovInfoFailed);
			}
		}
		
		private function onClose(e:Event):void {
			dispatchEvent(new Event("close"));
		}
		
		public function resize(isFullscreen:Boolean):void
		{
			_isFullScreen = isFullscreen;
			var w:Number = Context.getContext(ContextEnum.UI_MANAGER)["avalibleVideoWidth"];
			var h:Number = Context.getContext(ContextEnum.UI_MANAGER)["avalibleVideoHeight"];
			_h = h;
			if (_isFullScreen) {
				_w = 900;
			} else {
				_w = w;
			}
			if (_topbar) {
				var arr:Array = [];
				initGovInfo ? arr.push(initGovInfo) : null;
				initPerInfo ? arr.push(initPerInfo) : null;
				_topbar.data = arr;
				_topbar.resize(_w, _h);
			}
			if (_bottomPanel) {
				_bottomPanel.y = _topbar.height;
				_bottomPanel.resize(_w, H - _topbar.height);
			}
			_basePanel.width = _w;
		}
		
		private function onGetFirstPerInfoSuccess(info:Object):void {
			parsePerInfoToDealer(info);
			updateBottom();
		}
		
		private function parsePerInfoToDealer(info:Object):void {
			if (!initPerInfo) return;
			var l:DealerData = initPerInfo.leftDealerData ? initPerInfo.leftDealerData : new DealerData();
			var r:DealerData = initPerInfo.rightDealerData ? initPerInfo.rightDealerData : new DealerData();
			
			if (info) {
				var obj:Object = info.obj;
				obj["a"] ? l.resolveData(obj["a"]) : l.resolveData(obj["af"]);
				obj["b"] ? r.resolveData(obj["b"]) : r.resolveData(obj["bf"]);
			} else {
				l.odds = "1";
				r.odds = "1";
				l.title = initPerInfo.leftTitle;
				r.title = initPerInfo.rightTitle;
			}
			
			initPerInfo.leftDealerData = l;
			initPerInfo.rightDealerData = r;
		}
		
		private function onGetFirstGovInfoSuccess(info:Object):void {
			if (!initGovInfo) return;
			var total:Number = 0;
			for each (var item:Object in info.obj) {
				var d:DealerData = initGovInfo.getDealer(item.id);
				
				if (!d) {
					d = new DealerData();
					d.resolveData(item);
					total += d.betcount;
					initGovInfo.addDealer(d);
				} else {
					d.resolveData(item);
					total += d.betcount;
				}
			}
			for each (d in initGovInfo.dealders) {
				d.total = total;
			}
			updateBottom();
//			_bottomPanel.updateGovAndShow(info, _w, _h);
		}
		
		private function onGetFirstGovInfoFailed(info:Object):void {
			getGovData();
		}
		
		private function onGetFirstPerInfoFailed(info:Object):void {
			if ((info.hasOwnProperty("code"))&&(info["code"] == "000012")) {
				updateBottom();
//				_bottomPanel.updatePerAndShow(info,_w,_h);
			} else {
				getPerData();
			}
		}
		
		protected function updateBottom():void {
			_bottomPanel.data = _current;
			_bottomPanel.resize(_w, H - _topbar.height);
		}
		
	}
}