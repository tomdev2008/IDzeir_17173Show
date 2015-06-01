package com._17173.flash.show.module.video.app
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.show.base.context.user.IUser;
	import com._17173.flash.show.base.utils.Utils;
	import com._17173.flash.show.model.CEnum;
	import com._17173.flash.show.model.SEvents;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	public class AppItem extends Sprite
	{
		private var _url:String;
		private var _isNeedLogin:int = 0;
		private var _room:int=0;
		private var _type:String;
		public function AppItem()
		{
			super();
			this.buttonMode=true;
			
			this.addEventListener(MouseEvent.CLICK,mouseClickHandler);
		}
		
		public function setData(data:Object):void
		{
			var display:DisplayObject = Utils.getURLGraphic(data.iconPath,true,32,32);
			this.addChild(display);
			display.alpha = 0.6;
			
			_url = data.url;
			_room = data.isRoom;
			_type = data.type;
			if("isLogin" in data)
			_isNeedLogin = data.isLogin;
			
			
			this.addEventListener(MouseEvent.MOUSE_OVER,function(event:MouseEvent):void{
				display.alpha = 1;
			});
			this.addEventListener(MouseEvent.MOUSE_OUT,function(event:MouseEvent):void{
				display.alpha = 0.6;
			});
		}
		
		private function mouseClickHandler(event:MouseEvent):void
		{
			if(_room)
			{
				(Context.getContext(CEnum.EVENT)as IEventManager).send(SEvents.VIDEO_LINK_CLICK,{"type":_type});
			}else{
				var user:IUser = Context.getContext(CEnum.USER) as IUser;
				if(user.me.isLogin || _isNeedLogin == 0)
					flash.net.navigateToURL(new URLRequest(_url));
				else
					(Context.getContext(CEnum.EVENT)as IEventManager).send(SEvents.LOGINPANEL_SHOW);
			}
		}
	}
}