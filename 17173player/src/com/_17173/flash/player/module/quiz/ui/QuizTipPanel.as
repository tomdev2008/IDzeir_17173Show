package com._17173.flash.player.module.quiz.ui
{
	import com._17173.flash.core.components.common.Button;
	import com._17173.flash.core.util.Util;
	
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	/**
	 * 竞猜提示页面
	 */	
	public class QuizTipPanel extends QuizBasePanel
	{
		private var _label:TextField;
		private var _label2:TextField;
		private var _labelTf:TextFormat;
		private var _submit:Button;
		
		public function QuizTipPanel()
		{
			super();
			resizeThis();
		}
		
		public function setLabel(value:String, value2:String = ""):void {
			if (value != "") {
				_label.text = value;
			} else {
				_label.text = "对不起，操作失败!";
			}
			if (value2 != "") {
				_label2.visible = true;
				_label2.text = value2;
			}
			resizeThis();
		}
		
		override protected function init():void {
			_w = 465;
			super.init();
			
			this.titleStr = "提示";
			_labelTf = new TextFormat();
			_labelTf.font = Util.getDefaultFontNotSysFont();
			_labelTf.size = 16;
			_labelTf.color = 0xffffff;
			
			_label = new TextField();
			_label.selectable = false;
			_label.autoSize = TextFieldAutoSize.LEFT;
			_label.width = _w;
			_label.defaultTextFormat = _labelTf;
			_label.setTextFormat(_labelTf);
			
			_label2 = new TextField();
			_label2.visible = false;
			_label2.selectable = false;
			_label2.autoSize = TextFieldAutoSize.LEFT;
			_label2.width = _w;
			_label2.defaultTextFormat = _labelTf;
			_label2.setTextFormat(_labelTf);
			
			_submit = new Button();
			_submit.setSkin(new quizSubmitBtn());
			_submit.addEventListener(MouseEvent.CLICK, submitClick);
			_submit.width = 68;
			_submit.height = 28;
			addChild(_submit);
				
			addChild(_label);
			addChild(_label2);
		}
		
		private function submitClick(evt:MouseEvent):void {
			onCloseClick(null);
		}
		
		private function resizeThis():void {
			if (_label2 && _label2.visible) {
				_label.x = (width - _label.textWidth) / 2;
				_label.y = (height - _label.height) / 2 - 20;
				
				_label2.x = (width - _label2.textWidth) / 2;
				_label2.y = _label.y + _label.height + 5;
			} else {
				_label.x = (width - _label.textWidth) / 2;
				_label.y = (height - _label.height) / 2 - 10;
			}
			
			_submit.x = (_w - _submit.width) / 2;
			_submit.y = 195;
		}
	}
}