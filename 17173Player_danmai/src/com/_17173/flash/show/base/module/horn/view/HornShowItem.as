package com._17173.flash.show.base.module.horn.view
{
	import com._17173.flash.core.components.common.GraphicText;
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.util.Util;
	import com._17173.flash.show.base.context.text.GraphicTextElement;
	import com._17173.flash.show.base.context.text.GraphicTextElementType;
	import com._17173.flash.show.base.context.text.GraphicTextOption;
	import com._17173.flash.show.base.context.text.IGraphicTextManager;
	import com._17173.flash.show.model.CEnum;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	
	public class HornShowItem extends Sprite
	{
		public function HornShowItem()
		{
			super();
			mouseEnabled = false;
			y = 2;
		}
		
		private var _data:Object;

		/**
		 *数据 
		 * @return 
		 */		
		public function get data():Object
		{
			return _data;
		}

		public function set data(value:Object):void
		{
			if(_data == value) return;
			_data = value;
			
			if(!_data)
			{
				destroy();
				return;
			}
			
//			this.graphics.clear();
//			this.graphics.beginFill(0x22002B);
//			this.graphics.drawRect(0, 0, 200, 32);
//			this.graphics.endFill();
//			
//			return;
			
			//创建显示对象
			var msg:Object = _data;
			//赋值显示消息
			var textManager:IGraphicTextManager = Context.getContext(CEnum.GRAPHIC_TEXT) as IGraphicTextManager;
			var sName:String = msg.sName;
			var sNo:String = msg.sNo;
			var msgstr:String = msg.msg;
			var time:String = msg.time;
			var url:String = msg.url;
			
			var sNameE:GraphicTextElement = textManager.createElement();
			sNameE.content = sName + "：";
			sNameE.size = 14;
//			sNameE.color = 0x63acff;
			sNameE.color = 0xffffff;
			sNameE.type = GraphicTextElementType.Element_TEXT;
			
			var msgE:GraphicTextElement = textManager.createElement();
			msgE.size = 14;
			msgE.content = msgstr + "(" + time + ")";
//			msgE.color = 0x63acff;
			msgE.color = 0xA198B0;
			msgE.type = GraphicTextElementType.Element_CHAT_MESSAGE;
			
			var gto:GraphicTextOption = new GraphicTextOption(true);
			gto.showLink = true;
			gto.linkColor = 0xffffff;
//			gto.textWidth = 246;
			
			var isUrl:Boolean = false;
			var roomId:String = (Context.variables["showData"]).roomID;
			if(Util.validateStr(url) && url!=null &&  roomId!= msg.roomId){
				//msgE.link = url;
				isUrl = true;
				gto.unline = true;
				gto.link = url;
			}
			var text:GraphicText = textManager.createGraphicText([sNameE,msgE],gto) as GraphicText;
			text.x = 10;
//			text.y = (28 - text.height) >>1;
			text.y = 28 - text.height - 3;
			this.addChild(text);
			
			this.graphics.clear();
			this.graphics.beginFill(0x22002B);
			this.graphics.drawRect(0, 0, text.x + text.width + 75, 28);
			this.graphics.endFill();
		}
		
		/**
		 * 销毁 
		 */		
		private function destroy():void
		{
			recycle(this);
		}
		
		//===============================
		/**
		 *字典 
		 */	
		private static var _dic:Dictionary;
		
		/**
		 *创建 item
		 * @return 
		 */	
		public static function createItem($data:Object = null):DisplayObject
		{
			var item:*;
			for(item in _dic)
			{
				delete _dic[item];
				break;
			}
			
			if(!item)
			{
				item = new HornShowItem();
			}
			
			if($data)
			{
				item.data = $data;
			}
			item.alpha = 1;
			return item;
		}
		
		/**
		 *回收 
		 */	
		public static function recycle($item:DisplayObjectContainer):void
		{
			if(!$item) return;
			
			if($item.numChildren > 0)
			{
				var textManager:IGraphicTextManager = Context.getContext(CEnum.GRAPHIC_TEXT) as IGraphicTextManager;
				textManager.returnObject($item.removeChildAt(0));
			}
			
			if(!_dic)
			{
				_dic = new Dictionary(true);
			}
			_dic[$item] = true;
		}

	}
}