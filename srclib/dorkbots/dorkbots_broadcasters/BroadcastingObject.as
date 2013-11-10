/*
* Author: Dayvid jones
* http://www.dayvid.com
* Copyright (c) Disco Blimp 2013
* http://www.discoblimp.com
* Version: 1.0.3
* 
* Licence Agreement
*
* You may distribute and modify this class freely, provided that you leave this header intact,
* and add appropriate headers to indicate your changes. Credit is appreciated in applications
* that use this code, but is not required.
* 
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
* 
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
* 
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/
package dorkbots.dorkbots_broadcasters
{
	/**
	 * <b>BroadcastingObject</b> - This is an abstract class and should not be instantiated. It deals with broadcasting events, and offers more strict control of events via inheritance and polymorphism.
	 */
	public class BroadcastingObject implements IBroadcastingObject
	{
		protected var broadcasterManager:IBroadcasterManager;
		
		public function BroadcastingObject()
		{
			broadcasterManager = new BroadcasterManager(this);
		}
		
		/**
		 * Returns the last broadcasted event.
		 * 
		 * @return Returns a String - The last broadcasted event.
		 */
		public final function get broadcastedEvent():String
		{
			return broadcasterManager.broadcaster.broadcastedEvent;
		}
		
		/**
		 * Attaches callback functions to event strings.
		 * 
		 * @param name The name string of the event. Make sure that the owner object of the broadcaster does broadcast the event name.
		 * @param callback The function that will be called when the event is broadcasted. The callback function must expect an IBroadcastedEvent as a parameter.
		 */
		public final function addEventListener(name:String, callback:Function):void
		{
			switch(name)
			{
				case BroadcasterEvents.STATE_UPDATED:
				case BroadcasterEvents.BROADCAST_SENT:
					// Ignore verification for these default events
					break;
				default:
					if (!verifyEventName(name)) throw new Error("UKNOWN NAME --> name = " + name + " || This means method verifyEventName is overriden, and the concrete verification of the event 'name' returned false.");
					break;
			}
			broadcasterManager.broadcaster.addEventListener(name, callback);
		}
		
		/**
		 * The method can be overriden to add verification of events. This could be used with an array of events and verified. It's most used by a BroadcasterState.
		 * returns true if the event is verified.
		 * 
		 * @param name The name string of the event. Make sure that the owner object of the broadcaster does broadcast the event name.
		 */
		protected function verifyEventName(name:String):Boolean
		{
			return true;
		}
		
		/**
		 * Removes callback functions to event strings.
		 * 
		 * @param name The name string of the event. Make sure that the owner object of the broadcaster does broadcast the event name.
		 * @param callback The function that will be called when the event is broadcasted. The callback function must expect an IBroadcastedEvent as a parameter.
		 */
		public final function removeEventListener(name:String, callback:Function):void
		{
			if (broadcasterManager) broadcasterManager.broadcaster.removeEventListener(name, callback);
		}
		
		/**
		 * Removes all listeners and all events.
		 * 
		 */
		public final function removeAllListeners():void
		{
			if (broadcasterManager) broadcasterManager.removeAllListeners();
		}
		
		/**
		 * Performs a clean up of the model.
		 * 
		 */
		public function dispose():void
		{
			if (broadcasterManager)
			{
				broadcasterManager.dispose();
				broadcasterManager = null;
			}
		}
	}
}