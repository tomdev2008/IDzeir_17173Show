package com._17173.framework.core.manager
{
	import com._17173.framework.core.ApplicationGlobals;
	import com._17173.framework.core.events.ManagerEvent;
	import com._17173.framework.core.events.ModuleEvent;
	import com._17173.framework.core.log.Log;
	import com._17173.framework.core.module.ModuleManager;
	import com._17173.framework.core.net.http.HttpService;
	
	import flash.display.Sprite;
	
	/**
	 * @author Cray 
	 * @version 1.0
	 * @date Oct 28, 2014 10:59:53 AM
	 */
	public class ModuleDisplayManager implements IModuleDisplayManager
	{
		public static const CONTEXT_NAME:String = "ModuleDisplayManager";
		/** 模块信息向量数组 **/
		private var _modBeansVector:Vector.<IModuleBeanInfo> = new Vector.<IModuleBeanInfo>;
		
		public function ModuleDisplayManager()
		{
			
		}
		/**
		 * 停止到指定索引值 的模块下载 
		 * 默认值为 1000
		 */		
		private var _stopLoadName:String;
		public function stopLoadAtModuleName(name:String):void
		{
			_stopLoadName = name;
		}
		
		/**
		 * 继续下载模块 
		 * 
		 */		
		public function continueLoad():void
		{
			if(_stopLoadName!=null)
			{
				_stopLoadName=null;
				//开始加载模块
				loadModule();
			}
		}
		
		/**
		 * 下载所有模块 
		 * 
		 */		
		private var _allAuto:Boolean;
		public function loadModuleAll():void
		{
			_allAuto = true;
			loadModule();
		}
		/**
		 * 启动
		 * 开始读取配置文件，下载模块
		 * 布局视图
		 * 
		 */		
		private var _start:Boolean=false;
		public function startUp():void
		{
			if(_start)return;
			/** 添加容器到Application **/	
			_start = true;
            var modulesPath:String = AMGlobals.info["modulePath"];
			if(modulesPath && modulesPath.indexOf("xml")!=-1)
			{
				var httpService:HttpService = new HttpService();
				httpService.loadFile(modulesPath,modulesConfigSuccess,modulesConfigFail);
			}
		}
		/**
		 * 
		 * @param name
		 * @return 
		 * 
		 */		
		public function getModuleBeanInfo(name:String):IModuleBeanInfo
		{
			if(containsModule(name))
			{
				var i:int=0;
				for each(var modBeanInfo:ModuleBeanInfo in _modBeansVector)
				{
					if(modBeanInfo.name == name)
						break;
					i++;
				}
				return _modBeansVector[i];
			}else
				return null;
		}
		/**
		 * 添加模块到舞台 
		 * @param name
		 * 
		 */		
		public function addModule(name:String):void
		{
			addModuleByInfo(this.getModuleBeanInfo(name));
		}
		/**
		 * 删除模块 
		 * @param name
		 * 
		 */		
		public function removedModule(name:String):void
		{
			var modBeanInfo:IModuleBeanInfo = this.getModuleBeanInfo(name);
			if(AMGlobals.acm.measureContainer.getChildIndex(modBeanInfo.moduleInfo.module)!=-1)
				AMGlobals.acm.measureContainer.removeChild(modBeanInfo.moduleInfo.module);
			else if(AMGlobals.acm.windowContainer.getChildIndex(modBeanInfo.moduleInfo.module)!=-1)
				AMGlobals.acm.windowContainer.removeChild(modBeanInfo.moduleInfo.module);
			//钝化模块
			if(modBeanInfo.moduleInfo.module.hasOwnProperty("passivate"))
				modBeanInfo.moduleInfo.module["passivate"]();
			//log
			Log.getLogger(this).info("[ModuleManager] 模块 "+modBeanInfo.name+" 已经移除.");
		}
		
		/**
		 * 判断是否包含模块
		 * @param entityModle
		 * @return 
		 * 
		 */		
		public function containsModule(name:String):Boolean
		{
			return  _modBeansVector.some(function (item:*, index:int, vectory:Vector.<IModuleBeanInfo>):Boolean {
				if(name == item["name"])
					return true;
				else 
					return false;
			}, null);
		}

		
		/**
		 * 立即更新视图显示列表
		 * 
		 */		
		public function updateModuleDisplay():void
		{
			if(_modBeansVector.length==0)return;
			for each(var modBeanInfo:ModuleBeanInfo in _modBeansVector)
			{
				if(modBeanInfo.moduleInfo!=null && modBeanInfo.moduleInfo.module!= null)
				{
					if(modBeanInfo.moduleInfo.module.hasOwnProperty("stageResize"))
					{
						modBeanInfo.moduleInfo.module["stageResize"](ApplicationGlobals.application.stage.stageWidth,ApplicationGlobals.application.stage.stageHeight);
					}
					
					if(modBeanInfo.fixed)
						LayoutManager.setRelativePosition(modBeanInfo.moduleInfo.module,ApplicationGlobals.application.measuredWidth,ApplicationGlobals.application.measuredHeight,modBeanInfo.center,modBeanInfo.middle,modBeanInfo.top,modBeanInfo.left,modBeanInfo.bottom,modBeanInfo.right);
					else
						LayoutManager.setRelativePosition(modBeanInfo.moduleInfo.module,ApplicationGlobals.application.stage.stageWidth,ApplicationGlobals.application.stage.stageHeight,modBeanInfo.center,modBeanInfo.middle,modBeanInfo.top,modBeanInfo.left,modBeanInfo.bottom,modBeanInfo.right);
				}
			}
		}
		
		/*******************************************************************************************
		/*******************************************************************************************
		 * Private method
		 * *****************************************************************************************/
		/**
		 * 模块配置文件加载成功
		 * 开始解析配置文件，并开始下载模块
		 * @param data
		 * 
		 */		
		private function modulesConfigSuccess(data:Object):void
		{
			//log
			Log.getLogger(this).info("[ModuleConfig] 模块配置文件加载成功.");
			var modulesXmlInfo:XMLList = XML(data).children();
			if(modulesXmlInfo.length()==0)
			{
				//log
				Log.getLogger(this).warn("[ModuleConfig] 模块配置文件为空.");
				return;
			}
			 for each(var modXML:XML in modulesXmlInfo)
			 {
				 var modBeanInfo:ModuleBeanInfo = new ModuleBeanInfo(modXML.@name,modXML.@add,modXML.@load,modXML.@fiexd,modXML.@interactive);
				 
				 if(modXML.attribute("delayLoad").length())
					 modBeanInfo.delayLoad = Number(modXML.@delayLoad);
					 
				 if(modXML.attribute("center").length())
					 modBeanInfo.center = Number(modXML.@center);
				 else if(modXML.attribute("left").length())
					 modBeanInfo.left = Number(modXML.@left);
				 else if(modXML.attribute("right").length())
					 modBeanInfo.right = Number(modXML.@right);
				 
				 if(modXML.attribute("middle").length())
					 modBeanInfo.middle = Number(modXML.@middle);
				 else if(modXML.attribute("top").length())
					 modBeanInfo.top = Number(modXML.@top);
				 else if(modXML.attribute("bottom").length())
					 modBeanInfo.bottom = Number(modXML.@bottom);
				 
				 //存储到数组
				 _modBeansVector.push(modBeanInfo);
			 }
			 //添加监听器
			 ApplicationGlobals.application.getEventDispatcher().addEventListener(ModuleEvent.READY,moduleReadyHandler);
			 ApplicationGlobals.application.getEventDispatcher().addEventListener(ModuleEvent.ERROR,moduleReadyHandler);
			 //转发配置加载完成
			 ApplicationGlobals.application.getEventDispatcher().dispatchEvent(ManagerEvent.createEvent(ManagerEvent.MODULE_CONF_COMPLETE));
		}
		
		/**
		 * 是否有自动下载且没有下载的模块
		 * @return 
		 * 
		 */		
		private var _modBeanInfo:IModuleBeanInfo;
		private function search():IModuleBeanInfo
		{
			_modBeanInfo = null;
			for each(var modBeanInfo:ModuleBeanInfo in _modBeansVector)
			{
				if(modBeanInfo.load && !modBeanInfo.moduleInfo.loaded)
				{
					_modBeanInfo = modBeanInfo;
					break;
				}
			}
			return _modBeanInfo;
		}
		/**
		 * 加载模块 
		 * @param index
		 * 
		 */				
		private function loadModule():void
		{
			if(search()==null){
				//模块全部加载完成
				ApplicationGlobals.application.getEventDispatcher().dispatchEvent(ManagerEvent.createEvent(ManagerEvent.MODULE_LOAD_COMPLETE));
				return;
			}
			if(_stopLoadName == _modBeanInfo.name)
			{
				//log
				Log.getLogger(this).info("[Module] " + _stopLoadName + " 已停止模块加载.");
				return;
			}
			//开始下载模块
			var modUrl:String = _modBeanInfo.name;
			if(modUrl.indexOf(".swf")==-1)modUrl+=".swf";
			_modBeanInfo.moduleInfo =  ModuleManager.getModule(modUrl);
			/** 延迟加载模块 **/
			if(_modBeanInfo.delayLoad && _modBeanInfo.delayLoad>0)
				ApplicationGlobals.application.getTickerLaunch().newTimerTicker(_modBeanInfo.delayLoad*1000,1,null,function timerCompleteHandler():void
				{
					_modBeanInfo.moduleInfo.load();
				});
			else
				_modBeanInfo.moduleInfo.load();
		}

		/**
		 * 模块加载完成 
		 * @param event
		 * 
		 */		
		private function moduleReadyHandler(event:ModuleEvent):void
		{
			if(_modBeanInfo.add)
				this.addModuleByInfo(_modBeanInfo);
			/** 关闭模块鼠标交互 **/
			if(!_modBeanInfo.interactive && _modBeanInfo.moduleInfo.module is Sprite)
			{
				(_modBeanInfo.moduleInfo.module as Sprite).mouseChildren=false;
				(_modBeanInfo.moduleInfo.module as Sprite).mouseEnabled=false;
			}
			/** 更新模块视图布局 **/
			updateModuleDisplay();
			/**继续加载模块**/
			if(_allAuto)
			loadModule();
		}
		
		public function addModuleByInfo(modBeanInfo:IModuleBeanInfo):void
		{
			if(modBeanInfo.moduleInfo.module == null)return;
			if(modBeanInfo.fixed && !AMGlobals.acm.measureContainer.contains(modBeanInfo.moduleInfo.module))
				AMGlobals.acm.measureContainer.addChild(modBeanInfo.moduleInfo.module);
			else if(!AMGlobals.acm.windowContainer.contains(modBeanInfo.moduleInfo.module))
				AMGlobals.acm.windowContainer.addChild(modBeanInfo.moduleInfo.module);
			//调用模块startup
			if(modBeanInfo.moduleInfo.module.hasOwnProperty("startUp"))
				modBeanInfo.moduleInfo.module["startUp"]();
		}
		
		/**
		 * 
		 * @param error
		 * 
		 */		
		private function modulesConfigFail(error:Error):void
		{
			//log
			Log.getLogger(this).error("[ModulePath] 下载视图配置文件失败. error：" + error.message);
		}
	}
}
import com._17173.framework.core.manager.IModuleBeanInfo;
import com._17173.framework.core.module.IModuleInfo;

