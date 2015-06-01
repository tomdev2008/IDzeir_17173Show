package com._17173.flash.player.ui.comps.def
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class ControlBarDefItem extends Sprite
	{
		private var _bg:Sprite = null;
		private var _con:Sprite = null;
		private var _flag:MovieClip = null;
		private var _label:TextField = null;
		private var tf:TextFormat = null;
		private var _enable:Boolean = false;
		
		private var COLOR_WHITE:Number = 0xFFFFFF;
		private var COLOR_YELLOW:Number = 0xFDCD00;
		private var COLOR_NULL:Number = 0x555555;
		
		public function ControlBarDefItem(value:String)
		{
			super();
//			buttonMode = true;
			
			_bg = new Sprite();
			_bg.graphics.clear();
			_bg.graphics.beginFill(0,0)
			_bg.graphics.drawRect(0, 0, 64, 30.5);
			_bg.graphics.endFill();
			addChild(_bg);
			
			_con = new Sprite();
			
			_bg.addChild(_con);
			
			_flag = new mc_def_btn_selected();
			_flag.visible = false;
//			_con.buttonMode = true;
			_con.addChild(_flag);
			
			_label = new TextField();
			_label.mouseEnabled = false;
			_label.text = value;
			_label.width = 35;
			_label.height = 20;
			_label.textColor = COLOR_WHITE;
			_label.x = _flag.x + _flag.width;
			_con.addChild(_label);
			
			resize();
			init();
		}
		
		private function init():void
		{
			addEventListener(MouseEvent.ROLL_OVER, rollOver);
			addEventListener(MouseEvent.ROLL_OUT, rollOut);
			addEventListener(MouseEvent.CLICK, mouseClick);
		}
		
		private function rollOver(evt:MouseEvent):void
		{
			if(enable)
			{
				_label.textColor = COLOR_YELLOW;
			}
		}
		
		private function rollOut(evt:MouseEvent):void
		{
			if(!enable)
			{
				return;
			}
			if(!_flag.visible)
			{
				_label.textColor = COLOR_WHITE;
			}
		}
		
		private function mouseClick(evt:MouseEvent):void
		{
			if(enable)
			{
				isSelect = true;
				dispatchEvent(new Event("onClick"));
			}
		}
		
		public function set isSelect(value:Boolean):void
		{
			if(!enable)
			{
				_flag.visible = false;
				_label.textColor = COLOR_NULL;
				return;
			}
			
			if(value)
			{
				_flag.visible = true;
				_label.textColor = COLOR_YELLOW;
			}
			else
			{
				_flag.visible = false;
				_label.textColor = COLOR_WHITE;
			}
		}
		
		private function resize():void
		{
			if(_con && _bg.contains(_con))
			{
				_con.x = (_bg.width - _con.width) / 2;
				_con.y = (_bg.height - _con.height) / 2;
			}
			if(_flag && _con.contains(_flag))
			{
				_flag.y = (_con.height - _flag.height) / 2;
			}
			if(_label && _con.contains(_label))
			{
				_label.x = _flag.x + _flag.width + 4;
				_label.y = (_con.height - _label.height) / 2;
			}
		}

		public function get enable():Boolean
		{
			return _enable;
		}

		public function set enable(value:Boolean):void
		{
			_enable = value;
			if(value)
			{
				buttonMode = true;
			}
			else
			{
				buttonMode = false;
				_label.textColor = COLOR_NULL;
			}
		}

	}
}