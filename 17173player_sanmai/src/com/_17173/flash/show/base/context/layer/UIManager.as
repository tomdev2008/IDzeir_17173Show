package com._17173.flash.show.base.context.layer
{
	import com._17173.flash.core.components.common.Alert;
	import com._17173.flash.core.components.layer.PopUpLayer;
	import com._17173.flash.core.components.layer.ToolTipLayer;
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.context.IContextItem;
	import com._17173.flash.core.plugin.IPluginManager;
	import com._17173.flash.show.model.CEnum;
	import com._17173.flash.show.model.PEnum;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 *层级管理器,startup时需要传入主容器 
	 * @author zhaoqinghao
	 * 
	 */	
	public class UIManager implements IContextItem, IUIManager
	{
		
		private static const TOP_BAR_HEIGHT:int = 41;
		private static const BOTTOM_BAR_HEIGHT:int = 44;
			
		private var _scene:Sprite = null;
		private var _popupLayer:PopUpLayer= null;
		private var _toolTipLayer:ToolTipLayer = null;
		private var _parentDisplayObject:DisplayObjectContainer = null;
		private var _sceneRect:Rectangle = new Rectangle();
		//引导层
		private var _guideLayer:Sprite = null;
		
		/**
		 * 舞台点击事件的缓存列表 
		 */		
		private var _actions:Array = new Array();
		
		public function UIManager()
		{
			_guideLayer=  new Sprite();
			_guideLayer.mouseEnabled = false;
			//popup层
			_popupLayer = new PopUpLayer(Context.stage);
			_popupLayer.mouseEnabled = false;
			//tooltip层
			_toolTipLayer = new ToolTipLayer(Context.stage);	
			_toolTipLayer.mouseChildren = false;
			_toolTipLayer.mouseEnabled = false;
		}
		
		private function onStageResize(e:Event):void{
			
		}
		
		public function get contextName():String
		{
			return CEnum.UI;
		}
		
		public function startUp(param:Object):void
		{
			Context.stage.addEventListener(MouseEvent.CLICK,function(event:MouseEvent):void
			{
				_actions.forEach(function(e:*,index:int,arr:Array):void
				{
					var backCall:Function=e;					
					backCall.apply(null,[event]);					
				});
			});
			_parentDisplayObject = param as DisplayObjectContainer;
			_parentDisplayObject.addChild(_guideLayer);
			_parentDisplayObject.addChild(_popupLayer);
			_parentDisplayObject.addChild(_toolTipLayer);
		}
		
		public function initializeScene(scens:DisplayObject):void{
			if(scens is Sprite){
				_scene = scens as Sprite;
				_parentDisplayObject.addChildAt(_scene,0);
			}
		}
		
		public function addAction(handler:Function):void
		{
			this._actions.push(handler);
		}
		
		public function removeAction(handler:Function):void
		{
			do{
				var index:int=this._actions.indexOf(handler);
				if(index!=-1)
				{
					this._actions.splice(index,1);
				}
			}while(this._actions.length>0&&this._actions.indexOf(handler)!=-1)
			
		}
		
		/**
		 *弹出面板 
		 * @param panel
		 * @param panelPos
		 * 
		 */		
		public function popupPanel(panel:DisplayObject,panelPos:Point = null):void{
			_popupLayer.popupPanel(panel,0,panelPos);
		}
		
		public function popupAlert(title:String,showHtmlText:String,iconType:int = -1,btnType:int = -1,okCallFunction:Function = null,cancelCallFunction:Function = null,okLabel:String = null,cancelLabel:String = null):void{
 			var _alert:Alert = new Alert(title, showHtmlText, iconType, btnType, okCallFunction, cancelCallFunction, okLabel, cancelLabel);
			_popupLayer.popupPanel(_alert,1);
		}
		
		public function popupAlertPanel(panel:DisplayObject):void{
			_popupLayer.popupPanel(panel,1);
		}
		/**
		 *移除面板 
		 * @param panel
		 * 
		 */		
		public function removePanel(panel:DisplayObject):void{
			_popupLayer.removePanel(panel);
		}
		
		/**
		 *删除所有面板 
		 * 
		 */		
		public function removeAll():void{
			_popupLayer.removeAll();
		}
		
		/**
		 *注册普通ToolTip
		 * @param dsObj 注册的显示对象
		 * @param htmlText 需要提示的信息
		 * 
		 */		
		public function registerTip(dsObj:DisplayObject,htmlText:String):void{
			_toolTipLayer.registerTip(dsObj,htmlText)
		}
		/**
		 *注册高级ToolTip 
		 * @param dsObj 注册的显示对象
		 * @param showDsObj 高级提示
		 * 
		 */		
		public function registerTip1(dsObj:DisplayObject,showDsObj:DisplayObject):void{
			_toolTipLayer.registerTip1(dsObj,showDsObj);
		}
		/**
		 *注销ToolTip （注销时，如正在显示注销对象的Tooltip则会一起移除）
		 * @param dsObj 需要注销的显示对象
		 * 
		 */	
		public function destroyTip(dsObj:DisplayObject):void{
			_toolTipLayer.destroyTip(dsObj);
		}
		
		public function get sceneRect():Rectangle {
			var sceneWidth:int = Context.stage.stageWidth;
			var sceneHeight:int = Context.stage.stageHeight;
			var sceneX:int = 0;
			var sceneY:int = 0;
			
			var p:IPluginManager = IPluginManager(Context.getContext(CEnum.PLUGIN));
			if (p.hasPlugin(PEnum.TOPBAR)) {
				sceneHeight -= TOP_BAR_HEIGHT;
				sceneY = TOP_BAR_HEIGHT;
			}
			if (p.hasPlugin(PEnum.BOTTOMBAR)) {
				sceneHeight -= BOTTOM_BAR_HEIGHT;
			}
			
			if (sceneWidth < 0) sceneWidth = 0;
			if (sceneHeight < 0) sceneHeight = 0;
			
			_sceneRect.x = sceneX;
			_sceneRect.y = sceneY;
			_sceneRect.width = sceneWidth;
			_sceneRect.height = sceneHeight;
			
			return _sceneRect;
		}
		
		public function addGuide(guide:DisplayObject):void
		{
			// TODO Auto Generated method stub
			if(guide && !guide.parent){
				_guideLayer.addChild(guide);
			}
		}
		
		public function removeGuide(guide:DisplayObject):void
		{
			// TODO Auto Generated method stub
			if(guide && _guideLayer.contains(guide)){
				_guideLayer.removeChild(guide);
			}
		}
		
	}
}