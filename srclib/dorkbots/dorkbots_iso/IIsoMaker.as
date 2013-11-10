package dorkbots.dorkbots_iso
{
	import dorkbots.dorkbots_broadcasters.IBroadcastingObject;
	
	import flash.display.Bitmap;

	public interface IIsoMaker extends IBroadcastingObject
	{
		function get canvas():Bitmap;
		function createLevel():void;
		function loop():void;
	}
}