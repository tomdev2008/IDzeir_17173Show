package com._17173.flash.show.base.module.preview
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.show.base.context.module.BaseModuleDelegate;
	import com._17173.flash.show.base.context.user.IUser;
	import com._17173.flash.show.model.CEnum;
	import com._17173.flash.show.model.SEvents;

	/**
	 * 推流代理类
	 * @author qiuyue
	 * 
	 */	
	public class PreviewDelegate extends BaseModuleDelegate
	{
		/**
		 * camModule 
		 */		
		private var _iPreviewModule:IPreviewModule = null;
		/**
		 *待执行任务
		 */		
		private var _taskArray:Array = null;
		public function PreviewDelegate()
		{
			super();
			_taskArray = new Array();
			_e.listen(SEvents.CAMER_SHOW_CLICK, showCamer);
			_e.listen(SEvents.MIC_UP_MESSAGE,micUpMessage);
			_e.listen(SEvents.BOTTOM_BUTTON_CMP,bottonButtonCmp);
			_e.listen(SEvents.INIT_CAM_PREVIEW,camPreview);
			_e.listen(SEvents.RESET_PREVIEW,resetPreview);
		}
		
		/**
		 * 初始化CamPreview 
		 * @param data
		 * 
		 */		
		private function camPreview(data:Object):void{
			_e.send(SEvents.BOTTOM_CAMER_CLICK,SEvents.CAMER_SHOW_CLICK);
		}
		
		/**
		 * 底栏按钮点击 
		 * @param data
		 * 
		 */		
		private function bottonButtonCmp(data:Object):void{
			var iUser:IUser = Context.getContext(CEnum.USER) as IUser;
			var micIndex:int = iUser.getMicIndex(iUser.me.id);
			if(micIndex != -1){
				var order:Object = Context.variables.showData.order[micIndex];
				if(order != null){
					if(order.masterId == Context.variables.showData.masterID){
						_e.send(SEvents.BOTTOM_CAMER_CLICK,SEvents.CAMER_SHOW_CLICK);
					}
				}
			}
		}
		
		override protected function onModuleLoaded():void{
			super.onModuleLoaded();
			_iPreviewModule = _swf as IPreviewModule;
			if(!_swf){
				return;
			}
			if(!_swf)return;
			
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
		private function pushTask(fun:Function, data:Object = null):void{
			var obj:Object = new Object();
			obj.fun = fun;
			obj.data = data;
			_taskArray.push(obj);
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
				_iPreviewModule.resetPreview();
			}
		}
		
		/**
		 * 显示摄像头 
		 * @param data
		 * 
		 */		
		private function showCamer(data:Object):void{
			if(module == null){
				load();
				pushTask(showCamer,data);
			}else{
				_iPreviewModule.showCamer(data);
			}
		}
		
		/**
		 * 上麦消息  数据更新
		 * @param data
		 * 
		 */		
		private function micUpMessage(data:Object):void{
			if(data.smasterId != 0){
				if(data.smasterId == Context.variables.showData.masterID){
					onPushData();
				}
			}
		}
		
		/**
		 * 上麦消息传来 
		 * @param data
		 * 
		 */		
		private function onPushData():void {
			if(module == null){
				load();
				pushTask(onPushData,null);
			}else{
				_iPreviewModule.onPushData();
			}
		}
		
	}
}