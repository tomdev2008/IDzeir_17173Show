package com._17173.flash.show.base.module.seat.view
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.show.base.context.resource.IResourceManager;
	import com._17173.flash.show.base.components.common.BitmapAnim;
	
	import flash.display.Sprite;
	import com._17173.flash.show.model.CEnum;

	public class Seat_StandUP extends Sprite
	{
		private var _standUpMc:BitmapAnim = null;
		private var _standUpStarMc:BitmapAnim = null;
		public static const SEAT_STARTEFF:String = "seat_starteff";	
		public static const SEAT_STARUP:String = "seat_starup";	
		public function Seat_StandUP()
		{
			
			this.mouseEnabled = false;
			this.mouseChildren = false;
			var rs:IResourceManager = Context.getContext(CEnum.SOURCE) as IResourceManager;
			_standUpMc = new BitmapAnim();
			rs.addAnimDatas4Mc(SEAT_STARTEFF,new Seat_GiftStartEff());
			_standUpMc.playEndCall = standEnd;
			
			_standUpStarMc = new BitmapAnim();
			rs.addAnimDatas4Mc(SEAT_STARUP,new Seat_StarUP());
			_standUpStarMc.x = 150/2;
			_standUpStarMc.y = 111;
			_standUpStarMc.loop = -1;
		}
		
		public function play():void{
			var rs:IResourceManager = Context.getContext(CEnum.SOURCE) as IResourceManager;
			_standUpMc.data = rs.getAnimDatas(SEAT_STARTEFF);
			_standUpMc.gotoAndPlay(0);
			if(!this.contains(_standUpMc)){
				this.addChild(_standUpMc);
			}
		}
		
		private function standEnd():void{
			var rs:IResourceManager = Context.getContext(CEnum.SOURCE) as IResourceManager;
			_standUpStarMc.data = rs.getAnimDatas(SEAT_STARUP);
			_standUpStarMc.gotoAndPlay(0);
			if(!this.contains(_standUpStarMc)){
				_standUpStarMc.loop = 1;
				this.addChild(_standUpStarMc);
			}
		}
		
		public function stop():void{
			_standUpMc.stop();
			if(this.contains(_standUpMc)){
				this.addChild(_standUpMc);
			}
			_standUpMc = null;
			if(this.contains(_standUpStarMc)){
				this.addChild(_standUpStarMc);
			}
			_standUpStarMc = null
		}
	}
}