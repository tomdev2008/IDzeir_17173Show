package com._17173.flash.show.base.module.guidetask
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.show.base.context.module.BaseModuleDelegate;
	import com._17173.flash.show.base.context.net.IServiceProvider;
	import com._17173.flash.show.base.context.user.User;
	import com._17173.flash.show.base.module.guidetask.vo.GuideTaskVO;
	import com._17173.flash.show.base.module.task.TaskButton;
	import com._17173.flash.show.model.CEnum;
	import com._17173.flash.show.model.SEnum;
	import com._17173.flash.show.model.SEvents;
	
	public class GuideTaskDegelete extends BaseModuleDelegate
	{
		private var _showTask:Boolean=true;
		public function GuideTaskDegelete()
		{
			super();
			/** 模块都加载完成开始请求新手任务 **/
			_e.listen(SEvents.APP_LOAD_SUBDELEGATE,function():void{
				_e.remove(SEvents.APP_LOAD_SUBDELEGATE,arguments.callee);
				getTaskData();				
			});
			/** 没有直播不显示新手任务 **/
			_e.listen(SEvents.TASK_SHOW,function(data:Object):void{
				_showTask = data.showTask;			
			});
		}
		/**
		 * 请求任务数据
		 * 
		 */		
		private function getTaskData():void
		{
			if(!_showTask)return;
			_s.http.getData(SEnum.TASK_INFO,null,onSucc);
		}
		/**
		 * 加载成功 
		 * @param data
		 * 
		 */		
		private function onSucc(data:Object):void{
			/** 任务数据 **/
			GuideTaskVO.analysis(data.GUIDE);
			
			var user:User = Context.getContext(CEnum.USER) as User;
			if(user.me.isLogin){
				if(GuideTaskVO.taskStatus == "OPEN" || GuideTaskVO.taskStatus == "UNDONE" || (GuideTaskVO.finalAward == "NO" && GuideTaskVO.taskStatus == "DONE"))
					this.load();
			}else{
				this.load();
			}
			
		}
		
		override protected function onModuleLoaded():void{
			super.onModuleLoaded();
			
			this.module["startGuideTask"]();
			_e.listen(SEvents.TASK_QUIT,quitTask);
			_e.listen(SEvents.TASK_GET_REWARD,getReward);
			_s.socket.listen(SEnum.TASK_DATA_COMPLETE.action,SEnum.TASK_DATA_COMPLETE.type,taskComplete);
		}
		
		private function taskComplete(data:Object):void{
			var object:Object = data.ct;
			if(object.masterId == Context.variables.showData.masterID){
				module["updateTask"](object);
			}
		}
		
		private function quitTask(data:Object):void
		{
			if(data.giveup)
			{
				_s.http.getData(SEnum.TASK_GIVEUP,{"taskId":GuideTaskVO.taskId},function (data:Object):void{});
				this._swf.parent.removeChild(_swf);
			}
			else{
				_e.listen(SEvents.TASK_CONTINUE,continueTask);
				_e.send(SEvents.ADD_ACTI_BUTTON,new TaskButton(SEvents.TASK_CONTINUE,new TaskButtonSkin()));
			}
		}
		
		private function getReward(data:Object):void
		{
			if("final" in data &&　data.final == true)
				(Context.getContext(CEnum.SERVICE) as IServiceProvider).http.getData(SEnum.TASK_FINALAWARD,{"taskId":data.taskId},function(data:Object):void{});
			else
				(Context.getContext(CEnum.SERVICE) as IServiceProvider).http.getData(SEnum.TASK_REWARD,{"taskId":data.taskId,"subtaskId":data.subTaskId},function(data:Object):void{});
		}
		
		private function continueTask():void
		{
			_s.http.getData(SEnum.TASK_INFO,null,function(data:Object):void{
				/** 任务数据 **/
				GuideTaskVO.analysis(data.GUIDE);
				module["continueGuideTask"]();
			});
		}
	}
}