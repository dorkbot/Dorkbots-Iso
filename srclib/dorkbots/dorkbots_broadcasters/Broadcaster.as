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
package dorkbots.dorkbots_broadcasters{	/**	 * Broadcaster - This class should only be instantiated by BroadcasterManager. Use a BroadcasterManager to initiate and share broadcasts.	 * 	 */	public class Broadcaster implements IBroadcaster	{		private var _broadcastedEvent:String = "";				private var eventNames:Vector.<String> = new Vector.<String>();		private var callbacks:Vector.< Vector.< Function > > = new Vector.< Vector.< Function > >();				public function Broadcaster()		{		}				/**		 * Returns the last broadcasted event.		 * 		 * @return Returns a String - The last broadcasted event.		 */		public final function broadcastedEvent():String
		{
			return _broadcastedEvent;
		}		/**		 * Attaches callback functions to event strings.		 * 		 * @param name The name string of the event. Make sure that the owner object of the broadcaster does broadcast the event name.		 * @param callback The function that will be called when the event is broadcasted. The callback function must expect an IBroadcastedEvent as a parameter.		 */		public final function addEventListener(name:String, callback:Function):void		{			var index:int = eventNames.indexOf(name);			if (index > -1)			{				// get list of callbacks for the event name				var callbacksForEventName:Vector.<Function> = callbacks[index];				// make sure callback isn't already attached				if (callbacksForEventName.indexOf(callback) < 0)				{					callbacksForEventName.push(callback);				}			}			else			{				// event name is not listed so add it				eventNames.push(name);				// add the call back and new call back list/vector				callbacks.push( Vector.<Function>( [ callback ] ) );			}		}				/**		 * Removes callback functions to event strings.		 * 		 * @param name The name string of the event. Make sure that the owner object of the broadcaster does broadcast the event name.		 * @param callback The function that will be called when the event is broadcasted. The callback function must expect an IBroadcastedEvent as a parameter.		 */		public final function removeEventListener(name:String, callback:Function):void		{			var indexNames:int = eventNames.indexOf(name);			if (indexNames > -1)			{				// get list of callbacks for the event name 				var callbacksForEventName:Vector.<Function> = callbacks[indexNames];				// make sure callback isn't already attached				var indexCallbacks:int = callbacksForEventName.indexOf(callback);				if (indexCallbacks > -1)				{					// remove call back					callbacksForEventName.splice(indexCallbacks, 1);				}				if (callbacksForEventName.length == 0)				{					// no call backs for event name so remove event name					eventNames.splice(indexNames, 1);					// and remove call back list/vector					callbacks.splice(indexNames, 1);				}			}		}				internal final function broadcastEvent(name:String, owner:Object, object:Object = null):void		{			_broadcastEvent(name, owner, object);						// don't broadcast the BROADCAST_SENT event if a BroadcasterState has broadcasted the STATE_UPDATED event.			if (name != BroadcasterEvents.STATE_UPDATED)			{				_broadcastEvent(BroadcasterEvents.BROADCAST_SENT, owner, object);			}		}				private function _broadcastEvent(name:String, owner:Object, object:Object = null):void		{			switch(name)			{				case BroadcasterEvents.BROADCAST_SENT:				case BroadcasterEvents.STATE_UPDATED:					// don't save the event name					break;				default:					_broadcastedEvent = name;					break;			}						var index:int = eventNames.indexOf(name);			if (index > -1)			{				// get list of callbacks for the event name				var callbacksForEventName:Vector.<Function> = callbacks[index];				for (var i:int = 0; i < callbacksForEventName.length; i++) 				{					callbacksForEventName[i].call( null, new BroadcastedEvent( name, owner, object ) );				}			}		}				internal final function removeAllListeners():void		{			eventNames.length = 0;			for (var i:int = 0; i < callbacks.length; i++) 			{				callbacks[i].length = 0;			}			callbacks.length = 0;		}				internal final function dispose():void		{			removeAllListeners();		}	}}