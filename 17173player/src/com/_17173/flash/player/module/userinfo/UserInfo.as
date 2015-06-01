package com._17173.flash.player.module.userinfo
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.skin.ISkinObject;
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.player.context.ContextEnum;
	import com._17173.flash.player.context.SkinManager;
	import com._17173.flash.player.model.PlayerEvents;
	import com._17173.flash.player.ui.comps.SkinsEnum;
	import com._17173.flash.player.ui.stream.extra.ExtraUIItemEnum;
	
	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 *用户信息模块
	 * @author zhaoqinghao
	 *
	 */
	public class UserInfo extends Sprite
	{
		private var _userInfoUI:UserInfoUI = null;
		private var _needLoginUI:NeedLogin = null;

		public function UserInfo()
		{
			super();
			init();
		}

		private function onRemove(e:Event):void
		{
			this.removeEventListener(Event.REMOVED_FROM_STAGE, onRemove);
			removeLsn();
		}

		private function addLsn():void
		{
			Context.getContext(ContextEnum.EVENT_MANAGER).listen(PlayerEvents.BI_REQUEST_USERINFO, updateInfo);
			Context.getContext(ContextEnum.EVENT_MANAGER).listen(PlayerEvents.BI_GIFT_SENT, updateInfo);
		}

		private function removeLsn():void
		{
			Context.getContext(ContextEnum.EVENT_MANAGER).remove(PlayerEvents.BI_REQUEST_USERINFO, updateInfo);
			Context.getContext(ContextEnum.EVENT_MANAGER).remove(PlayerEvents.BI_GIFT_SENT, updateInfo);
		}

		private function init():void
		{
			var ver:String = "1.0.2";
			Debugger.log(Debugger.INFO, "[gift]", "用户信息模块[版本:" + ver + "]初始化!");
			//判断是否登录  添加到StreamExtrabar栏左
			var extBar:ISkinObject = (Context.getContext(ContextEnum.SKIN_MANAGER) as SkinManager).getSkin(SkinsEnum.STREAM_EXTRA_BAR);
			var setting:Object = Context.getContext(ContextEnum.SETTING);
			if (setting.userLogin)
			{
				_userInfoUI = new UserInfoUI();
				extBar.call("addItem", _userInfoUI, ExtraUIItemEnum.USER_INFO);
			}
			else
			{
				_needLoginUI = new NeedLogin();
				extBar.call("addItem", _needLoginUI, ExtraUIItemEnum.USER_INFO);
			}
			addLsn();
		}

		public function updateInfo(data:Object = null):void
		{
//			(Context.getContext(ContextEnum.EVENT_MANAGER) as IEventManager).send(PlayerEvents.BI_USER_INFO_CHANGE);
		}
	}
}
