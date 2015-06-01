package com._17173.flash.show.base.module.animation.duang
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.util.time.Ticker;
	import com._17173.flash.show.base.context.module.BaseModule;
	import com._17173.flash.show.base.context.resource.IResourceData;
	import com._17173.flash.show.base.context.resource.IResourceManager;
	import com._17173.flash.show.model.CEnum;
	
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	
	public class Duang extends BaseModule
	{
		private var _giftVector:Vector.<MovieClip>;
		private var _queueArray:Array;
		private var _isPlaying:Boolean;
		private var _continer:Sprite;
		public function Duang()
		{
			super();
			this.graphics.beginFill(0,0);
			this.graphics.drawRect(0,0,585,100);
			this.graphics.endFill();
			
			_queueArray = new Array();
			_continer = new Sprite();
			this.addChild(_continer);
			var shap:Shape = new Shape();
			shap.graphics.beginFill(0);
			shap.graphics.drawRect(0,0,585,100);
			shap.graphics.endFill();
			this.addChild(shap);
			_continer.mask = shap;
			this.mouseChildren=false;
			this.mouseEnabled=false;
		}
		/**
		 * 设置数据
		 * 进入队列 
		 * @param data
		 * 
		 */		
		public function showGift(data:Object):void
		{
			_queueArray.push(data.data);
			if(_giftVector == null)
			{
				_giftVector = new Vector.<MovieClip>;
				initMesstByGift(data.data);
			}else{
				play();
			}
		
		}
		/**
		 * 开始播放 
		 * 
		 */		
		private function play():void{
			if(_isPlaying)return;
			_isPlaying = true;
			
			var data:Object = _queueArray.shift();
			var giftCount:int = int(data.giftCount);
			var giftDisplay:MovieClip;
			if(giftCount>9)
				giftCount = 9;
			var vx:Number = 0;
			for(var i:int=0;i<giftCount;i++){
				giftDisplay = _giftVector[i];
				_continer.addChild(giftDisplay);
				giftDisplay.x = vx;
				giftDisplay.gotoAndStop(1);
				giftDisplay.play();
				vx += 60;
			}
//			_continer.width = vx;
			_continer.x = (585 - _continer.width)/2;
			Ticker.tick(2500,reset);
		}
		/**
		 * 重置数据 
		 * 并检查是否队列中仍有数据执行
		 */		
		private function reset():void
		{
			while(_continer.numChildren>0)
			{
				_continer.removeChildAt(0);
			}
			_isPlaying = false;
            if(_queueArray.length>0)this.play();
		}
		/**
		 * 初始化动画原件 
		 * @param data
		 * @return 
		 * 
		 */		
		private function initMesstByGift(data:Object):void
		{
			var giftDisplay:MovieClip;
			var giftId:String = data.giftId;
			var giftName:String = data.giftName;
			var giftCount:int = int(data.giftCount);
			var giftPicPath:String = data.giftSwfPath;
			var giftKey:String = data.giftKey;
			(Context.getContext(CEnum.SOURCE) as IResourceManager).loadResource(giftPicPath, function(value:IResourceData):void
			{
				var mc:MovieClip = value.newSource as MovieClip;
				var loader:Loader = mc.parent as Loader;
				if(loader.contentLoaderInfo.applicationDomain.hasDefinition(giftKey)){
					var cla:Class = loader.contentLoaderInfo.applicationDomain.getDefinition(giftKey)  as Class;
					
					var i:int;
					for(i = 0; i<9;i++)
					{
						giftDisplay = new cla();
						giftDisplay.stop();
						_giftVector.push(giftDisplay);
					}
					
					play();
				}
				
			});	
		}
	}
}