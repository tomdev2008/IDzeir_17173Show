package com._17173.flash.player.module.quiz.ui
{
	import com._17173.flash.core.components.common.Button;
	import com._17173.flash.core.components.common.HGroup;
	import com._17173.flash.core.components.common.Label;
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.core.util.Util;
	import com._17173.flash.player.context.ContextEnum;
	import com._17173.flash.player.model.PlayerEvents;
	import com._17173.flash.player.module.quiz.QuizEvents;
	import com._17173.flash.player.module.quiz.data.DealerData;
	import com._17173.flash.player.module.quiz.ui.QuizControlBar.QuizUIOfficialPrecBar;
	
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class QuizOfficialBetPanel extends QuizBasePanel
	{
		
		private var _line0:Sprite;
		private var _line1:Sprite;
		private var _line2:Sprite;
		private var _line3:Sprite;
		private var _line4:Sprite;
		private var _line5:HGroup;
		private var _line6:Sprite;
		private var _radioBtn1_1:QuizRadioBtn;
		private var _pec1_2:QuizUIOfficialPrecBar;
		private var _label1_3:Label;
		private var _label1_4:Label;
		private var _radioBtn2_1:QuizRadioBtn;
		private var _pec2_2:QuizUIOfficialPrecBar;
		private var _label2_3:Label;
		private var _label2_4:Label;
		private var _radioBtn3_1:QuizRadioBtn;
		private var _pec3_2:QuizUIOfficialPrecBar;
		private var _label3_3:Label;
		private var _label3_4:Label;
		private var _radioBtn4_1:QuizRadioBtn;
		private var _pec4_2:QuizUIOfficialPrecBar;
		private var _label4_3:Label;
		private var _label4_4:Label;
		private var _line:Shape;
		private var _label5_1:Label;
		private var _label5_2:Label;
		private var _label5_4:Label;
		private var _label6_1:Label;
		private var _label6_2C:Sprite;
		private var _label6_2:Label;
		private var _label6_3C:Sprite;
		private var _label6_3:Label;
		private var _submit:Button;
		private var _data:Array;
		private var _userInfo:Object;
		/**
		 * 官方抽水比例
		 */		
		private var _odds:Number;
		/**
		 * 当前使用的货币类型
		 */		
		private var _currency:int;
		private var _totalMoney:Number;
		private var _betFlag:Boolean;
		private var _radioFlag:Boolean;
		private var _currentSelectRadio:int;
		private var _e:IEventManager
		private var _minMoney:Number;
		private var _maxMoney:Number;
		
		public function QuizOfficialBetPanel()
		{
			super();
			init();
		}
		
		override protected function init():void {
			this.titleStr = "";
			this.title.width = 500;
			_w = 458;
			_h = 308;
			_e = Context.getContext(ContextEnum.EVENT_MANAGER) as IEventManager;
			super.init();
		}
		
		override protected function addListener():void {
			super.addListener();
			_e.listen(QuizEvents.QUIZ_PULL_DEALER_DATA, pullDealerData);
			_e.listen(PlayerEvents.BI_USER_INFO_GETED, getUserInfo);
			_e.listen(QuizEvents.QUIZ_PULL_OFFICIAL_DEALER_DATA, dealerOfficialStateChange);
		}
		
		public function setData(value:Array, reFlag:Boolean = true):void {
			_data = value;
			if (reFlag) {
				reInit();
			}
			_totalMoney = 0;
			for (var i:int = 0; i < _data.length; i++) {
				var item:DealerData = _data[i] as DealerData;
				_totalMoney += item.betcount;
			}
			if (_data.length > 0) {
				_radioBtn1_1.label = formatString((_data[0] as DealerData).title);
				_radioBtn1_1.width = 132;
				_pec1_2.setData((_data[0] as DealerData).betcount / _totalMoney);
				_label1_3.text = (_data[0] as DealerData).betcount + (_currency == 1 ? "金币" : "银币");
				if ((_data[0] as DealerData).betcount == 0) {
					_label1_4.text = "赔率 0:0";
				} else {
					_label1_4.text = "赔率 1:" + getCurrentOdd((_data[0] as DealerData).betcount);
				}
				_line0.addChild(_line1);
			}
			if (_data.length > 1) {
				_radioBtn2_1.label = formatString((_data[1] as DealerData).title);
				_radioBtn2_1.width = 132;
				_pec2_2.setData((_data[1] as DealerData).betcount / _totalMoney);
				_label2_3.text = (_data[1] as DealerData).betcount + (_currency == 1 ? "金币" : "银币");
				if ((_data[1] as DealerData).betcount == 0) {
					_label2_4.text = "赔率 0:0";
				} else {
					_label2_4.text = "赔率 1:" + getCurrentOdd((_data[1] as DealerData).betcount);
				}
				_line0.addChild(_line2);
			}
			if (_data.length > 2) {
				_radioBtn3_1.label = formatString((_data[2] as DealerData).title);
				_radioBtn3_1.width = 132;
				_pec3_2.setData((_data[2] as DealerData).betcount / _totalMoney);
				_label3_3.text = (_data[2] as DealerData).betcount + (_currency == 1 ? "金币" : "银币");
				if ((_data[2] as DealerData).betcount == 0) {
					_label3_4.text = "赔率 0:0";
				} else {
					_label3_4.text = "赔率 1:" + getCurrentOdd((_data[2] as DealerData).betcount);
				}
				_line0.addChild(_line3);
			}
			if (_data.length > 3) {
				_radioBtn4_1.label = formatString((_data[3] as DealerData).title);
				_radioBtn4_1.width = 132;
				_pec4_2.setData((_data[3] as DealerData).betcount / _totalMoney);
				_label4_3.text = (_data[3] as DealerData).betcount + (_currency == 1 ? "金币" : "银币");
				if ((_data[3] as DealerData).betcount == 0) {
					_label4_4.text = "赔率 0:0";
				} else {
					_label4_4.text = "赔率 1:" + getCurrentOdd((_data[3] as DealerData).betcount);
				}
				_line0.addChild(_line4);
			}
			_label5_4.text = "(投注范围：" + minMoney + "~" + maxMoney + (_currency == 1 ? "金币" : "银币") + ")";
			resizeThis();
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
		
		private function reInit():void {
			if (_line0 && _line0.numChildren > 0) {
				_line0.removeChildren(0, _line0.numChildren - 1);
			}
			_betFlag = false;
			_radioFlag = false;
			checkSubmit();
			_currentSelectRadio = 0;
			_radioBtn1_1.selected = false;
			_radioBtn2_1.selected = false;
			_radioBtn3_1.selected = false;
			_radioBtn4_1.selected = false;
			_label5_2.text = "";
			if (!_userInfo) {
				_userInfo = Context.variables["userInfo"];
			}
			_label5_1.text = "所押" + (_currency == 1 ? "金币:" : "银币:");
			_label6_1.text = "现有" + (_currency == 1 ? "金币" : "银币") + ":  " + (_currency == 1 ? _userInfo["jinbi"] : _userInfo["yinbi"]);
		}
		
		/**
		 * 后新的庄装数据推送过来
		 */		
		private function pullDealerData(value:Object):void {
			setData(value as Array, false);
		}
		
		/**
		 * 推送过来新的用户信息
		 */		
		private function getUserInfo(value:Object):void {
			_userInfo = Context.variables["userInfo"];
			if (_label6_1) {
				_label6_1.text = "现有" + (_currency == 1 ? "金币" : "银币") + ":" + (_currency == 1 ? _userInfo["jinbi"] : _userInfo["yinbi"]);
			}
			if (_label5_2) {
				betChangeHandler(null);
			}
		}
		
		override protected function drawOther():void {
			_line0 = new Sprite();
			addChild(_line0);
			
			initLine1();
			initLine2();
			initLine3();
			initLine4();
			initLine();
			initLine5();
			initLine6();
			initSubmit();
			
			resizeThis();
		}
		
		override protected function initTextFormat():void {
			_tf = new TextFormat();
			_tf.size = 12;
			_tf.color = 0x888888;
			_tf.font = Util.getDefaultFontNotSysFont();
			
			_inpt_tf = new TextFormat();
			_inpt_tf.size = 17;
			_inpt_tf.color = 0x888888;
			_inpt_tf.font = Util.getDefaultFontNotSysFont();
		}
		
		private function initLine1():void {
			_line1 = new Sprite();
			
			_radioBtn1_1 = new QuizRadioBtn();
			_radioBtn1_1.width = 132;
			_radioBtn1_1.addEventListener(MouseEvent.CLICK, radioBtn1Click);
			_line1.addChild(_radioBtn1_1);
			
			_pec1_2 = new QuizUIOfficialPrecBar();
			_line1.addChild(_pec1_2);
			
			_label1_3 = new Label({"maxW":100});
			setLabelFormat(_label1_3);
			_label1_3.width = 100;
			_line1.addChild(_label1_3);
			
			_label1_4 = new Label({"maxW":100});
			setLabelFormat(_label1_4);
			_label1_4.width = 100;
			_line1.addChild(_label1_4);
		}
		
		private function initLine2():void {
			_line2 = new Sprite();
			
			_radioBtn2_1 = new QuizRadioBtn();
			_radioBtn2_1.width = 132;
			_radioBtn2_1.addEventListener(MouseEvent.CLICK, radioBtn2Click);
			_line2.addChild(_radioBtn2_1);
			
			_pec2_2 = new QuizUIOfficialPrecBar();
			_line2.addChild(_pec2_2);
			
			_label2_3 = new Label({"maxW":100});
			setLabelFormat(_label2_3);
			_label2_3.width = 100;
			_line2.addChild(_label2_3);
			
			_label2_4 = new Label({"maxW":100});
			setLabelFormat(_label2_4);
			_label2_4.width = 100;
			_line2.addChild(_label2_4);
		}
		
		private function initLine3():void {
			_line3 = new Sprite();
			
			_radioBtn3_1 = new QuizRadioBtn();
			_radioBtn3_1.width = 132;
			_radioBtn3_1.addEventListener(MouseEvent.CLICK, radioBtn3Click);
			_line3.addChild(_radioBtn3_1);
			
			_pec3_2 = new QuizUIOfficialPrecBar();
			_line3.addChild(_pec3_2);
			
			_label3_3 = new Label({"maxW":100});
			setLabelFormat(_label3_3);
			_label3_3.width = 100;
			_line3.addChild(_label3_3);
			
			_label3_4 = new Label({"maxW":100});
			setLabelFormat(_label3_4);
			_label3_4.width = 100;
			_line3.addChild(_label3_4);
		}
		
		private function initLine4():void {
			_line4 = new Sprite();
			
			_radioBtn4_1 = new QuizRadioBtn();
			_radioBtn4_1.width = 132;
			_radioBtn4_1.addEventListener(MouseEvent.CLICK, radioBtn4Click);
			_line4.addChild(_radioBtn4_1);
			
			_pec4_2 = new QuizUIOfficialPrecBar();
			_line4.addChild(_pec4_2);
			
			_label4_3 = new Label({"maxW":100});
			setLabelFormat(_label4_3);
			_label4_3.width = 100;
			_line4.addChild(_label4_3);
			
			_label4_4 = new Label({"maxW":100});
			setLabelFormat(_label4_4);
			_label4_4.width = 100;
			_line4.addChild(_label4_4);
		}
		
		private function initLine():void {
			_line = new Shape();
			_line.graphics.clear();
			_line.graphics.beginFill(0x000000);
			_line.graphics.drawRect(0, 0, 430, 0.5);
			_line.graphics.endFill();
			addChild(_line);
		}
		
		private function initLine5():void {
			_line5 = new HGroup();
			_line5.valign = HGroup.MIDDLE;
			
			_label5_1 = new Label({"maxW":85});
			setLabelFormat(_label5_1);
			_label5_1.text = "所押金币:";
			_label5_1.width = 85;
			_line5.addChild(_label5_1);
			
			_label5_2 = new Label({"maxW":160});
			setLabelFormat(_label5_2, true);
			_label5_2.width = 160;
			_label5_2.height = 30;
			_label5_2.restrict = "0-9";
			_label5_2.addEventListener(Event.CHANGE, betChangeHandler);
			_label5_2.addEventListener(TextEvent.TEXT_INPUT, betInputHandler)
			var lb:QuizTextBG = new QuizTextBG(160, 30);
			lb.addItem(_label5_2);
			_line5.addChild(lb);
			
			_label5_4 = new Label({"maxW":200});
			setLabelFormat(_label5_1);
			_label5_4.text = "(投注范围：100~100000金币)";
			_label5_4.width = 200;
			_line5.addChild(_label5_4);
			
			addChild(_line5);
		}
		
		private function initLine6():void {
			_line6 = new Sprite();
			
			_label6_1 = new Label({"maxW":190});
			setLabelFormat(_label6_1);
			_label6_1.text = "现有金币:12345678";
			_label6_1.width = 190;
			_line6.addChild(_label6_1);
			
			var ctf:TextFormat = new TextFormat();
			ctf.color = 0xeda130;
			ctf.font = Util.getDefaultFontNotSysFont();
			ctf.size = 12;
			ctf.underline = true;
			
			_label6_2C = new Sprite();
			_label6_2C.buttonMode = true;
			_label6_2C.useHandCursor = true;
			_label6_2C.mouseChildren = false;
			_label6_2C.addEventListener(MouseEvent.CLICK, moneyClick);
			
			_label6_2 = new Label({"maxW":80});
			_label6_2.autoSize = TextFieldAutoSize.LEFT;
			_label6_2.defaultTextFormat = ctf;
			_label6_2.setTextFormat(ctf);
			_label6_2.text = "充值金币";
			_label6_2.width = 80;
			_label6_2C.addChild(_label6_2);
			_line6.addChild(_label6_2C);
			
			_label6_3C = new Sprite();
			_label6_3C.buttonMode = true;
			_label6_3C.useHandCursor = true;
			_label6_3C.mouseChildren = false;
			_label6_3C.addEventListener(MouseEvent.CLICK, getYinbiClick)
				
			_label6_3 = new Label({"maxW":140});
			_label6_3.autoSize = TextFieldAutoSize.LEFT;
			_label6_3.defaultTextFormat = ctf;
			_label6_3.setTextFormat(ctf);
			_label6_3.text = "如何获得银币?";
			_label6_3.width = 140;
			_label6_3C.addChild(_label6_3);
			_line6.addChild(_label6_3C);
			
			addChild(_line6);
		}
		
		private function initSubmit():void {
			_submit = new Button();
			_submit.setSkin(new quizBetBig());
			_submit.width = 72;
			_submit.height = 24;
			_submit.addEventListener(MouseEvent.CLICK, submitClick);
			_submit.disabled = true;
			addChild(_submit);
		}
		
		protected function submitClick(event:MouseEvent):void
		{
			var obj:Object = {};
			obj.id = (_data[_currentSelectRadio - 1] as DealerData).id;
			obj.money = _label5_2.text;
			_e.send(QuizEvents.QUZI_BET_OFFICIAL, obj);
		}
		
		private function betInputHandler(evt:TextEvent):void {
			if (_label5_2.text.length == 0 && evt.text == "0") {
				evt.preventDefault();
			}
		}
		
		private function betChangeHandler(evt:Event):void {
			var currentMony:Number = _currency == 1 ? _userInfo["jinbi"] : _userInfo["yinbi"];
			if (_label5_2.text.length > 0 && ( Number(_label5_2.text) <= currentMony ) && Number(_label5_2.text) >= minMoney && Number(_label5_2.text) <= maxMoney ) {
				_betFlag = true;
			} else {
				_betFlag = false;
			}
			checkSubmit();
		}
		
		private function checkSubmit():void {
			if (_betFlag && _radioFlag) {
				_submit.disabled = false;
			} else {
				_submit.disabled = true;
			}
		}
		
		protected function radioBtn1Click(event:MouseEvent):void
		{
			_currentSelectRadio = 1;
			setRadionState();
		}
		
		protected function radioBtn2Click(event:MouseEvent):void
		{
			_currentSelectRadio = 2;
			setRadionState();
		}
		
		protected function radioBtn3Click(event:MouseEvent):void
		{
			_currentSelectRadio = 3;
			setRadionState();
		}
		
		protected function radioBtn4Click(event:MouseEvent):void
		{
			_currentSelectRadio = 4;
			setRadionState();
		}
		
		private function setRadionState():void {
			_radioBtn1_1.selected = _currentSelectRadio == 1;
			_radioBtn2_1.selected = _currentSelectRadio == 2;
			_radioBtn3_1.selected = _currentSelectRadio == 3;
			_radioBtn4_1.selected = _currentSelectRadio == 4;
			_radioFlag = true;
			checkSubmit();
		}
		
		private function resizeThis():void {
			if (_line1) {
				_radioBtn1_1.x = 0;
				_radioBtn1_1.y = (_line1.height - _radioBtn1_1.height) / 2;
				
				_pec1_2.x = 138;
				_pec1_2.y = (_line1.height - _pec1_2.height) / 2;
				
				_label1_3.x = 278;
				_label1_3.y = (_line1.height - _label1_3.height) / 2;
				
				_label1_4.x = 360;
				_label1_4.y = (_line1.height - _label1_4.height) / 2;
			}
			if (_line2) {
				_radioBtn2_1.x = 0;
				_radioBtn2_1.y = (_line2.height - _radioBtn2_1.height) / 2;
				
				_pec2_2.x = 138;
				_pec2_2.y = (_line2.height - _pec2_2.height) / 2;
				
				_label2_3.x = 278;
				_label2_3.y = (_line2.height - _label2_3.height) / 2;
				
				_label2_4.x = 360;
				_label2_4.y = (_line2.height - _label2_4.height) / 2;
			}
			if (_line3) {
				_radioBtn3_1.x = 0;
				_radioBtn3_1.y = (_line3.height - _radioBtn3_1.height) / 2;
				
				_pec3_2.x = 138;
				_pec3_2.y = (_line3.height - _pec3_2.height) / 2;
				
				_label3_3.x = 278;
				_label3_3.y = (_line3.height - _label3_3.height) / 2;
				
				_label3_4.x = 360;
				_label3_4.y = (_line3.height - _label3_4.height) / 2;
			}
			if (_line4) {
				_radioBtn4_1.x = 0;
				_radioBtn4_1.y = (_line4.height - _radioBtn4_1.height) / 2;
				
				_pec4_2.x = 138;
				_pec4_2.y = (_line4.height - _pec4_2.height) / 2;
				
				_label4_3.x = 278;
				_label4_3.y = (_line4.height - _label4_3.height) / 2;
				
				_label4_4.x = 360;
				_label4_4.y = (_line4.height - _label4_4.height) / 2;
			}
			if (_line0 && _line0.numChildren > 0) {
				for (var i:int = 0; i < _line0.numChildren; i++) {
					var dis:DisplayObject = _line0.getChildAt(i);
					dis.x = 0;
					dis.y = i * 26;
				}
				_line0.x = (_w - _line0.width) / 2;
				_line0.y = (150 - _line0.height) / 2 + 30;
			}
			if (_line) {
				_line.x = (_w - _line.width) / 2;
				_line.y = 180;
			}
			if (_line5) {
				_line5.x = 12;
				_line5.y = _line.y + 20;
			}
			if (_line6) {
				_line6.x = 12;
				_line6.y = _line5.y + _line5.height + 5;
				
				_label6_1.x = 0;
				_label6_1.y = (_line6.height - _label6_1.height) / 2;
				
				_label6_2C.x = 280;
				_label6_2C.y = (_line6.height - _label6_2C.height) / 2;
				
				_label6_3.x = 340;
				_label6_3.y = (_line6.height - _label6_3.height) / 2;
			}
			if (_submit) {
				_submit.x = (_w - _submit.width) / 2;
				_submit.y = _line5.y + _line5.height + 38;
			}
		}
		
		/**
		 * 直接推送官方竞猜数据
		 */		
		private function dealerOfficialStateChange(data:Object):void {
			if (!data) {
//				Debugger.log(Debugger.INFO, "[quiz] quizOfficialBetPanel:官方竞猜传递过来无数据");
			} else {
//				Debugger.log(Debugger.INFO, "[quiz] quizOfficialBetPanel:官方竞猜使用传递过来的数据");
				if (!data) {
//					Debugger.log(Debugger.INFO, "[quiz] quizOfficialBetPanel:官方竞猜传递过来的数据wei kong");
				} else {
					if (data.hasOwnProperty("jcGovConInfos") && data["jcGovConInfos"]) {
//						Debugger.log(Debugger.INFO, "[quiz] uiBottomBar:官方竞猜传递过来的数据有正确的竞猜数据");
						var tempArr:Array = data["jcGovConInfos"] as Array;
						var officialData:Array = [];
						for (var i:int = 0; i < tempArr.length; i++) {
							var item:DealerData = new DealerData();
							item.resolveData(tempArr[i]);
							officialData.push(item);
						}
						setData(officialData, false);
					}
				}
			}
		}
		
		/**
		 * 充值金币
		 */		
		protected function moneyClick(event:MouseEvent):void
		{
			if (Context.getContext(ContextEnum.SETTING)["isFullScreen"]) {
				Context.stage.displayState = StageDisplayState.NORMAL;
			}
			Util.toUrl("http://v.17173.com/live/ucenter/payment.action");
		}
		
		private function getYinbiClick(evt:MouseEvent):void {
			if (Context.getContext(ContextEnum.SETTING)["isFullScreen"]) {
				Context.stage.displayState = StageDisplayState.NORMAL;
			}
			Util.toUrl("http://bbs.17173.com/thread-8082541-1-1.html");
		}
		
		private function formatString(value:String):String {
			if (value.length > 8) {
				return value.substr(0, 8);
			} else {
				return value;
			}
		}

		/**
		 * 官方抽水比例
		 */	
		public function get odds():Number
		{
			return _odds;
		}

		public function set odds(value:Number):void
		{
			_odds = value;
		}

		/**
		 * 当前使用的货币类型
		 */
		public function get currency():int
		{
			return _currency;
		}

		public function set currency(value:int):void
		{
			_currency = value;
		}

		public function get minMoney():Number
		{
			return _minMoney;
		}

		public function set minMoney(value:Number):void
		{
			_minMoney = value;
		}

		public function get maxMoney():Number
		{
			return _maxMoney;
		}

		public function set maxMoney(value:Number):void
		{
			_maxMoney = value;
		}

		
	}
}