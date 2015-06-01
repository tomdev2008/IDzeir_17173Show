package com._17173.flash.show.module.preview
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.show.base.context.module.BaseModuleDelegate;
	import com._17173.flash.show.model.SEnum;
	import com._17173.flash.show.model.SEvents;
	
	public class SimplePreviewDelegate extends BaseModuleDelegate
	{
		/**
		 * camModule 
		 */		
		//private var _iPreviewModule:ISimplePreviewModule = null;
		/**
		 *待执行任务
		 */		
		private var _taskArray:Array = null;
		public function SimplePreviewDelegate()
		{
			super();
			_taskArray = new Array();
			_s.socket.listen(SEnum.R_STARTPUSH.action, SEnum.R_STARTPUSH.type, micUpMessage);
			_e.listen(SEvents.RESET_PREVIEW,resetPreview);
		}
		
		/**
		 * 重置预览模块
		 * @param data
		 * 
		 */		
		private function resetPreview(data:Object):void{
			if(module == null){
				load();
				pushTask(resetPreview,null);
			}else{
				//_iPreviewModule.resetPreview();
				this.module.data = {"resetPreview":null};
			}
		}
		
		/**
		 * 上麦消息 返回 更新数据 
		 * @param data
		 * 
		 */		
		private function micUpMessage(data:Object):void{
			var obj:Object = data.ct;
			if(obj.masterId == Context.variables.showData.masterID){
				onPushData(data);
			}
		}
		
		private function onPushData(data:Object):void {
			if(module == null){
				load();
				pushTask(onPushData,data);
			}else{
				//_iPreviewModule.onPushData(data);
				this.module.data = {"onPushData":[data]};
			}
		}
		
		override protected function onModuleLoaded():void{
			super.onModuleLoaded();
			//_iPreviewModule = _swf as ISimplePreviewModule;
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
		
		private function pushTask(fun:Function, data:Object = null):void{
			var obj:Object = new Object();
			obj.fun = fun;
			obj.data = data;
			_taskArray.push(obj);
		}
	}
}