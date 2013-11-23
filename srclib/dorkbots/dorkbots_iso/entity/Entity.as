package dorkbots.dorkbots_iso.entity
{
	import com.csharks.juwalbose.IsoHelper;
	import com.newarteest.path_finder.PathFinder;
	
	import flash.display.MovieClip;
	import flash.geom.Point;
	
	import dorkbots.dorkbots_broadcasters.BroadcastingObject;
	import dorkbots.dorkbots_iso.room.IIsoRoomData;

	public class Entity extends BroadcastingObject implements IEntity
	{
		public static const PATH_ARRIVED_NEXT_NODE:String = "path arrived next node";
		
		protected var roomData:IIsoRoomData;
		private var _type:uint;
		
		private var borderOffsetX:Number;
		private var borderOffsetY:Number;
		
		private var _cartPos:Point = new Point();
		private var cartPosPrevious:Point = new Point();
		private var _node:Point = new Point();
		private var _nodePrevious:Point = _node.clone();
		
		private var _path:Array = new Array();
		private var destination:Point = new Point();
		
		private var speed:Number;
		private var _halfSize:Number;
		private var _movedAmountPoint:Point = new Point();
		
		private var _dX:Number = 0;
		private var _dY:Number = 0;
		private var idle:Boolean = true;
		private var _facingNext:String = "south";
		private var _facingCurrent:String = _facingNext;
		
		private var _moved:Boolean = true;
		
		private var _entity_mc:MovieClip;
		
		public function Entity()
		{
		}

		public final function get finalDestination():Point
		{
			if (_path.length == 0) return null;
			return _path[0].clone();
		}
		
		public final function get type():uint
		{
			return _type;
		}
		
		public final function get dY():Number
		{
			return _dY;
		}
		
		public final function set dY(value:Number):void
		{
			_dY = value;
		}
		
		public final function get dX():Number
		{
			return _dX;
		}
		
		public function set dX(value:Number):void
		{
			_dX = value;
		}
		
		public final function get path():Array
		{
			return _path;
		}
		
		public final function get movedAmountPoint():Point
		{
			return _movedAmountPoint;
		}
		
		public final function get moved():Boolean
		{
			return _moved;
		}
		
		public final function get node():Point
		{
			return _node;
		}
		
		public function set node(value:Point):void
		{
			if (!_node.equals(value)) _nodePrevious = _node;
			_node = value;
		}
		
		public final function get nodePrevious():Point
		{
			return _nodePrevious;
		}
		
		// the x and y values of the grid project in 2d. This is used for more optimized calculations when finding position of node and comparison
		public final function get cartPos():Point
		{
			return _cartPos;
		}
		
		public final function set cartPos(value:Point):void
		{
			_cartPos = value;
		}
		
		public final function get entity_mc():MovieClip
		{
			return _entity_mc;
		}
		
		public final function get facingNext():String
		{
			return _facingNext;
		}
		
		public final function set facingNext(value:String):void
		{
			_facingNext = value;
		}
		
		public final function get facingCurrent():String
		{
			return _facingCurrent;
		}
		
		public final function set facingCurrent(value:String):void
		{
			_facingCurrent = value;
		}
		
		public function init(a_mc:MovieClip, aSpeed:Number, aHalfSize:Number, aRoomData:IIsoRoomData, aType:uint):IEntity
		{
			_path.length = 0;
			_entity_mc = a_mc;
			_entity_mc.clip.gotoAndStop(_facingNext);
			speed = aSpeed;
			_halfSize = aHalfSize;
			roomData = aRoomData;
			borderOffsetX = roomData.borderOffsetX;
			borderOffsetY = roomData.borderOffsetY;
			
			_type = aType;
			
			return this;
		}
		
		override public function dispose():void
		{
			roomData = null;
			_cartPos = null;
			_node = null;
			_path.length = 0;
			_path = null;
			destination = null;
			_movedAmountPoint = null;
			_entity_mc = null;
			
			super.dispose();
		}
		
		public final function loop():void
		{
			cartPosPrevious = _cartPos.clone();
			aiWalk();
		}
		
		public final function move():void
		{			
			_moved = false;
			if (dY == 0 && dX == 0)
			{
				if (_facingNext != "") _entity_mc.clip.gotoAndStop(_facingNext);
				idle = true;
			}
			else if (idle || _facingCurrent != _facingNext)
			{
				idle = false;
				_facingCurrent = _facingNext;
				_entity_mc.clip.gotoAndPlay(_facingNext);
			}
			
			if (! idle && isWalkable())
			{
				_cartPos.x += speed * dX;
				_cartPos.y += speed * dY;
				
				_moved = true;
			} 
			else if(path.length > 0)
			{
				// put the entity in the middle of the node
				entityArrivedAtNextNode();
			}
			
			var currentNode:Point = IsoHelper.getNodeCoordinates(_cartPos, roomData.nodeWidth);
			if (!currentNode.equals(_node))
			{
				_nodePrevious = _node;
				_node = currentNode;
			}
			
			_movedAmountPoint = _cartPos.subtract(cartPosPrevious);
		}
		
		private function isWalkable():Boolean
		{
			var newPos:Point = new Point();
			newPos.x = _cartPos.x + (speed * dX);
			newPos.y = _cartPos.y + (speed * dY);
			
			switch (_facingNext)
			{
				case "north":
					newPos.y -= _halfSize;
					break;
				
				case "south":
					newPos.y += _halfSize;
					break;
				
				case "east":
					newPos.x += _halfSize;
					break;
				
				case "west":
					newPos.x -= _halfSize;
					break;
				
				case "northeast":
					newPos.y -= _halfSize;
					newPos.x += _halfSize;
					break;
				
				case "southeast":
					newPos.y += _halfSize;
					newPos.x += _halfSize;
					break;
				
				case "northwest":
					newPos.y -= _halfSize;
					newPos.x -= _halfSize;
					break;
				
				case "southwest":
					newPos.y += _halfSize;
					newPos.x -= _halfSize;
					break;
			}
			
			newPos = IsoHelper.getNodeCoordinates(newPos, roomData.nodeWidth);
			
			if (newPos.y < roomData.roomNodeGridHeight && newPos.x < roomData.roomNodeGridWidth && newPos.y >= 0 && newPos.x >= 0)
			{
				if(this.getWalkable()[newPos.y][newPos.x] > 0 && !newPos.equals(_node))
				{
					return false;
				}
				else
				{
					return true;
				}
			}
			else
			{
				return false
			}
		}
		
		/**
		 * Pathfinding control
		 */
		private function aiWalk():void
		{
			//trace("{IsoMaker} aiWalk -> path.length = " + path.length);
			if(_path.length == 0)
			{
				//path has ended
				dX = dY = 0;
				
				return;
			}
			
			if( _node.equals(destination) )
			{	
				var newPos:Point = new Point(_node.x * roomData.nodeWidth + (roomData.nodeWidth / 2), _node.y * roomData.nodeWidth + (roomData.nodeWidth / 2));
				if (Point.distance(newPos, cartPos) <= speed)
				{
					destination = _path.pop();
					getMovement();
					
					entityArrivedAtNextNode();
				}
			}
		}
		
		private function entityArrivedAtNextNode():void
		{
			putEntityInMiddleOfNode();
			
			this.broadcasterManager.broadcastEvent( PATH_ARRIVED_NEXT_NODE );
		}
		
		public final function putEntityInMiddleOfNode():void
		{
			_cartPos.x = _node.x * roomData.nodeWidth + (roomData.nodeWidth / 2);
			_cartPos.y = _node.y * roomData.nodeWidth + (roomData.nodeWidth / 2);
		}
		
		private function getMovement():void
		{
			if(_node.x < destination.x)
			{
				dX = 1;
			}
			else if(_node.x > destination.x)
			{
				dX = -1;
			}
			else 
			{
				dX = 0;
			}
			if(_node.y < destination.y)
			{
				dY = 1;
			}
			else if(_node.y > destination.y)
			{
				dY = -1;
			}
			else 
			{
				dY = 0;
			}
			if(_node.x == destination.x)
			{
				//top or bottom
				dX = 0;
			}
			else if(_node.y == destination.y)
			{
				//left or right
				dY = 0;
			}
			
			if (dX == 1)
			{
				if (dY == 0)
				{
					_facingNext = "east";
				}
				else if (dY == 1)
				{
					_facingNext = "southeast";
					dX = dY = 0.5;
				}
				else
				{
					_facingNext = "northeast";
					dX = 0.5;
					dY = -0.5;
				}
			}
			else if (dX == -1)
			{
				if (dY == 0)
				{
					_facingNext = "west";
				}
				else if (dY == 1)
				{
					_facingNext = "southwest";
					dY = 0.5;
					dX = -0.5;
				}
				else
				{
					_facingNext= "northwest";
					dX = dY = -0.5;
				}
			}
			else
			{
				if (dY == 0)
				{
					_facingNext = _facingCurrent;
				}
				else if (dY == 1)
				{
					_facingNext = "south";
				}
				else
				{
					_facingNext = "north";
				}
			}
		}
		
		// Entities need to reach the center of path node before creating a new path. Otherwise visual positioning get's skewed.
		public final function findPathToNode(nodePoint:Point, updateDestination:Boolean = true):void
		{
			var oldPath:Array = _path.slice();
			var startNode:Point;
			
			// used by the IsoMaker click for hero pathfinding. Prevents hero from moving backwards toward pervious node.
			if (!updateDestination && oldPath.length > 0)
			{
				startNode = destination;
			}
			else
			{
				startNode = _node;
			}
			
			_path = PathFinder.go( startNode.x, startNode.y, nodePoint.x, nodePoint.y, getWalkable() );
			path.reverse();
			path.push(nodePoint);
			path.reverse();
			
			if (updateDestination)
			{
				destination = path.pop();
			}
			// used by the IsoMaker click for hero pathfinding. 
			else if (oldPath.length == 0) 
			{
				destination = path.pop();
			}
		}
		
		protected function getWalkable():Array
		{
			return roomData.roomWalkable;
		}
	}
}