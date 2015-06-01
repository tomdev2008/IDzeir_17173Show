package com._17173.flash.player.module.bullets
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.core.skin.ISkinObject;
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.core.util.time.Ticker;
	import com._17173.flash.player.context.ContextEnum;
	import com._17173.flash.player.module.bullets.base.BulletConfig;
	import com._17173.flash.player.module.bullets.base.BulletData;
	import com._17173.flash.player.module.bullets.base.BulletLayer;
	import com._17173.flash.player.module.bullets.fixure.FixureBottomBulletLayer;
	import com._17173.flash.player.module.bullets.fixure.FixureBulletLayer;
	import com._17173.flash.player.ui.comps.SkinsEnum;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * 弹幕. 
	 * @author shunia-17173
	 */	
	public class Bullets extends Sprite
	{
		/**
		 * 版本号 
		 */		
		protected var _version:String = "";
		
		public static const TOOL_TIP_SUCCESS:Array = ["弹幕发送成功"];
		
		/**
		 * UI
		 */	
		protected var _ui:BulletUI = null;
		/**
		 * 弹幕的开关标志位 
		 */		
		private var _isOn:Boolean = false;
		/**
		 * 是否默认添加UI,为站外弹幕接口提供 
		 */		
		protected var _addUIDefault:Boolean = true;
		/**
		 * 是否还不允许显示弹幕 
		 */		
		protected var _blockShowBullets:Boolean = true;
		/**
		 * 被缓存下来的弹幕数据,需要随后显示 
		 */		
		protected var _blockedBullets:Array = null;
		/**
		 *弹幕层 
		 */		
		protected var _layers:Array;
		
		public function Bullets()
		{
			_version = "1.1.3";
			init();
		}
		
		protected function showVersion():void {
			Debugger.log(Debugger.INFO, "[bullet]", "弹幕模块[版本:" + _version + "]初始化!");
		}
		
		protected function init():void {
			showVersion();
			
			_layers = [];
			_layers.push(new BulletLayer());
			isOn = true;
			_blockedBullets = [];
			//ui
			if (_addUIDefault) {
				addToBar();
			}
			
			//监听JS消息
			Context.getContext(ContextEnum.JS_DELEGATE).listen("setMsg", onGetMessage);
			initFaceManager();
			addLsn();
			
			/**
			 * 更新机制
			 */
			Ticker.tick(1, update, 0, true);
//			Ticker.tick(1000, test, 0);
		}
		
		private function initFaceManager():void{
			BulletFaceManager.getInstance().faceSwitch = true;
		}
		
		protected function onGetMessage(arr:Array):void {
			if (isOn) {
				if (_blockShowBullets) {
					_blockedBullets = _blockedBullets.concat(arr);
				} else {
					for each (var obj:Object in arr) {
						addBullet2Layer(BulletData.fromObject(obj));
					}
				}
			}
		}
		
		protected function update():void {
			if (_blockShowBullets && Context.variables.hasOwnProperty("ADPlayComplete") && Context.variables["ADPlayComplete"]) {
				onStartShowBullets();
			}
			var len:int = _layers.length;
			var layer:BulletLayer;
			for (var i:int = 0; i < len; i++) 
			{
				layer = _layers[i] as BulletLayer;
				layer.update()
			}
		}
		
		/**
		 *添加监听 
		 */		
		private function addLsn():void {
			var eManager:IEventManager = Context.getContext(ContextEnum.EVENT_MANAGER) as IEventManager;
			Context.stage.addEventListener(Event.RESIZE, onResize);
		}
		
		/**
		 *移除监听 
		 */		
		private function removeLsn():void {
			var eManager:IEventManager = Context.getContext(ContextEnum.EVENT_MANAGER) as IEventManager;
			Context.stage.removeEventListener(Event.RESIZE, onResize);
		}
		
		/**
		 * 这是一个弹幕测试方法
		 */
		private var count:int = 0;
		private var count1:int = 0;
		private var count2:int = 0;
		private function test():void {
			var keyStrArray:Array = [
				"820","bbC","笨哥","单车","F91","海涛","JOY","老杨",
				"MISS","淑仪","小色","ZhOU","dC","PIS","小悠","BURNING","发来贺电",
				"gg","哈哈","好演员","牛x","longdd","2009","老鼠","17173"];
			if (Math.random()  > 0) {
				for (var i:int = 21; i<25; i++) {
					var keyString:String = keyStrArray[i%25] + keyStrArray[(i+1)%25] + keyStrArray[(i+2)%25];
					onGetMessage([{masterNick:"&lt;820",toMasterNick:"820","content":keyString + "&lt;<我爱你们"+(count++),"style":Math.random()*0xffffff+"#b#s#l#"+(Math.random()*21+14)+"#b#s#l#"+"bullettype_"+2}
						,{"content":"longdd 2009 老鼠 17173"+(count++),"style":Math.random()*0xffffff+"#b#s#l#"+(Math.random()*21+14)+"#b#s#l#"+"bullettype_"+2}
					]);
				}
			}
		}
		
		private function onStartShowBullets():void {
			_blockShowBullets = false;
			if (isOn) {
				onGetMessage(_blockedBullets);
			}
			_blockedBullets = null;
		}
		
		private function onResize(e:Event):void{
			var len:int = _layers.length;
			var layer:BulletLayer;
			for (var i:int = 0; i < len; i++) 
			{
				layer = _layers[i] as BulletLayer;
				layer.resize();
			}
		}
		
		/**
		 * 通过数据添加弹幕项
		 *  
		 * @param data
		 */		
		private function addBullet2Layer(data:BulletData):void {
			var type:String = data.type;
			//根据弹幕类型判断，放入对应层级
			var len:int = _layers.length;
			var layer:BulletLayer;
			var added:Boolean = false;
			for (var i:int = 0; i < len; i++) 
			{
				layer = _layers[i] as BulletLayer;
				//找数据对应的层级
				if (layer.checkBulltTypeOwnLayer(data.type)){
					layer.addBullet(data);
					added = true;
					break;
				}
			}
			if(!added){
				//如果该层级没有，则创建
				layer = createLayerByType(data.type);
				layer.addBullet(data);
			}
		}
		
		/**
		 *创建对应类型层 
		 * @param type
		 * @return 
		 * 
		 */		
		private function createLayerByType(type:String):BulletLayer{
			var bl:BulletLayer;
			switch (type)
			{
				case BulletConfig.BULLETTYPE_FIXURE_TOP:
				{
					bl = new FixureBulletLayer();	
					break;
				}
					
				case BulletConfig.BULLETTYPE_FIXURE_BOTTOM:
				{
					bl = new FixureBottomBulletLayer();	
					break;
				}
					
				default:
				{
					bl = new BulletLayer();
					break;
				}
			}
			
			_layers[_layers.length] = bl;
			updateView();
			return bl;
		}
		
		
		public function addToBar():void {
			var controlBar:ISkinObject = Context.getContext(ContextEnum.SKIN_MANAGER).getSkin(SkinsEnum.CONTROL_BAR);
			if (!_ui) {
			_ui = new BulletUI(this);
			_ui.name = "bullet";
			}
			controlBar.call("addItem", _ui);
		}
		
		/**
		 * 发送弹幕 
		 * @param bullet
		 */		
		public function sendBullet(bullet:BulletData):void {
				Context.getContext(ContextEnum.JS_DELEGATE).send("setMsg", bullet.toObject());
		}
		
		/**
		 * 接收弹幕 
		 * @param arr
		 */		
		public function receiveBullet(arr:Array):void {
			for each (var bd:BulletData in arr) {
				addBullet2Layer(bd);
			}
		}
		
		

		public function get isOn():Boolean {
			return _isOn;
		}

		public function set isOn(value:Boolean):void {
			_isOn = value;
			updateView();
		}
		
		private function updateView():void {
			var layer:BulletLayer;
			var len:int = _layers.length;
			for (var i:int = 0; i < len; i++) 
			{
				layer = _layers[i];
				if (_isOn) {
					if (layer && !layer.parent) {
						//添加时，需要添加到指定层级，以防止弹幕层会盖住其他组件
						var ui:Object = Context.getContext(ContextEnum.UI_MANAGER);
						var cl:Sprite = ui.getLayer("componenbefer");
						cl.addChild(layer);
					}
				} else {
					if (layer && layer.parent) {
						layer.destroy();
					}
				}
			}
		}
		
		public function get skinObject():Object {
			return {
				"switcher":mc_bulletSwitcher, 
				"bg":mc_streamBG, 
				"sendBtn":mc_sendBulletBtn, 
				"input":mc_userInput,
				"setBtn":mc_setingBtn
			};
		}
		
		override public function set visible(value:Boolean):void {
			if (_ui) {
				_ui.visible = value;
			}
		}
		
	}
}