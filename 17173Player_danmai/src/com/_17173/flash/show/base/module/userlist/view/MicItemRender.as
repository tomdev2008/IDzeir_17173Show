package com._17173.flash.show.base.module.userlist.view
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.show.base.components.common.UserItemRender;
	import com._17173.flash.core.components.interfaces.IItemRender;
	import com._17173.flash.show.base.context.user.IUser;
	import com._17173.flash.show.base.context.user.IUserData;
	import com._17173.flash.show.model.CEnum;
	
	import flash.geom.Point;

	/**
	 * 麦序列表信息卡
	 * @author idzeir
	 * 创建时间：2014-2-28  下午5:03:05
	 */
	public class MicItemRender extends UserItemRender implements IItemRender
	{

		private var micIndexBox:MicOrderBox;
		private var _user:IUserData;

		public function MicItemRender()
		{
			super();
			this.mouseChildren = false;
			this._head.width = 16;
			this._head.height = 32;

			micIndexBox = new MicOrderBox();
			micIndexBox.y = 9;
			micIndexBox.x = 10;
			this.addChild(micIndexBox);
		}

		override public function set user(value:IUserData):void
		{
			_user = value;
			this._simpleRender.startUp(value);
			//micIndex=value.micStatus;
			if(this.micIndexBox.visible)
			{
				this._content.addChild(this._head);
				this._simpleRender.overClip.x = -20;
			}
			else
			{
				this._simpleRender.overClip.x = 0;
			}
			_simpleRender.contentWidth = 170;
			_content.addChild(this._simpleRender);
		}

		public function set micIndex(value:uint):void
		{
			micIndexBox.micIndex = value;
		}

		public function startUp(value:Object):void
		{
			this.user = value.user as IUserData;
			micIndex = value.index;
		}
		
		override public function get height():Number
		{
			return _simpleRender.height;
		}

		public function set onOver(bool:Boolean):void
		{
			this._simpleRender.onOver = bool;
		}

		public function onMouseOver():void
		{
			this.onOver = true;
			var stagePos:Point = this.localToGlobal(new Point(this.width+5, 0));
			var hasUser:Boolean = (Context.getContext(CEnum.USER) as IUser).getUser(this._user.id) ? true : false;
			if(hasUser)
			{
				(Context.getContext(CEnum.USER) as IUser).showCard((this._user as IUserData).id, stagePos);
			}
		}

		public function onMouseOut():void
		{
			this.onOver = false;
			var hasUser:Boolean = (Context.getContext(CEnum.USER) as IUser).getUser(this._user.id) ? true : false;
			if(hasUser)
			{
				(Context.getContext(CEnum.USER) as IUser).autoHideCard();
			}
		}

		public function onSelected():void
		{
			//this._simpleRender.onSelected();						
		}

		public function unSelected():void
		{
			this._simpleRender.unSelected();
		}
	}
}

import com._17173.flash.core.context.Context;
import com._17173.flash.core.locale.ILocale;
import com._17173.flash.show.base.utils.FontUtil;
import com._17173.flash.show.model.CEnum;

import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFormat;

class MicOrderBox extends Sprite
{
	private var _micTxt:TextField = new TextField();

	public function MicOrderBox():void
	{
		this.graphics.beginFill(0x3F007F);
		this.graphics.drawRect(0, 0, 16, 32);
		this.graphics.endFill();

		this._micTxt.autoSize = "left";
		//this._micTxt.selectable=false;
		this._micTxt.text = "";
		var tf:TextFormat = new TextFormat(FontUtil.f, null, 0xffffff, true);
		this._micTxt.defaultTextFormat = tf;
		this.mouseChildren = false;

		this.addChild(this._micTxt);
	}

	public function set micIndex(value:uint):void
	{
		var order:uint = 0;
		switch(value)
		{
			case 1:				
			case 2:				
			case 3:
				order = value;
				break;
			default:
				order = 4;				
				break;
		}
		this._micTxt.text = (Context.getContext(CEnum.LOCALE) as ILocale).get("micName"+order,"userList").split("").join("\n");
		this.visible = true;
		this._micTxt.y = (32 - this._micTxt.height) * .5;
		this._micTxt.x = (16 - this._micTxt.width) * .5;
	}
}