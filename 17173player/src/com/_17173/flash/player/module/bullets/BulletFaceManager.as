package com._17173.flash.player.module.bullets
{
	import com._17173.flash.player.module.bullets.base.BulletConfig;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.text.engine.ContentElement;
	import flash.text.engine.ElementFormat;
	import flash.text.engine.GraphicElement;
	import flash.text.engine.GroupElement;
	import flash.text.engine.TextElement;
	import flash.utils.Dictionary;

	/**
	 *弹幕表情管理
	 * @author zhaoqinghao
	 *
	 */
	public class BulletFaceManager
	{

		private var _faceByKey:Dictionary = null;
		private var _keyByName:Dictionary = null;
		//分隔用字符串
		private const SP_STR:String = ";!$<>?%#$!#";
		//显示图上限
		private const GE_LIMIT:int = 2;
		
		private var _faceSwitch:Boolean = true;
		private static var bulletFaceManager:BulletFaceManager;
		
		public static function getInstance():BulletFaceManager{
			if(bulletFaceManager == null){
				bulletFaceManager = new BulletFaceManager();
			}
			return bulletFaceManager;
		}
		public function BulletFaceManager()
		{
			_faceByKey = new Dictionary();
			_keyByName = new Dictionary();
			initFaceData();
		}

		/**
		 *装载数据<br>
		 *将表情数据整合到一起，并且存储到字典中；元件取出来的表情会转换成bitmapdata存储<br>
		 * 表情数据结构{key:XXX,name:XXXX,bmd:XXX}
		 */
		private function initFaceData():void
		{
			var names:Array = BulletConfig.getInstance().faceNames;
			var mcs:Array = BulletConfig.getInstance().faceMcs;
			var len:int = names.length;
			var obj:Object;
			var name:String = null;
			var mc:MovieClip = null;
			var bmd:BitmapData = null;
			var key:String = null;
			for (var i:int = 0; i < names.length; i++)
			{
				if(names[i] && mcs[i]){
					key = "bfk"+i;
					obj = {key:key,name:names[i],bmd:getBitmapData(mcs[i]),url:key};
					_faceByKey[key] = obj;
					_keyByName[names[i]] = key;
				}
			}
		}
		
		private function getBitmapData(ds:DisplayObject):BitmapData{
			if(!ds){
				 return new BitmapData(20,20,true,0x000000); 
			}
			var bmd:BitmapData = new BitmapData(ds.width,ds.height,true,0x11111111);
			bmd.draw(ds);
			return bmd;
		}
		/**
		 *通过key获取bm
		 * @return 
		 * 
		 */
		public function getBitmapBykey(key:String):Bitmap
		{
			var bmd:BitmapData  = _faceByKey[key].bmd;
			var bmp:Bitmap = new Bitmap(bmd);
			return bmp;
		}
		/**
		 *通过字符串获取图 
		 * @return 
		 * 
		 */		
		public function getBitmapByName(name:String):Bitmap
		{
			var key:String = _keyByName[name.toUpperCase()];
			return getBitmapBykey(key);
		}
		/**
		 *解析字符串生成动画对象与字符串<br>
		 * 解析规则，通过字符串解析所有表情
		 * @return
		 *
		 */
		public function decodeString(usersay:String,faceStr:String,format:ElementFormat):GroupElement
		{
			var ge:GroupElement;
			//是否开启图片
			if(_faceSwitch){
				//为所有关键字加入分隔符
				var nameString:String = replaceAllName(faceStr);
				var array:Array = (usersay+nameString).split(SP_STR);
				//通过字符串数组获取图文混排group
				ge = createGroupEelement4Array(array,format);
			}else{
				var elemGroup:Vector.<ContentElement> = new Vector.<ContentElement>();
				elemGroup.push(new TextElement((usersay+faceStr),format));
				ge = new GroupElement(elemGroup);
			}
			return ge;
		}
		
		/**
		 *将可替换字符替换为分隔 
		 * @param str
		 * @return 
		 * 
		 */		
		private function replaceAllName(str:String):String{
			var newStr:String = str.slice();
			var names:Array = BulletConfig.getInstance().faceNames;
			var len:int = names.length;
			var name:String;
			var rex:RegExp;
			for (var i:int = 0; i < len; i++) 
			{
				name = names[i];
				rex = new RegExp("("+ name +")","/ig");
				newStr = newStr.replace(rex,SP_STR + name + SP_STR);
			}
			return newStr;
		}
		/**
		 *创建富文本元素 
		 * @param array
		 * @return 
		 * 
		 */		
		private function createGroupEelement4Array(array:Array,ef:ElementFormat):GroupElement{
			var ge:GroupElement = new GroupElement();
			var elemGroup:Vector.<ContentElement> = new Vector.<ContentElement>();
			var len:int =  array.length;
			//图片数量
			var rCount:int = 0;
			for (var i:int = 0; i < len; i++) 
			{
				var str:String = array[i];
				if(str && str!=""){
					var ce:ContentElement;
					//如果超过显示图片数量，则之后图片全部已文字显示
					//if(rCount <= GE_LIMIT){
					//ce = getElement(str,ef,true);
					if (rCount < GE_LIMIT){
						ce = getElement(str,ef,false);
						//是图片则计数加1
						if(ce && ce is GraphicElement){
							rCount ++;
						}
					} else {
						ce = getElement(str,ef,true);
					}
				}
				if(ce){
					elemGroup.push(ce);
				}
				//置空很重要
				ce = null;
			}
			//elemGroup = null;
			ge.setElements(elemGroup);
			return ge;
		}
		
		
		/**
		 *根据字符串获取element 
		 * @param str
		 * @return 
		 * 
		 */		
		private function getElement(str:String,ef:ElementFormat,isText:Boolean = false):ContentElement{
			var key:String = null;
			var cte:ContentElement;
			if(_keyByName[str] == null){
				cte = new TextElement(str,ef);
			}else{
				key = _keyByName[str];
				var data:Object = _faceByKey[key];
				if(data && !isText){
					var bmp:Bitmap = new Bitmap(data.bmd);
					bmp.y = 3;
					cte = new GraphicElement(bmp,bmp.width,bmp.height,ef);
				}else{
					cte = new TextElement(str,ef);
				}
			}
			return cte;
		}
		
		/**
		 *是否开启 
		 * @param value
		 * 
		 */		
		public function set faceSwitch(value:Boolean):void{
			_faceSwitch = value;
		}
	}
}