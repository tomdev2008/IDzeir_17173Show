package com._17173.flash.core.statemachine
{
	import flash.events.IEventDispatcher;
	
	public interface IStateMachine extends IEventDispatcher
	{
		function addState(state:IState, queue:Boolean = true):void;
		function removeState(state:IState):void;
		function insertState(base:IState, target:IState, isLeft:Boolean = false):void;
		function popState():void;
		function get currentState():IState;
		function cleanUp():void;
	}
}