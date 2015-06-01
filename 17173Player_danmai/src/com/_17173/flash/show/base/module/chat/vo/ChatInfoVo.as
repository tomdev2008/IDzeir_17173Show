package com._17173.flash.show.base.module.chat.vo
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.show.base.context.text.IGraphicTextManager;
	import com._17173.flash.show.base.context.user.IUser;
	import com._17173.flash.show.base.context.user.IUserData;
	import com._17173.flash.show.base.utils.FontUtil;
	import com._17173.flash.show.base.utils.Utils;
	import com._17173.flash.show.model.CEnum;
	
	import flash.display.DisplayObject;
	import flash.text.engine.ContentElement;
	import flash.text.engine.ElementFormat;
	import flash.text.engine.GraphicElement;
	import flash.text.engine.TextElement;

	/**
	 * 用户聊天信息类
	 * @author idzeir
	 * 创建时间：2014-3-14  下午1:50:24
	 */
	public class ChatInfoVo extends BaseChatVo
	{
		private var _opUser:IUserData;
		private var _toUser:IUserData;
		private var _info:String;
		private var _action:String;

		private const ICON_W:Number = 30;
		private const ICON_H:Number = 16;

		/**
		 * 公聊类型
		 */
		public static const PUBLIC_INFO:String = "0";
		/**
		 * 私聊类型
		 */
		public static const PRIVATE_INFO:String = "1";
		/**
		 * 公共私聊
		 */
		public static const PUBLIC_PRI_INFO:String = "2";

		/**
		 * 聊天信息
		 * @param op 发送用户
		 * @param to 接收用户
		 * @param msg 聊天消息
		 * @param _cAction 聊天类型
		 *
		 */
		public function ChatInfoVo(op:IUserData = null, to:IUserData = null, msg:String = "", _cAction:String = "0")
		{
			super();

			_opUser = op;
			_toUser = to;
			_info = msg;
			_action = _cAction;
		}
		
		private function createUserICON(_user:IUserData):Boolean
		{
			var limitlv:int = Context.variables["conf"].showIcon;
			var icon:DisplayObject;
			var gElement:GraphicElement;
			var textElement:TextElement;
			var w:Number = ICON_W;
			var h:Number = ICON_H
			if(_user)
			{
				var iconURL:String = "";
				if(_user.isAdmin)
				{
					w = 16;
					h = 16;
					iconURL = "admin";
				}else if(_user.agent){
					w = 16;
					h = 16;
					iconURL = "agent";
				}else if(parseInt(_user.richLevel) >= limitlv){						
					iconURL = "cflv" + _user.richLevel;
				}
				
				if(iconURL!="")
				{
					icon = Utils.getURLGraphic("assets/img/level/"+ iconURL + ".png",true,w,h);
					gElement = new GraphicElement(icon, icon.width, icon.height, FontUtil.getFormat());
					_elems.push(gElement);
					return true;
				}				
			}
			return false;
		}
		
		override protected function initVo():void
		{
			super.initVo();
			this._elems.push(this.timeStamp);
			var iuser:IUser = Context.getContext(CEnum.USER) as IUser;
			var icon:DisplayObject;
			var gElement:GraphicElement;
			var textElement:TextElement;
			var limitlv:int = Context.variables["conf"].showIcon;
			var hasIcon:Boolean = false;
			switch(_action)
			{
				case PUBLIC_INFO:					
					hasIcon = this.createGraphicFromArray(this.getUsericon(_opUser));				
					textElement = new TextElement((hasIcon?" ":"")+unescape(_opUser.name), this.getNameTF(_opUser));
					textElement.eventMirror = (Context.getContext(CEnum.GRAPHIC_TEXT) as IGraphicTextManager).controler;
					textElement.userData = _opUser;
					_elems.push(textElement); 
					
					textElement = new TextElement(" : ",FontUtil.getFormat());
					_elems.push(textElement);
					break;
				case PRIVATE_INFO:
				case PUBLIC_PRI_INFO:
					hasIcon = this.createGraphicFromArray(this.getUsericon(_opUser));
					var opName:String = (iuser.me == _opUser && action == PUBLIC_PRI_INFO) ? "我" : unescape(_opUser.name);
					
					textElement = new TextElement((hasIcon ? " " : "") + opName, this.getNameTF(_opUser));
					textElement.eventMirror = (Context.getContext(CEnum.GRAPHIC_TEXT) as IGraphicTextManager).controler;
					textElement.userData = _opUser;
					_elems.push(textElement);


					textElement = new TextElement(" 对 ", FontUtil.getFormat());
					_elems.push(textElement);

					hasIcon = false;//this.createGraphicFromArray(this.getUsericon(_toUser));					
					
					var toName:String = (iuser.me == _toUser && action == PUBLIC_PRI_INFO) ? "我" : unescape(_toUser.name);
					textElement = new TextElement((hasIcon ? " " : "") + toName, this.getNameTF(_toUser));
					textElement.userData = _toUser;
					textElement.eventMirror = (Context.getContext(CEnum.GRAPHIC_TEXT) as IGraphicTextManager).controler;

					_elems.push(textElement);


					textElement = new TextElement(" : ", FontUtil.getFormat());
					_elems.push(textElement);
					break;
			}
			
			var msgTf:ElementFormat;// = (PUBLIC_INFO != action && iuser.me.id == _toUser.id) ? FontUtil.getFormat(0xff56ea) : this.getMsgTF(_opUser)
			if(_opUser["id"] == iuser.me.id){
				msgTf = FontUtil.getFormat(0x00FFE5);
			}else if(_toUser&&_toUser["id"] == iuser.me.id){
				msgTf = FontUtil.getFormat(0xFF9966);
			}else{
				msgTf = FontUtil.getFormat(0xCCCCCC);
			}
			
			//加入聊天内容
			var msg:Vector.<ContentElement> = (Context.getContext(CEnum.GRAPHIC_TEXT) as IGraphicTextManager).factory.getElements(_info, msgTf);
			msg.forEach(function(e:*, index:*, arr:*):void
				{
					_elems.push(e);
				});
		}

		override public function reset():void
		{
			super.reset();

			_opUser = null;
			_toUser = null;
			_info = null;
			_action = null;
			_time = null;
			_groupElems = null;
		}

		override protected function dispose():void
		{
			super.dispose();
			_opUser = null;
			_toUser = null;
		}

		/**
		 * 聊天的类型 "0"公聊,"1"私聊,"2"公共私聊
		 */
		public function get action():String
		{
			return _action;
		}

		/**
		 * @private
		 */
		public function set action(value:String):void
		{
			_action = value;
		}

		/**
		 * 发送的内容
		 */
		public function set info(value:String):void
		{
			_info = value;
		}

		/**
		 * 接收的用户
		 */
		public function set toUser(value:IUserData):void
		{
			_toUser = value;
		}

		/**
		 * 发送的用户
		 */
		public function set opUser(value:IUserData):void
		{
			_opUser = value;
		}

	}
}