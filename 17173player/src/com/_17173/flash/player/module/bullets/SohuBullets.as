package com._17173.flash.player.module.bullets
{
	import com._17173.flash.core.base.StageIniator;
	import com._17173.flash.core.util.JSBridge;
	import com._17173.flash.core.util.SimpleObjectPool;
	import com._17173.flash.core.util.time.Ticker;
	import com._17173.flash.player.module.bullets.base.Bullet;
	import com._17173.flash.player.module.bullets.base.BulletData;
	import com._17173.flash.player.module.bullets.base.BulletLine;
	
	import flash.display.Sprite;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	
	/**
	 * 弹幕. 
	 * @author shunia-17173
	 */	
	public class SohuBullets extends StageIniator
	{
		/**
		 * 版本号 
		 */		
		protected var _version:String = "1.0.1";
		/**
		 * 弹幕字幕层 
		 */		
		private var _layer:Sprite = null;
		/**
		 * 当前剩下还未被显示的弹幕 
		 */		
		private var _bullets:Array = null;
		/**
		 * 正在显示中的弹幕 
		 */		
		private var _showedBullets:Array = null;
		/**
		 * 当前正在使用中的横线 
		 */		
		private var _lines:Array = null;
		/**
		 * 弹幕的开关标志位 
		 */		
		private var _isOn:Boolean = false;
		/**
		 * 当前允许的最大弹幕行数 
		 */		
		private var _maxLine:int = 0;
		/**
		 * 每一排的默认高度,在弹幕不允许调整字体大小的情况下,使用这个数字来静态计算高度 
		 */		
		private var _defaultLineHeight:int = 30;
		
		public function SohuBullets()
		{
			super(true);
		}
		
		protected function showVersion():void {
			var c:ContextMenu = new ContextMenu();
			var i:ContextMenuItem = new ContextMenuItem("17173 弹幕 版本: " + _version, false, false);
			c.hideBuiltInItems();
			c.customItems = [];
			c.customItems.push(i);
			this.contextMenu = c;
		}
		
		override protected function init():void {
			super.init();
			
			JSBridge.defaultNameSpace = loaderInfo.parameters.objectName;
			Ticker.init(stage);
			
			showVersion();
			//弹幕层
			_layer = new Sprite();
			_layer.name = "bullet";
			_layer.mouseChildren = false;
			_layer.mouseEnabled = false;
			
			isOn = true;
			
			_lines = [];
			_bullets = [];
			_showedBullets = [];
			
			//收到js消息有弹幕
			JSBridge.addCall("setMsg", null, null, onGetMessage, true);
			//清空弹幕
			JSBridge.addCall("clearMsg", null, null, onClearMessage, true);
			
			Ticker.tick(1, update, 0, true);
			
			initFaceManager();
		}
		/**
		 *初始化表情替换 
		 * 
		 */		
		private function initFaceManager():void{
			//关闭表情
			BulletFaceManager.getInstance().faceSwitch = false;
		}
		
		protected function onGetMessage(arr:Array):void {
			isOn = true;
			if (isOn) {
				for each (var obj:Object in arr) {
					addBullet(BulletData.fromObject(obj));
				}
			}
		}
		
		protected function onClearMessage():void {
			isOn = false;
		}
		
		/**
		 * 发送弹幕 
		 * @param bullet
		 */		
		public function sendBullet(bullet:BulletData):void {
			//将获得的消息发送给js,并通过聊天代理转发到后台
			JSBridge.addCall("setMsg", bullet.toObject());
		}
		
		/**
		 * 接收弹幕 
		 * @param arr
		 */		
		public function receiveBullet(arr:Array):void {
			for each (var bd:BulletData in arr) {
				addBullet(bd);
			}
		}
		
		/**
		 * 通过数据添加弹幕项
		 *  
		 * @param data
		 */		
		private function addBullet(data:BulletData):void {
			var bullet:Bullet = SimpleObjectPool.getPool(Bullet).getObject() as Bullet;
			bullet.init(data);
			_bullets.push(bullet);
			
			if (data.isSteady) {
				bullet.x = data.steadyX;
				bullet.y = data.steadyY;
			} else {
				bullet.x = stage.stageWidth;
				var line:BulletLine = getLine();
				if (line) {
					bullet.y = line.line * bullet.height + 2;
					//					bullet.y = 0;
					line.setOccupation(bullet);
					bullet.lineIndex = line.line;
				}
			}
		}
		
		protected function update():void {
			if (_layer == null || _layer.parent == null) return;
			
			var bullet:Bullet = null;
			if (_bullets && _bullets.length > 0) {
				bullet = _bullets.shift();
				_showedBullets.push(bullet);
			}
			var len:int = _showedBullets.length;
			while (len > 0) {
				bullet = _showedBullets[len - 1];
				if (!_layer.contains(bullet)) {
					_layer.addChild(bullet);
				}
				//				bullet.update();
				//检查当前横向上是否已经无法塞入弹幕了
				checkLineOccupation(bullet);
				//检查弹幕是否可以移除,一个个筛选当前队列里的弹幕
				if (checkBulletRemove(bullet)) {
					len = _showedBullets.length;
				} else {
					len --;
				}
			}
		}
		
		/**
		 * 移除弹幕
		 *  
		 * @param bullet
		 * @return 
		 */		
		private function checkBulletRemove(bullet:Bullet):Boolean {
			if (bullet.isTimeToDisappear) {
				//移除显示对象
				if (_layer.contains(bullet)) {
					_layer.removeChild(bullet);
				}
				//从队列里移除
				_showedBullets.splice(_showedBullets.indexOf(bullet), 1);
				//return到pool里
				SimpleObjectPool.getPool(BulletData).returnObject(bullet.bulletData);
				SimpleObjectPool.getPool(Bullet).returnObject(bullet);
				return true;
			}
			return false;
		}
		
		/**
		 * 检查弹幕是否已经移出当前这条线上了
		 * 当一条弹幕的尾部超过屏幕右侧的时候,则认为该条弹幕已经移出这条线,这条线的occupation为false
		 *  
		 * @param bullet
		 */		
		private function checkLineOccupation(bullet:Bullet):void {
			var line:BulletLine = getLineByIndex(bullet.lineIndex);
			if (line && line.isBulletOccupationed(bullet) && bullet.x <= (stage.stageWidth - bullet.width - 30)) {
				line.getOccupation(bullet);
				bullet.lineIndex = -1;
			}
		}
		
		/**
		 * 或者一个横向的line,用来放入bullet
		 *  
		 * @return 
		 */		
		private function getLine():BulletLine {
			var line:BulletLine = null;
			for each (var bulletLine:BulletLine in _lines) {
				if (bulletLine.isOccupation == false) {
					line = bulletLine;
					break;
				}
			}
			if (!line && _lines.length * _defaultLineHeight < stage.stageHeight) {
				line = new BulletLine();
				line.line = _lines.length;
				_lines.push(line);
			}
			return line;
		}
		
		/**
		 * 通过index获取line
		 *  
		 * @param index
		 * @return 
		 */		
		private function getLineByIndex(index:int):BulletLine {
			if (index > -1 && _lines.length > index) {
				return _lines[index];
			} else {
				return null;
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
			if (_isOn) {
				if (_layer && !_layer.parent) {
					stage.addChild(_layer);
				}
			} else {
				if (_layer && _layer.parent) {
					_layer.parent.removeChild(_layer);
					
					SimpleObjectPool.getPool(Bullet).destroyAll();
					SimpleObjectPool.getPool(BulletData).destroyAll();
					_showedBullets = [];
					_bullets = [];
					_lines = [];
					
					while (_layer.numChildren) {
						_layer.removeChildAt(0);
					}
				}
			}
		}
		
		public function get skinObject():Object {
			return {
				"switcher":mc_bulletSwitcher, 
				"bg":mc_streamBG, 
				"sendBtn":mc_startSendBulletBtn, 
				"input":mc_userInput
			};
		}
		
	}
}
