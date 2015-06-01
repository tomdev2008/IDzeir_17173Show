package com._17173.flash.show.base.module.centermessage.view
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.util.time.Ticker;
	import com._17173.flash.core.components.common.LinkText;
	import com._17173.flash.show.base.utils.Utils;
	import com.greensock.TweenLite;
	
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import com._17173.flash.show.model.ShowData;

	/**
	 *全局礼物消息展示 
	 * @author zhaoqinghao
	 * 
	 */	
	public class CenterGlobalPane extends Sprite
	{
		private var _showing:Boolean = false;
		private var _currentShow:DisplayObject = null;
		/**
		 *等待时间 
		 */		
		private var _showTime:int = 1000;
		private var _xsTime:int = 550;
		private var _showed:Boolean = false;
		private var _messages:Array = [];
		public function CenterGlobalPane(showTime:int = 1000)
		{
			_showTime = showTime;
			super();
			this.graphics.beginFill(0x18033C,.01);
			this.graphics.drawRect(0 ,0,329,38);
			this.graphics.endFill();
			this.mouseEnabled = false;
		}
		
		public function addMessage(msg:Object):void{
			_messages.push(msg);
			showNext();
		}
		
		private function addLsn():void{
			_currentShow.addEventListener(MouseEvent.ROLL_OVER,onOver);
			_currentShow.addEventListener(MouseEvent.ROLL_OUT,onOut);
		}
		
		private function removeLsn():void{
			_currentShow.removeEventListener(MouseEvent.ROLL_OVER,onOver);
			_currentShow.removeEventListener(MouseEvent.ROLL_OUT,onOut);
		}
		
		protected function onOver(e:MouseEvent):void{
			if(_currentShow){
				var tmp:TextField = (_currentShow as LinkText).labelTf;
				var tfm:TextFormat = tmp.getTextFormat();
				tfm.underline = true;
				tmp.setTextFormat(tfm);
				tmp.defaultTextFormat = tfm;
			}
		}
		
		protected function onOut(e:MouseEvent):void{
			if(_currentShow){
				var tmp:TextField = (_currentShow as LinkText).labelTf;
				var tfm:TextFormat = tmp.getTextFormat();
				tfm.underline = false;
				tmp.setTextFormat(tfm);
				tmp.defaultTextFormat = tfm;
			}
		}
		
		private function showNext():void{
			if(_currentShow == null){
				var roomId:String = (Context.variables["showData"] as ShowData).roomID;
				_currentShow = Utils.getGlobelMsg(_messages.shift(),roomId);
				_currentShow.x = (this.width - _currentShow.width )/2;
				_currentShow.y = (this.height - _currentShow.height )/2 + 1;
				this.addChild(_currentShow);
				_currentShow.alpha = 0;
				addLsn();
				onshow();
			}
		}
		
		private function onshow(data:Object = null):void{
			_showed = false;
			if(_currentShow is InteractiveObject){
				(_currentShow as InteractiveObject).mouseEnabled = true;
			}
			TweenLite.to(_currentShow,_xsTime/1000,{alpha:.9,onComplete:startWait});
		}
		
		private function startWait():void{
			if(_showed){
				if(_messages.length > 0){
					Ticker.tick(_showTime/50,runEff,1,true);
				}else{
					Ticker.tick(_showTime/50,startWait,1,true);
				}
			}else{
				_showed = true;
				Ticker.tick(_showTime,startWait);
			}
		}
		
		private function runEff(data:Object = null):void{
			
			if(_currentShow is InteractiveObject){
				(_currentShow as InteractiveObject).mouseEnabled = false;
			}
			TweenLite.to(_currentShow,_xsTime/1000,{alpha:0,onComplete:onEffEnd});
		}
		
		private function onEffEnd():void{
			removeLsn();
			this.removeChild(_currentShow);
			_currentShow = null;
			showNext();
		}
	}
}