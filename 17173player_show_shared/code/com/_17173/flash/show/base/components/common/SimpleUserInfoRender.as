package com._17173.flash.show.base.components.common
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.components.interfaces.IItemRender;
	import com._17173.flash.show.base.context.user.IUser;
	import com._17173.flash.show.base.context.user.IUserData;
	import com._17173.flash.show.base.module.userCard.UserCardData;
	import com._17173.flash.show.base.utils.FontUtil;
	import com._17173.flash.show.base.utils.Utils;
	import com._17173.flash.show.model.CEnum;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.text.TextFormat;
	import com._17173.flash.core.components.common.HGroup;
	import com._17173.flash.core.components.common.VGroup;
	
	/** 
	 * @author idzeir
	 * 创建时间：2014-2-28  下午2:42:46
	 */
	public class SimpleUserInfoRender extends Sprite implements IItemRender
	{
		public var content:VGroup;
		protected var _richIcon:Sprite;
		protected var _starIco:Sprite;
		protected var _vipIcon:Sprite;
		
		protected var icoBox:HGroup;
		
		protected var nameBox:HGroup;
		
		public var overClip:Shape;
		
		private var nameLabel:AslTextField;
		
		private var idLabel:AslTextField;
		private var _hideVip:Boolean = true;
		
		private var _data:*;
		
		private const ICON_W:Number = 30;
		private const ICON_H:Number = 16;
		
		private const BASE_URL:String = "assets/img/level/";
		
		public function SimpleUserInfoRender()
		{
			overClip=new Shape();
		}
		
		public function reset():void
		{
			this.removeChildren();	
			content=new VGroup();
			content.gap=3;
			this.nameBox=new HGroup();
			nameLabel=new AslTextField(90);	
			idLabel=new AslTextField(90);
			icoBox=new HGroup();
			
			this._richIcon=new Sprite();;			
			this._starIco=new Sprite();;
			this._vipIcon = new Sprite();
			this._richIcon.width = this._starIco.width = 30;
			this._richIcon.height = this._starIco.height = 16;
			overClip.graphics.clear();
			//this.graphics.clear();
		}
		
		public function startUp(value:Object):void
		{			
			if(value==null){return};			
			this.reset();
			overClip.graphics.beginFill(0x22033c);
			overClip.graphics.drawRect(0, 0, 210, 46);
			overClip.graphics.endFill();			
			
			content.left=10;			
			this.nameBox.gap=5;
			
			this._data=value;
			nameLabel.textColor=0x63acff;
			nameLabel.defaultTextFormat=new TextFormat(FontUtil.f);
			nameLabel.text=value.name;			
			
			idLabel.textColor=0xe0d170;			
			idLabel.defaultTextFormat=new TextFormat(FontUtil.f);
			idLabel.text=value.masterNo;
			this.nameBox.addChild(nameLabel);
			this.nameBox.addChild(idLabel);			
			
			icoBox.graphics.beginFill(0x000000,0);
			icoBox.graphics.drawRect(0,0,40,16);
			icoBox.graphics.endFill();
			
			this._richIcon=Utils.getURLGraphic(BASE_URL+"cflv"+value.richLevel+".png", true, ICON_W, ICON_H) as Sprite;
			this.icoBox.addChild(this._richIcon);
			this._starIco=Utils.getURLGraphic(BASE_URL+"lv"+value.starLevel+".png", true, ICON_W, ICON_H) as Sprite;
			this.icoBox.addChild(this._starIco);
			if(!this._hideVip&&(value as IUserData).vip>0)
			{
				this._vipIcon = Utils.getURLGraphic(BASE_URL+"vip"+((value as IUserData).vip)+".png", true, 29, 12) as Sprite;
				this.icoBox.addChild(this._vipIcon);
			}
			
			this.content.addChild(nameBox);
			this.content.addChild(icoBox);
			this.addChild(content);
			
			this.mouseChildren=false;
			
			/*this.graphics.clear();
			this.graphics.beginFill(0xff0000,0);
			this.graphics.drawRect(0,0,200,46);
			this.graphics.endFill();*/
			
			content.y=(this.overClip.height-content.height)*.5-2;
		}
		
		public function set hideVip(bool:Boolean):void
		{
			this._hideVip = bool;
		}
		
		override public function get height():Number
		{
			return overClip.height;
		}
		
		public function set contentWidth(value:Number):void
		{
			if(this.idLabel.proText()=="")
			{
				this.nameLabel.showWidth=value;
			}else{
				this.nameLabel.showWidth=value*.5;
				this.idLabel.showWidth=value-this.nameLabel.width-15;
			}
			nameBox.update();
		}
		
		public function set onOver(bool:Boolean):void
		{
			if (bool)
			{
				this.addChildAt(overClip, 0);
			}
			else if (this.contains(overClip))
			{
				this.removeChild(overClip);
			}
		}
		
		public function onMouseOver():void
		{
			this.onOver=true;
			var stagePos:Point=this.localToGlobal(new Point(210+5,0));
			var hasUser:Boolean = (Context.getContext(CEnum.USER) as IUser).getUser(this._data.id) ? true : false;
			if(hasUser){
				//trace(this._data.sortNum);
				(Context.getContext(CEnum.USER) as IUser).showCard((this._data as IUserData).id, stagePos, [UserCardData.HIDE_MIC_LIST],false);
			}
		}
		
		public function onMouseOut():void
		{
			this.onOver=false;
			var hasUser:Boolean = (Context.getContext(CEnum.USER) as IUser).getUser(this._data.id) ? true : false;
			if(hasUser){
				//trace(this._data.sortNum);
				(Context.getContext(CEnum.USER) as IUser).autoHideCard();
			}
		}
		
		public function onSelected():void
		{	
			//trace(this._data.sortNum)
		}
		
		public function unSelected():void
		{
			
		}
	}
}