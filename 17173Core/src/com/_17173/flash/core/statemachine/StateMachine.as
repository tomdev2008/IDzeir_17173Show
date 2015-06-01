package com._17173.flash.core.statemachine
{
	import flash.events.EventDispatcher;

	/**
	 * 简单状态机.
	 *  
	 * @author shunia-17173
	 */	
	public class StateMachine extends EventDispatcher implements IStateMachine
	{
		
		protected var _states:Vector.<IState>;
		
		public function StateMachine()
		{
			_states = new Vector.<IState>();
		}
		
		public function addState(state:IState, queue:Boolean = true):void {
			state.owner = this;
			state.added();
			if (queue) {
				_states.push(state);
				if (currentState == state) {
					state.enter();
				}
			} else {
				if (state.willInterupt()) {
					if (currentState != null) {
						removeState(currentState);
					}
					_states.unshift(state);
					state.enter();
				} else {
					if (_states.length > 0) {
						_states.splice(0, 0, state);
					} else {
						_states.unshift(state);
						state.enter();
					}
				}
			}
			notify(StateMachineEvent.STATE_ADDED, state);
		}
		
		public function removeState(state:IState):void {
			state.exit();
			var stateIndex:int = _states.indexOf(state);
			if (stateIndex > -1) {
				_states.splice(stateIndex, 1);
				state.removed();
				
				notify(StateMachineEvent.STATE_REMOVED, state);
				if (currentState) {
					currentState.enter();
				} else {
					notify(StateMachineEvent.STATE_COMPLETED);
				}
			}
		}
		
		public function insertState(base:IState, target:IState, isLeft:Boolean = false):void {
			var index:int = _states.indexOf(base);
			if (index > -1) {
				target.owner = this;
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
		
		public function popState():void {
			if (_states && _states.length > 0) {
				var state:IState = _states.shift();
				state.exit();
				state.removed();
				if (currentState) {
					currentState.enter();
				} else {
					notify(StateMachineEvent.STATE_COMPLETED);
				}
			}
		}
		
		public function get currentState():IState {
			if (_states && _states.length > 0) {
				return _states[0];
			}
			return null;
		}
		
		public function cleanUp():void {
			while (currentState != null) {
				currentState.exit();
				currentState.removed();
				_states.shift();
			}
			
			_states = new Vector.<IState>();
		}
		
		protected function notify(type:String, state:IState = null, index:int = -1):void {
			var e:StateMachineEvent = new StateMachineEvent(type);
			e.state = state;
			e.index = index;
			dispatchEvent(e);
		}
		
	}
}