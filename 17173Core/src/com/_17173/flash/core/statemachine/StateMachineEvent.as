package com._17173.flash.core.statemachine
{
	import flash.events.Event;
	
	public class StateMachineEvent extends Event
	{
		
		public static const STATE_ADDED:String = "stateAdded";
		public static const STATE_REMOVED:String = "stateRemoved";
		public static const STATE_INSERTED:String = "stateInserted";
		public static const STATE_COMPLETED:String = "stateCompleted";
		
		public var state:IState;
		public var index:int;
		
		public function StateMachineEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}