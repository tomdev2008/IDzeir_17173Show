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

		private var _unline:Boolean = false;

		private var _linkColor:int = 0xff0000;

		private var _showLink:Boolean = false;

		private var _textWidth:Number = 2000;

		private var _link:String = "";

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
		
		public function set unline(bool:Boolean):void
		{
			_unline = bool;
		}
		
		public function get unline():Boolean
		{
			return _unline;
		}
		
		public function set linkColor(value:int):void
		{
			_linkColor = value;
		}
		
		public function get linkColor():int
		{
			return _linkColor;
		}
		
		public function set showLink(bool:Boolean):void
		{
			_showLink = bool;
		}
		
		public function get showLink():Boolean
		{
			return _showLink;
		}
		
		public function set textWidth(value:Number):void
		{
			_textWidth = value;
		}
		
		public function get textWidth():Number
		{
			return _textWidth;
		}
		
		public function set link(url:String):void
		{
			_link = url;
		}
		
		public function get link():String
		{
			return _link;
		}
	}
}