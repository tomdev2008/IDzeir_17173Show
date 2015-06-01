package com._17173.flash.show.base.module.video.live
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.util.HtmlUtil;
	import com._17173.flash.show.base.components.common.AslTextField;
	import com._17173.flash.show.base.context.user.IUser;
	import com._17173.flash.show.base.module.video.base.OperationPanel;
	import com._17173.flash.show.base.utils.FontUtil;
	import com._17173.flash.show.model.CEnum;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class LiveVideoOperation extends Sprite
	{
		
		/**
		 * 坐标 
		 */		
		private var _pointArray1:Array = [698,69,521,391,10,367,422,365,1,352,519,38];
		private var _pointArray2:Array = [462,199,216,162,10,138,117,138,1,137,214,24];
		private var _pointArray3:Array = [1241,199,216,162,10,138,117,138,1,137,214,24];
		/**
		 * 麦序  
		 */		
		private var _micIndex:int = 1;
		/**
		 * 当前直播人的名字 
		 */		
		private var _userName:AslTextField = null;	
		/**
		 * 操作 
		 */		
		private var _oper:OperationPanel = null;
		
		private var _nameBg:LiveVideoNameBg = new LiveVideoNameBg();
		
		public function LiveVideoOperation(micIndex:int)
		{
			super();
			this._micIndex = micIndex;
			var textFormat:TextFormat = FontUtil.DEFAULT_FORMAT;
			textFormat.color = 0xd0cfcf;
			textFormat.size = 12;
			this.addChild(_nameBg);
			_nameBg.x = this["_pointArray"+micIndex][8];
			_nameBg.y = this["_pointArray"+micIndex][9];
			_nameBg.width = this["_pointArray"+micIndex][10];
			_nameBg.height = this["_pointArray"+micIndex][11];
			_userName = new AslTextField(90);
			_userName.defaultTextFormat = textFormat;
			_userName.autoSize = TextFieldAutoSize.LEFT;
			if((Context.variables.showData.order[micIndex] as Object) != null){
				_userName.text = HtmlUtil.decodeHtml((Context.variables.showData.order[micIndex] as Object).nickName);
			}else{
				_userName.text = "";
			}
			_userName.addEventListener(MouseEvent.CLICK,popUserCard);
			_userName.x = this["_pointArray"+micIndex][4];
			_userName.y = this["_pointArray"+micIndex][5];
			_userName.selectable = false;
			this.addChild(_userName);
			createOperation();
			this.x = this["_pointArray"+micIndex][0];
			this.y = this["_pointArray"+micIndex][1];
			
//			画圈
			this.graphics.beginFill(0x4700AD,1);
			this.graphics.drawRect(0,0,this["_pointArray"+micIndex][2],1);
			this.graphics.drawRect(0, this["_pointArray"+micIndex][3] -1 ,this["_pointArray"+micIndex][2],1);
			this.graphics.drawRect(0,1,1,this["_pointArray"+micIndex][3] -2 );
			this.graphics.drawRect(this["_pointArray"+micIndex][2]-1,1,1,this["_pointArray"+micIndex][3] -2);
			this.graphics.endFill();
		}
		
		/**
		 * 弹出用户选项卡 
		 * @param e
		 * 
		 */		
		private function popUserCard(e:MouseEvent):void{
			if(micIndex >=1 && micIndex <=3){
				if(_userName.text != ""){
					var stagePos:Point=this.localToGlobal(new Point(this._userName.width,this._userName.y));
					var order:Object = Context.variables.showData.order[micIndex];
					if(order){
						(Context.getContext(CEnum.USER) as IUser).showCard(order.masterId, stagePos);
					}
				}
			}
			e.stopPropagation();
		}
		
		public function get micIndex():int
		{
			return _micIndex;
		}

		private function createOperation():void{
			if(!_oper){
				_oper = new OperationPanel(micIndex);
			}
			if(!this.contains(_oper)){
				this.addChild(_oper);
			}
			_oper.x =  this["_pointArray"+micIndex][6];
			_oper.y =  this["_pointArray"+micIndex][7];
			this._oper.visible = true;
		}
		
		public function update():void{
			var order:Object = Context.variables.showData.order[micIndex];
			if(order){
				_userName.text = HtmlUtil.decodeHtml(order.nickName);
			}else{
				_userName.text = "";
			}
			_oper.update();
		}
	}
}