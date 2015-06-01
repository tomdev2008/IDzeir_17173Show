package com._17173.flash.core.ad.model
{
	import flash.events.Event;
	
	public class AdEvent extends Event
	{
		
		public static const AD_A2_COMPLETE:String = "adA2Complete";
		
		public function AdEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}