package com._17173.flash.show.base.components.base
{
	import com._17173.flash.core.util.time.Ticker;
	import com._17173.flash.show.base.components.event.MoveEvent;
	import com._17173.flash.show.base.components.interfaces.IMoveContainer;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Point;
	import com._17173.flash.core.components.base.BaseContainer;

	/**
	 *移动  移动显示对象有上限，如达到上限，需要监听
	 * @author zhaoqinghao
	 * 
	 */	
	public class BaseMovePane extends BaseContainer implements IMoveContainer
	{
		
		public static const STATE_START:int = 1;
		public static const STATE_STOP:int = 0;
		/**
		 *所有未开始组件 
		 */		
		protected var _waitMoveItems:Array = null;
		/**
		 *所有移动组件 
		 */		
		protected var _moveItems:Array = null;
		/**
		 *当前缓动对象 
		 */		
		protected var _currentItem:DisplayObject = null;
		
		/**
		 *当前状态 0停止 1开始
		 */		
		protected var _playState:int = 0;
		/**
		 *遮罩 
		 */		
		protected var _mask:Sprite = null;
		/**
		 *宽 
		 */		
		protected var _tWidth:int = 0;
		/**
		 *高
		 */		
		protected var _tHeight:int = 0;
		
		protected var _itemCount:int = 0; 
		/**
		 *是否可以播放下一个 
		 */		
		protected var _canPlayNext:Boolean = true;
		
		protected var _moveSpeed:int = 0;
		/**
		 *移动时间 
		 */		
		protected var _moveTime:Number = 0;
		
		protected var _delay:int = 0;
		/**
		 *运动间隔 
		 */		
		protected var _moveSpace:int =0;
		/**
		 *要移动到的位置 
		 */		
		protected var _xto:int = 0;
		/**
		 *要移动到的位置 
		 */
		protected var _yto:int = 0;
		/**
		 *全部播放完毕 
		 */		
		protected var _autoStop:Boolean = false;
		/**
		 * 
		 */		
		protected var _checkNext:Boolean = true;
		
		protected var _isMask:Boolean = true;
		/**
		 *缓动容器 
		 * @param tWidth 宽
		 * @param tHeight 高
		 * @param moveSpeed 移动速度 默认1；
		 * @param delay 间隔 默认500毫秒；
		 * @param maxCount 限制数量 默认30个；
		 * 
		 */			
		public function BaseMovePane(tWidth:int,tHeight:int,moveSpeed:int = 1,delay:int = 500,isMask:Boolean = true)
		{
			_tWidth = tWidth;
			_tHeight = tHeight;
			_moveSpeed = moveSpeed;
			_delay = delay; 
			_moveSpace = _delay;
			this.mouseEnabled = false;
			_isMask = isMask;
			super();
		}
		
		/**
		 *当前数量 
		 */
		public function get itemCount():int
		{
			return _itemCount;
		}

		/**
		 * @private
		 */
		public function set itemCount(value:int):void
		{
			_itemCount = value;
			this.dispatchEvent(new MoveEvent(MoveEvent.COUNT_CHANGE));
		}

		override protected function onShow():void{
//			start();
		}
		
		override protected function onHide():void{
			stop();
			killAllItemOnMoving();
			_moveItems = [];
		}
		
		override protected function onInit():void{
			super.onInit();
			_waitMoveItems = [];
			_moveItems = [];
			this.width = _tWidth;
			this.height = _tHeight;
			createMask();
		}
		
		
		private function createMask():void{
			if(_isMask){
				_mask =new Sprite();
				_mask.graphics.beginFill(0x000000);
				_mask.graphics.drawRect(0,0,_tWidth,_tHeight);
				_mask.graphics.endFill();
				_mask.mouseEnabled = false;
				this.mask = _mask;
				this.addChild(_mask);
			}
		}
		
		/**
		 *开始播放缓动
		 * 
		 */		
		private function startPlay():void{
			if(_waitMoveItems.length <= 0){
				this.dispatchEvent(new MoveEvent(MoveEvent.PLAY_NEXT));
			}else{
				playNext();
			}
		}
		/**
		 *自动开始播放特效
		 * 
		 */		
		private function needAutoStart():void{
			if(_autoStop == true){
				_autoStop = false;
				this.dispatchEvent(new MoveEvent(MoveEvent.AUTO_START));
				startPlay();
				Ticker.tick(1,run,-1,true);
			}
		}
		
		/**
		 *自动停止播放特效
		 * 
		 */		
		private function needAutoStop():void{
			if(itemCount == 0){
				_autoStop = true;
				this.dispatchEvent(new MoveEvent(MoveEvent.AUTO_STOP));
				Ticker.stop(run);
			}
		}
		/**
		 *移除正在移动的元素 
		 * @param item
		 * 
		 */		
		public function removeItemOnMoving(item:DisplayObject):void{
			if(_moveItems.indexOf(item) >= 0){
				_moveItems.splice(_moveItems.indexOf(item), 1);
				onItemMoveEnd(item);
			}
		}
		/**
		 *删除所有缓动的元素
		 * 
		 */		
		public function killAllItemOnMoving():void{
			var len:int = _moveItems.length;
			var item:DisplayObject;
			while(len > 0){
				item = _moveItems[0];
				_moveItems.shift();
				if(this.contains(item)){
					this.removeChild(item);
				}
				len--;
			}
		}
		
		/**
		 *移动完成 
		 * @param item
		 * 
		 */		
		protected function itemMoveEnd(item:DisplayObject):void{
			onItemMoveEnd(item);
		}
		/**
		 * 对象已经完成缓动 并到达预定位置
		 * @param item
		 * 
		 */		
		private function onItemMoveEnd(item:DisplayObject):void{
			if(this.contains(item)){
				this.removeChild(item);
			}
			this.dispatchEvent(new MoveEvent(MoveEvent.ITEM_MOVE_END,item));
		}
		
		
		protected function overItem():void{
			_canPlayNext = true;
			this.dispatchEvent(new MoveEvent(MoveEvent.PLAY_NEXT));
		}
		/**
		 *移动 移动方式自己覆盖重写
		 * @param item
		 * 
		 */		
		protected function moveItem(item:DisplayObject):void{
			_moveItems.push(item);
			this.addChild(item);
		}
		
		protected function run():void{
			var len:int = _moveItems.length;
			for (var i:int = 0; i < len; i++) 
			{
				var tmpitem:DisplayObject = _moveItems[i] as DisplayObject;
				var pot:Point = getToPosition(tmpitem);
				if(tmpitem.x <= pot.x){
					//移动完成
					removeItemOnMoving(tmpitem);
					i--;
					len = _moveItems.length;
				}else{
					tmpitem.x -= _moveSpeed;
				}
				//判断是否可以移动下一个
				if(i == len-1 && _checkNext)
				{
					checkNextItem(tmpitem);
				}
			}
		}
		
		/**
		 *移动区域  （如果是有遮罩则返回本身宽度，如果是使用舞台宽度，请复此方法）
		 * @return 
		 * 
		 */		
		protected function getPaneWidth():int{
			return width;
		}
		/**
		 *检测是否可以移动下一个 
		 * @param tmpItem
		 * 
		 */		
		protected function checkNextItem(tmpItem:DisplayObject):void{
			var space:int =  getPaneWidth() - (tmpItem.x + tmpItem.width);
			if(space > _moveSpace){
				_checkNext = false;
				overItem();
			}
		}
		/**
		 *计算移动时间
		 * 移动长度除以移动速度 
		 * 
		 */		
		protected function calMoveTime(item:DisplayObject,pot:Point):Number{
			return (Math.abs(pot.x- item.x))/_moveSpeed;
		}
		/**
		 *计算显示组件时间 
		 * @param item
		 * @return 
		 * 
		 */		
		protected function calShowTime(item:DisplayObject):Number{
			return item.width/_moveSpeed;
		}
		/**
		 *计算移动终点 
		 * 
		 */		
		protected function getToPosition(item:DisplayObject):Point{
			return new Point();
		}
		
		
		/**
		 *初始化位置 
		 * @param item
		 * 
		 */		
		protected function initMoveItemPosition(item:DisplayObject):void{
			item.x = this._tWidth + 10;
			item.y = 4;
		}
		
		protected function playNext():void{
			if(_canPlayNext && _playState == STATE_START){
				_canPlayNext = false;
				var item:DisplayObject = _waitMoveItems.shift();
				itemCount = itemCount - 1;
				_checkNext = true;
				moveItem(item);
			}else{
				_checkNext = true;
				_canPlayNext = true;
				needAutoStop();
			}
		}
		
		/**
		 *添加 请调用isfull方法判断是否可以添加 
		 * @param item
		 * @return 
		 * 
		 */		
		public function playItem(item:DisplayObject):Boolean
		{
			var result:Boolean = false;
			if(canPlayNext && _playState == STATE_START){
				initMoveItemPosition(item);
				_waitMoveItems.push(item);
				itemCount = itemCount + 1;
				if(canPlayNext == true){
					playNext();
				}else{
					needAutoStart();
				}
				result = true;
			}
			return result;
		}
		
		public function removeItem(item:DisplayObject):void
		{
			if(_waitMoveItems.indexOf(item) > 0){
				_waitMoveItems.splice(_waitMoveItems.indexOf(item), 1);
			}
		}
		
		/**
		 *添加到下一个显示 请调用isfull方法判断是否可以添加 
		 * @param item
		 * @return 
		 * 
		 */	
		public function insertItem(item:DisplayObject):Boolean
		{
			var result:Boolean = false;
			if(_canPlayNext  && _playState == STATE_START){
				initMoveItemPosition(item);
				_waitMoveItems.unshift(item);
				_itemCount++;
				if(canPlayNext == true){
					playNext();
				}else{
					needAutoStart();
				}
				result = true;
			}
			return result;
		}
		/**
		 *开始 
		 * 
		 */		
		public function start():void
		{
			if(_playState == STATE_STOP){
				_playState = STATE_START;
				startPlay();
				Ticker.tick(1,run,-1);
			}
		}
		/**
		 *重新开始 
		 * 
		 */		
		public function reStart():void{
			if(_playState == STATE_STOP){
				_playState = STATE_START;
				Ticker.tick(1,run,-1);
			}
		}
		/**
		 *停止后续对象移动，当前移动对象不会停止（停止不会删除添加对象，如需操作请调用clean方法）
		 * 
		 */		
		public function stop():void
		{
			if(_playState == STATE_START){
				_playState = STATE_STOP;
				Ticker.stop(run);
				_autoStop = false;
			}
			
		}
		/**
		 *清楚所有显示对象，当前移动对象不受限制 
		 * 
		 */		
		public function clean():void
		{
			stop();
			killAllItemOnMoving();
			itemCount == 0;
			_canPlayNext = true;
			_waitMoveItems = [];
			clearMove()
		}
		
		private function clearMove():void
		{
			var len:int = _moveItems.length;
			var dso:DisplayObject;
			for (var i:int = 0; i < len; i++) 
			{
				dso = _moveItems[i];
				if(dso && dso.parent){
					dso.parent.removeChild(dso);
				}
			}
			_moveItems = [];
		}
		/**
		 *获取是否可以播放 
		 * @return 
		 * 
		 */		
		public function get canPlayNext():Boolean{
			return _canPlayNext && _playState == STATE_START;
		}
		/**
		 *获取播放状态 
		 * @return 
		 * 
		 */		
		public function get playState():int{
			return _playState;
		}
		
		public function getMoveCount():int{
			var result:int = 0;
			if(_moveItems){
				result = _moveItems.length;
			}
			return result;
		}
		
		override protected function onDrawRect():void{
			_lastWidth = _setWidth;
			_lastHeight = _setHeight;
		}
	}
}