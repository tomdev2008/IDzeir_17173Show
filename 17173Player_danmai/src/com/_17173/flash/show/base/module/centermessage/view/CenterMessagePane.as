package com._17173.flash.show.base.module.centermessage.view
{
	import com._17173.flash.core.components.common.VGroup;
	
	import flash.display.DisplayObject;
	
	public class CenterMessagePane extends VGroup
	{
		
		private var _limit:int = 2;
		public function CenterMessagePane()
		{
			super();
//			this.graphics.beginFill(0xFFFFFF,.01);
//			this.graphics.drawRect(0,0,402,103);
//			this.graphics.endFill();
			vGap = 3;
			mouseChildren = false;
			mouseEnabled = false;
		}
		
		public function addMsg(msg:DisplayObject):void{
			addChild(msg);
		}
		
		override public function addChild(child:DisplayObject):DisplayObject{
			//如果超出上限则删除第一个,并且更细所有子组件位置
			if(_limit == _content.numChildren){
				_content.removeChildAt(0);
			}
			return super.addChild(child);
			
		}
		
		override protected function rePos():void{
			super.rePos();
			var tar:DisplayObject;
			for(var i:uint=0;i<_content.numChildren;i++)
			{				
				tar=_content.getChildAt(i);	
				tar.x = 0;
			}
		}
		
		
	}
}