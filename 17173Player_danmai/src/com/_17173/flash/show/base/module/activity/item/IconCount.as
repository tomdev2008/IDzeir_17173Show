package com._17173.flash.show.base.module.activity.item
{
	import com._17173.flash.show.base.utils.FontUtil;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.text.TextField;
	
	public class IconCount extends Sprite
	{
		private var _icon:DisplayObject = null;
		private var _countTf:TextField = null;
		private var _bg:DisplayObject;
		public function IconCount()
		{
			super();
			init();
		}
		
		private function init():void{
			
			_countTf = new TextField();
			_countTf.defaultTextFormat = FontUtil.DEFAULT_FORMAT;
			_countTf.setTextFormat(FontUtil.DEFAULT_FORMAT);
			_countTf.x = 2;
			_countTf.y = 2;
			_countTf.width = 30;
			_countTf.height = 25;
			_countTf.wordWrap = false;
			_countTf.multiline = false;
			_countTf.mouseEnabled = false;
			this.addChild(_countTf);
		}
		
		public function updateLabel(htmlText:String):void{
			_countTf.htmlText = htmlText;
			_countTf.width = _countTf.textWidth+4;
			_countTf.height = _countTf.textHeight + 4;
			resize();
		}
		
		public function setIcon(icon:DisplayObject):void{
			if(_icon && _icon.parent){
				_icon.parent.removeChild(_icon);
			}
			_icon = icon;
			this.addChild(icon);
			resize();
		}
		
		public function setbg(dis:DisplayObject):void{
			_bg = dis;
			this.addChildAt(dis,0);
			resize();
		}
		
		private function resize():void{
			var cW:int = _countTf.width + 4;
			if(_icon){
				cW = cW + _icon.width + 10;
				_countTf.x = _icon.width + 8;
				_icon.x = 2;
			}
			if(_bg){
				_bg.width = cW;
				if(_bg.height < (_countTf.height+4)){
					_bg.height = _countTf.height+4;
				}
				_countTf.y = (_bg.height - _countTf.height)/2 + 1;
				
				if(_icon){
					_icon.y = (_bg.height - _icon.height)/2;
				}
			}
			
			
			
		}
	}
}