package com._17173.flash.show.base.module.bag.view
{
	import com._17173.flash.core.components.common.Button;
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.locale.ILocale;
	import com._17173.flash.show.model.CEnum;
	
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	/**
	 *背包提示弹框  
	 * @author yeah
	 */	
	public class BagAlert extends BagPopPane
	{
		
		/**
		 *内容 
		 */		
		private var contentTF:TextField;
		
		private var _callBack:Function;

		/**
		 *确定回调函数 
		 * @param value
		 */		
		public function set callBack(value:Function):void
		{
			_callBack = value;
		}

		
		public function BagAlert()
		{
			super();
			
			attachSkin(new BagAlertBG());
			
			addCloseBtn(246, 1);
			
			var btn:Button = new Button((Context.getContext(CEnum.LOCALE) as ILocale).get("okBtn","bag"));
			btn.setSkin(new BagAlertOkBtn());
			btn.x = 95;
			btn.y = 153;
			btn.addEventListener(MouseEvent.CLICK, onOK);
			this.addChild(btn);
			
			var f:TextFormat = new TextFormat("Microsoft YaHei,微软雅黑,宋体", 16, 0xffff99, null, null, null, null, null, TextFormatAlign.CENTER, null, null, null, -5);
			contentTF = new TextField();
			contentTF.multiline = true;
			contentTF.wordWrap = true;
			contentTF.y = 62;
			contentTF.width = 270;
			contentTF.height = 200;
			contentTF.mouseEnabled = false;
			contentTF.defaultTextFormat = f;
			this.addChild(contentTF);
		}
		
		/**
		 *确定 
		 * @param event
		 */		
		private function onOK(event:MouseEvent):void
		{
			close();
			if(_callBack!=null)
			{
				_callBack.call();
			}
		}
		
		/**
		 *添加文本 
		 * @param $text
		 */		
		public function addText($text:String, $color:String, $size:int, $newLine:Boolean = false):void
		{
			if(!$newLine)
			{
				contentTF.htmlText = "";
			}
			contentTF.htmlText += ($newLine ? "\n":"") + "<font color='"+$color+"' size='"+$size+"'>" + $text + "</font>";
		}
	}
}