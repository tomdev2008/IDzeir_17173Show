package com._17173.flash.player.module.quiz.ui.out
{
	import com._17173.flash.core.components.common.Button;
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.util.Util;
	import com._17173.flash.player.module.quiz.QuizDataRetriver;
	import com._17173.flash.player.module.quiz.data.DealerData;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	

	
	/**
	 * 个人竞猜显示类
	 */
	public class OutQuizPerContainer extends Sprite
	{
		protected var container:Sprite = new Sprite();
		/**
		 * 个人竞猜需要的各种控件
		 */
		private var _vs:MovieClip = null;
		private var _leftVote:Button = null;
		private var _rightVote:Button = null;
		private var _leftMoney:TextField = new TextField();
		private var _rightMoney:TextField = new TextField();
		private var _leftName:TextField = new TextField();
		private var _rightName:TextField = new TextField();
		private var _leftMoneyBar:Sprite = new Sprite();
		private var _rightMoneyBar:Sprite = new Sprite();
		private var _leftOdd:TextField = new TextField();
		private var _rightOdd:TextField = new TextField();
		private var _info:Object = new Object();
		
		private var _leftTextFormat:TextFormat = new TextFormat();
		private var _rightTextFormat:TextFormat = new TextFormat();
		private var _oddsTextFormat:TextFormat = new TextFormat();
		private var _currentId:int = -1;
		private var _qd:QuizDataRetriver;
		private var _isFullscreen:Boolean;
		/**
		 * 工具条需要的各种数据
		 */
		private var _leftMoneyInt:int = 0;
		private var _rightMoneyInt:int = 0;
		private var _totalMoneyInt:int = 0;
		private var _w:int = 0;
		private var _h:int = 0;
		//info example
		//{"code":"000000|000001","msg":"失败原因（告知)","a":{"dealerid":"庄ID","userId":"庄创建者ID","odds":"比率","betcount":"投注额度","odds":"赔率","premium":"上庄底金"},"b":{"dealerid":"庄ID","userId":"庄创建者ID","odds":"比率","betcount":"投注额度","odds":"赔率","premium":"上庄底金"}}
		public function OutQuizPerContainer(info:Object,w:int,h:int)
		{
			super();
			_info = info;
			_vs = new customGuess_vs();
			_vs.x = 0; _vs.y = 0;
			addChild(_vs);
			_w = w; _h = h;
			
			_leftVote = new Button();
			_leftVote.setSkin(new customGuess_leftVote());
			_rightVote = new Button();
			_rightVote.setSkin(new customGuess_rightVote());
			_leftVote.addEventListener(MouseEvent.CLICK, onButtonClick);
			_rightVote.addEventListener(MouseEvent.CLICK, onButtonClick);
			_leftVote.mouseChildren = false;
			_rightVote.mouseChildren = false;
			addChild(_leftVote);
			addChild(_rightVote);
			//两种文字格式
			_leftTextFormat = new TextFormat();
			_leftTextFormat.font = Util.getDefaultFontNotSysFont();
			_leftTextFormat.size = 15;
//			_leftTextFormat.bold = true;
			_leftTextFormat.color = 0xEE375D;
			_leftTextFormat.align=TextFormatAlign.CENTER;
			
			_oddsTextFormat = new TextFormat();
			_oddsTextFormat.font = Util.getDefaultFontNotSysFont();
			_oddsTextFormat.size = 12;
			_oddsTextFormat.color = 0xffffff;
			_oddsTextFormat.align=TextFormatAlign.CENTER;
			
			_rightTextFormat = new TextFormat();
			_rightTextFormat.font = Util.getDefaultFontNotSysFont();
			_rightTextFormat.size = 15;
//			_rightTextFormat.bold = true;
			_rightTextFormat.color = 0x5CACEE;
			_rightTextFormat.align=TextFormatAlign.CENTER;
			
			_leftName.text = objHasKeys(info,['a','dealerid'])?info['a']['dealerid']:'缺失';
			_leftName.setTextFormat(_leftTextFormat);
			_leftName.width = 100;
			addChild(_leftName);
			_rightName.text =  objHasKeys(info,['b','dealerid'])?info['b']['dealerid']:"缺失";
			_rightName.width = 100;
			_rightName.setTextFormat(_rightTextFormat);
			addChild(_rightName);
			
			_leftMoney.text = "金币";
			_leftMoney.setTextFormat(_leftTextFormat);
			_leftMoney.width = 100;
			addChild(_leftMoney);
			_rightMoney.text = "金币";
			_rightMoney.setTextFormat(_rightTextFormat);
			_rightMoney.width = 100;
			addChild(_rightMoney);
			
			_leftMoneyBar.graphics.beginFill(0x101E2A,1);
			var x1:int = 100;
			var x2:int = _w/2 - 20;
			_leftMoneyBar.graphics.drawRoundRect(x1,45,x2-x1,20,5,5);//圆角矩形
			_leftMoneyBar.graphics.endFill();
			addChild(_leftMoneyBar);
			
			_rightMoneyBar.graphics.beginFill(0x101E2A,1);
			x1 = _w/2 + 20;
			x2 = _w - 100;
			_rightMoneyBar.graphics.drawRoundRect(x1,45,x2-x1,20,5,5);//圆角矩形
			_rightMoneyBar.graphics.endFill();
			addChild(_rightMoneyBar);
			
			_leftOdd.width = 40;
			_rightOdd.width = 40;
			addChild(_leftOdd);
			addChild(_rightOdd);
			
			update(info);
			/**
			 * 数据初始化
			 */
			resize(_w,_h);
		}
		
		
		private function objHasKeys(a:Object,keyArray:Array):Boolean
		{
			var obj:Object = new Object();
			obj = a;
			for (var i:int=0; i<keyArray.length;i++)
			{
				if (!obj.hasOwnProperty(keyArray[i]))
				{
					return false;
				}
				obj = obj[keyArray[i]];
			}
			return true;
		}
		public function update(infoObject:Object):void
		{
			var info:Object = infoObject;
			if (infoObject.hasOwnProperty('obj')) info = infoObject['obj'];
			else info = infoObject;
			if (info == null) return;
			leftName = objHasKeys(info,['a','dealerid'])?info['a']['dealerid']:"无人上庄";
			leftOdd = ((objHasKeys(info,['a','betcount'])) && (int(info['a']['betcount'])!=0) &&(objHasKeys(info,['a','odds'])) )?("1:"+info['a']['odds']):("0:0");
			leftMoney = objHasKeys(info,['a','betcount'])?Number(info['a']['betcount']):0;
			
			rightName = objHasKeys(info,['b','dealerid'])?info['b']['dealerid']:"无人上庄";
			rightOdd = ((objHasKeys(info,['b','betcount'])) && (int(info['b']['betcount'])!=0) && (objHasKeys(info,['b','odds'])) )?("1:"+info['b']['odds']):("0:0");
			rightMoney =  objHasKeys(info,['b','betcount'])?Number(info['b']['betcount']):0;
		}
		/**
		 * 这里写调整布局的代码
		 */
		public function resize(w:int,h:int):void
		{
			_w = w; _h = h;
			
//			update(_info);
			
			var tempx:Number = 0; var tempy:Number = 0;
			tempx = (_w/2 - _vs.width/2);
			_vs.x = tempx; _vs.y = 50;
			
			_leftVote.x = 20; _leftVote.y = 50;
			_rightVote.x = _w - 20 - _rightVote.width; _rightVote.y = 50; 
			
			_leftName.x = _w/2 - 100; _leftName.y = 20;
			_rightName.x = _w/2; _rightName.y = 20;
			
			_leftMoney.x = 80; _leftMoney.y = 20;
			_rightMoney.x = w - 80 - _rightMoney.width; _rightMoney.y = 20;
			
			_leftOdd.x = 60; _leftOdd.y = 50;
			_rightOdd.x = _w - 60 - _rightOdd.width; _rightOdd.y = 50;
			
			var _leftMoneytext:String = "";
			var _leftNametext:String = "";
			var _leftOddtext:String = "";
			var _rightMoneytext:String = "";
			var _rightNametext:String = "";
			var _rightOddtext:String = "";
			var moneyNum:int = 0;
			var nameNum:int = 0;
			var oddNum:int = 0
			if (_w > 440)
			{
				nameNum = 6;
				moneyNum = 11;
				oddNum = 4;
				_leftMoneytext = _leftMoney.text.substring((_leftMoney.text.length - 10<0)?0:_leftMoney.text.length-10, _leftMoney.text.length);//:String_leftMoney.text
				_rightMoneytext = _rightMoney.text.substring((_rightMoney.text.length - 10<0)?0:_rightMoney.text.length-10, _rightMoney.text.length);
				_leftNametext = _leftName.text.substring((_leftName.text.length - 10<0)?0:_leftName.text.length-10, _leftName.text.length);
				_rightNametext = _rightName.text.substring((_rightName.text.length - 10<0)?0:_rightName.text.length-10, _rightName.text.length);
				_leftOddtext = _leftOdd.text.substring((_leftOdd.text.length - 10<0)?0:_leftOdd.text.length-10, _leftOdd.text.length);
				_rightOddtext = _rightOdd.text.substring((_rightOdd.text.length - 10<0)?0:_rightOdd.text.length-10, _rightOdd.text.length);
			}
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
		
		public function set leftMoney(num:int):void
		{
			if (_leftMoneyBar)
			{
				if (_leftMoneyBar.parent)
				{
					_leftMoneyBar.parent.removeChild(_leftMoneyBar);
				}
			}
			if (_rightMoneyBar)
			{
				if (_rightMoneyBar.parent)
				{
					_rightMoneyBar.parent.removeChild(_rightMoneyBar);
				}
			}
			
			_leftMoneyBar =new Sprite();
			_leftMoneyBar.graphics.beginFill(0x101E2A,1);
			var x1:int = 100;
			var x2:int = _w/2 - 20;
			_leftMoneyBar.graphics.drawRoundRect(x1,45,x2-x1,20,5,5);//圆角矩形
			_leftMoneyBar.graphics.endFill();
			
			_rightMoneyBar =new Sprite();
			_rightMoneyBar.graphics.beginFill(0x101E2A,1);
			x1 = _w/2 + 20;
			x2 = _w - 100;
			_rightMoneyBar.graphics.drawRoundRect(x1,45,x2-x1,20,5,5);//圆角矩形
			_rightMoneyBar.graphics.endFill();
			
			_leftMoneyInt = num;
			_totalMoneyInt = _leftMoneyInt + _rightMoneyInt;
			
			_leftMoney.text = num.toString(10) +" 金币";
			_leftMoney.setTextFormat(_leftTextFormat);
			
			_leftMoneyBar.graphics.beginFill(0xEE375D,1);
			x1 = 100;
			
			if ((objHasKeys(_info,['a','betcount']))&&(objHasKeys(_info,['a','betcount']))&&(objHasKeys(_info,['a','betcount'])))
			{
				x2 = 100 + (_w-240)/2*(_info['a']['betcount']/(_info['a']['premium'] / (Number(_info['a']['odds'] + 0.01))));
			}
			else
			{
				x2 = 100;
			}
			//= 100 + (_w-240)/2*(_info['a']['betcount']/(_info['a']['premium'] / Number(_info['a']['odds'])));
			_leftMoneyBar.graphics.drawRoundRect(x1,45,x2-x1,20,5,5);//圆角矩形
			_leftMoneyBar.graphics.endFill();
			
			_totalMoneyInt = _leftMoneyInt + _rightMoneyInt;
			
			_rightMoney.text = _rightMoneyInt.toString(10) +" 金币";
			_rightMoney.setTextFormat(_rightTextFormat);
			
			_rightMoneyBar.graphics.beginFill(0x5CACEE,1);
			x1 = _w/2+20;
			if ((objHasKeys(_info,['b','betcount']))&&(objHasKeys(_info,['b','betcount']))&&(objHasKeys(_info,['b','betcount'])))
			{
				x2 =  _w/2+20+(_w-240)/2*(_info['b']['betcount']/(_info['b']['premium'] / Number(_info['b']['odds'])+0.01));
			}
			else
			{
				x2 = _w/2 + 20;//100;
			}

			_rightMoneyBar.graphics.drawRoundRect(x1,45,x2-x1,20,5,5);//圆角矩形
			_rightMoneyBar.graphics.endFill();
		}
		
		public function set rightMoney(num:int):void
		{
			if (_leftMoneyBar)
			{
				if (_leftMoneyBar.parent)
				{
					_leftMoneyBar.parent.removeChild(_leftMoneyBar);
				}
			}
			if (_rightMoneyBar)
			{
				if (_rightMoneyBar.parent)
				{
					_rightMoneyBar.parent.removeChild(_rightMoneyBar);
				}
			}
			_leftMoneyBar =new Sprite();
			_leftMoneyBar.graphics.beginFill(0x101E2A,1);
			var x1:int = 100;
			var x2:int = _w/2 - 20;
			_leftMoneyBar.graphics.drawRoundRect(x1,45,x2-x1,20,5,5);//圆角矩形
			_leftMoneyBar.graphics.endFill();
			addChild(_leftMoneyBar);
			
			_rightMoneyBar =new Sprite();
			_rightMoneyBar.graphics.beginFill(0x101E2A,1);
			x1 = _w/2 + 20;
			x2 = _w - 100;
			_rightMoneyBar.graphics.drawRoundRect(x1,45,x2-x1,20,5,5);//圆角矩形
			_rightMoneyBar.graphics.endFill();
			addChild(_rightMoneyBar);
			//var canBetCount:Number = (_data.premium) / Number(_data.odds);
			_rightMoneyInt = num;
			_totalMoneyInt = _leftMoneyInt + _rightMoneyInt;
			
			_rightMoney.text = num.toString(10) +" 金币";
			_rightMoney.setTextFormat(_rightTextFormat);
			
			_rightMoneyBar.graphics.beginFill(0x5CACEE,1);
			x1 = _w/2+20;
			x2 = _w/2 + 20;
			if ((objHasKeys(_info,['b','betcount']))&&(objHasKeys(_info,['b','betcount']))&&(objHasKeys(_info,['b','betcount'])))
			{
				x2 =  _w/2+20+(_w-240)/2*(_info['b']['betcount']/(_info['b']['premium'] / Number(_info['b']['odds'])+0.01));
			}
			else
			{
				x2 = _w/2 + 20;//100;
			}
			//var x2:int = w/2+20+(w-240)/2*(_info['b']['betcount']/(_info['b']['premium'] / Number(_info['b']['odds'])));
			_rightMoneyBar.graphics.drawRoundRect(x1,45,x2-x1,20,5,5);//圆角矩形
			_rightMoneyBar.graphics.endFill();
			
			_leftMoney.text = _leftMoneyInt.toString(10) +" 金币";
			_leftMoney.setTextFormat(_leftTextFormat);
			
			_leftMoneyBar.graphics.beginFill(0xEE375D,1);
			x1 = 100;
			if ((objHasKeys(_info,['a','betcount']))&&(objHasKeys(_info,['a','betcount']))&&(objHasKeys(_info,['a','betcount'])))
			{
				x2 = 100 + (_w-240)/2*(_info['a']['betcount']/(_info['a']['premium'] / (Number(_info['a']['odds'] + 0.01))));
			}
			else
			{
				x2 = 100;
			}
			_leftMoneyBar.graphics.drawRoundRect(x1,45,x2-x1,20,5,5);//圆角矩形
			_leftMoneyBar.graphics.endFill();
		}
		
		public function set leftName(name:String):void
		{
			_leftName.text = name;
			_leftName.setTextFormat(_leftTextFormat);
		}
		
		public function set rightName(name:String):void
		{
			_rightName.text = name;
			_rightName.setTextFormat(_rightTextFormat);
		}
		
		public function set leftOdd(name:String):void
		{
			_leftOdd.text = name;
			_leftOdd.setTextFormat(_oddsTextFormat);
		}
		
		public function set rightOdd(name:String):void
		{
			_rightOdd.text = name;
			_rightOdd.setTextFormat(_oddsTextFormat);
		}
		/**
		 * 更新id=_id的数据
		 */
		private function refresh(_id:int):void
		{
			getDealer(_id);
		}
		/**
		 * 获取当前竞猜的最优庄
		 */		
		public function getDealer(id:int):void {
			if (_currentId != id)
			{
				return ;
			}
			doGetDealer(id);
		}
		
		private function doGetDealer(id:int):void {
//			_label.visible = false;
//			_con.visible = true;
//			
//			_data = value as QuizData;
//			_isSettle = _data.state == "3";
//			_leftTitle = _data.leftTitle;
//			_rightTitle = _data.rightTitle;
//			if (!_isSettle) {
				_qd.getDealerByQuiz(id.toString(), getDealerSuccess, getDealerFail);
//			} else {
//				_label.visible = true;
//				_con.visible = false;
//				quizSettle(_data.id);
//			}
		}
		
		
		
		private function getDealerSuccess(data:Object):void {
			var leftData:Object = data['obj']['a'];
			var rightData:Object = data['obj']['b'];
			var _data:DealerData = new DealerData();
			
			_data.resolveData(data['obj']['a']);
			leftMoney =  _data.betcount + (_data.currency == "5" ? "银币" : "金币");
			leftName = _data.title ? _data.title : "";
			leftOdd = "1:" + _data.odds;
			
			_data.resolveData(data['obj']['b']);
			rightMoney =  _data.betcount + (_data.currency == "5" ? "银币" : "金币");
			rightName = _data.title ? _data.title : "";
			rightOdd = "1:" + _data.odds;
		}
		
		
		private function getDealerFail(data:Object):void {
//			if (data && data.hasOwnProperty("code") && data["code"] == "000012") {
//				getDealerSuccess(null);
//			} else {
//				_label.text = "竞猜内容正在努力向您跑来，请稍候...";
//				_label.visible = true;
//				_con.visible = false;
//			}
	}
		
		public function set topic(a:String):void
		{
			
		}
	}
}