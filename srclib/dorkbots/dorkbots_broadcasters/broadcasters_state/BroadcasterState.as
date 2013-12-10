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
package dorkbots.dorkbots_broadcasters.broadcasters_state
{
	import dorkbots.dorkbots_broadcasters.BroadcasterEvents;
	import dorkbots.dorkbots_broadcasters.BroadcastingObject;
	
	/**
	 * <b>BroadcasterState</b> - This is an abstract class and should not be instantiated. It deals with broadcasting events and states, setting and recording states, and stricter control of adding listener event names.
	 */
	public class BroadcasterState extends BroadcastingObject implements IBroadcasterState
	{
		private var states:Vector.<String> =  new Vector.<String>();
		private var statesHistory:Vector.<String> =  new Vector.<String>();
		protected var _currentState:String = "";
		protected var _lastState:String = "";
		private var _stateHistoryClearedCount:uint = 0;
		
		public function BroadcasterState()
		{
			super();
			
			addState(BroadcasterEvents.TEST_ONLY_USED_FOR_TESTING);
			
			setUpStates();
		}

		/**
		 * Updates the state of the model.
		 * 
		 * @param state The current state.
		 */
		public final function updateState(state:String, object:Object = null):void
		{			
			if (verifyState(state))
			{
				_lastState = _currentState;
				
				_currentState = state;
				
				stateChange(state, object);
				
				if ( !checkStateHistory( state ) )
				{
					statesHistory.push(state);
				}
				
				broadcastEvent(state, object);
				
				// using a try incase this object has been disposed after the first broadcast/update
				try 
				{ 
					broadcastEvent(BroadcasterEvents.STATE_UPDATED, object);
				} 
				catch (myError:Error) 
				{ 
					// do nothing
				} 
			}
			else
			{
				throw new Error("The state [" + state + "] is an unknown state!! You need to add states via the addState() method.");
			}
		}
		
		/**
		 * Returns the last state.
		 * 
		 */
		public final function get lastState():String
		{
			return _lastState;
		}
		
		/**
		 * Returns the current state.
		 * 
		 */
		public final function get currentState():String
		{
			return _currentState;
		}
		
		/**
		 * Check if the passed state has occured. Returns "true" if the state is in the history.
		 * 
		 * @param state The state to look for.
		 */
		public final function checkStateHistory(state:String):Boolean
		{
			if (statesHistory.indexOf(state) < 0)
			{
				return false;
			}
			
			return true;
		}
		
		/**
		 * Clears state history.
		 * 
		 */
		public final function clearStateHistory():void
		{
			_stateHistoryClearedCount++;
			statesHistory.length = 0;
		}
		
		/**
		 * Returns the amount of times the state history has been cleared.
		 * 
		 */
		public final function get stateHistoryClearedCount():uint
		{
			return _stateHistoryClearedCount;
		}
		
		/**
		 * Performs a clean up.
		 * 
		 */
		override public function dispose():void
		{
			states.length = 0;
			statesHistory.length = 0;
			
			super.dispose();
		}
		
		/**
		 * The concrete sub classes use this method to add state names to the states array.
		 * 
		 * @param state The current state.
		 */
		protected final function addState(state:String):void
		{
			states.push(state);                                                                                                        
		}		
		
		/**
		 * Used for concrete actions and methods to be taken by the model when certain states are set. This method is meant to be overridden.
		 * 
		 * @param state The current state.
		 */
		protected function stateChange(state:String, object:Object = null):void
		{
			// Don't add functionality
		}
		
		/**
		 * Used by concrete sub classes to set up and add state names to the states array. This method is meant to be overridden.
		 * 
		 */
		protected function setUpStates():void
		{
			// Don't add functionality
		}
		
		/**
		 * By default this overrides the method and adds verification via the verifyState method. This can be overridden to separate that dependence adding more flexibility.
		 * 
		 * @param name The name string of the event. Make sure that the owner object of the broadcaster does broadcast the event name.
		 */
		override protected function verifyEventName(name:String):Boolean
		{
			return verifyState(name);
		}
		
		private function verifyState(state:String):Boolean
		{
			if (states.indexOf(state) > -1) return true;
			return false;
		}
	}
}