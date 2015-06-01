package com._17173.flash.core.transactionStatemachine
{
	public interface ITransactionState
	{
		function get transcationData():Object;
		function set transcationData(value:Object):void;
	}
}