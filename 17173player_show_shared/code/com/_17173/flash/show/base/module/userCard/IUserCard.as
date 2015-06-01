package com._17173.flash.show.base.module.userCard
{
	
	import flash.geom.Point;

	/**
	 * 用户选项卡.
	 *  
	 * @author shunia-17173
	 */	
	public interface IUserCard
	{
		
		/**
		 * 在某个地方弹出用户操作卡. 
		 * 
		 * @param userData 要显示在卡上的用户数据.
		 * @param stagePos 要显示在舞台上的位置.这里需要是stage上的绝对位置.
		 * @param auto 是否自动隐藏
		 */		
		function showCard(userData:IUserCardData, stagePos:Point = null,auto:Boolean = true):void;
		
		function set autoHide(bool:Boolean):void;
		
		function get autoHide():Boolean;
	}
}