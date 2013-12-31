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
		public static const PATH_COMPLETE:String = "path complete";
		public static const WALKING_ON_NODE_TYPE_OTHER:String = "walking on node type other";
		public static const NEW_NODE:String = "new node";
		
		protected var roomData:IIsoRoomData;
		private var _type:uint;
		
		private var borderOffsetX:Number;
		private var borderOffsetY:Number;
		
		private var _cartPos:Point = new Point();
		private var cartPosPrevious:Point = new Point();
		private var _node:Point = new Point();
		private var _nodePrevious:Point = _node.clone();
		
		protected var walkableList:Vector.<uint>;
		private var _path:Array = new Array();
		private var destination:Point = new Point();
		private var broadcastPathComplete:Boolean = false;
		
		private var _speed:Number;
		private var _halfSize:Number;
		private var _movedAmountPoint:Point = new Point();
		
		protected var _healthMax:uint = 100;
		private var _health:Number = _healthMax;
		private var _dX:Number = 0;
		private var _dY:Number = 0;
		private var idle:Boolean = true;
		private var _facingNext:String = "south";
		private var _facingCurrent:String = _facingNext;
		
		private var _moved:Boolean = true;
		
		private var _entity_mc:MovieClip;
		
		private var _destroyed:Boolean = false;
		
		public function Entity()
		{
		}

		public final function get speed():Number
		{
			return _speed;
		}

		public final function set speed(value:Number):void
		{
			_speed = value;
		}

		public final function get destroyed():Boolean
		{
			return _destroyed;
		}

		public final function set destroyed(value:Boolean):void
		{
			_destroyed = value;
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
		
		public final function get health():Number
		{
			return _health;
		}
		
		public final function set health(value:Number):void
		{
			_health = value;
		}
		
		public final function get healthMax():uint
		{
			return _healthMax;
		}
		
		public final function set healthMax(value:uint):void
		{
			_healthMax = value;
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
		
		public final function init(aSpeed:Number, aHalfSize:Number, aType:uint):IEntity
		{
			_path.length = 0;
			_speed = aSpeed;
			_halfSize = aHalfSize;
			
			_type = aType;
			
			setupWalkableList();
			
			return this;
		}
		
		public final function wake(a_mc:MovieClip, aRoomData:IIsoRoomData):IEntity
		{
			_entity_mc = a_mc;
			_entity_mc.clip.gotoAndStop(_facingNext);
			idle = true;
			_facingNext = _facingCurrent;
			setFaceView();
			roomData = aRoomData;
			borderOffsetX = roomData.borderOffsetX;
			borderOffsetY = roomData.borderOffsetY;
			
			_cartPos = new Point();
			destination = new Point();
			_movedAmountPoint = new Point();
			
			//move();
			
			return this;
		}
		
		override public function dispose():void
		{
			putInStasis();
			_node = null;
			
			super.dispose();
		}
		
		public final function putInStasis():void
		{
			roomData = null;
			_cartPos = null;
			_path.length = 0;
			destination = null;
			_movedAmountPoint = null;
			_entity_mc = null;
		}
		
		public final function loop():void
		{
			cartPosPrevious = _cartPos.clone();
			aiWalk();
		}
		
		private function setFaceView():void
		{
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
		}
		
		public final function move():void
		{			
			_moved = false;
			
			setFaceView();
			
			if (! idle && checkWalkable())
			{
				_cartPos.x += _speed * dX;
				_cartPos.y += _speed * dY;
				
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
				broadcastEvent( NEW_NODE , {node: _node} );
			}
			
			_movedAmountPoint = _cartPos.subtract(cartPosPrevious);
			
			if (broadcastPathComplete)
			{
				broadcastPathComplete = false;
				broadcastEvent( PATH_COMPLETE );
			}
		}
		
		private function checkWalkable():Boolean
		{
			var newPos:Point = new Point();
			newPos.x = _cartPos.x + (_speed * dX);
			newPos.y = _cartPos.y + (_speed * dY);
			
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
				var nodeType:uint = getWalkable()[newPos.y][newPos.x];
				if(!isWalkable(nodeType))
				{
					return false;
				}
				else
				{
					if (nodeType > 1)
					{
						broadcastEvent( WALKING_ON_NODE_TYPE_OTHER, {nodeType: nodeType} );
					}
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
			if(_path.length == 0 && !destination)
			{
				//path has ended
				dX = dY = 0;
				return;
			}
			
			if ( !isWalkable( getWalkable()[_node.y][_node.x] ) )
			{
				destination = _nodePrevious;
			}
			else if( _node.equals(destination))
			{	
				var newPos:Point = new Point(_node.x * roomData.nodeWidth + (roomData.nodeWidth / 2), _node.y * roomData.nodeWidth + (roomData.nodeWidth / 2));
				if (Point.distance(newPos, cartPos) <= _speed)
				{
					destination = _path.pop();
					
					if (destination) getMovement();
					
					entityArrivedAtNextNode();
					
					if (!destination) broadcastPathComplete = true;
				}
			}
		}
		
		private function entityArrivedAtNextNode():void
		{
			putEntityInMiddleOfNode();
			
			broadcastEvent( PATH_ARRIVED_NEXT_NODE );
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
			
			_path = PathFinder.go( startNode.x, startNode.y, nodePoint.x, nodePoint.y, getWalkable(), walkableList );
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
		
		// Don't need to add 0. This tells the pathfinder to count other numbers as walkable besides 0.
		// use this when you want the Enemy to walk on nodes that activate other behaviors, such as lava causing damage.
		// override this method in your projects Enemy or Hero Class to remove or add walkable node types.
		protected function setupWalkableList():void
		{
			
		}
		
		public final function isWalkable(num:uint):Boolean
		{
			if (num == 0) return true;
			
			if (walkableList) if (walkableList.indexOf(num) > -1) return true;
			
			return false;
		}
		
		protected function getWalkable():Array
		{
			return roomData.roomWalkable;
		}
	}
}