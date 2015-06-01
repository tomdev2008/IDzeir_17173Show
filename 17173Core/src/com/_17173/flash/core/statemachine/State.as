package com._17173.flash.core.statemachine
{
	import flash.events.EventDispatcher;

	public class State extends EventDispatcher implements IState
	{
		
		protected var _owner:IStateMachine;
		
		public function State()
		{
		}
		
		public function added():void
		{
		}
		
		public function removed():void
		{
		}
		
		public function enter():void
		{
		}
		
		public function exit():void
		{
		}
		
		public function update(delta:Number):void {
			
		}
		
		public function get type():int {
			return -1;
		}
		
		public function willInterupt():Boolean {
			return false;
		}
		
		public function set owner(value:IStateMachine):void {
			_owner = value;
		}
	}
}