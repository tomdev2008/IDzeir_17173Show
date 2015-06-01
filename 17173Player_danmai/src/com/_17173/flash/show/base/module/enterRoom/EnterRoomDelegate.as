package com._17173.flash.show.base.module.enterRoom
{
	import com._17173.flash.show.base.context.module.BaseModuleDelegate;
	import com._17173.flash.show.model.SEvents;
	
	public class EnterRoomDelegate extends BaseModuleDelegate
	{
		//private var _iEnterRoomModule:IEnterRoomModule = null;
		
		/**
		 * 待执行任务
		 */		
		private var _taskArray:Array = null;
		
		public function EnterRoomDelegate()
		{
			super();
			_taskArray = new Array();
			_e.listen(SEvents.ENTER_ROOM_MESSAGE,enterRoom);
		}
		
		override protected function onModuleLoaded():void
		{
			super.onModuleLoaded();
			//_iEnterRoomModule = _swf as IEnterRoomModule;
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
		 * 进入房间 
		 * @param data
		 * 
		 */		
		private function enterRoom(data:Object):void{
			/*if(_iEnterRoomModule == null){
				load();
				pushTask(enterRoom,data);
			}else{
				_iEnterRoomModule.enterRoom();
			}*/
			if(!module)
			{
				load();
				pushTask(enterRoom,data);
			}else{
				module.data = {"enterRoom":null};
			}
		}
	}
}