package com._17173.flash.player.ui.stream.rec
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.core.util.Util;
	import com._17173.flash.player.context.ContextEnum;
	import com._17173.flash.player.model.PlayerErrors;
	import com._17173.flash.player.model.PlayerEvents;
	import com._17173.flash.player.ui.comps.grid.Grid;
	
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	/**
	 * 个人前后推基类.只有一个grid控件. 
	 * @author shunia-17173
	 */	
	public class BaseGridStreamRecommand extends Sprite
	{
		
		protected var _tf:TextField = null;
		protected var _grid:Grid = null;
		
		public function BaseGridStreamRecommand()
		{
			super();
			
			var fmt:TextFormat = new TextFormat();
			fmt.font = Util.getDefaultFontNotSysFont();
			fmt.color = 0xFDCD00;
			fmt.size = 22;
			fmt.align = TextFormatAlign.CENTER;
			_tf = new TextField();
			_tf.selectable = false;
			_tf.autoSize = TextFieldAutoSize.LEFT;
			_tf.wordWrap = true;
			_tf.defaultTextFormat = fmt;
			_tf.text = "";
			addChild(_tf);
			
			_grid = new Grid();
			addChild(_grid);
		}
		
		public function set isBack(value:Boolean):void {
			_tf.text = value ? backText : foreText;
			
			resize();
		}
		
		public function startReq():void {
//			Global.dataRetriver.reqForMore(Context.variables["roomID"], onRecIncome);
			Context.getContext(ContextEnum.DATA_RETRIVER).reqForMore(Context.variables["roomID"], onRecIncome);
		}
		
		protected function onRecIncome(data:Object):void {
			onRecResult(data.obj);
		}
		
		protected function onRecResult(data:Array):void {
			var result:Array = data;
			_grid.data = result;
			resize();
		}
		
		protected function onRecFault(data:Object):void {
//			Global.eventManager.send(
			(Context.getContext(ContextEnum.EVENT_MANAGER) as IEventManager).send(
				PlayerEvents.ON_PLAYER_ERROR, 
				PlayerErrors.packUpError(PlayerErrors.VIDEO_RECOMMAND_DATA_CORRUPTED));
		}
		
		protected function get foreText():String {
			return "";
		}
		
		protected function get backText():String {
			return "";
		}
		
		public function resize():void {
			_grid.resize(avalibleWidth, avalibleHeight);
			
			_tf.width = avalibleWidth;
			_tf.x = (avalibleWidth - _tf.width) / 2;
			_tf.y = 10;
		}
		
		protected function get avalibleWidth():Number {
//			return Global.uiManager.avalibleVideoWidth;
			return Context.getContext(ContextEnum.UI_MANAGER).avalibleVideoWidth;
		}
		
		protected function get avalibleHeight():Number {
//			return Global.uiManager.avalibleVideoHeight;
			return Context.getContext(ContextEnum.UI_MANAGER).avalibleVideoHeight;
		}
		
	}
}