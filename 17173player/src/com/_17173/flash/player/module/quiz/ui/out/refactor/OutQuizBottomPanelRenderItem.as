package com._17173.flash.player.module.quiz.ui.out.refactor
{
	import com._17173.flash.core.util.Util;
	import com._17173.flash.player.module.quiz.data.DealerData;
	
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	/**
	 * 竞猜底栏条的基类
	 *  
	 * @author 庆峰
	 */	
	public class OutQuizBottomPanelRenderItem extends Sprite
	{
		
		protected var _w:int = 0;
		protected var _h:int = 0;
		
		protected var _d:DealerData = null;
		
		protected var _name:TextField = null;
		protected var _nameFormat:TextFormat = null;
		protected var _bar:OutQuizBar = null;
		protected var _barPer:Number = 1;
		protected var _barWidth:Number = 0;
		protected var _money:TextField = null;
		protected var _moneyFormat:TextFormat = null;
		protected var _rate:TextField = null;
		protected var _rateFormat:TextFormat = null;
		
		public function OutQuizBottomPanelRenderItem()
		{
			_nameFormat = initNameTextFormat();
			_name = createTF(_nameFormat);
			addChild(_name);
			
			_bar = initBar();
			addChild(_bar);
			
			_moneyFormat = initMoneyTextFormat();
			_money = createTF(_moneyFormat);
			addChild(_money);
			
			_rateFormat = initRateTextFormat();
			_rate = createTF(_rateFormat);
			addChild(_rate);
		}
		
		protected function initBar():OutQuizBar {
			return new OutQuizBar(0xABABAB, 0xEE375D, false);
		}
		
		protected function createTF(format:TextFormat):TextField {
			var tf:TextField = new TextField();
			tf.text = " ";
			tf.selectable = false;
			tf.autoSize = TextFieldAutoSize.LEFT;
			tf.defaultTextFormat = format;
			tf.setTextFormat(format);
			return tf;
		}
		
		protected function createTFFormat():TextFormat {
			var fmt:TextFormat = new TextFormat();
			fmt.font = Util.getDefaultFontNotSysFont();
			fmt.color = 0xFFFFFF;
			fmt.size = 12;
			fmt.align = TextFormatAlign.CENTER;
			return fmt;
		}
		
		protected function initNameTextFormat():TextFormat {
			var fmt:TextFormat = createTFFormat();
			return fmt;
		}
		
		protected function initMoneyTextFormat():TextFormat {
			var fmt:TextFormat = createTFFormat();
			return fmt;
		}
		
		protected function initRateTextFormat():TextFormat {
			var fmt:TextFormat = createTFFormat();
			return fmt;
		}
		
		public function set data(value:DealerData):void {
			_d = value;
			
			updateData();
		}
		
		public function resize(w:int, h:int):void {
			_w = w;
			_h = h;
			
			calcBar();
			updateBar();
			layoutItems();
		}
		
		protected function calcBar():void {
			
		}
		
		protected function updateBar():void {
			_bar.width = _barWidth;
			_bar.percent = _barPer>1?1:_barPer;
		}
		
		protected function updateData():void {
		}
		
		protected function layoutItems():void {
		}
		
	}
}