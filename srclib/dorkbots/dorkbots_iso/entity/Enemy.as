package dorkbots.dorkbots_iso.entity
{
	public class Enemy extends Entity implements IEnemy
	{
		public function Enemy()
		{
			super();
		}
		
		override protected function getWalkable():Array
		{
			return roomData.enemiesWalkable;
		}
	}
}