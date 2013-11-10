package dorkbots.dorkbots_iso
{
	import flash.display.MovieClip;

	public class IsoRoomData implements IIsoRoomData
	{
		protected var _roomWalkable:Array = 
		  // 0  1  2  3  4  5  6  7  8  9 10 11 12
		   [[1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1], // 0
			[1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1], // 1
			[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1], // 2
			[1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1], // 3
			[1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1], // 4
			[0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0], // 5
			[1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1], // 6
			[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1], // 7
			[1, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 1], // 8
			[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1], // 9
			[1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 1], // 10
			[1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1], // 11
			[1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1]];// 12
		
		
		protected var _roomPickups:Array =
		  // 0  1  2  3  4  5  6  7  8  9 10 11 12
		   [[0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0], // 0
			[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], // 1
			[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], // 2
			[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], // 3
			[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], // 4
			[0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1], // 5
			[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], // 6
			[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], // 7
			[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], // 8
			[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], // 9
			[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], // 10
			[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], // 11
			[0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0]];// 12
		
		
		protected var _roomTerrain:Array = 
		  // 0  1  2  3  4  5  6  7  8  9 10 11 12
		   [[1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1], // 0
			[1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1], // 1
			[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1], // 2
			[1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1], // 3
			[1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1], // 4
			[0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0], // 5
			[1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1], // 6
			[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1], // 7
			[1, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 1], // 8
			[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1], // 9
			[1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 1], // 10
			[1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1], // 11
			[1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1]];// 12
		
		
		protected var _roomTriggers:Array = 
		   // 0  1  2  3  4  5  6  7  8  9 10 11 12
		   [[0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0], // 0
			[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], // 1
			[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], // 2
			[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], // 3
			[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], // 4
			[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3], // 5
			[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], // 6
			[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], // 7
			[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], // 8
			[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], // 9
			[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], // 10
			[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], // 11
			[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]];// 12
		
		
		protected var _roomEntities:Array = 
		  // 0  1  2  3  4  5  6  7  8  9 10 11 12
		   [[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], // 0
			[0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], // 1
			[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], // 2
			[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], // 3
			[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], // 4
			[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], // 5
			[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], // 6
			[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], // 7
			[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], // 8
			[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], // 9
			[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], // 10
			[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], // 11
			[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]];// 12
		
		
		private var _roomNodeWidth:uint;
		private var _roomNodeHeight:uint;
		
		protected var _viewWidth:Number = 800;
		protected var _viewHeight:Number = 600
		protected var _nodeWidth:uint = 50;
		protected var _borderOffsetY:uint = 20;
		protected var _borderOffsetX:uint = 320;
		
		// hero
		protected var heroClass:Class;
		private var _hero:MovieClip;
		protected var _heroHalfSize:uint = 20;
		
		//the tiles
		protected var terrainTileClass:Class;
		private var _terrainTile:MovieClip;
		protected var pickupTileClass:Class;
		private var _pickupTile:MovieClip;
		
		//to handle direction movement
		protected var _speed:uint = 6;
		protected var _heroFacing:String = "south";
		
		public final function IsoRoomData()
		{
		}

		public final function init():void
		{
			_roomNodeWidth = _roomWalkable[0].length;
			_roomNodeHeight = _roomWalkable.length;
		}
		
		public final function stasis():void
		{
			_hero = null;
			_terrainTile = null;
		}
		
		public final function dispose():void
		{
			_roomWalkable.length = 0;
			_roomWalkable = null;
			_roomTerrain.length = 0;
			_roomTerrain = null;
			_roomTriggers.length = 0;
			_roomTriggers = null;
			_roomPickups.length = 0;
			_roomPickups = null;
			_roomEntities.length = 0;
			_roomEntities = null;
			
			heroClass = null;
			terrainTileClass = null;
			pickupTileClass = null;
			
			stasis();
		}
		
		public final function get heroFacing():String
		{
			return _heroFacing;
		}

		public final function get speed():uint
		{
			return _speed;
		}

		public final function get terrainTile():MovieClip
		{
			if (_terrainTile == null) _terrainTile = new terrainTileClass();
			return _terrainTile;
		}

		public final function get pickupTile():MovieClip
		{
			if (_pickupTile == null) _pickupTile = new pickupTileClass();
			return _pickupTile;
		}
		
		public final function get hero():MovieClip
		{
			if (_hero == null) _hero = new heroClass();
			return _hero;
		}

		
		public final function get heroHalfSize():uint
		{
			return _heroHalfSize;
		}

		public final function get borderOffsetX():uint
		{
			return _borderOffsetX;
		}

		public final function get borderOffsetY():uint
		{
			return _borderOffsetY;
		}

		public final function get nodeWidth():uint
		{
			return _nodeWidth;
		}
		
		public final function get viewHeight():Number
		{
			return _viewHeight;
		}
		
		public final function get viewWidth():Number
		{
			return _viewWidth;
		}
		
		public final function get roomNodeHeight():uint
		{
			return _roomNodeHeight;
		}
		
		public final function get roomNodeWidth():uint
		{
			return _roomNodeWidth;
		}
		
		public final function get roomWalkable():Array
		{
			return _roomWalkable;
		}
		
		public final function get roomTerrain():Array
		{
			return _roomTerrain;
		}
		
		public final function get roomTriggers():Array
		{
			return _roomTriggers;
		}
		
		public final function get roomPickups():Array
		{
			return _roomPickups;
		}
		
		public final function get roomEntities():Array
		{
			return _roomEntities;
		}
	}
}