package com._17173.flash.show.base.init.base
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.core.statemachine.State;
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.show.base.context.net.IServiceProvider;
	import com._17173.flash.show.model.CEnum;
	import com._17173.flash.show.model.SEvents;
	
	import flash.utils.getTimer;

	/**
	 * 初始化实例基类.
	 * 每一个需要进入初始化队列的实例都应该继承自该类.
	 *  
	 * @author shunia-17173
	 */	
	public class BaseInit extends State
	{
		
		protected var _s:IServiceProvider = null;
		protected var _e:IEventManager = null;
		protected var _name:String = null;
		protected var _weight:Number = 0;
		
		private var _time:int;
		
		public function BaseInit()
		{
			_s = Context.getContext(CEnum.SERVICE) as IServiceProvider;
			_e = Context.getContext(CEnum.EVENT) as IEventManager;
			super();
		}
		
		protected function get name():String {
			return _name;
		}
		
		protected function get weight():Number {
			return _weight;
		}
		
		override public function enter():void {
			super.enter();
			_time = getTimer();
			//发送初始化的消息
			_e.send(SEvents.FW_INIT_ITEM_START, name);
		}
		
		/**
		 * 当前初始化动作结束后应调用此方法以启动下一个初始化任务. 
		 */		
		protected function complete():void {
			Debugger.log(Debugger.INFO,"[baseInit]",this,"执行时间："+(getTimer()-_time));
			//发送结束的消息
			_e.send(SEvents.FW_INIT_ITEM_COMPLETE, name);
			//发送进度消息
			_e.send(SEvents.FW_INIT_ITEM_PROGRESS, weight);
			//移除当前状态
			if (_owner) {
				_owner.removeState(this);
			}
		}
		
	}
}