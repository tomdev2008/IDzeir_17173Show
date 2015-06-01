package com._17173.flash.player.module.quiz.ui.out
{
	import com._17173.flash.core.components.common.Button;
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.util.Util;
	import com._17173.flash.player.context.ContextEnum;
	import com._17173.flash.player.model.RedirectDataAction;
	import com._17173.flash.player.module.quiz.data.QuizData;
	import com._17173.flash.player.module.stat.IStat;
	import com._17173.flash.player.module.stat.base.StatTypeEnum;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
	/* 
	*
	* 站外竞猜UI上的tab
	*
	*/
	public class OutQuizUITopBar extends Sprite
	{
		
		private var _data:Array = [];
		
		private var _btns:Sprite = null;
		private var _moreBtn:Button = null;
		private var _closeButton:Button = null;
		private var _isGov:Array = new Array();
		
		private var _interval:int = -1;
		private var _currentBtn:Object = null;
		
		public function OutQuizUITopBar()
		{
			super();
			init();
		}
		
		public function set data(arr:Array):void {
			_data = arr;
			
			while (_btns.numChildren) {
				_btns.removeChildAt(0);
			}
			
			initBtns();
		}
		
		private function init():void {
			_btns = new Sprite();
			addChild(_btns);
			
			initBtns();
			
			_moreBtn = new Button();
			_moreBtn.setSkin(null);
			_moreBtn.label = "<font size='12'>更多</font>";
			_moreBtn.height = 22;
			_moreBtn.addEventListener(MouseEvent.CLICK, onMore);
			addChild(_moreBtn);
			
			_closeButton = new Button();
			_closeButton.setSkin(new customGuess_buttonClose());
			_closeButton.addEventListener(MouseEvent.CLICK, onCloseButtonClick);
			addChild(_closeButton);
		}
		
		protected function onMore(event:MouseEvent):void {
			IStat(Context.getContext(ContextEnum.STAT)).stat(
				StatTypeEnum.BI, StatTypeEnum.EVENT_REDIRECT, {"action":RedirectDataAction.ACTION_QUIZ_OUT_MORE, "click_type":RedirectDataAction.CLICK_TYPE_REDIRECTION});
			Util.toUrl(Context.variables["url"]);
		}
		
		private function initBtns():void {
			if (_data && _data.length) {
				for (var i:int = 0; i < _data.length; i ++) {
					var item:QuizData = _data[i];
					var btn:OutQuizUITopBarBtn = new OutQuizUITopBarBtn(item.type == 0);
					//item.type == 0 表示这个button是官方竞猜
					if (item.type == 0) {
						btn.addEventListener(MouseEvent.CLICK , onRefreshGovContainer);
					} else {
						btn.addEventListener(MouseEvent.CLICK, onRefreshPerContainer);
					}
					btn.label = formatString(item.title, item.type == 0 ? 8 : 10);
					btn.x = btn.width * i;
					_btns.addChild(btn);
				}
				
				if (_interval >= 0) {
					clearInterval(_interval);
				}
				
				_interval = setInterval(function ():void {
					clearInterval(_interval);
					_interval = -1;
					if (_btns.numChildren > 0) {
						_btns.getChildAt(0)["selected"] = true;
						_btns.getChildAt(0).dispatchEvent(new MouseEvent(MouseEvent.CLICK,false));
					}
				}, 1000);
			}
		}
		
		private function onRefreshGovContainer(event:MouseEvent):void
		{
			if (event.currentTarget == _currentBtn) return;
			if (_currentBtn) _currentBtn["selected"] = false;
			_currentBtn = event.currentTarget;
			
			this.dispatchEvent(new Event("refreshGovContainer"));
		}
		
		private function onRefreshPerContainer(event:MouseEvent):void
		{
			if (event.currentTarget == _currentBtn) return;
			if (_currentBtn) _currentBtn["selected"] = false;
			_currentBtn = event.currentTarget;
			
			this.dispatchEvent(new Event("refreshPerContainer"));
		}
		
		private function formatString(value:String, num:int = 8):String {
			if (value.length > num) {
				return value.substr(0,num);
			} else {
				return value;
			}
		}
		
		private function onCloseButtonClick(e:MouseEvent):void
		{
			IStat(Context.getContext(ContextEnum.STAT)).stat(
				StatTypeEnum.BI, StatTypeEnum.EVENT_REDIRECT, {"action":RedirectDataAction.ACTION_QUIZ_OUT_CLOSE, "click_type":RedirectDataAction.CLICK_TYPE_NORMAL});
			onClose();
		}
		
		private function onClose():void {
			dispatchEvent(new Event("close"));
		}
		
		public function resize(w:int, h:int):void {
			_moreBtn.x = _btns.width;
			_closeButton.x = w - _closeButton.width - 5;
			
			_moreBtn.y = 1;
			_closeButton.y = 3;
		}
		
	}
}