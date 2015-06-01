package com._17173.flash.player.module.quiz.ui
{
	import com._17173.flash.core.components.base.BasePanel;
	import com._17173.flash.core.components.common.Label;
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.core.util.Util;
	import com._17173.flash.player.context.ContextEnum;
	import com._17173.flash.player.module.quiz.QuizEvents;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FullScreenEvent;
	import flash.events.MouseEvent;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	
	/**
	 * 竞猜使用的panel基类
	 */	
	public class QuizBasePanel extends BasePanel
	{
		protected var _w:Number = 430;
		protected var _h:Number = 260;
		protected var _tf:TextFormat;
		protected var _inpt_tf:TextFormat;
		protected var _container:Sprite;
		
		public function QuizBasePanel()
		{
			super();
			init();
			addListener();
			initContainer();
			this.setSkin_Bg(new quizPanelBG());
			this.setSkin_Close(new quizCloseBtn());
			this.skinVo.updateSkinState("hideLine");
		}
		
		protected function init():void {
			this.width = _w;
			this.height = _h;
		}
		
		protected function addListener():void {
			addEventListener(Event.ADDED_TO_STAGE, addToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStage);
			Context.stage.addEventListener(FullScreenEvent.FULL_SCREEN, onFullScreen);
		}
		
		/**
		 * 全屏的时候如果窗口在显示，那么改变自己的坐标
		 */		
		protected function onFullScreen(event:FullScreenEvent):void
		{
			this.x = (Context.stage.stageWidth - _w) / 2;
			this.y = (Context.stage.stageHeight - _h) / 2;
		}
		
		protected function addToStage(evt:Event):void {
			(Context.getContext(ContextEnum.EVENT_MANAGER) as IEventManager).send(QuizEvents.QUZI_PANEL_VISIBLE_CHANGE, "show");
		}
		
		protected function removedFromStage(evt:Event):void {
			(Context.getContext(ContextEnum.EVENT_MANAGER) as IEventManager).send(QuizEvents.QUZI_PANEL_VISIBLE_CHANGE, "hide");
		}
		
		override public function set titleStr(value:String):void {
			super.title.width = 300;
			super.titleStr = "<FONT size='16' color='#888888' face='" + Util.getDefaultFontNotSysFont() + "'>" + value + "</FONT>";
		}
		
		override protected function onRePostionTitle():void {
			this.title.x = 5;
			this.title.y = 3;
		}
		
		override public function onCloseClick(e:MouseEvent):void {
			closeThis();
		}
		
		protected function closeThis():void {
			Context.getContext(ContextEnum.UI_MANAGER).closePopup(this);
		}
		
		protected function initContainer():void {
			initTextFormat();
			drawContainer();
			drawOther();
		}
		
		protected function drawContainer():void {
			_container = new Sprite();
			_container.graphics.clear();
			_container.graphics.beginFill(0, 0);
			_container.graphics.drawRect(0, 0, _w, _h - 30);
			_container.graphics.endFill();
			_container.y = 30;
			
			this.content = _container;
		}
		
		protected function drawOther():void {
			
		}
		
		protected function initTextFormat():void {
			_tf = new TextFormat();
			_tf.size = 14;
			_tf.color = 0x888888;
			_tf.font = Util.getDefaultFontNotSysFont();
			
			_inpt_tf = new TextFormat();
			_inpt_tf.size = 17;
			_inpt_tf.color = 0x888888;
			_inpt_tf.font = Util.getDefaultFontNotSysFont();
		}
		
		/**
		 * 格式化label
		 */		
		public function setLabelFormat(value:Label, isInput:Boolean = false):void {
			var tempTF:TextFormat;
			if (isInput) {
				value.selectable = true;
				value.type = TextFieldType.INPUT;
				tempTF = _inpt_tf;
			} else {
				value.selectable = false;
				value.autoSize = TextFieldAutoSize.LEFT;
				tempTF = _tf;
			}
			value.defaultTextFormat = tempTF;
			value.setTextFormat(tempTF);
		}

		public function get w():Number
		{
			return _w;
		}

		public function set w(value:Number):void
		{
			_w = value;
		}

		public function get h():Number
		{
			return _h;
		}

		public function set h(value:Number):void
		{
			_h = value;
		}


	}
}