package com._17173.flash.player.business.file.queue
{
	import com._17173.flash.core.statemachine.StateMachineEvent;
	import com._17173.flash.core.transactionStatemachine.TranscationState;
	
	import flash.events.Event;
	
	public class FileState extends TranscationState
	{
		public function FileState()
		{
			super();
		}
		
		/**
		 * 当前state执行完毕
		 */		
		public function complete():void {
			if (_owner) {
				_owner.removeState(this);
			} else {
				dispatchEvent(new Event(StateMachineEvent.STATE_REMOVED));
			}
		}
		
	}
}