package com._17173.flash.show.base.module.task
{
	import com._17173.flash.core.components.common.Button;
	import com._17173.flash.core.components.common.GraphicText;
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.locale.ILocale;
	import com._17173.flash.show.base.context.text.GraphicTextElement;
	import com._17173.flash.show.base.context.text.GraphicTextElementType;
	import com._17173.flash.show.base.context.text.GraphicTextOption;
	import com._17173.flash.show.base.context.text.IGraphicTextManager;
	import com._17173.flash.show.model.CEnum;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class TaskItemRender extends Sprite
	{
		private var _taskLine:TaskLine;
		private var textManager:IGraphicTextManager = Context.getContext(CEnum.GRAPHIC_TEXT) as IGraphicTextManager;
		private var text:GraphicText = null;
		private var button:Button = new Button();
		private var _locale:ILocale = Context.getContext(CEnum.LOCALE) as ILocale;
		public function get buttonType():int
		{
			return _buttonType;
		}

		private var btnClickFun:Function = null;
		private var _buttonType:int = 0;
		private var sprite:Sprite;
		private var _mouseOut:Function = null;
		private var _mouseOver:Function = null;
		
		public function TaskItemRender(mouseOver:Function,mouseOut:Function)
		{
			super();
			_mouseOut = mouseOut;
			_mouseOver = mouseOver;
			_taskLine = new TaskLine();
			_taskLine.x = 3;
			_taskLine.y = 0;
			this.addChild(_taskLine);
			sprite = new Sprite();
			sprite.graphics.beginFill(0xFF0000,0);
			sprite.graphics.drawRect(0,0,365,50);
			sprite.graphics.endFill();
			this.addChild(sprite);
			button = new Button();
			button.x = 262;
			button.y = 13;
			button.width = 86;
			button.height = 28;
			button.addEventListener(MouseEvent.CLICK, buttonClick);
			this.addChild(button);
			
			this.addEventListener(MouseEvent.MOUSE_OVER,mouseOver);
			this.addEventListener(MouseEvent.MOUSE_OUT,mouseOut);
		}
		
		private function mouseOver(e:MouseEvent):void{
			if(_mouseOver == null){
				_mouseOver(e);
			}
		}
		
		private function mouseOut(e:MouseEvent):void{
			if(_mouseOut == null){
				_mouseOut(e);
			}
		}
		
		private function buttonClick(e:MouseEvent):void{
			if(btnClickFun != null){
				btnClickFun(_buttonType);
			}
		}
		
		
		public function update(task:Object, taskInfo:Object, btnClickFun:Function):void{
			_buttonType = task.subTaskId;
			this.btnClickFun = btnClickFun;
			
			if(btnClickFun == null){
				button.mouseEnabled = false;
			}else{
				button.mouseEnabled = true;
			}
			
			var taskState:String = "";
			var stateColor:int = 0xFFFFFF;
			if(task.done == "UNDONE"){
				button.visible = taskInfo.subTaskShowQuickButton == 1;
				stateColor = 0xFF0000;
				taskState = _locale.get("taskState1","task");
				if(button.visible){
					button.label = _locale.get("taskBtnLabel_"+buttonType,"task");
				}
			}else{
				button.visible = true;
				if(task.getAward == "NO"){
					stateColor = 0x01A664;
					taskState = _locale.get("taskState2","task");;
					button.label = _locale.get("taskState3","task");
				}else{
					stateColor = 0x01A664;
					taskState = _locale.get("taskState2","task");;
					button.label = _locale.get("taskState4","task");
				}
			}
			
			var info:GraphicTextElement = textManager.createElement();
			info.content = taskInfo.subTaskDesc +"   ";
			info.color = 0x63acff;
			info.size = 14;
			info.type = GraphicTextElementType.Element_TEXT;
			
			var stateStr:GraphicTextElement = textManager.createElement();
			stateStr.content = taskState;
			stateStr.color = stateColor;
			stateStr.size = 14;
			stateStr.type = GraphicTextElementType.Element_TEXT;
			
			if(text && text.parent){
				text.parent.removeChild(text);
			}
			
			var gto:GraphicTextOption = new GraphicTextOption(true);
			gto.textWidth = 238;
			
			text = textManager.createGraphicText([info,stateStr],gto) as GraphicText;
			text.textWidth = 238;
			text.x = 10;
			text.y = 5;
			sprite.addChild(text);
		}
	}
}