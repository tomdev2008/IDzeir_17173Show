package com._17173.flash.player.ui.stream.extra
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	

	public class StreamCustomExtraBar extends StreamExtraBar
	{
		public function StreamCustomExtraBar()
		{
			super();
		}
		
//		override protected function resetItemVisible():void {
//			return;
//		}
		
		override protected function resizeChildEx():void {
			var child:DisplayObject = null;
			var tmp:Number = 0;
			for (var i:int = 0; i < _left.numChildren; i ++) {
				child = _left.getChildAt(i);
				child.x = tmp;
				//站位组件在获取高度渲染的时候第一次会出现一个错误的值，因此在站位容器内有值的时候，直接取组件本身的高度
				if ((child as Sprite).numChildren > 0) {
					var item2:Sprite = (child as Sprite).getChildAt(0) as Sprite;
					child.y = Math.ceil((_bg.height - item2.height) / 2);
				} else {
					child.y = Math.ceil((_bg.height - child.height) / 2);
				}
				if (child.visible) {
					tmp += child.width + 6;
				}
			}
			tmp = 0;
			
			for (i = 0; i < _right.numChildren; i ++) {
				child = _right.getChildAt(i);
				child.x = tmp;
				child.y =  Math.ceil((_bg.height - child.height) / 2);
				if (child.visible) {
					tmp -= (child.width + 6);
				}
			}
			_right.x = _w - 6;
		}

	}
}