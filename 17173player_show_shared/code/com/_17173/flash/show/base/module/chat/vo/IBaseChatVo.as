package com._17173.flash.show.base.module.chat.vo
{
	import flash.text.engine.GroupElement;

	/**
	 * 聊天面板展示信息接口
	 * @author idzeir
	 * 创建时间：2014-3-14  上午10:32:40
	 */
	public interface IBaseChatVo
	{
		/**
		 * 获取组成的图文混排元素
		 * @return 异常时返回null
		 *
		 */
		function get elements():GroupElement;

		/**
		 * 设置消息时间戳，默认为本机时间
		 * @param _time
		 *
		 */
		function set time(_time:String):void;
		/**
		 * 初始化消息数据
		 *
		 */
		function reset():void;
	}
}