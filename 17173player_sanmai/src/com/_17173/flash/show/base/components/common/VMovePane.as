package com._17173.flash.show.base.components.common
{
	import com._17173.flash.show.base.components.base.BaseMovePane;
	
	import flash.display.DisplayObject;
	import flash.geom.Point;
	
	public class VMovePane extends BaseMovePane
	{
		private var _moveToTop:Boolean = false;
		public function VMovePane(tWidth:int, tHeight:int, moveSpeed:int=10, delay:int=1000, moveToTop:Boolean = true)
		{
			_moveToTop = moveToTop;
			super(tWidth, tHeight, moveSpeed, delay);
		}
		
		override protected function getToPosition(item:DisplayObject):Point{
			var result:Point = new Point();
			if(_moveToTop){
				result.y =  Math.max(-(item.height + 10), -500); 
			}else{
				result.y = Math.min((this.height + 10), 1000);
			}
			result.x = 5;
			return result;
		}
		
		override protected function initMoveItemPosition(item:DisplayObject):void{
			if(_moveToTop){
				item.y = Math.min((this.height + 10), 1000);
			}else{
				item.y = Math.max(-(item.height + 10), -500);
			}
			item.x = 5;
		}
		
		/**
		 *计算移动时间
		 * 移动长度除以移动速度 
		 * 
		 */		
		override protected function calMoveTime(item:DisplayObject,pot:Point):Number{
			return (Math.abs(pot.y- item.y))/_moveSpeed;
		}
		/**
		 *计算显示组件时间 
		 * @param item
		 * @return 
		 * 
		 */		
		override protected function calShowTime(item:DisplayObject):Number{
			return item.height/_moveSpeed;
		}
	}
}