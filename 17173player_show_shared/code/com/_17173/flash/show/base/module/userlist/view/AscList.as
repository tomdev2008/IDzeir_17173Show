package com._17173.flash.show.base.module.userlist.view
{
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.core.components.common.List;
	import com._17173.flash.show.base.context.user.IUserData;
	
	import flash.display.DisplayObject;
	
	public class AscList extends List
	{
		public function AscList(max:uint=0, isLine:Boolean=false, itemRender:Class=null)
		{
			super(max, isLine, itemRender);
			this.gap = 2;
		}
		
		override protected function reBuild():void
		{
			super.reBuild();
			itemBox.graphics.clear();	
			for(var i:uint = 1;i<itemBox.numChildren;i++)
			{
				var item:DisplayObject = itemBox.getChildAt(i) as DisplayObject;						
				itemBox.graphics.beginFill(0x2B1349,.55);
				itemBox.graphics.drawRect(item.x,item.y-2,210,1);
				itemBox.graphics.beginFill(0x693DB7,.3);
				itemBox.graphics.drawRect(item.x,item.y-1,210,1);
				itemBox.graphics.endFill();
			}			
		}
		
		public function relist():void
		{
			try{
				var arr:Array = [];
				var guests:Array = [];
				for(var i:uint = 0;i<itemBox.numChildren;i++)
				{
					var item:DisplayObject = itemBox.getChildAt(i);
					var user:IUserData = this.dictionary[item];
					if(Number(user.id)<0)
					{
						//游客单独排序
						guests.push({context:item,data:user});
						continue;
					}
					arr.push({context:item,data:user});
				}			
				arr.sort(sort);//优化方式	
				//直接把游客排到末尾
				guests.forEach(function(e:Object,index:int,_arr:Array):void
				{
					arr.push(e);
				});
				var yPos:Number = 0;
				arr.forEach(function(e:Object,index:int,_arr:Array):void
				{
					var child:DisplayObject = e.context as DisplayObject;
					itemBox.setChildIndex(child,index);
					child.y = yPos;
					yPos += child.height + gap;
					//trace(e.data.name,e.data.sortNum);
				});	
			}catch(e:Error){
				Debugger.log(Debugger.WARNING,"[AscList]用户列表排序错误",e.message);
			}
		}	
		
		private function sort(e:Object,b:Object):int
		{
			if(e.data.sortNum>b.data.sortNum)
			{
				return -1;
			}else if(e.data.sortNum<b.data.sortNum){
				return 1;
			}else{
				return 0;
			}
		}
	}
}