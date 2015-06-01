package com._17173.flash.show.base.init
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.core.statemachine.StateMachineEvent;
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.show.base.init.base.InitQueue;
	import com._17173.flash.show.base.utils.ShortCutUtil;
	import com._17173.flash.show.model.CEnum;
	import com._17173.flash.show.model.SEvents;
	
	import flash.events.Event;

	/**
	 * 业务配置层.也是一个模块.
	 * 
	 * 负责跟业务相关联的启动逻辑.
	 * 比如新增的模块引入.
	 * 
	 * 时序是先解析公用数据,连接socket,,然后通过代理类加载各个模块
	 *  
	 * @author shunia-17173
	 */	
	public class MCfg
	{
		
		/**
		 * 初始化队列 
		 */		
		private var _queue:InitQueue = null;

		private var _e:IEventManager;
		
		public function MCfg()
		{
			_e = Context.getContext(CEnum.EVENT);
			_queue = new InitQueue();
			_queue.addEventListener(StateMachineEvent.STATE_COMPLETED, onInitComplete);
			_e.listen(SEvents.APP_LOAD_SUBDELEGATE,onLoadSub);
			_e.listen(SEvents.FW_INIT_ALL_COMPLETE,secondInit);
			//注册快捷键
			ShortCutUtil.register();
			//初始化各个步骤
			init();
			
//			Ticker.tick(25000,onLoadSub);
		}
		
		protected function init():void {
			Debugger.log(Debugger.INFO, "[cfg]", "启动业务逻辑初始化!");
			//按顺序初始化业务逻辑
			//这里可以优化，先请求gslb拉流
			//Preloader
			_queue.addState(new InitPreloader());
			//配置文件,语言包,场景配置
			_queue.addState(new InitConfig());
			//房间数据
			_queue.addState(new InitRoom());
			//启动业务模块
			_queue.addState(new InitModules());
			//加载房间状态
			_queue.addState(new InitRoomStatus());
			
		}
		
		protected function secondInit(value:* = null):void
		{
			_e.remove(SEvents.FW_INIT_ALL_COMPLETE,secondInit);
			//socket服务器
			_queue.addState(new InitSocket());
			//登陆房间
			_queue.addState(new InitEnterRoom());
			//最后一步检查所有逻辑是否都通过
			_queue.addState(new InitComplete());
		}
		
		/**
		 * 初始化时序结束.
		 *  
		 * @param event
		 */		
		protected function onInitComplete(event:Event):void {
			Debugger.log(Debugger.INFO, "[cfg]", "业务逻辑初始化结束!");
			
			_queue.removeEventListener(StateMachineEvent.STATE_COMPLETED, onInitComplete);
			
			var e:IEventManager = Context.getContext(CEnum.EVENT) as IEventManager;
			//广播
			e.send(SEvents.APP_INIT_COMPLETE);
			//重连
			e.listen(SEvents.FW_SOCKET_HANDING, function(value:*):void {
				Debugger.log(Debugger.INFO, "[cfg]", "重新获取token并尝试重新发送握手消息！");
				//清除上一次的状态机状态
				_queue.cleanUp();
				//重取token
				_queue.addState(new RetryInitRoom());
				//重试握手
				_queue.addState(new InitEnterRoom());
				//检查最终逻辑
				_queue.addState(new InitComplete()); 
			});
		}
		
		/**
		 *策略加载次要模块 
		 * @param o
		 * 
		 */		
		protected function onLoadSub(o:Object = null):void{
			_queue.addState(new InitSubModules());
		}
		
	}
}