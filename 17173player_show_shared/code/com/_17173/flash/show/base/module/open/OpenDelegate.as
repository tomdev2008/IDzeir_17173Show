package com._17173.flash.show.base.module.open
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.util.Util;
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.show.base.context.module.BaseModuleDelegate;
	import com._17173.flash.show.model.SEnum;
	import com._17173.flash.show.model.SEvents;
	
	/**
	 * 房间模块
	 * @author qiuyue
	 * 
	 */	
	public class OpenDelegate extends BaseModuleDelegate
	{
		
		private var _iOpenModule:IOpenModule = null;
		/**
		 * 待执行任务
		 */		
		private var _taskArray:Array = null;
		public function OpenDelegate()
		{
			super();
			update();
		}
		private function update():void
		{
			_taskArray = new Array();
 			_s.socket.listen(SEnum.R_UPDATESTATUS.action, SEnum.R_UPDATESTATUS.type, onUpdate);
			_e.listen(SEvents.CHANGE_ROOM_STATUS_MESSAGE, changeRoom);
		}
		
		override protected function onModuleLoaded():void
		{
			super.onModuleLoaded();
			_iOpenModule = _swf as IOpenModule;
			if(!_swf){
				return;
			}
			while(_taskArray.length > 0){
				var obj:Object = _taskArray.shift();
				if(obj.hasOwnProperty("data")){
					obj.fun(obj.data);
				}else{
					obj.fun();
				}
			}
			
		}
		
		/**
		 * 待执行任务
		 * @param fun 执行方法
		 * @param data 执行方法的参数
		 * 
		 */
		private function pushTask(fun:Function,data:Object = null):void
		{
			var obj:Object = new Object();
			obj.fun = fun;
			obj.data = data;
			_taskArray.push(obj);
		}
		
		/**
		 * 改变房间状态
		 * @param data
		 * 
		 */		
		private function changeRoom(data:Object):void
		{
			if(_iOpenModule == null){
				load();
				pushTask(changeRoom,null);
			}else{
				_iOpenModule.changeRoom();
			}
		}
		
		/**
		 * 房间状态更新 
		 * @param data
		 * 
		 */		
		private function onUpdate(data:Object):void
		{
			var obj:Object = data.ct;
			Debugger.log(Debugger.INFO,"[OpenModule]","房间状态为"+ obj.status);
			Context.variables.showData.roomStatus = obj.status;
			_e.send(SEvents.CHANGE_ROOM_STATUS);
			Util.refreshPage();
		}
	}
}