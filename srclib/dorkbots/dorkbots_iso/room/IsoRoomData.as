package dorkbots.dorkbots_iso.room
{
	import flash.display.MovieClip;
	
	import dorkbots.dorkbots_iso.entity.IEnemy;

	public class IsoRoomData implements IIsoRoomData
	{
		protected var _roomWalkable:Array;
		protected var _roomPickups:Array;
		protected var _roomTerrain:Array;
		protected var _roomTriggers:Array;
		protected var _roomEntities:Array;
		
		private var _roomNodeGridWidth:uint;
		private var _roomNodeGridHeight:uint;
		
		protected var _viewWidth:Number = 800;
		protected var _viewHeight:Number = 600
		protected var _nodeWidth:uint = 50;
		protected var _borderOffsetY:uint = 20;
		protected var _borderOffsetX:uint = 320;
		
		// hero
		protected var heroClass:Class;
		private var _hero:MovieClip;
		protected var _heroHalfSize:uint = 20;
		
		// enemy
		protected var enemyClass:Class;
		protected var _enemyHalfSize:uint = 20;
		private var _enemies:Vector.<IEnemy> = new Vector.<IEnemy>();
		
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
			_roomNodeGridWidth = _roomWalkable[0].length;
			_roomNodeGridHeight = _roomWalkable.length;
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
			enemyClass = null;
			_enemies.length = 0;
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
		
		public function get enemyHalfSize():uint
		{
			return _enemyHalfSize;
		}
		
		public function createEnemy(type:uint):MovieClip
		{
			return new enemyClass();
		}
		
		public final function set enemies(value:Vector.<IEnemy>):void
		{
			_enemies = value;
		}
		
		public final function get enemies():Vector.<IEnemy>
		{
			return _enemies;
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
		
		public final function get roomNodeGridHeight():uint
		{
			return _roomNodeGridHeight;
		}
		
		public final function get roomNodeGridWidth():uint
		{
			return _roomNodeGridWidth;
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