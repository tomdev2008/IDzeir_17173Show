package com._17173.flash.show.base.module.animation.biganimation
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.show.base.module.animation.base.AnimationType;
	import com._17173.flash.show.base.module.animation.base.BaseAmtControl;
	import com._17173.flash.show.base.module.animation.base.IAnimactionLayer;
	import com._17173.flash.show.base.module.animation.base.IAnimationPlay;
	import com._17173.flash.show.model.CEnum;
	import com._17173.flash.show.model.SEvents;
	
	public class BigAmtControl extends BaseAmtControl
	{
		public function BigAmtControl(type:String, parentLayer:IAnimactionLayer)
		{
			super(type, parentLayer);
		}
		
		/**
		 *清理数据时判断如果是鲜花动画则派发小花动画 
		 * 
		 */		
		override protected function clearDatas():void{
			var len:int = _datas.length;
			var data:IAnimationPlay;
			var arr:Array = [];
			//直接添加当前展示的大花动画
			if(_cPlayData && _cPlayData.data && _cPlayData.type == AnimationType.ATYPE_FLOWER){
				_cPlayData.data.giftCount = 1;
				arr[0] = _cPlayData.data;
			}
			//移除当前播放数据
			if (_cPlayData) {
				_cPlayData.remove();
				_cPlayData = null;
			}
			//检测剩余其他数据
			for (var i:int = 0; i < len; i++) 
			{
				data = _datas[i];
				if(data){
					//清空数据时如果判断是大花动画则派发显示小花数据;
					if(data.type == AnimationType.ATYPE_FLOWER){
						data.data.giftCount = 1;
						arr[arr.length] = data.data;
					}
					data.remove();
				}
			}
			
			if(arr && arr.length>0){
				len = arr.length;
				//判断如果数量大于12个则只保留最后12个，因为舞台只能显示小花12个
				if(len > 12){
					arr = arr.slice(len - 12,len);
				}
				//派发显示小花事件(该事件不执行动画)
				Context.getContext(CEnum.EVENT).send(SEvents.GIFT_ANIMATION_HX,arr);
			}
			_datas = [];
		}
		
	}
}