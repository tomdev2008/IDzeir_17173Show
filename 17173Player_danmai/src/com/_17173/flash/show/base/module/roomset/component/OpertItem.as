package com._17173.flash.show.base.module.roomset.component
{
	import com._17173.flash.core.components.common.CompEnum;
	import com._17173.flash.show.base.module.roomset.common.ButtonBindData;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class OpertItem extends Sprite
	{
		private const FONT_NAME:String = "Microsoft YaHei,微软雅黑,宋体,Monaco";
		
		private var _measuredWidth:int = 155;//默认宽度
		private var _measuredHight:int = 35;// 默认高度
		
		private var _leftOff:int = 15; //左面偏移
		private var _rightOff:int = 15;//右面偏移
		
		private var _label:String = null;
		private var _labelTxt:TextField = null;

		private var _overMc:Shape;//鼠标经过背景
		
		private var _data:ButtonBindData = null;
		
		public function OpertItem()
		{
			super();
			this.mouseChildren = false;
			this.buttonMode = true;
			
			initTextField();
			
			_overMc=new Shape();
			this.addChildAt(_overMc,0);
			_overMc.visible=false;
			
			this.addEventListener(MouseEvent.MOUSE_OVER,mouserOverHander);
			this.addEventListener(MouseEvent.MOUSE_OUT,mouserOutHandler);
		}
		
		public function get measuredHight():int
		{
			return _measuredHight;
		}

		public function set measuredHight(value:int):void
		{
			_measuredHight = value;
		}

		public function get measuredWidth():int
		{
			return _measuredWidth;
		}

		public function set measuredWidth(value:int):void
		{
			_measuredWidth = value;
		}
		
		public function get data():ButtonBindData
		{
			return _data;
		}
		
		public function set data(value:ButtonBindData):void
		{
			_data = value;
			this.label = _data.label;
		}

		/**
		 *初始化文本，计算居中 
		 * 
		 */		
		protected function initTextField():void{
			var textFormat:TextFormat = new TextFormat();
			textFormat.color = CompEnum.LABEL_BUTTON_COLOR;
			textFormat.font = FONT_NAME;
			textFormat.size = CompEnum.LABEL_BUTTON_SIZE;
			_labelTxt = new TextField();
			_labelTxt.multiline = false;
			_labelTxt.width = 12;
			_labelTxt.height = 12;
			_labelTxt.setTextFormat(textFormat);
			_labelTxt.defaultTextFormat = textFormat;
			_labelTxt.mouseEnabled = false;
			_labelTxt.selectable = false;
			this.addChild(_labelTxt);
		}
		
		/**
		 *按钮标签 
		 * @return 
		 * 
		 */
		public function get label():String
		{
			return _label;
		}
		
		public function set label(value:String):void
		{
			_label = value;
			updateLabel();
		}

		
		/**
		 *更新显示列表
		 * 
		 */		
		public function updateDisplayList():void{
			if(_labelTxt){
				//绘画背景
				_overMc.graphics.beginFill(0x4A0058,1);
				_overMc.graphics.drawRect(1,1,_measuredWidth-1,_measuredHight-1);
				_overMc.graphics.endFill();
				
				this.graphics.clear();
				this.graphics.lineStyle(1, 0x4C0640, 1);
				this.graphics.beginFill(0x22022A,1);
				this.graphics.drawRect(0,0,_measuredWidth,_measuredHight);
				this.graphics.endFill();
				
				_labelTxt.x = _leftOff;
				_labelTxt.y = (_measuredHight - _labelTxt.height)/2;
			}
		}
		
		/**
		 *更新文本位置 
		 * 
		 */		
		private function updateLabel():void{
			if(_labelTxt == null) return;
			_labelTxt.htmlText = _label;
			//计算文本框放置位置
			var tw:int = _labelTxt.textWidth;
			var th:int = _labelTxt.textHeight;
			_labelTxt.width = tw + 4;
			_labelTxt.height = th + 3;
			
			if(_labelTxt.height > _measuredHight)
				_measuredHight = _labelTxt.height + 4;
			if(_labelTxt.width > _measuredWidth)
				_measuredWidth = _labelTxt.width+_leftOff+_rightOff;
		}
		
		private function mouserOverHander(event:MouseEvent):void
		{
			_overMc.visible=true;
		}
		
		private function mouserOutHandler(event:MouseEvent):void
		{
			_overMc.visible=false;
		}
	}
}