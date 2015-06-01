package com._17173.flash.core.util.debug
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.context.IContextItem;
	import com._17173.flash.core.util.Util;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.system.System;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	
	/**
	 * 控制台显示debug信息.
	 *  
	 * @author shunia-17173
	 */	
	public class Console extends Sprite implements IDebuggerOutput,IContextItem
	{
		
		private static const MAX_MESSAGE_COUNT:int = 1000;
		public static const CONTEXT_NAME:String = "debugger";
		
		private var _len:int = 0;
		
		private var _bg:Sprite = null;
		private var _label:TextField = null;
		/**
		 * 关闭按钮 
		 */		
		private var _close:DisplayObject = null;
		/**
		 * 清空按钮 
		 */		
		private var _clear:DisplayObject = null;
		
		public function Console()
		{
			super();
			_bg = new Sprite();
			var fmt:TextFormat = new TextFormat(Util.getDefaultFontNotSysFont(), 12, 0xFFFFFF);
			_label = new TextField();
			_label.defaultTextFormat = fmt;
			_label.width = Context.stage.stageWidth;
			_label.height = Context.stage.stageHeight;
			_label.multiline = true;
			_label.selectable = true;
			_label.wordWrap = true;
//			_label.autoSize = TextFieldAutoSize.LEFT;
			_label.addEventListener(MouseEvent.CLICK, onSelectAll);
			_close = createClsBtn();
			_close.addEventListener(MouseEvent.CLICK, onClose);
			_clear = createClearBtn();
			_clear.addEventListener(MouseEvent.CLICK, onClear);
			
			addChild(_bg);
			addChild(_label);
			addChild(_close);
			addChild(_clear);
			
			_len = 0;
			
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
			addEventListener(MouseEvent.MOUSE_WHEEL, onWheel);
			addEventListener(KeyboardEvent.KEY_UP, onKey);
			Context.stage.addEventListener(Event.RESIZE, onResize);
			startUp(null);
		}
		
		protected function onClear(event:Event):void {
			clearContent();
		}
		
		protected function onKey(event:KeyboardEvent):void {
			if (event.ctrlKey && event.keyCode == Keyboard.D) {
				clearContent();
			}
		}
		
		protected function onWheel(event:MouseEvent):void {
			var d:int = _label.scrollV + event.delta;
			if (d < 1) {
				d = 1;
			} else if (d > _label.maxScrollV) {
				d = _label.maxScrollV;
			}
			_label.scrollV = d;
		}
		
		protected function onClose(event:MouseEvent):void {
			if (parent && parent.contains(this)) {
				parent.removeChild(this);
			}
		}
		
		protected function onAdded(event:Event):void {
			onSelectAll(null);
			onResize();
		}
		
		protected function onSelectAll(event:MouseEvent):void {
			_label.setSelection(0, _label.text.length);
			if (event) {
				System.setClipboard(_label.text);
			}
		}
		
		private function clearContent():void {
			_label.text = "";
		}
		
		public function output(info:String):void {
			_len ++;
			//大于500条直接全干掉
			if (_len >= MAX_MESSAGE_COUNT) {
				_len = 0;
				clearContent();
			}
			onRender(info);
//			_label.setSelection(_label.htmlText.length - 1, _label.htmlText.length);
		}
		
		private function onRender(data:Object):void {
//			_label.htmlText += data;
			_label.appendText(data as String);
		}
		
		private function onResize(e:Object = null):void
		{
			if (_label) {
				_label.width = Context.stage.stageWidth;
				_label.height = Context.stage.stageHeight;
			}
			if(_bg && contains(_bg))
			{
				_bg.graphics.clear();
				_bg.graphics.beginFill(0, 0.7);
				_bg.graphics.drawRect(0, 0, Context.stage.stageWidth, Context.stage.stageHeight);
				_bg.graphics.endFill();
			}
			if(_close && contains(_close))
			{
				_close.x = Context.stage.stageWidth - _close.width;
				_close.y = 0;
			}
			if (_clear && contains(_clear)) {
				_clear.x = Context.stage.stageWidth - 40 - _clear.width;
				_clear.y = 0;
			}
		}
		
		private function onShow(data:Object):void {
			Context.stage.addChild(this);
		}
		
		private function createClearBtn():DisplayObject {
			var b:Sprite = new Sprite();
			b.buttonMode = true;
			b.useHandCursor = true;
			
			b.graphics.beginFill(0x333333, 1);
			b.graphics.drawRect(0, 0, 30, 30);
			b.graphics.endFill();
			b.graphics.lineStyle(3, 0xFFFFFF, 1);
			b.graphics.moveTo(3, 3);
			b.graphics.lineTo(27, 3);
			b.graphics.lineTo(27, 27);
			b.graphics.lineTo(3, 27);
			b.graphics.lineTo(3, 3);
			b.graphics.endFill();
			
			return b;
		}
		
		private function createClsBtn():DisplayObject {
			var b:Sprite = new Sprite();
			b.buttonMode = true;
			b.useHandCursor = true;
			
			b.graphics.beginFill(0x333333, 1);
			b.graphics.drawRect(0, 0, 30, 30);
			b.graphics.lineStyle(3, 0xFFFFFF, 1);
			b.graphics.moveTo(3, 3);
			b.graphics.lineTo(27, 27);
			b.graphics.moveTo(27, 3);
			b.graphics.lineTo(3, 27);
			b.graphics.endFill();
			
			return b;
		}
		
		public function get contextName():String {
			return CONTEXT_NAME;
		}
		
		public function startUp(param:Object):void {
			Context.getContext("eventManager").listen("onShowConsole", onShow);
		}
	}
}