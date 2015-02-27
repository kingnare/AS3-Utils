package com.kingnare.utils
{
	import flash.net.LocalConnection;
	
	import net.linksoon.player.components.ad.ADContentType;
	import net.linksoon.player.data.Config;

	public class Tools
	{
		public function Tools()
		{
		}
		
		public static function gc():void
		{
			try
			{
				new LocalConnection().connect('GC');
			} 
			catch(e:Error)
			{
			}
		}
		
		public static function maxGC():void
		{
			try
			{
				new LocalConnection().connect('GC');
				new LocalConnection().connect('GC');
			} 
			catch(e:Error)
			{
			}
		}
        
        public static function getSuffix(str:String):String
        {
            var suffixArray:Array = str.split(".");
            if(suffixArray.length > 0)
            {
                return suffixArray[suffixArray.length-1].toLowerCase();
            }
            else
            {
                return "";
            }
        }
		
		public static function aspectRatioSize(inputWidth:Number, inputHeight:Number, containerWidth:Number, containerHeight:Number):Object
		{
			if (inputHeight == 0 || containerHeight == 0)
			{
				return {width:inputWidth, Math:inputHeight};
			}
			if(inputWidth == containerWidth && inputHeight == containerHeight)
			{
				return {width:inputWidth, height:inputHeight};
			}
			var _scale:Number = inputWidth / inputHeight;
			var _rect_scale:Number = containerWidth / containerHeight;
			var end_w:Number = inputWidth;
			var end_h:Number = inputHeight;
			if (_scale > _rect_scale)
			{
				end_w = containerWidth;
				end_h = end_w / _scale;
			}
			else
			{
				end_h = containerHeight;
				end_w = end_h * _scale;
			}
			
			return {width:Math.floor(end_w), height:Math.floor(end_h)};
		}
        
        public static function fillWithScale(inputWidth:Number, inputHeight:Number, containerWidth:Number, containerHeight:Number):Object
        {
            var input_scale:Number = inputWidth / inputHeight;
            var container_scale:Number = containerWidth / containerHeight;
            var scale:Number = 1;
            
            var end_w:Number = inputWidth;
            var end_h:Number = inputHeight;
            
            if (input_scale <= container_scale)
            {
                scale = containerWidth/inputWidth;
                end_w = containerWidth;
                end_h = scale*inputHeight;
            }
            else
            {
                scale = containerHeight/inputHeight;
                end_w = scale*inputWidth;
                end_h = containerHeight;
            }
            
            return {width:Math.floor(end_w), height:Math.floor(end_h)};
        }
		
		public static function changeColorToFF(value:uint):String
		{
		    var tr:int = value >> 16;
		    var tg:int = value >> 8 ^ tr << 8;
		    var tb:int = value ^ (tr << 16 | tg << 8);
		    var r:String = tr.toString(16);
		   	var g:String = tg.toString(16);
		    var b:String = tb.toString(16);
		    while (r.length < 2){
		        r = "0" + r;
		    } 
		    while (g.length < 2){
		        g = "0" + g;
		    } 
		    while (b.length < 2){
		        b = "0" + b;
		    } 
		    return (r + g + b).toUpperCase();
		}
		
		/**
		 * 时间格式转换
		 * @param time 秒
		 * @param bool 是否加入毫秒显示
		 * @return 时间字符串，如: 00:00:00 或 00:00:00.0
		 * 
		 */		
		public static function transTimeFormat(time:Number,showKseconds:Boolean=false):String
		{
			var kseconds:int = Math.floor(time * 1000 % 1000 / 10);
			var minutes:int = Math.floor(time / 60);
			var seconds:int = Math.floor(time % 60);
			
			var s:String = (minutes<10 ? "0"+minutes.toString() : minutes.toString()) + ":" + 
						   (seconds<10 ? "0"+seconds.toString() : seconds.toString());
			
			if (time >= 3600)
			{
				var hours:int = Math.floor(time / 3600);
				minutes = Math.floor((time/60) % 60);
				seconds = Math.floor(time % 60);
				s = (hours<10?"0"+hours.toString():hours.toString()) + ":" + 
					(minutes<10?"0"+minutes.toString():minutes.toString()) + ":" + 
					(seconds<10?"0"+seconds.toString():seconds.toString());
			}
			if (showKseconds)
			{
				return s + "." + (kseconds<10?"0"+kseconds.toString():kseconds.toString());
			}
			return s;
		}
        
        public static function transIntLessThanTen(value:int):String
        {
            if(value<10)
            {
                return "0"+value.toString();
            }
            
            return value.toString();
        }
		
		/**
		 * 将时间字串转换为毫秒级整型
		 * @param _ss
		 * @return 
		 * 
		 */		
		public static function transTime(_ss:String):uint
		{
			var _h:* = 0;
			var _m:* = 0;
			var _s:* = 0;
			var _ms:* = 0;
			var _time1:Array = _ss.split(":");
			
			if (_time1.length == 2) 
			{
				//e.g 03:39.771
				_m = parseInt(_time1[0]);
				var _ms_array:Array = _time1[1].split(/[.,]/);
				_s = parseInt(_ms_array[0]);
				_ms = _ms_array[1];
			} 
			else if (_time1.length == 3) 
			{
				//e.g 00:03:39.771
				//trace("length:"+_time1);
				_h = parseInt(_time1[0]);
				_m = parseInt(_time1[1]);
				var ms_array:Array = _time1[2].split(/[.,]/);
				_s = parseInt(ms_array[0]);
				_ms = ms_array[1];
			}
			////////////////                                                                                                                                                            
			if (_ms == undefined || isNaN(_ms)) 
			{
				_ms = "0";
			}
			
			var _mssplit:Array = _ms.toString().split("");
			
			switch (_mssplit.length) 
			{
				case 1 :
					_ms = parseInt(_ms)*100;
					break;
				case 2 :
					_ms = parseInt(_ms)*10;
					break;
				case 3 :
					_ms = parseInt(_ms);
					break;
				default :
					_ms = parseInt(_mssplit[0])*100+parseInt(_mssplit[1])*10+parseInt(_mssplit[2]);
					break;
			}
			/////////////////////
			return _h*3600000+_m*60000+_s*1000+_ms;
		}
		
		/**
		 * 
		 * @param bytes
		 * @return 
		 * 
		 */		
		public static function transSize(bytes:Number, toFixed:* = 0):String
		{
			if(bytes<0) return "0 KB";
			var mb:Number = bytes/(1024*1024);
			if(mb<1)
			{
				return (Math.floor(bytes/1024*10)/10).toFixed(toFixed)+"KB";
			}
			else
			{
				return (Math.floor(mb*1024)/1024).toFixed(toFixed)+"MB";
			}
		}
        
        public static function tranSize2(bytes:Number, toFixed:*=0):Object
        {
            if(bytes<0) return {value:0, isMB:false};
            var mb:Number = bytes/(1024*1024);
            if(mb<1)
            {
                return {value:(Math.floor(bytes/1024*10)/10).toFixed(toFixed), isMB:false};
            }
            else
            {
                return {value:(Math.floor(mb*1024)/1024).toFixed(toFixed), isMB:true};
            }
        }
		
		public static function kaigen(a:Number,b:Number):Number
		{
        	return Math.exp(Math.log(a)/b);
		}
		
		public static function decimal(num:Number, n:Number):Number
		{
			if(isNaN(num) || isNaN(n))
			{
				return NaN;
			}
			else
			{
				var d:Number = Math.pow(10,n);
				return Math.round(num/1024/1024*d)/d;
			}
			
			return NaN;
		}
		
		
		
		
		public static function isEmpty(obj:*):Boolean
		{
			return obj == null || obj == undefined || obj == "" || trim2(obj) == "" || (obj is Number && isNaN(obj)) || (obj is Boolean);
		}
		
		public static function trim(v:String):String
		{
			return v?v.replace(/(^\s*)|(\s*$)/g, ""):"";
		}
		
		public static function trim2(v:String):String
		{
			return v?trim(v).replace(/\n[\s| ]*\r/g, ""):"";
		}
        
        
        /**
         * 随机排序
         * http://bbs.9ria.com/thread-145386-1-1.html
         * 自身插入法
         * 通常插入法是将随机移出来的数扔到新的数组里，但是这么写的牛逼之处在于扔自己数组后面了，节省了效率：）。此法在数组较短时效率高，超过200效率就不如传统插入法了
         * 
         * 利用1-100的顺序数组进行测试，执行10000次所用的时间分别为。
         * 自身插入法：1654
         * 传统插入法（放进新数组）： 2574 
         * 选择法：594
         * 利用Sort() ：1479 
         * @param arr
         * @return 
         * 
         */        
        public static function RanomArray1(arr:Array):Array
        {
            var outputArr:Array = arr.slice();
            var i:int = outputArr.length;
            
            while (i)
            {
                outputArr.push(outputArr.splice(int(Math.random() * i--), 1)[0]);
            }
            
            return outputArr;
        }
        
        /**
         * 传统插入法
         * 在数组较长（200以上）时效率比自身插入法高，因为短数组操作起来更快。
         * @param arr
         * @return 
         * 
         */        
        public static function RanomArray2(arr:Array):Array
        {
            var cloneArr:Array = arr.slice();
            var outputArr:Array = [];
            var i:int = cloneArr.length;
            
            while (i)
            {
                outputArr.push(cloneArr.splice(int(Math.random() * i--), 1)[0]);
            }
            
            return outputArr;
        }
        
        /**
         * 选择法
         * 选择排序法就是按照顺序从余下数中选出最小（大）的数，和顺序位置的数字交换，反复进行。此法最多可能会交换n-1次，比如[4,1,2,3]递增排序中的4就需要挪3次，当然最少一次也不用。但是随机算法循环次数无法浮动，必须是固定的，怎么办呢？没有关系，我们可以引入废操作，位置已经摆对的数自己和自己交换，这样就可以让所有顺序排序都成为n-1步走。
         * 反过来想就明白了，从0开始每个位置和后面的随机位置交换，也可以和自己交换，直到n-2和n-1（或n-2自己交换），就可以得到一个随机数组。
         * @param arr
         * @return 
         * 
         */        
        public static function RanomArray3(arr:Array):Array
        {
            var outputArr:Array = arr.slice();
            var i:int = outputArr.length;
            var temp:*;
            var indexA:int;
            var indexB:int;
            
            while (i)
            {
                indexA = i-1;
                indexB = Math.floor(Math.random() * i);
                i--;
                
                if (indexA == indexB) continue;
                temp = outputArr[indexA];
                outputArr[indexA] = outputArr[indexB];
                outputArr[indexB] = temp;
            }
            
            return outputArr;
        }
        
        /**
         * sort可以带一个比较函数，排序时，会按照一定规则挑选两个参数进行比较，最后排出顺序
         * 当返回值为1时，参数A对应元素排到参数B对应元素后
         * 当返回值为0时，参数A与参数B位置保持不变
         * 当返回值为-1时，参数B对应元素排到参数A对应元素前
         * @param arr
         * @return 
         * 
         */        
        public static function RanomArray4(arr:Array):Array
        {
            var outputArr:Array = arr.slice();
            outputArr.sort(function():int{return Math.random()>.5?1:-1}); 
            return outputArr;
        }
		
	}
}