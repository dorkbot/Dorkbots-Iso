package dorkbots.dorkbots_iso.room
{
	import flash.display.MovieClip;
	
	import dorkbots.dorkbots_iso.entity.IEnemy;

	public class IsoRoomData implements IIsoRoomData
	{
		protected var _roomWalkable:Array;
		protected var _roomPickups:Array;
		protected var _roomTileArt:Array;
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
		private var _enemiesWalkable:Array = new Array();
		
		//the tiles
		protected var tileArtClass:Class;
		private var _tileArt:MovieClip;
		protected var tilePickupClass:Class;
		private var _tilePickup:MovieClip;
		
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
			_tileArt = null;
		}
		
		public final function dispose():void
		{
			_roomWalkable.length = 0;
			_roomWalkable = null;
			_roomTileArt.length = 0;
			_roomTileArt = null;
			_roomTriggers.length = 0;
			_roomTriggers = null;
			_roomPickups.length = 0;
			_roomPickups = null;
			_roomEntities.length = 0;
			_roomEntities = null;
			
			heroClass = null;
			enemyClass = null;
			_enemies.length = 0;
			tileArtClass = null;
			tilePickupClass = null;
			
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

		public final function get tileArt():MovieClip
		{
			if (_tileArt == null) _tileArt = new tileArtClass();
			return _tileArt;
		}

		public final function get tilePickup():MovieClip
		{
			if (_tilePickup == null) _tilePickup = new tilePickupClass();
			return _tilePickup;
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
		
		public final function get enemiesWalkable():Array
		{
			return _enemiesWalkable;
		}
		
		public final function set enemiesWalkable(value:Array):void
		{
			_enemiesWalkable = value;
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
		
		public final function get roomTileArt():Array
		{
			return _roomTileArt;
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