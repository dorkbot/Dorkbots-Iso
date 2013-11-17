package com.dayvid.grid
{
	public class AStar
	{
		private var _open:Array;
		private var _closed:Array;
		private var _grid:Grid;
		private var _endNode:Node;
		private var _startNode:Node;
		private var _path:Array;
		private var _heuristic:Function = manhattan;
		/*private var _heuristic:Function = euclidian;
		private var _heuristic:Function = diagonal;*/
		private var _straightCost:Number = 1.0;
		private var _diagCost:Number = Math.SQRT2;
		//
		public function AStar()
		{
		}
		
		
		
		// TO DO
		// create a manger class that builds a grid from an array, or vector array.
		// optional elibibleNode function
		// change heurisitics, setter with switch
		// change cost to uint
		// verify Number datat type, make uint or int
		
		
		
		public function findPath(grid:Grid, findDiagonal:Boolean = true):Boolean
		{
			_grid = grid;
			_open = new Array();
			_closed = new Array();
			//
			_startNode = _grid.startNode;
			_endNode = _grid.endNode;
			//
			_startNode.g = 0;
			_startNode.h = _heuristic(_startNode);
			_startNode.f = _startNode.g + _startNode.h;
			//
			return search();
		}
		
		private function eligibleNode(node:Node):Boolean
		{
			return node.walkable;
		}
		//
		public function search():Boolean
		{
			var node:Node = _startNode;
			while(node != _endNode)
			{
				var startX:int = Math.max(0, node.x - 1);
				var endX:int = Math.min(_grid.numCols - 1, node.x + 1);
				var startY:int = Math.max(0, node.y - 1);
				var endY:int = Math.min(_grid.numRows - 1, node.y + 1);
				
				for(var i:int = startX; i <= endX; i++)
				{
					for(var j:int = startY; j <= endY; j++)
					{
						// removes any diagonal nodes
						// use the findDiagonal param
						// if (aPoint.x == i || aPoint.y == j) 
						var test:Node = _grid.getNode(i, j);
						if(test == node || 
						   !eligibleNode(test) ||
						   !eligibleNode(_grid.getNode(node.x, test.y)) ||
						   !eligibleNode(_grid.getNode(test.x, node.y)))
						{
							continue;
						}
						
						var cost:Number = _straightCost;
						if(!((node.x == test.x) || (node.y == test.y)))
						{
							cost = _diagCost;
						}
						var g:Number = node.g + cost * test.costMultiplier;
						var h:Number = _heuristic(test);
						var f:Number = g + h;
						if(isOpen(test) || isClosed(test))
						{
							if(test.f > f)
							{
								test.f = f;
								test.g = g;
								test.h = h;
								test.parent = node;
							}
						}
						else
						{
							test.f = f;
							test.g = g;
							test.h = h;
							test.parent = node;
							_open.push(test);
						}
					}
				}
				/*for(var o:int = 0; o < _open.length; o++)
				{
				}*/
				_closed.push(node);
				if(_open.length == 0)
				{
					//trace("no path found");
					return false
				}
				_open.sortOn("f", Array.NUMERIC);
				node = _open.shift() as Node;
			}
			buildPath();
			return true;
		}
		
		private function buildPath():void
		{
			_path = new Array();
			var node:Node = _endNode;
			//trace("node.x: " + node.x + ", node.y: " + node.y);
			_path.push(node);
			while(node != _startNode)
			{
				node = node.parent;
				//trace("node.x: " + node.x + ", node.y: " + node.y);
				_path.unshift(node);
			}
		}
		
		public function get path():Array
		{
			return _path;
		}
		
		private function isOpen(node:Node):Boolean
		{
			for(var i:int = 0; i < _open.length; i++)
			{
				if(_open[i] == node)
				{
					return true;
				}
			}
			return false;
		}
		
		private function isClosed(node:Node):Boolean
		{
			for(var i:int = 0; i < _closed.length; i++)
			{
				if(_closed[i] == node)
				{
					return true;
				}
			}
			return false;
		}
		
		private function manhattan(node:Node):Number
		{
			return Math.abs(node.x - _endNode.x) * _straightCost + Math.abs(node.y + _endNode.y) * _straightCost;
		}
		
		private function euclidian(node:Node):Number
		{
			var dx:Number = node.x - _endNode.x;
			var dy:Number = node.y - _endNode.y;
			return Math.sqrt(dx * dx + dy * dy) * _straightCost;
		}
		
		private function diagonal(node:Node):Number
		{
			var dx:Number = Math.abs(node.x - _endNode.x);
			var dy:Number = Math.abs(node.y - _endNode.y);
			var diag:Number = Math.min(dx, dy);
			var straight:Number = dx + dy;
			return _diagCost * diag + _straightCost * (straight - 2 * diag);
		}
		
		public function get visited():Array
		{
			return _closed.concat(_open);
		}
	}
}
