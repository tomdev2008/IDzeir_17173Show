package com._17173.flash.core.components.skin.skinclass
{
	import com._17173.flash.core.components.interfaces.ISkinClass;
	import com._17173.flash.core.components.interfaces.ISkinComponent;
	import com._17173.flash.core.components.skin.SkinManager;
	
	import flash.display.DisplayObject;
	import flash.utils.Dictionary;

	public class BaseSkinClass implements ISkinClass
	{
		/**
		 *skin类型，必须赋值
		 */
		protected var skinType:String = null;
		protected var changed:Boolean = false;
		protected var needChange:Boolean = false;
		protected var skinInfo:Object = null;
		protected var skinComponent:ISkinComponent = null;
		protected var skinState:Object = null;
		protected var skins:Dictionary = null;
		protected var bg:DisplayObject = null;

		public function BaseSkinClass(skinClassType:String, skinCpnt:ISkinComponent)
		{
			skins = new Dictionary();
			skinType = skinClassType;
			skinComponent = skinCpnt;
			init();
			addSkin2Manager();
		}

		/**
		 *设置默认皮肤数据
		 * 并且查看是否有背景字段
		 */
		private function init():void
		{
			if (skinType != null && skinInfo == null)
			{
				skinInfo = SkinManager.getInstance().getSkinByDef(skinType);
			}
			if (skinInfo && skinInfo.hasOwnProperty("bg"))
			{
				bg = skinInfo["bg"];
				this.addSkinUI("bg",bg);
			}
			onInitAdd();
			resize();
		}

		/**
		 *更新skinUI状态
		 *
		 */
		private function updateSkin():void
		{
			onUpdateState();
			onBgRender();
		}

		/**
		 *添加到管理器
		 *
		 */
		private function addSkin2Manager():void
		{
			SkinManager.getInstance().addManager(skinType, this);
		}

		/**
		 *从管理器移除
		 *
		 */
		private function removeSkin2Manager():void
		{
			SkinManager.getInstance().removeManger(skinType, this);
			onRemoveAllSkinUI(skinInfo);
		}

		/**
		 *外部更新skin状态
		 * @param state
		 *
		 */
		public function updateSkinState(state:Object):void
		{
			skinState = state;
			updateSkin();
		}

		/**
		 *添加皮肤到容器
		 * @param dis
		 *
		 */
		protected function addSkinUI(key:String,dis:DisplayObject,index:int = -1):void
		{
			skinComponent.addSkinUI(dis,index);
			skins[key] = dis;
		}

		/**
		 *从容器移除皮肤
		 * @param dis
		 *
		 */
		protected function removeSkinUI(key:String,dis:DisplayObject):void
		{
			var dobj:DisplayObject = skins[key] as DisplayObject;
			if(dobj){
				skinComponent.removeSkinUi(dobj);
				delete skins[key];
			}
		}

		/**
		 *初始化或者状态更新时皮肤状态更新
		 *
		 */
		protected function onUpdateState():void
		{

		}

		/**
		 *初始化并添加 子类复写
		 *
		 */
		protected function onInitAdd():void
		{

		}

		/**
		 *背景通用逻辑可复写
		 *
		 */
		protected function onBgRender():void
		{
			if (bg)
			{
				bg.width = skinComponent.getCompRect().width;
				bg.height = skinComponent.getCompRect().height;
			}
		}

		/**
		 *更换皮肤
		 * @param newSkin 皮肤对象键值<br>
		 * 在更换皮肤时，首先移除之前对应皮肤（如果存在的话），更换皮肤并执行初始化状态
		 */
		public function set skin(newSkin:Object):void
		{
			// TODO Auto Generated method stub
			onRemoveAllSkinUI(newSkin);
			changed = true;
			needChange = true;
			onChangeSkin(newSkin);
			updateInfo(newSkin);
			updateSkin();
			needChange = false;
			resize();
		}

		/**
		 *更换皮肤
		 * @param newSkin 皮肤对象键值<br>
		 * 在更换皮肤是，首先移除之前对应皮肤（如果存在的话），更换皮肤并执行初始化状态
		 */
		public function get skin():Object
		{
			return skinInfo;
		}

		/**
		 *获取类型
		 * @return
		 *
		 */
		public function get skinClassType():String
		{
			return skinType;
		}

		/**
		 *销毁
		 *
		 */
		public function destroySkin():void
		{
			removeSkin2Manager();
		}

		/**
		 *皮肤重定位
		 *
		 */
		public function rePostion():void
		{
			// TODO Auto Generated method stub

		}

		public function onHide():void
		{
			// TODO Auto Generated method stub

		}

		public function onShow():void
		{
			// TODO Auto Generated method stub

		}

		protected function onChangeSkin(skin:Object):void
		{
			// TODO Auto Generated method stub
			if (skin && skin.hasOwnProperty("bg"))
			{
				bg = skin["bg"];
				this.addSkinUI("bg",bg,0);
			}

		}

		/**
		 *移除所有UI
		 *
		 */
		protected function onRemoveAllSkinUI(newSkin):void
		{
			for(var key:String in newSkin) 
			{
				if(skins[key]){
					removeSkinUI(key,skins[key]);
				}
			}
			
		}
		/**
		 *设置大小 
		 * 
		 */		
		public function resize():void
		{
			// TODO Auto Generated method stub
			onBgRender();
		}
		/**
		 *更新新的皮肤到已有皮肤上 
		 * @param skin
		 * 
		 */		
		private function updateInfo(skin:Object):void{
			for(var key:String in skin) 
			{
				skinInfo[key] = skin[key];
			}
		}
		
	}
}
