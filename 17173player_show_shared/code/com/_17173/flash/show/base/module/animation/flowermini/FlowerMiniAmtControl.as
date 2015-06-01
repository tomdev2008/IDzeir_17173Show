package  com._17173.flash.show.base.module.animation.flowermini
{
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.show.base.module.animation.base.AnimationObject;
	import com._17173.flash.show.base.module.animation.base.BaseAmtControl;
	import com._17173.flash.show.base.module.animation.base.IAnimactionLayer;
	import com._17173.flash.show.base.module.animation.extAnimation.FlowerMiniAnimation;
	
	/**
	 *小花动画控制器 
	 * @author zhaoqinghao
	 * 
	 */	
	public class FlowerMiniAmtControl extends BaseAmtControl
	{
		private var extDatas:Array;
		private var loaded:Boolean = false;
		public function FlowerMiniAmtControl(type:String, parentLayer:IAnimactionLayer)
		{
			super(type, parentLayer);
			extDatas = [];
		}
		
		/**
		 *添加回显数据 
		 * @param data
		 * 
		 */		
		public function addExtData(data:AnimationObject):void{
			extDatas[extDatas.length] = data;
			loadExtNext();
		}
		/**
		 *加载下一个回显 
		 * 
		 */		
		private function loadExtNext():void{
			if(extDatas.length > 0){
				var data:AnimationObject = extDatas[0];
				data.loadAnimation(loadExtCmp);
			}
		}
		/**
		 *加载完成后添加 
		 * 
		 */		
		private function loadExtCmp():void{
			var len:int = extDatas.length;
			var anm:AnimationObject;
			for (var i:int = 0; i < len; i++) 
			{
				var data:FlowerMiniAnimation = extDatas[i];
				if(data.loaded && data.mc){
					data.toStopEnd();
					(_parent as FlowerMiniLayer).addExtFlow(data);
					extDatas.splice(i,1);					
					break;
				}
				if(data.loaded && data.loadFail){
					extDatas.splice(i,1);					
					break;
				}
			}
			loadExtNext();
		}
	}
}