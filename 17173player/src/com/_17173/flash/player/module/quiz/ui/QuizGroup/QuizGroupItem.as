package com._17173.flash.player.module.quiz.ui.QuizGroup
{
	import com._17173.flash.core.components.common.Button;
	import com._17173.flash.core.components.common.Label;
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.core.util.Util;
	import com._17173.flash.player.context.ContextEnum;
	import com._17173.flash.player.module.quiz.QuizEvents;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class QuizGroupItem extends Sprite
	{
		private var _data:Array;
		private var _tf:TextFormat;
		private var _label1:Label;
		private var _label2:Label;
		private var _label3:Label;
		private var _label4:Label;
		private var _bg1:Sprite;
		private var _bg2:Sprite;
		private var _bg3:Sprite;
		private var _bg4:Sprite;
		private var _bg5:Sprite;
		private var _stopBtn:Button;
		private var _showBtn:Boolean;
		private var _rowArr:Array = [88, 88, 162, 68, 106];
		private var _w:int;
		private var _h:int;
		
		public function QuizGroupItem(data:Array, w:int, needBtn:Boolean = false)
		{
			super();
			_data = data;
			_w = w;
			_showBtn = needBtn;
			init();
			resize();
		}
		
		private function init():void {
			graphics.clear();
			graphics.beginFill(0, 0);
			graphics.drawRect(0, 0, _w, _h);
			graphics.endFill();
			
			if (!_tf) {
				_tf = new TextFormat();
				_tf.size = 14;
				_tf.color = 0xffffff;
				_tf.font = Util.getDefaultFontNotSysFont();
			}
			if (!_label1) {
				_label1 = new Label();
				setLabelFormat(_label1);
				_label1.text = _data[0];
				_bg1 = getBG(_rowArr[0], _label1.height);
				_bg1.addChild(_label1);
				_label1.x = (_bg1.width - _label1.width) / 2;
				addChild(_bg1);
			}
			if (!_label2) {
				_label2 = new Label();
				setLabelFormat(_label2);
				_label2.text = _data[1];
				_label2.width = _rowArr[1];
				_bg2 = getBG(_rowArr[1], _label2.height);
				_bg2.addChild(_label2);
				_label2.x = (_bg2.width - _label2.width) / 2;
				addChild(_bg2);
			}
			if (!_label3) {
				_label3 = new Label();
				setLabelFormat(_label3);
				_label3.text = _data[2] ? _data[2] : "";
				_label3.width = _rowArr[2];
				_bg3 = getBG(_rowArr[2], _label3.height);
				_bg3.addChild(_label3);
				_label3.x = (_bg3.width - _label3.width) / 2;
				addChild(_bg3);
			}
			if (!_label4) {
				_label4 = new Label();
				setLabelFormat(_label4);
				_label4.text = _data[3];
				_label4.width = _rowArr[3];
				_bg4 = getBG(_rowArr[3], _label4.height);
				_bg4.addChild(_label4);
				_label4.x = (_bg4.width - _label4.width) / 2;
				addChild(_bg4);
			}
			if (_showBtn) {
				_stopBtn = new Button();
				_stopBtn.setSkin(new quizStopDealer());
				_stopBtn.addEventListener(MouseEvent.CLICK, stopClickHandler);
				_stopBtn.width = 46;
				_stopBtn.height = 24;
				addChild(_stopBtn);
			}
		}
		
		private function getBG(w:int, h:int):Sprite {
			var sp:Sprite = new Sprite();
			sp.graphics.clear();
			sp.graphics.beginFill(0, 0);
			sp.graphics.drawRect(0, 0, w, h);
			sp.graphics.endFill();
			return sp;
		}
		
		/**
		 * 格式化label
		 */		
		private function setLabelFormat(value:Label):void {
			var tempTF:TextFormat;
			value.selectable = false;
			tempTF = _tf;
			value.autoSize = TextFieldAutoSize.LEFT;
			value.defaultTextFormat = tempTF;
			value.setTextFormat(tempTF);
		}
		
		/**
		 * 派发关闭当前庄事件
		 */		
		private function stopClickHandler(evt:MouseEvent):void {
			var obj:Object = {};
			obj["id"] = _data[4];
			obj["dis"] = _stopBtn;
			(Context.getContext(ContextEnum.EVENT_MANAGER) as IEventManager).send(QuizEvents.QUZI_SHOW_STOP_DEALER_CONFIRM, obj);
		}
		
		public function resize():void {
			var item:DisplayObject;
			var temp:int = 0;
			for (var i:int = 0; i < this.numChildren; i++) {
				item = this.getChildAt(i);
				item.x = temp;
				temp = item.x + item.width;
			}
			if (_stopBtn) {
				_stopBtn.x = 436;
				_stopBtn.y = 1;
			}
		}
		
	}
}