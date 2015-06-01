package com._17173.flash.show.base.module.chat.vo
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.locale.ILocale;
	import com._17173.flash.show.base.context.user.IUser;
	import com._17173.flash.show.base.context.user.IUserData;
	import com._17173.flash.show.base.utils.FontUtil;
	import com._17173.flash.show.base.utils.TimeUtil;
	import com._17173.flash.show.model.CEnum;
	
	import flash.text.engine.ContentElement;
	import flash.text.engine.ElementFormat;
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
				return FontUtil.getFormat(0xd0cfcf);
			}
			else
			{
				//普通用户
				return FontUtil.getFormat(0xd0cfcf);
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