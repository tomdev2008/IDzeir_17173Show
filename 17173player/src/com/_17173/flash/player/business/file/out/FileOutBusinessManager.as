package com._17173.flash.player.business.file.out
{
	import com._17173.flash.core.statemachine.StateMachineEvent;
	import com._17173.flash.player.business.file.FileBusinessManager;
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
	import com._17173.flash.player.business.file.queue.ShowRecState;
	
	/**
	 * 点播站外使用的business
	 */	
	public class FileOutBusinessManager extends FileBusinessManager
	{
		public function FileOutBusinessManager()
		{
			super();
		}
		
		override protected function addListeners():void {
			super.addListeners();
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
			var showRecState:ShowRecState = new ShowRecState();
			
			_queueArr.push(ps);
			_queueArr.push(new ShowPWState());//显示密码
			_queueArr.push(new FileShowFirstPage());
			_queueArr.push(checkADPS);
			_queueArr.push(showADPS);
			_queueArr.push(showRecState);
			_queueArr.push(new FileShowErrorState());//验证是否有错误信息
		}
		
	}
}