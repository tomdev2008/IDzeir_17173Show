package com._17173.flash.player.module.gift.ui
{
	import com._17173.flash.core.util.Util;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;

	/**
	 *全局礼物飞屏
	 * @author zhaoqinghao
	 *
	 */
	public class GiftEffectGlobal extends Sprite
	{
		private var _label:TextField = null;
		/**
		 *底图组件
		 */
		private var _bgmc:MovieClip = null;
		
		private var bgSprite:Sprite = null;
		/**
		 *切后底图
		 */
		private var _bg:Bitmap = null;
		/**
		 *边框
		 */
		private var _frame:MovieClip = null;
		/**
		 *遮罩
		 */
		private var _mask:MovieClip = null;
		/**
		 *发光线
		 */
		private var _line1:MovieClip = null;
		private var _line:MovieClip = null;
		private var _box:MovieClip = null;
		/**
		 * 跳转链接 
		 */		
		private var _jumpTo:String = null;

		public function GiftEffectGlobal()
		{
			super();
			init();
			
			this.mouseChildren = false;
			buttonMode = true;
			useHandCursor = true;
			addEventListener(MouseEvent.CLICK, onClick);
		}
		
		/**
		 * 点击跳转到用户房间
		 *  
		 * @param event
		 */		
		protected function onClick(event:MouseEvent):void
		{
			if (Util.validateStr(_jumpTo)) {
				Util.toUrl(_jumpTo);
			}
		}
		
		private function init():void
		{
			//层级很重要
//			_mask = new mc_FlyMask();
//			_mask.scale9Grid = new Rectangle(160, 30, 50, 30);
//			this.mask = _mask;
//			this.addChild(_mask);
//			_mask.y = -2;
//			_mask.x = 13;
			//底图
			
			_bg = new Bitmap();
			bgSprite = new Sprite();
			bgSprite.addChild(_bg);
			bgSprite.x = 13;
			bgSprite.y = 18;
			this.addChild(bgSprite);
			
			_mask = new mc_FlyMask1();
//			_mask.scale9Grid = new Rectangle(160, 3, 50, 30);
			bgSprite.mask = _mask;
			bgSprite.addChild(_mask);
			
			//边框
			_frame = new mc_GiftGlobalbf();
			_frame.x = 13;
			_frame.y = 18;
//			_frame.scale9Grid = new Rectangle(160, 3, 50, 30);
			this.addChild(_frame);
			
			_box = new mc_GiftBox2();
			_box.x = 11;
			_box.y = 2;
			this.addChild(_box);

			//底图
			_bgmc = new mc_GiftGlobalaf();
			//遮罩 显示不规则形状边缘
			//发光的线
			_line = new mc_GiftGlobalLine();
			this.addChild(_line);
			_line1 = new mc_GiftGlobalLine();
			this.addChild(_line1);

			_label = new TextField();
			_label.x = 115;
			_label.y = 24;
			_label.selectable = false;
			this.addChild(_label);
		}

		public function updateText(label:String):void
		{
			//_label.htmlText = "<font size='20' color='#FFE260' face='Microsoft yahei'>" + HtmlUtil2.encode(label) + "</font>";
			var _format:TextFormat = new TextFormat();
			_format.size = 20;
			_format.font = 'Microsoft yahei';
			_format.color = 0xFFE260;
			
			_label.text = label;
			_label.setTextFormat(_format);
			_label.width = _label.textWidth + 20;
			
			var th:int = _label.textWidth + 170;

			//线
			_line.x = th - 20 - _line.width;
			_line.y = 19;
			_line1.x = 185;
			_line1.y = 62;

			//缩放
			_frame.width = th ;
			_mask.width = th;
			if (_bg.bitmapData)
			{
				_bg.bitmapData.dispose();
				_bg.bitmapData = null;
			}
			var bmd:BitmapData = new BitmapData(_frame.width, 45);
			bmd.draw(_bgmc, null, null, null, new Rectangle(0, 0, _frame.width, 45));
			_bg.bitmapData = bmd;
		}
		
		public function set jumpTo(value:String):void {
			_jumpTo = value;
		}
		
	}
}

