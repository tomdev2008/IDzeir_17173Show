package com._17173.flash.core.components.common
{
	import com._17173.flash.core.components.interfaces.IGraphic;
	import com._17173.flash.core.components.interfaces.IOutputTxt;
	
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.system.System;
	import flash.text.engine.ContentElement;
	import flash.text.engine.ElementFormat;
	import flash.text.engine.FontDescription;
	import flash.text.engine.FontLookup;
	import flash.text.engine.GroupElement;
	import flash.text.engine.TextBaseline;
	import flash.text.engine.TextBlock;
	import flash.text.engine.TextElement;
	import flash.text.engine.TextLine;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	
	
	public class GraphicText extends Sprite implements IOutputTxt
	{
		/** 文本显示宽度，默认200px*/
		private var _textWidth:Number = 2000;
		
		private var textBlock:TextBlock;
		
		private var _leading:uint = 3;
		
		private var _wordWrap:Boolean = true;
		
		/**
		 *断行时候的缩进量
		 */
		protected var _warpIndent:Number = 0;
		
		private var textline:TextLine;
		
		/**下一行文本y起点*/
		private var ypos:Number = 0;
		
		/** 最大行数*/
		private var _maxLines:uint = 100;
		
		/** 锁屏状态下清理聊天记录临界点*/
		private const MAX_LOCK_LINE:uint = 400;
		
		/** 锁屏达到临界点之后清除的条数*/
		private const DEL_LOCK_LINE:uint = 200;
		
		/**缓存显示行，定时器提取展示*/
		private var cacheArr:Vector.<GroupElement>;
		
		/** 全部显示的行数*/
		private var eleMap:Vector.<GroupElement>;
		
		protected var _iGraphic:IGraphic;
		
		private var _showLink:Boolean = false;
		
		private var _locked:Boolean = false;
		
		private var _lines:Sprite;
		
		private var _underLines:Sprite;
		
		/**
		 * 图文混排显示
		 * @param iGraphic 图标管理生成ElementFormat
		 *
		 */
		public function GraphicText(iGraphic:IGraphic = null, isWrap:Boolean = true, warpIndent:Number = 0)
		{
			super();
			this._warpIndent = warpIndent;
			this._wordWrap = isWrap;
			this._iGraphic = iGraphic;
			cacheArr = new Vector.<GroupElement>();
			eleMap = new Vector.<GroupElement>();
			textBlock = new TextBlock();
			_lines = new Sprite();
			this._underLines = new Sprite();
			this.addChild(_lines);
			this.addChild(this._underLines);
			textBlock.baselineZero = flash.text.engine.TextBaseline.DESCENT;
		}
		
		/**定时器提取缓存cacheArr中的行数据*/
		private function build(e:TimerEvent = null):void
		{
			//if(this._locked)return;
			while(cacheArr.length > 0)
			{
				var groupElement:GroupElement = cacheArr.shift();
				eleMap.push(groupElement);
				if(eleMap.length > _maxLines)
				{
					eleMap.shift();
				}
				textBlock = new TextBlock();
				textBlock.baselineZero = flash.text.engine.TextBaseline.DESCENT;
				textBlock.content = groupElement;
				textline = textBlock.createTextLine(null, _textWidth);				
				var indent:Number = 0;
				while(textline)
				{
					ypos += textline.height + this._leading;
					textline.y = ypos;
					textline.x = indent;
					if(groupElement["userData"]&&groupElement.userData.hasOwnProperty("unline")&&groupElement.userData.hasOwnProperty("link")&&groupElement.userData.link!="")
					{		
						
						if(groupElement.userData["unline"]==true)
						{
							var line:Shape = new Shape();						
							textline.userData = {unline:line};												
							line.graphics.beginFill(groupElement.userData.hasOwnProperty("linkColor")?groupElement.userData["linkColor"]:0xec7218);
							line.graphics.drawRect(0,0,textline.width,1);							
							line.graphics.endFill();
							if(!textline.previousLine)
							{
								line.width = line.width - groupElement["userData"].indent;
							}
							line.x = groupElement["userData"].indent;
							line.y = textline.y+(groupElement["userData"]["leading"]?groupElement["userData"]["leading"]:0);
							_underLines.addChild(line);
						
							textline.userData["link"] = groupElement["userData"].link;
							textline.addEventListener(MouseEvent.CLICK,onTextLineClick);
							textline.addEventListener(MouseEvent.MOUSE_OVER,onTextOver);
							textline.addEventListener(MouseEvent.MOUSE_OUT,onTextOver);
						}
					}
					/*if(textline.mirrorRegions && this.showLink)
					{
						var len:uint = textline.mirrorRegions.length;
						for(var i:uint = 0; i < len; i++)
						{
							//var bounds:Rectangle = textline.mirrorRegions[i].bounds;
							//graphics.lineStyle(1, 0xd0cfcf);
							//graphics.moveTo(bounds.left, ypos);
							//graphics.lineTo(bounds.right, ypos);
						}
					}*/
					_lines.addChild(textline);
					if(!this._wordWrap)
					{
						textBlock.releaseLineCreationData();
						break;
					}
					if(textBlock.textLineCreationResult != "complete")
						indent = groupElement.userData&&groupElement.userData.hasOwnProperty("indent") ? groupElement.userData.indent : this._warpIndent;
					textline = textBlock.createTextLine(textline, _textWidth - indent);
				}
				this.textBlock.releaseLineCreationData();
			}
			Mouse.cursor = MouseCursor.AUTO;
			if(!this.showLink)
			{
				this.graphics.clear();
			}
			overFlowHiden();
		}
		
		private function onTextOver(e:MouseEvent):void
		{
			switch(e.type)
			{
				case MouseEvent.MOUSE_OVER:
					flash.ui.Mouse.cursor = flash.ui.MouseCursor.BUTTON;
					break;
				case MouseEvent.MOUSE_OUT:
					flash.ui.Mouse.cursor = flash.ui.MouseCursor.AUTO;
					break;
			}
		}
		private function onTextLineClick(e:MouseEvent):void
		{
			var textline:TextLine = e.currentTarget as TextLine;
			if(textline&&textline.userData&&textline.userData["link"])
			{
				//Util.toUrl(textline.userData["link"]);
				flash.net.navigateToURL(new URLRequest(textline.userData["link"]),"_blank");
			}
		}
		
		/**
		 * 重新创建行，性能优化
		 * @param line
		 *
		 */
		public function recreateLine(line:TextLine):void
		{
			var oPos:Object = {x:line.x, y:line.y};
			line.textBlock.releaseLineCreationData();
			line.textBlock.recreateTextLine(line, line.previousLine, this.textWidth - oPos.x);
			line.x = oPos.x;
			line.y = oPos.y;
			line.textBlock.releaseLineCreationData();
		}
		
		/**
		 * 超过显示行数，删掉最老的消息
		 *
		 */
		private function overFlowHiden():void
		{
			var reduce:Number = 0;
			var line:TextLine;
			var index:uint = 0;
			var target:TextLine;
			
			var max:uint = this.locked ? MAX_LOCK_LINE : this._maxLines;
			//超出行数限制
			while(_lines.numChildren > max && _lines.numChildren > 0)
			{
				line = _lines.getChildAt(0) as TextLine;
				if(line&&line.userData&&line.userData["unline"])
				{
					if(line.hasEventListener(MouseEvent.CLICK))
					{
						line.removeEventListener(MouseEvent.CLICK,this.onTextLineClick);
						line.removeEventListener(MouseEvent.MOUSE_OVER,onTextOver);
						line.removeEventListener(MouseEvent.MOUSE_OUT,onTextOver);
					}
					_underLines.removeChild(line.userData["unline"] as DisplayObject);	
				}	
				_lines.removeChild(line);
			}
			//排列剩余行位置
			if(_lines.numChildren > 0 && line)
			{
				line = _lines.getChildAt(0) as TextLine;
				reduce = line.getBounds(_lines).top - this.leading;
				this.ypos -= reduce;				
				for(index = 0; index < _lines.numChildren; index++)
				{
					line = _lines.getChildAt(index) as TextLine;
					line.y -= reduce;
					if(line&&line.userData&&line.userData["unline"])
					{
						var unline:DisplayObject = line.userData["unline"] as DisplayObject;
						unline.y = line.y+1;
					}
				}
			}
			flash.system.System.pauseForGCIfCollectionImminent(0);
		}
		
		/**
		 * 添加一条显示记录,不是立即显示出来，定时器从队列里面定时取
		 * @param str:String 加入显示的文本内容
		 * @param elf:ElementFormat 本行显示内容的格式
		 */
		public function append(str:String, elf:ElementFormat = null):void
		{
			var groupElement:GroupElement
			try
			{
				groupElement = _iGraphic.getGroupElement(str, elf);
			}
			catch(e:Error)
			{
				//trace("图标管理未初始化，以原始文本方式显示");				
				var fd:FontDescription = new FontDescription();
				fd.fontLookup = flash.text.engine.FontLookup.DEVICE;
				fd.fontName = "宋体,文泉驿微米黑,WenQuanYi Micro Hei,WenQuanYi Zen Hei";
				var elemFormat:ElementFormat = elf ? elf : new ElementFormat(fd, 12);
				
				var eleVec:Vector.<ContentElement> = new Vector.<ContentElement>();
				eleVec.push(new TextElement(str, elemFormat));
				groupElement = new GroupElement(eleVec, elemFormat);
			}
			
			cacheArr.push(groupElement);
			//缓存数据不超过200条
			if(cacheArr.length > this.maxLines)
			{
				cacheArr.shift();
			}
			build();
		}
		
		/**
		 * 向文本中添加一条显示元素
		 * @param element
		 *
		 */
		public function addElement(element:GroupElement):void
		{
			cacheArr.push(element);
			//缓存数据不超过200条
			if(cacheArr.length > this.maxLines)
			{
				cacheArr.shift();
			}
			build();
		}
		
		public function resize():void
		{
			//if(this._locked)return;
			reset();
			var localMap:Vector.<GroupElement> = eleMap.concat();
			for each(var e:GroupElement in localMap)
			{
				var groupElement:GroupElement = e;
				textBlock = new TextBlock();
				textBlock.baselineZero = flash.text.engine.TextBaseline.DESCENT;
				textBlock.content = groupElement;
				textline = textBlock.createTextLine(null, _textWidth);
				var indent:Number = 0;
				while(textline)
				{
					ypos += textline.height + this._leading;
					textline.y = ypos;
					textline.x = indent;
					if(groupElement["userData"]&&groupElement.userData.hasOwnProperty("unline")&&groupElement.userData.hasOwnProperty("link")&&groupElement.userData.link!="")
					{		
						if(groupElement.userData["unline"]==true)
						{
							var line:Shape = new Shape();						
							textline.userData = {unline:line};												
							line.graphics.beginFill(0xec7218);
							line.graphics.drawRect(0,0,textline.width,1);							
							line.graphics.endFill();
							if(!textline.previousLine)
							{
								line.width = line.width - groupElement["userData"].indent;
							}
							line.x = groupElement["userData"].indent
							line.y = textline.y+(groupElement["userData"]["leading"]?groupElement["userData"]["leading"]:1)
							_underLines.addChild(line);
						
							if(groupElement["userData"].hasOwnProperty("link"))
							{
								textline.userData["link"] = groupElement["userData"].link;
								textline.addEventListener(MouseEvent.CLICK,onTextLineClick);	
								textline.addEventListener(MouseEvent.MOUSE_OVER,onTextOver);
								textline.addEventListener(MouseEvent.MOUSE_OUT,onTextOver);
							}
						}
					}
					if(textline.mirrorRegions && this.showLink)
					{
						var len:uint = textline.mirrorRegions.length;
						for(var i:uint = 0; i < len; i++)
						{
							var bounds:Rectangle = textline.mirrorRegions[i].bounds;
							//graphics.lineStyle(1, 0xd0cfcf);
							//graphics.moveTo(bounds.left, ypos);
							//graphics.lineTo(bounds.right, ypos);
						}
					}
					_lines.addChild(textline);
					if(!this._wordWrap)
					{
						textBlock.releaseLineCreationData();
						break;
					}
					if(textBlock.textLineCreationResult != "complete")
						indent = groupElement.userData&&groupElement.userData.hasOwnProperty("indent") ? groupElement.userData.indent : this._warpIndent;
					textline = textBlock.createTextLine(textline, _textWidth - indent);
				}
				this.textBlock.releaseLineCreationData();
			}
			Mouse.cursor = MouseCursor.AUTO;
			if(!this.showLink)
			{
				this.graphics.clear();
			}
			localMap.length = 0;
			localMap = null;
			overFlowHiden();
		}
		
		/**清楚文本内容，重置坐标*/
		private function reset():void
		{
			ypos = 0;
			textBlock.releaseLineCreationData();
			textline = null;
			this.graphics.clear();
			while(this._lines.numChildren>0)
			{
				var line:TextLine = this._lines.removeChildAt(0) as TextLine;
				if(line.hasEventListener(MouseEvent.CLICK))
				{
					line.removeEventListener(MouseEvent.CLICK,this.onTextLineClick);
				}
			}
			this._underLines.removeChildren();
		}
		
		/**
		 * 设置图文混排的表情库
		 * @param value
		 *
		 */
		public function set iGraphic(value:IGraphic):void
		{
			this._iGraphic = value;
			resize();
		}
		
		/**
		 * 显示超链接下划线
		 */
		public function get showLink():Boolean
		{
			return _showLink;
		}
		
		/**
		 * @private
		 */
		public function set showLink(value:Boolean):void
		{
			_showLink = value;
			this.resize();
		}
		
		/**
		 * 设置自动断行时候的缩进
		 * @param value
		 *
		 */
		public function set warpIndent(value:Number):void
		{
			this._warpIndent = value;
			resize();
		}
		
		/**
		 * 是否可以自动换行
		 * @param bool
		 *
		 */
		public function set wordWrap(bool:Boolean):void
		{
			this._wordWrap = bool;
			resize();
		}
		
		public function get wordWrap():Boolean
		{
			return this._wordWrap;
		}
		
		public function set textWidth(value:Number):void
		{
			_textWidth = value;
			resize();
		}
		
		public function get textWidth():Number
		{
			return this._textWidth;
		}
		
		public function set maxLines(value:uint):void
		{
			_maxLines = value;
			this.resize();
		}
		
		public function get maxLines():uint
		{
			return _maxLines;
		}
		
		public function set locked(bool:Boolean):void
		{
			this._locked = bool;
			if(!_locked && this.cacheArr.length > 0)
			{
				this.build();
			}
		}
		
		public function get locked():Boolean
		{
			return this._locked;
		}
		
		public function get leading():uint
		{
			return _leading;
		}
		
		public function set leading(value:uint):void
		{
			_leading = value;
			this.resize();
		}
		
		public function clear():void
		{
			reset();
			cacheArr.length = 0;
			eleMap.length = 0;
		}
		
		public function dispose():void
		{
			clear();
			this.warpIndent = 0;
			this._wordWrap = true;
			this._iGraphic = null;
		}
	}
}