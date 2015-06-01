package com._17173.flash.show.base.module.userlist.view
{
	import com._17173.flash.core.components.common.HGroup;
	import com._17173.flash.core.components.common.Label;
	import com._17173.flash.core.components.common.VGroup;
	import com._17173.flash.core.components.interfaces.IItemRender;
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.locale.ILocale;
	import com._17173.flash.show.base.components.common.BitmapMovieClip;
	import com._17173.flash.show.base.context.layer.IUIManager;
	import com._17173.flash.show.base.context.resource.IResourceData;
	import com._17173.flash.show.base.context.resource.IResourceManager;
	import com._17173.flash.show.base.context.user.IUser;
	import com._17173.flash.show.base.context.user.IUserData;
	import com._17173.flash.show.base.module.userCard.UserCardData;
	import com._17173.flash.show.base.utils.FontUtil;
	import com._17173.flash.show.base.utils.Utils;
	import com._17173.flash.show.model.CEnum;
	
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.text.TextFormat;
	
	/**
	 * 用户列表信息卡片 
	 * @author idzeir
	 * 
	 */	
	public class UserListItem extends Sprite implements IItemRender
	{
		/**
		 * 用户名称
		 */
		private var _nameTxt:Label;
		/**
		 * 财富等级
		 */
		private var _rich:BitmapMovieClip;
		/**
		 * 主播等级
		 */
		private var _star:BitmapMovieClip;
		/**
		 * 经纪人（房主）
		 */
		private var _broker:Sprite;
		/**
		 * vip图标
		 */
		private var _vip:BitmapMovieClip;
		/**
		 * 巡管图标
		 */
		private var _admin:Sprite;
		/**
		 * 代理图标
		 */
		private var _agent:Sprite;
		/**
		 * 房间管理员图标
		 */
		private var _nAdmin:Sprite;
		/**
		 * 整个显示对象容器
		 */
		private var _box:VGroup;
		//第一行图标
		private var _firstBox:HGroup;
		//第二行图标
		private var _iconBox:HGroup;
		
		public var overClip:Shape;
		
		private var _data:*;
		
		private const BASE_URL:String = "assets/img/level/";
		
		private var _ilocal:ILocale;
		private var _iUi:IUIManager;
		private var _iUser:IUser;
		
		public function UserListItem()
		{
			super();
			_box = new VGroup();
			_box.gap = 5;
			_box.left = 10;
			_box.top = 5;
			
			_firstBox = new HGroup();
			_firstBox.valign = HGroup.MIDDLE;
			_firstBox.gap = 5;
			
			_iconBox = new HGroup();
			_iconBox.gap = 5;
			_iconBox.valign = HGroup.TOP;
			
			_nameTxt = new Label({maxW:120});
			_nameTxt.defaultTextFormat=new TextFormat(FontUtil.f,14,0x63acff,false);
			_vip = new BitmapMovieClip();
			_vip.addEventListener(Event.ADDED_TO_STAGE,onAddedVip);
			_vip.addEventListener(Event.REMOVED_FROM_STAGE,onRemovedVip);
			
			overClip = new Shape();
			
			_ilocal = Context.getContext(CEnum.LOCALE) as ILocale;
			_iUi = Context.getContext(CEnum.UI) as IUIManager;
			_iUser = Context.getContext(CEnum.USER) as IUser;
			this.addChild(_box);
		}
		
		protected function onRemovedVip(event:Event):void
		{
			_vip.stop();
		}
		
		protected function onAddedVip(event:Event):void
		{
			_vip.play();
		}
		
		protected function dispose():void
		{
			reset();
			_vip.removeEventListener(Event.ADDED_TO_STAGE,onAddedVip);
			_vip.removeEventListener(Event.REMOVED_FROM_STAGE,onRemovedVip);
			_vip.stop();
		}
		
		/**
		 * 重置图标显示 
		 */		
		private function reset():void
		{
			this._data = null;
			_firstBox.removeChildren();
			_broker = null;
			_iconBox.removeChildren();
			_admin = null;
			_agent = null;
			_nAdmin = null;
			_box.removeChildren();
			overClip.graphics.clear();
			this.onOver = false;
		}
		
		/**
		 * 按照用户数据初始化信息显示 
		 * @param value
		 * 
		 */		
		public function startUp(value:Object):void
		{
			if(value==null){return};			
			this.reset();
			this._data = value;
			var user:IUserData = value as IUserData;
			var iUser:IUser = Context.getContext(CEnum.USER) as IUser;
			
			//主播等级显示
			if(user.broker)
			{
				if(int(user.starLevel)>0)
				{
					if(!_star)
					{
						_star = new BitmapMovieClip();
					}
					var _stype:String = (int(user.starLevel) > 25) ? ".swf" : ".png";
					_star.url = BASE_URL + "lv" + user.starLevel + _stype;
					_firstBox.addChild(_star);
				}
			}else{
				if(int(user.richLevel)>0)
				{
					if(!_rich)
					{
						_rich = new BitmapMovieClip();
					}
					var _rtype:String = (int(user.richLevel) > 25) ? ".swf" : ".png";
					_rich.url = BASE_URL + "cflv" + user.richLevel + _rtype;
					_firstBox.addChild(_rich);
				}
			}
			//用户名
			_nameTxt.htmlText = user.name;	
			_nameTxt.textColor = user.id == iUser.me.id?0xD0CCD7:0xA198AF;
			_firstBox.addChild(_nameTxt);
			//房主显示图标
			if(user.broker)
			{
				_broker = Utils.getURLGraphic(BASE_URL+_ilocal.get("icon_broker","chatPanel"),true,24,24) as Sprite;
				_firstBox.addChild(_broker);
			}
			_box.addChild(_firstBox);
			
			if(user.broker)
			{
				this.graphics.clear();
				this.graphics.beginFill(0x000000,.4);
				this.graphics.drawRect(0,0,210,_box.height+10);
				this.graphics.endFill();
			}else{
				//非主播显示
				//是否包含icon图标
				var has:Boolean = user.vip||user.isAdmin||user.agent||user.normalAdmin;
				//vip
				if(user.vip>0)
				{
					var vipKey:String = BASE_URL + _ilocal.get("icon_vip"+user.vip,"chatPanel");
					var _res:IResourceManager = Context.getContext(CEnum.SOURCE) as IResourceManager;
					_res.loadResource(vipKey,function(data:IResourceData):void
					{
						_res.addAnimDatas4Mc(vipKey,data.newSource as MovieClip,false);
						_vip.data = _res.getAnimDatas(vipKey);
					});
					_iconBox.addChild(_vip);
				}
				//巡管
				if(user.isAdmin)
				{
					_admin = Utils.getURLGraphic(BASE_URL+_ilocal.get("icon_admin","chatPanel")) as Sprite;
					_iconBox.addChild(_admin);
				}
				//代理
				if(user.agent)
				{
					_agent = Utils.getURLGraphic(BASE_URL+_ilocal.get("icon_agent","chatPanel")) as Sprite;
					_iconBox.addChild(_agent);
				}
				//管理员
				if(!user.isAdmin&&user.normalAdmin)
				{
					_nAdmin = Utils.getURLGraphic(BASE_URL+_ilocal.get("icon_normalAdmin","chatPanel")) as Sprite;
					_iconBox.addChild(_nAdmin);
				}
				
				if(has)
				{
					_box.addChild(_iconBox);
				}
			}
			overClip.graphics.beginFill(0x4E025C,.9);
			overClip.graphics.drawRect(0,0,166,_box.height + 10);
			overClip.graphics.endFill();
		}
		
		/**
		 * 覆盖返回背景的高度 
		 * @return 
		 */		
		override public function get height():Number
		{
			return overClip.height;
		}
		/**
		 * 鼠标滑过处理
		 */		
		public function onMouseOver():void
		{
			this.onOver=true;
			var stagePos:Point=this.localToGlobal(new Point(176,0));
			var hasUser:Boolean = (Context.getContext(CEnum.USER) as IUser).getUser(this._data.id) ? true : false;
			if(hasUser){
				(Context.getContext(CEnum.USER) as IUser).showCard((this._data as IUserData).id, stagePos, [UserCardData.HIDE_MIC_LIST],false);
			}
		}
		/**
		 * 设置滑过的展示背景
		 */	
		public function set onOver(bool:Boolean):void
		{
			var iuser:IUserData = _data as IUserData;
			if(iuser&&iuser.broker)
			{
				return;
			}
			if (bool)
			{
				this.addChildAt(overClip, 0);
			}
			else if (this.contains(overClip))
			{
				this.removeChild(overClip);
			}
		}
		/**
		 * 鼠标滑出处理 
		 */		
		public function onMouseOut():void
		{
			this.onOver=false;
			var hasUser:Boolean = (Context.getContext(CEnum.USER) as IUser).getUser(this._data.id) ? true : false;
			if(hasUser){
				(Context.getContext(CEnum.USER) as IUser).autoHideCard();
			}
		}
		/**
		 * 选中
		 */		
		public function onSelected():void
		{
		}
		/**
		 * 取消选中
		 */	
		public function unSelected():void
		{
		}
	}
}