package com._17173.flash.show.base.module.scene
{
	import com._17173.flash.core.context.Context;
	
	import flash.display.DisplayObject;
	import flash.utils.getQualifiedClassName;

	/**
	 * 场景位置信息.
	 *  
	 * @author shunia-17173
	 */	
	public class SceneElement
	{
		
		public static const SCENE_WIDTH:int = 1920;
		public static const SCENE_HEIGHT:int = 1000;
		
		private static const SCENE_MIN_WIDTH:int = 1000;
		private static const SCENE_MIN_HEIGHT:int = 740;
		
		private var _isAbsolute:Boolean = false;
		private var _top:int = -1;
		private var _bottom:int = -1;
		private var _left:int = -1;
		private var _right:int = -1;
		private var _id:String = null;
		private var _name:String = null;
		private var _content:DisplayObject = null;
		private var _pos:Object = null;
		private var _configKey:String;
		
		public function SceneElement()
		{
		}

		public function get configKey():String
		{
			return _configKey;
		}

		public function set configKey(value:String):void
		{
			_configKey = value;
		}
		
		/**
		 * 内部方法,用于根据配置文件生成scenepos配置.
		 *  
		 * @param conf
		 * @return 
		 */		
		internal static function wrapConf(conf:Object):SceneElement {
			var s:SceneElement = new SceneElement();
			for (var key:String in conf) {
				if (s.hasOwnProperty(key)) {
					s[key] = conf[key];
				}
			}
			return s;
		}

		/**
		 * 内部方法用于整合位置信息并提供封装数据.
		 *  
		 * @return 
		 */		
		internal function getPos():Object {
			if (!_pos) _pos = {};
			
			var baseWidth:int = isAbsolute ? SceneElement.SCENE_WIDTH : Context.stage.stageWidth;
			var baseHeight:int = isAbsolute ? SceneElement.SCENE_HEIGHT : Context.stage.stageHeight;

			if (_left >= 0) {
				_pos.x = _left;
			} else if (_right >= 0) {
				_pos.x = baseWidth - _right;
			} else {
				_pos.x = 0;
			}
			
			if (_top >= 0) {
				_pos.y = _top;
			} else if (_bottom >= 0) {
				_pos.y = baseHeight - _bottom;
			} else {
				_pos.y = 0;
			}
			return _pos;
		}

		/**
		 * 为true时是绝对坐标,false是相对坐标. 
		 */
		public function get isAbsolute():Boolean
		{
			return _isAbsolute;
		}

		/**
		 * @private
		 */
		public function set isAbsolute(value:Boolean):void
		{
			_isAbsolute = value;
		}

		/**
		 * 相对场景顶部的位置 
		 */
		public function get top():int
		{
			return _top;
		}

		/**
		 * @private
		 */
		public function set top(value:int):void
		{
			_top = value;
		}

		/**
		 * 相对场景底部的位置 
		 */
		public function get bottom():int
		{
			return _bottom;
		}

		/**
		 * @private
		 */
		public function set bottom(value:int):void
		{
			_bottom = value;
		}

		/**
		 * 相对场景左侧的位置 
		 */
		public function get left():int
		{
			return _left;
		}

		/**
		 * @private
		 */
		public function set left(value:int):void
		{
			_left = value;
		}

		/**
		 * 相对场景右侧的位置 
		 */
		public function get right():int
		{
			return _right;
		}

		/**
		 * @private
		 */
		public function set right(value:int):void
		{
			_right = value;
		}

		/**
		 * 指定的显示对象的id,作为一个代号 
		 */
		public function get id():String
		{
			return _id;
		}

		/**
		 * @private
		 */
		public function set id(value:String):void
		{
			_id = value;
		}
		
		/**
		 *显示对象 
		 * @return 
		 * 
		 */		
		public function get content():DisplayObject
		{
			return _content;
		}
		
		public function set content(value:DisplayObject):void
		{
			_content = value;
			var tmpStr:String = getQualifiedClassName(_content);
			if(tmpStr.indexOf("::") > 0){
				_configKey = tmpStr.split("::")[1];
			}else{
				_configKey = tmpStr;
			}
		}

		/**
		 * 控件在显示对象列表里的名字 
		 */
		public function get name():String
		{
			return _name;
		}

		/**
		 * @private
		 */
		public function set name(value:String):void
		{
			_name = value;
		}

	}
}