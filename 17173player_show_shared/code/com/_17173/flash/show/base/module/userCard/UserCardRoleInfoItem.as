package com._17173.flash.show.base.module.userCard
{
	import com._17173.flash.core.components.common.HGroup;
	import com._17173.flash.show.base.context.user.IUserData;
	import com._17173.flash.show.base.utils.Utils;
	
	public class UserCardRoleInfoItem extends HGroup
	{
		protected var _user:IUserData;
		
		private var _hasGraphic:Boolean = false;
		
		public function UserCardRoleInfoItem()
		{
			super();
		}
		/**
		 * 是否包含图标
		 * @return 
		 * 
		 */		
		public function get hasGraphic():Boolean
		{
			return _hasGraphic;
		}

		public function set user(value:IUserData):void
		{
			_user = value;
			updateInfo();
		}
		
		private function updateInfo():void
		{
			this.graphics.clear();
			this.removeChildren();
			_hasGraphic = false;
			if(_user)
			{
				if(_user.isAdmin)
				{
					//巡管
					_hasGraphic = true;
					this.addChild(Utils.getURLGraphic("assets/img/level/admin.png",true,16,16));
				}
				if(_user.agent)
				{
					//代理
					_hasGraphic = true;
					this.addChild(Utils.getURLGraphic("assets/img/level/agent.png",true,16,15));
				}
				if(_user.broker)
				{
					//房主 经纪人
					_hasGraphic = true;
					this.addChild(Utils.getURLGraphic("assets/img/level/broker.png",true,61,16));
				}else if(_user.assistant){
					//副房主 助理
					_hasGraphic = true;
					this.addChild(Utils.getURLGraphic("assets/img/level/assistant.png",true,50,16));
				}else if(_user.artist){
					//艺人 主播
					_hasGraphic = true;
					this.addChild(Utils.getURLGraphic("assets/img/level/artist.png",true,74,16));
				}else if(_user.normalAdmin){
					//管理员
					_hasGraphic = true;
					this.addChild(Utils.getURLGraphic("assets/img/level/normalAdmin.png",true,85,16));
				}
			}
		}
		
	}
}