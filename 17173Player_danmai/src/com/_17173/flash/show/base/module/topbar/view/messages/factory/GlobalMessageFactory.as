package com._17173.flash.show.base.module.topbar.view.messages.factory
{
	import com._17173.flash.show.base.module.topbar.view.messages.GlobalMessageSprite;
	import com._17173.flash.show.base.module.topbar.view.messages.GlobalMessageYanhua;
	import com._17173.flash.show.base.module.topbar.view.messages.base.IGlobalMessageShow;

	public class GlobalMessageFactory implements IGlobalMessageFactory
	{
		public function GlobalMessageFactory()
		{
		}
		
		public function getMessageByType(data:Object):IGlobalMessageShow
		{
			// TODO Auto Generated method stub
			var result:IGlobalMessageShow = null;
			
			
			if(data.giftId &&(data.giftId == "7403" || data.giftId == "7402")){
				result = new GlobalMessageYanhua();
			}
			
			//默认返回常用全局
			if(result == null){
				result = new GlobalMessageSprite();
			}
			return result;
		}
		
		public function returnMessage(msg:IGlobalMessageShow):void
		{
			// TODO Auto Generated method stub
			
		}
		
		
		
		
	}
}