package com._17173.flash.show.base.module.flyscreen
{
	import com._17173.flash.core.util.time.Ticker;
	import com._17173.flash.show.base.context.module.BaseModule;
	import com._17173.flash.show.base.module.flyscreen.item.FlyItem;
	import com._17173.framework.core.objpool.GenericObjectPool;
	
	public class FlyScreen extends BaseModule
	{
		/** 飞屏类型对象池 **/
		private var _flyPoolObj:Object;
		/** 执行飞屏队列 **/
		private var _flyItemQuence:Array;
		/** 是否正在播放 **/
		private var _isPlaying:Boolean;
		/** 可用纵坐标数组 **/
		private var _coorYArray:Array;
		
		private static const SCENE_WIDTH:int = 1920;
		private static const SCENE_HEIGHT:int = 1000;
		private static const SPEED:int = 4;
		private static const MAX_COLUMN:int = 5;

		
		public function FlyScreen()
		{
			super();
			this.mouseChildren=false;
			this.mouseEnabled=false;
			
			_flyItemQuence = new Array;
			
			initCoord();
		}
		
		private function initCoord():void
		{
			_coorYArray = new Array();
			_coorYArray.push(new CoordElement(450,true));
			_coorYArray.push(new CoordElement(340,true));
			_coorYArray.push(new CoordElement(230,true));
			_coorYArray.push(new CoordElement(560,true));
			_coorYArray.push(new CoordElement(670,true));
			
		}
		
		/**
		 * 初始化对象池 
		 * 
		 */		
		public function initObjectPool(data:Object):void
		{
			FlyScreenVo.flyScreenData = data as Array;
			_flyPoolObj = new Object();
			for each(var obj:Object in FlyScreenVo.flyScreenData)
			{
				_flyPoolObj[obj.flyId] = new GenericObjectPool(FlyItem);
			}
		}
		

		/**
		 * 显示飞屏 
		 * @param data
		 * 
		 */		
		public function showFlyScreen(data:Object):void
		{
			var flyItem:FlyItem = getFlyItem(data.flyId);
			flyItem.setItemData(data);
			push(flyItem);
		}
		/**
		 * 插入播放队列
		 * @param flyItem
		 * 
		 */		
		private function push(flyItem:FlyItem):void
		{
			_flyItemQuence.push(flyItem);
			this.addChild(flyItem);
			flyItem.x = SCENE_WIDTH;
			
			this.play();
		}
		/**
		 * 移除播放队列
		 * @param flyItem
		 * 
		 */		
		private function pull(flyItem:FlyItem):void
		{
			if(_flyItemQuence.length == 1)this.stop();
			//移除显示对象
			this.removeChild(flyItem);
			//移除队列
			_flyItemQuence.splice(_flyItemQuence.indexOf(flyItem),1);
			//回收对象
			returnFlyItem(flyItem);
		}
		/**
		 * 播放飞屏 
		 * 
		 */		
		private function play():void
		{
			if(_isPlaying)return;
			_isPlaying = true;
			
			Ticker.tick(2, onTick, -1);
		}
		/**
		 * 停止飞屏 
		 * 
		 */		
		private function stop():void
		{
			_isPlaying = false;
			Ticker.stop(onTick);
		}
		/**
		 * 计时计算队列中元件的x坐标 
		 * 
		 */		
		private function onTick():void
		{
			for each(var flyItem:FlyItem in _flyItemQuence)
			{				if(flyItem.isInitFinish){
					if(flyItem.isPlaying)
					{
						flyItem.x -= SPEED;
						
						if(((flyItem.x + flyItem.flagWidth) < SCENE_WIDTH) && !flyItem.releaseCoord)
						{
							flyItem.releaseCoord=true;
							for each(var co:* in _coorYArray)
							{
								if(co.y == flyItem.y)
								{
									co.enable=true;
									break;
								}
							}
						}
						
						if(flyItem.x + flyItem.width < 0)
							this.pull(flyItem);
					}else
					{
						var fy:int=0;
						for each(var ce:CoordElement in _coorYArray)
						{
							if(ce.enable)
							{
								ce.enable=false;
								fy = ce.y;
								break;
							}
						}
						if(fy){
							flyItem.y = fy;
							flyItem.isPlaying=true;
						}
					}
				}
			}
		}

		
		/**
		 * 获得飞屏元件 
		 * @param flyId
		 * @return 
		 * 
		 */		
		private function getFlyItem(flyId:String):FlyItem
		{
			return (_flyPoolObj[flyId] as GenericObjectPool).borrowObject() as FlyItem;
		}
		/**
		 * 回收对象 
		 * @param flyItem
		 * 
		 */		
		private function returnFlyItem(flyItem:FlyItem):void
		{
			(_flyPoolObj[flyItem.flyId] as GenericObjectPool).returnObject(flyItem);
		}
	}
}

class CoordElement{
	public var y:Number;
	public var enable:Boolean=false;
	
	public function CoordElement($y:int,$enable:Boolean):void
	{
		y = $y;
		enable = $enable;
	}
}