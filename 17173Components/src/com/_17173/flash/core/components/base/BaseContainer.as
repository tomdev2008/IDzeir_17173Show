package com._17173.flash.core.components.base
{


	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 *窗体面板父类 
	 * @author zhaoqinghao
	 * 
	 */	
	public class BaseContainer extends Sprite
	{
		/**
		 *是否已经添加到舞台
		 */		
		protected var _isShow:Boolean = false;
		/**
		 *外部设置宽 
		 */		
		protected var _setWidth:int = 0;
		/**
		 *外部设置高 
		 */		
		protected var _setHeight:int = 0;
		/**
		 *最后赋值宽度 
		 */		
		protected var _lastWidth:int = 0;
		/**
		 *最后赋值高度 
		 */		
		protected var _lastHeight:int = 0;

		
		public function BaseContainer(parent:DisplayObjectContainer=null)
		{
			super();
			onInit();
			initComplete();
			addEventListener(Event.ADDED_TO_STAGE,onAddStage);
			if(parent)
			{
				parent.addChild(this);
			}
		}
		private function onAddStage(e:Event):void{
			_isShow = true;
			//监听 移出舞台
			addEventListener(Event.REMOVED_FROM_STAGE,onRemoveStage);
			//监听舞台resize事件
			stage.addEventListener(Event.RESIZE,baseResize);
			//监听Render
			addEventListener(Event.RENDER,render);
			
			onDrawRect();
			onRender(null);
			baseResize(null);
			onShow();
			update();			
		}
		private function onRemoveStage(e:Event):void{
			_isShow = false;
			onHide();
			//移除监听
			removeEventListener(Event.REMOVED_FROM_STAGE,onRemoveStage);
			removeEventListener(Event.RENDER,render);
			//移除舞台resize事件
			stage.removeEventListener(Event.RESIZE,baseResize);
		}
		/**
		 *重绘 
		 * @param e
		 * 
		 */		
		private function render(e:Event = null):void{
			onRender();
			onContainerRender();
			baseResize(null);
		}
		
		/**
		 *面板重置大小 
		 * @param e
		 * 
		 */		
		private function baseResize(e:Event = null):void{
			resize();
		}
		
		/**
		 *关闭面板 
		 * 
		 */		
		public function hide():void
		{
			if (this.parent && this.parent.contains(this)) {
				this.parent.removeChild(this);
				this.dispatchEvent(new Event(Event.CLOSE));
			}
		}
		/**
		 *获取容器真实高度
		 * @return 
		 * 
		 */		
		public function get baseHeight():Number{
			return super.height;
		}
		/**
		 *获取容器真实宽度 
		 * @return 
		 * 
		 */		
		public function get baseWidth():Number{
			return super.width;
		}

		/**
		 *更新容器方法<br>
		 * 
		 */		
		public function update():void{
			onUpdate();
		}
		
		override public function get width():Number{
			return _setWidth;
		}
		
		override public function set width(value:Number):void{
			_setWidth = value;
			if(stage){
				stage.invalidate();
			}
		}
		
		override public function get height():Number{
			return _setHeight;
		}
		
		override public function set height(value:Number):void{
			_setHeight = value;
			if(stage){
				stage.invalidate();
			}
		}
		/**
		 *初始化容器
		 * 
		 */		
		protected function onInit():void{
			
		}
		/**
		 *初始化容器完毕 （此方法在 onInit方法后执行）
		 * 
		 */		
		protected function initComplete():void{
		}
		/**
		 * 更新容器.调用update方法后执行此方法，此方法用于更新数据业务操作
		 * 
		 */		
		protected function onUpdate():void{
			
		}
		/**
		 *绘制容器宽高（渲染方法调用时执行此方法）
		 * 
		 */		
		protected function onDrawRect():void{
			this.graphics.clear();
			this.graphics.beginFill(0x000000,.01);
			this.graphics.drawRect(0,0,_setWidth,_setHeight);
			this.graphics.endFill();
			_lastWidth = _setWidth;
			_lastHeight = _setHeight;
		}
		
		/**
		 *渲染 设置宽高后自动调用
		 * @param e
		 * 
		 */		
		protected function onRender(e:Event = null):void{
		}
		
		/**
		 *加入舞台 添加到舞台后自动调用
		 * <br>会自动调用更新方法 
		 * 
		 */		
		protected function onShow():void{
		}
		/**
		 *移出舞台 移除舞台后自动调用
		 * 
		 */		
		protected function onHide():void{
			
		}
		
		
		/**
		 *重绘本身大小事件 
		 * 
		 */		
		protected function onContainerRender(e:Event = null):void{
			if(_setHeight !=_lastHeight || _setWidth != _lastWidth){
				onRectChange();
			}
		}
		
		/**
		 *用于配置容器大小是否根据舞台做相应调整。舞台大小改变或手动调用resize方法后自动调用
		 * 
		 */		
		protected function onResize(e:Event=null):void{
			
		}
		
		/**
		 *重新设置容器内子显示对象布局，舞台大小改变或手动调用resize方法后自动调用
		 * 
		 */		
		protected function onRePosition():void{
		}
		/**
		 *面板大小改变 
		 * 
		 */		
		protected function onRectChange():void{
			onDrawRect();
		}
		
		/**
		 *返回容器限制宽度.(默认返回容器当前宽度)
		 * 
		 */		
		public function get limitWidth():int{
			return width;
		}
		
		/**
		 *返回容器限制高度 (默认返回容器当前高度)
		 * 
		 */	
		public function get limitHeight():int{
			return height;
		}

		
		/**
		 *舞台大小改变，调用onResize方法与onRePosition
		 * 
		 */		
		public function resize(e:Event = null):void
		{
			onResize(e);
			onRePosition();
		}

		
		
		/**
		 * 设置组件宽高 
		 * @param w 指定宽
		 * @param h 指定高
		 * 
		 */		
		public function setSize(w:Number,h:Number):void
		{
			this._setWidth=w;
			this._setHeight=h;
			if(stage)
			{
				stage.invalidate();
			}
		}
		
		/**
		 * 移动组件到指定坐标点 
		 * @param xpos 
		 * @param ypos
		 * 
		 */		
		public function move(xpos:Number,ypos:Number):void
		{
			x=xpos;
			y=ypos;
		}

	}
}