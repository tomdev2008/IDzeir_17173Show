package com._17173.flash.player.ui.tip
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.skin.ISkinManager;
	import com._17173.flash.core.skin.ISkinObject;
	import com._17173.flash.player.context.ContextEnum;
	import com._17173.flash.player.model.PlayerEvents;
	import com._17173.flash.player.ui.comps.SkinsEnum;
	
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TextEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	/**
	 * 友好提示的显示对象.
	 * 
	 * 直播是灰色底黄色字显示在中间,没有关闭按钮.
	 * 点播是全屏宽度的条右侧有关闭按钮,文字显示在中间.
	 *  
	 * @author shunia-17173
	 */	
	public class Tooltip extends Sprite
	{
		
		private var _bg:Shape = null;
		private var _data:TooltipData = null;
		private var _text:TextField = null;
		private var _clsBtn:DisplayObject = null;
		
		public function Tooltip()
		{
			super();
			
			_bg = new Shape();
			addChild(_bg);
			
			_text = new TextField();
			_text.autoSize = TextFieldAutoSize.LEFT;
			_text.addEventListener(TextEvent.LINK, onSuperLink);
			_text.selectable = false;
			addChild(_text);
			
			if (!Context.variables["lv"]) {
				_clsBtn = new mc_clsBtn();
				addChild(_clsBtn);
				_clsBtn.addEventListener("close", onClose);
			}
			
			Context.getContext(ContextEnum.EVENT_MANAGER).listen(PlayerEvents.UI_RESIZE, onResize);
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		protected function onAdded(event:Event):void {
			updateView();
			onResize();
		}
		
		public function set data(value:TooltipData):void {
			if (value) {
				_data = value;
				refresh(value);
			}
		}
		
		public function onResize(e:Object = null):void {
			if (Context.variables["lv"]) {
				x = (Context.stage.stageWidth - width) / 2;
			}
			
//			var bottomBar:ISkinObject = Global.skinManager.getSkin(SkinsEnum.BOTTOM_BAR);
			var bottomBar:ISkinObject = (Context.getContext(ContextEnum.SKIN_MANAGER) as ISkinManager).getSkin(SkinsEnum.BOTTOM_BAR);
			if (bottomBar) {
				y = Context.stage.stageHeight - bottomBar.display.height - height;
			}
		}
		
		private function refresh(data:TooltipData):void {
			clear();
			
			_text.htmlText = _data.content;
		}
		
		private function updateView():void {
			if (Context.variables["lv"]) {
				_bg.graphics.clear();
				_bg.graphics.beginFill(0x000000, 0.8);
				_bg.graphics.drawRect(0, 0, _text.textWidth + 20, _text.textHeight + 10);
				_bg.graphics.endFill();
				
				_text.x = 10;
				_text.y = 5;
			} else {
				_clsBtn.scaleX = _clsBtn.scaleY = 0.5;
				_text.x = 5;
				_clsBtn.x = _text.width + 20;
				_clsBtn.y = (height - _clsBtn.height) / 2;
				
				_bg.graphics.clear();
				_bg.graphics.drawRect(0, 0, _clsBtn.width + _clsBtn.x + 3, _text.height + 2);
				_bg.graphics.endFill();
				_text.y = 1;
			}
		}
		
		private function clear():void {
			_text.htmlText = "";
		}
		
		protected function onSuperLink(event:TextEvent):void {
			if (_data.callback != null) {
				try {
					_data.callback();
				} catch (e:Error) {};
			}
		}
		
		private function onClose(evt:Event):void {
			dispatchEvent(new Event("close"));
		}
		
	}
}