package com._17173.flash.core.transactionStatemachine
{
	import com._17173.flash.core.statemachine.IState;
	import com._17173.flash.core.statemachine.StateMachine;
	import com._17173.flash.core.statemachine.StateMachineEvent;
	
	public class TranscationStateMachine extends StateMachine implements ITransactionStateMachine
	{
		private var _transcationData:Object = {};
		
		public function TranscationStateMachine()
		{
			super();
		}
		override public function addState(state:IState, queue:Boolean = true):void {
			(state as ITransactionState).transcationData = _transcationData;
			super.addState(state, queue);
		}
		
		/**
		 * 覆写基类,将transcationData参数传入
		 */		
		override public function insertState(base:IState, target:IState, isLeft:Boolean=false):void {
			var index:int = _states.indexOf(base);
			if (index > -1) {
				target.owner = this;
				(target as ITransactionState).transcationData = _transcationData;
				if (!isLeft) {
					index += 1;
				}
				target.added();
				_states.splice(index, 0, target);
				
				notify(StateMachineEvent.STATE_INSERTED, target, index);
				
				if (currentState == target) {
					target.enter();
				}
			}
		}

		public function get transcationData():Object
		{
			return _transcationData;
		}

		public function set transcationData(value:Object):void
		{
			_transcationData = value;
		}

	}
}