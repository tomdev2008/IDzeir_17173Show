package com._17173.flash.show.base.module.dingyue
{
	import com._17173.flash.core.components.base.BaseContainer;
	import com._17173.flash.core.util.time.Ticker;
	
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 *显示一定时间自动关闭面板
	 * @author zhaoqinghao
	 *
	 */
	public class DingyueBaseAutoClosePanel extends BaseContainer
	{
		private var _autoCloseTime:int = 3;
		private var _mouseStop:Boolean = false;

		/**
		 *自动关闭
		 * @param showTime 显示时间
		 * @param mouseStop 鼠标是否能阻止关闭
		 *
		 */
		public function DingyueBaseAutoClosePanel(showTime:int = 3, mouseStop:Boolean = false)
		{
			super(null);
			_autoCloseTime = showTime;
			_mouseStop = mouseStop;
		}


		override protected function onShow():void
		{
			super.onShow();
			addLsn();
			autoHide();
		}

		override protected function onHide():void
		{
			removeLsn();
		}
		
		
		public function updateAutoCd(cd:int):void{
			_autoCloseTime = cd;
			killAuto();
			autoHide();
		}
		/**
		 *自动关闭 
		 * 
		 */
		protected function autoHide():void
		{
			Ticker.tick(_autoCloseTime*1000,onClose);
		}
		/**
		 *执行关闭 
		 * 
		 */		
		protected function onClose():void{
			hide();
		}
		/**
		 *拦截关闭 
		 * 
		 */		
		protected function killAuto():void{
			Ticker.stop(onClose);
		}

		private function addLsn():void
		{
			this.addEventListener(MouseEvent.ROLL_OVER, onOver);
		}

		private function removeLsn():void
		{
			this.removeEventListener(MouseEvent.ROLL_OVER, onOver);
		}


		private function onOver(e:Event):void
		{
			
			this.addEventListener(MouseEvent.ROLL_OVER, onOut);
		}

		private function onOut(e:Event):void
		{
			this.removeEventListener(MouseEvent.ROLL_OVER, onOut);
		}
	}
}
