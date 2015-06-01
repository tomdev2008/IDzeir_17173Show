package com._17173.flash.player.business.file
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.core.plugin.IPluginItem;
	import com._17173.flash.core.plugin.PluginManager;
	import com._17173.flash.core.statemachine.StateMachineEvent;
	import com._17173.flash.player.business.file.out.FileOutBusinessManager;
	import com._17173.flash.player.business.file.queue.FileCheckADInSkip;
	import com._17173.flash.player.business.file.queue.FileCheckADisLocal;
	import com._17173.flash.player.business.file.queue.FileInitVideoState;
	import com._17173.flash.player.business.file.queue.FileShowErrorState;
	import com._17173.flash.player.business.file.queue.FileShowFirstPage;
	import com._17173.flash.player.business.file.queue.InitVideoDispatchState;
	import com._17173.flash.player.business.file.queue.PTDelayeState;
	import com._17173.flash.player.business.file.queue.ParallelState;
	import com._17173.flash.player.business.file.queue.ShowADState;
	import com._17173.flash.player.business.file.queue.ShowPWState;
	import com._17173.flash.player.context.ContextEnum;
	import com._17173.flash.player.model.PlayerEvents;
	import com._17173.flash.player.model.PlayerScope;
	import com._17173.flash.player.module.PluginEnum;
	
	/**
	 * 点播企业版播放器业务逻辑控制类
	 * @author 安庆航
	 * 
	 */	
	public class FileCustomerBusinessManager extends FileOutBusinessManager
	{
		public function FileCustomerBusinessManager()
		{
			super();
		}
		
		override protected function addListeners():void {
			super.addListeners();
			(Context.getContext(ContextEnum.EVENT_MANAGER) as IEventManager).listen(PlayerEvents.BI_GET_VIDEO_INFO, getVideoInfo);
		}
		
		private function getVideoInfo(data:Object):void {
			Context.variables["flashURL"] = "http://v.17173.com/live/playerVideo/PreloaderFileCustomer.swf&url='" + Context.variables["url"] + "'";
		}
		
		
		/**
		 * 初始化需要用的状态
		 */		
		override protected function initStates():void {
			_queue.addEventListener(StateMachineEvent.STATE_COMPLETED, queueComplete);
			_queueArr = new Array();
			
			var ps:ParallelState = new ParallelState();
			//获取调度、延迟PT
			ps.addItems([new InitVideoDispatchState(), new PTDelayeState()]);
			var checkADPS:ParallelState = new ParallelState();
			//广告验证：是否是本地、是否是审核版本
			checkADPS.addItems([new FileCheckADisLocal(), new FileCheckADInSkip()]);
			var showADPS:ParallelState = new ParallelState();
			//加载显示广告、初始化视频
			showADPS.addItems([new ShowADState(), new FileInitVideoState()]);
			
			_queueArr.push(ps);
			_queueArr.push(new ShowPWState());//显示密码
			_queueArr.push(new FileShowFirstPage());
			_queueArr.push(checkADPS);
			_queueArr.push(showADPS);
			_queueArr.push(new FileShowErrorState());//验证是否有错误信息
		}
		
		override protected function initUI():void {
			Context.getContext(ContextEnum.DATA_RETRIVER)["getConfig"](getUIModuleScuess, getUIModuleScuess);
		}
		
		/**
		 * 成功获取配置信息
		 * 派发获取模块信息成功事件
		 * @param value
		 */		
		private function getUIModuleScuess(value:Object = null):void {
			resetAutoPlay();
			showRec();
			Context.getContext(ContextEnum.EVENT_MANAGER).send(PlayerEvents.UI_INTED);
		}
		
		/**
		 * 显示秀场推荐
		 */		
		private function showRec():void {
			var obj:Object = Context.variables["UIModuleData"];
			if (obj && obj[FileCustomerDataRetriver.M14] && Context.stage.stageWidth >= PlayerScope.PLAYER_WIDTH_6 && Context.stage.stageHeight >= PlayerScope.PALYER_HEIGHT_4) {
				var showRec:IPluginItem = (Context.getContext(ContextEnum.PLUGIN_MANAGER) as PluginManager).getPlugin(PluginEnum.SHOW_REC);
			}
		}
		
		/**
		 * 根据后台配置设置播放器autoPlay属性
		 */		
		private function resetAutoPlay():void {
			var obj:Object = Context.variables["UIModuleData"];
			if (obj && obj[FileCustomerDataRetriver.M16]) {
				Context.variables["autoplay"] = true;
				Context.variables["showFP"] = false;
			}
		}
	}
}