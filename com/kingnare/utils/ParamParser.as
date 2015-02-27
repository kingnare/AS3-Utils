package com.kingnare.utils
{
    /**
     * 参数分析器
     * @author kingnare
     * 
     */    
    public class ParamParser
    {
        protected static var _ignoreWhitespace:Boolean;
        /**
         * <pre>
         * 例1: {name:"server",type:"string",defaultValue:"http://localhost/", enum:["a", "b"], instance:Config,  setter:"Border"}
         * 例2: {name:"server",type:"number",defaultValue:2, max:10, min:0}
         * </pre>
         * @param parameters 参数对象
         * @param parameterlist 参数列表数组
         * @return 
         * 
         */
        public static function parse(parameters:Object, parameterlist:Array, ignoreWhitespace:Boolean=true):Object
        {
            var re:Object = {};
            _ignoreWhitespace = ignoreWhitespace;
            
            for each (var item:Object in parameterlist) 
            {
                if(parameters.hasOwnProperty(item.name))
                {
                    var val:* = transType(parameters[item.name], item);
                    re[item.name] = val;
                    
                    if(item.hasOwnProperty("instance") && item.hasOwnProperty("setter"))
                        item.instance[item.setter] = val;
                }
                else
                {
                    item.hasOwnProperty("defaultValue") ? (re[item.name] = item.defaultValue) : (re[item.name] = null);
                }
            }
            
            return re;
        }
        
        /**
         * 
         * @param source
         * @param type
         * @return 
         * 
         */        
        protected static function transType(source:String, item:Object):*
        {
            var val:*;
            var re:*;
            
            switch(item.type)
            {
                case "number":
                {
                    val = Number(source);
                    re = numberProcess(val, item);
                    break;
                }
                case "int":
                {
                    val = int(source);
                    re = numberProcess(val, item);
                    break;
                } 
                case "uint":
                {
                    val = Number(source);
                    if(!isNaN(val) && val>=0)
                    {
                        val = uint(source);
                    }
                    else
                    {
                        val = 0;
                    }
                    
                    re = numberProcess(val, item);
                    break;
                }
                case "bool":
                {
                    if(source == "1" || source.toLowerCase() == "true")
                        re = true;
                    else
                        re = false;
                    
                    break;
                }
                default:
                {
                    /*if(source != null && source.replace(/[\s\t\n\x0B\f\r]/g, "") != "")
                    {
                        if(item.hasOwnProperty("enum"))
                        {
                            if(item.enum.indexOf(source) != -1)
                                re = source;
                            else
                                re = item.defaultValue; 
                        }
                        else
                        {
                            re = source;
                        }
                    }
                    else
                    {
                        re = item.defaultValue;
                    }*/
                    
                    if(source != null)
                    {
                        if(_ignoreWhitespace && source.replace(/[\s\t\n\x0B\f\r]/g, "") == "")
                        {
                            re = item.defaultValue;
                        }
                        else
                        {
                            if(item.hasOwnProperty("enum"))
                            {
                                if(item.enum.indexOf(source) != -1)
                                    re = source;
                                else
                                    re = item.defaultValue; 
                            }
                            else
                            {
                                re = source;
                            }
                        }
                    }
                    else
                    {
                        re = item.defaultValue;
                    }
                    
                    
                    
                }
            }
            
            return re;
        }
        
        /**
         * 数字处理
         * @param val
         * @param item
         * @return 
         * 
         */        
        protected static function numberProcess(val:*, item:Object):*
        {
            var re:*;
            if(!isNaN(val))
            {
                if(item.hasOwnProperty("enum"))
                {
                    if(item.enum.indexOf(val) != -1)
                        re = val;
                    else
                        re = item.defaultValue; 
                }
                else
                {
                    if(item.hasOwnProperty("min") && item.hasOwnProperty("max") && item.max > item.min)
                    {
                        val = Math.min(item.max, Math.max(item.min, val));
                    }
                    else if(item.hasOwnProperty("min"))
                    {
                        val = Math.max(item.min, val);
                    }
                    else if(item.hasOwnProperty("max"))
                    {
                        val = Math.min(item.max, val);
                    }
                    
                    re = val;
                }
            }
            else 
            {
                re = item.defaultValue;
            }
            
            return re;
        }
    }
}