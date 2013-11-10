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
package dorkbots.dorkbots_broadcasters{	/**	 * <b>BroadcasterManager</b> - Wraps or encapsulates the Broadcaster. Instantiate this class to broadcast events. This helps to secure the broadcasting of events, only this class can initiate a broadcast. The owner instantiates a BroadcasterManager and does not allow outside access it, it only shares access to the BroadcasterManager's Broadcaster. Other objects add listeners to the owner's Broadcaster. Use a getter or public var to allow access.	 * <ol>	 *		<li> <b>owner</b> The owner of the broadcasts. This is the object that instantiates BroadcasterManager and initiates the broadcast of events.</li>	 * </ol>	 */	public class BroadcasterManager implements IBroadcasterManager	{		private var _owner:Object;		private var _broadcaster:IBroadcaster;		private var broadcasterInternal:Broadcaster;				public function BroadcasterManager(owner:Object)		{			_owner = owner;			_broadcaster = new Broadcaster();			broadcasterInternal = Broadcaster(_broadcaster);		}				/**		 * Returns the instance of the broadcaster. The owner object gives public access to this object.		 * 		 */		public final function get broadcaster():IBroadcaster		{			return _broadcaster;		}				/**		 * Used by the owner object to broadcast an event. Only the owner object should be allowed to broadcast an event, this is why this functionality is only available in the BroadcasterManger and not the Broadcaster.		 * 		 * @param name The name string of the event.		 * @param object An optional object that will be attached to the IBroadcastedEvent.		 */		public final function broadcastEvent(name:String, object:Object = null):void		{			broadcasterInternal.broadcastEvent(name, _owner, object);		}				/**		 * Removes all listeners and all events.		 * 		 */		public final function removeAllListeners():void		{			broadcasterInternal.removeAllListeners();		}				/**		 * Performs a clean up of the BroadcastManager and Broadcaster.		 * 		 */		public final function dispose():void		{			_owner = null;			_broadcaster = null;			broadcasterInternal.dispose();			broadcasterInternal = null;		}	}}