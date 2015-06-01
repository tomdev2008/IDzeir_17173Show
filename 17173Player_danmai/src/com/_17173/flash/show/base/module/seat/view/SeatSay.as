package com._17173.flash.show.base.module.seat.view
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.show.base.context.resource.IResourceManager;
	import com._17173.flash.show.base.context.text.GraphicTextElement;
	import com._17173.flash.show.base.context.text.GraphicTextElementType;
	import com._17173.flash.show.base.context.text.IGraphicTextManager;
	import com._17173.flash.show.base.utils.Utils;
	import com._17173.flash.show.model.CEnum;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;
	
	public class SeatSay extends Sprite
	{
		private var _bg:MovieClip = null;
		private var _jt:MovieClip = null;
		private var _msgString:Object = null;
		private var _bitMap:Bitmap = null;
		private var _bitMapData:BitmapData = null;
		private var _textSp:Sprite = null;
		private var _showText:TextField = null;
		public function SeatSay()
		{
			super();
			init();
		}
		/**
		 *消息 
		 * @param msg
		 * 
		 */		
		public function set msgString(msg:Object):void{
			_msgString = msg;
			updateMsg();
		}
		
		private function init():void{
			this.mouseEnabled = false;
			this.mouseChildren = false;
			_bg = new Seat_MessageBg();
			_bg.mouseEnabled = false;
			this.addChild(_bg);
			
			_jt = new Seat_Jiantou();
			_jt.mouseEnabled = false;
			this.addChild(_jt);
			_bitMap = new Bitmap();
			_textSp = new Sprite();
			_textSp.x = 10;
			_textSp.y = 4;
			_textSp.mouseEnabled = false;
			_textSp.addChild(_bitMap);
			this.addChild(_textSp);
		}
		private var dis:DisplayObject
		private function updateMsg():void{
			var text:DisplayObject = getMesstByGift(_msgString);
			if(text == null){
				return;
			}
			//将文字draw出来以便于执行缩放
			_bitMapData = new BitmapData(text.width,text.height+8,true,0x11CCCCCC);
			_bitMapData.draw(text);
			_bitMap.bitmapData = _bitMapData;
			updateSize(text.width);
		}
		
		
		private function updateSize(tW:int):void{
			_bg.width = tW + 20;
			_jt.x = (_bg.width - _jt.width)/2;
			_jt.y = _bg.height;
		}
		private function getMesstByGift(data:Object):DisplayObject{
			var text:DisplayObject;
			var str:String = "";
			var i:IResourceManager = Context.getContext(CEnum.SOURCE) as IResourceManager;
			if(data != null){
				var textManager:IGraphicTextManager = Context.getContext(CEnum.GRAPHIC_TEXT) as IGraphicTextManager;
				var sName:String = data.sName;
				var sNo:String = data.sNo;
				var tName:String = data.tName;
				var tNo:String = data.tNo;
				var gName:String = data.giftName;
				var count:String = data.giftCount;
				var path:String = data.giftPicPath;
//				str = sName + "送给" + tName + count + "个" + gName;
				var sNameE:GraphicTextElement = textManager.createElement();
				sNameE.content ="[" +  sName  + "]";
				sNameE.type = GraphicTextElementType.Element_TEXT;
				sNameE.color = 0x7806FC;
				
				var sg:GraphicTextElement = textManager.createElement();
				sg.content = " 送给 ";
				sg.type = GraphicTextElementType.Element_TEXT;
				sg.color = 0x2B075E;
				
				var tNameE:GraphicTextElement = textManager.createElement();
				tNameE.content ="[" + tName + "]";
				tNameE.type = GraphicTextElementType.Element_TEXT;
				tNameE.color = 0x7806FC;
				
				var countE:GraphicTextElement = textManager.createElement();
				countE.content = " "+count;
				countE.type = GraphicTextElementType.Element_TEXT;
				countE.color = 0x7806FC;
				
				var ges:GraphicTextElement = textManager.createElement();
				ges.content = "个 ";
				ges.type = GraphicTextElementType.Element_TEXT;
				ges.color = 0x2B075E;
				
				var gNameE:GraphicTextElement = textManager.createElement();
				gNameE.content = gName;
				gNameE.type = GraphicTextElementType.Element_TEXT;
				gNameE.color = 0x7806FC;
				
				
				var icon:GraphicTextElement = textManager.createElement();
				icon.content = Utils.getURLGraphic(path,true,20,20);
				icon.content.y = -25;
				icon.type = GraphicTextElementType.Element_SHAPE;
				text = textManager.createGraphicText([sNameE,sg,tNameE,countE,ges,gNameE,icon]);
			}
			return text;
		}
	}
}