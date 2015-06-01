package com._17173.flash.show.base.components.layer
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.components.base.BasePanel;
	
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.utils.Dictionary;

	/**
	 *popup弹窗 
	 * @author zhaoqinghao
	 * 
	 */	
	public class PopUpLayer extends Sprite implements IPopup
	{
		private var _alertLayer:Sprite = null;
		private var _panelLayer:Sprite = null;
		/**
		 *所有显示窗体 
		 */		
		private var _panels:Array = null;
		/**
		 *alert蒙版 
		 */		
		private var _alertMb:Sprite = null;
		private var _panelPots:Dictionary = null;
		public function PopUpLayer()
		{
			super();
			this.mouseEnabled = false;
			onInit();
			this.addEventListener(Event.ADDED_TO_STAGE,onAddToStage);
		}
		
		/**
		 *alert层 
		 */
		public function get alertLayer():Sprite
		{
			return _alertLayer;
		}

		/**
		 *panel层 
		 */
		public function get panelLayer():Sprite
		{
			return _panelLayer;
		}

		private function onAddToStage(e:Event):void{
			stage.addEventListener(Event.RESIZE,onResize);
			stage.addEventListener(Event.REMOVED_FROM_STAGE,onRemoveToStage);
		}
		
		private function onRemoveToStage(e:Event):void{
			stage.removeEventListener(Event.RESIZE,onResize);
			stage.removeEventListener(Event.REMOVED_FROM_STAGE,onRemoveToStage);
			removeAll();
		}
		
		protected function onInit():void{
			initAlertMb();
			_panels = new Array();
			_panelPots = new Dictionary();
			_alertLayer = new Sprite();
			_panelLayer = new Sprite();
			this.addChild(_panelLayer);
			this.addChild(_alertMb);
			this.addChild(_alertLayer);
		}
		
		/**
		 *resize 
		 * @param e
		 * 
		 */		
		protected function onResize(e:Event=null):void{
			var pot:Point;
			for (var panel:* in _panelPots) {
				pot = _panelPots[panel] ;
				setPost(panel,pot);
			}
		}
		
		/**
		 * 设置面板位置
		 * @param panel 面板
		 * @param pot 位置 空则居中
		 * 
		 */
		private function setPost(panel:DisplayObject,pot:Point):void{
			if(pot){
				panel.x = pot.x;
				panel.y = pot.y;
			}else{
				panel.x = (Context.stage.stageWidth - panel.width)/2;
				panel.y = (Context.stage.stageHeight - panel.height)/2;
			}
		}
		
		
		/**
		 *打开面板 
		 * @param panel
		 * @param popupLeve 显示层级 Alert为1 其他窗体为0
		 * @param panelPos 窗体显示位置null为居中
		 */		
		public function popupPanel(panel:DisplayObject,popupLeve:int = 0,panelPos:Point = null):void{
			if(Context.stage){
				Context.stage.focus = null;
			}
			if(_panels.indexOf(panel) < 0){
				_panels.push(panel);
				_panelPots[panel] = panelPos;
				//设置位置
				setPost(panel,panelPos);
				if(popupLeve == 0){
					_panelLayer.addChild(panel);
				}else{
					_alertLayer.addChild(panel);
				}
				panel.addEventListener(Event.CLOSE,onCloseEvent);
			}else{
				//设置位置
				setPost(panel,panelPos);
				//放置最上层
				if(popupLeve == 0){
					_panelLayer.setChildIndex(panel,_panelLayer.numChildren-1);
				}else{
					_alertLayer.setChildIndex(panel,_alertLayer.numChildren-1);
				}
			}
			changeMb();
		}
		
		/**
		 *检测面板是否已经存在 
		 * @param panel
		 * 
		 */		
		public function hasPanel(panel:DisplayObject):Boolean{
			var resutl:Boolean = false;
			if(panel != null){
				resutl = _panels.indexOf(panel) >= 0?true:false;
			}
			return resutl;
		}
		
		/**
		 *删除面板 
		 * @param $panel
		 * 
		 */		
		public function removePanel(panel:DisplayObject):void{
			if(_panels.indexOf(panel) >= 0){
				delete _panelPots[panel];
				_panels.splice(_panels.indexOf(panel), 1);
				if(panel.parent){
					panel.parent.removeChild(panel);
				}
			}
			changeMb();
		}
		
		/**
		 *移出所有面板 
		 * 
		 */		
		public function removeAll():void{
			for each (var panel:DisplayObject in _panels) {
				removePanel(panel);
			}
		}
		
		/**
		 * 关闭面板
		 * @param e
		 * 
		 */		
		private function onCloseEvent(e:Event):void{
			var current:BasePanel = e.currentTarget as BasePanel;
			removePanel(current);
		}
		
		/**
		 *蒙版 
		 * 
		 */		
		private function initAlertMb():void{
			_alertMb = new Sprite();
			_alertMb.graphics.beginFill(0x11111,.4);
			_alertMb.graphics.drawRect(0,0,1920,1000);
			_alertMb.graphics.endFill();
			_alertMb.visible = false;
		}
		/**
		 *显示蒙版 
		 * 
		 */		
		private function changeMb():void{
			if(_alertLayer.numChildren > 0){
				_alertMb.visible = true;
			}else{
				_alertMb.visible = false;
			}
		}
		
	}
}