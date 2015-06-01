package com._17173.flash.show.base.module.scene
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.core.util.time.Ticker;
	import com._17173.flash.show.base.context.layer.IUIManager;
	import com._17173.flash.show.base.context.module.BaseModule;
	import com._17173.flash.show.base.module.guidetask.GuideManager;
	import com._17173.flash.show.model.CEnum;
	import com._17173.flash.show.model.SEvents;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	/**
	 * 场景.
	 * 
	 * 负责各个显示对象的布局.
	 *  
	 * @author shunia-17173
	 */	
	public class Scene extends BaseModule implements IScene
	{
		
		private var _bg:DisplayObject = null;
		private var _bgLayer:Sprite = null;
		private var _uiLayer:Sprite = null;
		
		/**
		 * 标识是否正在执行场景元素添加 
		 */		
		private var _isAdding:Boolean = false;
		private var _inited:Boolean = false;
		private var _items:Array = null;
		private var _delayAddIndex:int = 0;
		private var _config:Array = null;
		private var _absoluteConfig:Array = null;
		private var _inabsoluteConfig:Array = null;
		private var _idDic:Dictionary = null;
		private var _drag:SceneDrag = null;
		public function Scene()
		{
			super();
			_version = "0.0.1";
		}
		
		override protected function init():void {
			super.init();
			//初始化数据
			_inited = false;
			_delayAddIndex = 0;
			_items = [];
			_idDic = new Dictionary(true);
			_bgLayer = new Sprite();
			_bgLayer.mouseChildren = true;
			addChild(_bgLayer);
			//初始化背景层
			initBackground();
			_uiLayer = new Sprite();
			_uiLayer.mouseEnabled = false;
			addChild(_uiLayer);
			addLsn();
			Context.variables["isDrag"] = true;
		}
		
		private function addLsn():void{
			var s:IEventManager = Context.getContext(CEnum.EVENT) as IEventManager;
			s.listen(SEvents.CHange_SCENE_DRAG,onDragChange);
		}
		
		private function onDragChange(data:Boolean):void{
			Context.variables["isDrag"] = data;
			if(data)
			    Debugger.log(Debugger.INFO, "[Scene]", "已启动拖动场景: " + data.toString());
			else
				Debugger.log(Debugger.INFO, "[Scene]", "已停止拖动场景: " + data.toString());
		}
		
		/**
		 * 真实添加 
		 */		
		private function checkAdd():void {
			if (_delayAddIndex != _items.length) {
				var p:SceneElement = _items[_delayAddIndex] as SceneElement;
				addToLayer(p);
				
				_delayAddIndex ++;
				_isAdding = true;
				Ticker.tick(1, checkAdd, 1, true);
			} else {
				_isAdding = false;
				Ticker.stop(checkAdd);
			}
		}
		
		override protected function onAdded(event:Event):void {
			super.onAdded(event);
			//赋值配置
			Context.stage.addEventListener(Event.RESIZE, onStageResize);
			//启用拖拽
			_drag = new SceneDrag(_bgLayer);
			//强制居中
			onStageResize(null);
			//延迟添加
			onDelayAdd();
		}
		
		public function initScene():void {
			_inited = true;
			//延迟添加
			onDelayAdd();
		}
		
		/**
		 * 应用初始化完毕后延迟加载模块.
		 *  
		 * @param data
		 */		
		private function onDelayAdd():void {
			if (!_inited || parent == null) return;
			
			Ticker.tick(1, checkAdd, 1, true);
		}
		
		protected function onStageResize(event:Event):void {
			updatePosition();
			centerBackground();
			if (_drag) {
				_drag.updateDrag();
			}
//			onTestLog();
		}
		
		/**
		 * 测试输出 
		 */		
		private function onTestLog():void {
			var c:Sprite = null;
			var n:String = null;
			for (var i:int = 0; i < _bgLayer.numChildren; i ++) {
				c = _bgLayer.getChildAt(i) as Sprite;
				if (c && c.numChildren > 0) {
					n = c.getChildAt(0).name;
				}
				if (n) {
					Debugger.tracer("background: [name: " + n + ", index: " + i + "]");
				}
			}
			for (i = 0; i < _uiLayer.numChildren; i ++) {
				c = _uiLayer.getChildAt(i) as Sprite;
				if (c && c.numChildren > 0) {
					n = c.getChildAt(0).name;
				}
				if (n) {
					Debugger.tracer("ui: [name: " + n + ", index: " + i + "]");
				}
			}
		}
		
		/**
		 * 初始化背景层 
		 */		
		private function initBackground():void {
			_bg = new background();
			if(_bg is MovieClip){
				(_bg as MovieClip).mouseEnabled = false;
				(_bg as MovieClip).mouseChildren = false;
			}
			_bg.cacheAsBitmap = true;
			_bgLayer.addChild(_bg);
			
			GuideManager.backgourdnLayer = _bgLayer;
		}
		
		/**
		 * 背景层居中 
		 */		
		private function centerBackground():void { 
			_bgLayer.x = (Context.stage.stageWidth - Math.floor(_bg.width)) / 2;
			
			_bgLayer.y = (Context.getContext(CEnum.UI) as IUIManager).sceneRect.y;
		}
		
		/**
		 * 更新坐标 
		 * @param updatePos  不传参数时候更新全部场景元素，传入参数时候更新某个场景元素
		 * 
		 */		
		private function updatePosition(updatePos:SceneElement = null):void {
			for (var i:int = 0; i < _items.length; i ++) {
				var pos:SceneElement = _items[i] is SceneElement ? _items[i] as SceneElement : null;
				if (pos) {
					var child:DisplayObject = pos.content;
		
					if (!updatePos||child&&updatePos.name == pos.name) {
						var cor:Object = pos.getPos();
						child.x = cor.x;
						child.y = cor.y;
					}
				}
			}
		}
		
//		/**
//		 *添加到对应层级 
//		 * @param ds
//		 */		
//		private function addChildToLayer(layer:Sprite, ds:DisplayObject, key:String):void{
//			_idDic[ds] = key;
//			var info:Array = _config.getInfoByName(key);
//			var depth:int = info[0];
//			//判断层级 如果是添加到最上层
//			if(info[1] < 0){
//				layer.addChild(ds);
//			}else{
//				var tmp:DisplayObject = null;
//				var findIdx:int = -1;
//				var id:String = "";
//				var tmpDepth:int = 0;
//				var len:int = layer.numChildren;
//				for (var i:int = 0; i < len; i++) 
//				{
//					tmp = layer.getChildAt(i);
//					//背景层不调整层级
//					if(tmp === _bg)continue;
//					id = _idDic[tmp];
//					//获取当前层级
//					if(id!="" && id!=null){
//						tmpDepth = (_config.getInfoByName(key))[1];
//						if(tmpDepth > depth){
//							findIdx = i;
//							break;
//						}
//					}
//				}
//				//添加到对应深度
//				if(findIdx < 0){
//					layer.addChild(ds);
//				}else{
//					layer.addChildAt(ds,findIdx);
//				}
//			}
//		}
		
		/**
		 * 初始化配置数据.
		 *  
		 * @param value
		 */		
		public function initData(value:Object):void
		{
			_config = value ? value as Array : [];
			_absoluteConfig = [];
			_inabsoluteConfig = [];
			var sp:Sprite = null;
			//分离动态层和非动态层
			for (var i:int = 0; i < _config.length; i ++) {
				var conf:Object = _config[i];
				sp = new Sprite();
				//取消容器鼠标拦截
				sp.mouseEnabled = false;
				if (conf.isAbsolute) {
					_bgLayer.addChild(sp);
					_absoluteConfig.push(conf);
				} else {
					_uiLayer.addChild(sp);
					_inabsoluteConfig.push(conf);
				}
			}
		}
		
		public function addElement(element:Object):void
		{
			var p:SceneElement = null;
			if (element is DisplayObject) {
				//如果是显示对象,判断是否在配置中,在则添加
				var key:String = element.name;
				for each (var conf:Object in _config) {
					if (conf["name"] == key) {
						p = SceneElement.wrapConf(conf);
						p.content = element as DisplayObject;
						break;
					}
				}
			} else if (element is SceneElement) {
				//如果是场景坐标,则覆盖添加
				p = element as SceneElement;
			}
			//没有符合条件的不做处理
			if (p == null) return;
//			//右键菜单.
//			var ui:IUIManager = Context.getContext(CEnum.UI) as IUIManager;
//			if (p.content.hasOwnProperty("contextMenu")) {
//				p.content["contextMenu"] = ui.contextMenu;
//			}
			//存起来
			_items.push(p);
			//添加
//			addToLayer(p);
//			if (scenePos.isAbsolute) {
//				addToAbsoluteLayer(scenePos.content, scenePos.name);
//			} else {
//				addToInabsoluteLayer(scenePos.content, scenePos.name);
//			}
			if (_inited&&!_isAdding) {
				onDelayAdd();
			}
		}
		
		/**
		 * 根据层级关系及位置信息添加到舞台上.
		 *  
		 * @param pos
		 */		
		private function addToLayer(pos:SceneElement):void {
			var l:Sprite = null;
			var i:int = 0;
			var confs:Array = null;
			if (pos.isAbsolute) {
				l = _bgLayer;
				i = 1;
				confs = _absoluteConfig;
			} else {
				l = _uiLayer;
				i = 0;
				confs = _inabsoluteConfig;
			}
			//先更新位置，再add防止覆盖元素addtoStage时候的位置赋值
			updatePosition(pos);
			
			updateToLayer(l, i, confs, pos);			
		}
		
		/**
		 * 将子对象按照要求添加到对应的层级上.
		 *  
		 * @param layer
		 * @param baseIndex
		 * @param confs
		 * @param pos
		 */		
		private function updateToLayer(layer:Sprite, baseIndex:int, confs:Array, pos:SceneElement):void {
			//最终的深度
			var d:int = 0;
			//列表中的深度
			var k:int = 0;
			var conf:Object = null;
			while (k < confs.length) {
				conf = confs[k];
				if (conf["name"] == pos.name) {
					break;
				}
				k ++;
			}
			k += baseIndex;
			//如果没有找到相应的层级，说明是动态添加，直接添加到最上，不作排序
			if (k >= layer.numChildren) {
				layer.addChild(pos.content);
			} else {
				var container:Sprite = layer.getChildAt(k) as Sprite;
				if (container && !container.contains(pos.content)) {
					container.addChild(pos.content);
				}
			}
//			Debugger.tracer("[scene] add to layer: " + pos.content.name + " at index " + k + ", numchildren " + layer.numChildren);
//			if (layer.numChildren > k) {
//				Debugger.tracer("[scene] add to: " + k);
//				layer.addChildAt(pos.content, k);
//			} else {
//				Debugger.tracer("[scene] add to top");
//				layer.addChild(pos.content);
//			}
		}
		
	}
}