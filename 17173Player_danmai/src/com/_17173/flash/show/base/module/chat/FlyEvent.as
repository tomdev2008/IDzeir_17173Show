package com._17173.flash.show.base.module.chat
{
	import flash.events.Event;
	
	public class FlyEvent extends Event
	{
		public static const FLY_SEND:String = "flySend";
		
		public var flyId:*;
		
		public function FlyEvent(type:String, fid:* = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			flyId = fid;
		}
	}
}