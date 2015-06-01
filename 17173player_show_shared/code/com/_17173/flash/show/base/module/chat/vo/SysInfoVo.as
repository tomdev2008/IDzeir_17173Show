package com._17173.flash.show.base.module.chat.vo
{
	import com._17173.flash.show.base.utils.FontUtil;
	
	import flash.text.engine.GroupElement;
	import flash.text.engine.TextElement;

	/**
	 * 系统消息类
	 * @author idzeir
	 * 创建时间：2014-3-14  下午12:11:20
	 */
	public class SysInfoVo extends BaseChatVo
	{
		private var _link:String;
		private var _info:String;
		private var _type:String;
		
		/**
		 * 系统消息
		 * @param msg
		 *
		 */
		public function SysInfoVo(msg:String = "",type:String="",link:String="")
		{
			super();
			this._link = link;
			_info = msg;
			_type = type;
		}

		public function set link(value:String):void
		{
			_link = value;
		}

		override protected function initVo():void
		{
			super.initVo();
			//this._elems.push(this.timeStamp);	
			
			var textElement:TextElement = new TextElement(this._type+" : ",FontUtil.getFormat(0xec7218));
			_elems.push(textElement);			
			textElement = new TextElement(_info, FontUtil.getFormat(0xec7218));			
			_elems.push(textElement);
		}

		override public function get elements():GroupElement
		{
			var ge:GroupElement = super.elements;
			ge.userData = {"link":_link,indent:60,unline:true};
			return ge;
		}

		/**
		 * 系统消息内容
		 */
		public function set info(value:String):void
		{
			_info = value;
		}
		
		/**
		 * 消息类型 
		 * @param value
		 */		
		public function set type(value:String):void
		{
			_type = value;
		}
	}
}