class ModuleBeanInfo implements IModuleBeanInfo
{
	
	public function ModuleBeanInfo(name:String,add:Boolean,load:Boolean,fiexd:Boolean,interactive:Boolean)
	{
		_name = name;
		_add = add;
		_load = load;
		_fixed = fixed;
		_interactive = interactive;
	}
	private var _name:String;
	public function get name():String
	{
		return _name;
	}
	private var _add:Boolean;
	public function get add():Boolean
	{
		return _add;
	}
	private var _load:Boolean;
	public function get load():Boolean
	{
		return _load;
	}
	private var _fixed:Boolean;
	public function get fixed():Boolean
	{
		return _fixed;
	}
	private var _interactive:Boolean;
	public function get interactive():Boolean
	{
		return _interactive;
	}
	private var _delayLoad:Number;
	public function get delayLoad():Number
	{
		return _delayLoad;
	}
	
	public function set delayLoad(value:Number):void
	{
		_delayLoad = value;
	}
	
	private var _center:Number;
	public function get center():Number
	{
		return _center;
	}
	
	public function set center(value:Number):void
	{
		_center = value;
	}
	private var _middle:Number;
	public function get middle():Number
	{
		return _middle;
	}
	
	public function set middle(value:Number):void
	{
		_middle = value;
	}
	
	private var _top:Number;
	public function get top():Number
	{
		return _top;
	}
	
	public function set top(value:Number):void
	{
		_top = value;
	}
	private var _bottom:Number;
	public function get bottom():Number
	{
		return _bottom;
	}
	
	public function set bottom(value:Number):void
	{
		_bottom = value;
	}
	
	private var _left:Number;
	public function get left():Number
	{
		return _left;
	}
	
	public function set left(value:Number):void
	{
		_left = value;
	}
	private var _right:Number;
	public function get right():Number
	{
		return _right;
	}
	
	public function set right(value:Number):void
	{
		_right = value;
	}
	
	private var _module:IModuleInfo;
	public function get moduleInfo():IModuleInfo
	{
		return _module;
	}
	public function set moduleInfo(module:IModuleInfo):void
	{
		_module = module;
	}
}