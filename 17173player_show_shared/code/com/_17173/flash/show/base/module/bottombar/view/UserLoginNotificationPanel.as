package com._17173.flash.show.base.module.bottombar.view
{
	import flash.display.Sprite;
	
	public class UserLoginNotificationPanel extends Sprite
	{
		
		public function UserLoginNotificationPanel()
		{
			super();
		}
		
		public function set data(value:Object):void {
			var notification:UserLoginNotification = createNotification(value);
			addChild(notification);
		}
		
		private function createNotification(user:Object):UserLoginNotification {
			var n:UserLoginNotification = new UserLoginNotification();
			n.data = user;
			n.x = -n.width;
			n.y = -n.height;
			return n;
		}
		
	}
}