package com._17173.flash.player.ui.stream.extra
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.core.skin.ISkinManager;
	import com._17173.flash.core.skin.ISkinObjectListener;
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.core.util.time.Ticker;
	import com._17173.flash.player.context.ContextEnum;
	import com._17173.flash.player.context.UIManager;
	import com._17173.flash.player.model.PlayerEvents;
	import com._17173.flash.player.model.SkinEvents;
	import com._17173.flash.player.ui.comps.SkinsEnum;
	import com.greensock.TweenLite;
	
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
	/**
	 * 直播底下的额外功能条,放置礼物,弹幕等功能区
	 * 所有添加的子项应当实现IExtraUIItem接口,用以提供在左或者右方的布局以进行计算
	 *  
	 * @author shunia-17173
	 */	
	public class StreamExtraBar extends Sprite implements ISkinObjectListener
	{
		public var _mouseOnBar:Boolean = false;
		private var _items:Vector.<IExtraUIItem> = null;
		
		protected var _bg:Shape = null;
		protected var _right:Sprite = null;
		protected var _left:Sprite = null;
		protected var _w:Number = 0;
		protected var _h:Number = 50;
		
		protected var _addingStack:Array = null;
		
		private var _isShow:Boolean = true;
		private var _isMouseStay:Boolean = false;
		protected var _itemDic:Dictionary = null;
		
		private var _userInfo:Sprite = null;
		private var _specileMouseStateArr:Array;
		
		public function StreamExtraBar()
		{
			super();
			_bg = new Shape();
			addChild(_bg);
			
			_addingStack = [];
			
			_left = new Sprite();
			addChild(_left);
			
			_right = new Sprite();
			addChild(_right);
			_items = new Vector.<IExtraUIItem>();
			_isShow = true;
			_isMouseStay = false;
			
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
			(Context.getContext(ContextEnum.EVENT_MANAGER) as IEventManager).listen(PlayerEvents.UI_COMP_ENABLE_CHANGE, uicompEableChange);
		}
		
		public function set mouseOnBar(value:Boolean):void {
			_mouseOnBar = value;
		}
		/**
		 * 注册左右站位组件
		 * @param left
		 * @param right
		 * 
		 */		
		public function registerItem(left:Array, right:Array):void {
			if (_itemDic) {
				return;
			}
			_itemDic = new Dictionary();
			
			for (var i:int = 0; i < left.length; i++) {
				_itemDic[left[i]] = new Sprite();
				_left.addChild(_itemDic[left[i]]);
			}
			
			for (var j:int = 0; j < right.length; j++) {
				_itemDic[right[j]] = new Sprite();
				_right.addChild(_itemDic[right[j]]);
			}
			
			if(_addingStack.length) {
				_addingStack.forEach(function (item:Object, index:int, o:Array):void {
					addItem(item.item, item.parent);
				});
				_addingStack = [];
			}
		}
		
		public function getItem(value:String):Sprite {
			return _itemDic[value];
		}
		
		protected function onAdded(event:Event):void {
			resize();
//			if (!Global.settings.isFullScreen) {
			if (!Context.getContext(ContextEnum.SETTING)["isFullScreen"]) {
//				addEventListener(MouseEvent.MOUSE_OVER, onOver);
//				addEventListener(MouseEvent.MOUSE_OUT, onOut);
//				Global.eventManager.listen("bulletInputing", onBulletInput);
				(Context.getContext(ContextEnum.EVENT_MANAGER) as IEventManager).listen("bulletInputing", onBulletInput);
			} else {
//				removeEventListener(MouseEvent.ROLL_OVER, onOver);
//				removeEventListener(MouseEvent.ROLL_OUT, onOut);
			}
		}
		
		private function onBulletInput(data:Object = null):void
		{
			_isMouseStay = true;
			Ticker.stop(hide);
//			if (!_isShow && Global.settings.isFullScreen) {
			if (!_isShow && Context.getContext(ContextEnum.SETTING)["isFullScreen"]) {
				Ticker.tick(UIManager.UI_IN_OUT_TIME, hide);
			}
		}
		
		public function show():void {
			_isShow = true;
//			var ph:Number = Global.skinManager.getSkin(SkinsEnum.BOTTOM_BAR).display.height;
			var ph:Number = (Context.getContext(ContextEnum.SKIN_MANAGER) as ISkinManager).getSkin(SkinsEnum.BOTTOM_BAR).display.height;
			TweenLite.to(this, 0.5, {"x":(Context.stage.fullScreenWidth - width) / 2, 
				"y": Context.stage.fullScreenHeight - height - ph - 30});
//			Global.eventManager.send("streamBarShowed");
			(Context.getContext(ContextEnum.EVENT_MANAGER) as IEventManager).send("streamBarShowed");
		}
		
		protected function onOut(event:MouseEvent):void {
			_isMouseStay = false;
			_isShow = false;
		}
		
		protected function onOver(event:MouseEvent):void {
			_isMouseStay = true;
		}
		
		public function hide():void {
			if (_mouseOnBar) return;
			_isShow = false;
			TweenLite.to(this, 0.5, {"y":Context.stage.fullScreenHeight});
//			Global.eventManager.send("streamBarHided");
			(Context.getContext(ContextEnum.EVENT_MANAGER) as IEventManager).send("streamBarHided");
		}
		
		public function addItem(item:IExtraUIItem, parentName:String):void {
			if (!_itemDic) {
				// 如果还没有初始化,就把要添加的项放到队列里
				_addingStack.push({"item":item, "parent":parentName});
				return;
			}
			
			var dis:DisplayObject = item as DisplayObject;
			var changed:Boolean = false;
			if (dis) {
				dis.visible = false;
				if (!dis.hasEventListener("updated")) {
					dis.addEventListener("updated", onItemUpdated);
				}
				var temp:Sprite = _itemDic[parentName] as Sprite;
				if (temp) {
					if (temp.numChildren > 0) {
						temp.removeChildAt(0);
					}
					temp.addChild(dis);
					changed = true;
				}
			}
			if (changed) {
				_items.push(item);
				resizeChilds();
			}
			drawBg();
		}
		
		protected function onItemUpdated(event:Event):void
		{
			resizeChildEx();
			drawBg();
		}
		
		public function removeItem(item:IExtraUIItem, parentName:String):void {
//			if (item.side == ExtraUIItemEnum.SIDE_LEFT && _left.contains(item as DisplayObject)) {
//				_left.removeChild(item as DisplayObject);
//			}
//			if (item.side == ExtraUIItemEnum.SIDE_RIGHT && _right.contains(item as DisplayObject)) {
//				_right.removeChild(item as DisplayObject);
//			}
			_addingStack.forEach(function (item:Object, index:int, o:Array):void {
				if (item.item == item && item.parent == parentName) {
					_addingStack.splice(index, 1);
				}
			});
			
			var temp:Sprite = _itemDic[parentName] as Sprite;
			if (temp) {
				if (temp.numChildren > 0) {
					temp.removeChildAt(0);
				}
			}
			if (_items.hasOwnProperty(item)) {
				delete _items[item];
			}
			resizeChilds();
			drawBg();
		}
		
		/**
		 * 删除所有组件
		 */		
		public function removeAllItem():void {
			return;
			if (_left && _left.numChildren > 0) {
				for (var i:int = 0; i < _left.numChildren; i++) {
					_left.removeChildAt(i);
				}
			}
			if (_right && _right.numChildren > 0) {
				for (var j:int = 0; j < _right.numChildren; j++) {
					_right.removeChildAt(j);
				}
			}
		}
		
		public function resize():void {
//			if (Global.settings.isFullScreen) {
			if (Context.getContext(ContextEnum.SETTING)["isFullScreen"]) {
				_w = Context.stage.fullScreenWidth * .9;
//				y = -(height + 30);
			} else {
				_w = Context.stage.stageWidth;
			}
			
			if (_w != _bg.width || _h != _bg.height) {
				graphics.clear();
//				if (!Global.settings.isFullScreen) {
				if (!Context.getContext(ContextEnum.SETTING)["isFullScreen"]) {
					graphics.beginFill(0xFFFFFF, 1);
					graphics.drawRect(0, 0, _w, _h);
					graphics.endFill();
				}
				drawBg();
			}
			
			_left.x = 6;
			_left.name = "left";
			//重新给两侧的子项排位置
			resizeChilds();
		}
		/**
		 *刷新背景 
		 * 
		 */		
		private function drawBg():void{
			_bg.graphics.clear();
			//				_bg.graphics.lineStyle(1, 0x757575);
			_bg.graphics.beginFill(0x444444, 0.8);
			_bg.graphics.drawRect(0, 0, _w, _h);
			_bg.graphics.endFill();
			_bg.name = "bg";
			//右侧栏绘制背景
			_right.graphics.clear();
			_right.graphics.beginFill(0x696969, .01);
			_right.graphics.drawRect(0, 0, -_right.width,_h);
			_right.graphics.endFill();
		}
		
		private function resizeChilds():void {
			for each (var item:IExtraUIItem in _items) {
//				item.refresh(Global.settings.isFullScreen);
				item.refresh(Context.getContext(ContextEnum.SETTING)["isFullScreen"]);
			}
			
			resizeChildEx();
			resetItemVisible();
			checkMouseEnabel();
		}
		
		protected function resetItemVisible():void {
			for each (var value:DisplayObject in _items) {
				if (value is DisplayObject && (value as DisplayObject).visible == false) {
					(value as DisplayObject).visible = true;
				}
			}
		}
		
		protected function resizeChildEx():void {
			var child:DisplayObject = null;
			var tmp:Number = 0;
			for (var i:int = 0; i < _left.numChildren; i ++) {
				child = _left.getChildAt(i);
				child.x = tmp;
				child.y = Math.ceil((_bg.height - child.height) / 2);
				tmp += child.width + ((i>0)?10:0) + child.x;
			}
			tmp = 0;
			
			for (i = 0; i < _right.numChildren; i ++) {
				child = _right.getChildAt(i);
				tmp -= (child.width);
				child.x = tmp;
				child.y =  Math.ceil((_bg.height - child.height) / 2);
			}
			
			_right.x = _w - 6;
		}
		
		override public function set height(value:Number):void {
			_h = value;
		}
		
		override public function get height():Number {
//			if (_isFullScreen) {
//				return 0;
//			} else {
				return _h;
//			}
		}
		
		override public function get width():Number {
			return _w;
		}
		
		public function listen(event:String, data:Object):void
		{
			switch (event) {
				case SkinEvents.RESIZE : 
					TweenLite.killTweensOf(this);
					resize();
					break;
				case SkinEvents.SHOW_FLOW : 
//					if (Global.settings.isFullScreen) {
					if (Context.getContext(ContextEnum.SETTING)["isFullScreen"]) {
						show();
					}
					break;
				case SkinEvents.HIDE_FLOW : 
//					if (Global.settings.isFullScreen) {
					if (Context.getContext(ContextEnum.SETTING)["isFullScreen"]) {
						hide();
					}
					break;
			}
		}
		
		private function checkMouseEnabel():void {
			if (Context.variables.hasOwnProperty("uiCompEnable")) {
				for (var item:String in _itemDic) {
					if (_specileMouseStateArr) {
						if (_specileMouseStateArr.indexOf(item) == -1) {
							(_itemDic[item] as Sprite).mouseChildren = Context.variables["uiCompEnable"];
							(_itemDic[item] as Sprite).mouseEnabled = Context.variables["uiCompEnable"];
						}
					} else {
						(_itemDic[item] as Sprite).mouseChildren = Context.variables["uiCompEnable"];
						(_itemDic[item] as Sprite).mouseEnabled = Context.variables["uiCompEnable"];
					}
				}
			}
		}
		
		private function uicompEableChange(value:Object):void {
			var child:DisplayObject = null;
			if (value) {
				this.mouseChildren = true;
				this.mouseEnabled = true;
			}
			for (var item:String in _itemDic) {
				(_itemDic[item] as Sprite).mouseChildren = Context.variables["uiCompEnable"];
				(_itemDic[item] as Sprite).mouseEnabled = Context.variables["uiCompEnable"];
			}
		}
		
		public function specilCompEnable(value:Array):void {
			_specileMouseStateArr = value;
		}
		
	}
}