package com._17173.flash.core.statemachine
{
	public interface IState
	{
		function added():void;
		function removed():void;
		function enter():void;
		function exit():void;
		function update(delta:Number):void;
		function willInterupt():Boolean;
		function get type():int;
		
		function set owner(stateMachine:IStateMachine):void;
	}
}