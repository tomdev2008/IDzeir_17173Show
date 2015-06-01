package com._17173.flash.player.business.file.queue
{
	import com._17173.flash.core.statemachine.StateMachineEvent;
	import com._17173.flash.core.transactionStatemachine.TranscationState;
	
	import flash.events.Event;
	
	public class ParallelState extends FileState
	{
		private var _items:Array;
		private var _completeNum:int = 0;
		
		public function ParallelState()
		{
			super();
			_completeNum = 0;
		}
		
		public function addItems(items:Array = null):void {
			cleanItems();
			if (items) {
				_items = items;
			}
		}
		
		private function cleanItems():void {
			_items = [];
		}
		
		override public function added():void {
			for (var i:int = 0; i < _items.length; i++) {
				var tempItem:TranscationState = _items[i] as TranscationState;
				tempItem.addEventListener(StateMachineEvent.STATE_REMOVED, itemComplete);
				tempItem.transcationData = this.transcationData;
				tempItem.added();
			}
		}
		
		override public function enter():void {
			for (var i:int = 0; i < _items.length; i++) {
				var tempItem:TranscationState = _items[i] as TranscationState;
				tempItem.enter();
			}
		}
		
		protected function itemComplete(evt:Event):void {
			_completeNum++;
			if (_completeNum == _items.length) {
				complete();
			}
		}
	}
}