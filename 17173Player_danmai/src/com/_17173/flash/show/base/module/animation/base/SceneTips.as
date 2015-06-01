package com._17173.flash.show.base.module.animation.base
{
	public class SceneTips
	{
		public function SceneTips()
		{
				
		}
		
		public static const TIPS:Array = [
			"亲爱的，请多多支持我哟~",
			"亲爱的，不要总点人家嘛~",
			"我唱歌很好的哟，别忘记关注哦~",
			"欢迎来到我的直播间，请一定要常来呦!",
			"游客朋友请注册，注册的朋友请关注，关注的朋友请支持!"]
			
		public static function get tip():String{
			var len:int = TIPS.length;
			var rand:int = Math.floor(Math.random() * len);
			return TIPS[rand];
		}
	}
}