/*
FPT Jump Demo - demonstration of FPT-methods for the jump number problem
Copyright (C) 2009 Tomasz Polachowski, sprytnyserek@gmail.com

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 3
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA,
or see <http://www.gnu.org/licenses/>.
*/
/**
 * Obsługa rysowania posetu
 *
 * Zawiera definicję rysownika porządkującego
 *
 * Author: Tomasz Polachowski, $(LINK2 mailto:sprytnyserek@gmail.com,sprytnyserek@gmail.com)
 * License: GNU General Public License 3, $(LINK http://www.gnu.org/licenses/gpl.html)
 * Version: 1.0
 */
 module painter;
 
 private {
 	import dfl.all;
 	
 	import std.math;
 	import std.conv;
 } // end of imports
 
 
 class PosetPainter {
 	private:
 	struct PosetElmt {
 		uint elmt;
 		uint row, column;
 		float xCoor = float.infinity, yCoor = float.infinity;
 		bool disabled;
 		PosetElmt*[] covering, coveredBy;
 	} // end of PosetElmts private struct definition
 	
 	PosetElmt[] elmts; // array of poset elements in topological (progressive) order
 	
 	
 	public:
 	this() {
 		
 	}
 	
 	
 	~this() {
 		
 	}
 	
 } // end of PosetPainter class definition
 