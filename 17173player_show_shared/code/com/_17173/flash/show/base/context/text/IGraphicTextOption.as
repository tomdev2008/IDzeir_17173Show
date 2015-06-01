package com._17173.flash.show.base.context.text
{

	/**
	 * @author idzeir
	 * 创建时间：2014-2-19  下午7:38:48
	 */
	public interface IGraphicTextOption
	{
		/**
		 * 图文混排自动断行属性
		 * @param bool
		 *
		 */
		function set isWrap(bool:Boolean):void;

		function get isWrap():Boolean;

		/**
		 * 自动断行时候第二行的缩进量
		 * @param value
		 *
		 */
		function set warpIndent(value:Number):void;

		function get warpIndent():Number;
	}
}