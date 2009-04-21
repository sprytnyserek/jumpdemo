﻿/*
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
 * Podstawowe struktury danych dla programu
 *
 * Zawiera definicje posetu oraz drzewa wyszukiwań dla rozwiązań problemu skoków w posecie.
 *
 * Author: Tomasz Polachowski, $(LINK2 mailto:sprytnyserek@gmail.com,sprytnyserek@gmail.com)
 * License: GNU General Public License 3, $(LINK http://www.gnu.org/licenses/gpl.html)
 * Version: 1.0
 */
module structure;

private {
	import std.stdio;
	import std.string;
	import std.stream;
	import std.conv;
}

class Poset {
	private:
	uint[][] inlist;
	uint[][] outlist;
	uint n;
	uint[] result;
	
	void accessibleFrom(uint node) {
		if (this.inlist[node].length > 1) return;
		else {
			this.result.length = this.result.length + 1;
			this.result[length - 1] = node;
			foreach (uint i; this.outlist[node]) this.accessibleFrom(i);
		}
	}
	
	void maxAccessibleFrom(uint node) {
		bool isMaxAccessible = true;
		
		foreach (uint i; this.outlist[node]) {
			if (this.inlist[i].length > 1) {
				continue;
			}
			else {
				isMaxAccessible = false;
				this.maxAccessibleFrom(i);
			}
		}
		if (isMaxAccessible) {
			this.result.length = this.result.length + 1;
			this.result[length - 1] = node;
		}
	}
	
	
	private bool isConsistent() {
		for (uint i = 0; i < inlist.length; i++) {
			foreach (uint j; inlist[i]) if (!contains(outlist[j],i)) return false;
			foreach (uint j; outlist[i]) if (!contains(inlist[j],i)) return false;
		}
		return true;
	}
	
	
	private void correctDef() {
		for (uint i = 0; i < inlist.length; i++) {
			foreach (uint j; inlist[i]) {
				if (j >= outlist.length) throw new Exception("No such poset element: " ~ std.string.toString(j));
				if (!contains(outlist[j],i)) {
					outlist[j].length = outlist[j].length + 1;
					outlist[j][length - 1] = i;
				}
			}
			foreach (uint j; outlist[i]) {
				if (j >= inlist.length) throw new Exception("No such poset element: " ~ std.string.toString(j));
				if (!contains(inlist[j],i)) {
					inlist[j].length = inlist[j].length + 1;
					inlist[j][length - 1] = i;
				}
			}
		}
	}
	
	
	public:
	this() {
		inlist = [];
		outlist = [];
		n = 0;
	}
	
	/*this(uint[][] inlist, uint[][] outlist) {
		this.setInOutList(inlist,outlist);
	}*/
	
	~this() {
		inlist.length = 0;
		outlist.length = 0;
	}
	
	uint[][] getInlist() {
		return inlist.dup;
	}
	
	uint[][] getOutlist() {
		return outlist.dup;
	}
	
	uint getCurrency() {
		return this.n;
	}
	
/* *******************************************************************************************
@#*$(#((#*(*(@*(*#(@**(@#*(*#(@*#*@(#*(@*#(*@(#*(@*#(*@#*(@*#(*#()@*#(@*(#*@(#*(@*(#*@(*#(@*#(
#@(*@#*(*#(@*#()*@(#*(@*#(*(@*#(@*#&@*&#&@^&%&^$@*&$(@*#@%$^@%^$%%$^*(@&$(*@$)*_)*(^$@%$&@^*$&
@#&^&@^&#^@(&#^*&@#*(&@#)&@(#*(*@#)_@*#)_*@(#)_*(#)_(@)_(#)_@(*#)_*@)_*#)_@*#*@(*#*@#*@*)#*#*0
%@^&%#^!%@*(!&(#*(!&#^!&#^!*&#(!(#*_!*#(@&*#%@$#%@^&%#&@$()_($)@*^#&@^@$!*)%&$!*%&$^!^)$&!*&!%
&%$*^&^$%*(&^%$@#*(%^@#&*^&*^%$##%^*&^%$#@$%^&^*%$#@#$%^&^%$#@$%^&^%$#$^^&%$#@&&*^%$##^*&%$#&^
*********************************************************************************************/
	/* !!!DODAĆ WERYFIKACJĘ !!! */
	void setInOutList(uint[][] inlist,uint[][] outlist) {
		if ((inlist.length == 0) || (inlist.length != inlist.length)) throw new Exception("inlist-outlist length mismatch");
		this.inlist.length = 0;
		this.outlist.length = 0;
		this.inlist = inlist[];
		this.outlist = outlist[];
		//writefln(inlist);
		//writefln(outlist);
		for (uint i = 0; i < inlist.length; i++) {
			inlist[i] = unique(inlist[i]);
			outlist[i] = unique(outlist[i]);
		}
		n = inlist.length;
		correctDef();
	}
	
