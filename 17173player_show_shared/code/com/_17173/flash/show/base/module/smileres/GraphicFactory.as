package com._17173.flash.show.base.module.smileres
{
	import com._17173.flash.core.components.interfaces.IGraphic;
	
	import flash.display.DisplayObject;
	import flash.text.engine.ContentElement;
	import flash.text.engine.ElementFormat;
	import flash.text.engine.GraphicElement;
	import flash.text.engine.GroupElement;
	import flash.text.engine.TextElement;

	public class GraphicFactory implements IGraphic
	{
		private const BASE_URL:String = "assets/img/smileres/";
		
		protected var _graphicMap:Vector.<Object>

		private var elemFormat:ElementFormat;

		static private const SIZE:uint = 20;

		/**按照headTag生成的提取图形的正则表达式*/
		private var regExp:RegExp = /\[([^\]]+)\]/ig;
		
		private var _factory:Function = null;

		/**
		 * 图文混排图片显示行生成器
		 */
		public function GraphicFactory()
		{
			_graphicMap = new Vector.<Object>();
		}
		
		public function set format(value:ElementFormat):void
		{
			elemFormat = value;
		}

		/**
		 * 初始化表情数据
		 * @param faces 表情数据的数组
		 *
		 */
		public function createGraphic(faces:Array,_factory:Function):void
		{
			this._factory = _factory;
			var tsize:uint = faces.length;
			var total:uint = 0;
			do
			{
				var data:Object = {};
				data.frame = total;
				data.tag = faces[total].tag;
				data.tips = faces[total].tips;
				data.url = BASE_URL + faces[total].url;
				this._graphicMap.push(data);
				total++;
			} while(total < tsize);
		}

		/**
		 * 向表情工厂中注入一个表情
		 * @param gaphic
		 * @return 返回该标签的使用标签
		 *
		 */
		public function injectGraphic(gaphic:DisplayObject):String
		{
			//var data:Object={frame:this.graphicMap.length,tag:_headTag+this.graphicMap.length,data:gaphic,injected:true};
			//this.graphicMap.push(data);
			return "错误了";
		}

		/**
		 * 取得tag标示的表情内容
		 * @param tag:String 表情标签
		 * @return 返回对应表情内容
		 */
		private function getGraphics(tag:String):Object
		{
			for(var i:uint = 0; i < _graphicMap.length; i++)
			{
				if(_graphicMap[i].tag == tag)
				{
					return _graphicMap[i];
				}
			}
			return null;
		}

		/**
		 * 返回字符串计算之后的长度，每个表情算一个长度
		 * @param str
		 * @return
		 *
		 */
		public function getTotal(str:String):uint
		{
			var faces:Array = str.match(this.regExp);
			var total:uint = str.length;
			for each(var i:String in faces)
			{
				if(this.getGraphics(i))
				{
					total = total - i.length + 1;
				}
			}
			return total;
		}

		/**
		 * 将字符串转化成图文混排元素
		 * @param msg:String 待转化的字符串
		 * @param elf:ElementFormat 图文元素的格式
		 * @return 返回元素组
		 * */
		public function getGroupElement(msg:String, elf:ElementFormat = null):GroupElement
		{
			var localFormat:ElementFormat = elf ? elf : this.elemFormat;

			return new GroupElement(getElements(msg, localFormat), localFormat);
		}

		/**
		 * 接收字符串返回图文混排中GroupElement的的原数组
		 * @param msg
		 * @param elf
		 * @return
		 *
		 */
		public function getElements(msg:String, elf:ElementFormat = null):Vector.<ContentElement>
		{
			var str:String = msg;
			var graphicArr:Array = str.match(regExp);
			var elemGroup:Vector.<ContentElement> = new Vector.<ContentElement>();
			var textElement:TextElement
			var localFormat:ElementFormat = elf ? elf : this.elemFormat;

			if(graphicArr.length == 0)
			{
				textElement = new TextElement(msg, localFormat);
				elemGroup.push(textElement);
			}

			while(graphicArr.length > 0)
			{
				var tag:String = graphicArr.shift()
				var tagIndex:int = (str.indexOf(tag))
				if(tagIndex != 0)
				{
					textElement = new TextElement(str.substring(0, tagIndex), localFormat);
					elemGroup.push(textElement);
				}
				var graphic:Object = getGraphics(tag);
				if(graphic)
				{
					var graphicItem:DisplayObject;

					if(!graphic.hasOwnProperty("injected"))
					{
						graphicItem = this._factory.apply(null,[graphic.url]);
					}
					else
					{
						graphicItem = graphic.data;
					}
					graphicItem.y = 3;
					var graphicElement:GraphicElement = new GraphicElement(graphicItem, graphicItem.width, graphicItem.height, localFormat)
					elemGroup.push(graphicElement);
				}
				else
				{
					textElement = new TextElement(tag, localFormat);
					elemGroup.push(textElement);
				}
				str = str.substring(tagIndex + tag.length);
				if(str.length != 0 && graphicArr.length == 0)
				{
					textElement = new TextElement(str, localFormat);
					elemGroup.push(textElement);
				}
			}
			return elemGroup;
		}

		public function cloneFormat():ElementFormat
		{
			return this.elemFormat.clone();
		}

		/**
		 * 图形起始标识串
		 * @return
		 *
		 */
		public function get headTag():String
		{
			return "";
		}

		/**
		 * 获取表情内容
		 * */
		public function get graphicMap():Vector.<Object>
		{
			return this._graphicMap;
		}

		public function get tagRegExp():RegExp
		{
			return this.regExp;
		}
	}
}