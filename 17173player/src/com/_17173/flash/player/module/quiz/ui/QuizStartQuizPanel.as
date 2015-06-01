package com._17173.flash.player.module.quiz.ui
{
	import com._17173.flash.core.components.common.Button;
	import com._17173.flash.core.components.common.HGroup;
	import com._17173.flash.core.components.common.Label;
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.core.util.Util;
	import com._17173.flash.player.context.ContextEnum;
	import com._17173.flash.player.module.quiz.QuizEvents;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	
	/**
	 * 开启竞猜界面
	 * @author 安庆航
	 * 
	 */	
	public class QuizStartQuizPanel extends QuizBasePanel
	{
		private var _line1:HGroup;
		private var _line2:HGroup;
		private var _line3:HGroup;
		private var _line4:HGroup;
		private var _label1_1:Label;
		private var _label1_2:Label;
		private var _label1_3:Label;
		private var _label2_1:Label;
		private var _label2_2:Label;
		private var _label2_3:Label;
		private var _label2_4:Label;
		private var _label3_1:Label;
		private var _label3_2:Label;
		private var _radioLable3_1:QuizCheckBox;
		private var _radioLable3_2:QuizCheckBox;
		private var _submit:Button;
		private var _cancel:Button;
		private var _hasTitle:Boolean;
		private var _hasLeftTitle:Boolean;
		private var _hasRightTitle:Boolean;
		private var _hasCurrency:Boolean;
		private var _sameTitle:Boolean;
		
		public function QuizStartQuizPanel()
		{
			super();
		}
		
		override protected function init():void {
			super.init();
			this.titleStr = "竞猜设置";
		}
		
		/**
		 * 初始化内容
		 */		
		public function initValue():void {
			if (_label1_2) {
				_label1_2.text = "";
			}
			if (_label2_2) {
				_label2_2.text = "";
			}
			if (_label2_3) {
				_label2_3.text = "";
			}
			if (_radioLable3_1) {
				_radioLable3_1.selected = false;
			}
			if (_radioLable3_2) {
				_radioLable3_2.selected = false;
			}
			if (_submit) {
				_submit.disabled = true;
			}
			_label2_4.visible = false;
			_sameTitle = true;
			_hasTitle = false;
			_hasLeftTitle = false;
			_hasRightTitle = false;
			_hasCurrency = false;
			_line3.update();
		}
		
		/**
		 * 画背景、初始化组件
		 */		
		override protected function drawOther():void {
			initLine1();
			initLine2();
			initLine3();
			initLine4();
			
			resizeThis();
		}
		
		/**
		 * 初始化第一行
		 */		
		private function initLine1():void {
			_line1 = new HGroup();
			_line1.gap = 2;
			_line1.valign = HGroup.MIDDLE;
			
			_label1_1 = new Label();
			_label1_1.text = "主题：";
			setLabelFormat(_label1_1);
			_line1.addChild(_label1_1);
			
			_label1_2 = new Label();
			setLabelFormat(_label1_2, true);
			_label1_2.addEventListener(Event.CHANGE, titleLabelHandler);
			_label1_2.maxChars = 10;
			_label1_2.addEventListener(TextEvent.TEXT_INPUT, titleInputHandler);
			_label1_2.height = 30;
			_label1_2.width = 160;
			var lb:QuizTextBG = new QuizTextBG(160, 30);
			lb.addItem(_label1_2);
			_line1.addChild(lb);
			
			_label1_3 = new Label({"maxW":150});
			_label1_3.text = "(最多可输入10个字)";
			_label1_3.width = 150;
			setLabelFormat(_label1_3);
			_line1.addChild(_label1_3);
			
			_container.addChild(_line1);
		}
		
		/**
		 * 初始化第二行
		 */	
		private function initLine2():void {
			_line2 = new HGroup();
			_line2.valign = HGroup.MIDDLE;
			_line2.gap = 2;
			
			_label2_1 = new Label();
			_label2_1.text = "竞猜条件：";
			setLabelFormat(_label2_1);
			_label2_1.width = 85;
			_line2.addChild(_label2_1);
			
			_label2_2 = new Label();
			setLabelFormat(_label2_2, true);
			_label2_2.addEventListener(Event.CHANGE, leftTitleLabelHandler);
			_label2_2.addEventListener(TextEvent.TEXT_INPUT, titleInputHandler);
			_label2_2.maxChars = 10;
			_label2_2.height = 30;
			_label2_2.width = 110;
			var lb:QuizTextBG = new QuizTextBG(110, 30);
			lb.addItem(_label2_2);
			_line2.addChild(lb);
			
			var vs:Label = new Label();
			vs.text = "vs";
			vs.textColor = 0xffffff;
			setLabelFormat(_label2_1);
			_line2.addChild(vs);
			
			_label2_3 = new Label();
			setLabelFormat(_label2_3, true);
			_label2_3.addEventListener(Event.CHANGE, rightTitleLabelHandler);
			_label2_3.addEventListener(TextEvent.TEXT_INPUT, titleInputHandler);
			_label2_3.maxChars = 10;
			_label2_3.height = 30;
			_label2_3.width = 110;
			var lb2:QuizTextBG = new QuizTextBG(110, 30);
			lb2.addItem(_label2_3);
			_line2.addChild(lb2);
			
			_label2_4 = new Label();
			setLabelFormat(_label2_4);
			_label2_4.text = "条件重复";
			_label2_4.textColor = 0xFF0000;
			_label2_4.width = 200;
			_label2_4.visible = false;
			_line2.addChild(_label2_4);
			
			_container.addChild(_line2);
		}
		
		/**
		 * 初始化第三行
		 */	
		private function initLine3():void {
			_line3 = new HGroup();
			_line3.valign = HGroup.MIDDLE;
			_line3.gap = 5;
			
			_label3_1 = new Label();
			_label3_1.text = "竞猜类型：";
			setLabelFormat(_label3_1);
			_label3_1.width = 85;
			_line3.addChild(_label3_1);
			
			_radioLable3_1 = new QuizCheckBox();
			_radioLable3_1.label = "金币";
			_radioLable3_1.addEventListener(MouseEvent.CLICK, currencyClickHandler);
			_radioLable3_1.width = 55;
			_radioLable3_1.height = 18;
			_line3.addChild(_radioLable3_1);
			
			_radioLable3_2 = new QuizCheckBox();
			_radioLable3_2.label = "银币";
			_radioLable3_2.addEventListener(MouseEvent.CLICK, currencyClickHandler);
			_line3.addChild(_radioLable3_2);
			_radioLable3_2.width = 55;
			_radioLable3_2.height = 18;
			
			_label3_2 = new Label({"maxW":160});
			setLabelFormat(_label3_2);
			_label3_2.text = "(此次竞猜支持的币种)";
			_label3_2.width = 160;
			_line3.addChild(_label3_2);
			_line3.update();
			
			_container.addChild(_line3);
		}
		
		/**
		 * 初始化第四行
		 */	
		private function initLine4():void {
			_line4 = new HGroup();
			_line4.gap = 10;
			
			_submit = new Button();
			_submit.setSkin(new quizSubmitBtn());
			_submit.width = 68;
			_submit.height = 28;
			_submit.addEventListener(MouseEvent.CLICK, submitClick);
			_submit.disabled = true;
			_line4.addChild(_submit);
			
			_cancel = new Button();
			_cancel.setSkin(new quizCancelBtn());
			_cancel.width = 68;
			_cancel.height = 28;
			_cancel.addEventListener(MouseEvent.CLICK, cancelClick);
			_line4.addChild(_cancel);
			
			_container.addChild(_line4);
		}
		
		/**
		 * 标题中有输入操作
		 */		
		private function titleLabelHandler(evt:Event):void {
			var temp:String = Util.trimStr(_label1_2.text);
			if (temp.length > 0) {
				_hasTitle = true;
			} else {
				_hasTitle = false;
			}
			resetSubmitState();
		}
		
		private function titleInputHandler(evt:TextEvent):void {
			//限制不可输入特殊字符
			var myPattern:RegExp = /^([\u4e00-\u9fa5]+|[a-zA-Z0-9]+)$/;
			if (myPattern.test(evt.text)) {
				
			} else {
				evt.preventDefault();
			}
		}
		
		/**
		 * 左边条件有输入操作
		 */		
		private function leftTitleLabelHandler(evt:Event):void {
			var temp:String = Util.trimStr(_label2_2.text);
			if (temp.length > 0) {
				_hasLeftTitle = true;
			} else {
				_hasLeftTitle = false;
			}
			checkSameTitle();
			resetSubmitState();
		}
		
		/**
		 * 右边条件有输入操作
		 */		
		private function rightTitleLabelHandler(evt:Event):void {
			var temp:String = Util.trimStr(_label2_3.text);
			if (temp.length > 0) {
				_hasRightTitle = true;
			} else {
				_hasRightTitle = false;
			}
			checkSameTitle();
			resetSubmitState();
		}
		
		/**
		 * 检查胜利条件是否一样
		 */		
		private function checkSameTitle():void {
			if (_label2_2.text == _label2_3.text) {
				_sameTitle = true;
			} else {
				_sameTitle = false;
			}
			_label2_4.visible = _sameTitle;
		}
		
		/**
		 * 货币类型操作
		 */		
		private function currencyClickHandler(evt:MouseEvent):void {
			if (!_radioLable3_1.selected && !_radioLable3_2.selected) {
				_hasCurrency = false;
			} else {
				_hasCurrency = true;
			}
			resetSubmitState();
		}
		
		/**
		 * 当前所有都输入，确定按钮才可用
		 */		
		private function resetSubmitState():void {
			if (_hasTitle && _hasLeftTitle && _hasRightTitle && _hasCurrency && !_sameTitle) {
				_submit.disabled = false;
			} else {
				_submit.disabled = true;
			}
//			_submit.disabled = false;
		}
		
		/**
		 * 布局页面
		 */		
		public function resizeThis():void {
			if (_line1) {
				_line1.x = (_w - _line1.width) / 2;
				_line1.y = 30;
			}
			if (_line2) {
				_line2.x = _line1.x - 28;
				_line2.y = _line1.y + _line1.height + 10;
			}
			if (_line3) {
				_line3.x = _line2.x;
				_line3.y = _line2.y + _line2.height + 10;
			}
			if (_line4) {
				_line4.x = (_w - 150) / 2;
				_line4.y = _line3.y + _line3.height + 25;
			}
		}
		
		private function cancelClick(evt:MouseEvent):void {
			onCloseClick(null);
		}
		
		private function submitClick(evt:MouseEvent):void {
			var obj:Object = {
				"roomID":Context.variables["roomID"],
				"title":Util.trimStr(_label1_2.text),
				"leftTitle":Util.trimStr(_label2_2.text),
				"rightTitle":Util.trimStr(_label2_3.text),
				"currency":getCurrency()};
			(Context.getContext(ContextEnum.EVENT_MANAGER) as IEventManager).send(QuizEvents.QUIZ_ADD_QUIZ_DATA, obj);
			onCloseClick(null);
		}
		
		/**
		 * 15:金币+银币；1：金币；5：银币
		 */		
		private function getCurrency():int {
			var re:int;
			if (_radioLable3_1.selected && _radioLable3_2.selected) {
				re = 15;
			} else if (_radioLable3_1.selected && !_radioLable3_2.selected) {
				re = 1;
			} else {
				re = 5;
			}
			return re;
		}
		
		override protected function closeThis():void {
			Context.getContext(ContextEnum.UI_MANAGER).closePopup(this);
//			Context.stage.removeChild(this);
		}
		
	}
	
}