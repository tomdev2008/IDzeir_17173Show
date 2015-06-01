package com._17173.flash.show.base.utils
{
	import flash.text.TextFormat;
	import flash.text.engine.BreakOpportunity;
	import flash.text.engine.ElementFormat;
	import flash.text.engine.FontDescription;
	import flash.utils.Dictionary;

	public class FontUtil
	{

		/**
		 * 微软雅黑
		 */
		private static const FONT_WRYH:String = "Microsoft YaHei,微软雅黑,宋体,Monaco";

		/**
		 * 获取当前的默认字体名称.
		 *
		 * 微软雅黑.
		 *
		 * @return
		 */
		public static function get f():String
		{
			return FONT_WRYH;
		}

		/**
		 *蓝色
		 */
		public static const FONT_COLOR_BLUE1:uint = 0x63ACFF;
		/**
		 *title灰色
		 */
		public static const FONT_COLOR_GRAY:uint = 0xC0BDC2;

		/**
		 *白色
		 */
		public static const FONT_COLOR_WHITE:uint = 0xFFFFFF;

		/**
		 * 紫色
		 */
		public static const FONT_COLOR_VIOLET:uint = 0xeb03ff; //0x500093;
		/**
		 *黑色描边 一般字体需要
		 * @param size
		 * @return
		 *
		 */

		/**
		 * 图文混排字体样式管理
		 */
		private static var _format:Dictionary = new Dictionary(true);
		/**
		 * 字体描述
		 */
		private static var fds:FontDescription = new FontDescription(f);

		/**
		 * 默认字体样式
		 * @return
		 *
		 */
		static public function get DEFAULT_FORMAT():TextFormat
		{
			return new TextFormat(FontUtil.f, 14, 0xFFFFFF);
		}
		/**
		 * 图文混排字体样式获取
		 * @param _color 字体颜色
		 * @return
		 *
		 */
		public static function getFormat(_color:uint = 0xD0CFCF,size:Number = 14):ElementFormat
		{
			if(!_format.hasOwnProperty(_color))
			{
				_format[_color] = new ElementFormat(fds, size, _color);
				//任何字符都可以执行自动换行
				ElementFormat(_format[_color]).breakOpportunity = BreakOpportunity.ANY;
			}
			return _format[_color];
		}
	}
}
