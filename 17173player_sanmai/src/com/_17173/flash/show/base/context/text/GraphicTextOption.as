package com._17173.flash.show.base.context.text
{

	/**
	 * @author idzeir
	 * 创建时间：2014-2-20  上午10:52:18
	 */
	public class GraphicTextOption implements IGraphicTextOption
	{
		private var _isWap:Boolean = true;
		private var _indent:Number = 0;

		/**
		 * 图文混排文本配置基类
		 * @param isWap 是否自动断行
		 * @param indent 自动断行后下一行的缩进量
		 *
		 */
		public function GraphicTextOption(isWap:Boolean = false, indent:Number = 0)
		{
			this._isWap = isWap;
			this._indent = indent;
		}

		public function set isWrap(bool:Boolean):void
		{
			this._isWap = bool;
		}

		public function get isWrap():Boolean
		{
			return this._isWap;
		}

		public function set warpIndent(value:Number):void
		{
			this._indent = value;
		}

		public function get warpIndent():Number
		{
			return this._indent;
		}
	}
}