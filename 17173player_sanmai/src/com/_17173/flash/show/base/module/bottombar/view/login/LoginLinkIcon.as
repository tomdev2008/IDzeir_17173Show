package com._17173.flash.show.base.module.bottombar.view.login
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	public class LoginLinkIcon extends Sprite
	{
		/**
		 *快捷链接类型 
		 */		
		private var _linkType:String;
		public function LoginLinkIcon(type:String,icon:DisplayObject)
		{
			super();
			_linkType = type;
			this.addChild(icon);
			buttonMode = true;
		}

		public function get linkType():String
		{
			return _linkType;
		}

	}
}