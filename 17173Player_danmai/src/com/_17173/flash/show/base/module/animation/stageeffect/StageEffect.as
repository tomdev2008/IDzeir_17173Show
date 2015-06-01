package com._17173.flash.show.base.module.animation.stageeffect
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.show.base.context.module.BaseModule;
	import com.greensock.TweenMax;
	
	import flash.display.DisplayObject;
	import flash.geom.Point;
	
	public class StageEffect extends BaseModule
	{
		private var _giftVector:Vector.<DisplayObject> = new Vector.<DisplayObject>;
		public function StageEffect()
		{
			super();
			this.graphics.beginFill(0,0);
			this.graphics.drawRect(0,0,550,60);
			this.graphics.endFill();
			
			this.mouseEnabled = false;
			this.mouseChildren = false;
		}
		/**
		 * 显示礼物效果 
		 * @param data
		 * 
		 */		
		private var _giftDisplay:DisplayObject;
		public function showGift(data:Object):void
		{		
			/** 礼物座位坐标 **/
			var point:Point = data.point;
			var giftVector:Vector.<DisplayObject> = data.giftVector as Vector.<DisplayObject>;
					
			for(var i:int=0;i<giftVector.length;i++)
			{
				var x:Number = Math.round(Math.random()*526);
				var y:Number = Math.round(Math.random()*36);			

				var sp:Point = new Point(x,y);
				sp = this.localToGlobal(sp);

				/** 礼物舞台位置  **/
				giftVector[i].x = point.x;
				giftVector[i].y = point.y;
				/** 礼物在舞台最上层经过 **/
				Context.stage.addChild(giftVector[i]);
				
				/** 赛贝尔曲线点 **/
				var bx:int;
				var by:int;
				if(point.x > sp.x)
				{
					bx = Math.round((sp.x + point.x)/2) + Math.round(Math.random()*60);
					by = Math.round((sp.y + point.y)/2) - 50 - Math.round(Math.random()*100);
				}else{
					bx = Math.round((sp.x + point.x)/2) - Math.round(Math.random()*60);
					by = Math.round((sp.y + point.y)/2) - 50 - Math.round(Math.random()*100);
				}
				/** bezierThrough 赛贝尔经过点 **/
				TweenMax.to(giftVector[i],1,{delay:0,bezierThrough:[{x:point.x,y:point.y},{x:bx, y:by},{x:sp.x,y:sp.y}],onStart:starts,onStartParams:[giftVector[i]],onComplete:completes,onCompleteParams:[giftVector[i]]});
				/** 大于200个清楚等待gc回收 **/
				_giftVector.push(giftVector[i]);
				if(_giftVector.length>200)
				{
					var d:DisplayObject = _giftVector.shift();
					if(this.contains(d))
					this.removeChild(d);
				}
			}
		}
		/**
		 * 开始执行 礼物可见 
		 * @param d
		 * 
		 */		
		private function starts(d:DisplayObject):void
		{
			d.visible=true;
		}
		/**
		 * 完成礼物放置到舞台 
		 * @param d
		 * 
		 */		
		private function completes(d:DisplayObject):void
		{
			var sp:Point = new Point(d.x,d.y);
			sp = this.globalToLocal(sp);
			d.x = sp.x;
			d.y = sp.y;
			//trace("sp.x :" + sp.x +"*******"+ "sp.y :" + sp.y);
			this.addChild(d);
			if(sp.x < 0 || sp.y < 0 || sp.x > 550 || sp.y>60)
				d.visible=false;
			else
				d.visible=true;
		}
	}
}