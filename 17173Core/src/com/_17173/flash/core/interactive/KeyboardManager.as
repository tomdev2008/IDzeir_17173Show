package com._17173.flash.core.interactive
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.context.IContextItem;
	import com._17173.flash.core.util.time.Ticker;
	
	import flash.events.EventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.ui.Keyboard;

	/**
	 * 键盘管理类. 
	 * @author shunia-17173
	 */	
	public class KeyboardManager extends EventDispatcher implements IContextItem, IKeyboardManager
	{
		
		public static const CONTEXT_NAME:String = "keyboardManager";
		
		private var _registerdKeymap:Array = null;
		private var _enable:Boolean = true;
		
		public function KeyboardManager()
		{
		}
		
		protected function onChangeFocus():void {
			if (Context.stage.focus is TextField) return;
			if (Context.stage.focus == Context.stage) return;
			
			Context.stage.focus = Context.stage;
		}
		
		public function registerKeymap(callback:Function, ...keys):void {
			_registerdKeymap.push({"key":keys, "callback":callback});
		}
		
		protected function onKeyUp(event:KeyboardEvent):void {
			if (!enable) {
				return;
			}
			//针对输入框做处理,不处理事件
			if (event.target is TextField) {
				var tf:TextField = event.target as TextField;
				if (tf.type == TextFieldType.INPUT) {
					return;
				}
			}
				
			for each (var keysComb:Object in _registerdKeymap) {
				var succ:Boolean = true;
				for each (var key:uint in keysComb["key"]) {
					if (!matchKey(key, event)) {
						succ = false;
						break;
					}
				}
				//匹配成功并且有回调则进行调用
				if (succ && keysComb.callback) {
					(keysComb.callback as Function).apply(null, null);
				}
			}
		}
		
		/**
		 * 是否匹配单个key
		 *  
		 * @param registerdKey
		 * @param keyEvent
		 * @return 
		 */		
		private function matchKey(registerdKey:uint, keyEvent:KeyboardEvent):Boolean {
			if (registerdKey == Keyboard.CONTROL && keyEvent.ctrlKey) {
				return true;
			} else if (registerdKey == Keyboard.SHIFT && keyEvent.shiftKey) {
				return true;
			} else if (registerdKey == Keyboard.ALTERNATE && keyEvent.altKey) {
				return true;
			} else if (registerdKey == keyEvent.keyCode) {
				return true;
			}
			return false;
		}

		public function get enable():Boolean
		{
			return _enable;
		}

		public function set enable(value:Boolean):void
		{
			_enable = value;
		}

		public function get contextName():String
		{
			return CONTEXT_NAME;
		}
		
		public function startUp(param:Object):void
		{
			//监听键盘事件用以转发
			Context.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			Ticker.tick(1, onChangeFocus, 0, true);
			_registerdKeymap = [];
		}
		
	}
}