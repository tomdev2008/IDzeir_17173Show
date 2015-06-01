package com._17173.flash.player.ui.comps.backRecommendMiddle
{
	import com._17173.flash.core.util.Util;
	import com._17173.flash.player.ui.comps.Pic;
	import com._17173.flash.player.ui.comps.backRecommend.data.BackRecItemData;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	public class BackRecItemMiddle extends MovieClip
	{
		private var _hot:MovieClip = null;
		private var _bg:MovieClip = null;
		private var _itemData:BackRecItemData = null;
		private var _title:TextField = null;
		private var _mask:Sprite = null;
		private var _titleC:Sprite = null;
		private var _thisUrl:String = "";
		private var _pic:Pic = null;
		private var _topMask:Sprite = null;
		private var _showIcon:MovieClip = null;
		private var _w:Number;
		private var _h:Number;
		
		public function BackRecItemMiddle(w:Number, h:Number)
		{
			super();
			
			this.buttonMode = true;
			_w = w;
			_h = h;
			
			_bg = new mc_backRec_item_back();
			addChild(_bg);
			_bg.width = _w;
			_bg.height = h;
			
			var format:TextFormat = new TextFormat();
			format.color = 0xFFFFFF;
			format.size = 16;
			format.font = Util.getDefaultFontNotSysFont();
			format.align = TextFormatAlign.CENTER;
			
			_pic = new Pic();
			_pic.isfit = true;
			_pic.width = _w;
			_pic.height = _h - 25;
			this.addChild(_pic);
			
			_mask = new Sprite();
			_mask.graphics.clear();
			_mask.graphics.beginFill(0,0);
			_mask.graphics.drawRect(0, 0, _w, _h - 25);
			_mask.graphics.endFill();
			this.addChild(_mask);
			_pic.mask = _mask;
			
			_titleC = new Sprite();
			_titleC.buttonMode = true;
			_titleC.mouseChildren = false;
			_titleC.graphics.clear();
			_titleC.graphics.beginFill(0,0);
			_titleC.graphics.drawRect(0, 0, _w, 25);
			_titleC.graphics.endFill();
			this.addChild(_titleC);
			
			_title = new TextField();
			_title.width = w;
			_title.autoSize = TextFieldAutoSize.CENTER;
			_title.selectable = false;
			_title.defaultTextFormat = format;
			_title.setTextFormat(format);
			_titleC.addChild(_title);
			
			_topMask = new Sprite();
			_topMask.graphics.clear();
			_topMask.graphics.beginFill(0x000000,0.7);
			_topMask.graphics.drawRect(0, 0, _w, _h - 25);
			_topMask.graphics.endFill();
//			addChild(_topMask);
			
			resize();
			init();
		}
		
		private function init():void
		{
			this.addEventListener(MouseEvent.ROLL_OVER, showTitle);
			this.addEventListener(MouseEvent.ROLL_OUT, hideTitle);
			this.addEventListener(MouseEvent.CLICK, thisClick);
		}
		
		private function thisClick(evt:MouseEvent):void
		{
//			navigateToURL((new URLRequest(_thisUrl)), "_blank");
			Util.toUrl(_thisUrl);
		}
		
		private function showTitle(evt:MouseEvent):void
		{
			_title.textColor = 0xfdcd00;
			_topMask.visible = false;
		}
		
		private function hideTitle(evt:MouseEvent):void
		{
			_title.textColor = 0xffffff;
			_topMask.visible = true;
		}
		
		public function initData(obj:BackRecItemData):void
		{
			if(obj)
			{
				_itemData = obj;
				if(_itemData.title)
				{
					_title.text = _itemData.title;
				}
				else
				{
					_title.text = "";
				}
				_thisUrl = _itemData.play_url;
				_title.text = Util.formatStringExceed(_title, _w);
				
				if (_itemData.pic_4in3 && _itemData.pic_4in3 != "") {
					_pic.content = _itemData.pic_4in3;
				} else {
					_pic.content = _itemData.pic_16in9;
				}
				
				if(_itemData.isHot == 1)
				{
					showHot();
				}
				if (_itemData.isShow) {
					showShowIcon();
				}
			}
		}
		
		private function ioEvent(evt:Event):void
		{
			
		}
		
		private function showHot():void
		{
			_hot = new mc_backRec_item_hot();
			addChild(_hot);
		}
		
		/**
		 * 显示秀场“娱乐”角标
		 */		
		private function showShowIcon():void {
			if (_hot && contains(_hot)) {
				removeChild(_hot)
			}
			if (!_showIcon) {
				_showIcon = new mc_fileBackRec_showIcon();
			}
			if (!contains(_showIcon)) {
				addChild(_showIcon);
			}
		}
		
		public function resize():void
		{
			if(_titleC && this.contains(_titleC))
			{
				_titleC.x = 0;
				_titleC.y = _pic.height;
			}
		}
	}
}