package com._17173.flash.show.base.module.userCard
{
	import com._17173.flash.core.components.common.HGroup;
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.locale.ILocale;
	import com._17173.flash.show.base.components.common.BitmapMovieClip;
	import com._17173.flash.show.base.context.layer.IUIManager;
	import com._17173.flash.show.base.context.user.IUserData;
	import com._17173.flash.show.base.utils.Utils;
	import com._17173.flash.show.model.CEnum;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	public class UserCardRoleInfoItem extends HGroup
	{
		protected var _user:IUserData;
		
		private var _hasGraphic:Boolean = false;
		/**vip*/
		private var _vip:BitmapMovieClip;
		/**主播*/
		private var _broker:Sprite;
		/**巡管*/
		private var _admin:Sprite;
		/**代理*/
		private var _agent:Sprite;
		/**销售*/
		private var _saler:Sprite;
		/**普通管理*/
		private var _nAdmin:Sprite;
		/**助理*/
		private var _assistant:Sprite;
		/**主播等级*/
		private var _star:BitmapMovieClip;
		/**财富等级*/
		private var _rich:BitmapMovieClip;
		
		private const BASE_URL:String = "assets/img/level/";
		
		private var _ilocal:ILocale;
		
		private var _iui:IUIManager;
		
		public function UserCardRoleInfoItem()
		{
			super();
			this.gap = 3;
			this.valign = HGroup.MIDDLE;
			_ilocal = Context.getContext(CEnum.LOCALE) as ILocale;
			_iui = Context.getContext(CEnum.UI) as IUIManager;
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
			checkRole();
			updateInfo();
		}
		
		private function checkRole():void
		{
			if(_user.vip>0&&!_vip)
			{
				_vip = new BitmapMovieClip();
				_iui.registerTip(_vip,_ilocal.get("vip"+_user.vip,"userRole"));
			}
			if(Number(_user.starLevel)>0&&!_star)
			{
				_star = new BitmapMovieClip();
				_iui.registerTip(_star,_ilocal.get("star","userRole"));
			}
			if(Number(_user.richLevel)>0&&!_rich)
			{
				_rich = new BitmapMovieClip();
				_iui.registerTip(_rich,_ilocal.get("rich","userRole"));
			}
			
			if(_user.broker&&!_broker)
			{
				_broker = Utils.getURLGraphic(BASE_URL+_ilocal.get("icon_broker","chatPanel")) as Sprite;
				_iui.registerTip(_broker,_ilocal.get("broker","userRole"));
			}
			if(_user.isAdmin&&!_admin)
			{
				_admin = Utils.getURLGraphic(BASE_URL+_ilocal.get("icon_admin","chatPanel")) as Sprite;
				_iui.registerTip(_admin,_ilocal.get("admin","userRole"));
			}
			if(_user.agent&&!_agent)
			{
				_agent = Utils.getURLGraphic(BASE_URL+_ilocal.get("icon_agent","chatPanel")) as Sprite;
				_iui.registerTip(_agent,_ilocal.get("agent","userRole"));
			}
			if(_user.saler&&!_saler)
			{
				_saler = Utils.getURLGraphic(BASE_URL+_ilocal.get("icon_saler","chatPanel")) as Sprite;
				_iui.registerTip(_saler,_ilocal.get("saler","userRole"));
			}
			if(_user.assistant&&!_assistant)
			{
				_assistant = Utils.getURLGraphic(BASE_URL+_ilocal.get("icon_assistant","chatPanel")) as Sprite;
				_iui.registerTip(_assistant,_ilocal.get("assistant","userRole"));
			}
			if(_user.normalAdmin&&!_nAdmin)
			{
				_nAdmin = Utils.getURLGraphic(BASE_URL+_ilocal.get("icon_normalAdmin","chatPanel")) as Sprite;
				_iui.registerTip(_nAdmin,_ilocal.get("nAdmin","userRole"));
			}
		}
		
		override public function addChild(child:DisplayObject):DisplayObject
		{
			super.addChild(child);
			_hasGraphic = true;
			return child;
		}
		
		private function updateInfo():void
		{
			this.graphics.clear();
			this.removeChildren();
			_hasGraphic = false;
			var w:int = 24;
			var h:int = 24;
			if(_user)
			{
				//紫色vip（黄色vip）>房主>巡管>代理(经纪人)>房管>助理>主播等级>财富等级
				if(_user.vip>0)
				{
					var vipKey:String = BASE_URL + _ilocal.get("icon_vip"+_user.vip,"chatPanel");
					_vip.url = vipKey;
					addChild(_vip);
				}
				if(_user.broker)
				{
					addChild(_broker);
				}
				
				if(_user.isAdmin)
				{
					addChild(_admin);
				}else if(_user.agent){
					addChild(_agent);					
				}else if(_user.saler){
					addChild(_saler);
				}
				
				if(!_user.isAdmin&&_user.normalAdmin)
				{
					addChild(_nAdmin);
				}
				
				if(_user.assistant)
				{
					addChild(_assistant);
				}
				if(Number(_user.starLevel)>0)
				{
					var _stype:String = (int(_user.starLevel) > 25) ? ".swf" : ".png";
					_star.url = BASE_URL + "lv" + _user.starLevel + _stype;
					addChild(_star);
				}
				if(Number(_user.richLevel)>0)
				{
					var _rtype:String = (int(_user.richLevel) > 25) ? ".swf" : ".png";
					_rich.url = BASE_URL + "cflv" + _user.richLevel + _rtype;
					addChild(_rich);
				}
			}
		}
		
	}
}