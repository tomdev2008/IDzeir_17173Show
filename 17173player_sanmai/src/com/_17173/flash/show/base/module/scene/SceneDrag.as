package com._17173.flash.show.base.module.scene
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.show.base.context.layer.IUIManager;
	import com._17173.flash.show.model.CEnum;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;

	/**
	 * 场景拖拽.
	 *  
	 * @author shunia-17173
	 */	
	public class SceneDrag
	{
		
		private var _spriteTarget:Sprite = null;
		private var _dragRect:Rectangle = null;
		private var _target:DisplayObject = null;
		/**
		 * 传入需要被拖拽的对象,将自动根据舞台进行拖拽.
		 *  
		 * @param target 需要被拖拽的对象.
		 */		
		public function SceneDrag(target:DisplayObject)
		{
			_target = target;
			//如果是sprite,使用startDrag进行拖拽
			if (target is Sprite) {
				_spriteTarget = target as Sprite;
				//拖拽范围的起始点
//				_dragRect = new Rectangle(_spriteTarget.x / 2, _spriteTarget.y / 2);
//				_dragRect = new Rectangle(_spriteTarget.x, _spriteTarget.y);
				updateDrag();
			}
			
			_target.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		}

		public function updateDrag():void {
			var ui:IUIManager = IUIManager(Context.getContext(CEnum.UI));
			var rect:Rectangle = ui.sceneRect;
			var w:int = rect.width;
			var h:int = rect.height;
			_dragRect = new Rectangle(rect.x, rect.y, 
				Math.ceil(w - _spriteTarget.width), 
				Math.ceil(h - _spriteTarget.height));
//			Debugger.tracer("更新拖拽区域: ", _dragRect);
		}
		
		/**
		 * 鼠标按下启动拖拽,并重新计算当前拖拽的范围.
		 *  
		 * @param event
		 */		
		protected function onMouseDown(event:Event):void {
			//对于文本文字上的操作始终抛弃
			if (event.target is TextField) return;
			
			if(!Context.variables["isDrag"]) return;
				
			
			
			if (_spriteTarget) {
				//拖拽范围
				//其实是(场景高度 / 2 - 舞台高度 / 2) * 2
//				_dragRect.width = 
//					ScenePos.SCENE_WIDTH - Context.stage.stageWidth;
//				_dragRect.height = 
//					ScenePos.SCENE_HEIGHT - Context.stage.stageHeight;
//				_dragRect.width = Context.stage.stageWidth;
//				_dragRect.height = Context.stage.stageHeight;
				_spriteTarget.startDrag(false, _dragRect);
			} else {
				Context.stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			}
			Context.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		/**
		 * 如果使用mouseMove跟随的方式,计算位置偏移量.
		 *  
		 * @param event
		 */		
		protected function onMouseMove(event:Event):void {
			
		}
		
		/**
		 * 鼠标提起停止拖拽.
		 *  
		 * @param event
		 */		
		protected function onMouseUp(event:Event):void {
			Context.stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			if (_spriteTarget) {
				_spriteTarget.stopDrag();
			} else {
				Context.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			}
		}
	}
}