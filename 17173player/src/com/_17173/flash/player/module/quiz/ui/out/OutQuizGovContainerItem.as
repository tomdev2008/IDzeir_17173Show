package com._17173.flash.player.module.quiz.ui.out
{
	import com._17173.flash.core.util.Util;
	import com._17173.flash.player.module.quiz.data.DealerData;
	
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	public class OutQuizGovContainerItem extends Sprite
	{
		
		//最多显示8个文字
		public static const moneyNum:int = 11;
		//最多显示9位数
		public static const nameNum:int = 8;
		//最多显示2位数字
		public static const oddNum:int = 6;
		
		private var _name1:TextField = new TextField();
		private var _moneyText1:TextField = new TextField();
		private var _moneyBar1:Sprite = new Sprite();
		private var _odds1:TextField = new TextField();
		private var _nameTextFormat:TextFormat = new TextFormat();
		private var _oddsTextFormat:TextFormat = new TextFormat();
		
		private var _d:DealerData = null;
		
		public function OutQuizGovContainerItem(d:DealerData, w:int)
		{
			super();
			
			_nameTextFormat = new TextFormat();
			_nameTextFormat.font = Util.getDefaultFontNotSysFont();
			_nameTextFormat.size = 12;
			//			_nameTextFormat.bold = true;
			_nameTextFormat.color = 0xffffff;
			_nameTextFormat.align=TextFormatAlign.CENTER;
			
			_oddsTextFormat = new TextFormat();
			_oddsTextFormat.font = Util.getDefaultFontNotSysFont();
			_oddsTextFormat.size = 12;
			//			_oddsTextFormat.bold = true;
			_oddsTextFormat.color = 0x7D8287;
			_oddsTextFormat.align=TextFormatAlign.CENTER;
			
			_name1.text = getLastNCharacter(d.title, nameNum);
			_name1.width = 120;
			_name1.setTextFormat(_nameTextFormat);
			addChild(_name1);
			
			_moneyBar1.graphics.beginFill(0x101E2A,1);
			_moneyBar1.graphics.drawRoundRect(x1,0,x2-x1,barHeight,5,5);//圆角矩形
			_moneyBar1.graphics.endFill();
			_moneyBar1.graphics.beginFill(0xEE375D,1);
			_moneyBar1.graphics.drawRoundRect(x1,0,(x2-x1)*(_moneyArray[0]*1.0/(_totalMoneyInt+0.01)),barHeight,5,5);//圆角矩形
			_moneyBar1.graphics.endFill();
			var barHeight:int = 10;
			_moneyBar1.graphics.beginFill(0x101E2A,1);
			var x1:int = 100;
			var x2:int = w - 160 - 100;
			_moneyBar1.graphics.drawRoundRect(x1,0,x2-x1,barHeight,5,5);//圆角矩形
			_moneyBar1.graphics.endFill();
			addChild(_moneyBar1);
			
			_moneyText1.text =  getLastNCharacter(d.betcount + d.currency == "5" ? "银币" : "金币", moneyNum);
			_moneyText1.width = 100;
			_moneyText1.setTextFormat(_nameTextFormat);
			addChild(_moneyText1);
			
			_odds1.text = ("赔率1:" + d.odds).substr(0, oddNum);
			_odds1.setTextFormat(_oddsTextFormat);
			_odds1.width = 100;
			addChild(_odds1);
		}
		
		public function set data(value:DealerData):void {
			_d = value;
		}
		
		private function getLastNCharacter(a:String,n:int):String
		{
			var b:String = a.substring((a.length - n<0)?0:(a.length-n),a.length);
			return b;
		}
	}
}