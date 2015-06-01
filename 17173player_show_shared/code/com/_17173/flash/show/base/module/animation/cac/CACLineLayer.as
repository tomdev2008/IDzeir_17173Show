package com._17173.flash.show.base.module.animation.cac
{
	import com._17173.flash.show.base.components.common.HMovePane;
	import com._17173.flash.show.base.components.event.MoveEvent;
	import com._17173.flash.show.base.module.animation.base.AnimationObject;
	import com._17173.flash.show.base.module.animation.base.BaseAnimationLayer;
	import com._17173.flash.show.base.module.animation.extAnimation.CACBarAnimation;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	public class CACLineLayer extends BaseAnimationLayer
	{
		
		private var _msgs:Array = null;
		private var _plays:Array = null;
		private var _lines:Array = null;
		public function CACLineLayer()
		{
			super();
			_msgs = [];
			_plays = [];
			init();
		}
		
		override public function addAnimation(aData:AnimationObject):void
		{
		}
		
		override public function removeAnimation(adata:AnimationObject):void
		{
		}
		
		
		private function init():void{
			_lines = new Array();
			var count:int = CACConfig.getInstans().showLine;
			var lHeight:int = CACConfig.getInstans().lineHeight;
			for (var i:int = 0; i < count; i++) 
			{
				var hv:CACMovePane = new CACMovePane(1920,lHeight,5,100);
				hv.mouseChildren = false;
				hv.mouseEnabled = false;
				hv.y = lHeight * i;
				hv.addEventListener(MoveEvent.PLAY_NEXT,onNext);
				hv.addEventListener(MoveEvent.ITEM_MOVE_END,onPlayEnd);
				this.addChild(hv);
				_lines.push(hv);
				hv.start();
			}
		}
		
		private function onNext(e:Event = null):void{
			if(_msgs && _msgs.length){
				checkEndLoad();
			}
		}
		
		public function addMsg(obj:AnimationObject):void{
			_msgs[_msgs.length] = obj;
			checkEndLoad();
		}
		/**
		 *检查是是否可以放下一个 
		 * 
		 */		
		private function checkEndLoad():void{
			var len:int = _lines.length;
			var hv:HMovePane;
			for (var i:int = 0; i < len; i++) 
			{
				hv = _lines[i];
				if(hv.canPlayNext){
					//先加载
					loadNext();
				}
			}
			
		}
		
		private function loadNext():void{
			var len:int = _msgs.length;
			var anm:AnimationObject;
			for (var i:int = 0; i < len; i++) 
			{
				anm = _msgs[i];
				if(anm && anm.loading == false && anm.loaded == false){
					anm.loadAnimation(onLoad);
					break;
				}else if(anm && anm.loading == false && anm.loaded){
					onLoad();
				}
			}
		}
		
		/**
		 * @param data
		 * @return 
		 * 
		 */		
		private function onLoad():void{
			var len:int = _lines.length;
			var hv:HMovePane;
			for (var i:int = 0; i < len; i++) 
			{
				hv = _lines[i];
				if(hv.canPlayNext){
					var len1:int = _msgs.length;
					var tanm:AnimationObject;
					for (var j:int = 0; j < len1; j++) 
					{
						var anm:AnimationObject = _msgs[j];
						if(anm.loaded){
							tanm = anm;
							_msgs.splice(j,1);
							break;
						}
					}
					if(tanm){
						var bmp:Bitmap = (tanm as CACBarAnimation).getBmp();
						hv.playItem(bmp);
//						hv.playItem(tanm.mc);
						_plays[_plays.length] = tanm;
						break;
					}
				}
			}
		}
		
		private function onPlayEnd(e:MoveEvent):void{
			var obj:DisplayObject = e.data as DisplayObject;
			var len:int = _plays.length;
			for (var i:int = 0; i < len; i++) 
			{
				var anm:AnimationObject = _plays[i];
				if((anm as CACBarAnimation).bmp === obj){
//				if((anm as CACBarAnimation).mc === obj){
					anm.returnObj();
					_plays.splice(i,1);
					break;
				}
			}
		}
		
		public function stop():void{
			_msgs = [];
			var len:int = _lines.length;
			var hv:HMovePane;
			for (var i:int = 0; i < len; i++) 
			{
				hv = _lines[i];		
				hv.clean();
			}
		}
		
		public function start():void{
			var len:int = _lines.length;
			var hv:HMovePane;
			for (var i:int = 0; i < len; i++) 
			{
				hv = _lines[i];		
				hv.start();
			}
		}
	}
}