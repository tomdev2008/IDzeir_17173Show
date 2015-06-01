package com._17173.flash.show.base.components.common
{
	import com._17173.flash.show.base.components.base.BaseMovePane;
	
	import flash.display.DisplayObject;
	import flash.geom.Point;

	/**
	 *横向缓动控制板
	 * @author zhaoqinghao
	 * 
	 */	
	public class HMovePane extends BaseMovePane
	{
		/**
		 *左移动移动 
		 */		
		private var _moveToLeft:Boolean = false
		/**
		 * 
		 * @param tWidth 宽
		 * @param tHeight 高
		 * @param moveSpeed 移动速度 默认1；
		 * @param delay 间隔 默认2000毫秒；
		 * @param toMoveLeft 向左右移动 默认等于true向左移动；
		 * @param maxCount 限制数量 默认30个；
		 * 
		 */		
		public function HMovePane(tWidth:int, tHeight:int, moveSpeed:int=3, delay:int=4000,moveToLeft:Boolean = true,isMask:Boolean = true)
		{
			_moveToLeft = moveToLeft;
			super(tWidth, tHeight, moveSpeed, delay,isMask);
		}
		
		override protected function getToPosition(item:DisplayObject):Point{
			var result:Point = new Point();
			if(_moveToLeft){
				result.x =  Math.max(-(item.width + 10),-1000); 
			}else{
				result.x = Math.min((this.width + 10),2920);
			}
			result.y = this.height - item.height - 0;
			return result;
		}
		
		override protected function initMoveItemPosition(item:DisplayObject):void{
			if(_moveToLeft){
				item.x = Math.min((this.width + 10),2920);
			}else{
				item.x = Math.max(-(item.width + 10),-1000);
			}
			item.y = this.height - item.height - 0;
		}
		
		/**
		 *计算移动时间
		 * 移动长度除以移动速度 
		 * 
		 */		
		override protected function calMoveTime(item:DisplayObject,pot:Point):Number{
			return (Math.abs(pot.x- item.x))/_moveSpeed;
		}
		/**
		 *计算显示组件时间 
		 * @param item
		 * @return 
		 * 
		 */		
		override protected function calShowTime(item:DisplayObject):Number{
			return item.width/_moveSpeed;
		}
	}
}