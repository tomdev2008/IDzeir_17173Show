package com._17173.flash.player.module.quiz.ui
{
	import com._17173.flash.core.components.common.Button;
	import com._17173.flash.core.components.common.HGroup;
	import com._17173.flash.core.components.common.Label;
	import com._17173.flash.core.components.common.VGroup;
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.core.util.Util;
	import com._17173.flash.player.context.ContextEnum;
	import com._17173.flash.player.model.PlayerEvents;
	import com._17173.flash.player.module.quiz.QuizEvents;
	import com._17173.flash.player.module.quiz.data.QuizData;
	import com._17173.flash.player.module.quiz.data.QuizUserData;
	
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;

	/**
	 * 我要坐庄
	 */	
	public class QuizStartDealerPanel extends QuizBasePanel
	{
		private var _line1:HGroup;
		private var _line2:HGroup;
		private var _line3:HGroup;
		private var _line4:HGroup;
		private var _line5:HGroup;
		private var _line6:HGroup;
		private var _line7:HGroup;
		private var _line8:HGroup;
		private var _vgroup1:VGroup;
		private var _vgroup2:VGroup;
		private var _label1_1:Label;
		private var _label1_2:Label;
		private var _label2_1:Label;
		private var _radioBtn2_1:QuizRadioBtn;
		private var _radioBtn2_2:QuizRadioBtn;
		private var _label3_1:Label;
		private var _label3_2:Label;
		private var _label3_3:Label;
		private var _label3_4:Label;
		private var _label4_1:Label;
		private var _radioBtn4_1:QuizRadioBtn;
		private var _radioBtn4_2:QuizRadioBtn;
		private var _label5_1:Label;
		private var _label5_2:Label;
		private var _label6_1:Label;
		private var _label6_2:Label;
		private var _label6_3:Label;
		private var _label7_1:Label;
		private var _label7_2:Label;
		private var _label7_3:Label;
		private var _submit:Button;
		private var _cancel:Button;
		private var _moneyBtn:Button;
		private var _currentData:QuizData;
		private var _hasVictor:Boolean;
		private var _hasOdds:Boolean;
		private var _hasCurrency:Boolean;
		private var _hasPremium:Boolean;
		private var _userInfo:Object;
		private var _premium:int;
		
		public function QuizStartDealerPanel()
		{
			super();
			init();
		}
		
		public function setData(value:Object):void {
			var temp:QuizUserData = Context.variables["quizUser"] as QuizUserData;
			if (temp) {
				_premium = temp.premium;
			} else {
				_premium = 1000;
			}
			resetData();
			_currentData = value as QuizData;
			
			_label1_2.text = _currentData.title;
			_radioBtn2_1.label = _currentData.leftTitle;
			_radioBtn2_1.update();
			_radioBtn2_2.label = _currentData.rightTitle;
			_radioBtn2_2.update();
			_line2.update();
			setCurrency();
			setUserInfo();
			resizeThis();
		}
		
		private function resetData():void {
			_radioBtn2_1.selected = false;
			_radioBtn2_2.selected = false;
			_label3_3.text = "";
			_radioBtn4_1.selected = false;
			_radioBtn4_2.selected = false;
			_label6_2.text = "";
			
			_hasVictor = false;
			_hasOdds = false;
			_hasPremium = false;
			_hasCurrency = false;
		}
		
		override protected function init():void {
			this.titleStr = "我要做庄（您开的庄可以被其他用户购买）";
			this.title.width = 456;
			_w = 456;
			_h = 437;
			super.init();
		}
		
		override protected function addListener():void {
			super.addListener();
			(Context.getContext(ContextEnum.EVENT_MANAGER) as IEventManager).listen(PlayerEvents.BI_USER_INFO_GETED, setUserInfo);
		}
		
		private function setCurrency():void {
			if (_currentData.currency == 1) {
				_radioBtn4_1.visible = true;
				_radioBtn4_1.selected = true;
				_radioBtn4_2.visible = false;
				_hasCurrency = true;
			} else if (_currentData.currency == 5) {
				_radioBtn4_1.visible = false;
				_radioBtn4_2.visible = true;
				_radioBtn4_2.selected = true;
				_hasCurrency = true;
			} else {
				_radioBtn4_1.visible = true;
				_radioBtn4_2.visible = true;
				_radioBtn4_1.selected = false;
				_radioBtn4_2.selected = false;
				_hasCurrency = false;
			}
		}
		
		private function setUserInfo(data:Object = null):void {
			_userInfo = Context.variables["userInfo"];
			switch (_currentData.currency) {
				case 1:
					_label5_2.text = _userInfo["jinbi"] + "金币";
					break;
				case 5:
					_label5_2.text = _userInfo["yinbi"] + "银币";
					break;
				case 15:
					_label5_2.text = _userInfo["jinbi"] + "金币     " + _userInfo["yinbi"] + "银币";
					break;
				default:
					_label5_2.text = _userInfo["jinbi"] + "金币     " + _userInfo["yinbi"] + "银币";
			}
			_label5_2.width = 400;
			_line5.update();
			
			_label6_3.text = "（底金不少于" + _premium +"）";
		}
		
		override protected function drawOther():void {
			initLine1();
			initLine2();
			initLine3();
			initLine4();
			initLine5();
			initLine6();
			initLine7();
			initLine8();
			
			resizeThis();
		}
		
		private function initLine1():void {
			_line1 = new HGroup();
			_line1.valign = HGroup.TOP;
			
			_label1_1 = new Label({"maxW":85});
			_label1_1.text = "竞猜主题：";
			setLabelFormat(_label1_1);
			_label1_1.width = 85;
			_line1.addChild(_label1_1);
			
			_label1_2 = new Label({"maxW":160});
			_label1_2.width = 160;
			setLabelFormat(_label1_2);
			_label1_2.textColor = 0xffffff;
			_line1.addChild(_label1_2);
			
			_container.addChild(_line1);
		}
		
		private function initLine2():void {
			_line2 = new HGroup();
			_line2.valign = HGroup.TOP;
			
			_label2_1 = new Label({"maxW":140});
			_label2_1.text = "押胜方：";
			setLabelFormat(_label2_1);
			_line2.addChild(_label2_1);
			
			_radioBtn2_1 = new QuizRadioBtn();
			_radioBtn2_1.addEventListener(MouseEvent.CLICK, rb1ClickHandler);
			_line2.addChild(_radioBtn2_1);
			
			_radioBtn2_2 = new QuizRadioBtn();
			_radioBtn2_2.addEventListener(MouseEvent.CLICK, rb2ClickHandler);
			_line2.addChild(_radioBtn2_2);
			
			_container.addChild(_line2);
		}
		
		private function initLine3():void {
			_line3 = new HGroup();
			_line3.valign = HGroup.MIDDLE;
			
			_label3_1 = new Label({"maxW":140});
			_label3_1.text = "比率：";
			setLabelFormat(_label3_1);
			_line3.addChild(_label3_1);
			
			_label3_2 = new Label();
			_label3_2.text = "1：";
			setLabelFormat(_label3_2);
			_label3_2.textColor = 0xffffff;
			_line3.addChild(_label3_2);
			
			_label3_3 = new Label({"maxW":60});
			setLabelFormat(_label3_3, true);
			_label3_3.width = 60;
			_label3_3.height = 30;
			_label3_3.addEventListener(TextEvent.TEXT_INPUT, oddsInputHandler);
			_label3_3.addEventListener(Event.CHANGE, oddsChangeHandler);
			var lb:QuizTextBG = new QuizTextBG(60, 30);
			lb.addItem(_label3_3);
			_line3.addChild(lb);
			
			_label3_4 = new Label({"maxW":170});
			setLabelFormat(_label3_4);
			_label3_4.text = "输入范围：0.1-9.9";
			_label3_4.textColor = 0xFF6347;
			_label3_4.width = 170;
			_line3.addChild(_label3_4);
			
			_container.addChild(_line3);
		}
		
		private function initLine4():void {
			_line4 = new HGroup();
			_line4.valign = HGroup.MIDDLE;
			
			_label4_1 = new Label({"maxW":140});
			_label4_1.text = "类型：";
			setLabelFormat(_label4_1);
			_line4.addChild(_label4_1);
			
			_radioBtn4_1 = new QuizRadioBtn();
			_radioBtn4_1.label = "金币";
			_radioBtn4_1.width = 50;
			_radioBtn4_1.addEventListener(MouseEvent.CLICK, jinbiClickHandler);
			_line4.addChild(_radioBtn4_1);
			
			_radioBtn4_2 = new QuizRadioBtn();
			_radioBtn4_2.label = "银币";
			_radioBtn4_2.addEventListener(MouseEvent.CLICK, yinbiClickHandler);
			_radioBtn4_2.width = 50;
			_line4.addChild(_radioBtn4_2);
			
			_container.addChild(_line4);
		}
		
		private function initLine5():void {
			_line5 = new HGroup();
			_line5.valign = HGroup.TOP;
			
			_label5_1 = new Label({"maxW":85});
			_label5_1.text = "我的账户：";
			setLabelFormat(_label5_1);
			_label5_1.width = 85;
			_line5.addChild(_label5_1);
			
			_label5_2 = new Label();
			setLabelFormat(_label5_2);
			_label5_2.textColor = 0xffffff;
			_line5.addChild(_label5_2);
			
			_moneyBtn = new Button();
			_moneyBtn.setSkin(new quizChongzhi());
			_moneyBtn.addEventListener(MouseEvent.CLICK, moneyClick);
			_moneyBtn.width = 46;
			_moneyBtn.height = 24;
			_line5.addChild(_moneyBtn);
			
			_container.addChild(_line5);
		}
		
		protected function moneyClick(event:MouseEvent):void
		{
			if (Context.getContext(ContextEnum.SETTING)["isFullScreen"]) {
				Context.stage.displayState = StageDisplayState.NORMAL;
			}
			Util.toUrl("http://v.17173.com/live/ucenter/goMpkgAccountLookup.action");
		}
		
		private function initLine6():void {
			_line6 = new HGroup();
			_line6.valign = HGroup.MIDDLE;
			
			_label6_1 = new Label({"maxW":140});
			_label6_1.text = "底金：";
			setLabelFormat(_label6_1);
			_line6.addChild(_label6_1);
			
			_label6_2 = new Label({"maxW":60});
			setLabelFormat(_label6_2, true);
			_label6_2.restrict = "0-9";
			_label6_2.width = 60;
			_label6_2.height = 30;
			_label6_2.addEventListener(Event.CHANGE, premiumChangeHandler);
			var lb:QuizTextBG = new QuizTextBG(60, 30);
			lb.addItem(_label6_2);
			_line6.addChild(lb);
			
			_label6_3 = new Label({"maxW":190});
			_label6_3.text = "（底金不少于" + _premium +"）";
			setLabelFormat(_label6_3);
			_label6_3.width = 190;
			_line6.addChild(_label6_3);
			
			_container.addChild(_line6);
		}
		
		private function initLine7():void {
			_line7 = new HGroup();
			_line7.valign = HGroup.TOP;
			
			_label7_1 = new Label({"maxW":140});
			_label7_1.text = "举例：";
			setLabelFormat(_label7_1);
			_line7.addChild(_label7_1);
			
			_vgroup1 = new VGroup();
			_vgroup1.gap = 0;
			_vgroup1.align = VGroup.LEFT;
			
			_label7_2 = new Label({"maxW":350});
			_label7_2.text = "1000底金，押注A胜利，赔率1：2；如A胜利，最多";
			_label7_2.width = 350;
			setLabelFormat(_label7_2);
			_vgroup1.addChild(_label7_2);
			
			_label7_3 = new Label({"maxW":250});
			_label7_3.text = "盈利500；A失败，最多赔1000";
			_label7_3.width = 250;
			setLabelFormat(_label7_3);
			_vgroup1.addChild(_label7_3);
			
			_line7.addChild(_vgroup1);
			
			_container.addChild(_line7);
		}
		
		private function initLine8():void {
			_line8 = new HGroup();
			_line8.valign = HGroup.MIDDLE;
			
			_submit = new Button();
			_submit.setSkin(new quizSubmitBtn());
			_submit.width = 68;
			_submit.height = 28;
			_submit.addEventListener(MouseEvent.CLICK, submitClick);
			_submit.disabled = true;
			_line8.addChild(_submit);
			
			_cancel = new Button();
			_cancel.setSkin(new quizCancelBtn());
			_cancel.width = 68;
			_cancel.height = 28;
			_cancel.addEventListener(MouseEvent.CLICK, cancelClick);
			_line8.addChild(_cancel);
			
			_container.addChild(_line8);
		}
		
		/**
		 * 验证可输入范围为0.1--9.9
		 */		
		private function oddsInputHandler(evt:TextEvent):void {
			var myPattern:RegExp = /^[0-9](\.[1-9])?$/;
			if (evt.text == ".") {
				var temp:int = int(_label3_3.text);
				if (_label3_3.text.indexOf(".") == -1 && (temp >= 0 && temp <= 9)) {
					
				} else {
					evt.preventDefault();
					return;
				}
			} else {
				if(myPattern.test(_label3_3.text + evt.text))
				{
					
				} else {
					evt.preventDefault();
				}
			}
		}
		
		private function oddsChangeHandler(evt:Event):void {
			if (_label3_3.text.length > 0 && _label3_3.text != ".") {
				_hasOdds = true;
			} else {
				_hasOdds = false;
			}
			resetSubmitState();
		}
		
		private function jinbiClickHandler(evt:MouseEvent):void {
			_radioBtn4_2.selected = false;
			_radioBtn4_1.selected = true;
			_hasCurrency = true;
			premiumChangeHandler(null);
			resetSubmitState();
		}
		
		private function yinbiClickHandler(evt:MouseEvent):void {
			_radioBtn4_1.selected = false;
			_radioBtn4_2.selected = true;
			_hasCurrency = true;
			premiumChangeHandler(null);
			resetSubmitState();
		}
		
//		/**
//		 * 货币类型操作
//		 */		
//		private function currencyClickHandler(evt:MouseEvent):void {
//			if (!_radioBtn4_1.selected && !_radioBtn4_2.selected) {
//				_hasCurrency = false;
//			} else {
//				_hasCurrency = true;
//			}
//			resetSubmitState();
//		}
		
		private function rb1ClickHandler(evt:MouseEvent):void {
			_radioBtn2_1.selected = true;
			_radioBtn2_2.selected = false;
			_hasVictor = true;
			resetSubmitState();
		}
		
		private function rb2ClickHandler(evt:MouseEvent):void {
			_radioBtn2_2.selected = true;
			_radioBtn2_1.selected = false;
			_hasVictor = true;
			resetSubmitState();
		}
		
		private function premiumChangeHandler(evt:Event):void {
			if (_label6_2.text.length > 0 && int(_label6_2.text) >= _premium) {
				if (_radioBtn4_1.selected) {
					//金币
					if (int(_label6_2.text) <= int(_userInfo["jinbi"])) {
						_hasPremium = true;
					} else {
						_hasPremium = false;
					}
				}
				if (_radioBtn4_2.selected) {
					//银币
					if (int(_label6_2.text) <= int(_userInfo["yinbi"])) {
						_hasPremium = true;
					} else {
						_hasPremium = false;
					}
				}
			} else {
				_hasPremium = false;
			}
			resetSubmitState();
		}
		
		/**
		 * 当前所有都输入，确定按钮才可用
		 */		
		private function resetSubmitState():void {
			if (_hasVictor && _hasOdds && _hasPremium && _hasCurrency) {
				_submit.disabled = false;
			} else {
				_submit.disabled = true;
			}
		}
		
		private function cancelClick(evt:MouseEvent):void {
			onCloseClick(null);
		}
		
		private function submitClick(evt:MouseEvent):void {
			var obj:Object = {
				"quizID":_currentData.id,
				"victor":_radioBtn2_1.selected ? _currentData.leftTitle : _currentData.rightTitle,
				"odds":_label3_3.text,
				"currency":getCurrency(),
				"premium":_label6_2.text
			};
			(Context.getContext(ContextEnum.EVENT_MANAGER) as IEventManager).send(QuizEvents.QUIZ_START_DEALER_DATA, obj);
			onCloseClick(null);
		}
		
		/**
		 * 15:金币+银币；1：金币；5：银币
		 */		
		private function getCurrency():int {
			var re:int;
			if (_radioBtn4_1.selected && _radioBtn4_2.selected) {
				re = 15;
			} else if (_radioBtn4_1.selected && !_radioBtn4_2.selected) {
				re = 1;
			} else {
				re = 5;
			}
			return re;
		}
		
		private function resizeThis():void {
			if (_line1) {
				_line1.x = 30;
				_line1.y = 20;
			}
			if (_line2) {
				_line2.x = _line1.x + 14;
				_line2.y = _line1.y + _line1.height + 15;
			}
			if (_line3) {
				_line3.x = _line1.x + 28;
				_line3.y = _line2.y + _line2.height + 15;
			}
			if (_line4) {
				_line4.x = _line1.x + 28;
				_line4.y = _line3.y + _line3.height + 15;
				
				if (!_radioBtn4_1.visible) {
					_radioBtn4_2.x = _radioBtn4_1.x;
				} else {
					_line4.update();
				}
			}
			if (_line5) {
				_line5.x = _line1.x;
				_line5.y = _line4.y + _line4.height + 15;
			}
			if (_line6) {
				_line6.x = _line1.x + 28;
				_line6.y = _line5.y + _line5.height + 10;
			}
			if (_line7) {
				_line7.x = _line1.x + 28;
				_line7.y = _line6.y + _line6.height + 15;
			}
			if (_line8) {
				_line8.x = (_w - 150) / 2;
				_line8.y = _line7.y + _line7.height + 20;
			}
		}
		
	}
	
}