package com._17173.flash.show.base.module.task
{
	import com._17173.flash.show.base.context.module.BaseModule;
	
	import flash.events.Event;
	
	public class TaskModule extends BaseModule
	{
		private var _taskPanel:TaskPanel;
		private var _taskArray:Array;
		private var _taskInfoArray:Array;
		public function TaskModule()
		{
			super();
		}
		
		override protected function onAdded(event:Event):void{
			_taskPanel = new TaskPanel();
			_taskPanel.x = 0;
			_taskPanel.y = 0;
			_taskPanel.visible = false;
			_taskPanel.update(_taskArray,_taskInfoArray);
			this.addChild(_taskPanel);
		}
		
		public function hide():void{
			if(_taskPanel){
				_taskPanel.hide();
			}
		}
		
		public function showOrHide():void{
			if(_taskPanel){
				if(_taskPanel.visible){
					_taskPanel.hide();
				}else{
					_taskPanel.show();
				}
			}
		}
		
		public function setListData(data:Object):void{
			_taskArray = data.GUIDE.masterTaskList as Array;
			_taskInfoArray = data.GUIDE.taskList as Array;
		}
		
		public function updateTask(data:Object):void{
			if(data.taskId == 1 &&　_taskPanel && _taskArray){
				for(var i:int = 0; i< _taskArray.length; i++){
					var obj:Object = _taskArray[i];
					if(obj.subTaskId == data.subTaskId){
						_taskArray[i] = data.masterTask;
						break;
					}
				}
				_taskPanel.update(_taskArray,_taskInfoArray);
			}
		}
	}
}