package com._17173.flash.core.plugin
{
	import flash.events.Event;
	
	public class PluginEvents extends Event
	{
		
		public static const READY:String = "plugin_ready";
		public static const INIT:String = "plugin_init";
		public static const COMPLETE:String = "plugin_complete";
		
		public static const ALL_COMPLETE:String = "plugin_allComplete";
		
		public function PluginEvents(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}