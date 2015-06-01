package  com._17173.flash.core.components.layer
{
	import com._17173.flash.core.components.base.BasePanel;
	import com._17173.flash.core.components.common.ToolTip;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;

	/**
	 * tooltip管理 
	 * @author zhaoqinghao
	 */
	public class ToolTipLayer extends Sprite implements IToolTip
	{
		/**
		 *自定义ToolTip 
		 */		
		private var _toolTipDisplayObject:DisplayObject = null;
		/**
		 *显示tip 
		 */		
		private var _zToolTip:ToolTip = null;
		/**
		 *当前显示 
		 */		
		private var currentObj:*;
		/**
		 *当前显示的tip对象 
		 */		
		private var currentShow:*;
		private var _stage:Stage = null;
		/**
		 *存放所有需要显示对象 
		 */		
		private  var _showDict:Dictionary = new Dictionary(true);
		public function ToolTipLayer(stage:Stage)
		{
			_stage = stage;
			this.mouseEnabled = false;
			this.mouseChildren = false;
		}
		
		public function setTipPanel(tipPanel:ToolTip):void{
			_zToolTip = tipPanel
		}
		
		public function initStage(stage:Stage):void
		{
			// TODO Auto Generated method stub
			_stage = stage;
		}
		/**
		 *注册普通ToolTip
		 * @param dsObj 注册的显示对象
		 * @param htmlText 需要提示的信息
		 * 
		 */		
		public function registerTip(dsObj:DisplayObject,htmlText:String):void{
			if(dsObj == null || htmlText == null) return;
			if(_zToolTip == null){
				_zToolTip = new ToolTip();
			}
			if(_showDict[dsObj] == null){
				_showDict[dsObj] = htmlText;
				dsObj.addEventListener(MouseEvent.ROLL_OVER,onMouseOver);
			}else{
				_showDict[dsObj] = htmlText;
			}
			checkTip(dsObj);
		}
		
		
		public function checkTip(objs:DisplayObject):void{
			if(currentShow && currentShow === objs){
				var obj:* = _showDict[objs];
				showTip(obj);
			}
		}
		
		/**
		 *注册高级ToolTip 
		 * @param dsObj 注册的显示对象
		 * @param showDsObj 高级提示
		 * 
		 */		
		public function registerTip1(dsObj:DisplayObject,showDsObj:DisplayObject):void{
			if(dsObj == null || dsObj == null) return;
			_showDict[dsObj] = showDsObj;
			dsObj.addEventListener(MouseEvent.ROLL_OVER,onMouseOver);
		}
		
		/**
		 *注销ToolTip （注销时，如正在显示注销对象的Tooltip则会一起移除）
		 * @param dsObj 需要注销的显示对象
		 * 
		 */		
		public function destroyTip(dsObj:DisplayObject):void{
			var obj:* = _showDict[dsObj];
			if(obj != null){
				dsObj.removeEventListener(MouseEvent.ROLL_OVER,onMouseOver);
				if(dsObj.hasEventListener(MouseEvent.ROLL_OUT)){
					dsObj.removeEventListener(MouseEvent.ROLL_OUT,onMouseOut);
				}
				if(dsObj.hasEventListener(MouseEvent.MOUSE_MOVE)){
					dsObj.removeEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
				}
				if(currentObj === obj &&　this.contains(_toolTipDisplayObject)){
					if(_toolTipDisplayObject){
						this.removeChild(_toolTipDisplayObject);
						currentObj = null;
						currentShow = null;
					}
				}
				delete _showDict[dsObj];
			}
		}
		
		private function onMouseOver(e:MouseEvent):void{
			var ds:DisplayObject = e.currentTarget as DisplayObject;
			ds.addEventListener(MouseEvent.ROLL_OUT,onMouseOut);
			ds.addEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
		}
		
		
		private function onMouseOut(e:MouseEvent):void{
			var ds:DisplayObject = e.currentTarget as DisplayObject;
			ds.removeEventListener(MouseEvent.ROLL_OUT,onMouseOut);
			ds.removeEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
			if(_toolTipDisplayObject){
				this.removeChild(_toolTipDisplayObject);
				_toolTipDisplayObject = null;
				currentObj = null;
				currentShow = null;
			}
		}
		
		private  function onMouseMove(e:MouseEvent):void{
			var ds:DisplayObject = e.currentTarget as DisplayObject;
			currentShow = ds;
			var obj:* = _showDict[ds];
			if(obj){
				showTip(obj);
			}
		}
		/**
		 *显示 
		 * @param obj
		 * 
		 */		
		private function showTip($obj:*):void{
			var obj:* = $obj;
			if(_toolTipDisplayObject && this.contains(_toolTipDisplayObject)){
				this.removeChild(_toolTipDisplayObject);
				_toolTipDisplayObject = null;
				currentObj = null;
			}
			//字符串
			if($obj is String){
				_zToolTip.setTip($obj);
				_toolTipDisplayObject = _zToolTip;
			}
			//显示对象
			else if($obj is DisplayObject){
				_toolTipDisplayObject =  $obj as DisplayObject;
			}
			if(_toolTipDisplayObject == null) return;
			currentObj = $obj;
			
			if(this.mouseX + _toolTipDisplayObject.width > _stage.stageWidth){
				_toolTipDisplayObject.x = int(this.mouseX - _toolTipDisplayObject.width)  ;
			}else{
				_toolTipDisplayObject.x = int(this.mouseX + 12);
			}
			
			if(this.mouseY + _toolTipDisplayObject.height > _stage.stageHeight){
				_toolTipDisplayObject.y = int(this.mouseY - _toolTipDisplayObject.height) ;
			}else{
				_toolTipDisplayObject.y = int(this.mouseY + 12);
			}
			
			this.addChild(_toolTipDisplayObject);
			
		}
		
	}
}