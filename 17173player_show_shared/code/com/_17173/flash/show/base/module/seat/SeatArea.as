package com._17173.flash.show.base.module.seat
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.EventManager;
	import com._17173.flash.show.base.context.module.BaseModule;
	import com._17173.flash.show.base.module.seat.view.Seat;
	
	import flash.display.Sprite;
	import flash.geom.Point;
	import com._17173.flash.show.model.CEnum;
	import com._17173.flash.show.model.SEvents;
	
	public class SeatArea extends BaseModule
	{
		private var _seatDowns:Array = null;
		private var _seatUps:Array = null;
		private var _needShowMsg:Array = null;
		private var _putSeatErrorCount:int = 0;
		private var _putErrorLimit:int = 10;
		/**
		 *座位每排容器 
		 */		
		private var _colSeats:Array = null;
		public static var EFFECTWAIT:Boolean = false;
		public function SeatArea()
		{
			super();
			_version = "0.0.1";
			this.graphics.beginFill(0x00FFFF,.01);
			this.graphics.drawRect(0, 0, 843, 155);
			this.graphics.endFill();
			this.mouseEnabled = false;
			this.mouseChildren = false;
		}
		
		override protected function init():void{
			initSeat();
			addEventLsn();
			addServerLsn();
			_needShowMsg = [];
		}
		
		/**
		 *监听事件 
		 * 
		 */		
		private function addEventLsn():void{
			var event:EventManager = Context.getContext(CEnum.EVENT) as EventManager;
			event.listen(SEvents.NORMAL_GIFT_MESSAGE,addMessage);
		}
		
		/**
		 *监听通信消息 
		 * 
		 */		
		private function addServerLsn():void{
			
		}
		
		/**
		 *初始化所有座位
		 * 
		 */		
		private function initSeat():void{
			
			_seatDowns = [];
			_seatUps = [];
			_colSeats = [];
			//按预先位置放置座位到up
			
			
			//取一共多少排
			var row:Array = SeatConfig.seatRowCountConfig;
			var rowLen:int = row.length;
			var rowCount:int = 0;
			var rowInitPoint:Point;
			var colYOffset:int = 0;
			var seat:Seat;
			var count:int = 0;
			for (var k:int = 0; k < rowLen; k++) 
			{
				var tmp:Sprite = new Sprite();
				tmp.mouseEnabled = false;
				_colSeats[k] = tmp;
				this.addChild(tmp);
			}
			
			for (var i:int = 0; i < rowLen; i++) 
			{
				rowCount = row[i];
				rowInitPoint = SeatConfig.potConfig[i];
				colYOffset = 0;
				for (var j:int = 0; j < rowCount; j++) 
				{
					//设置座位
					seat = new Seat(count,SeatConfig.standTime,SeatConfig.standWaitTime);
					seat.rowIdx = i;
					seat.finishCallback = _standOver;
					//设置位置
					//x = 每排初始化位置x+间隔
					colYOffset += (SeatConfig.seatRowYs[i][j]);
					seat.x = rowInitPoint.x + j * SeatConfig.seatSpace;
					seat.y = rowInitPoint.y + colYOffset + 13;
					//位置居中
					seat.x -= SeatConfig.seatWidth/2;
					seat.y -= SeatConfig.seatHeight;
					_seatUps.push(seat);
					count++;
				}
				
			}
			
				
		}
		
		private function addMessage(msg:Object = null):void{
			_needShowMsg.push(msg);
			var seat:Seat;
			if(_seatUps.length > 0){
				randomGetOutSeat();
			}else{
				//没有座位了等着吧
			}
		}
		
		private function seatStand(seat:Seat):void{
			_colSeats[seat.rowIdx].addChild(seat);
			seat.showMessageAndEff(_needShowMsg.shift());
		}
		/**
		 *站立结束  
		 * 
		 */		
		private function _standOver(seat:Seat):void{
			//放置座位到up
			_seatUps[seat.seatIdx] = seat;
			if(seat.parent){
				seat.parent.removeChild(seat);
			}
			if(_needShowMsg.length > 0){
				randomGetOutSeat();
			}
		}
		
		/**
		 *随机获取座位，并站立
		 * @return 
		 * 
		 */		
		private function randomGetOutSeat():void{
			var seat:Seat = null;
			if(_seatUps.length > 0){
				//取出所有空座位的下标
				var idxs:Array = [];
				var tmpSeat:Seat;
				for (var i:int = 0; i < _seatUps.length; i++) 
				{
					if(_seatUps[i] != null){
						idxs.push(i);
					}
				}
				var len:int = idxs.length;
				var rand:int = Math.floor(Math.random() * len);
				seat = _seatUps[int(idxs[rand])];
				_seatUps[int(idxs[rand])] = null;
			}
			if(seat!=null){
				_putSeatErrorCount = 0;
				seatStand(seat);
			}else{
				//座位取出错误
				if(_putSeatErrorCount < _putErrorLimit){
					_putSeatErrorCount++;
					randomGetOutSeat();
				}
			}
		}
		
	}
}