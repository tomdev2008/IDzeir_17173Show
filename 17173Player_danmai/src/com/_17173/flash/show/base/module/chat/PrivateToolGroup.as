package com._17173.flash.show.base.module.chat
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.show.base.context.net.IServiceProvider;
	import com._17173.flash.show.base.context.user.IUser;
	import com._17173.flash.show.model.CEnum;
	import com._17173.flash.show.model.SEnum;
	import com._17173.flash.show.model.SEvents;
	import com._17173.flash.show.model.ShowData;

	public class PrivateToolGroup extends ToolGroup
	{

		private var noPriBut:ChatToolButton;
		
		public function PrivateToolGroup()
		{
			super();
		}
		
		override protected function addChildren():void
		{
			var clearBut:ChatToolButton = new ChatToolButton(ilocal.get("clear", "chatPanel"),function():void
			{
				(Context.getContext(CEnum.EVENT) as IEventManager).send(SEvents.CLEAR_CHAT_MSG,index);
			});
			noPriBut = new ChatToolButton(ilocal.get("noPriChat", "chatPanel"),function():void
			{
				var _s:IServiceProvider = (Context.getContext(CEnum.SERVICE) as IServiceProvider);
				var data:Object = {};
				data.privateChat = uint(!(Context.variables["showData"] as ShowData).userPrivateChatStatus);
				data.flag = data.privateChat;
				_s.http.postData(SEnum.USER_CLOSE_PRIVATE_CHAT + "?flag=" + data.flag, null);
				_s.socket.listen(SEnum.R_CLOSE_PRIVATE_CHAT.action, SEnum.R_CLOSE_PRIVATE_CHAT.type, chatStatusChanage)
			});
			
			clearBut.setSkin(new ClearMsgSkin1_8());
			noPriBut.setSkin(new ClearMsgSkin1_8());
			
			addChild(clearBut);
			addChild(noPriBut);	
		}
		
		private function chatStatusChanage(value:*):void
		{
			if(!(value is String) && value.hasOwnProperty("ct"))
			{
				
				if((Context.getContext(CEnum.USER) as IUser).me.id == value.ct.userId)
				{
					var isAllowed:Boolean = (Context.variables["showData"] as ShowData).userPrivateChatStatus = Boolean(value.ct.privateChat);
					noPriBut.label = ilocal.get(isAllowed ? "noPriChat" : "yesPriChat", "chatPanel");
				}
			}
		}
	}
}