package dorkbots.dorkbots_iso.entity
{
	public class Enemy extends Entity implements IEnemy
	{
		private var attackReadyCount:uint = 0;
		protected var attackReadyLimit:uint = 30;
		
		public function Enemy()
		{
			super();
		}
		
		override protected function getWalkable():Array
		{
			return roomData.enemiesWalkable;
		}

		public final function attackReadyReset():void
		{
			attackReadyCount = 0;
		}
		
		public final function attackReady():Boolean
		{
			if (attackReadyCount == attackReadyLimit )
			{
				return true;
			}
			attackReadyCount++;
			return false;
		}
	}
}