package com._17173.flash.player.business.file.queue
{
	import com._17173.flash.core.statemachine.IState;
	import com._17173.flash.core.transactionStatemachine.TranscationStateMachine;
	
	public class FileBusinessControlQueue extends TranscationStateMachine
	{
		public function FileBusinessControlQueue()
		{
			super();
		}
		
		override public function removeState(state:IState):void {
			super.removeState(state);
		}
	}
}