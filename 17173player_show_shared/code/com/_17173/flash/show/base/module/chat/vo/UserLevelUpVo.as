package com._17173.flash.show.base.module.chat.vo
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.show.base.context.resource.IResourceData;
	import com._17173.flash.show.base.context.resource.IResourceManager;
	import com._17173.flash.show.base.context.text.IGraphicTextManager;
	import com._17173.flash.show.base.context.user.IUserData;
	import com._17173.flash.show.base.utils.FontUtil;
	import com._17173.flash.show.base.utils.Utils;
	import com._17173.flash.show.model.CEnum;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.text.engine.GraphicElement;
	import flash.text.engine.TextElement;

	/**
	 * 用户升级消息类
	 * @author idzeir
	 * 创建时间：2014-3-14  上午11:48:45
	 */
	public class UserLevelUpVo extends BaseChatVo
	{
		private var _uName:String;
		private var _type:uint;
		private var _level:uint;
		private var _isMe:Boolean;
		private var _user:IUserData;

		/**
		 * 升级的类型（财富）
		 */
		static public const UP_TYPE_RICH:uint = 3;
		/**
		 * 升级的类型（主播）
		 */
		static public const UP_TYPE_ANCHORS:uint = 2;

		/**
		 * 用户主播等级和财富等级提升信息
		 * @param _user 用户
		 * @param upType 升级类型 （2为主播等级、3为财富等级）
		 * @param tolv 升级之后的级别
		 * @param _me 是否是本人
		 *
		 */
		public function UserLevelUpVo(_user:IUserData = null, upType:uint = 0, tolv:uint = 0, _me:Boolean = false)
		{
			super();
			this._user = _user;
			_uName = _user ? _user.name : "";
			_type = upType;
			_level = tolv;
			_isMe = _me;
		}
		
		private function createPublicElement():void
		{
			var textElement:TextElement;
			textElement = new TextElement("系统消息：恭喜 ",FontUtil.getFormat(0xec7218));
			_elems.push(textElement);
			
			textElement = new TextElement(_uName,FontUtil.getFormat(0x63acff));
			textElement.eventMirror = (Context.getContext(CEnum.GRAPHIC_TEXT) as IGraphicTextManager).controler;
			textElement.userData = _user;
			_elems.push(textElement);
			
			textElement = new TextElement(" "+(_type == UP_TYPE_ANCHORS ? "艺人" : "财富") + "等级提升至 ", FontUtil.getFormat(0xec7218));
			_elems.push(textElement);

			var ico:DisplayObject = Utils.getURLGraphic("assets/img/level/" + (_type == UP_TYPE_ANCHORS ? "lv" : "cflv") + _level + ".png", true, 30, 16);
			var graphicElement:GraphicElement = new GraphicElement(ico, ico.width, ico.height, FontUtil.getFormat());
			_elems.push(graphicElement);
		}
		
		private function createPrivateElement():void
		{
			var textElement:TextElement;
			textElement = new TextElement("您的"+(_type == UP_TYPE_ANCHORS ? "艺人" : "财富")+"等级达到 ", FontUtil.getFormat(0xec7218));
			_elems.push(textElement);
			
			var ico:DisplayObject = Utils.getURLGraphic("assets/img/level/" + (_type == UP_TYPE_ANCHORS ? "lv" : "cflv") + _level + ".png", true, 30, 16);
			var graphicElement:GraphicElement = new GraphicElement(ico, ico.width, ico.height, FontUtil.getFormat());
			_elems.push(graphicElement);
			
			textElement = new TextElement("，"+(_type == UP_TYPE_ANCHORS ? "离金光闪闪的巨星又近了一步。" : "威武啊。"), FontUtil.getFormat(0xec7218));
			_elems.push(textElement);
		}

		override protected function initVo():void
		{
			super.initVo();
			this._elems.push(this.timeStamp);
			if(!_isMe)
			{
				//公聊区显示
				createPublicElement();
			}else{
				//私聊区显示
				createPrivateElement();
			}
			/*var textElement:TextElement;
			textElement = new TextElement(_isMe ? "您好，您" : _uName + " ", _isMe ? FontUtil.getFormat(0xec7218) : FontUtil.getFormat(0x63acff));
			if(!_isMe)
			{
				textElement.eventMirror = (Context.getContext(CEnum.GRAPHIC_TEXT) as IGraphicTextManager).controler;
				textElement.userData = _user;
			}
			_elems.push(textElement);

			textElement = new TextElement("的" + (_type == UP_TYPE_ANCHORS ? "艺人" : "财富") + "等级达到了 ", FontUtil.getFormat(0xec7218));
			_elems.push(textElement);

			textElement = new TextElement(String(_level), FontUtil.getFormat(0xefe46c));
			_elems.push(textElement);

			textElement = new TextElement(" 级 ", FontUtil.getFormat(0xec7218));
			_elems.push(textElement);

			var ico:Sprite = new Sprite();
			ico.graphics.beginFill(0x000000, 0);
			ico.graphics.drawRect(0, 0, 30, 16);
			ico.graphics.endFill();
			(Context.getContext(CEnum.SOURCE) as IResourceManager).loadResource("assets/img/level/" + (_type == UP_TYPE_ANCHORS ? "lv" : "cflv") + _level + ".png", function(value:IResourceData):void
				{
					var source:DisplayObject = value.newSource as DisplayObject;
					if(source)
					{
						source.width = 30;
						source.height = 16;
						ico.addChild(source);
						ico.graphics.clear();
					}
				})
			var graphicElement:GraphicElement = new GraphicElement(ico, ico.width, ico.height, FontUtil.getFormat());
			_elems.push(graphicElement);

			if(_isMe)
			{
				textElement = new TextElement(_type == UP_TYPE_ANCHORS ? " ,离金光闪闪的巨星又近了一步。" : " 继续加油呀。", FontUtil.getFormat(0xec7218));
				_elems.push(textElement);
			}*/
		}

		public function set user(u:IUserData):void
		{
			this._user = u;
		}

		/**
		 * 是否是本人
		 */
		public function set isMe(value:Boolean):void
		{
			_isMe = value;
		}

		/**
		 * 达到的级别
		 */
		public function set level(value:uint):void
		{
			_level = value;
		}

		/**
		 * 升级类型
		 */
		public function set type(value:uint):void
		{
			_type = value;
		}

		/**
		 * 升级的用户名称
		 */
		public function set uName(value:String):void
		{
			_uName = value;
		}

		override protected function dispose():void
		{
			super.dispose();
			_user = null;
		}
	}
}