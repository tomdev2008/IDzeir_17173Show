package com._17173.flash.show.base.module.userlist.view
{
	import flash.events.Event;

	/**
	 * 模块内部事件
	 * @author idzeir
	 * 创建时间：2014-2-27  下午7:59:30
	 */
	public class UserListEvent extends Event
	{
		/**
		 * 当用户列表的滚动条达到最大值的时候触发
		 */
		static public const TOUCH_LIST_BOTTOM:String = "touchListBottom";

		public function UserListEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
		}
	}
}