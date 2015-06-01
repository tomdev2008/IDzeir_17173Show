package com._17173.flash.player.module.quiz.ui.out
{
	import com._17173.flash.core.components.common.Button;
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.util.Util;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	
	
	/**
	 * 个人竞猜显示类
	 */
	public class OutQuizGovContainer extends Sprite
	{
		protected var container:Sprite = new Sprite();
		/**
		 * 个人竞猜需要的各种控件
		 */
		private var _name1:TextField = new TextField();
		private var _name2:TextField = new TextField();
		private var _name3:TextField = new TextField();
		private var _name4:TextField = new TextField();
		private var _moneyText1:TextField = new TextField();
		private var _moneyText2:TextField = new TextField();
		private var _moneyText3:TextField = new TextField();
		private var _moneyText4:TextField = new TextField();
		private var _moneyBar1:Sprite = new Sprite();
		private var _moneyBar2:Sprite = new Sprite();
		private var _moneyBar3:Sprite = new Sprite();
		private var _moneyBar4:Sprite = new Sprite();
		private var _odds1:TextField = new TextField();
		private var _odds2:TextField = new TextField();
		private var _odds3:TextField = new TextField();
		private var _odds4:TextField = new TextField();
		private var _voteButton:Button = null;
		
		private var _moneyArray:Array = new Array();
		private var _nameTextFormat:TextFormat = new TextFormat();
		private var _oddsTextFormat:TextFormat = new TextFormat();
		/**
		 * 工具条需要的各种数据
		 */
		private var _leftMoneyInt:int = 0;
		private var _rightMoneyInt:int = 0;
		private var _totalMoneyInt:int = 0;
		private var _itemNumber:int = 0;
		private var _waterRate:Number = 0;
		
		private var _w:int = 0;
		private var _h:int = 0;
		
		public function OutQuizGovContainer(info:Object,w:int,h:int)
		{
			super();
			_w = w;
			_h = h;
			/**
			 * 解析数据信息
			 */
			init(info);
			resize(w,h);
		}
		
		public function init(info:Object):void
		{
			_itemNumber = (info['obj'] as Array).length;
			for (var i:int=0;i<_itemNumber;i++)
			{
				_moneyArray[i] = Number(info['obj'][i]['totalMoney']);
			}
			_totalMoneyInt = 0;
			for (i=0;i<_itemNumber;i++)
			{
				_totalMoneyInt += Number(info['obj'][i]['totalMoney']);
			}
			waterrate = 0.1;
			_moneyBar1.visible = false;
			_name1.visible = false;
			_odds1.visible = false;
			_moneyText1.visible = false;
			
			_moneyBar2.visible = false;
			_name2.visible = false;
			_odds2.visible = false;
			_moneyText2.visible = false;
			
			_moneyBar3.visible = false;
			_name3.visible = false;
			_odds3.visible = false;
			_moneyText3.visible = false;
			
			_moneyBar4.visible = false;
			_name4.visible = false;
			_odds4.visible = false;
			_moneyText4.visible = false;
			
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
			
			//最多显示9位数
			var moneyNum:int = 11;
			//最多显示6个文字
			var nameNum:int = 6;
			//最多显示2位数字
			var oddNum:int = 6;
			
			if (_itemNumber > 0)
			{
				_moneyBar1.visible = true;
				_name1.visible = true;
				_odds1.visible = true;
				_moneyText1.visible = true;
				
				_moneyText1.text =  getLastNCharacter( 
					info['obj'][0]['totalMoney'] + ((info['obj'][0]['currency']=="5")?"银币":"金币")
						, moneyNum);
				_moneyText1.width = 100;
				_moneyText1.setTextFormat(_nameTextFormat);
				addChild(_moneyText1);
				
				_name1.text = getLastNCharacter(info['obj'][0]['name'],nameNum);
				_name1.width = 120;
				_name1.setTextFormat(_nameTextFormat);
				addChild(_name1);
				
				_odds1.text = ("赔率1:" + info['obj'][0]['odds']).substr(0,oddNum);
				_odds1.setTextFormat(_oddsTextFormat);
				_odds1.width = 100;
				addChild(_odds1);
			}
			if (_itemNumber > 1)
			{
				_moneyBar2.visible = true;
				_name2.visible = true;
				_odds2.visible = true;
				_moneyText2.visible = true;
				
				_moneyText2.text =  getLastNCharacter( 
					info['obj'][1]['totalMoney'] + ((info['obj'][1]['currency']=="5")?"银币":"金币")
						, moneyNum);
				_moneyText2.width = 100;
				_moneyText2.setTextFormat(_nameTextFormat);
				addChild(_moneyText2);
				
				_name2.text = getLastNCharacter(info['obj'][1]['name'],nameNum);
				_name2.width = 120;
				_name2.setTextFormat(_nameTextFormat);
				addChild(_name2);
				
				_odds2.text =("赔率1:" + info['obj'][1]['odds']).substr(0,oddNum);
				_odds2.setTextFormat(_oddsTextFormat);
				_odds2.width = 100;
				addChild(_odds2);
			}
			if (_itemNumber > 2)
			{
				_moneyBar3.visible = true;
				_name3.visible = true;
				_odds3.visible = true;
				_moneyText3.visible = true;
				
				_moneyText3.text = getLastNCharacter( 
					info['obj'][2]['totalMoney'] + ((info['obj'][2]['currency']=="5")?"银币":"金币")
					, moneyNum);
				_moneyText3.width = 100;
				_moneyText3.setTextFormat(_nameTextFormat);
				addChild(_moneyText3);
				
				_name3.text = getLastNCharacter( info['obj'][2]['name'] , nameNum);
				_name3.width = 120;
				_name3.setTextFormat(_nameTextFormat);
				addChild(_name3);
				
				_odds3.text = ("赔率1:" + info['obj'][2]['odds']).substr(0,oddNum);
				_odds3.setTextFormat(_oddsTextFormat);
				_odds3.width = 100;
				addChild(_odds3);
			}
			if (_itemNumber > 3)
			{
				_moneyBar4.visible = true;
				_name4.visible = true;
				_odds4.visible = true;
				_moneyText4.visible = true;
				
				_moneyText4.text = getLastNCharacter( 
					info['obj'][3]['totalMoney'] + ((info['obj'][3]['currency']=="5")?"银币":"金币")
						, moneyNum);
				_moneyText4.width = 100;
				_moneyText4.setTextFormat(_nameTextFormat);
				addChild(_moneyText4);
				
				_name4.text = getLastNCharacter(info['obj'][3]['name'],nameNum);
				_name4.width = 100;
				_name4.setTextFormat(_nameTextFormat);
				addChild(_name4);
				
				_odds4.text = ("赔率1:" + info['obj'][3]['odds']).substr(0,oddNum);
				_odds4.setTextFormat(_oddsTextFormat);
				_odds4.width = 100;
				addChild(_odds4);
			}

			_voteButton = new Button();
			_voteButton.setSkin(new customGuess_vote());
			addChild(_voteButton);
			_voteButton.addEventListener(MouseEvent.CLICK, onButtonClick);
			//_money4 = info['obj'][3]['totalMoney'];
			//两种文字格式
			var barHeight:int = 10;
			_moneyBar1.graphics.beginFill(0x101E2A,1);
			var x1:int = 100;
			var x2:int = _w - 160 - 100;
			_moneyBar1.graphics.drawRoundRect(x1,0,x2-x1,barHeight,5,5);//圆角矩形
			_moneyBar1.graphics.endFill();
			addChild(_moneyBar1);
			_moneyBar2.graphics.beginFill(0x101E2A,1);
			_moneyBar2.graphics.drawRoundRect(x1,0,x2-x1,barHeight,5,5);//圆角矩形
			_moneyBar2.graphics.endFill();
			addChild(_moneyBar2);
			_moneyBar3.graphics.beginFill(0x101E2A,1);
			_moneyBar3.graphics.drawRoundRect(x1,0,x2-x1,barHeight,5,5);//圆角矩形
			_moneyBar3.graphics.endFill();
			addChild(_moneyBar3);
			_moneyBar4.graphics.beginFill(0x101E2A,1);
			_moneyBar4.graphics.drawRoundRect(x1,0,x2-x1,barHeight,5,5);//圆角矩形
			_moneyBar4.graphics.endFill();
			addChild(_moneyBar4);
			
			refreshMoneyBar();
			resize(_w,_h);
			//money1 = _moneyArray[0];
		}
		
		private function getLastNCharacter(a:String,n:int):String
		{
			var b:String = a.substring((a.length - n<0)?0:(a.length-n),a.length);
			return b;
		}
		private function onButtonClick(e:MouseEvent):void
		{
			Util.toUrl(Context.variables['url']);
//			try{
//				navigateToURL(new URLRequest("http://www.17173.com/"));
//			}catch(e:Error){
//				trace("Error occurred!");
//			}
		}
		
		public function set waterrate(value:Number):void
		{
			_waterRate = value;
		}
		
		public function set money1(num:int):void
		{
			_moneyArray[0] = num;
			_totalMoneyInt = 0;
			for (var i:int=0;i<_itemNumber;i++)
			{
				_totalMoneyInt += _moneyArray[i];
			}
			refreshMoneyBar();
		}
		private function refreshMoneyBar():void
		{
			/**
			 * 画背景色
			 */
			var barHeight:int = 10;
			var x1:int = 100;
			var x2:int = _w - 160 - 100;
			if (_itemNumber > 0)
			{
				_moneyBar1.graphics.beginFill(0x101E2A,1);
				_moneyBar1.graphics.drawRoundRect(x1,0,x2-x1,barHeight,5,5);//圆角矩形
				_moneyBar1.graphics.endFill();
				_moneyBar1.graphics.beginFill(0xEE375D,1);
				_moneyBar1.graphics.drawRoundRect(x1,0,(x2-x1)*(_moneyArray[0]*1.0/(_totalMoneyInt+0.01)),barHeight,5,5);//圆角矩形
				_moneyBar1.graphics.endFill();
			}
			if (_itemNumber > 1)
			{
				_moneyBar2.graphics.beginFill(0x101E2A,1);
				_moneyBar2.graphics.drawRoundRect(x1,0,x2-x1,barHeight,5,5);//圆角矩形
				_moneyBar2.graphics.endFill();
				_moneyBar2.graphics.beginFill(0xEE375D,1);
				_moneyBar2.graphics.drawRoundRect(x1,0,(x2-x1)*(_moneyArray[1]*1.0/(_totalMoneyInt+0.01)),barHeight,5,5);//圆角矩形
				_moneyBar2.graphics.endFill();
			}
			if (_itemNumber > 2)
			{
				_moneyBar3.graphics.beginFill(0x101E2A,1);
				_moneyBar3.graphics.drawRoundRect(x1,0,x2-x1,barHeight,5,5);//圆角矩形
				_moneyBar3.graphics.endFill();
				_moneyBar3.graphics.beginFill(0xEE375D,1);
				_moneyBar3.graphics.drawRoundRect(x1,0,(x2-x1)*(_moneyArray[2]*1.0/(_totalMoneyInt+0.01)),barHeight,5,5);//圆角矩形
				_moneyBar3.graphics.endFill();
			}
			if (_itemNumber > 3)
			{
				_moneyBar4.graphics.beginFill(0x101E2A,1);
				_moneyBar4.graphics.drawRoundRect(x1,0,x2-x1,barHeight,5,5);//圆角矩形
				_moneyBar4.graphics.endFill();
				_moneyBar4.graphics.beginFill(0xEE375D,1);
				_moneyBar4.graphics.drawRoundRect(x1,0,(x2-x1)*(_moneyArray[3]*1.0/(_totalMoneyInt+0.01)),barHeight,5,5);//圆角矩形
				_moneyBar4.graphics.endFill();
			}
		}
		/**
		 * resize逻辑
		 */
		public function resize(w:int,h:int):void
		{
			_w = w; _h = h;
			var startY:int = 5;
			var step:int = 18;
			var moneyTextOffset:int = 0;
			_name1.x = 0; _name1.y = startY;
			_name2.x = 0; _name2.y = startY + step;
			_name3.x = 0; _name3.y = startY + step*2;
			_name4.x = 0; _name4.y = startY + step*3;
			
			_moneyText1.x = _w - 260; _moneyText1.y = startY + moneyTextOffset ;
			_moneyText2.x = _w - 260; _moneyText2.y = startY + step+ moneyTextOffset ;
			_moneyText3.x = _w - 260; _moneyText3.y = startY + step*2 + moneyTextOffset ;
			_moneyText4.x = _w - 260; _moneyText4.y = startY + step*3 + moneyTextOffset ;
			
			var _moneyBarOffset:int = 6;
			_moneyBar1.x = 0; _moneyBar1.y = startY +_moneyBarOffset;
			_moneyBar2.x = 0; _moneyBar2.y = startY + step +_moneyBarOffset;
			_moneyBar3.x = 0; _moneyBar3.y =  startY + step*2 +_moneyBarOffset;
			_moneyBar4.x = 0; _moneyBar4.y = startY + step*3 +_moneyBarOffset;
			
			var _oddsOffset:int = 0;
			_odds1.x = _w - 160; _odds1.y = startY + _oddsOffset;
			_odds2.x = _w - 160; _odds2.y = startY + step + _oddsOffset;
			_odds3.x = _w - 160; _odds3.y =  startY + step*2 + _oddsOffset;
			_odds4.x = _w - 160; _odds4.y = startY + step*3 + _oddsOffset;	
			
			_voteButton.x = _w - 60; _voteButton.y = startY + step;
			
			refreshMoneyBar();
		}
		/**
		 * 添加时间监听
		 */
		public function update(info:Object):void
		{
			
		}
//		private function addListen():void {
//			_e.listen(QuizEvents.QUIZ_CURRENT_SELECTE_CHANGE, getDealer);
//			_e.listen(QuizEvents.QUZI_SETTLE_ACCOUNT, quizSettle);
//			_e.listen(QuizEvents.QUIZ_PULL_DEALER_DATA, dealerStateChange);
//			_e.listen(PlayerEvents.UI_RESIZE, resize);
//		}
//		/**
//		 * 这里写调整布局的代码
//		 */
//		private function resize():void
//		{
//			var w:Number = (Context.getContext(ContextEnum.UI_MANAGER) as UIManager).avalibleVideoWidth;
//			var h:Number =  (Context.getContext(ContextEnum.UI_MANAGER) as UIManager).avalibleVideoHeight;
//			
//			var tempx:Number = 0; var tempy:Number = 0;
//			tempx = (w/2 - _vs.width/2);
//			_vs.x = tempx; _vs.y = 50;
//			
//			_leftVote.x = 20; _leftVote.y = 50;
//			_rightVote.x = w - 20 - _rightVote.width; _rightVote.y = 50; 
//			
//			_leftName.x = w/2 - 100; _leftName.y = 20;
//			_rightName.x = w/2; _rightName.y = 20;
//			
//			_leftMoney.x = w/2 - 200; _leftMoney.y = 20;
//			_rightMoney.x = w/2 + 100; _rightMoney.y = 20;
//			
//			leftMoney = 100;
//			rightMoney = 100;
//		}
//		
//		private function onVoteClick(e:MouseEvent):void
//		{
//			try{
//				navigateToURL(new URLRequest("http://www.17173.com/"));
//			}catch(e:Error){
//				trace("Error occurred!");
//			}
//		}
//		
//		public function set leftMoney(num:int):void
//		{
//			var w:Number = (Context.getContext(ContextEnum.UI_MANAGER) as UIManager).avalibleVideoWidth;
//			_leftMoneyBar.graphics.beginFill(0x101E2A,1);
//			var x1:int = 80;
//			var x2:int = w/2 - 20;
//			_leftMoneyBar.graphics.drawRoundRect(x1,45,x2-x1,20,5,5);//圆角矩形
//			_leftMoneyBar.graphics.endFill();
//			
//			_rightMoneyBar.graphics.beginFill(0x101E2A,1);
//			x1 = w/2 + 20;
//			x2 = w - 80;
//			_rightMoneyBar.graphics.drawRoundRect(x1,45,x2-x1,20,5,5);//圆角矩形
//			_rightMoneyBar.graphics.endFill();
//			
//			_leftMoneyInt = num;
//			_totalMoneyInt = _leftMoneyInt + _rightMoneyInt;
//			
//			_leftMoney.text = num.toString(10) +" 金币";
//			_leftMoney.setTextFormat(_leftTextFormat);
//			
//			_leftMoneyBar.graphics.beginFill(0xEE375D,1);
//			var x1:int = 80;
//			var x2:int = 80 + (w-200)/2*(_leftMoneyInt/(_leftMoneyInt+_rightMoneyInt));
//			_leftMoneyBar.graphics.drawRoundRect(x1,45,x2-x1,20,5,5);//圆角矩形
//			_leftMoneyBar.graphics.endFill();
//			
//			_totalMoneyInt = _leftMoneyInt + _rightMoneyInt;
//			
//			_rightMoney.text = _rightMoneyInt.toString(10) +" 金币";
//			_rightMoney.setTextFormat(_rightTextFormat);
//			
//			_rightMoneyBar.graphics.beginFill(0x5CACEE,1);
//			var x1:int = w/2+20;
//			var x2:int = w/2+20+(w-200)/2*(_rightMoneyInt/(_leftMoneyInt+_rightMoneyInt));
//			_rightMoneyBar.graphics.drawRoundRect(x1,45,x2-x1,20,5,5);//圆角矩形
//			_rightMoneyBar.graphics.endFill();
//		}
//		
//		public function set rightMoney(num:int):void
//		{
//			var w:Number = (Context.getContext(ContextEnum.UI_MANAGER) as UIManager).avalibleVideoWidth;
//			_leftMoneyBar =new Sprite();
//			_leftMoneyBar.graphics.beginFill(0x101E2A,1);
//			var x1:int = 80;
//			var x2:int = w/2 - 20;
//			_leftMoneyBar.graphics.drawRoundRect(x1,45,x2-x1,20,5,5);//圆角矩形
//			_leftMoneyBar.graphics.endFill();
//			addChild(_leftMoneyBar);
//			
//			_rightMoneyBar =new Sprite();
//			_rightMoneyBar.graphics.beginFill(0x101E2A,1);
//			x1 = w/2 + 20;
//			x2 = w - 80;
//			_rightMoneyBar.graphics.drawRoundRect(x1,45,x2-x1,20,5,5);//圆角矩形
//			_rightMoneyBar.graphics.endFill();
//			addChild(_rightMoneyBar);
//			
//			_rightMoneyInt = num;
//			_totalMoneyInt = _leftMoneyInt + _rightMoneyInt;
//			
//			_rightMoney.text = num.toString(10) +" 金币";
//			_rightMoney.setTextFormat(_rightTextFormat);
//			
//			_rightMoneyBar.graphics.beginFill(0x5CACEE,1);
//			var x1:int = w/2+20;
//			var x2:int = w/2+20+(w-200)/2*(_rightMoneyInt/(_leftMoneyInt+_rightMoneyInt));
//			_rightMoneyBar.graphics.drawRoundRect(x1,45,x2-x1,20,5,5);//圆角矩形
//			_rightMoneyBar.graphics.endFill();
//			
//			_leftMoney.text = _leftMoneyInt.toString(10) +" 金币";
//			_leftMoney.setTextFormat(_leftTextFormat);
//			
//			_leftMoneyBar.graphics.beginFill(0xEE375D,1);
//			var x1:int = 80;
//			var x2:int = 80 + (w-200)/2*(_leftMoneyInt/(_leftMoneyInt+_rightMoneyInt));
//			_leftMoneyBar.graphics.drawRoundRect(x1,45,x2-x1,20,5,5);//圆角矩形
//			_leftMoneyBar.graphics.endFill();
//		}
//		
//		public function set leftName(name:String):void
//		{
//			_leftName.text = name;
//			_leftName.setTextFormat(_leftTextFormat);
//		}
//		
//		public function set rightName(name:String):void
//		{
//			_rightName.text = name;
//			_rightName.setTextFormat(_rightTextFormat);
//		}

		
		public function set topic(a:String):void
		{
			
		}
	}
}

