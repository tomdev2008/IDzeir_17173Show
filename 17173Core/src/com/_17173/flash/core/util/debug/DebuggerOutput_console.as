package com._17173.flash.core.util.debug
{
	import com._17173.flash.core.util.JSBridge;

	public class DebuggerOutput_console implements IDebuggerOutput
	{
		
		public function DebuggerOutput_console()
		{
			super();
		}
		
		public function output(info:String):void {
			JSBridge.addCall("log", info, "console");
		}
		
	}
}