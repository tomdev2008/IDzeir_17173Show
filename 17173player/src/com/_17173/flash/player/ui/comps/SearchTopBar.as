package com._17173.flash.player.ui.comps
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.core.skin.ISkinObjectListener;
	import com._17173.flash.core.util.HtmlUtil;
	import com._17173.flash.core.util.Util;
	import com._17173.flash.core.video.interfaces.IVideoManager;
	import com._17173.flash.player.business.file.FileCustomerDataRetriver;
	import com._17173.flash.player.business.file.FileDataRetriver;
	import com._17173.flash.player.business.stream.StreamDataRetriver;
	import com._17173.flash.player.business.stream.custom.StreamCustomDataRetriver;
	import com._17173.flash.player.context.ContextEnum;
	import com._17173.flash.player.model.PlayerEvents;
	import com._17173.flash.player.model.PlayerScope;
	import com._17173.flash.player.model.PlayerType;
	import com._17173.flash.player.model.RedirectData;
	import com._17173.flash.player.model.RedirectDataAction;
	import com._17173.flash.player.model.SkinEvents;
	import com.greensock.TweenLite;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	
	/**
	 * 站外定制播放器顶部搜索栏
	 * @author 安庆航
	 * 
	 */	
	public class SearchTopBar extends Sprite implements ISkinObjectListener
	{
		private var _bg:Sprite = null;
		private var _search:MovieClip = null;
		private var _fontBg:MovieClip = null;
		private var _label:TextField = null;
		private var _canShow:Boolean = false;
		private var _focusIN:Boolean = false;
		private var _thisHeight:int = 37;
		private var _title:TextField = null;
		private var _offsetW:int = 15;
		private var _searchW:Number = 212;
		private var _titleW:Number = 0;
		private var _videoCanStart:Boolean = false;
		private var _e:IEventManager;
		
		public function SearchTopBar()
		{
			super();
			_titleW = Context.stage.stageWidth - _searchW - (_offsetW * 3) > 0 ? Context.stage.stageWidth - _searchW - (_offsetW * 3) : width;
			_e = Context.getContext(ContextEnum.EVENT_MANAGER) as IEventManager;
			_e.listen(PlayerEvents.UI_INTED, init);
		}
		
		/**
		 * 根据模块获取完成才初始化信息
		 */		
		private function init(data:Object = null):void {
			this.visible = false;
			
			_bg = new Sprite();
			addChild(_bg);
			
			if (!getShowFlag()) {
				return;
			}
			
			_search = new mc_outTopBarSearchBtn();
			addChild(_search);
			
			_fontBg = new mc_outTopBarSearchBG();
			_fontBg.width = 160;
			addChild(_fontBg);
			
			var format:TextFormat = new TextFormat();
			format.color = 0x000000;
			format.size = 16;
			format.font = Util.getDefaultFontNotSysFont();
			_label = new TextField();
			_label.text = "";
			_label.width = 159;
			_label.height = 24;
			_label.type = TextFieldType.INPUT;
			_label.defaultTextFormat = format;
			_label.setTextFormat(format);
			addChild(_label);
			initTitle();
			
			resize();
			addlisteners();
		}
		
		private function addlisteners():void {
			_e.listen(PlayerEvents.BI_PLAYER_INITED, videoInit);
			_e.listen(PlayerEvents.BI_INIT_COMPLETE, onBIInitVideoInfo);
			_e.listen(PlayerEvents.UI_TOGGLE_FULL_SCREEN, onFullScreen);
			_e.listen(PlayerEvents.UI_SHOW_BACK_RECOMMAND, showBackRec);
			_e.listen(PlayerEvents.UI_HIDE_BACK_RECOMMAND, hideBackRec);
			_e.listen(PlayerEvents.BI_VIDEO_CAN_START, videoCanStart);
			_search.addEventListener(MouseEvent.CLICK, onSearchHandler);
			_label.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
			_label.addEventListener(FocusEvent.FOCUS_IN, labelFocusIN);
			_label.addEventListener(FocusEvent.FOCUS_OUT, labelFocusOut);
		}
		
		private function initTitle():void {
			if (getTitleUIModule()) {
				var tf:TextFormat = new TextFormat();
				tf.color = 0xececec;
				tf.size = 14;
				tf.font = Util.getDefaultFontNotSysFont();
				_title = new TextField();
				_title.autoSize = TextFieldAutoSize.LEFT;
				_title.selectable = false;
				_title.text = " ";
				_title.defaultTextFormat = tf;
				_title.setTextFormat(tf);
				addChild(_title);
			}
		}
		
		private function onFullScreen(data:Object):void {
			TweenLite.to(this, 0.5, {"y":-height});
			this.visible = false;
		}
		
		private function videoInit(data:Object):void {
			_canShow = true;
		}
		
		private function getViedoTitle():void {
			if (!_title || !getTitleUIModule()) {
				return;
			}
			var vm:IVideoManager = Context.getContext(ContextEnum.VIDEO_MANAGER) as IVideoManager;
			var title:String = "";
			if (vm && vm.data) {
				title = HtmlUtil.decodeHtml((Context.getContext(ContextEnum.VIDEO_MANAGER) as IVideoManager).data.title);
			}
			if (Util.validateStr(title)) {
				_title.text = title;
			} else {
				_title.text = "";
			}
			_title.text = Util.formatStringExceed(_title, _titleW);
			_title.x = 15;
			_title.y = (_bg.height - _title.height) / 2;
		}
		
		private function onBIInitVideoInfo(data:Object):void {
			_canShow = false;
		}
		
		private function keyDown(evt:KeyboardEvent):void
		{
			switch (evt.keyCode)
			{
				case Keyboard.ENTER:
					onSearchHandler(null);
					break;
			}
		}
		
		private function onSearchHandler(evt:Event):void
		{
			if(_label.text != "")
			{
				var url:String = "";
//				if (Context.variables["type"] == Settings.PLAYER_TYPE_STREAM_OUT_CUSTOM) {
				var obj:Object = Context.variables;
				if (Context.variables["type"] == PlayerType.S_CUSTOM) {
					url = StreamDataRetriver.STREAM_SERACH_RUL;
				} else {
					url = FileDataRetriver.VIDEO_SERACH_RUL;
				}
				
				url += encodeURI(_label.text);
//				url += _label.text;
				
				//回链
				var redirect:RedirectData = new RedirectData();
				redirect.click_type = RedirectDataAction.CLICK_TYPE_REDIRECTION;
				redirect.url = url;
				redirect.action = RedirectDataAction.ACTION_BACK_SEARCH;
				redirect.send();
				
				_label.text = "";
			}
		}
		
		private function labelFocusIN(evt:FocusEvent):void {
//			if(Global.settings.isFullScreen) {
			if(Context.getContext(ContextEnum.SETTING)["isFullScreen"]) {
				Context.stage.displayState = StageDisplayState.NORMAL;
			}
			_focusIN = true;
		}
		
		private function labelFocusOut(evt:FocusEvent):void {
			_focusIN = false;
		}
		
		public function resize():void {
			resetChild();
			
			var centerW:Number = _search.width + _fontBg.width + 5;
			if(_bg && contains(_bg))
			{
				_bg.graphics.clear();
				_bg.graphics.beginFill(0x030303);
				_bg.graphics.drawRect(0, 0, Context.stage.stageWidth, _thisHeight);
				_bg.graphics.endFill();
			}
			
			if (_title && contains(_title)) {
				_title.x = 15;
//				_title.text = HtmlUtil.decodeHtml(Global.videoData["title"]);
				if (Context.getContext(ContextEnum.VIDEO_MANAGER) && (Context.getContext(ContextEnum.VIDEO_MANAGER) as IVideoManager).data) {
					_title.text = HtmlUtil.decodeHtml((Context.getContext(ContextEnum.VIDEO_MANAGER) as IVideoManager).data["title"]);
				} else {
					_title.text = "";
				}
				_titleW = Context.stage.stageWidth - _searchW - (_offsetW * 3) > 0 ? Context.stage.stageWidth - _searchW - (_offsetW * 3) : width;
				_title.text = Util.formatStringExceed(_title, _titleW);
				_title.y = (_bg.height - _title.height) / 2;
				
				if(_fontBg && contains(_fontBg))
				{
					_fontBg.x = Context.stage.stageWidth - _offsetW - _searchW;
					_fontBg.y = (_bg.height - _fontBg.height) / 2;
				}
			} else {
				if(_fontBg && contains(_fontBg))
				{
					_fontBg.x = (_bg.width - centerW) / 2;
					_fontBg.y = (_bg.height - _fontBg.height) / 2;
				}
			}
			
			
			if(_search && contains(_search))
			{
				_search.x = _fontBg.x + _fontBg.width + 5;
				_search.y = (_bg.height - _search.height) / 2 - 2;
			}
			
			if(_label && contains(_label))
			{
				_label.x = _fontBg.x + 1;
				_label.y = _fontBg.y + (_fontBg.height - _label.height) / 2 - 1;
			}
			
		}
		
		public function listen(event:String, data:Object):void {
			if (!_canShow) {
				return;
			}
			switch (event) {
				case SkinEvents.SHOW_FLOW : 
//					if (Global.settings.isFullScreen || !getShowFlag() || !_videoCanStart) {
					if (Context.getContext(ContextEnum.SETTING)["isFullScreen"] || !getShowFlag() || !_videoCanStart) {
						return;
					}
					getViedoTitle();
					this.visible = true;
					TweenLite.to(this, 0.5, {"y":0});
					break;
				case SkinEvents.HIDE_FLOW : 
					if (!getShowFlag()) {
						return;
					}
					if (_focusIN) {
						break;
					} else {
						TweenLite.to(this, 0.5, {"y":-height});
						this.visible = false;
						break;
					}
				case SkinEvents.RESIZE : 
					resize();
					break;
			}
		}
		
		/**
		 * 后推不能显示topbar
		 * @param data
		 * 
		 */		
		private function showBackRec(data:Object):void {
			_canShow = false;
			this.visible = false;
		}
		
		private function hideBackRec(data:Object):void {
			_canShow = true;
		}
		
		/**
		 * 获取模块配置参数中是否显示顶部搜索栏
		 */		
		private function getShowFlag():Boolean {
			var obj:Object = Context.variables["UIModuleData"];
			var re:Boolean = true;
			switch (Context.variables["type"]) {
//				case Settings.PLAYER_TYPE_STREAM_OUT_CUSTOM:
				case PlayerType.S_CUSTOM:
					if (Context.stage.stageWidth < PlayerScope.PLAYER_WIDTH_5) {
						re = false;
					} else {
						if (Util.validateObj(obj, StreamCustomDataRetriver.M4)) {
							re = obj[StreamCustomDataRetriver.M4];
						}
					}
					break;
//				case Settings.PLAYER_TYPE_FILE_OUT_CUSTOM:
				case PlayerType.F_CUSTOM:
					if (Context.stage.stageWidth < PlayerScope.PLAYER_WIDTH_4) {
						re = false;
					} else {
						if (Util.validateObj(obj, FileCustomerDataRetriver.M1)) {
							re = obj[FileCustomerDataRetriver.M1];
						}
					}
					break;
				default :
					re = true;
			}
			return re;
		}
		
		/**
		 * 从模块配置中获取是否要显示搜索栏标题
		 * @return 
		 * 
		 */		
		private function getTitleUIModule():Boolean {
			var obj:Object = Context.variables["UIModuleData"];
			var re:Boolean = true;
			switch (Context.variables["type"]) {
//				case Settings.PLAYER_TYPE_STREAM_OUT_CUSTOM:
				case PlayerType.S_CUSTOM:
					if (Util.validateObj(obj, StreamCustomDataRetriver.M14)) {
						re = obj[StreamCustomDataRetriver.M14];
					}
					break;
//				case Settings.PLAYER_TYPE_FILE_OUT_CUSTOM:
				case PlayerType.F_CUSTOM:
					if (Util.validateObj(obj, FileCustomerDataRetriver.M8)) {
						re = obj[FileCustomerDataRetriver.M8];
					}
					break;
				default :
					re = true;
			}
			if (Context.stage.stageWidth < PlayerScope.PLAYER_WIDTH_1) {
				re = false;
			}
			return re;
		}
		
		/**
		 * 根据当前宽度判断组件是否要显示
		 */			
		private function resetChild():void {
			var w:Number = Context.stage.stageWidth;
			if (w < PlayerScope.PLAYER_WIDTH_1 && _title && contains(_title)) {
				removeChild(_title);
			}
			if (w >= PlayerScope.PLAYER_WIDTH_1) {
				if (_title && !contains(_title)) {
					initTitle();
				}
			}
		}
		
		protected function videoCanStart(data:Object):void {
			_videoCanStart = true;
		}
		
	}
}