package com._17173.flash.show.base.module.activity
{
	import com._17173.flash.show.base.context.module.BaseModule;
	import com._17173.flash.show.base.module.activity.item.TwoDayIcon;
	
	import flash.utils.Dictionary;

	/**
	 *活动处理 
	 * @author zhaoqinghao
	 * 
	 */	
	public class Activity extends BaseModule
	{
		private var actDic:Dictionary;
		public function Activity()
		{
			super();
			actDic = new Dictionary();
		}  
		
		
		public function addItem(data:Object):void{
			var type:String = data.type;
			addByType(type);
		}
		
		
		private function addByType(type:String):void{
			switch(type)
			{
				case ActivityType.ZQJ_JSJ:
				{
					createAct();
					break;
				}
					
				default:
				{
					break;
				}
			}
		}
		
		
		
		private function createAct():void{
			var two:TwoDayIcon = new TwoDayIcon();
			two.x = 683;
			two.y = 100;
			two.updateInfo();
			this.addChild(two);
		}
		
		
	}
}