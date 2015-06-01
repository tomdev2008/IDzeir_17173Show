package com._17173.flash.show.base.module.chat.vo
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.locale.ILocale;
	import com._17173.flash.show.base.components.common.BitmapAnim;
	import com._17173.flash.show.base.components.common.BitmapMovieClip;
	import com._17173.flash.show.base.components.common.MasterNoMovie;
	import com._17173.flash.show.base.context.resource.IResourceData;
	import com._17173.flash.show.base.context.resource.IResourceManager;
	import com._17173.flash.show.base.context.user.IUser;
	import com._17173.flash.show.base.context.user.IUserData;
	import com._17173.flash.show.base.utils.FontUtil;
	import com._17173.flash.show.base.utils.TimeUtil;
	import com._17173.flash.show.base.utils.Utils;
	import com._17173.flash.show.model.CEnum;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.engine.ContentElement;
	import flash.text.engine.ElementFormat;
	import flash.text.engine.GraphicElement;
	import flash.text.engine.GroupElement;
	import flash.text.engine.TextElement;

	/**
	 * 聊天面板展示信息基类
	 * @author idzeir
	 * 创建时间：2014-3-14  上午10:34:51
	 */
	public class BaseChatVo implements IBaseChatVo
	{
		protected var _ilocal:ILocale;
		
		protected var _groupElems:GroupElement;

		protected var _elems:Vector.<ContentElement>;

		protected var _time:String = "";

		public function BaseChatVo()
		{
			this._elems = new Vector.<ContentElement>();
			_ilocal = Context.getContext(CEnum.LOCALE) as ILocale;
		}

		/**
		 * 子类覆盖初始化个性样式
		 *
		 */
		protected function initVo():void
		{

		}

		protected function getUserName(data:IUserData):String
		{
			var user:IUser = (Context.getContext(CEnum.USER) as IUser);
			if(data == null)
				return "神秘人";
			if(data.id == user.me.id)
			{
				return "你";
			}
			return data.name;
		}

		/**
		 * 获取用户名的显示样式
		 * @param user
		 * @return
		 *
		 */
		protected function getNameTF(user:IUserData):ElementFormat
		{
			var iUser:IUser = (Context.getContext(CEnum.USER) as IUser);
			if(user == null)
				return FontUtil.getFormat();
			if(iUser.me.id == user.id)
			{
				//自己
				return FontUtil.getFormat(0x63acff);
			}
			else if(user.jinbi > 999999)
			{
				//暂时代替冠名用户
				return FontUtil.getFormat(0x63cfcf);
			}
			else if(parseInt(user.richLevel) > 0)
			{
				//财富等级用户
				return FontUtil.getFormat(0x63acff);
			}
			else
			{
				//普通用户
				return FontUtil.getFormat(0x63acff);
			}
		}
		
		/**
		 * 创建用户聊天区显示图标
		 * @param value 用户拥有的图标数组
		 * @return 返回是否包含图标
		 */
		protected function createGraphicFromArray(value:Vector.<DisplayObject>):Boolean
		{
			var has:Boolean = false;
			for each(var i:DisplayObject in value)
			{
				var ge:GraphicElement = new GraphicElement(i,i.width,i.height,FontUtil.getFormat());
				this._elems.push(ge);
				has = true;
			}
			return has;
		}
		
		/**
		 * 返回该用户在聊天中所带的图标
		 */
		protected function getUsericon(user:IUserData):Vector.<DisplayObject>
		{
			var iconMap:Vector.<DisplayObject> = new Vector.<DisplayObject>();
			var baseUrl:String = "assets/img/level/";
			var w:int = 24;
			var h:int = 24;
			var iUser:IUser = (Context.getContext(CEnum.USER) as IUser);
			
			var icon:DisplayObject;
			
			if(user)
			{
				if(user.isAdmin)
				{
					//巡管
					icon = Utils.getURLGraphic(baseUrl+ this._ilocal.get("icon_admin","chatPanel"),true,w,h);
					icon.y = 4;
					iconMap.push(icon);
				}else if(user.agent){
					//代理
					icon = Utils.getURLGraphic(baseUrl+ this._ilocal.get("icon_agent","chatPanel"),true,w,h);
					icon.y = 4;
					iconMap.push(icon);
				}else if(user.saler){
					//销售
					icon = Utils.getURLGraphic(baseUrl+ this._ilocal.get("icon_saler","chatPanel"),true,w,h);
					icon.y = 4;
					iconMap.push(icon);
				}else{
					if(user.vip>0)
					{
						//vip
						var key:String = baseUrl + this._ilocal.get("icon_vip"+user.vip,"chatPanel");
						var ires:IResourceManager = (Context.getContext(CEnum.SOURCE) as IResourceManager);
						
						var vipShape:BitmapAnim = new BitmapAnim();
						vipShape.graphics.beginFill(0xff0000,0);
						vipShape.graphics.drawRect(0,0,w,h);
						vipShape.graphics.endFill();
						
						var removeHandler:Function = function(value:Event):void
						{
							vipShape.removeEventListener(Event.REMOVED_FROM_STAGE,removeHandler);
							vipShape.dispose();
						}
						ires.loadResource(key,function(value:IResourceData):void
						{
							ires.addAnimDatas4Mc(key,(value.newSource as MovieClip));
							vipShape.data =ires.getAnimDatas(key);
							vipShape.loop = -1;
							vipShape.play();
						});
						vipShape.y = 4;
						vipShape.addEventListener(Event.REMOVED_FROM_STAGE,removeHandler);
						iconMap.push(vipShape);
					}
					if(int(user.richLevel)>0)
					{
						//财富等级
						var _rich:BitmapMovieClip = new BitmapMovieClip();
						var _rtype:String = (int(user.richLevel) > 25) ? ".swf" : ".png";
						_rich.url = baseUrl + "cflv" + user.richLevel + _rtype;
						_rich.y = 4;
						iconMap.push(_rich)
					}
				}
				if(user.masterNoFlag)
				{
					try{
						var no:MasterNoMovie = new MasterNoMovie(true,63,17);
						no.url = user.masterNoSwf;
						no.no = user.masterNo;
						no.y = 5;
						iconMap.push(no);
					}catch(e:Error){}	
				}
			}
			return iconMap;
		}

		/**
		 * 获取用户聊天内容显示样式
		 * @param user
		 * @return
		 *
		 */
		protected function getMsgTF(user:IUserData):ElementFormat
		{
			var iUser:IUser = (Context.getContext(CEnum.USER) as IUser);

			if(user == null)
				return FontUtil.getFormat();
			if(iUser.me.id == user.id)
			{
				//自己
				return FontUtil.getFormat(0x34ffee);
			}
			else if(user.jinbi > 999999)
			{
				//暂时代替冠名用户
				return FontUtil.getFormat(0xea00ff);
			}
			else if(parseInt(user.richLevel) > 0)
			{
				//财富等级用户
				return FontUtil.getFormat(0xCCCCCC);
			}
			else
			{
				//普通用户
				return FontUtil.getFormat(0xCCCCCC);
			}

			return FontUtil.getFormat();
		}

		/**
		 * 设置消息时间戳，默认为本机时间
		 * @param _time
		 *
		 */
		public function set time(_time:String):void
		{
			this._time = _time;
		}

		/**
		 * 时间戳
		 * @return
		 *
		 */
		protected function get timeStamp():TextElement
		{
			var textElement:TextElement = new TextElement((_time == "" || _time == null ? TimeUtil.getTimeFormat() : this._time) + " ", FontUtil.getFormat(0x63acff));
			return textElement;
		}

		public function get elements():GroupElement
		{
			initVo();
			var gpEl:GroupElement = new GroupElement(this._elems, FontUtil.getFormat());
			dispose();
			return gpEl;
		}

		public function reset():void
		{

		}

		protected function dispose():void
		{
			this._elems = null;
			this._time = "";
		}
	}
}