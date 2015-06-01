package com._17173.flash.show.base.module.lobby
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.util.Util;
	import com._17173.flash.core.util.time.Ticker;
	import com._17173.flash.show.base.components.common.BitmapAnim;
	import com._17173.flash.show.base.components.common.data.AnimData;
	import com._17173.flash.show.base.context.resource.IResourceData;
	import com._17173.flash.show.base.context.resource.IResourceManager;
	import com._17173.flash.show.model.CEnum;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	
	public class PreVideoAnimation extends BitmapAnim
	{
		private const WIDTH:Number = 313;
		private const HEIGHT:Number = 177;
		
		private var _roomUrl:String = "";
		
		private var _inited:Boolean = false;
		
		public function PreVideoAnimation()
		{			
			super();
			this.loop = -1;
		}
		
		public function set urls(value:Array):void
		{
			var ires:IResourceManager = (Context.getContext(CEnum.SOURCE) as IResourceManager);
			var bmds:Array = [];
			var total:uint = value.length;
			
			var backcall:Function = function(res:IResourceData):void
			{				
				var index:int = value.indexOf(res.key);
				//trace(res.key);
				if(index!=-1)
				{
					var aniData:LobbyAnimData = new LobbyAnimData();
					var src:BitmapData = (res.newSource as Bitmap).bitmapData;
					var bmd:BitmapData = new BitmapData(WIDTH,HEIGHT);
					var xscale:Number = bmd.width/src.width;
					var yscale:Number = bmd.height/src.height;	
					var matrix:Matrix = new Matrix();
					matrix.scale(xscale,yscale)
					bmd.draw(src,matrix,null,null,null,true);					
					aniData.bd = bmd;
					bmds[index] = (aniData);
					if(!_inited)
					{
						_inited = true;
						dispose();
						data = [aniData.deepCopy()];
					}
					if(--total<=0)
					{
						dispose();
						data = bmds;
					}					
				}				
			}
			
			for(var i:uint = 0 ; i<value.length;i++)
			{
				ires.loadResource(value[i],backcall);
			}			
		}
		
		override public function dispose():void
		{
			for each(var i:LobbyAnimData in this._data)
			{
				i.dispose();
			}
			super.dispose();
		}
	
		public function set roomUrl(value:String):void
		{
			if(!Util.validateStr(value))
			{
				if(this.hasEventListener(MouseEvent.CLICK))
				{
					this.removeEventListener(MouseEvent.CLICK,gotoRoom);
				}
				this.buttonMode = false;
				return;
			}
			this._roomUrl = value;
			this.buttonMode = true;
			this.addEventListener(MouseEvent.CLICK,gotoRoom);
		}
		
		private function gotoRoom(e:MouseEvent):void
		{
			this.stop();
			Util.toUrl(this._roomUrl);			
		}
		
		override public function play():void
		{
			if (_data && this.totalFrame > 1 && !_isPlaying) {
				//如果loop==0则默认播放一次
				this.loop = loop == 0 ? 1 : loop;
				_isPlaying = true;
				Ticker.tick(300, onRender, -1);
			}
		}
		
	}
}