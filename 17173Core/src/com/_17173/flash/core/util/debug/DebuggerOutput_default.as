package com._17173.flash.core.util.debug
{
	public class DebuggerOutput_default implements IDebuggerOutput
	{
		public function DebuggerOutput_default()
		{
		}
		
		public function output(info:String):void
		{
			trace(info);
		}
	}
}