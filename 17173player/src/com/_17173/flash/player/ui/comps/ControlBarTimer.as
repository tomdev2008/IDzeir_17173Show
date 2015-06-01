package com._17173.flash.player.ui.comps
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.core.util.Util;
	import com._17173.flash.core.util.time.Ticker;
	import com._17173.flash.core.video.interfaces.IVideoManager;
	import com._17173.flash.player.context.ContextEnum;
	import com._17173.flash.player.model.PlayerEvents;
	
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	/**
	 * 播放时间. 
	 * @author shunia-17173
	 */	
	public class ControlBarTimer extends Sprite
	{
		
		private var _playedTimeTF:TextField = null;
		private var _totalTimeTF:TextField = null;
		private var _decoTF:TextField = null;
		private var _playedTime:int = 0;
		private var _totalTime:int = 0;
		
		public function ControlBarTimer()
		{
			super();
			
			var fm:TextFormat = new TextFormat();
			fm.size = fontSize;
			fm.color = 0xFFFFFF;
			fm.font = Util.getDefaultNumberFontNotSysFont();
			
			var tfm:TextFormat = new TextFormat();
			tfm.size = fontSize;
			tfm.color = 0x808080;
			tfm.font = Util.getDefaultNumberFontNotSysFont();
			
			_playedTimeTF = new TextField();
			_playedTimeTF.autoSize = TextFieldAutoSize.LEFT;
			_playedTimeTF.defaultTextFormat = fm;
			_playedTimeTF.text = "00:00";
			_playedTimeTF.selectable = false;
			addChild(_playedTimeTF);
			ContextEnum.SETTING
			if (Context.getContext(ContextEnum.SETTING)) {
				_decoTF = new TextField();
				_decoTF.autoSize = TextFieldAutoSize.LEFT;
				_decoTF.defaultTextFormat = fm;
				_decoTF.setTextFormat(fm);
				_decoTF.text = "/";
				_decoTF.selectable = false;
				addChild(_decoTF);
				
				_totalTimeTF = new TextField();
				_totalTimeTF.autoSize = TextFieldAutoSize.LEFT;
				_totalTimeTF.defaultTextFormat = tfm;
				_totalTimeTF.setTextFormat(tfm);
				_totalTimeTF.text = "00:00";
				_totalTimeTF.selectable = false;
				addChild(_totalTimeTF);
			}
			
			updatePos();
//			Global.eventManager.listen(PlayerEvents.VIDEO_INIT, onUpdateTotalTime);
			(Context.getContext(ContextEnum.EVENT_MANAGER) as IEventManager).listen(PlayerEvents.VIDEO_INIT, onUpdateTotalTime);
		}
		
		private function onUpdateTotalTime(data:Object = null):void {
//			if (_totalTime == Global.videoData.totalTime) return;
			if (_totalTime == (Context.getContext(ContextEnum.VIDEO_MANAGER) as IVideoManager).data.totalTime) return;
			
//			_totalTime = Global.videoData.totalTime;
			_totalTime = (Context.getContext(ContextEnum.VIDEO_MANAGER) as IVideoManager).data.totalTime;
			_totalTimeTF.text = formatTimeString(_totalTime);
			
			updatePos();
			Ticker.tick(300, updateCurrentTime, 0);
		}
		
		private function updateCurrentTime():void {
//			if (_playedTime == Global.videoData.playedTime) return;
			if (_playedTime == (Context.getContext(ContextEnum.VIDEO_MANAGER) as IVideoManager).data.playedTime) return;
			
//			_playedTime = Global.videoData.playedTime;
			_playedTime = (Context.getContext(ContextEnum.VIDEO_MANAGER) as IVideoManager).data.playedTime;
			if(_playedTime >= _totalTime) {
				_playedTime = _totalTime;
			}
			_playedTimeTF.text = formatTimeString(_playedTime);
			
			updatePos();
		}
		
		public function set currentTime(value:int):void {
			if (_playedTime == value) return;
			_playedTime = value;
			if(_playedTime >= _totalTime)
			{
				_playedTime = _totalTime
			}
			_playedTimeTF.text = formatTimeString(_playedTime);
			
			updatePos();
		}
		
		private function updatePos():void {
			if (_decoTF == null || _totalTimeTF == null) return; 
			_decoTF.x = _playedTimeTF.width;
			_totalTimeTF.x = _decoTF.width + _decoTF.x;
		}
		
		private function formatTimeString(sec:int):String {
			var min:int = sec / 60;
			var h:int = min / 60;
			sec = sec % 60;
			var str:String = "";
			if (h > 0) {
				str += h + ":";
				min = min % 60;
			}
			str += min < 10 ? "0" + min : min;
			str += ":";
			str += sec < 10 ? "0" + sec : sec;
			return str;
		}
		
		/**
		 * 获取当前的字体
		 */		
		protected function get fontSize():int {
			return 13;
		}
		
	}
}