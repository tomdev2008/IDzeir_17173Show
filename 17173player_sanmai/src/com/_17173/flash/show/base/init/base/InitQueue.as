package com._17173.flash.show.base.init.base
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.core.statemachine.IState;
	import com._17173.flash.core.statemachine.StateMachine;
	import com._17173.flash.show.model.CEnum;
	import com._17173.flash.show.model.SEvents;

	/**
	 * 初始化队列管理类.
	 *  
	 * @author shunia-17173
	 */	
	public class InitQueue extends StateMachine
	{
		
		public function InitQueue()
		{
			super();
		}
		
		override public function removeState(state:IState):void {
			super.removeState(state);
			
			//如果全部移除完毕,发出全部完成事件
			if (_states.length == 0) {
				var e:IEventManager = Context.getContext(CEnum.EVENT) as IEventManager;
				e.send(SEvents.FW_INIT_ALL_COMPLETE);
			}
		}
		
	}
}