package com._17173.flash.show.base.context.text
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.context.IContextItem;
	import com._17173.flash.core.util.SimpleObjectPool;
	import com._17173.flash.core.util.Util;
	import com._17173.flash.core.components.common.GraphicText;
	import com._17173.flash.core.components.interfaces.IGraphic;
	import com._17173.flash.show.base.context.user.IUser;
	import com._17173.flash.show.base.module.smileres.GraphicFactory;
	import com._17173.flash.show.base.module.userCard.UserCardData;
	import com._17173.flash.show.base.utils.FontUtil;
	import com._17173.flash.show.model.CEnum;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.engine.ContentElement;
	import flash.text.engine.ElementFormat;
	import flash.text.engine.FontDescription;
	import flash.text.engine.FontLookup;
	import flash.text.engine.GraphicElement;
	import flash.text.engine.GroupElement;
	import flash.text.engine.TextElement;
	import flash.text.engine.TextLine;
	import flash.text.engine.TextLineMirrorRegion;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;

	/**
	 * @author idzeir
	 * 创建时间：2014-2-20  上午10:02:27
	 */
	public class GraphicTextManager implements IContextItem, IGraphicTextManager
	{
		private var _factory:IGraphic;

		private var _format:ElementFormat;

		private var _eventMirror:EventDispatcher;

		private var overTag:ContentElement;

		public function GraphicTextManager()
		{

		}

		public function get contextName():String
		{
			return CEnum.GRAPHIC_TEXT;
		}

		public function startUp(param:Object):void
		{
			this._factory = new GraphicFactory();
			this._factory.format = FontUtil.getFormat();
			
			var fds:FontDescription = new FontDescription(FontUtil.f);
			fds.fontLookup = flash.text.engine.FontLookup.DEVICE;

			this._format = new ElementFormat(fds, 12, 0xD0CFCF);

			this._eventMirror = new EventDispatcher();
			this._eventMirror.addEventListener("click", onLinkClick);
			this._eventMirror.addEventListener("mouseOver", onLinkOver);
			this._eventMirror.addEventListener("mouseOut", onLinkOut);
		}

		public function initFactory(value:Object,_factory:Function):void
		{
			this.factory.createGraphic(value as Array,_factory);
		}

		protected function onLinkOut(event:MouseEvent):void
		{
			if(Mouse.cursor == MouseCursor.BUTTON)
			{
				var line:TextLine = event.currentTarget as TextLine;
				if(overTag)
					overTag.elementFormat = overTag.userData.format;
				/*var pos:Object={x: line.x, y: line.y};
				   line.textBlock.recreateTextLine(line);
				   line.textBlock.releaseLineCreationData();
				   line.x=pos.x;
				 line.y=pos.y;*/
				if(line.parent && (line.parent.parent is GraphicText))
				{
					(line.parent.parent as GraphicText).recreateLine(line);
				}
				overTag = null;
				if(line.parent && !(line.parent.parent as GraphicText).showLink)
				{
					(line.parent.parent as Sprite).graphics.clear();
				}
				Mouse.cursor = MouseCursor.AUTO;
			}
		}

		protected function onLinkOver(event:MouseEvent):void
		{
			if(Mouse.cursor != MouseCursor.BUTTON)
			{
				var redFormat:ElementFormat = FontUtil.getFormat(0xffffff,12);
				var line:TextLine = event.currentTarget as TextLine;
				var i:int = 0;
				while(i < line.mirrorRegions.length)
				{
					var region:TextLineMirrorRegion = line.mirrorRegions[i];
					if(region.bounds.contains(event.localX, event.localY))
					{
						if(region.element.userData && region.element.userData.hasOwnProperty("link"))
						{
							overTag = region.element;
							region.element.elementFormat = redFormat;
						}
						else if(!region.element.userData)
						{
							return;
						}
						else
						{
							if(line.parent.parent)
							{
								var bounds:Rectangle = region.bounds;
								(line.parent.parent as Sprite).graphics.lineStyle(.5, region.element.elementFormat.color); //0xd0cfcf);
								(line.parent.parent as Sprite).graphics.moveTo(bounds.left + line.x, line.y + 1);
								(line.parent.parent as Sprite).graphics.lineTo(bounds.right + line.x, line.y + 1);
							}
						}
						break;
					}
					i++;
				}

				//var pos:Object={x:line.x,y:line.y};

				//line.textBlock.recreateTextLine(line);
				//line.textBlock.releaseLineCreationData();	
				//line.x=pos.x;
				//line.y=pos.y;		
				if(line.parent&&line.parent.parent && (line.parent.parent is GraphicText))
				{
					(line.parent.parent as GraphicText).recreateLine(line);
				}
				Mouse.cursor = MouseCursor.BUTTON;
			}
		}

		protected function onLinkClick(event:MouseEvent):void
		{
			try
			{
				var line:TextLine = event.currentTarget as TextLine;
				var i:int = 0;
				var locPos:Point = line.globalToLocal(new Point(event.stageX, event.stageY));
				while(i < line.mirrorRegions.length)
				{
					var region:TextLineMirrorRegion = line.mirrorRegions[i];
					if(region.bounds.containsPoint(locPos))
					{
						if(region.element.userData.hasOwnProperty("link"))
						{
							Util.toUrl(region.element.userData.link);
							return;
						}
						else
						{
							(Context.getContext(CEnum.USER) as IUser).showCard(region.element.userData["id"], new Point(event.stageX, event.stageY), [UserCardData.HIDE_MIC_LIST]);
						}
						break;
					}
					i++;
				}
			}
			catch(error:Error)
			{

			}
			event.stopPropagation();
		}

		public function createGraphicText(elements:Array = null, options:* = null):DisplayObject
		{
			var group:Vector.<ContentElement>;
			var format:ElementFormat;

			if(elements != null)
			{
				group = new Vector.<ContentElement>();
				for(var i:uint = 0; i < elements.length; i++)
				{
					format = this._format.clone();
					var igElement:IGraphicTextElement = elements[i];
					format.fontSize = igElement.size;
					format.color = igElement.color;
					var fds:FontDescription = format.fontDescription.clone();
					fds.fontName = igElement.font;
					format.fontDescription = fds;
					var element:ContentElement;

					switch(igElement.type)
					{
						case GraphicTextElementType.Element_TEXT:
							element = new TextElement(igElement.content, format);
							group.push(element);
							break;
						case GraphicTextElementType.Element_SHAPE:
							var garphic:DisplayObject = igElement.content as DisplayObject;
							element = new GraphicElement(garphic, garphic.width, garphic.height, format);
							group.push(element);
							break;
						case GraphicTextElementType.Element_URL:
							var picBox:DisplayObject = this.getPic(igElement.content);
							element = new GraphicElement(picBox, picBox.width, picBox.height, format);
							group.push(element);
							break;
						case GraphicTextElementType.Element_CHAT_MESSAGE:
							var eles:Vector.<ContentElement> = this._factory.getElements(igElement.content, format);
							eles.forEach(function(e:ContentElement, index:int, arr:*):void
								{
									if(Util.validateStr(igElement.link))
									{
										e.userData = {link:igElement.link, format:format};
										e.eventMirror = _eventMirror;
									}
									group.push(e);
								})
							//element = new GroupElement(eles,format);							
							break;
					}
					if(Util.validateStr(igElement.link) && element)
					{
						element.userData = {link:igElement.link, format:format};
						element.eventMirror = this._eventMirror;
					}
				}
			}
			var option:IGraphicTextOption = options != null ? options : new GraphicTextOption();

			var text:GraphicText = SimpleObjectPool.getPool(GraphicText).getObject() as GraphicText;
			text.iGraphic = this._factory;
			text.wordWrap = option.isWrap;
			text.warpIndent = option.warpIndent;

			var groupElement:GroupElement = new GroupElement(group, this._format);

			text.addElement(groupElement);

			//回收对象			

			if(elements && elements.length > 0)
			{
				for each(var gte:GraphicTextElement in elements)
				{
					gte.reset();
					SimpleObjectPool.getPool(GraphicTextElement).returnObject(gte);
				}
				elements.length = 0;
			}
			return text;
		}

		public function createElement():GraphicTextElement
		{
			return SimpleObjectPool.getPool(GraphicTextElement).getObject() as GraphicTextElement;
		}

		public function returnObject(line:DisplayObject):Boolean
		{
			var content:GraphicText = line as GraphicText;
			if(content)
			{
				content.dispose();
				SimpleObjectPool.getPool(GraphicText).returnObject(line);
				return true;
			}
			return false;
		}

		public function registerAction(action:String, handler:Function):Boolean
		{
			//还没有实现
			return true;
		}

		public function removeAction(action:String, handler:Function):Boolean
		{
			return true;
		}

		public function get controler():EventDispatcher
		{
			return this._eventMirror;
		}

		public function get factory():IGraphic
		{
			return this._factory;
		}

		private function getPic(url:String, w:Number = 22, h:Number = 22):DisplayObject
		{
			return new PicContainer(url, w, h) as DisplayObject
		}
	}
}
import com._17173.flash.core.context.Context;
import com._17173.flash.show.base.context.resource.IResourceData;
import com._17173.flash.show.base.context.resource.IResourceManager;
import com._17173.flash.show.model.CEnum;

