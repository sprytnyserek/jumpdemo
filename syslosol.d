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
 * Przedstawienie rozwiązania FPT problemu skoków w posecie według Sysły
 *
 * Author: Tomasz Polachowski, $(LINK2 mailto:sprytnyserek@gmail.com,sprytnyserek@gmail.com)
 * License: GNU General Public License 3, $(LINK http://www.gnu.org/licenses/gpl.html)
 * Version: 1.0
 */
module syslosol;

private {
	import std.math;
	import std.stdio;
	/* internal imports */
	import structure;
} // end of imports


/**
 * Klasa posetu rozszerzona o reprezentację łukową
 */
class ArcPoset : Poset {
	private:
	// uint[][] inlist, outlist; -- derived
	// uint n; -- derived
	uint verts; // number of vertices in arc reprezentation (always equal or more than n + 1)
	uint[uint] tail, head; // tail and head of i-arc in arc reprezentation; (i < n) => i-poset arc; otherwise i-dummy arc
	
	public:
	this() {
		super();
		verts = 1; // vertex that is source'n'sink in one
		//tail.length = 0;
		//head.length = 0;
	}
	
	
	uint getVerts() {
		return verts;
	}
	
	
	uint[uint] getHead() {
		uint[uint] result;
		foreach (uint key, uint value; head) {
			result[key] = value;
		}
		return result;
	}
	
	
	uint[uint] getTail() {
		uint[uint] result;
		foreach (uint key, uint value; tail) {
			result[key] = value;
		}
		return result;
	}
	
	
	uint[] covering(uint x) {
		//if (x >= tail.length) return [];
		if ((!contains(tail.keys, x)) || (!contains(head.keys, x))) return [];
		uint[] result;
		uint[][] inarc = getInarc(), outarc = getOutarc();
		uint a = tail[x], b = head[x];
		foreach (uint i; outarc[b]) {
			if (i < n) {
				if (!contains(result, i)) result ~= i;
			}
			else {
				result ~= covering(i);
			}
		}
		return result;
	}
	
	
	uint[] covered(uint x) {
		//if (x >= tail.length) return [];
		if ((!contains(tail.keys, x)) || (!contains(head.keys, x))) return [];
		uint[] result;
		uint[][] inarc = getInarc(), outarc = getOutarc();
		uint a = tail[x], b = head[x];
		foreach (uint i; inarc[a]) {
			if (i < n) {
				if (!contains(result, i)) result ~= i;
			}
			else {
				result ~= covered(i);
			}
		}
		return result;
	}
	
	
	void setTailHead(uint[uint] tail, uint[uint] head, uint n) {
		if ((tail.length == 0) || (tail.length != head.length)) throw new Exception("tail-head length mismatch");
		if (n > head.length) throw new Exception("poset arcs overloaded");
		//this.tail.length = 0;
		//this.head.length = 0;
		//delete this.tail;
		//delete this.head;
		this.tail = null;
		this.head = null;
		//this.tail = tail;
		//this.head = head;
		foreach (uint key, uint value; tail) this.tail[key] = value;
		foreach (uint key, uint value; head) this.head[key] = value;
		uint max = 0;
		/+for (uint i = 0; i < head.length; i++) {
			if (head[i] > max) max = head[i];
			if (tail[i] > max) max = tail[i];
		}+/
		foreach (uint key, uint value; head) {
			if (value > max) max = value;
		}
		foreach (uint key, uint value; tail) {
			if (value > max) max = value;
		}
		verts = max + 1;
		this.n = n;
		uint[][] inarc = getInarc(), outarc = getOutarc();
		inlist.length = 0;
		outlist.length = 0;
		inlist.length = n;
		outlist.length = n;
		//for (uint i = 0; i < n; i++) { // po wszystkich lukach rzeczywistych
		foreach (uint key, uint value; head) { /* wprowadza niejednoznacznosc zapisu, gdy luki sa usuwane */
			if (key < n) {
				inlist[key] = covered(key);
				outlist[key] = covering(key);
			}
		}
	}
	
	
	uint indeg(uint v) {
		if (v >= verts) return 0;
		uint result;
		//for (uint i = 0; i < head.length; i++) if (head[i] == v) result++;
		foreach (uint key, uint value; head) if (value == v) result++;
		return result;
	}
	
	
	uint outdeg(uint v) {
		if (v >= verts) return 0;
		uint result;
		//for (uint i = 0; i < tail.length; i++) if (tail[i] == v) result++;
		foreach (uint key, uint value; tail) if (value == v) result++;
		return result;
	}
	
	
	uint pindeg(uint v) {
		if (v >= verts) return 0;
		uint result;
		//for (uint i = 0; i < n; i++) if (head[i] == v) result++;
		foreach (uint key, uint value; head) if ((key < n) && (value == v)) result++;
		return result;
	}
	
	
	uint poutdeg(uint v) {
		if (v >= verts) return 0;
		uint result;
		//for (uint i = 0; i < n; i++) if (tail[i] == v) result++;
		foreach (uint key, uint value; tail) if ((key < n) && (value == v)) result++;
		return result;
	}
	
	
	void setInOutList(uint[][] inlist, uint[][] outlist) {
		super.setInOutList(inlist, outlist);
		//tail.length = head.length = n; // poczatkowo
		tail = null;
		head = null;
		for (uint i = 0; i < n; i++) {
			tail[i] = 2 * i;
			head[i] = tail[i] + 1;
		}
		verts = 2 * n;
		uint k = n;
		for (uint i = 0; i < n; i++) {
			foreach (uint j; outlist[i]) { // analogicznie mozna wykonac to samo po listach wejsciowych
				//tail.length = tail.length + 1;
				//head.length = head.length + 1;
				tail[k] = head[i];
				head[k++] = tail[j];
			}
		}
		compactize();
		topologize();
		debug {
			writefln("------------------");
			writefln("Arc reprezentation");
			writefln("------------------");
			writefln("verts: ", verts);
			foreach (uint i; this.head.keys) {
				if (i < n) writef("rzeczywisty: "); else writef("pozorny: ");
				writefln(this.tail[i], " ", this.head[i]);
			}
		}
		/+debug {
			/+writefln("inlist: ", this.inlist);
			writefln("outlist: ", this.outlist);
			writefln("------------------");
			writefln("Arc reprezentation");
			writefln("------------------");
			writefln("verts: ", verts);
			for (uint i = 0; i < head.length; i++) {
				if (i < n) writef("rzeczywisty: "); else writef("pozorny: ");
				writefln(tail[i], " ", head[i]);
			}
			writefln("inarc: ", this.getInarc());
			writefln("outarc: ", this.getOutarc());+/
			uint[uint] head, tail;
			//head.length = this.head.length;
			//tail.length = this.tail.length;
			/+head = this.head;
			tail = this.tail;+/
			writefln("------------------");
			writefln("Arc reprezentation");
			writefln("------------------");
			writefln("verts: ", verts);
			//for (uint i = 0; i < head.length; i++) {
			foreach (uint i; this.head.keys) {
				if (i < n) writef("rzeczywisty: "); else writef("pozorny: ");
				writefln(this.tail[i], " ", this.head[i]);
			}
			writefln("inarc: ", this.getInarc());
			writefln("outarc: ", this.getOutarc());
			foreach (uint key, uint value; this.head) head[key] = value;
			foreach (uint key, uint value; this.tail) tail[key] = value;
			this.setTailHead(tail, head, n);
			writefln("inlist: ", this.inlist);
			writefln("outlist: ", this.outlist);
		}+/
	}
	
	
	/**
	 * Operacja zwierania diagramu łukowego posetu
	 */
	void compactize(bool extendedMode = false) {
		// redukcja zrodel
		uint[] src;
		/+for (uint i = 0; i < n; i++) {
			if (indeg(tail[i]) == 0) src ~= i;
		}+/
		foreach (uint key, uint value; tail) if (indeg(value) == 0) src ~= key;
		//debug writefln("sources: ", src);
		if (src.length > 1) for (uint i = 0; i < src.length - 1; i++) {
			uint c, d;
			if (tail[src[i]] < tail[src[i + 1]]) {
				c = tail[src[i]];
				d = tail[src[i + 1]];
				tail[src[i + 1]] = c;
			}
			else {
				d = tail[src[i]];
				c = tail[src[i + 1]];
				tail[src[i]] = c;
			}
			// przenumerowanie wierzcholkow (d zostal usuniety)
			/+for (uint j = 0; j < head.length; j++) {
				head[j] = head[j] > d ? head[j] - 1 : head[j];
				tail[j] = tail[j] > d ? tail[j] - 1 : tail[j];
			}+/
			foreach (uint key, uint value; head) {
				head[key] = head[key] > d ? head[key] - 1 : head[key];
				tail[key] = tail[key] > d ? tail[key] - 1 : tail[key];
			}
			verts -= 1;
		}
		// redukcja odplywow
		uint[] snk;
		/+for (uint i = 0; i < n; i++) {
			if (outdeg(head[i]) == 0) snk ~= i;
		}+/
		foreach (uint key, uint value; head) if (outdeg(value) == 0) snk ~= key;
		//debug writefln("sinks:", snk);
		if (snk.length > 1) for (uint i = 0; i < snk.length - 1; i++) {
			uint c, d;
			if (head[snk[i]] < head[snk[i + 1]]) {
				c = head[snk[i]];
				d = head[snk[i + 1]];
				head[snk[i + 1]] = c;
			}
			else {
				d = head[snk[i]];
				c = head[snk[i + 1]];
				head[snk[i]] = c;
			}
			// przenumerowanie wierzcholkow (d zostal usuniety)
			/+for (uint j = 0; j < head.length; j++) {
				head[j] = head[j] > d ? head[j] - 1 : head[j];
				tail[j] = tail[j] > d ? tail[j] - 1 : tail[j];
			}+/
			foreach (uint key, uint value; tail) {
				head[key] = head[key] > d ? head[key] - 1 : head[key];
				tail[key] = tail[key] > d ? tail[key] - 1 : tail[key];
			}
			verts -= 1;
		}
		// redukcja lukow pozornych
		/+uint i = n;
		while (i < head.length) {
			if ((indeg(head[i]) <= 1) || (outdeg(tail[i]) <= 1)) {
				uint c, d;
				c = head[i] < tail[i] ? head[i] : tail[i];
				d = head[i] < tail[i] ? tail[i] : head[i];
				for (uint j = 0; j < head.length; j++) {
					head[j] = head[j] == d ? c : head[j];
					tail[j] = tail[j] == d ? c : tail[j];
				}
				head = head[0 .. i] ~ head[(i + 1) .. $];
				tail = tail[0 .. i] ~ tail[(i + 1) .. $];
				for (uint j = 0; j < head.length; j++) {
					head[j] = head[j] > d ? head[j] - 1 : head[j];
					tail[j] = tail[j] > d ? tail[j] - 1 : tail[j];
				}
				verts -= 1;
				continue;
			}
			i++;
		}
		if (extendedMode) {
			// bezposredni test na sciaganie luku pozornego
			// jezeli sciagniecie luku pozornego nie spowoduje pokrywania sie dwoch innych lukow w calym diagramie - ok
			
		}+/
		foreach (uint i; head.keys) {
			if ((i >= n) && ((indeg(head[i]) <= 1) || (outdeg(tail[i]) <= 1))) {
				uint c, d;
				c = head[i] < tail[i] ? head[i] : tail[i];
				d = head[i] < tail[i] ? tail[i] : head[i];
				foreach (uint j; head.keys) {
					head[j] = head[j] == d ? c : head[j];
					tail[j] = tail[j] == d ? c : tail[j];
				}
				head.remove(i);
				tail.remove(i);
				foreach (uint j; head.keys) {
					head[j] = head[j] > d ? head[j] - 1 : head[j];
					tail[j] = tail[j] > d ? tail[j] - 1 : tail[j];
				}
				verts -= 1;
			}
		}
	}
	
	
	private void topologizeAt(uint i, inout uint[] result, inout uint nr, inout bool[] numbered) {
		numbered[i] = true;
		//for (uint j = 0; j < tail.length; j++) {
		foreach (uint j; tail.keys) {
			if ((head[j] == i) && (!numbered[tail[j]])) {
				topologizeAt(tail[j], result, nr, numbered);
			}
		}
		result[i] = nr++;
	}
	
	
	void topologize() {
		uint[] result;
		result.length = verts;
		uint begin;
		//for (uint i = 0; i < head.length; i++) if (outdeg(head[i]) == 0) {
		foreach (uint i; head.keys) if (outdeg(head[i]) == 0) {
			begin = head[i];
			break;
		}
		uint nr = 0;
		bool[] numbered;
		numbered.length = verts;
		topologizeAt(begin, result, nr, numbered);
		//for (uint i = 0; i < head.length; i++) {
		//debug writefln(result);
		foreach (uint i; head.keys) {
			tail[i] = result[tail[i]];
			head[i] = result[head[i]];
		}
	}
	
	
	uint[][] getInarc() {
		uint[][] result;
		result.length = verts;
		/+for (uint i = 0; i < head.length; i++) {
			result[head[i]] ~= i;
		}+/
		foreach (uint key, uint value; head) {
			result[value] ~= key;
		}
		return result;
	}
	
	
	uint[][] getOutarc() {
		uint[][] result;
		result.length = verts;
		/+for (uint i = 0; i < tail.length; i++) {
			result[tail[i]] ~= i;
		}+/
		foreach (uint key, uint value; tail) {
			result[value] ~= key;
		}
		return result;
	}
	
	
	static synchronized ArcPoset randomPosetbyArc(uint n = 0, uint dn = 0) { // n == 0 => losowa liczba elementow (lukow rzeczywistych); dn == 0 => poset N-wolny
		ArcPoset P = new ArcPoset();
		
		
		return P;
	}
	
}


private void optLineExt(ArcPoset D, inout uint[][] Lopt) {
	/* subroutines as in Syslo' solution */
	/* S, W - queues */
	void remove(uint path, ArcPoset D, inout uint[] S, inout uint[] W, inout bool[] usedArcs = []) { // D is inout object
		if (!D) throw new Exception("Fatal: inout object of ArcPoset become null during processing");
		uint[][] inarc = D.getInarc(), outarc = D.getOutarc();
		
	}
	
	void subLineExt(uint path, inout uint[][] L, ArcPoset D, inout uint[] S, inout uint[] W) { // D is ind object - must be a clear copy
		
	}
	
	uint[] L, S, W;
	uint r = uint.max;
	bool[] usedArcs;
	//usedArcs.length = head.length;
	
}


uint[][] arcOptLineExt(ArcPoset P) {
	if (!P) return [];
	uint[][] result;
	
	return result;
}