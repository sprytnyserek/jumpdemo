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
 	import std.stdio;
 	
 	import structure;
 } // end of imports
 
 
 class PosetPainter {
 	private:
 	struct PosetElmt {
 		uint elmt;
 		uint row, column;
 		float xCoor = float.infinity, yCoor = float.infinity;
 		bool disabled;
 		PosetElmt*[] covering, coveredBy;
 		uint[][] coveringIndex, coveredByIndex;
 	} // end of PosetElmts private struct definition
 	
 	PosetElmt[] elmts; // array of poset elements in topological (progressive) order
 	
 	Poset P;
 	
 	
 	void numberizeFrom(uint elmt, bool[] added = []) {
 		if (P is null) return;
 		uint[][] inlist = P.getInlist();
 		uint[][] outlist = P.getOutlist();
 		uint n = P.getCurrency();
 		if (added.length == 0) added.length = n;
 		if (added.length != n) return;
 		if (elmt >= n) return;
 		/+foreach (uint i; outlist[elmt]) {
 			numberizeFrom(i, added);
 		}+/
 		foreach (uint i; inlist[elmt]) {
 			if (!added[i]) numberizeFrom(i, added);
 		}
 		bool exists;
 		for (uint i = 0; i < elmts.length; i++) if (elmts[i].elmt == elmt) exists = true;
 		if (!exists) {
 			PosetElmt e;
			e.elmt = elmt;
			uint max = 0;
			foreach (uint j; inlist[elmt]) for (uint i = 0; i < elmts.length; i++) if (elmts[i].elmt == j) {
				if (max < elmts[i].row) max = elmts[i].row;
			}
			e.row = max + 1;
			elmts.length = elmts.length + 1;
			elmts[length - 1] = e;
		}
 	}
 	
 	
 	void createPosetArray() {
 		if (P is null) return;
 		uint[][] inlist = P.getInlist();
 		uint[][] outlist = P.getOutlist();
 		uint n = P.getCurrency();
 		bool[] added;
 		added.length = n;
 		bool done;
 		while (!done) {
 			done = true;
 			for (uint i = 0; i < n; i++) {
 				if ((!added[i]) && (outlist[i].length == 0)) {
 					done = false;
 					numberizeFrom(i);
 					break;
 				}
 			}
 			for (uint i = 0; i < elmts.length; i++) added[elmts[i].elmt] = true;
 		}
 	}
 	
 	public:
 	this(Poset P = null) {
 		this.P = new Poset();
 		if (P !is null) {
 			this.P.setInOutList(P.getInlist(), P.getOutlist());
 			createPosetArray();
 			
 			debug for (uint i = 0; i < elmts.length; i++) writef("%2s ", elmts[i].elmt);
 			debug writefln();
 			debug for (uint i = 0; i < elmts.length; i++) writef("%2s ", elmts[i].row);
 			debug writefln();
 		}
 	}
 	
 	
 	~this() {
 		
 	}
 	
 } // end of PosetPainter class definition
 