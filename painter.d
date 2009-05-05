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
 	
 	
 	uint[][] selectColumns() {
 		// sprawdzenie numeracji wierszy - liczba wierszy, gestosc rozmieszczenia - wszystko w kolejnosci topologicznej
		uint[] rowCapacity; // wiersze zasadniczo numerowane od 1, ale tu od 0, aby nie marnowac miejsca
		uint[] colCapacity;
		for (uint i = 0; i < elmts.length; i++) {
			if (elmts[i].row > rowCapacity.length) rowCapacity.length = elmts[i].row;
			rowCapacity[elmts[i].row - 1] += 1; // przenumerowanie do 0
			elmts[i].column = rowCapacity[elmts[i].row - 1];
			if (elmts[i].column > colCapacity.length) colCapacity.length = elmts[i].column;
			colCapacity[elmts[i].column - 1] += 1;
		}
		for (uint i = 0; i < elmts.length; i++) {
			uint row = elmts[i].row;
			//writefln(colCapacity.length);
			// fragment kodu odpowiedzialny za wyrownywanie elementow posetu do srodka diagramu
			if (rowCapacity[row - 1] < colCapacity.length) {
				//writefln("rowCapacity: ", rowCapacity[row - 1]);
				colCapacity[elmts[i].column - 1] -= 1;
				colCapacity[(elmts[i].column + ((colCapacity.length - rowCapacity[row - 1]) / 2)) - 1] += 1;
				elmts[i].column += (colCapacity.length - rowCapacity[row - 1]) / 2;
			}
		}
		return [rowCapacity, colCapacity];
 	}
 	
 	
 	public:
 	this(Poset P = null) {
 		this.P = new Poset();
 		if (P !is null) {
 			createPainter(P);
 			/+debug for (uint i = 0; i < elmts.length; i++) writef("%2s ", elmts[i].elmt);
 			debug writefln();
 			debug for (uint i = 0; i < elmts.length; i++) writef("%2s ", elmts[i].row);
 			debug writefln();+/
 		}
 	}
 	
 	
 	~this() {
 		
 	}
 	
 	
 	void createPainter(Poset P) {
 		if (P is null) return;
 		this.P = new Poset();
 		this.P.setInOutList(P.getInlist(), P.getOutlist());
		createPosetArray();
		uint[][] capacity = selectColumns();
 	}
 	
 	
 	uint[2][] getGrid(uint minSpace, uint maxSpace, uint gridWidth, uint gridHeight) {
 		if ((gridWidth <= 20) || (gridHeight <= 20)) return [];
 		uint rows, columns;
 		uint[] rowCapacity, colCapacity;
 		for (uint i = 0; i < elmts.length; i++) {
 			rows = rows < elmts[i].row ? elmts[i].row : rows;
 			columns = columns < elmts[i].column ? elmts[i].column : columns;
 			if (rowCapacity.length < elmts[i].row) rowCapacity.length = elmts[i].row;
 			if (colCapacity.length < elmts[i].column) colCapacity.length = elmts[i].column;
 			rowCapacity[elmts[i].row - 1] += 1;
 			colCapacity[elmts[i].column - 1] += 1;
 		}
 		uint[2][] result;
 		result.length = elmts.length;
 		uint space = gridWidth < gridHeight ? (gridWidth - 20) / (columns - 1) : (gridHeight - 20) / (columns - 1);
 		if (space < minSpace) space = minSpace;
 		else if (space > maxSpace) space = maxSpace;
 		uint y11 = (rows - 1) * space + 20;
 		uint x11 = 20;
 		if ((columns - 1) * space + 20 < gridWidth) {
 			x11 += (gridWidth - ((columns - 1) * space + 20)) / 2;
 		}
 		/+if (y11 < gridHeight) {
 			y11 += (gridHeight - y11) / 2;
 		}+/
 		foreach (i; elmts) {
 			result[i.elmt][0] = x11 + space * (i.column - 1);
 			result[i.elmt][1] = y11 - space * (i.row - 1);
 		}
 		return result;
 	}
 	
 	
 } // end of PosetPainter class definition
 