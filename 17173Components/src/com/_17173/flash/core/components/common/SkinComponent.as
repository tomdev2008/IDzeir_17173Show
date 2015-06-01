package com._17173.flash.core.components.common
{
	import com._17173.flash.core.components.base.BaseContainer;
	import com._17173.flash.core.components.interfaces.ISkinClass;
	import com._17173.flash.core.components.interfaces.ISkinComponent;
	import com._17173.flash.core.components.skin.skinclass.BaseSkinClass;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import com._17173.flash.core.components.skin.SkinType;

	public class SkinComponent extends BaseContainer implements ISkinComponent
	{

		protected var skinLayer:Sprite = null;
		protected var _skinVo:ISkinClass = null;
		protected var _skinState:String = "";
		protected var useSkinSize:Boolean = false;
		public function SkinComponent(parent:DisplayObjectContainer=null)
		{
			//初始化ui所属type必须放在super之前
			initSkinLayer();
			initSkinVo();
			super(parent);
		}

		public function addSkinUI(disp:DisplayObject,index:int = -1):void
		{
			// TODO Auto Generated method stub
			if(disp == null) return;
			if(index <= -1){
				skinLayer.addChild(disp);
			}else{
				index = Math.min(index,skinLayer.numChildren);
				skinLayer.addChildAt(disp,index);
			}
		}
		
		public function removeSkinUi(disp:DisplayObject):void
		{
			// TODO Auto Generated method stub
			if(skinLayer && skinLayer.contains(disp)){
				skinLayer.removeChild(disp);
			}
		}
		

		private function initSkinLayer():void
		{
			skinLayer = new Sprite();
			skinLayer.mouseEnabled = false;
			this.addChildAt(skinLayer, 0);
		}

		override protected function onRectChange():void
		{
			super.onRectChange();
			skinVo.updateSkinState(_skinState);
			skinVo.resize()
		}
		
		override protected function onResize(e:Event=null):void{
			super.onResize(e);
			skinVo.resize();
		}
		
		override protected function onRender(e:Event=null):void{
			super.onRender(e);
			skinVo.resize();
		}
		
		override protected function onRePosition():void{
			super.onRePosition();
			skinVo.rePostion();
		}
		
		override protected function onShow():void{
			skinVo.onShow();
		}
		
		override protected function onHide():void{
			skinVo.onHide();
		}

		/**
		 *初始化SkinVo 
		 * 
		 */		
		protected function initSkinVo():void{
			_skinVo = new BaseSkinClass(SkinType.SKIN_TYPE_BASE,this);
		}
		
		public function getCompRect():Rectangle
		{
			var rect:Rectangle;
			// TODO Auto Generated method stub
			if(!useSkinSize){
				rect = new Rectangle(x,y,_setWidth,_setHeight);
			}else{
				rect = new Rectangle(0,0,0,0);
			}
			return rect;
		}
		
		
		public function get skinVo():ISkinClass
		{
			// TODO Auto Generated method stub
			return _skinVo;
		}
		
		public function destroySkin():void{
			_skinVo.destroySkin();
		}
		
		public function changeRect(tw:int, th:int):void
		{
			// TODO Auto Generated method stub
			this.width = tw;
			this.height = th;
			useSkinSize = true;
		}
		
		override public function set width(value:Number):void{
			super.width = value;
			useSkinSize = false;
		}
		
		override public function set height(value:Number):void{
			super.height = value;
			useSkinSize = false;
		}
		
		/**
		 *更新背景 
		 * 
		 */		
		public function setSkin_Bg(source:DisplayObject):void{
			skinVo.skin = {"bg":source};
		}
	}
}
