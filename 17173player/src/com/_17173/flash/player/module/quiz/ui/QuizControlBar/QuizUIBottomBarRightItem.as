package com._17173.flash.player.module.quiz.ui.QuizControlBar
{
	import com._17173.flash.core.components.common.Button;
	import com._17173.flash.core.components.common.Label;
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.core.util.Util;
	import com._17173.flash.player.context.ContextEnum;
	import com._17173.flash.player.module.quiz.QuizEvents;
	import com._17173.flash.player.module.quiz.data.DealerData;
	import com._17173.flash.player.module.quiz.ui.QuizTextBG;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class QuizUIBottomBarRightItem extends Sprite
	{
		private var _startQuizBtn:Button;
		private var _betCon:Sprite;
		private var _betBtn:Button;
		private var _odds:Label;
		private var _oddBG:QuizTextBG;
		private var _titleLine:Sprite;
		private var _tf:TextFormat;
		private var _title:Label;
		private var _money:Label;
		private var _perLine:QuizPercentBar;
		private var _data:DealerData;
		private var _w:int = 340;
		private var _h:int = 38;
		private var _e:IEventManager;
		
		public function QuizUIBottomBarRightItem()
		{
			super();
			initTextFormat();
			init();
		}
		
		public function setData(data:Object, currency:String = "1"):void {
			if (data is String) {
				_money.text = "0" + (currency == "5" ? "银币" : "金币");
				_startQuizBtn.visible = true;
				_betCon.visible = false;
				_title.text = data as String;
				_perLine.setData(1);
			} else {
				_data = new DealerData();
				_data.resolveData(data);
				
				_money.text = _data.betcount + (_data.currency == "5" ? "银币" : "金币");
				_title.text = _data.title ? _data.title : "";
				_odds.text = "1:" + _data.odds;
				//庄可投注数目
				var canBetCount:Number = (_data.premium) / Number(_data.odds);
				//剩余可投入
				var surplus:Number = canBetCount - _data.betcount;
				if(surplus <= 0) {
					if (_betBtn) {
						_betBtn.disabled = true;
					}
				} else {
					if (_betBtn) {
						_betBtn.disabled = false;
					}
				}
				_perLine.setData(_data.betcount / canBetCount);
//				_perLine.setData(0.2);
				resizOdd();
				_startQuizBtn.visible = false;
				_betCon.visible = true;
			}
			
			resize();
		}
		
		public function setDealerFull():void {
			_betCon.visible = true;
			_odds.text = "已满";
			_betBtn.disabled = true;
			_perLine.setData(1);
			resizOdd();
		}
		
		private function init():void {
			_e = Context.getContext(ContextEnum.EVENT_MANAGER) as IEventManager;
			initLeft();
			initRight();
		}
		
		private function initLeft():void {
			_startQuizBtn = new Button();
			_startQuizBtn.setSkin(new quizStartBig());
			_startQuizBtn.width = 72;
			_startQuizBtn.height = 24;
			_startQuizBtn.addEventListener(MouseEvent.CLICK, showStartDealer);
			addChild(_startQuizBtn);
			
			_betCon = new Sprite();
			_betBtn = new Button();
			_betBtn.setSkin(new quizBetBlue());
			_betBtn.width = 43;
			_betBtn.height = 25;
			_betBtn.addEventListener(MouseEvent.CLICK, showBetPanel);
			_betCon.addChild(_betBtn);
			
			_odds = new Label();
			setLabelFormat(_odds);
			_odds.width = 40;
			_oddBG = new QuizTextBG(30, 25);
			_oddBG.buttonMode = true;
			_oddBG.mouseChildren = false;
			_oddBG.mouseEnabled = true;
			_oddBG.addEventListener(MouseEvent.CLICK, showStartDealer);
			_oddBG.addItem(_odds);
			Context.getContext(ContextEnum.UI_MANAGER).registerTip(_oddBG,"我要抢庄!");
			resizOdd();
			_betCon.addChild(_oddBG);
			
			addChild(_betCon);
		}
		
		/**
		 * 派发投注界面
		 */		
		protected function showBetPanel(event:MouseEvent):void
		{
			_e.send(QuizEvents.QUZI_SHOW_BET_PANEL, _data);
		}
		
		/**
		 * 派发显示上庄界面
		 */		
		protected function showStartDealer(event:MouseEvent):void
		{
			_e.send(QuizEvents.QUIZ_SHOW_START_DEALER);
		}
		
		private function resizOdd():void {
			if (_odds.width >= 30) {
				_odds.x = 0;
			} else {
				_odds.x = (30 - _odds.width) / 2;
			}
			_odds.y = 1;
		}
		
		private function initRight():void {
			_titleLine = new Sprite();
			_titleLine.graphics.clear();
			_titleLine.graphics.beginFill(0, 0);
			_titleLine.graphics.drawRect(0, 0, 258, 20);
			_titleLine.graphics.endFill();
			
			_money = new Label();
			_money.width = 100;
			_titleLine.addChild(_money);
			
			_title = new Label();
			_title.width = 158;
			_titleLine.addChild(_title);
			addChild(_titleLine);
			
			_perLine = new QuizPercentBar(1);
			addChild(_perLine);
		}
		
		private function initTextFormat():void {
			_tf = new TextFormat();
			_tf.size = 12;
			_tf.color = 0x888888;
			_tf.font = Util.getDefaultFontNotSysFont();
		}
		
		/**
		 * 格式化label
		 */		
		private function setLabelFormat(value:Label):void {
			var tempTF:TextFormat;
			value.selectable = false;
			value.autoSize = TextFieldAutoSize.LEFT;
			tempTF = _tf;
			value.defaultTextFormat = tempTF;
			value.setTextFormat(tempTF);
		}
		
		public function resize():void {
			this.graphics.clear();
			this.graphics.beginFill(0,0);
			this.graphics.drawRect(0, 0, _w, _h);
			this.graphics.endFill();
			
			if (_startQuizBtn) {
				_startQuizBtn.x = 258 + 10;
				_startQuizBtn.y = (_h - _startQuizBtn.height) / 2 + 5;
			}
			if (_betCon) {
				var item:DisplayObject;
				var temp:int = 0;
				for (var i:int = 0; i < _betCon.numChildren; i++) {
					item = _betCon.getChildAt(i);
					item.x = temp;
					item.y = 0;
					temp = item.x + item.width;
				}
				
				_betCon.x = 258 + 10;
				_betCon.y = _h - 28;
			}
			if (_titleLine) {
				_money.x = 250 - _money.width;
				_title.x = 0;
				_titleLine.x = 0;
				_titleLine.y = 0;
			}
			if (_perLine) {
				_perLine.x = 0;
				_perLine.y = _titleLine.height - 2;
			}
		}
		
	}
}