import flash.display.DisplayObject;
import flash.display.Sprite;

class PicContainer extends Sprite
{
	private var _width:Number;
	private var _height:Number;
	private var _url:String;
	private var iResManager:IResourceManager;

	public function PicContainer(url:String = "", w:Number = 22, h:Number = 22)
	{

		iResManager = Context.getContext(CEnum.SOURCE) as IResourceManager;
		this._height = h;
		this._width = w;
		this.url = url;
		this.resize();
	}

	public function get url():String
	{
		return _url;
	}

	public function set url(value:String):void
	{
		_url = value;
		iResManager.loadResource(value, onComplete);
	}

	public function onComplete(source:IResourceData):void
	{
		var graphic:DisplayObject = this.addChild(source.newSource as DisplayObject);
		this._height = graphic.height;
		this._width = graphic.width;
		this.resize();
	}

	override public function get height():Number
	{
		return _height;
	}

	override public function set height(value:Number):void
	{
		_height = value;
		super.height = value;
		this.resize();
	}

	override public function get width():Number
	{
		return _width;
	}

	override public function set width(value:Number):void
	{
		_width = value;
		super.width = value;
		this.resize();
	}

	private function resize():void
	{
		this.graphics.clear();
		this.graphics.beginFill(0xff0000, 0);
		this.graphics.drawRect(0, 0, this._width, this._height);
		this.graphics.endFill();
	}
}
