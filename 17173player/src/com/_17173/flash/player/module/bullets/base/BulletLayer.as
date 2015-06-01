package com._17173.flash.player.module.bullets.base
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.util.SimpleObjectPool;
	import com._17173.flash.player.context.ContextEnum;
	import com._17173.flash.player.model.PlayerType;
	import com._17173.flash.player.ui.comps.SkinsEnum;
	
	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 *弹幕层 
	 * @author zhaoqinghao
	 * 
	 */	
	public class BulletLayer extends Sprite
	{
		/**
		 * 当前允许的最大弹幕行数 
		 */		
		protected var _maxLine:int = 0;
		/**
		 * 每一排的默认高度,在弹幕不允许调整字体大小的情况下,使用这个数字来静态计算高度 
		 */		
		protected var _defaultLineHeight:int = 40;
		/**
		 * 当前正在使用中的横线 
		 */		
		protected var _lines:Array = null;
		/**
		 * 当前剩下还未被显示的弹幕 
		 */		
		protected var _bullets:Array = null;
		/**
		 * 正在显示中的弹幕 
		 */		
		protected var _showedBullets:Array = null;
		/**
		 *创建line时与stage高度的减量（以防止盖住其他ui） 
		 */		
		protected var _otherHeight:int = 80;
		/**
		 *是否启用覆盖line，当line已满并且不能塞入弹幕时，如果有弹幕数据过来是否先进先出取出line；
		 */		
		protected var _overrideLine:Boolean = true;
		/**
		 *可放置弹幕类型数组 
		 */		
		protected var _setBulletTypes:Array;
		public function BulletLayer()
		{
			super();
			mouseChildren = false;
			mouseEnabled = false;
			init();
		}
		
		
		protected function init():void{
			_lines = [];
			_bullets = [];
			_showedBullets = [];
			_setBulletTypes = [];
			initSetBullteTypes();
		}
		
		/**
		 *初始化放置类型 
		 * 
		 */		
		protected function initSetBullteTypes():void{
			_setBulletTypes[0] = BulletConfig.BULLETTYPE_NORMAL;
		}
		
		/**
		 * 通过index获取line
		 *  
		 * @param index
		 * @return 
		 */		
		protected function getLineByIndex(index:int):BulletLine {
			if (index > -1 && _lines.length > index) {
				return _lines[index];
			} else {
				return null;
			}
		}
		
		/**
		 *定位 
		 * 
		 */		
		protected function rePostion():void{
			//全屏下弹幕往下移动顶部栏的高度
			if (Context.getContext(ContextEnum.SETTING).isFullScreen) {
				this.y = Context.getContext(ContextEnum.SKIN_MANAGER).getSkin(SkinsEnum.FULLSCREEN_TOP_BAR).display.height;
			}
			 else {
				 if(Context.variables["type"] !=  PlayerType.S_ZHANNEI){
					this.y = 36;
				 }else{
					 this.y = 0;
				 }
			}
		}
		
		/**
		 *获取当前line的摆放高度高度 
		 * @param line
		 * 
		 */		
		protected function getCurrentLineHeight(line:BulletLine):int{
			var lHeight:int = 0;
			var len:int = _lines.length;
			var tLine:BulletLine;
			for (var i:int = 0; i < len; i++) 
			{
				tLine = _lines[i] as BulletLine;
				if(line === tLine){
					break;
				}
				lHeight += tLine.lineHeight;
			}
			return lHeight;
		}
		
		/**
		 * 移除弹幕
		 *  
		 * @param bullet
		 * @return 
		 */		
		protected function checkBulletRemove(bullet:Bullet):Boolean {
			if (bullet.isTimeToDisappear) {
				//移除显示对象
				if (this.contains(bullet)) {
					this.removeChild(bullet);
				}
				//从队列里移除
				_showedBullets.splice(_showedBullets.indexOf(bullet), 1);
				
				var line:BulletLine = getLineByIndex(bullet.lineIndex);
				if (line) 
				{
					line.getOccupation(bullet);
				}//line.getOccupation(bullet);
				//return到pool里
				SimpleObjectPool.getPool(BulletData).returnObject(bullet.bulletData);
				returnBullet(bullet);
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
		protected function checkLineOccupation(bullet:Bullet):void {
			var line:BulletLine = getLineByIndex(bullet.lineIndex);
			if (line && line.isBulletOccupationed(bullet) && bullet.x <= (Context.stage.stageWidth - bullet.width - 30)) {
				line.getOccupation(bullet);
				bullet.lineIndex = -1;
			}
		}
		
		/**
		 * 或者一个横向的line,用来放入bullet
		 *  
		 * @return 
		 */		
		protected function getLine():BulletLine {
			var line:BulletLine = null;
			for each (var bulletLine:BulletLine in _lines) {
				if (bulletLine.isOccupation == false) {
					line = bulletLine;
					break;
				}
			}
//			if (!line && _lines.length * _defaultLineHeight < Context.getContext(ContextEnum.UI_MANAGER).avalibleVideoHeight) {
			//是否可以创建新航，_defaultLineHeight默认行最大高度
			if (!line && ( getAllLineHeight() + _defaultLineHeight < (Context.stage.stageHeight - _otherHeight))) {
				line = new BulletLine();
				line.line = _lines.length;
				_lines.push(line);
			}
			
			if(line == null && _overrideLine){
//				var idx:int = Math.floor(Math.random() * _lines.length)
//				if(_lines[idx]){
//					line = _lines[idx];
//				}
			}
			resizeLine();
			return line;
		}
		
		/**
		 *获取所有弹幕line的总高度 
		 * @return 
		 * 
		 */		
		protected function getAllLineHeight():int{
			var lHeight:int = 0;
			var len:int = _lines.length;
			var tLine:BulletLine;
			for (var i:int = 0; i < len; i++) 
			{
				tLine = _lines[i] as BulletLine;
				lHeight += tLine.lineHeight;
			}
			return lHeight;
		}
		/**
		 *计算当前屏幕可显示行数,删除多余行。（不删除行当前滚动的字幕） 
		 * @return 
		 * 
		 */		
		protected  function resizeLine():int{
			var lHeight:int = 0;
			var len:int = _lines.length;
			var tLine:BulletLine;
			var faildLineIdx:int = len;
			//超找高度line下标
			for (var i:int = 0; i < len; i++) 
			{
				tLine = _lines[i] as BulletLine;
				lHeight += tLine.lineHeight;
				if(lHeight >= stage.stageHeight - _otherHeight){
					faildLineIdx = i;
					break;
				}
			}
			//删除所有超过的line
			var rcount:int = len - faildLineIdx;
			if(rcount > 0){
				while(rcount > 0){
					_lines.pop();
					rcount--;
				}
			}
			return lHeight;
		}
		/**
		 *设置弹幕初始位置 
		 * 
		 */		
		protected function initBulltePosition(bullet:Bullet,line:BulletLine):void{
			bullet.y = getCurrentLineHeight(line) + 2;
			bullet.x = stage.stageWidth;
		}
		
		/**
		 *检查是否可以放置次弹幕类型 
		 * @param type
		 * 
		 */		
		public function checkBulltTypeOwnLayer(type:String):Boolean{
			var result:Boolean = false;
			var len:int = _setBulletTypes.length;
			for (var i:int = 0; i < len; i++) 
			{
				if(type == _setBulletTypes[i]){
					result = true;
					break;
				}
			}
			return result;
		}
		
		public function resize(e:Event = null):void{
			resizeLine();
		}
		
		/**
		 *清理数据 
		 * 
		 */		
		public function clear():void{
			_lines = [];
			_bullets = [];
			_showedBullets = [];
			while (this.numChildren) {
				this.removeChildAt(0);
			}
		}
		
		/**
		 *销毁数据 
		 * 
		 */		
		public function destroy():void{
			clear();
			this.parent.removeChild(this);
			SimpleObjectPool.getPool(Bullet).destroyAll();
			SimpleObjectPool.getPool(BulletData).destroyAll();
			while (this.numChildren) {
				this.removeChildAt(0);
			}
		}
		
		
		public function update():void{
			rePostion();
			var bullet:Bullet = null;
			if (_bullets && _bullets.length > 0) {
				bullet = _bullets.shift();
				_showedBullets.push(bullet);
			}
			var len:int = _showedBullets.length;
			while (len > 0) {
				bullet = _showedBullets[len - 1];
				if (!this.contains(bullet)) {
					this.addChild(bullet);
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
		 *添加弹幕 
		 * @param data
		 * 
		 */		
		public function addBullet(data:BulletData):void{
			var bullet:Bullet = getBullet();
			if (data.isSteady) {
				bullet.x = data.steadyX;
				bullet.y = data.steadyY;
			} else {
				var line:BulletLine = getLine();
				if (line) {
					bullet.init(data);
					_bullets.push(bullet);
					initBulltePosition(bullet, line);
					line.setOccupation(bullet);
					bullet.lineIndex = line.line;
				}
			}
		}
		/**
		 *返回对象池 
		 * @param bullet
		 * 
		 */		
		protected function returnBullet(bullet:Bullet):void{
			SimpleObjectPool.getPool(Bullet).returnObject(bullet);
		}
		/**
		 *对象池取出 
		 * @return 
		 * 
		 */		
		protected function getBullet():Bullet{
			return SimpleObjectPool.getPool(Bullet).getObject() as Bullet;
		}
	}
}