package com._17173.flash.show.base.module.chat
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.show.model.CEnum;
	import com._17173.flash.show.model.SEvents;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.Mouse;

	public class ChatVBox extends Sprite
	{
		private var _pubView:ChatMsgPanel;

		private var _gap:uint = 8;

		private var _priView:ChatMsgPanel;

		private var _drag:Sprite;

		private var _dragRect:Rectangle;

		private var _fixH:Number = 100;

		private var _bglayer:Shape;

		private var _minPub:Number = 40;

		private var _minPri:Number = 100;

		private var _pubPer:Number = .75;

		private var _pubTool:ToolGroup;

		private var _priTool:ToolGroup;
		private var _e:IEventManager;
		
		private var _oldPer:Number;
		private var _status:Boolean = true

		/**
		 * 拖动时鼠标形状 
		 */		
		private var _mouseIcon:Bitmap;
		
		private var _draging:Boolean = false;

		public function ChatVBox()
		{
			super();
			_bglayer = new Shape();
			this.addChild(_bglayer);

			_drag = new Sprite();
			_drag.mouseChildren = false;

			var exp:Expand1_8 = new Expand1_8();
			exp.x = -exp.width * .5;
			_drag.addChild(exp);
			_drag.buttonMode = true;
			
			
			_drag.addEventListener(MouseEvent.ROLL_OVER,onRollOver);
			_drag.addEventListener(MouseEvent.ROLL_OUT,onRollOut);
			_e = Context.getContext(CEnum.EVENT) as IEventManager;
			
			_e.listen(SEvents.SWITCH_PRI_CHAT,closePriPanel);
			
			_oldPer = this._pubPer;
			
			_mouseIcon = new Bitmap(new MouseDragIcon1_8(),"auto",true);
			_mouseIcon.visible = false;	
		}
		
		protected function onRollOut(e:MouseEvent):void
		{
			e.stopPropagation();
			if(!_draging)
			{
				_drag.addEventListener(MouseEvent.ROLL_OVER,onRollOver);
				_drag.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			}
		}
		
		protected function onMouseDown(e:MouseEvent):void
		{
			Mouse.hide();
			_draging = true;
			_drag.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_UP, release);
			_drag.startDrag(false, _dragRect);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onDrag);
			e.stopPropagation();
			
			stage.addChild(_mouseIcon);
			_mouseIcon.visible = true;
			var local:Point = this.localToGlobal(new Point(mouseX - _mouseIcon.width*.5,mouseY - _mouseIcon.height*.5))
			_mouseIcon.x = local.x;
			_mouseIcon.y = local.y;
		}
		
		protected function onRollOver(e:MouseEvent):void
		{
			e.stopPropagation();
			_drag.removeEventListener(MouseEvent.ROLL_OVER,onRollOver);
			_drag.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		}
		
		/**
		 * 私聊面板展开状态 true为显示 
		 */
		public function get status():Boolean
		{
			return _status;
		}

		private function addTool():void
		{
			_pubTool = new ToolGroup();
			_pubTool.index = 0;
			//_pubTool.x = _pubView.x + _pubView.width - _pubTool.width + 8;
			_pubTool.visible = false;
			this.addChild(_pubTool);

			_priTool = new PrivateToolGroup();
			_priTool.index = 1;
			//_priTool.x = _priView.x + _priView.width - _priTool.width + 40;
			_priTool.visible = false;
			this.addChild(_priTool);

			updateToolPos();
		}
		
		private function closePriPanel(value:Boolean = true):void
		{
			_status = !value;
			if(value)
			{
				_oldPer = this._pubPer;
				_drag.visible = this._priView.visible = false;
				this._pubView.height = this._pubView.height + this._priView.height - _gap + 20;
				_pubView.update();
			}else{
				_drag.visible = this._priView.visible = true;
				this._pubView.height = this._pubView.height - this._priView.height - _gap - 20;
				this._pubPer = _oldPer;
				this.update();
			}
		}

		private function updateToolPos():void
		{
			if(_priTool)
			{
				_priTool.y = this._drag.y + 6;
			}

			if(_pubTool)
			{
				_pubTool.y = 0;
			}
		}


		private function onDrag(e:MouseEvent):void
		{
			_pubPer = _drag.y / _fixH;
			this._pubView.setSize(this._pubView.width, _fixH * _pubPer - _gap);
			this._priView.setSize(this._priView.width, _fixH * (1 - _pubPer) - _gap - 20);

			this._pubView.update();
			this._priView.update();
			this.updatePos();
			updateToolPos();
			
			var local:Point = this.localToGlobal(new Point(mouseX - _mouseIcon.width*.5,mouseY - _mouseIcon.height*.5))
			_mouseIcon.x = local.x;
			_mouseIcon.y = local.y;			
		}

		private function release(e:MouseEvent):void
		{
			_drag.stopDrag();
			stage.removeEventListener(MouseEvent.MOUSE_UP, release);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onDrag);
			_drag.addEventListener(MouseEvent.ROLL_OVER,onRollOver);
			_draging = false;
			_mouseIcon.visible = false;
			stage.removeChild(_mouseIcon);
			Mouse.show();
		}
		
		
		protected function overHandler(event:MouseEvent):void
		{
			var tar:ChatMsgPanel = event.currentTarget as ChatMsgPanel;
			var tool:ToolGroup;
			if(tar==this._pubView)
			{
				tool = this._pubTool;
			}else{
				tool = this._priTool;
			}
			switch(event.type)
			{
				case MouseEvent.ROLL_OUT:
					tool.hiden();
					break;
				case MouseEvent.ROLL_OVER:
					tool.show();
					break;
			}
			event.stopPropagation();
		}
		
		private function hidenTool(value:DisplayObject):void
		{
			var tool:DisplayObject = value;
			tool.visible = false;
		}

		public function setUp(pubView:ChatMsgPanel, priView:ChatMsgPanel):void
		{
			this._pubView = pubView;
			this._priView = priView;
			
			this._pubView.addEventListener(MouseEvent.ROLL_OVER,overHandler);
			this._pubView.addEventListener(MouseEvent.ROLL_OUT,overHandler);
			this._priView.addEventListener(MouseEvent.ROLL_OVER,overHandler);
			this._priView.addEventListener(MouseEvent.ROLL_OUT,overHandler);

			if(!this.contains(pubView))
			{
				this.addChild(_pubView);
			}

			if(!this.contains(priView))
			{
				this.addChild(_priView);
			}

			_drag.graphics.beginFill(0x780060, 1);
			_drag.graphics.drawRect(-pubView.width * .5, 3, pubView.width, 2);
			_drag.graphics.beginFill(0xff0000,0);
			_drag.graphics.drawRect(-pubView.width * .5, 1, pubView.width, 6);
			_drag.graphics.endFill();

			if(!this.contains(_drag))
			{
				this.addChild(_drag);
			}

			update();
			addTool();		
		}

		override public function set height(value:Number):void
		{
			_fixH = value;
			this._bglayer.graphics.clear();
			this._bglayer.graphics.beginFill(0xff0000, 0);
			this._bglayer.graphics.drawRect(0, 0, 334, _fixH);
			this._bglayer.graphics.endFill();
			update()
		}

		override public function get height():Number
		{
			return _fixH;
		}

		public function update():void
		{
			this._pubView.setSize(this._pubView.width, _fixH * _pubPer - _gap);
			this._priView.setSize(this._priView.width, _fixH * (1 - _pubPer) - _gap - 20);
			this._pubView.update();
			this._priView.update();
			
			if(!_priView.visible)
			{
				closePriPanel();
			}

			updatePos();
			_drag.x = this._pubView.x + (this._pubView.width) * .5
			_drag.y = this._pubView.y + this._pubView.height + _gap;
			_dragRect = new Rectangle(_drag.x, _pubView.y + _minPub, 0, _priView.y + _priView.height - _minPri);

			updateToolPos();
		}

		private function updatePos():void
		{
			var yPos:Number = 0;
			this._pubView.y = yPos;
			yPos = this._pubView.height + _gap;
			this._priView.y = yPos + _gap;
		}
	}
}