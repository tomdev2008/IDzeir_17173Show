package com._17173.flash.show.base.module.gamelink
{
	import com._17173.flash.core.components.common.Button;
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.core.util.Util;
	import com._17173.flash.show.base.context.user.IUser;
	import com._17173.flash.show.base.utils.Utils;
	import com._17173.flash.show.model.CEnum;
	import com._17173.flash.show.model.SEvents;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class GameItemRender extends Sprite
	{
		private var _gameBglayer:Sprite;
		
		private var _gotoButton:Button;
		private var _link:String;
		
		public function GameItemRender(link:String = "")
		{
			super();
			_gameBglayer = new Sprite();
			this.addChild(_gameBglayer);
			_gotoButton = new Button("");
			_gotoButton.setSkin(new GameButtonBg1_8_1());
			this.addChild(_gotoButton);
			
			this.mouseChildren = true;
			
			_link = link;
			this.addEventListener(MouseEvent.CLICK,gotoGame);
		}
		
		protected function gotoGame(event:MouseEvent):void
		{
			var e:IEventManager = (Context.getContext(CEnum.EVENT) as IEventManager);
			var iuser:IUser = (Context.getContext(CEnum.USER) as IUser);
			if(iuser.me.isLogin){
				if(_link.indexOf("http://")!=-1)
				{
					Util.toUrl(_link);
				}else{
					const CHAT_TO_EGG_GAME:String = "chatToZadan";
					e.send(_link,{type:CHAT_TO_EGG_GAME});
				}
			}else{
				e.send(SEvents.LOGINPANEL_SHOW);
			}
		}
		
		public function set game(bglayer:DisplayObject):void
		{
			_gameBglayer.removeChildren();
			_gameBglayer.addChild(bglayer);
			update();
		}
		
		private function update():void
		{
			_gotoButton.x = _gameBglayer.x + _gameBglayer.width - _gotoButton.width + 10;
			_gotoButton.y = _gameBglayer.y + _gameBglayer.height - _gotoButton.height - 35;
		}
	}
}