	uint[] accessible() { // returns num array
		uint[] min;
		this.result.length = 0;
		
		for (uint i = 0; i < n; i++) if (this.inlist[i].length == 0) {
			min.length = min.length + 1;
			min[length - 1] = i;
		}
		foreach (uint i; min) this.accessibleFrom(i);
		return result;
	}
	
	uint[] maxAccessible() { // returns num array
		uint[] min;
		this.result.length = 0;
		
		for (uint i = 0; i < n; i++) if (this.inlist[i].length == 0) {
			min.length = min.length + 1;
			min[length - 1] = i;
		}
		foreach (uint i; min) this.maxAccessibleFrom(i);
		return result;
	}
	
	
	int fromFile(char[] filename) {
		File file = new File();
		try {
			file.open(filename);
		}
		catch (Exception ex) {
			return -1;
		}
		if (file.eof()) return -1;
		char[] line;
		line = file.readLine();
		uint n;
		n = std.conv.toUint(line);
		uint[][] inlist;
		uint[][] outlist;
		char[][] elmts;
		inlist.length = outlist.length = n;
		uint i = 0, k = 0;
		while ((!file.eof) && (i < n)) {
			line = file.readLine();
			elmts = split(line);
			for (uint j = 0; j < elmts.length; j++) {
				uint elmt = std.conv.toUint(elmts[j]);
				if (elmt >= n) continue;
				inlist[i].length = inlist[i].length + 1;
				inlist[i][length - 1] = elmt;
			}
			k++;
			if (file.eof()) break;
			line = file.readLine();
			elmts = split(line);
			for (uint j = 0; j < elmts.length; j++) {
				uint elmt = std.conv.toUint(elmts[j]);
				if (elmt >= n) continue;
				outlist[i].length = outlist[i].length + 1;
				outlist[i][length - 1] = elmt;
			}
			i++;
			k++;
		}
		if ((i == n) && (k == 2 * i)) {
			this.setInOutList(inlist,outlist);
			}
		return 0;
	}
	
}


/**
 * Sprawdzenie, czy tablica $(I a) zawiera element $(I elmt)
 */
private bool contains(uint[] a, uint elmt) {
	uint i;
	
	while (a.length > i) {
		if (a[i++] == elmt) return true;
		}
	return false;
}


/**
 * Zamiana danej tablicy na tablicę bez powtórzeń
 */
private uint[] unique(uint[] a) {
	uint[] result;
	
	foreach (uint i; a) {
		if (!(contains(result,i))) result ~= [i];
	}
	return result;
}


class TreeElmt {
	public:
	Poset P;
	uint[] chain;
	bool[] gottenElmts;
	TreeElmt parent;
	TreeElmt[] children;
	
	this(Poset P, uint[] chain, bool[] gottenElmts = []) {
		this.P = P;
		this.chain = chain;
		if (gottenElmts.length == 0) {
			gottenElmts.length = P.getCurrency();
			for (uint i = 0; i < gottenElmts.length; i++) gottenElmts[i] = false;
		}
		if (gottenElmts.length < P.getCurrency()) {
			uint j = gottenElmts.length;
			gottenElmts.length = P.getCurrency();
			for (uint i = j; i < gottenElmts.length; i++) gottenElmts[i] = false;
			}
	}
	
	TreeElmt[] getChildren() {
		return children;
	}
	
	TreeElmt getParent() {
		return parent;
	}
	
	void addChild(TreeElmt elmt) {
		children.length = children.length + 1;
		children[length - 1] = elmt;
	}
	
}