package com._17173.flash.player.module.quiz.ui.QuizControlBar
{
	import com._17173.flash.core.components.common.Button;
	import com._17173.flash.core.components.common.HGroup;
	import com._17173.flash.core.components.common.VGroup;
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.player.context.ContextEnum;
	import com._17173.flash.player.model.PlayerEvents;
	import com._17173.flash.player.module.quiz.QuizEvents;
	import com._17173.flash.player.module.quiz.data.DealerData;
	import com._17173.flash.player.module.quiz.ui.QuizMainUI;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class QuizUIOfficialBottom extends Sprite
	{
		private var _h1:HGroup;
		private var _v1:VGroup;
		private var _v2:VGroup;
		private var _item1:QuizUIOfficialBottomItem;
		private var _item2:QuizUIOfficialBottomItem;
		private var _item3:QuizUIOfficialBottomItem;
		private var _item4:QuizUIOfficialBottomItem;
		private var _line:MovieClip;
		private var _btn:Button;
		private var _data:Array;
		private var _totalMoney:Number;
		private var _odd:Number;
		
		public function QuizUIOfficialBottom()
		{
			super();
			init();
			(Context.getContext(ContextEnum.EVENT_MANAGER) as IEventManager).listen(PlayerEvents.UI_RESIZE, resize);
		}
		
		private function init():void {
			this.graphics.clear();
			this.graphics.beginFill(0, 0);
			this.graphics.drawRect(0, 0, Context.stage.stageWidth, QuizMainUI.BOTTOM_BAR_HEIGHT);
			this.graphics.endFill();
			
			_h1 = new HGroup();
			_h1.gap = 10;
			_v1 = new VGroup();
			_v1.gap = 0;
			_v2 = new VGroup();
			_v2.gap = 0;
			
			_item1 = new QuizUIOfficialBottomItem();
			_item2 = new QuizUIOfficialBottomItem();
			_item3 = new QuizUIOfficialBottomItem();
			_item4 = new QuizUIOfficialBottomItem();
			
			_v1.addChild(_item1);
			_v1.addChild(_item3);
			_v2.addChild(_item2);
			_v2.addChild(_item4);
			
			_h1.addChild(_v1);
			_h1.addChild(_v2);
			
			addChild(_h1);
			
			_line = new mc_quizOfficialPecHLine();
			addChild(_line);
			
			_btn = new Button();
			_btn.setSkin(new quizBetBig());
			_btn.width = 72;
			_btn.height = 24;
			_btn.addEventListener(MouseEvent.CLICK, btnClick);
			addChild(_btn);
			
			resize();
		}
		
		protected function btnClick(event:MouseEvent):void
		{
			(Context.getContext(ContextEnum.EVENT_MANAGER) as IEventManager).send(QuizEvents.QUZI_SHOW_OFFICIAL_QUZI_PANLE, _data);
		}
		
		public function setData(data:Array):void {
			_data = [];
			_data = data;
			_item1.visible = false;
			_item2.visible = false;
			_item3.visible = false;
			_item4.visible = false;
			_totalMoney = 0;
			for (var i:int = 0; i < _data.length; i++) {
				var item:DealerData = _data[i] as DealerData;
				_totalMoney += item.betcount;
			}
			if (_data.length > 0) {
				_item1.odds = odd;
				_item1.totalMoney = _totalMoney;
				_item1.setData(_data[0]);
				_item1.visible = true;
			}
			if (_data.length > 1) {
				_item2.odds = odd;
				_item2.totalMoney = _totalMoney;
				_item2.setData(_data[1]);
				_item2.visible = true;
			}
			if (_data.length > 2) {
				_item3.odds = odd;
				_item3.totalMoney = _totalMoney;
				_item3.setData(_data[2]);
				_item3.visible = true;
			}
			if (_data.length > 3) {
				_item4.odds = odd;
				_item4.totalMoney = _totalMoney;
				_item4.setData(_data[3]);
				_item4.visible = true;
			}
			resize();
		}
		
		private function resize(data:Object = null):void {
			if (_h1) {
				_h1.x = 8;
				if (_data && _data.length <= 2) {
					_h1.y = (QuizMainUI.BOTTOM_BAR_HEIGHT - _item1.height) / 2;
				} else {
					_h1.y = (QuizMainUI.BOTTOM_BAR_HEIGHT - _h1.height) / 2;
				}
				_v2.x = _v1.x + _v1.width + 10;
			}
			if (_line) {
				if (Context.getContext(ContextEnum.SETTING).isFullScreen) {
					_line.x = 760 - _line.width - 93;
				} else {
					_line.x = Context.stage.stageWidth - _line.width - 93;
				}
				_line.y = (this.height - _line.height) / 2;
			}
			
			if (_btn) {
				if (Context.getContext(ContextEnum.SETTING).isFullScreen) {
					_btn.x = 760 - _btn.width - 10;
				} else {
					_btn.x = Context.stage.stageWidth - _btn.width - 10;
				}
				_btn.y = (this.height - _btn.height) / 2;
			}
		}

		/**
		 * 官方抽水比率
		 */		
		public function get odd():Number
		{
			return _odd;
		}

		public function set odd(value:Number):void
		{
			_odd = value;
		}

		override public function get width():Number {
			return 742;
		}
		
		override public function get height():Number {
			return QuizMainUI.BOTTOM_BAR_HEIGHT;
		}
	}
}