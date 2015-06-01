package com._17173.flash.show.base.module.centermessage
{
	import com._17173.flash.core.components.common.GraphicText;
	import com._17173.flash.core.context.Context;
	import com._17173.flash.show.base.context.module.BaseModule;
	import com._17173.flash.show.base.context.text.GraphicTextElement;
	import com._17173.flash.show.base.context.text.GraphicTextElementType;
	import com._17173.flash.show.base.context.text.GraphicTextOption;
	import com._17173.flash.show.base.context.text.IGraphicTextManager;
	import com._17173.flash.show.base.module.centermessage.view.CenterMessagePane;
	import com._17173.flash.show.base.utils.FontUtil;
	import com._17173.flash.show.model.CEnum;
	
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class CenterMessage extends BaseModule
	{
		private var _messagePane:CenterMessagePane = null;
		public function CenterMessage()
		{
			super();
			_version = "0.0.3";
		}
		
		override protected function init():void{
			this.mouseEnabled = false;
		
			var rankBg:RankBg = new RankBg();
			this.addChild(rankBg);
			rankBg.x = 0;
			rankBg.y = 0;
			rankBg.width = 260;
			rankBg.height = 133;
			
			var format:TextFormat = FontUtil.DEFAULT_FORMAT;
			format.color = 0xE5E5E5;
			format.size = 14;
			
			var title:TextField = new TextField();
			title.defaultTextFormat = format;
			title.text = "送礼记录";
			title.x = 104;
			title.y = 5;
			title.selectable = false;
			this.addChild(title);
			
			var rankLine:RankLine = new RankLine();
			rankLine.x = 0;
			rankLine.y = 35;
			this.addChild(rankLine);
			
			_messagePane = new CenterMessagePane();
			_messagePane.y = 42;
			_messagePane.x = 0;
			addChild(_messagePane);
		}
		
		public function addMessage(data:Object):void{
			var sName:String = data.sName;
			var sNo:String = data.sNo;
			var tName:String = data.tName;
			var tNo:String = data.tNo;
			var gName:String = data.giftName;
			var count:String = data.giftCount;
			var str:String = "<font color='#63acff'>"+sName +"</font>" + "送给" + "<font color='#63acff'>"+tName +"</font><font color='#efe46c'>"+ count + "</font>个" + gName;
			var sprite:Sprite = new Sprite();
			
			
			var textManager:IGraphicTextManager = Context.getContext(CEnum.GRAPHIC_TEXT) as IGraphicTextManager;
			var sNameE:GraphicTextElement = textManager.createElement();
			sNameE.content = sName;
			sNameE.color = 0x63acff;
			sNameE.type = GraphicTextElementType.Element_TEXT;
			
			var sNormalE:GraphicTextElement = textManager.createElement();
			sNormalE.content = "送给";
			sNormalE.color = 0xd0cfcf;
			sNormalE.type = GraphicTextElementType.Element_TEXT;
			
			var tNameE:GraphicTextElement = textManager.createElement();
			tNameE.content = tName;
			tNameE.color = 0x63acff;
			tNameE.type = GraphicTextElementType.Element_TEXT;
			
			var sCountE:GraphicTextElement = textManager.createElement();
			sCountE.content = count.toString();
			sCountE.color = 0xefe46c;
			sCountE.type = GraphicTextElementType.Element_TEXT;
			
			var gNameE:GraphicTextElement = textManager.createElement();
			gNameE.content = "个"+gName;
			gNameE.color = 0xd0cfcf;
			gNameE.type = GraphicTextElementType.Element_TEXT;
			
			var text:GraphicText = textManager.createGraphicText([sNameE,sNormalE,tNameE,sCountE,gNameE],new GraphicTextOption(true)) as GraphicText;
			text.textWidth = 218;
			text.x = 20;

			if(text.height <= 20){
				text.y = 9;
			}else{
				text.y = 0;
			}
			sprite.graphics.beginFill(0xFF0000,0);
			sprite.graphics.drawRect(0,0,240,40);
			sprite.graphics.endFill();
		
			sprite.addChild(text);
		
			var sc:SmallCricle = new SmallCricle;
			sc.x = 10;
			sc.y = 15;
			
			sprite.addChild(sc);
		
			_messagePane.addMsg(sprite);
		}
		
	}
}