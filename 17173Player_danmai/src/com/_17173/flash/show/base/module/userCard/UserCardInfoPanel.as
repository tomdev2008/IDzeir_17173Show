package com._17173.flash.show.base.module.userCard
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.show.core.base.net.IServiceProvider;
	import com._17173.flash.show.core.base.user.IUser;
	import com._17173.flash.show.core.base.user.IUserData;
	import com._17173.flash.show.core.components.common.AslTextField;
	import com._17173.flash.show.core.components.common.Pic;
	import com._17173.flash.show.core.utils.FontUtil;
	
	import flash.display.Sprite;
	import flash.text.TextFormat;
	import com._17173.flash.show.model.CEnum;
	
	/**
	 * 用户基本信息面板.
	 * 包含头像,姓名等.
	 *  
	 * @author shunia-17173
	 */	
	public class UserCardInfoPanel extends Sprite
	{
		
		private var _s:IServiceProvider = null;
		private var _u:IUser = null;
		/**
		 * 要显示的用户id 
		 */		
		private var _uid:String = null;
		/**
		 * 头像 
		 */		
		private var _head:Pic = null;
		/**
		 * 用户名 
		 */		
		private var _name:AslTextField = null;
		
		public function UserCardInfoPanel()
		{
			super();
			_s = IServiceProvider(Context.getContext(CEnum.SERVICE));
			_u = IUser(Context.getContext(CEnum.USER));
		}
		
		/**
		 * 当前要显示的用户的id.
		 *  
		 * @param value
		 */		
		public function set uid(value:String):void {
			if (_uid == value) return;
			_uid = value;
			
			create();
			update(_u.getUser(_uid));
		}
		
		public function get uid():String {
			return _uid;
		}
		
		/**
		 * 根据用户数据更新面板.
		 *  
		 * @param user
		 */		
		private function update(user:IUserData):void {
			if (user) {
//				_head.content = user.head;
				_head.content = "http://img.live.tv.itc.cn/20120830/images/headImg-default.png";
				_name.text = user.name;
			}
		}
		
		/**
		 * 准备显示对象以待内容填充. 
		 */		
		private function create():void {
			if (_head == null) {
				_head = new Pic();
				_head.x = 3;
				_head.y = 3;
				_head.width = 40;
				_head.height = 40;
				addChild(_head);
			}
			if (_name == null) {
				_name = new AslTextField(110);
				var format:TextFormat = FontUtil.DEFAULT_FORMAT;
				format.color = FontUtil.FONT_COLOR_BLUE1;
				_name.defaultTextFormat = format;
				_name.x = 44;
				_name.y = 3;
				addChild(_name);
			}
		}
		
	}
}