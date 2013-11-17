package dorkbots.dorkbots_iso.pathfinding
{
	public class PathFinding implements IPathFinding
	{
		public function PathFinding()
		{
		}
		
		public final function getPathFinder():PathFinder
		{
			return new PathFinder();
		}
	}
}