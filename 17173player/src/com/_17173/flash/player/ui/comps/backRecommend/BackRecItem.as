package com._17173.flash.player.ui.comps.backRecommend
{
	import com._17173.flash.core.util.Util;
	import com._17173.flash.player.ui.comps.Pic;
	import com._17173.flash.player.ui.comps.backRecommend.data.BackRecItemData;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class BackRecItem extends MovieClip
	{
		private var _hot:MovieClip = null;
		private var _bg:MovieClip = null;
		private var _itemData:BackRecItemData = null;
		private var _title:TextField = null;
		private var _mask:Sprite = null;
		private var _fontBack:MovieClip = null;
		private var _thisUrl:String = "";
		private var _pic:Pic = null;
		private var _labelC:Sprite = null;
		private var _topMask:Sprite = null;
		private var _showIcon:MovieClip = null;
		
		public function BackRecItem()
		{
			super();
			
			this.buttonMode = true;
			_bg = new mc_backRec_item_back();
			addChild(_bg);
			
			_fontBack = new mc_backRec_item_font_back();
			addChild(_fontBack);
			
			var format:TextFormat = new TextFormat();
			format.color = 0xFFFFFF;
			format.size = 14;
			format.font = Util.getDefaultFontNotSysFont();
//			format.align = TextFormatAlign.CENTER;
			
			_pic = new Pic();
			_pic.isfit = true;
			_pic.width = this.width;
			_pic.height = this.height;
			addChild(_pic);
			
			_mask = new Sprite();
			_mask.graphics.clear();
			_mask.graphics.beginFill(0,0);
			_mask.graphics.drawRect(0, 0, _pic.width, _pic.height);
			_mask.graphics.endFill();
			addChild(_mask);
			mask = _mask;
			
			_labelC = new Sprite();
			_labelC.graphics.clear();
			_labelC.graphics.beginFill(0x000000, 0.8);
			_labelC.graphics.drawRect(0, 0, _pic.width, 25);
			_labelC.graphics.endFill();
			_labelC.visible = false;
			_labelC.y = _pic.height - _labelC.height;
			addChild(_labelC);
			
			_title = new TextField();
			_title.width = this.width;
			_title.autoSize = TextFieldAutoSize.CENTER;
			_title.wordWrap = false;
			_title.defaultTextFormat = format;
			_title.setTextFormat(format);
			_labelC.addChild(_title);
			
			_topMask = new Sprite();
			_topMask.graphics.clear();
			_topMask.graphics.beginFill(0x000000, 0.5);
			_topMask.graphics.drawRect(0, 0, _pic.width, _pic.height);
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
			_labelC.y = _pic.height - _labelC.height;
			_title.text = Util.formatStringExceed(_title, 200);
			_labelC.visible = true;
			_topMask.visible = false;
		}
		
		private function hideTitle(evt:MouseEvent):void
		{
			_labelC.visible = false;
			_topMask.visible = true;
		}
		
		public function initData(obj:BackRecItemData):void
		{
			if(obj)
			{
				_itemData = obj;
				_title.text = (_itemData.title == null ? "" : _itemData.title);
				_title.text = Util.formatStringExceed(_title, 200);
				_thisUrl = _itemData.play_url;
				if (_itemData.pic_16in9) {
					_pic.content = _itemData.pic_16in9;
				} else {
					//一个容错处理，如果没有16:9就取4:3
					if (_itemData.pic_4in3) {
						_pic.isfit = true;
						_pic.content = _itemData.pic_4in3;
					}
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
				_showIcon.y = 1;
			}
			if (!contains(_showIcon)) {
				addChild(_showIcon);
			}
		}
		
		public function resize():void
		{
			if(_fontBack && this.contains(_fontBack))
			{
				_fontBack.x = 0;
				_fontBack.y = _bg.height - _fontBack.height + 1;
			}
		}
	}
}