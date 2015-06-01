package com._17173.flash.player.module.quiz.ui.QuizControlBar
{
	import com._17173.flash.core.components.common.Label;
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.core.util.Util;
	import com._17173.flash.player.context.ContextEnum;
	import com._17173.flash.player.model.PlayerEvents;
	import com._17173.flash.player.module.quiz.data.DealerData;
	
	import flash.display.Sprite;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class QuizUIOfficialBottomItem extends Sprite
	{
		private var _group:Sprite;
		private var _label:Label;
		private var _prec:QuizUIOfficialPrecBar;
		private var _odd:Label;
		private var _tf:TextFormat;
		private var _w:int = 134;
		private var _h:int = 21;
		private var _data:DealerData;
		private var _totalMoney:Number;
		private var _odds:Number;
		private var _oddWidth:int = 82;
		
		public function QuizUIOfficialBottomItem()
		{
			super();
			init();
			(Context.getContext(ContextEnum.EVENT_MANAGER) as IEventManager).listen(PlayerEvents.UI_RESIZE, resize);
		}
		
		private function init():void {
			this.graphics.clear();
			this.graphics.beginFill(0, 0);
			this.graphics.drawRect(0, 0, _w, _h);
			this.graphics.endFill();
			
			initTextFormat();
			
			_group = new Sprite();
			addChild(_group);
			
			_label = new Label();
			setLabelFormat(_label);
			_label.width = 120;
			_group.addChild(_label);
			
			_prec = new QuizUIOfficialPrecBar();
			_group.addChild(_prec);
			
			_odd = new Label();
			setLabelFormat(_odd);
			_odd.width = 90;
			_group.addChild(_odd);
			
			resize();
		}
		
		public function setData(data:Object):void {
			_data = data as DealerData;
			
			_label.text = formatString(_data.title);
//			_label.text = "我们赢我们赢我们";
			if (_data.betcount == 0) {
				_odd.text = "赔率 0:0";
			} else {
				_odd.text = "赔率 1:" + getCurrentOdd(_data.betcount);
			}
			var pec:Number = 0;
			if (totalMoney == 0) {
				pec = 0;
			} else {
				pec = _data.betcount / totalMoney;
			}
//			_prec.setData(pec);
			var curr:String = _data.currency == "1" ? " 金币":" 银币";
			Context.getContext(ContextEnum.UI_MANAGER).registerTip(_prec, _data.betcount + curr);
			resize();
			_prec.setData(pec);
		}
		
		private function getCurrentOdd(value:Number):String {
			var re:Number = (_totalMoney / value) * (1 - _odds);
			if (re < 1) {
				re = 1;
			}
			
			var s:String = re.toFixed(3);
			while (true) {
				var temp:String = s.slice(s.length - 1, s.length);
				if (temp == "0" || temp == ".") {
					s = s.slice(0, s.length - 1);
				} else {
					break;
				}
			}
			return s;
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
			value.autoSize = TextFieldAutoSize.RIGHT;
			tempTF = _tf;
			value.defaultTextFormat = tempTF;
			value.setTextFormat(tempTF);
		}
		
		private function resize(data:Object = null):void {
			//（stage宽度  - 非整个条的多余宽度）/ 2  - 106(标题) - 70（赔率）
			if (Context.getContext(ContextEnum.SETTING).isFullScreen) {
				_w = (760 - 116 - 30) / 2 - 100 - _oddWidth;
			} else {
				_w = (Context.stage.stageWidth - 116 - 30) / 2 - 100 - _oddWidth;
			}
			if (_label) {
				_label.x = 100 - _label.width;
				_label.y = Math.ceil((_h - _label.height) / 2);
			}
			if (_prec) {
//				_prec.setWidth(_w);
				_prec.width = _w;
				_prec.x = _label.x + _label.width + 5;
				_prec.y = Math.ceil((_h - _prec.height) / 2);
			}
			if (_odd) {
				_odd.x = _prec.x + _prec.width + 5;
				_odd.y = Math.ceil((_h - _odd.height) / 2);
			}
			this.graphics.clear();
			this.graphics.beginFill(0, 0);
			this.graphics.drawRect(0, 0, (100 + 10 + _w + 5 + _oddWidth), _h);
		}
		
		private function formatString(value:String):String {
			if (value.length > 8) {
				return value.substr(0, 8);
			} else {
				return value;
			}
		}

		public function get totalMoney():Number
		{
			return _totalMoney;
		}

		public function set totalMoney(value:Number):void
		{
			_totalMoney = value;
		}

		public function get odds():Number
		{
			return _odds;
		}

		public function set odds(value:Number):void
		{
			_odds = value;
		}

//		override public function get width():Number {
//			return 120 + 10 + _w + 5 + 90;
//		}
		
	}
}