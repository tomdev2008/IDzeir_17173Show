package com._17173.flash.show.base.components.common
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.show.base.context.user.IUser;
	import com._17173.flash.show.base.context.user.IUserData;
	import com._17173.flash.show.base.utils.Utils;
	import com._17173.flash.show.model.CEnum;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import com._17173.flash.core.components.common.HGroup;
	
	/** 
	 * @author idzeir
	 * 创建时间：2014-2-28  下午4:01:17
	 */
	public class UserItemRender extends Sprite
	{
		protected var _head:Sprite;
		protected var _simpleRender:SimpleUserInfoRender;
		protected var _content:HGroup;
		
		protected var _headMask:Shape;
		
		protected var _isMasked:Boolean=false;
		
		private var _hideVip:Boolean = true;
		
		public function UserItemRender()
		{
			super();
			_content=new HGroup();
			
			_content.gap=3;
			
			_simpleRender=new SimpleUserInfoRender();			
			_head=new Sprite();
			_head.graphics.beginFill(0x000000,0);
			_head.graphics.drawRect(0,0,40,40);
			_head.graphics.endFill();
			
			_headMask=new Shape();
			_headMask.graphics.beginFill(0x000000);
			_headMask.graphics.drawCircle(0,0,17);
			_headMask.graphics.endFill();
			_headMask.x=(_head.width)*.5;
			_headMask.y=(_head.height)*.5+5;						
			this.addChild(_content);
			isMasked=true;
		}
		
		public function set user(value:IUserData):void
		{
			//_head.content=value.head;//"assets/img/face.jpg";
			_head.removeChildren();
			//if((Context.getContext(CEnum.USER) as IUser).me.id == value.id) Debugger.log(Debugger.INFO, "[userItem]", "自己头像地址:",value.head);
			_head.addChild(Utils.getURLGraphic(value.head, true, 40, 40));
			_head.graphics.clear();
			_content.addChild(_head);
			this._simpleRender.startUp(value);
			this._simpleRender.content.left=0;
			_simpleRender.contentWidth=120;
			_content.addChild(this._simpleRender);	
			_simpleRender.y = 1;
		}
		
		public function set hideVip(bool:Boolean):void
		{
			this._hideVip = bool;
			this._simpleRender.hideVip = bool;
		}
		
		public function set isMasked(bool:Boolean):void
		{
			_isMasked=bool;
			if(_isMasked)
			{
				_head.mask=_headMask;
				this.addChild(_headMask);
			}else{
				_head.mask=null;
				if(this.contains(_headMask))this.removeChild(_headMask);
			}
		}
	}
}