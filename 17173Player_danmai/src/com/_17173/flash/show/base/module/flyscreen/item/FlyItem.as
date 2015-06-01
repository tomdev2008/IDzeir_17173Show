package com._17173.flash.show.base.module.flyscreen.item
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.show.base.components.common.BitmapMovieClip;
	import com._17173.flash.show.base.context.resource.IResourceData;
	import com._17173.flash.show.base.context.resource.IResourceManager;
	import com._17173.flash.show.base.context.text.IGraphicTextManager;
	import com._17173.flash.show.base.module.flyscreen.FlyScreenVo;
	import com._17173.flash.show.base.utils.FontUtil;
	import com._17173.flash.show.model.CEnum;
	import com._17173.framework.core.objpool.ibase.IObject;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.text.engine.ContentElement;
	import flash.text.engine.GraphicElement;
	import flash.text.engine.GroupElement;
	import flash.text.engine.TextBaseline;
	import flash.text.engine.TextBlock;
	import flash.text.engine.TextElement;
	import flash.text.engine.TextLine;
	
	public class FlyItem extends Sprite implements IObject
	{
		private var _textContainer:Sprite;
		private var _flyId:String;

		
		private var _resDisplay:DisplayObject;
		private var _elems:Vector.<ContentElement>;
		private var _maxWidth:int = 822;
		private var _backMc:MovieClip;
		private var _isInitFinish:Boolean=false;
		private var _releaseCoord:Boolean=false;



		private var _isPlaying:Boolean=false;
		private var _defaultWidth:Number;
		private var _flagWidth:Number;



		public function FlyItem()
		{
			super();
			this.mouseChildren=false;
			this.mouseEnabled=false;
		}
		
		public function setItemData(data:Object):void
		{
			_elems = new Vector.<ContentElement>;
			_flyId = data.flyId;
			var flyData:Object = getflyData(_flyId);
			if(_resDisplay==null)
			{
				var that:* = this;
				(Context.getContext(CEnum.SOURCE) as IResourceManager).loadResource(flyData.flyResPath + "?" + Math.random(), function(value:IResourceData):void
				{
					_resDisplay = value.newSource as DisplayObject;
					var w:int = ~~(_resDisplay.width);
					var h:int = ~~(_resDisplay.height);
//					that.graphics.clear();
//					that.graphics.beginFill(0,0);
//					that.graphics.drawRect(0,0,w,h);
//					that.graphics.endFill();
					_defaultWidth = w;
					if("rootMc" in _resDisplay)
					{
						var rMc:MovieClip = _resDisplay["rootMc"] as MovieClip;
						if("backMc" in rMc)
						{
							_backMc = rMc["backMc"];
							var sw:int = 310;
							var sh:int = _backMc.height - 10;
							var sx:int = ~~((w-sw)/2);
							var sy:int = 5;
							_backMc.scale9Grid = new Rectangle(sx,sy,sw, sh);
						}
						
//						if("txtMc" in rMc)
//							_textContainer = rMc["txtMc"];
//						else
//						{
//							_textContainer = new Sprite();
//							that.addChild(_textContainer);
//						}
						
						_textContainer = new Sprite();
						that.addChild(_textContainer);
					}
					that.addChildAt(_resDisplay,0);
					
					createRichText(data,flyData);
				});
			}else
			{
				createRichText(data,flyData);
			}
		}
		/**
		 * 创建富文本 
		 * @param itemData
		 * @param flyData
		 * 
		 */		
		private function createRichText(itemData:Object,flyData:Object):void
		{
			var baseUrl:String = "assets/img/level/";
			var size:Number = 18;
			if(("richLevel" in itemData) && (itemData.richLevel != ""))
			{
				var richLevel:int = int(itemData.richLevel);
				if(richLevel>0)
				{
					//财富等级
					var _rich:BitmapMovieClip = new BitmapMovieClip();
					var _rtype:String = richLevel > 25 ? ".swf" : ".png";
					_rich.url = baseUrl + "cflv" + richLevel + _rtype;
					_rich.y = 3;
				}
				var ge:GraphicElement = new GraphicElement(_rich,_rich.width,_rich.height,FontUtil.getFormat());
				_elems.push(ge);
			}
			
			var textElement:TextElement;
			textElement = new TextElement(itemData.userName,FontUtil.getFormat(formatColor(flyData.userColor),size));
			_elems.push(textElement);
			if(String(itemData.receiverId) != "0")
			{
				textElement = new TextElement(" 对 ",FontUtil.getFormat(formatColor(flyData.contentColor),size));
				_elems.push(textElement); 
				textElement = new TextElement(itemData.receiverName,FontUtil.getFormat(formatColor(flyData.userColor),size));
				_elems.push(textElement); 
			}
			textElement = new TextElement(" 说： ",FontUtil.getFormat(formatColor(flyData.contentColor),size));
			_elems.push(textElement); 
			
			//加入聊天内容
			var msg:Vector.<ContentElement> = (Context.getContext(CEnum.GRAPHIC_TEXT) as IGraphicTextManager).factory.getElements(unescape(itemData.msg), FontUtil.getFormat(formatColor(flyData.contentColor),size));
			msg.forEach(function(e:*, index:*, arr:*):void
			{
				_elems.push(e);
			});
			
			appendGroupElement(new GroupElement(_elems));
		}
		/**
		 *  文本块组成完成
		 *  加入显示列表
		 * @param value
		 * 
		 */		
		public function appendGroupElement(value:GroupElement):void
		{
			var textBlock:TextBlock = new TextBlock;
			textBlock.baselineZero =  TextBaseline.IDEOGRAPHIC_CENTER;
			textBlock.content = value;
			
			var textLine:TextLine = textBlock.createTextLine (null, _maxWidth);
			_textContainer.addChild(textLine);
			
			_backMc.width = _textContainer.width + 150;
			_backMc.x = ~~((_defaultWidth - _backMc.width)/2);
			_textContainer.x = _backMc.x + 75;
			_textContainer.y = _backMc.y +20;
			
			this.x = this.x - _backMc.x;//重新计算x的坐标,快速显示
			_flagWidth =_backMc.x +  _backMc.width + 100;
			_isInitFinish=true;
		}
		
		
		
		/**
		 * 获得飞屏背景资源地址 
		 * @param flyId
		 * @return 
		 * 
		 */		
		private function getflyData(flyId:String):Object
		{
			var flyData:Object; 
			for each(var obj:Object in FlyScreenVo.flyScreenData)
			{
				if(obj.flyId == flyId)
				{
					flyData = obj;
					break;
				}
			}
			return flyData;
		}
		
		private function formatColor(color:String):uint
		{
			if(color.indexOf("#")!=-1)
				color = color.substr(1,color.length);
			return parseInt(color,16);
		}
		
		public function get isInitFinish():Boolean
		{
			return _isInitFinish;
		}

		public function get flyId():String
		{
			return _flyId;
		}
		
		/** 是否开始播放 **/
		public function get isPlaying():Boolean
		{
			return _isPlaying;
		}
		
		/**
		 * @private
		 */
		public function set isPlaying(value:Boolean):void
		{
			_isPlaying = value;
		}

		public function get flagWidth():Number
		{
			return _flagWidth;
		}

		public function get releaseCoord():Boolean
		{
			return _releaseCoord;
		}
		
		public function set releaseCoord(value:Boolean):void
		{
			_releaseCoord = value;
		}
		
		/**
		 * 重置数据 
		 * 
		 */		
		public function reset():void
		{
			_isInitFinish = false;
			_isPlaying = false;
			_releaseCoord = false;
			_flagWidth = 0;
			while(_textContainer.numChildren>0)
			{
				_textContainer.removeChildAt(0);
			}
		}
		/**
		 * 销毁所有引用
		 * EG: removeEventListener, obj=null
		 * 等待GC回收 
		 * 
		 */		
		public function dipose():void
		{
			
		}
		
	}
}