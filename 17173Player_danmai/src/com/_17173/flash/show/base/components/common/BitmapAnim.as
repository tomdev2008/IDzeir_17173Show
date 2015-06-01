package com._17173.flash.show.base.components.common
{
	import com._17173.flash.core.util.time.Ticker;
	import com._17173.flash.show.base.components.common.data.AnimData;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	
	public class BitmapAnim extends Sprite
	{
		
		protected var _bp:Bitmap = null;
		
		protected var _frame:int = 0;
		protected var _totalFrame:int = 0;
		protected var _data:Array = null;
		protected var _isPlaying:Boolean = false;
		protected var _loop:int = 0;
		protected var _autoPlay:Boolean = false;

		public function get playEndCall():Function
		{
			return _playEndCall;
		}

		public function set playEndCall(value:Function):void
		{
			_playEndCall = value;
		}

		private var _playEndCall:Function = null;
		public function BitmapAnim()
		{
			super();
		}
		
		/**
		 *自动播放 
		 */
		public function get autoPlay():Boolean
		{
			return _autoPlay;
		}

		/**
		 * @private
		 */
		public function set autoPlay(value:Boolean):void
		{
			_autoPlay = value;
		}

		/**
		 *播放次数 默认值为0播放一次结束， 重复播放请设置-1；
		 * @return 
		 * 
		 */
		public function get loop():int
		{
			return _loop;
		}

		public function set loop(value:int):void
		{
			_loop = value;
		}

		public function set data(value:Array):void {
			_data = value;
			_totalFrame = _data.length;
			
			if (_bp) {
				if (_bp.bitmapData) {
					_bp.bitmapData.dispose();
				}
				_bp.bitmapData = null;
			} else {
				_bp = new Bitmap();
				addChild(_bp);
			}
			var d:AnimData = _data[0];
			_bp.bitmapData = d.bd;
			if(_autoPlay){
				play();
			}
		}
		
		public function get frame():int {
			return _frame;
		}
		
		public function get totalFrame():int {
			return _totalFrame;
		}
		
		public function get isPlaying():Boolean {
			return _isPlaying;
		}
		
		public function play():void {
			if (_data && _totalFrame > 0 && !_isPlaying) {
				//如果loop==0则默认播放一次
				_loop = _loop == 0 ? 1 : _loop;
				_isPlaying = true;
				Ticker.tick(1, onRender, -1, true);
//				onRender();
			}
		}
		
		/**
		 * 往前走一帧 
		 */		
		protected function onRender(bool:Boolean = true):void {
			if(isPlaying && _data !=null ){
				if(bool)
				{
					run();
				}
				var d:AnimData = _data[_frame];
				_bp.bitmapData = d.bd;
				_bp.x = d.x;
				_bp.y = d.y;
			}			
		}
		
		protected function run():void{
			_frame++;
			updateFrame();
		}
		
		/**
		 * 更新帧,根据差值f计算当前的帧数
		 *  
		 * @param f
		 */		
		protected function updateFrame():void {
			var tmp:int = _frame;
			if (tmp == _totalFrame) {
				tmp = tmp - _totalFrame;
			} else if (tmp < 0) {
				tmp = _totalFrame + tmp - 1;
			}
			_frame = tmp;
			if(tmp == _totalFrame - 1)
				if(_loop != -1){
					_loop--;
				}
			if(_loop == 0){
				stop();
				if(_playEndCall != null){
					_playEndCall();
				}
			}
		}
		
		public function pause():void {
			if(_isPlaying){
				_isPlaying = false;
				Ticker.stop(onRender);
			}
		}
		
		public function stop():void {
			if(_isPlaying){
				_isPlaying = false;
				Ticker.stop(onRender);
			}
		}
		
		public function dispose():void {
			stop();
			_data = null;
		}
		
		public function reset():void {
			stop();
			play();
		}
		
		
		public function gotoAndPlay(toframe:int):void{
			_frame = toframe - 1;
			play();
		}
		
		public function gotoAndStop(toframe:int):void{
			_frame = toframe - 1;
			onRender(false);
			stop();
		}
		
	}
}