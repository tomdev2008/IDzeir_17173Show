package com._17173.flash.player.ui.stream.rec
{
	import com._17173.flash.core.util.Util;
	import com._17173.flash.player.ui.comps.Pic;
	import com._17173.flash.player.ui.comps.grid.GridItemRenderer;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class StreamOrgnizeRecItem extends GridItemRenderer
	{
		
		private static const PIC_WIDTH:int = 160;
		private static const PIC_HEIGHT:int = 90;
		
		private var _preview:Pic = null;
		private var _info:Sprite = null;
		private var _tfTitle:TextField = null;
		private var _tfMaster:TextField = null;
		private var _url:String = null;
		
		public function StreamOrgnizeRecItem()
		{
			super();
			
			graphics.beginFill(0xFFFFFF, 0.2);
			graphics.drawRect(0, 0, PIC_WIDTH, PIC_HEIGHT);
			graphics.endFill();
			
			_preview = new Pic();
			_preview.width = PIC_WIDTH;
			_preview.height = PIC_HEIGHT;
			addChild(_preview);
			
			_info = new Sprite();
			_info.visible = false;
			_info.graphics.beginFill(0xFFFFFF, 0.4);
			_info.graphics.drawRect(0, 0, PIC_WIDTH, PIC_HEIGHT);
			_info.graphics.endFill();
			addChild(_info);
			
			_tfTitle = packUpText();
			_tfTitle.y = 2;
			_tfMaster = packUpText();
			_tfMaster.y = _tfTitle.y + _tfTitle.textHeight + 3;
			var btn:DisplayObject = new mc_orgRecBtn();
			_info.addChild(btn);
			btn.x = (PIC_WIDTH - btn.width) / 2;
			btn.y = _tfMaster.y + _tfMaster.textHeight + 3;
		}
		
		override public function set data(value:Object):void {
			super.data = value;
			
			var pic:String = _data.pic;
			if (Util.validateStr(pic)) {
				_preview.content = pic;
			}
			
			_tfTitle.text = "栏目名称:" + _data.liveTitle;
			_tfMaster.text = "主持人:" + _data.masterName;
			Util.shortenText(_tfTitle, PIC_WIDTH - 10);
			Util.shortenText(_tfMaster, PIC_WIDTH - 10);
			
			_url = _data.url;
			
			addEventListener(MouseEvent.CLICK, onClick);
			addEventListener(MouseEvent.ROLL_OVER, onOver);
			addEventListener(MouseEvent.ROLL_OUT, onOut);
		}
		
		private function onOut(event:MouseEvent):void {
			_info.visible = false;
		}
		
		private function onOver(event:MouseEvent):void {
			_info.visible = true;
		}
		
		private function onClick(event:MouseEvent):void {
			var u:String = Util.validateStr(_url) ? _url : "http://v.17173.com/live";
//			navigateToURL(new URLRequest(u), "_blank");
			Util.toUrl(u);
		}
		
		private function packUpText():TextField {
			var fmt:TextFormat = new TextFormat(Util.getDefaultFontNotSysFont(), 12, 0xFFFFFF);
			var t:TextField = new TextField();
			t.selectable = false;
			t.mouseEnabled = false;
			t.autoSize = TextFieldAutoSize.LEFT;
			t.defaultTextFormat = fmt;
			t.width = PIC_WIDTH - 15 * 2;
			t.text = " ";
			t.x = 5;
			_info.addChild(t);
			return t;
		}
		
	}
}