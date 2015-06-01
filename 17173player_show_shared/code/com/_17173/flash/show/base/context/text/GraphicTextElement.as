package com._17173.flash.show.base.context.text
{
	import com._17173.flash.show.base.utils.FontUtil;

	/**
	 * @author idzeir
	 * 创建时间：2014-2-20  上午10:44:26
	 */
	public class GraphicTextElement implements IGraphicTextElement
	{
		private var _data:Object = {};

		/**
		 * 图文混排元素基础类
		 * @param content 显示内容，可为字符串或者显示对象
		 * @param type 元素的类型,从GraphicTextElementType中枚举
		 * @param color 字体颜色
		 * @param size 字体大小
		 * @param font 字体
		 * @param link 链接地址
		 *
		 */
		public function GraphicTextElement(content:* = null, type:uint = 0, color:Number = 0xD0CFCF, size:Number = 12, font:String = null, link:String = null)
		{
			this._data.content = content;
			this._data.type = type;
			this._data.color = color;
			this._data.size = size;
			this._data.font = font ? font : FontUtil.f;
			this._data.link = link;
		}

		public function get color():Number
		{
			return this._data.color;
		}

		public function set color(value:Number):void
		{
			this._data.color = value;
		}

		public function get size():Number
		{
			return this._data.size;
		}

		public function set size(value:Number):void
		{
			this._data.size = value;
		}

		public function get font():String
		{
			return this._data.font;
		}

		public function set font(value:String):void
		{
			this._data.font = value;
		}

		public function set link(value:String):void
		{
			this._data.link = value;
		}

		public function get link():String
		{
			return this._data.link;
		}

		public function set content(value:*):void
		{
			this._data.content = value;
		}

		public function get content():*
		{
			return this._data.content;
		}

		public function set type(value:uint):void
		{
			this._data.type = value;
		}

		public function get type():uint
		{
			return this._data.type;
		}

		public function reset():void
		{
			this._data.content = null;
			this._data.type = 0;
			this._data.color = 0xD0CFCF;
			this._data.size = 12;
			this._data.font = FontUtil.f;
			this._data.link = null;
		}
	}
}