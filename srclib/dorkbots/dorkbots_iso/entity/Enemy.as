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
			var newWalkable:Array = new Array();
			
			var i:int;
			
			for (i = 0; i < roomData.roomNodeGridHeight; i++)
			{
				newWalkable[i] = new Array();
				for (var j:uint = 0; j < roomData.roomNodeGridWidth; j++)
				{
					newWalkable[i][j] = roomData.roomWalkable[i][j];
				}
			}
			
			var enemy:IEnemy;
			for (i = 0; i < roomData.enemies.length; i++) 
			{
				enemy = roomData.enemies[i];
				if (enemy != this) 
				{
					newWalkable[enemy.node.y][enemy.node.x] = 1;
				}
			}
			
			return newWalkable;
		}
	}
}