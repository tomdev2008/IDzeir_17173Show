package
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.context.IContextItem;
	import com._17173.flash.core.util.debug.Debugger;
	
	import flash.utils.describeType;
	
	/**
	 * Context框架统一入口方法.通过此方法可以完全代理Context的使用方式:</br>
	 *  Context -> _() </br>
	 * 	Context.regContext("eventManager", EventManager) -> _("eventManager", EventManager, null) </br>
	 * 	Context.injectContext("eventManager", new EventManager) -> _("eventManager", new EventManager) </br>
	 * 	Context.getContext("eventManager") -> _("eventManager") </br>
	 *  Context.stage(或者其他任意属性) -> _("stage") </br>
	 * 	Context.variables["cid"] -> _("cid") </br>
	 * 	Context.variables["cid"]="100" -> _("cid", 100) </br>
	 * </br>
	 */	
	public function _(selector:* = null, setValue:* = null, params:Object = null):* {
		// 如果参数为空,默认返回Context
		if (!selector && !setValue) return Context;
		
		if (setValue == null) {		// 获取
			// 没有setValue,说明是获取Context中的属性或者context
			var query:* = Context[selector];		// 优先检查是不是调用的Context上的公共属性
			if (query != null) return query;
			query = Context.getContext(selector);	// 再次检查是不是调用的IContextItem
			if (query != null) return query;
			if (!Context.variables.hasOwnProperty(selector)) {
				Debugger.tracer(Debugger.INFO, "[_]", "无法获取属性[" + selector + "]对应的内容!");
			} else {
				query = Context.variables[selector];	// 最后检查是不是查找的variables中的全局变量
			}
			return query;
		} else {					// 设置
			// 如果是IContextItem实例				-- TODO: 可能虽然是实例,但是目的只是单纯的设置属性
			var injectContext:Function = function ():Boolean {
				if (setValue is IContextItem) {
					Context.injectContext(selector, setValue);
					return true;
				} else {
					return false;
				}
			};
			// 如果是IContextItem实现的类 			-- TODO: 可能虽然是对应的类,但是目的只是单纯的设置属性
			var injectContextClass:Function = function ():Boolean {
				if (setValue is Class) {
					var found:Boolean = false;
					// 通过describeType解出接口类
					var type:XML = describeType(setValue);
					var lists:XMLList = type.factory.implementsInterface;
					if (lists && lists.length() > 0) {
						for each (var xml:XML in lists) {
							if (xml.@type.indexOf("IContextItem") > -1) {
								found = true;
								break;
							}
						}
					}
					if (found) {
						Context.regContext(selector, setValue, null, params);
						return true;
					} else {
						return false;
					}
				} else {
					return false;
				}
			};
			// 如果是其他
			var setProp:Function = function ():Boolean {
				Context.variables[selector] = setValue;
				return true;
			};
			
			return !(injectContext() || injectContextClass() || setProp());
		}
	}
	
}