package com._17173.flash.core.util.debug
{
	import flash.events.DataEvent;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class DebuggerOutPut_videoPanel extends EventDispatcher implements IDebuggerOutput
	{
		public function DebuggerOutPut_videoPanel(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		public function output(info:String):void
		{
			var e:DataEvent = new DataEvent("debugPanel", true, true);
			e.data = info;
			dispatchEvent(e);
		}
	}
}