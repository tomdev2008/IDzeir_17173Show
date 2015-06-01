package com._17173.flash.show.base.module.animation.cac
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.show.base.components.common.HMovePane;
	
	import flash.display.DisplayObject;
	import flash.geom.Point;
	
	public class CACMovePane extends HMovePane
	{
		public function CACMovePane(tWidth:int, tHeight:int, moveSpeed:int=50, delay:int=4000, moveToLeft:Boolean=true)
		{
			super(tWidth, tHeight, moveSpeed, delay, moveToLeft,false);
		}
		
		override protected function getToPosition(item:DisplayObject):Point{
			//注意必须转换x坐标
			var pot:Point = localToGlobal(new Point(0,0));
			var result:Point = new Point();
			result.x = Math.max(-(490 + 10),-1000) - pot.x; 
			result.y = this.height - 180 - 5;
			return result;
		}
		
		override protected function initMoveItemPosition(item:DisplayObject):void{
			//注意必须转换x坐标
			var pot:Point = localToGlobal(new Point(0,0));
			item.x = Context.stage.stageWidth + 10 - pot.x;
			item.y = this.height - 180 - 5
		}
		
		override protected function getPaneWidth():int{
			return Context.stage.stageWidth;
		}
		
		override protected function run():void{
			super.run();
		}
		
		/**
		*检测是否可以移动下一个 
		* @param tmpItem
		* 
		*/		
		override protected function checkNextItem(tmpItem:DisplayObject):void{
			var pot:Point = localToGlobal(new Point(tmpItem.x,tmpItem.y));
			var space:int =  getPaneWidth() - (pot.x + tmpItem.width);
			if(space > _moveSpace){
				_checkNext = false;
				overItem();
			}
		}
	}
}