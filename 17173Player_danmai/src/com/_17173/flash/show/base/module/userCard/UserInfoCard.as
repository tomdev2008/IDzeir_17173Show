package com._17173.flash.show.base.module.userCard
{
	import com._17173.flash.core.components.common.HGroup;
	import com._17173.flash.core.components.common.Label;
	import com._17173.flash.core.components.common.VGroup;
	import com._17173.flash.show.base.context.user.IUserData;
	import com._17173.flash.show.base.utils.FontUtil;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.text.TextFormat;
	
	public class UserInfoCard extends Sprite
	{
		/**
		 * 头像34X34
		 */
		private var _head:Face;
		/**
		 * 用户名
		 */
		private var _nameTxt:Label;
		/**
		 * 靓号
		 */
		private var _masterNo:Label;
		
		private var _user:IUserData;
		
		private var _box:HGroup;
		private var _rightBox:VGroup;
		
		private var _faceMask:Shape;
		
		public function UserInfoCard()
		{
			super();
			_nameTxt = new Label({maxW:120});
			_nameTxt.defaultTextFormat = new TextFormat(FontUtil.f,12,0xFFFFFF,false);
			_masterNo = new Label({maxW:120});
			_masterNo.defaultTextFormat = new TextFormat(FontUtil.f,12,0xDE0087,false);
			
			_box = new HGroup();
			_box.valign = HGroup.MIDDLE;
			
			
			_rightBox = new VGroup();
			_rightBox.gap = -5;
			
			_head = new Face();
			_faceMask = new Shape();
			_faceMask.graphics.beginFill(0x000000,0);
			_faceMask.graphics.drawCircle(17,17,17);
			_faceMask.graphics.endFill();
			
			this.addChild(_box);
		}
		
		public function set user(value:IUserData):void
		{
			clear();
			
			_user = value;
			
			_nameTxt.text = _user.name;
			_masterNo.text = "("+_user.masterNo+")";
			_rightBox.addChild(_nameTxt);
			if(_user.masterNo!="")_rightBox.addChild(_masterNo);
			
			createUserFace();
			
			_box.addChild(_head);
			_box.addChild(_rightBox);
			
			//_nameTxt.opaqueBackground = 0xff0000;
			//_masterNo.opaqueBackground = 0x00ff00;
			//_head.opaqueBackground = 0x0000ff;
		}
		
		private function createUserFace():void
		{
			_head.head = _user.head;
		}
		
		private function clear():void
		{
			_user = null;
			_box.removeChildren();
			_rightBox.removeChildren();
		}
	}
}