package com._17173.flash.player.module.userinfo
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.player.context.ContextEnum;
	import com._17173.flash.player.model.Settings;
	import com._17173.flash.player.ui.stream.extra.IExtraUIItem;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	/**
	 *提示登录
	 * @author zhaoqinghao
	 *
	 */
	public class NeedLogin extends Sprite implements IExtraUIItem
	{
		public function NeedLogin()
		{
			super();
			init();
			this.mouseEnabled = false;
		}

		private function init():void
		{

			this.graphics.beginFill(0xff0000, .01);
			this.graphics.drawRect(0, 0, 200, 1);
			this.graphics.endFill();
			var label:TextField = new TextField();
			label.text = "小伙伴，主播喊你快来登录啊！";
			label.mouseEnabled = false;
			label.width = 200;
			label.height = 25;
			label.textColor = 0xD4D4D4;
			label.width = label.textWidth + 4;
			label.x = int((200 - label.width) / 2);
			label.y = 2;
			this.addChild(label);

			var btn:SimpleButton = new mc_loginBtn();
			btn.x = int((200 - btn.width) / 2);
			btn.y = 24;
			btn.addEventListener(MouseEvent.CLICK, onLoginClick);
			this.addChild(btn);

			var sp:MovieClip = new mc_splitLine();
			sp.mouseChildren = false;
			sp.mouseEnabled = false;
			sp.x = 199;
			this.addChild(sp);
		}

		public function refresh(isFullScreen:Boolean = false):void
		{
		}

		private function onLoginClick(e:Event):void
		{
			//去登录
			Context.getContext(ContextEnum.SETTING).login();
//			var setting:Settings = Context.getContext(ContextEnum.SETTING);
//			setting.login();
		}

		public function get side():Boolean
		{
			return false;
		}
	}
}
