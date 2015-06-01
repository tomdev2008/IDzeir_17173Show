package com._17173.flash.show.base.module.userlist.view
{
	import com._17173.flash.show.base.context.user.IUserData;

	/**
	 * @author idzeir
	 * 创建时间：2014-2-19  下午4:19:46
	 */
	public interface IUserListManager
	{
		/**
		 *用户列表进入用户接口
		 * @param user
		 * @param type 操作的列表索引
		 */
		function entryUser(user:IUserData, type:uint = 0):void;
		/**
		 *用户列表退出用户
		 * @param user
		 * @param type 操作的列表索引
		 */
		function exitUser(user:IUserData, type:uint = 0):void;
		/**
		 * 用户登录之后房间内的已有用户接口
		 * @param value
		 * @param type 操作的列表索引
		 */
		function updateList(value:Array, type:uint = 0):void;

		/**
		 * 用户面板显示隐藏接口
		 */
		function show():void;
		/**
		 * 用户列表显示状态
		 * @return
		 *
		 */
		function get isShow():Boolean;

		/**
		 * 麦序改变
		 * @param arr
		 *
		 */
		function changeMicList(arr:Array):void;

		/**
		 * 用户数据更新
		 * @param value
		 *
		 */
		function userUpdate(value:String):void;
		/**
		 * 移除所有用户列表用户
		 *
		 */
		function exitAll():void;

		/**
		 * 跳转到列表某一个索引
		 * @param index
		 *
		 */
		function goto(index:int):void;
		/**
		 * 用户等级提升 影响排序功能 
		 * @param user
		 * 
		 */		
		function levelUp(user:IUserData):void;
	}
}