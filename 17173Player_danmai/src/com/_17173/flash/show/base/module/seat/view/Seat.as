package com._17173.flash.show.base.module.seat.view
{
	import com._17173.flash.core.util.time.Ticker;
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	
	import flash.display.Sprite;

	/**
	 *单个座位 
	 * @author zhaoqinghao
	 * 
	 */	
	public class Seat extends Sprite
	{
		/**
		 *站立效果 
		 */		
		private var _standUpMc:Seat_StandUP = null;
		private var _standDownMc:Seat_StandDown = null;
		private var _cWidth:int = 155;
		/**
		 *显示消息 
		 */		
		private var _showMsg:SeatSay = null;
		private var _seatIdx:int = 0;
		/**
		 *是否站立中 
		 */		
		private var _standing:Boolean = false;
		/**
		 *坐下后再次站立等候时间 
		 */		
		private var _waitTime:int = 0;
		/**
		 *站立时间 
		 */		
		private var _standTime:int = 0;
		/**
		 *显示消息 
		 */		
		private var _currentMsg:Object = null;
		private var _seatRowIdx:int = 0;

		/**
		 *座位排 
		 */
		public function get rowIdx():int
		{
			return _seatRowIdx;
		}

		/**
		 * @private
		 */
		public function set rowIdx(value:int):void
		{
			_seatRowIdx = value;
		}

		/**
		 *座位编号 
		 */
		public function set seatIdx(value:int):void
		{
			_seatIdx = value;
		}

		/**
		 *完成后回调方法 
		 */
		public function get finishCallback():Function
		{
			return _finishCallback;
		}

		/**
		 * @private
		 */
		public function set finishCallback(value:Function):void
		{
			_finishCallback = value;
		}

		private var _finishCallback:Function;
		/**
		 *座位 
		 * @param seatNum 编号
		 * @param waitCD 再次站立cd（毫秒）
		 * @param standTime 站立时间(毫秒)
		 * 
		 */		
		public function Seat(seatNum:int,standTime:int,waitCD:int)
		{
			super();
			_seatIdx = seatNum;
			_waitTime = waitCD;
			_standTime = standTime;
			this.mouseEnabled = false;
			this.mouseChildren = false;
			initSeat();
		}

		private function initSeat():void{
			//初始msgmc
			_showMsg = new SeatSay();
		}
		
		public function get standing():Boolean
		{
			return _standing;
		}

		public function set standing(value:Boolean):void
		{
			_standing = value;
		}

		public function get seatIdx():int
		{
			return _seatIdx;
		}

		/**
		 *座位显示消息及效果 
		 * @param msg
		 * 
		 */		
		public function showMessageAndEff(msg:Object):void{
			_currentMsg = msg;
			standStart();
			
		}
		/**
		 *开始站立效果 
		 * 
		 */		
		private function standStart():void{
			if(_standUpMc == null){
				_standUpMc = new Seat_StandUP();
			}
			if(!this.contains(_standUpMc)){
				this.addChild(_standUpMc);
			}
			showMessage();
			_standUpMc.play();
			Ticker.tick(_standTime,showStandDownEff);
		}
		/**
		 *开始坐下效果 
		 * 
		 */		
		private function showStandDownEff():void{
			
			if(this.contains(_standUpMc)){
				this.removeChild(_standUpMc);
			}
			_standUpMc.stop();
			_standUpMc = null;
			standDown();
			hideMessage();
		}
		
		protected function showMessage():void{
			_showMsg.msgString = _currentMsg;
			var tw:int = _showMsg.width;
			var xto:int = (_cWidth-tw)/2;
			_showMsg.scaleY = _showMsg.scaleX = 84/tw;
			_showMsg.alpha = .2;
			_showMsg.x = (_cWidth-84)/2;
			_showMsg.y = 90;
			//消息的缓动实现
			if(!this.contains(this._showMsg)){
				this.addChild(_showMsg);
			}
			TweenLite.to(_showMsg,.7,{x:xto+5,y:0,scaleX:1,scaleY:1,alpha:1});
			TweenLite.to(_showMsg,1,{y:0,ease:Back.easeOut});
		}
		
		private function standDown():void{
			if(_standDownMc == null){
				_standDownMc = new Seat_StandDown();
			}
			if(!this.contains(_standDownMc)){
				this.addChild(_standDownMc);
			}
			_standDownMc.play();
			Ticker.tick(_waitTime,cdTimeOut);
		}
		
		private function hideMessage():void{
			_showMsg.alpha = 1;
			//消息的缓动实现
			TweenLite.to(_showMsg,.4,{alpha:0,onComplete:removeMessage});
		}
		
		private function removeMessage():void{
			if(contains(_showMsg)){
				this.removeChild(_showMsg);
			}
		}
		
		/**
		 *站立动作完成后调用 
		 * 
		 */		
		private function cdTimeOut():void{
			if(this.contains(_standDownMc)){
				this.removeChild(_standDownMc);
			}
			_standDownMc.stop();
			_standDownMc = null
			if(_finishCallback != null){
				_finishCallback(this);
			}
		}
		/**
		 *隐藏 
		 * 
		 */		
		public function hideMessageAndEff():void{
			_standUpMc.visible = false;
			_showMsg.visible = false;
		}
	}
}