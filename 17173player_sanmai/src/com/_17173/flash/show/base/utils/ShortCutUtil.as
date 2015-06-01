package com._17173.flash.show.base.utils
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.core.interactive.IKeyboardManager;
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.show.model.CEnum;
	
	import flash.system.System;
	import flash.ui.Keyboard;

	/**
	 * 快捷键注册类.最好所有快捷键相关逻辑都可以脱离业务场景,以不依赖的方式运行.
	 * 
	 * @author 庆峰
	 * 
	 */	
	public class ShortCutUtil
	{
		
		public static function register():void {
			//注册控制台输出快捷键
			var k:IKeyboardManager=Context.getContext(CEnum.KEYBOARD) as IKeyboardManager;
			//ctrl + alt + 1 = 显示log面板
			k.registerKeymap(onShowConsole, Keyboard.CONTROL, Keyboard.ALTERNATE, Keyboard.NUMBER_1);
			//ctrl + alt + 2 = 复制房间id
			k.registerKeymap(onCopyRoomId, Keyboard.CONTROL, Keyboard.ALTERNATE, Keyboard.NUMBER_2);
		}
		
		/**
		 * 显示log面板 
		 */		
		public static function onShowConsole():void {
			(Context.getContext(CEnum.EVENT) as IEventManager).send("onShowConsole");
		}
		
		/**
		 * 复制房间id 
		 */		
		public static function onCopyRoomId():void {
			if (Context.variables["roomId"]) {
				System.setClipboard(Context.variables["roomId"]);
				
				Debugger.log(Debugger.INFO, "[shortcut]", "房间ID已复制!");
			}
		}
		
	}
}