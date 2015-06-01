package com._17173.flash.show.base.module.scene
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.show.base.context.layer.IUIManager;
	import com._17173.flash.show.base.context.module.BaseModuleDelegate;
	import com._17173.flash.show.model.CEnum;
	import com._17173.flash.show.model.SEvents;

	/**
	 * 场景模块代理类
	 *  
	 * @author shunia-17173
	 */	
	public class SceneDelegate extends BaseModuleDelegate
	{
		
		/**
		 * 缓存的注册点 
		 */		
		private var _regedPos:Array = null;
		/**
		 * 场景配置 
		 */		
		private var _sceneConfig:Array = null;
		/**
		 * 场景接口 
		 */		
		//private var _scene:IScene = null;
		/**
		 * 是否已经可以初始化场景 
		 */		
		private var _inited:Boolean = false;
		
		public function SceneDelegate()
		{
			var modules:Array = Context.variables["conf"].modules;
			_sceneConfig = [];
			for (var i:int = 0; i < modules.length; i ++) {
				var m:Object = modules[i];
				var o:Object = {};
				o.name = m.name;
				for (var key:String in m["position"]) {
					o[key] = m["position"][key];
				}
				_sceneConfig.push(o);
			}
			_regedPos = [];
			
			super();
			_e.listen(SEvents.APP_INIT_COMPLETE, onInitScene);
			_e.listen(SEvents.REG_SCENE_POS, onRegScenePos);
			
		}
		
		/**
		 * 应用初始化结束事件
		 *  
		 * @param data
		 */		
		private function onInitScene(data:Object = null):void {
			//移除事件
			_e.remove(SEvents.APP_INIT_COMPLETE, onInitScene);
			//标记
			_inited = true;
			//确认
			checkSceneInit();
		}
		
		/**
		 * 检查场景是否可以初始化.(在收到应用初始化完成事件,并且场景模块已经加载完毕的情况下,才让场景开始初始化) 
		 */		
		private function checkSceneInit():void {
			if (_inited && module) {
				//_scene.initScene();
				this.module.data = {"initScene":null};
				_inited = false;
			}
		}
		
		/**
		 * 注册场景中的各个模块的位置 
		 */		
		private function onRegScenePos(data:Object):void {
			//注册或者缓存
			/*if (_scene) {
				_scene.addElement(data);
			} else {
				_regedPos.push(data);
			}*/
			if(module)
			{
				module.data = {"addElement":[data]};
			}else{
				_regedPos.push(data);
			}
		}
		
		override protected function onModuleLoaded():void {
			super.onModuleLoaded();
			
			//_scene = _swf as IScene;
			module.data = {"initData":[_sceneConfig]};
			
			//如果有缓存的注册信息,提供给scene.
			while (_regedPos.length) {
				//_scene.addElement(_regedPos.shift());
				module.data = {"addElement":[_regedPos.shift()]};
			}
			
			//确认场景是否可以初始化
			checkSceneInit();
			
			//注册到UI中并统一进行层级管理
			IUIManager(Context.getContext(CEnum.UI)).initializeScene(_swf);
		}
		
	}
}