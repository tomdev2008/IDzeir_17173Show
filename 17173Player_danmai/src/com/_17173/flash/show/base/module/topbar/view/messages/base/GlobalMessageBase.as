package com._17173.flash.show.base.module.topbar.view.messages.base
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.util.Util;
	import com._17173.flash.show.base.context.layer.IUIManager;
	import com._17173.flash.show.base.context.resource.IResourceManager;
	import com._17173.flash.show.base.utils.FontUtil;
	import com._17173.flash.show.model.CEnum;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class GlobalMessageBase extends Sprite implements IGlobalMessageShow
	{
		protected var infos:Object;
		/**
		 *等级icon 
		 */		
		protected var lvlIcon:DisplayObject;
		/**
		 *礼物图片 
		 */		
		protected var giftIcon:DisplayObject;
		protected var sName:String;
		protected var sLabel:TextField;
		protected var tname:String;
		protected var tLabel:TextField;
		protected var gName:String;
		protected var sgLabel:TextField;
		protected var otCount:String;
		protected var otLabel:TextField;
		protected var _rs:IResourceManager;
		protected var _ui:IUIManager;
		protected var _test:TextField;
		protected var _limieWidth:int = 120;
		protected var showSp:Sprite;
		protected var line:Sprite;
		protected var linkto:String;
		protected var showLine:Boolean;
		protected var timeLabel:TextField;
		public function GlobalMessageBase()
		{
			super();
			showSp = new Sprite();
			this.addChild(new Top_Message_Bg());
			lvlIcon = new Sprite();
			
			giftIcon = new Sprite();
			sLabel = new TextField();
			sLabel.height  = 28;
			sLabel.defaultTextFormat = FontUtil.DEFAULT_FORMAT;
			sLabel.setTextFormat(FontUtil.DEFAULT_FORMAT)
			sLabel.selectable = false;
			tLabel = new TextField();
			tLabel.height  = 28;
			tLabel.defaultTextFormat = FontUtil.DEFAULT_FORMAT;
			tLabel.setTextFormat(FontUtil.DEFAULT_FORMAT)
			tLabel.selectable = false;
			sgLabel = new TextField();
			sgLabel.height  = 28;
			sgLabel.defaultTextFormat = FontUtil.DEFAULT_FORMAT;
			sgLabel.setTextFormat(FontUtil.DEFAULT_FORMAT)
			sgLabel.mouseEnabled = false;
			otLabel = new TextField();
			otLabel.height  = 28;
			otLabel.defaultTextFormat = FontUtil.DEFAULT_FORMAT;
			otLabel.setTextFormat(FontUtil.DEFAULT_FORMAT)
			otLabel.mouseEnabled = false;
			
			timeLabel = new TextField();
			timeLabel.height  = 28;
			timeLabel.defaultTextFormat = FontUtil.DEFAULT_FORMAT;
			timeLabel.setTextFormat(FontUtil.DEFAULT_FORMAT)
			timeLabel.mouseEnabled = false;
			_test = new TextField();
			sName = "";
			tname = "";
			gName = "";
			otCount = "";
			line = new Sprite();
			showSp.addChild(sLabel);
			showSp.addChild(tLabel);
			showSp.addChild(sgLabel);
			showSp.addChild(otLabel);
			showSp.addChild(timeLabel)
			showSp.addChild(line);
			this.addChild(showSp);
			_rs = Context.getContext(CEnum.SOURCE) as IResourceManager;
			_ui = Context.getContext(CEnum.UI) as IUIManager;
			this.addEventListener(MouseEvent.CLICK,onClick);
		}
		
		protected function onClick(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			if(showLine){
				Util.toUrl(infos.url);
			}
			
		}		
		
		protected function updateLine():void{
			line.graphics.clear();
			line.graphics.lineStyle(1,0xeeeeee,1);
			line.graphics.moveTo(0,54);
			line.graphics.lineTo(showSp.width,54);
		}
		
		public function updateInfo(data:Object, sLine:Boolean=true):void
		{
			infos = data;
			setupInfo();
			showLine = sLine;
			if(showLine){
				updateLine();
				if(line.parent == null){
					showSp.addChild(line);
				}
				this.buttonMode = true;
			}else{
				if(line.parent != null){
					showSp.removeChild(line);
				}
				this.buttonMode = false;
			}
		}
		
		public function clear():void
		{
			infos = null
			_ui.destroyTip(tLabel);
			_ui.destroyTip(sLabel);
			if(lvlIcon.parent){
				lvlIcon.parent.removeChild(lvlIcon);
			}
			if(giftIcon.parent){
				giftIcon.parent.removeChild(giftIcon);
			}
			sName = "";
			tname = "";
			gName = "";
			otCount = "";
			linkto = "";
			showLine = false;
		}
		
		public function checkLen(str:String):Boolean{
			_test.htmlText = "<font color='#63D3FF' size='16'>" + str +"</font>";
			if((_test.textWidth + 4) > _limieWidth){
				return false;
			}
			return true;
		}
		
		
		protected function setupInfo():void{
			
		}
	}
}