package dorkbots.dorkbots_iso.entity
{
	import com.csharks.juwalbose.IsoHelper;
	import com.newarteest.path_finder.PathFinder;
	
	import flash.display.MovieClip;
	import flash.geom.Point;
	
	import dorkbots.dorkbots_iso.room.IIsoRoomData;

	public class Entity implements IEntity
	{
		private var roomData:IIsoRoomData;
		
		private var cornerPoint:Point = new Point();
		
		private var borderOffsetX:Number;
		private var borderOffsetY:Number;
		
		private var _cartPos:Point = new Point();
		private var _node:Point = new Point();
		
		private var _path:Array = new Array();
		private var destination:Point = new Point();
		private var stepsTillTurn:uint = 5;
		private var stepsTaken:uint;
		
		private var speed:Number;
		private var _halfSize:Number;
		private var _movedAmountPoint:Point = new Point();
		
		private var _dX:Number = 0;
		private var _dY:Number = 0;
		private var idle:Boolean = true;
		private var _facing:String;
		private var _currentFacing:String;
		
		private var _moved:Boolean = true;
		
		private var _entity_mc:MovieClip;
		
		public function Entity()
		{
		}
		
		public function init(a_mc:MovieClip, aSpeed:Number, aHalfSize:Number, aRoomData:IIsoRoomData):IEntity
		{
			_path.length = 0;
			_entity_mc = a_mc;
			speed = aSpeed;
			_halfSize = aHalfSize;
			roomData = aRoomData;
			borderOffsetX = roomData.borderOffsetX;
			borderOffsetY = roomData.borderOffsetY;
			
			stepsTillTurn = Math.floor((roomData.nodeWidth / 2) / speed);
			
			return this;
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
			_node = value;
		}
		
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
		
		public final function get facing():String
		{
			return _facing;
		}
		
		public final function set facing(value:String):void
		{
			_facing = value;
		}
		
		public final function get currentFacing():String
		{
			return _currentFacing;
		}
		
		public final function set currentFacing(value:String):void
		{
			_currentFacing = value;
		}
		
		public final function loop(aCornerPoint:Point):void
		{
			cornerPoint = aCornerPoint;
			aiWalk();
		}
		
		public final function move():void
		{
			_node = IsoHelper.getNodeCoordinates(_cartPos, roomData.nodeWidth);
			
			_moved = false;
			if (dY == 0 && dX == 0)
			{
				if (_facing != "") _entity_mc.clip.gotoAndStop(_facing);
				idle = true;
			}
			else if (idle || _currentFacing != _facing)
			{
				idle = false;
				_currentFacing = _facing;
				_entity_mc.clip.gotoAndPlay(_facing);
			}
			
			if (! idle && isWalkable())
			{
				_movedAmountPoint.x = speed * dX;
				_movedAmountPoint.y = speed * dY;
				_cartPos.x +=  _movedAmountPoint.x;
				_cartPos.y +=  _movedAmountPoint.y;
				
				_moved = true;
			}
		}
		
		private function isWalkable():Boolean
		{
			var newPos:Point = new Point();
			newPos.x = _cartPos.x + (speed * dX);
			newPos.y = _cartPos.y + (speed * dY);
			
			switch (_facing)
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
				if(roomData.roomWalkable[newPos.y][newPos.x] == 1)
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
				//reached current destination, set new, change direction
				//wait till we are few steps into the tile before we turn
				stepsTaken++;
				if(stepsTaken < stepsTillTurn)
				{
					return;
				}
				
				//place the hero at tile middle before turn
				var pos:Point = new Point();
				
				pos.x = _node.x * roomData.nodeWidth + (roomData.nodeWidth / 2) + cornerPoint.x;
				pos.y = _node.y * roomData.nodeWidth + (roomData.nodeWidth / 2) + cornerPoint.y;
				
				pos = IsoHelper.twoDToIso(pos);
				
				_entity_mc.x = borderOffsetX + pos.x;
				_entity_mc.y = borderOffsetY + pos.y;
				
				_cartPos.x = _node.x * roomData.nodeWidth + roomData.nodeWidth / 2;
				_cartPos.y = _node.y * roomData.nodeWidth + roomData.nodeWidth / 2;
				
				//new point, turn, find dX,dY
				stepsTaken = 0;
				destination = _path.pop();
				getMovement();
			}
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
					_facing = "east";
				}
				else if (dY == 1)
				{
					_facing = "southeast";
					dX = dY = 0.75;
				}
				else
				{
					_facing = "northeast";
					dX = 0.75;
					dY = -0.75;
				}
			}
			else if (dX == -1)
			{
				if (dY == 0)
				{
					_facing = "west";
				}
				else if (dY == 1)
				{
					_facing = "southwest";
					dY = 0.75;
					dX = -0.75;
				}
				else
				{
					_facing= "northwest";
					dX = dY = -0.75;
				}
			}
			else
			{
				if (dY == 0)
				{
					_facing = _currentFacing;
				}
				else if (dY == 1)
				{
					_facing = "south";
				}
				else
				{
					_facing = "north";
				}
			}
		}
		
		public final function createPath(nodePoint:Point):void
		{
			destination = _node;
			_path = PathFinder.go( _node.x, _node.y, nodePoint.x, nodePoint.y, roomData.roomWalkable );
			path.reverse();
			path.push(nodePoint);
			path.reverse();
			
			getMovement();
		}
	}
}