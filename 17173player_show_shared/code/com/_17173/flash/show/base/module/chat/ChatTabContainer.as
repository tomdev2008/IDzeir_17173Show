package com._17173.flash.show.base.module.chat
{
	import com._17173.flash.core.components.common.GraphicText;
	import com._17173.flash.core.components.common.TabBar;
	import com._17173.flash.core.components.common.TabContainer;
	import com._17173.flash.core.components.common.ViewStack;
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.core.locale.ILocale;
	import com._17173.flash.core.util.Util;
	import com._17173.flash.show.base.context.text.IGraphicTextManager;
	import com._17173.flash.show.base.utils.FontUtil;
	import com._17173.flash.show.model.CEnum;
	import com._17173.flash.show.model.SEvents;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.engine.ContentElement;
	import flash.text.engine.GroupElement;
	import flash.text.engine.TextBaseline;
	import flash.text.engine.TextBlock;
	import flash.text.engine.TextElement;

	/**
	 * @author idzeir
	 * 创建时间：2014-2-18  下午3:13:46
	 */
	public class ChatTabContainer extends TabContainer
	{
		private var _block:TextBlock;

		private var txt:GraphicText;
		
		private var txtBg:Sprite;
		
		public function ChatTabContainer()
		{
			super();
		}

		override protected function addChildren():void
		{
			tabBar = new TabBar(ChatListTabButton);
			viewStack = new ViewStack();

			this.addChild(tabBar);
			this.addChild(viewStack);
			
			//创建房间公告内容
			createNotice();
		}
		
		private function createNotice():void
		{
			_block = new TextBlock();
			_block.baselineZero = flash.text.engine.TextBaseline.DESCENT;
			txt = new GraphicText(null,true,65);
			txt.leading = 7;
			txt.textWidth = 330;	
			txt.x = 8;
			txtBg = new NoticeBg();			
		}
		
		public function get noticeHeight():Number
		{
			return txt.height + 5;
		}
		
		public function notice(value:String,link:String = ""):void
		{
			var local:ILocale = Context.getContext(CEnum.LOCALE) as ILocale;
			var msg:String = value == ""?local.get("defaultNotice","chatPanel"):value;
			var txtMgr:IGraphicTextManager = (Context.getContext(CEnum.GRAPHIC_TEXT) as IGraphicTextManager);
			txt.clear();
			
			var te:TextElement = new TextElement(local.get("msg_notice","chatPanel")+" : "+msg,FontUtil.getFormat(0xff9900));
			
			var vector:Vector.<ContentElement> = new Vector.<ContentElement>();
			vector.push(te);
			
			var gp:GroupElement = new GroupElement(vector,FontUtil.getFormat(0xff9900));
			if(Util.validateStr(link))
			{
				gp.userData = {"link":link,indent:60,unline:true,leading:0};	
			}			
			txt.addElement(gp);			
			if(!this.contains(txt))
			{
				this.addChild(txtBg);
				this.addChild(txt);
			}
			txtBg.height = txt.height + 20;
			
			txtBg.y = tabBar.contentMaxHeight;
			viewStack.y = tabBar.contentMaxHeight + 15 + txt.height;
		}

		override public function addItem(key:String, label:String, graphic:DisplayObject):void
		{
			var tbData:Object = {label:label, index:tabBar.size}
			tabBar.addItem(tbData);
			viewStack.addItem(key, label, graphic);

			if(!tabBar.hasEventListener(flash.events.Event.CHANGE))
			{
				tabBar.addEventListener(Event.CHANGE, onChange);
			}
			txt.y = tabBar.height + 10;	
			
			//txtBg.width = 330;
			txtBg.y = tabBar.contentMaxHeight;
			viewStack.y = tabBar.contentMaxHeight + 15 + txt.height;
			drawRules();
		}

		override protected function drawRules():void
		{
			this.graphics.clear();
			this.graphics.lineStyle(0, 0, 0);

			this.graphics.beginFill(0x976ADD);
			this.graphics.drawRect(0, tabBar.contentMaxHeight - .5, viewStack.contentMaxWidth + 15, 1);

			this.graphics.beginFill(0x5a3ba5);
			this.graphics.drawRect(0, tabBar.contentMaxHeight + .5, viewStack.contentMaxWidth + 15, 1);
		}

		/**
		 * 指定index的tab闪烁
		 * @param _index
		 *
		 */
		public function flash(_index:uint):void
		{
			(Context.getContext(CEnum.EVENT) as IEventManager).send(SEvents.TAB_BUTTON_FLASH, _index);
			tabBar.flash(_index);
		}
	}
}