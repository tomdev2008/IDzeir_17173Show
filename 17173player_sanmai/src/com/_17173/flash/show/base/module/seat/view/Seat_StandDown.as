package com._17173.flash.show.base.module.seat.view
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.show.base.context.resource.IResourceManager;
	import com._17173.flash.show.base.components.common.BitmapAnim;
	
	import flash.display.Sprite;
	import com._17173.flash.show.model.CEnum;

	public class Seat_StandDown extends Sprite
	{
		private var _standDownMc:BitmapAnim = null;
		private var _standDownStarMc:BitmapAnim = null;
		public static const SEAT_ENDEFF:String = "seat_endeff";	
		public static const SEAT_STARDOWN:String = "seat_stardown";
		public function Seat_StandDown()
		{
			this.mouseEnabled = false;
			this.mouseChildren = false;
			var rs:IResourceManager = Context.getContext(CEnum.SOURCE) as IResourceManager;
			rs.addAnimDatas4Mc(SEAT_ENDEFF,new Seat_GiftEndEffect());
			_standDownMc = new BitmapAnim();
			
			rs.addAnimDatas4Mc(SEAT_STARDOWN,new Seat_StarDown());
			_standDownStarMc = new BitmapAnim();
			_standDownStarMc.x = 106;
			_standDownStarMc.y = 57;
			_standDownStarMc.playEndCall = starEnd;
		}
		
		public function play():void{
			var rs:IResourceManager = Context.getContext(CEnum.SOURCE) as IResourceManager;
			
			_standDownMc.data = rs.getAnimDatas(SEAT_ENDEFF);
			_standDownMc.gotoAndPlay(1);
			if(!this.contains(_standDownMc)){
				this.addChild(_standDownMc);
			}
			
			_standDownStarMc.data = rs.getAnimDatas(SEAT_STARDOWN);
			_standDownStarMc.gotoAndPlay(1);
			_standDownStarMc.loop = 1;
			if(!this.contains(_standDownStarMc)){
				this.addChild(_standDownStarMc);
			}
			
		}
		
		private function starEnd():void{
			if(_standDownMc && this.contains(_standDownMc)){
				this.removeChild(_standDownStarMc);
			}
		}
		
		public function stop():void{
			if(this.contains(_standDownMc)){
				this.addChild(_standDownMc);
			}
			_standDownMc = null;
			if(this.contains(_standDownStarMc)){
				this.addChild(_standDownStarMc);
			}
			_standDownStarMc = null;
		}
			
	}
}