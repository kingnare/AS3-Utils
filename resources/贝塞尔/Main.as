package
{
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import flash.events.Event;
	import flash.utils.getDefinitionByName;
	
	
	public class Main extends Sprite
	{
		private var __MouseMC:Class = getDefinitionByName("MouseMC") as Class;
		private var _speed:Number;								// 速度
		private var _numPoints:uint;							// 曲线段数
		private var _curPoint:uint;								// 当前所在点
		private var _points:Array;								// 点数组
		private var _currentStep:uint;							// 当前步数
		private var _totalStep:uint;							// 总步数
		private var border:Rectangle;							// 边界
		private var mouse_mc:MovieClip;							// 老鼠
		
		
		public function Main ()
		{
			initVars();
			cureateCurve();
			paint();
			init();
			addEventListener(Event.ENTER_FRAME, thread);
		}
		
		
		//  初始化成员
		private function initVars ():void
		{
			_speed     = 15;
			_numPoints = 24;
			_points    = new Array();
			border     = new Rectangle(20, 20, stage.stageWidth-20, stage.stageHeight-20);
			mouse_mc   = new __MouseMC();
			addChild(mouse_mc);
		}
		
		
		//  生成曲线路径点
		private function cureateCurve ():void
		{
			//  起点
			_points.push(new Point(Math.random()*stage.stageWidth, stage.stageHeight + 100));

			//  随机位置点
			for (var i:uint = 1; i < _numPoints - 1; i++) 
			{
				_points[i]   = new Point();
				_points[i].x = Math.random() * border.width + border.left;
				_points[i].y = Math.random() * border.height + border.top;
			}
			
			//  终点
			_points.push(new Point(Math.random()*border.width + border.x, border.y));
		}
		
		
		//  绘制
		private function paint ():void
		{
			//  活动区域
			graphics.lineStyle(1, 0x00FF00);
			graphics.moveTo(border.x,     border.y);
			graphics.lineTo(border.width, border.y);
			graphics.lineTo(border.width, border.height);
			graphics.lineTo(border.x,     border.height);
			graphics.lineTo(border.x,     border.y);
			
			//  曲线路径
			graphics.lineStyle(1, 0xFFFF00);
			graphics.moveTo(_points[0].x, _points[0].y);
			for (var i:uint = 1; i < _numPoints - 2; i ++)
			{
				var xc:Number = (_points[i].x + _points[i + 1].x) / 2;
				var yc:Number = (_points[i].y + _points[i + 1].y) / 2;
				graphics.curveTo(_points[i].x, _points[i].y, xc, yc);
			}
			graphics.curveTo(_points[i].x, _points[i].y, _points[i + 1].x, _points[i + 1].y);
		}

		
		//  下一步运动
		private function nextStep ():void
		{
			//  贝塞尔曲线
			var p0:Point = (_curPoint == 0) ? _points[0] : new Point((_points[_curPoint].x + _points[_curPoint + 1].x) / 2, (_points[_curPoint].y + _points[_curPoint + 1].y) / 2);
			var p1:Point = new Point(_points[_curPoint + 1].x, _points[_curPoint + 1].y);
			var p2:Point = (_curPoint <= _numPoints - 4) ? new Point((_points[_curPoint + 1].x + _points[_curPoint + 2].x) / 2, (_points[_curPoint + 1].y + _points[_curPoint + 2].y) / 2) : _points[_curPoint + 2];
			_totalStep = Bezier.init(p0, p1, p2, _speed);
			
			//  绘制出路径点
			graphics.lineStyle(1, 0xFF00FF);
			for (var i:uint = 1; i <= _totalStep; i++)
			{
				var data:Array = Bezier.getAnchorPoint(i);
				var pt:Point   = new Point(data[0], data[1]);
				graphics.moveTo(pt.x - 2, pt.y);
				graphics.lineTo(pt.x + 2, pt.y);
				graphics.moveTo(pt.x, pt.y - 2);
				graphics.lineTo(pt.x, pt.y + 2);
			}
		}
		
		
		//  初始化
		private function init ():void
		{
			mouse_mc.x   = _points[0].x;
			mouse_mc.y   = _points[0].y;
			_curPoint    = 0;
			_currentStep = 0;
			nextStep();
		}
		
		
		//  主线程
		private function thread (evt:Event):void
		{
			var data:Array    = Bezier.getAnchorPoint(_currentStep);
			mouse_mc.x        = data[0];
			mouse_mc.y        = data[1];
			mouse_mc.rotation = data[2] + 90;
			_currentStep ++;
			
			//  第1条贝塞尔曲线的终点点 和 第2条贝塞尔曲线的起点重叠，会出现短暂停顿的现象。所以需要跳过终点。
			if (_currentStep > _totalStep - 1)
			{
				if (_curPoint < _numPoints - 3)
				{
					_curPoint ++;
					_currentStep = 0;
					nextStep();
				}
			}
			
			//  终点检测
			if (_currentStep > _totalStep)
				removeEventListener(Event.ENTER_FRAME, thread);
		}
		
	}
}