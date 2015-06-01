package com._17173.flash.player.module.quiz.ui
{
	import com._17173.flash.core.components.common.Button;
	import com._17173.flash.core.components.common.HGroup;
	import com._17173.flash.core.components.common.Label;
	import com._17173.flash.core.components.common.VGroup;
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.core.util.time.Ticker;
	import com._17173.flash.player.context.ContextEnum;
	import com._17173.flash.player.module.quiz.QuizEvents;
	import com._17173.flash.player.module.quiz.data.QuizData;
	
	import flash.events.MouseEvent;

	/**
	 * 结束竞猜
	 */	
	public class QuizCloseQuziPanel extends QuizBasePanel
	{
		private var _line1:HGroup;
		private var _line2:HGroup;
		private var _line3:VGroup;
		private var _line4:HGroup;
		private var _label1_1:Label;
		private var _label1_2:Label;
		private var _label2_1:Label;
		private var _radioBtn1:QuizRadioBtn;
		private var _radioBtn2:QuizRadioBtn;
		private var _submit:Button;
		private var _cancel:Button;
		private var _currentData:QuizData;
		
		public function QuizCloseQuziPanel()
		{
			super();
			init();
		}
		
		override protected function init():void {
			this.titleStr = "结束竞猜";
			this.title.width = _w;
			super.init();
		}
		
		public function setData(value:Object):void {
			_radioBtn1.selected = false;
			_radioBtn2.selected = false;
			_submit.disabled = true;
			
			_currentData = value as QuizData;
			_label1_2.text = _currentData.title;
			_radioBtn1.label = _currentData.leftTitle;
			_radioBtn2.label = _currentData.rightTitle;
			
			resizeThis();
			startTime();
		}
		
		/**
		 * 30秒倒计时
		 */		
		private function startTime():void {
			Ticker.tick(30000, autoClose);
		}
		
		private function autoClose():void {
			onCloseClick(null);
		}
		
		override protected function drawOther():void {
			initLine1();
			initLine2();
			initLine4();
			
			resizeThis();
		}
		
		private function initLine1():void {
			_line1 = new HGroup();
			_line1.valign = HGroup.TOP;
			
			_label1_1 = new Label();
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
			_label2_1.text = "请选择本次获胜方：";
			_label2_1.width = 140;
			setLabelFormat(_label2_1);
			_line2.addChild(_label2_1);
			
			_line3 = new VGroup();
			_line3.align = VGroup.CENTER;
			_radioBtn1 = new QuizRadioBtn();
			_radioBtn1.addEventListener(MouseEvent.CLICK, rb1ClickHandler);
			_line3.addChild(_radioBtn1);
			
			_radioBtn2 = new QuizRadioBtn();
			_radioBtn2.addEventListener(MouseEvent.CLICK, rb2ClickHandler);
			_line3.addChild(_radioBtn2);
			
			_line2.addChild(_line3);
			
			_container.addChild(_line2);
		}
		
		private function initLine4():void {
			_line4 = new HGroup();
			
			_submit = new Button();
			_submit.setSkin(new quizSubmitBtn())
			_submit.width = 68;
			_submit.height = 28;
			_submit.addEventListener(MouseEvent.CLICK, submitClick);
			_submit.disabled = true;
			_line4.addChild(_submit);
			
			_cancel = new Button();
			_cancel.setSkin(new quizCancelBtn())
			_cancel.width = 68;
			_cancel.height = 28;
			_cancel.addEventListener(MouseEvent.CLICK, cancelClick);
			_line4.addChild(_cancel);
			
			_container.addChild(_line4);
		}
		
		private function cancelClick(evt:MouseEvent):void {
			onCloseClick(null);
		}
		
		private function submitClick(evt:MouseEvent):void {
			var obj:Object = {
				"quizID":_currentData.id,
				"victor":_radioBtn1.selected ? _currentData.leftTitle : _currentData.rightTitle};
			(Context.getContext(ContextEnum.EVENT_MANAGER) as IEventManager).send(QuizEvents.QUIZ_CLOSE_QUIZ_DATA, obj);
			onCloseClick(null);
		}
		
		private function rb1ClickHandler(evt:MouseEvent):void {
			_radioBtn1.selected = true;
			_radioBtn2.selected = false;
			_submit.disabled = false;
		}
		
		private function rb2ClickHandler(evt:MouseEvent):void {
			_radioBtn2.selected = true;
			_radioBtn1.selected = false;
			_submit.disabled = false;
		}
		
		override public function onCloseClick(e:MouseEvent):void {
			Ticker.stop(autoClose);
			closeThis();
		}
		
		private function resizeThis():void {
			if (_line1) {
				_line1.x = (_w - _line1.width) / 2;
				_line1.y = 35;
			}
			if (_line2) {
				_line2.x = _line1.x - 56;
				_line2.y = _line1.y + _line1.height + 20;
			}
			if (_line4) {
				_line4.x = (_w - 150) / 2;
				_line4.y = _line2.y + _line2.height + 55;
			}
		}
	}
}