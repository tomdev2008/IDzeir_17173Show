package com._17173.flash.show.base.module.userlist.view
{
	import com._17173.flash.core.components.common.HGroup;
	import com._17173.flash.core.components.common.Label;
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.locale.ILocale;
	import com._17173.flash.show.base.components.common.BitmapMovieClip;
	import com._17173.flash.show.base.context.user.IUser;
	import com._17173.flash.show.base.context.user.IUserData;
	import com._17173.flash.show.base.module.userCard.UserCardData;
	import com._17173.flash.show.base.utils.FontUtil;
	import com._17173.flash.show.base.utils.Utils;
	import com._17173.flash.show.model.CEnum;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextFormat;
	
	/**
	 * 用户列表主播显示卡 
	 * @author idzeir
	 * 
	 */	
	public class BrokerBox extends HGroup
	{
		/**
		 * 主播等级
		 */
		private var _level:BitmapMovieClip;
		/**
		 * 主播名字
		 */
		private var _nameTxt:Label;
		/**
		 * 主播标记
		 */
		private var _broker:Sprite;

		private var _ilocal:ILocale;

		private const BASE_URL:String = "assets/img/level/";
		
		private var _user:IUserData;
		/**
		 * 主播显示卡 
		 */		
		public function BrokerBox()
		{
			super();
			this.mouseChildren = false;
			this.top = 5;
			this.left = 10;
			this.valign = HGroup.MIDDLE;

			_nameTxt = new Label({maxW: 100});
			_nameTxt.defaultTextFormat = new TextFormat(FontUtil.f, 14, 0xD0CCD7,false);

			_ilocal = Context.getContext(CEnum.LOCALE) as ILocale;

			_broker = Utils.getURLGraphic(BASE_URL + _ilocal.get("icon_broker", "chatPanel")) as Sprite;
			
			this.addEventListener(MouseEvent.MOUSE_OVER,overHandler);
			this.addEventListener(MouseEvent.MOUSE_OUT,overHandler);
		}
		
		private function overHandler(e:MouseEvent):void
		{
			var _iuser:IUser = Context.getContext(CEnum.USER) as IUser;
			switch(e.type)
			{
				case MouseEvent.MOUSE_OVER:
					var stagePos:Point=this.localToGlobal(new Point(176,0));
					_iuser.showCard(_user.id,stagePos,[UserCardData.HIDE_MIC_LIST],false);
					break;
				case MouseEvent.MOUSE_OUT:
					_iuser.autoHideCard();
					break;
			}
		}

		private function reset():void
		{
			this.graphics.clear();
			this.removeChildren();
			if(this.contains(_broker))
			{
				this.removeRawChild(_broker);
			}
			//_level = null;
			_user = null;
		}
		
		public function get user():IUserData
		{
			return _user;
		}

		public function set user(value:IUserData):void
		{
			reset();
			_user = value;
			if(value.broker)
			{
				if(!_level)
				{
					_level = new BitmapMovieClip();
				}
			}
			var _stype:String = (int(value.starLevel) > 25) ? ".swf" : ".png";
			_level.url = BASE_URL + "lv" + user.starLevel + _stype;

			this.addChild(_level);

			_nameTxt.text = value.name;
			this.addChild(_nameTxt);

			this.graphics.beginFill(0x000000, .4);
			this.graphics.drawRect(0, 0, 174, 34);
			this.graphics.endFill();
			
			var _x:int = this.width - _broker.width - 10;
			var _y:int = (this.height - _broker.height) >> 1;
			this.addRawChildAt(_broker, this.numChildren, _x, _y);
		}
	}
}