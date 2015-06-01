package com._17173.flash.show.base.module.ad.ui
{
	import com._17173.flash.core.components.common.Button;
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.show.base.module.ad.base.AdPlayerType;
	import com._17173.flash.show.base.module.ad.base.AdPlayer_Image;
	import com._17173.flash.show.base.module.ad.base.AdPlayer_SWF;
	import com._17173.flash.show.base.module.ad.base.AdPlayer_Video;
	import com._17173.flash.show.base.module.ad.base.AdType;
	import com._17173.flash.show.model.CEnum;
	import com.greensock.TweenLite;
	
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	public class AdShowRight extends AdBaseShow
	{
		private var A_W:int = 0;
		private var A_H:int = 0;
		public function AdShowRight()
		{
			super();
			_close = new Button();
			_close.setSkin(new Skin_btn_Ad());
			_close.addEventListener(MouseEvent.CLICK, closeClick);
			this.addChild(_close);
			_close.visible = false;
//			this.resize(A_W,A_H);
		}
		
		protected function closeClick(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			this.dispose();
			event.stopPropagation();
			(Context.getContext(CEnum.EVENT) as IEventManager).send("ad_close_type",AdType.SHOW_RIGHT);
			(Context.getContext(CEnum.EVENT) as IEventManager).send("ad_a_cmp",AdType.SHOW_RIGHT);
		}
		private var _close:Button = null;
		override protected function initType():void{
			_supportedPlayer[AdPlayerType.IMAGE] = AdPlayer_Image;
			_supportedPlayer[AdPlayerType.SWF] = AdPlayer_SWF;
			_supportedPlayer[AdPlayerType.VIDEO] = AdPlayer_Video;
		}
		
		override protected function onLoadSucc(result:Object):void{
			A_W = (this._player.display as Object).contentLoaderInfo.width;
			A_H = (this._player.display as Object).contentLoaderInfo.height;
			this.resize(A_W,A_H);
			this._player.display.y = A_H;
			_close.x = A_W - _close.width;
			super.onLoadSucc(result);
			rePostion(Context.getContext(CEnum.UI).sceneRect);
			TweenLite.to(this._player.display,.5,{y:0,onComplete:onShow});
		}
		
		protected function onShow():void{
			_close.visible = true;
		}
		
		override public function dispose():void{
			super.dispose();
			if(this.parent){
				this.parent.removeChild(this);
			}
		}
		
		/**
		 *定位 
		 * @param rect
		 * 
		 */		
		override public function rePostion(rect:Rectangle):void{
			this.x = rect.width - this.A_W;
			this.y = rect.height - this.A_H;
		}
		
	}
}