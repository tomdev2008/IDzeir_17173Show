package com._17173.flash.show.base.module.task
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.show.base.components.common.plugbutton.PlugButton;
	import com._17173.flash.show.base.context.module.BaseModuleDelegate;
	import com._17173.flash.show.model.SEnum;
	import com._17173.flash.show.model.SEvents;
	
	import flash.geom.Point;
	import flash.net.URLVariables;
	
	public class TaskDelegate extends BaseModuleDelegate
	{
		private var _taskArray:Array = null;
		private var _taskData:Object =  null;
		public function TaskDelegate()
		{
			super();
			_taskArray = new Array();
			_s.http.getData(SEnum.TASK_INFO,null,onSucc,onFail);

		}
		
		private function taskTimeComplete(data:Object):void{
			if(_swf){
				var url:URLVariables = new URLVariables();
				url.taskId = 1;
				url.subtaskId = 3;
				url.roomId = Context.variables.showData.roomID;
				_s.http.getData(SEnum.TASK_COMPLETE,url,onTaskSucc,onTaskFail,true);
			}
		}
		
		private function onTaskSucc(data:Object):void{
			_e.remove(SEvents.TASK_TIME_COMPLETE,taskTimeComplete);
		}
		
		private function onTaskFail(data:Object):void{
			if(data.msg){
				Debugger.log(Debugger.INFO,"[TaskDelegate]","新手任务40分钟完成失败!" + data.msg);
			}else{
				Debugger.log(Debugger.INFO,"[TaskDelegate]","新手任务40分钟完成失败!");
			}
		}
		
		private function onSucc(data:Object):void{
			if(_swf){
				return;
			}
			if("taskStatus" in data.GUIDE && data.GUIDE.taskStatus == "CLOSE")return;
			
			_e.listen(SEvents.APP_LOAD_SUBDELEGATE,sendMessageForGuide);
			
			if((data.GUIDE.masterTaskList as Array).length > 0){
				_taskData = data;
				loadModule();
			}

		}
		
		private function sendMessageForGuide(data:Object):void{
			_e.remove(SEvents.APP_LOAD_SUBDELEGATE,sendMessageForGuide);
			if(_taskData){
				var isShow:int = (_taskData.GUIDE.masterTaskList as Array).length > 0?1:0;
				_e.send(SEvents.USER_AUTH,isShow);
			}else{
				_e.send(SEvents.USER_AUTH,0);
			}
			
		}
		
		private function onFail(data:Object):void{
			
		}
		
		private function isShowTask(data:Object):void{
			if(module){
				module.data = {"showOrHide":null};
			}
			taskPoint(data);
		}
		
		private function taskPoint(data:Object):void{
			if(module){
				if(data is PlugButton){
					var point:Point = (data as PlugButton).localToGlobal(new Point(data.x,data.y));
					//_swf.y = point.y + (data as PlugButton).height/2 - 386/2;
					_swf.y = point.y - 180;
				}else if(data is Point)
				{
					_swf.y = data.y - 180;
				}
			}
		}
		
		/**
		 * 互斥操作 
		 * @param data	
		 * 
		 */		
		private function btnClick(data:Object):void{
			if(data != SEvents.IS_SHOW_TASK){
				if(module){
					module.data = {"hide":null};
				}
			}
		}
		
		private function complete():void{
			module.data = {"hide":null};
			module.data = {"setListData":[_taskData]};
			_e.listen(SEvents.BOTTOM_BUTTON_CLICK,btnClick);
			_e.listen(SEvents.IS_SHOW_TASK,isShowTask);
			_e.listen(SEvents.TASK_TIME_COMPLETE,taskTimeComplete);
			_e.listen(SEvents.PLUGBUTTON_CHANGE_POSTION,taskPoint);
			_s.socket.listen(SEnum.TASK_DATA_COMPLETE.action,SEnum.TASK_DATA_COMPLETE.type,taskComplete);
			_e.send(SEvents.ADD_ACTI_BUTTON,new TaskButton(SEvents.IS_SHOW_TASK,new TaskButtonSkin()));
		}
		
		private function taskComplete(data:Object):void{
			var object:Object = data.ct;
			if(object.masterId == Context.variables.showData.masterID){
				module.data = {"updateTask":[object]};
			}
		}
		
		override protected function onModuleLoaded():void{
			super.onModuleLoaded();
			if(!_swf){
				return;
			}
			complete();
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
		 * 加入待执行任务 
		 * @param fun 要执行的方法
		 * @param data 要执行方法的参数
		 * 
		 */		
		private function pushTask(fun:Function,data:Object = null):void{
			var obj:Object = new Object();
			obj.fun = fun;
			obj.data = data;
			_taskArray.push(obj);
		}
	}
}