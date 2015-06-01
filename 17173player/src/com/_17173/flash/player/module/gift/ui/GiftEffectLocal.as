package com._17173.flash.player.module.gift.ui
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.filters.DropShadowFilter;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class GiftEffectLocal extends Sprite
	{
		private var _label:TextField = null;
		private var _bg:MovieClip = null;
		private var _box:MovieClip = null;
		
		public function GiftEffectLocal()
		{
			super();
			this.mouseChildren = this.mouseEnabled = false;
			init();
		}
		
		private function init():void
		{
			_bg = new mc_GiftLocal();
			_bg.scale9Grid = new Rectangle(10,5,10,20);
			this.addChild(_bg);
			
			_box = new mc_GiftBox1();
			_box.y = 0;
			this.addChild(_box);
			var dsf:DropShadowFilter = new DropShadowFilter(5,45,0x000000,1,5,5,1);
			_bg.filters = [dsf];
			_label = new TextField();
			_label.x = 15;
			_label.y = 4;
			this.addChild(_label);
		}
		
		public function updateText(label:String):void
		{
			var _format:TextFormat = new TextFormat();
			_format.size = 16;
			_format.font = 'Microsoft yahei';
			_format.color = 0x63FDFF;
			
			_label.text = label;
			_label.width = _label.textWidth + 20;
			_label.setTextFormat(_format);
			
			_label.width = _label.textWidth+20;
			//文字宽度加上左边10像素与右边60像素
			_bg.width = _label.textWidth + 80;
			_bg.height = 35;
			_box.x = _bg.width - 45;
		}
	}
}

