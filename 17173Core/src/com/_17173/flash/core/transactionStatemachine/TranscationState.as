package com._17173.flash.core.transactionStatemachine
{
	import com._17173.flash.core.statemachine.State;

	public class TranscationState extends State implements ITransactionState
	{
		protected var _transcationData:Object;
		
		public function get transcationData():Object {
			return _transcationData;
		}
		
		public function set transcationData(value:Object):void {
			_transcationData = value;
		}
		
	}
}