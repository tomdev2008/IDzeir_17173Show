package com._17173.flash.player.module.quiz.ui
{
	import com._17173.flash.core.components.common.Button;
	import com._17173.flash.core.components.common.Label;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class QuizTipWithBtnPanel extends QuizBasePanel
	{
		private var _label1:Label;
		private var _label2:Label;
		private var _label3:Label;
		private var _labeleC:Sprite;
		private var _submit:Button;
		private var _url:String;
		
		public function QuizTipWithBtnPanel()
		{
			super();
		}
		
		override protected function init():void {
			this.titleStr = "提示";
			_w = 286;
			_h = 260;
			super.init();
		}
		
		public function setData(value:String):void {
			_url = value;
		}
		
		override protected function drawOther():void {
			initLine1();
			initLine2();
			initLine3();
			initLine4();
			
			resizeThis();
		}
		
		private function initLine1():void {
			_label1 = new Label({"maxW":300});
			_label1.text = "对不起，只有签约主播才可开启竞猜！";
			_label1.width = 300;
			setLabelFormat(_label1);
			addChild(_label1);
		}
		
		private function initLine2():void {
			_label2 = new Label({"maxW":300});
			_label2.text = "等什么，赶紧去签约吧！";
			_label2.width = 300;
			setLabelFormat(_label2);
			addChild(_label2);
		}
		
		private function initLine3():void {
			_labeleC = new Sprite();
			_labeleC.buttonMode = true;
			_labeleC.mouseChildren = false;
			_labeleC.mouseEnabled = true;
			addChild(_labeleC);
			_label3 = new Label({"maxW":140});
			_label3.text = "申请签约";
			setLabelFormat(_label3);
			_label3.textColor = 0x007eff;
//			_labeleC.addChild(_label3);
		}
		
		private function initLine4():void {
			_submit = new Button();
			_submit.setSkin(new quizKnow());
			_submit.width = 70;
			_submit.height = 22;
			_submit.addEventListener(MouseEvent.CLICK, submitClick);
			addChild(_submit);
		}
		
		protected function submitClick(event:MouseEvent):void
		{
			onCloseClick(null);
		}
		
		public function resizeThis():void {
			if (_label1) {
				_label1.x = (_w - _label1.width) / 2;
				_label1.y = 60;
			}
			if (_label2) {
				_label2.x = _label1.x;
				_label2.y = _label1.y + _label1.height;
			}
			if (_label3) {
				_label3.x = (_w - _label3.width) / 2;
				_label3.y = _label2.y + _label2.height + 50;
			}
			if (_submit) {
				_submit.x = (_w - _submit.width) / 2;
				_submit.y = _h - _submit.height - 40;
			}
		}
		
	}
}