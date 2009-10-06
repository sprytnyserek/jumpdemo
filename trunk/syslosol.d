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
 * Przedstawienie rozwiązania FPT problemu skoków w posecie według Sysły
 *
 * Author: Tomasz Polachowski, $(LINK2 mailto:sprytnyserek@gmail.com,sprytnyserek@gmail.com)
 * License: GNU General Public License 3, $(LINK http://www.gnu.org/licenses/gpl.html)
 * Version: 1.0
 */
module syslosol;

private {
	import std.math;
	import std.random;
	import std.stdio;
	import std.string;
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
	
	
	uint getN() {
		return n;
	}
	
	
	uint[] covering(uint x) {
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
		return result.sort;
	}
	
	
	uint[] covered(uint x) {
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
		return result.sort;
	}
	
	void setTailHead(uint[uint] tail, uint[uint] head, uint n) {
		/+writefln("setTailHead");+/
		/+if (tail.length == 0) throw new Exception("syslosol setTailHead: tail.length == 0");
		if (head.length == 0) throw new Exception("syslosol setTailHead: head.length == 0");+/
		if (tail.length != head.length) throw new Exception("syslosol setTailHead: tail-head length mismatch");
		if (tail.length == 0) {
			this.tail = null;
			this.head = null;
			this.tail[0] = 0;
			this.head[0] = 0;
			this.tail.remove(0);
			this.head.remove(0);
			inlist.length = 0;
			outlist.length = 0;
			inlist.length = n;
			outlist.length = n;
			return;
		}
		this.tail = null;
		this.head = null;
		foreach (uint key, uint value; tail) this.tail[key] = value;
		foreach (uint key, uint value; head) this.head[key] = value;
		uint max = 0;
		/+debug writefln("tail: ", tail);
		debug writefln("head: ", head);
		debug writefln("this.tail: ", this.tail);
		debug writefln("this.head: ", this.head);+/
		foreach (uint key, uint value; head) {
			if (value > max) max = value;
		}
		foreach (uint key, uint value; tail) {
			if (value > max) max = value;
		}
		verts = max + 1;
		/+debug writefln("verts: ", verts);+/
		this.n = n;
		uint[][] inarc = getInarc(), outarc = getOutarc();
		inlist.length = 0;
		outlist.length = 0;
		inlist.length = n;
		outlist.length = n;
		foreach (uint key, uint value; head) { /* wprowadza niejednoznacznosc zapisu, gdy luki sa usuwane */
			if (key < n) {
				inlist[key] = covered(key);
				outlist[key] = covering(key);
			}
		}
	}
	
	
	void examplePoset() {
		/+writefln("example poset");+/
		uint[uint] newTail;
		uint[uint] newHead;
		//newTail[0] = 0; newTail[1] = 2; newTail[2] = 1; newTail[3] = 0; newTail[4] = 2; newTail[5] = 1;
		//newHead[0] = 1; newHead[1] = 3; newHead[2] = 4; newHead[3] = 4; newHead[4] = 5; newHead[5] = 3;
		//newTail = [0:4, 1:6, 2:1, 6:9, 7:2, 8:5];
		//newHead = [0:1, 1:5, 2:9, 6:0, 7:9, 8:1];
		newTail = [0:0,1:0,2:1,3:3,4:4,5:5,6:7,7:6,8:7,9:4,10:3];
		newHead = [0:1,1:1,2:2,3:1,4:0,5:6,6:2,7:3,8:6,9:7,10:0];
		uint newN;
		//newN = 5;
		newN = 7;
		this.setTailHead(newTail, newHead, newN);
		debug writefln(this.getTail());
		debug writefln(this.getHead());
		debug writefln("liczba wierzcholkow: ", this.getVerts());
		debug writefln("inlist: ", this.getInlist());
		debug writefln("outlist: ", this.getOutlist());
		this.compactize();
		debug writefln("compact:");
		debug writefln(this.getTail());
		debug writefln(this.getHead());
		debug writefln("liczba wierzcholkow: ", this.getVerts());
		debug writefln("inlist: ", this.getInlist());
		debug writefln("outlist: ", this.getOutlist());
		this.topologize();
		debug writefln("topologized:");
		debug writefln(this.getTail());
		debug writefln(this.getHead());
		debug writefln("liczba wierzcholkow: ", this.getVerts());
		debug writefln("inlist: ", this.getInlist());
		debug writefln("outlist: ", this.getOutlist());
	}
	
	
	uint indeg(uint v) {
		if (v >= verts) return 0;
		uint result;
		foreach (uint key, uint value; head) if (value == v) result++;
		return result;
	}
	
	
	uint outdeg(uint v) {
		if (v >= verts) return 0;
		uint result;
		foreach (uint key, uint value; tail) if (value == v) result++;
		return result;
	}
	
	
	uint pindeg(uint v) {
		if (v >= verts) return 0;
		uint result;
		foreach (uint key, uint value; head) if ((key < n) && (value == v)) result++;
		return result;
	}
	
	
	uint poutdeg(uint v) {
		if (v >= verts) return 0;
		uint result;
		foreach (uint key, uint value; tail) if ((key < n) && (value == v)) result++;
		return result;
	}
	
	
	void setInOutList(uint[][] inlist, uint[][] outlist) {
		super.setInOutList(inlist, outlist);
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
				tail[k] = head[i];
				head[k++] = tail[j];
			}
		}
		compactize();
		topologize();
		debug {
			writefln("inlist: ", this.inlist);
			writefln("outlist: ", this.outlist);
			writefln("------------------");
			writefln("Arc reprezentation");
			writefln("------------------");
			writefln("verts: ", verts);
			foreach (uint i; this.head.keys) {
				if (i < n) writef(i, ": rzeczywisty: "); else writef("pozorny: ");
				writefln(this.tail[i], " ", this.head[i]);
			}
			uint[uint] tail, head;
			foreach (uint key, uint value; this.head) head[key] = value;
			foreach (uint key, uint value; this.tail) tail[key] = value;
			this.setTailHead(tail, head, n);
			writefln("inlist: ", this.inlist);
			writefln("outlist: ", this.outlist);
		}
	}
	
	
	/**
	 * Operacja zwierania diagramu łukowego posetu
	 */
	void compactize() {
		/+debug writefln("compactize");+/
		uint[][] inarc, outarc;
		uint[uint] newTail, newHead;
		inarc = getInarc();
		outarc = getOutarc();
		
		if ((inarc.length < 2) || (outarc.length < 2)) {
			return;
		}
		
		bool clear = false;
		uint upper, lower;
		
		while (!clear) {
			clear = true;
			inarc = getInarc();
			outarc = getOutarc();
			newTail = getTail();
			newHead = getHead();
			foreach (uint i; newTail.keys) {
				if (i >= n && (outarc[newTail[i]].length < 2 || inarc[newHead[i]].length < 2)) {
					if (newTail[i] < newHead[i]) {
						upper = newHead[i];
						lower = newTail[i];
					} else {
						upper = newTail[i];
						lower = newHead[i];
					}
					foreach (uint j; newTail.keys) {
						if (newTail[j] == upper) {
							newTail[j] = lower;
						} else if (newTail[j] > upper) {
							newTail[j] -= 1;
						}
						if (newHead[j] == upper) {
							newHead[j] = lower;
						} else if (newHead[j] > upper) {
							newHead[j] -= 1;
						}
					}
					newTail.remove(i);
					newHead.remove(i);
					this.setTailHead(newTail, newHead, n);
					clear = false;
					break;
				}
			}
		}
		
		inarc = getInarc();
		outarc = getOutarc();
		newTail = getTail();
		newHead = getHead();
		
		uint[] src;
		for (uint i = 0; i < inarc.length; i++) {
			if (inarc[i].length == 0 && outarc[i].length > 0) {
				src.length = src.length + 1;
				src[length - 1] = i;
			}
		}
		uint[] sink;
		for (uint i = 0; i < outarc.length; i++) {
			if (outarc[i].length == 0 && inarc[i].length > 0) {
				sink.length = sink.length + 1;
				sink[length - 1] = i;
			}
		}
		foreach (uint i; newTail.keys) {
			for (uint j = 1; j < src.length; j++) {
				if (newTail[i] == src[j]) {
					newTail[i] = src[0];
				}
			}
		}
		foreach (uint i; newHead.keys) {
			for (uint j = 1; j < sink.length; j++) {
				if (newHead[i] == sink[j]) {
					newHead[i] = sink[0];
				}
			}
		}
		for (uint i = 1; i < src.length; i++) {
			foreach (uint j; newTail.keys) {
				if (newTail[j] > src[i]) {
					newTail[j] -= 1;
				}
			}
			foreach (uint j; newHead.keys) {
				if (newHead[j] > src[i]) {
					newHead[j] -= 1;
				}
			}
			for (uint j = i + 1; j < src.length; j++) {
				src[j] -= 1;
			}
			for (uint j = 0; j < sink.length; j++) {
				if (sink[j] > src[i]) sink[j] -= 1;
			}
		}
		for (uint i = 1; i < sink.length; i++) {
			foreach (uint j; newTail.keys) {
				if (newTail[j] > sink[i]) {
					newTail[j] -= 1;
				}
			}
			foreach (uint j; newHead.keys) {
				if (newHead[j] > sink[i]) {
					newHead[j] -= 1;
				}
			}
			for (uint j = i + 1; j < sink.length; j++) {
				sink[j] -= 1;
			}
		}
		this.setTailHead(newTail, newHead, this.n);
		
		inarc = getInarc();
		outarc = getOutarc();
		
		bool changed = true;
		
		while (changed) {
			changed = false;
			foreach (uint i; newTail.keys) {
				if (i >= n && (inarc[newTail[i]].length == 0 || outarc[newHead[i]].length == 0)) {
					newTail.remove(i);
					newHead.remove(i);
					changed = true;
					break;
				}
			}
		}
		this.setTailHead(newTail, newHead, this.n);
		
		inarc = getInarc();
		outarc = getOutarc();
		newTail = getTail();
		newHead = getHead();
		
		src.length = 0;
		for (uint i = 0; i < inarc.length; i++) {
			if (inarc[i].length == 0 && outarc[i].length > 0) {
				src.length = src.length + 1;
				src[length - 1] = i;
			}
		}
		sink.length = 0;
		for (uint i = 0; i < outarc.length; i++) {
			if (outarc[i].length == 0 && inarc[i].length > 0) {
				sink.length = sink.length + 1;
				sink[length - 1] = i;
			}
		}
		foreach (uint i; newTail.keys) {
			for (uint j = 1; j < src.length; j++) {
				if (newTail[i] == src[j]) {
					newTail[i] = src[0];
				}
			}
		}
		foreach (uint i; newHead.keys) {
			for (uint j = 1; j < sink.length; j++) {
				if (newHead[i] == sink[j]) {
					newHead[i] = sink[0];
				}
			}
		}
		for (uint i = 1; i < src.length; i++) {
			foreach (uint j; newTail.keys) {
				if (newTail[j] > src[i]) {
					newTail[j] -= 1;
				}
			}
			foreach (uint j; newHead.keys) {
				if (newHead[j] > src[i]) {
					newHead[j] -= 1;
				}
			}
			for (uint j = i + 1; j < src.length; j++) {
				src[j] -= 1;
			}
			for (uint j = 0; j < sink.length; j++) {
				if (sink[j] > src[i]) sink[j] -= 1;
			}
		}
		for (uint i = 1; i < sink.length; i++) {
			foreach (uint j; newTail.keys) {
				if (newTail[j] > sink[i]) {
					newTail[j] -= 1;
				}
			}
			foreach (uint j; newHead.keys) {
				if (newHead[j] > sink[i]) {
					newHead[j] -= 1;
				}
			}
			for (uint j = i + 1; j < sink.length; j++) {
				sink[j] -= 1;
			}
		}
		this.setTailHead(newTail, newHead, this.n);
		
		/+inarc = getInarc();
		outarc = getOutarc();
		
		uint indegi, indegpi, outdegi, outdegpi;
		uint first, second;
		
		for (uint i = 0; i < verts; i++) {
			indegi = indeg(i);
			indegpi = pindeg(i);
			outdegi = outdeg(i);
			outdegpi = poutdeg(i);
			if (indegi == 1 && indegi == indegpi && outdegi == 1 && outdegi == outdegpi) {
				first = inarc[i][0];
				second = outarc[i][0];
				newHead[first] = newHead[second];
				newTail.remove(second);
				newHead.remove(second);
			}
		}
		
		this.setTailHead(newTail, newHead, this.n);
		
		inarc = getInarc();
		outarc = getOutarc();
		
		changed = true;
		
		while (changed) {
			changed = false;
			foreach (uint arc; tail.keys) {
				if (isPath(tail[arc], head[arc], arc)) {
					debug writefln("USUWAM");
					newTail.remove(arc);
					newHead.remove(arc);
					changed = true;
					break;
				}
			}
			if (changed) {
				this.setTailHead(newTail, newHead, this.n);
			}
		}+/
		
		return;
	}
	
	
	private void topologizeAtOld(uint i, inout uint[] result, inout uint nr, inout bool[] numbered) {
		numbered[i] = true;
		foreach (uint j; tail.keys) {
			if ((head[j] == i) && (!numbered[tail[j]])) {
				topologizeAtOld(tail[j], result, nr, numbered);
			}
		}
		result[i] = nr++;
	}
	
	
	void topologize() {
		uint[] result;
		result.length = verts;
		uint begin;
		foreach (uint i; head.keys) if (outdeg(head[i]) == 0) {
			begin = head[i];
			break;
		}
		uint nr = 0;
		bool[] numbered;
		numbered.length = verts;
		topologizeAtOld(begin, result, nr, numbered);
		foreach (uint i; head.keys) {
			tail[i] = result[tail[i]];
			head[i] = result[head[i]];
		}
		uint v;
		foreach (uint i; head.keys) {
			if (head[i] > v) {
				v = head[i];
			}
			if (tail[i] > v) {
				v = tail[i];
			}
		}
		verts = v + 1;
		/+debug writefln("topologic map: ", result);+/
	}
	
	
	/+private void topologizeAt(uint v, inout uint[][] inarc, inout uint[][] outarc, inout uint[] result, inout uint counter, inout bool[] numberized) {
		if (numberized[v]) return;
		numberized[v] = true;
		foreach (uint i; inarc[v]) {
			if (inarc[tail[i]].length != 0 && result[tail[i]] == 0) {
				topologizeAt(tail[i], inarc, outarc, result, counter, numberized);
			}
		}
		result[v] = counter++;
		foreach (uint i; outarc[v]) {
			topologizeAt(head[i], inarc, outarc, result, counter, numberized);
		}
	}
	
	void topologize() {
		uint[][] inarc, outarc;
		inarc = this.getInarc();
		outarc = this.getOutarc();
		uint[] result;
		result.length = this.verts;
		
		uint start;
		bool found = false;
		for (uint i = 0; i < this.verts; i++) {
			if (inarc[i].length == 0) {
				start = i;
				found = true;
				break;
			}
		}
		if (!found) {
			return;
		}
		result[start] = 0;
		uint counter = 1;
		bool[] numberized;
		numberized.length = this.verts;
		foreach (uint i; outarc[start]) {
			topologizeAt(head[i], inarc, outarc, result, counter, numberized);
		}
		foreach (uint i; tail.keys) {
			tail[i] = result[tail[i]];
			head[i] = result[head[i]];
		}
		uint v;
		foreach (uint i; head.keys) {
			if (head[i] > v) {
				v = head[i];
			}
			if (tail[i] > v) {
				v = tail[i];
			}
		}
		verts = v + 1;
	}+/
	
	
	/+void topologize() {
		// najpierw sprawdz, czy jest dokladnie jedno zrodlo i dokladnie jeden odplyw
		uint[][] inarc, outarc;
		bool srcFound, snkFound;
		uint src, snk;
		uint[] map;
		bool[] numbered;
		bool preNumbered;
		bool allNull = true;
		uint counter = 1;
		
		inarc = getInarc();
		outarc = getOutarc();
		for (uint i = 0; i < inarc.length; i++) {
			if (inarc[i].length == 0 && outarc[i].length == 0) {
				continue;
			}
			allNull = false;
			if (inarc[i].length == 0 && !srcFound) {
				srcFound = true;
				src = i;
			} else if (inarc[i].length == 0 && srcFound) {
				debug writefln("tail: ", tail);
				debug writefln("head: ", head);
				debug writefln("inarc: ", inarc);
				debug writefln("outarc: ", outarc);
				throw new Exception("source duplicated");
			}
		}
		if (allNull) {
			verts = 0;
			return;
		}
		allNull = true;
		if (!srcFound) {
			debug writefln("tail: ", tail);
			debug writefln("head: ", head);
			debug writefln("inarc: ", inarc);
			debug writefln("outarc: ", outarc);
			throw new Exception("source not found");
		}
		for (uint i = 0; i < outarc.length; i++) {
			if (inarc[i].length == 0 && outarc[i].length == 0) {
				continue;
			}
			allNull = false;
			if (outarc[i].length == 0 && !snkFound) {
				snkFound = true;
				snk = i;
			} else if (outarc[i].length == 0 && snkFound) {
				debug writefln("tail: ", tail);
				debug writefln("head: ", head);
				debug writefln("inarc: ", inarc);
				debug writefln("outarc: ", outarc);
				throw new Exception("sink duplicated");
			}
		}
		if (allNull) {
			verts = 0;
			return;
		}
		if (!snkFound) {
			debug writefln("tail: ", tail);
			debug writefln("head: ", head);
			debug writefln("inarc: ", inarc);
			debug writefln("outarc: ", outarc);
			throw new Exception("sink not found");
		}
		
		// start topologizing
		map.length = verts;
		map[src] = 0;
		uint last = src;
		numbered.length = verts;
		numbered[src] = true;
		
		while (last != snk) {
			for (uint i = 0; i < verts; i++) {
				if (numbered[i] || ((inarc[i].length == 0) && (outarc[i].length == 0))) {
					continue;
				}
				preNumbered = true;
				foreach (uint arc; inarc[i]) {
					if (!numbered[tail[arc]]) {
						preNumbered = false;
						break;
					}
				}
				if (preNumbered) {
					map[i] = counter++;
					numbered[i] = true;
					last = i;
					if (i == snk) {
						break;
					}
				}
			}
		}
		foreach (uint i; tail.keys) {
			tail[i] = map[tail[i]];
			head[i] = map[head[i]];
		}
		verts = counter;
	}+/
	
	
	uint[][] getInarc() {
		uint[][] result;
		result.length = verts;
		foreach (uint key, uint value; head) {
			result[value] ~= key;
		}
		return result;
	}
	
	
	uint[][] getOutarc() {
		uint[][] result;
		result.length = verts;
		foreach (uint key, uint value; tail) {
			result[value] ~= key;
		}
		return result;
	}
	
	
	bool isPath(uint a, uint b, inout uint[][] inarc, inout uint[][] outarc) {
		if ((a >= verts) || (b >= verts)) throw new Exception("No such vertex " ~ std.string.toString(a) ~ " or " ~ std.string.toString(b));
		if (a == b) return true;
		
		if ((inarc.length == 0) && (outarc.length == 0)) {
			inarc = getInarc();
			outarc = getOutarc();
		}
		foreach (uint i; outarc[a]) {
			if (isPath(head[i], b, inarc, outarc)) return true;
		}
		return false;
	}
	
	
	bool isPath(uint a, uint b, uint exclude = 0) {
		uint[][] inarc, outarc;
		
		inarc = getInarc();
		outarc = getOutarc();
		//debug writefln("outarc.length: ", outarc.length);
		
		foreach (uint arc; tail.keys) {
			if (arc != exclude && tail[arc] == a && head[arc] == b) {
				return true;
			}
		}
		
		uint[] ceiling;
		ceiling.length = 1;
		ceiling[0] = a;
		uint count = 1, index, counter;
		
		while (count > 0) {
			counter = count;
			count = 0;
			index = ceiling.length;
			for (uint i = index - 1; i >= index - counter; i--) {
				/+debug writefln(outarc.length);
				debug writefln(ceiling.length);
				debug writefln("i ", i);
				debug writefln(ceiling[i]);+/
				foreach (uint arc; outarc[ceiling[i]]) {
					if (arc == exclude) {
						if (i == 0) break;
						continue;
					}
					if (head[arc] == b) {
						return true;
					}
					if (!contains(ceiling, head[arc])) {
						ceiling.length = ceiling.length + 1;
						ceiling[length - 1] = head[arc];
						count += 1;
					}
				}
				if (i == 0) break;
			}
		}
		
		return false;
	}
	
	
	static synchronized ArcPoset randomPosetByArc(uint n = 0, uint s = 0, float p = 0.0, float q = 0.0) { // n == 0 => losowa liczba elementow (lukow rzeczywistych); dn == 0 => poset N-wolny
		ArcPoset P = new ArcPoset();
		uint[uint] randomTail, randomHead;
		uint[][] inarc, outarc;
		uint VCOUNT = 2, DCOUNT = 1, a, b;
		float X, Y;
		
		while (n == 0) n = rand() % int.max;
		if (p < float.min) p = float.min;
		if (q < float.min) q = float.min;
		
		randomTail[0] = 0;
		randomHead[0] = 1;
		P.setTailHead(randomTail, randomHead, 1);
		debug writefln("0, (0,1)");
		
		for (uint i = 1; i < n; i++) {
			X = cast(float)(rand() % 1000) / 1000.0;
			Y = cast(float)(rand() % 1000) / 1000.0;
			if ((X > p) && (Y > q)) {
				if (VCOUNT == 2) {
					a = 0;
					b = 1;
				} else {
					a = rand() % VCOUNT;
					do{
						b = rand() % VCOUNT;
					} while (a == b);
				}
				inarc = P.getInarc();
				outarc = P.getOutarc();
				// zmiana isPath
				if (P.isPath(b, a, inarc, outarc)) {
					randomTail[i] = b;
					randomHead[i] = a;
				} else {
					randomTail[i] = a;
					randomHead[i] = b;
				}
			} else if ((X > p) && (Y <= q)) {
				a = rand() % VCOUNT;
				randomTail[i] = a;
				b = VCOUNT;
				randomHead[i] = VCOUNT;
				VCOUNT += 1;
				debug writefln("new head vertex ", b);
			} else if ((X <= p) && (Y > q)) {
				a = VCOUNT;
				b = rand() % VCOUNT;
				randomTail[i] = VCOUNT;
				randomHead[i] = b;
				VCOUNT += 1;
				debug writefln("new tail vertex ", a);
			} else {
				a = VCOUNT;
				b = VCOUNT + 1;
				randomTail[i] = VCOUNT;
				randomHead[i] = VCOUNT + 1;
				VCOUNT += 2;
				debug writefln("new tail-head vertices ", a, " ", b);
			}
			P.setTailHead(randomTail, randomHead, i + 1);
			debug writefln(i, ", (", a, ", ", b, ")");
		}
		
		uint j = n;
		debug writefln("Dummies");
		while (s--) { // (s == 0) => s becomes uint.max
			a = rand() % VCOUNT;
			do{
				b = rand() % VCOUNT;
			} while (a == b);
			inarc = P.getInarc();
			outarc = P.getOutarc();
			// zmiana isPath
			if ((!(P.isPath(a, b, inarc, outarc))) && (!(P.isPath(b, a, inarc, outarc)))) {
				randomTail[j] = a;
				randomHead[j] = b;
				j += 1;
				P.setTailHead(randomTail, randomHead, n);
				debug writefln(j-1, ", (", a, ", ", b, ")");
			}
		}
		debug writefln(P.getTail());
		debug writefln(P.getHead());
		debug writefln("liczba wierzcholkow: ", P.getVerts());
		debug writefln("inlist: ", P.getInlist());
		debug writefln("outlist: ", P.getOutlist());
		if (!(P.isArcAcyclic())) {
			/+writefln("random arc diagram is not acyclic!");
			char[] buf;
			while ((buf = readln()) != null) {+/
			return ArcPoset.randomPosetByArc(n, s, p, q);
			}
		P.compactize();
		debug writefln("compact:");
		debug writefln(P.getTail());
		debug writefln(P.getHead());
		debug writefln("liczba wierzcholkow: ", P.getVerts());
		debug writefln("inlist: ", P.getInlist());
		debug writefln("outlist: ", P.getOutlist());
		if (!(P.isArcAcyclic())) {
			/+writefln("random arc diagram is not acyclic!");
			char[] buf;
			while ((buf = readln()) != null) {+/
			return ArcPoset.randomPosetByArc(n, s, p, q);
			}
		P.topologize();
		debug writefln("topologized:");
		debug writefln(P.getTail());
		debug writefln(P.getHead());
		debug writefln("liczba wierzcholkow: ", P.getVerts());
		debug writefln("inlist: ", P.getInlist());
		debug writefln("outlist: ", P.getOutlist());
		if (!(P.isArcAcyclic())) {
			/+writefln("random arc diagram is not acyclic!");
			char[] buf;
			while ((buf = readln()) != null) {+/
			return ArcPoset.randomPosetByArc(n, s, p, q);
			}
		uint[][] inlist, outlist;
		inlist = P.getInlist();
		outlist = P.getOutlist();
		P.setInOutList(inlist, outlist);
		return P;
	}
	
	private uint[] managedBuildCeiling(uint elmt, inout uint[] result, inout uint[][] outarc) {
		if (elmt >= verts) return [];
		if (contains(result, elmt)) return [];
		
		//result ~= [elmt];
		result.length = result.length + 1;
		result[length - 1] = elmt;
		
		foreach (uint i; outarc[elmt]) {
			managedBuildCeiling(this.head[i], result, outarc);
		}
		
		return result;
	}
	
	private bool isArcAcyclic() {
		uint[] ceiling;
		uint[][] inarc, outarc;
		inarc = this.getInarc();
		outarc = this.getOutarc();
		for (uint i = 0; i < this.verts; i++) {
			//while (contains(inlist[i], i)) remove(inlist[i], index(inlist[i], i));
			//while (contains(outlist[i], i)) remove(outlist[i], index(outlist[i], i));
			
			// check for loops
			foreach (uint j; inarc[i]) {
				if (tail[j] == i) {
					// DEBUG INFO ?
					return false;
				}
			}
			foreach (uint j; outarc[i]) {
				if (head[j] == i) {
					// DEBUG INFO ?
					return false;
				}
			}
		}
		for (uint i = 0; i < this.verts; i++) {
			ceiling.length = 0;
			ceiling = managedBuildCeiling(i, ceiling, outarc);
			foreach (uint j; ceiling) {
				/+if (contains(outlist[j], i)) {
					remove(outlist[j], index(outlist[j], i));
					remove(inlist[i], index(inlist[i], j));
				}+/
				
				// check for non-trivial cycles
				foreach (uint k; outarc[j]) {
					if (head[k] == j) {
						// DEBUG INFO ?
						return false;
					}
				}
			}
		}
		return true;
	}
	
}


private void optLineExt(ArcPoset D, inout uint[][] Lopt) {
	uint[] S, W;
	uint[][] Ls, L;
	uint r = uint.max;
	
	/* UWAGA: funkcja istotnie zaklada, ze diagram jest zwarty (i nie sprawdza, czy ten warunek jest spelniony!!!) */
	void updateGreedyPaths(ArcPoset D, inout uint[] S, inout uint[] W) {
		ubyte[] vStat;
		vStat.length = D.verts; /* 0 - niesprawdzona, 1 - silny, 2 - slabo silny, 3 - silnie zakonczony,
			4 - slabo zakonczony */
		uint[][] inarc, outarc;
		
		inarc = D.getInarc();
		outarc = D.getOutarc();
		S.length = 0;
		W.length = 0;
		for (uint i = 0; i < vStat.length; i++) { // po wszystkich wierzchołkach diagramu łukowego
			if (i == 0) { // obsluga zrodla
				vStat[i] = 1; // zakładamy, że diagram jest zwarty zatem w pierwszym wierzchołku nie ma łuku pozornego
				continue; // potrzebne, bo poset moze byc pusty
			}
			if (i + 1 == vStat.length) { // obsluga odplywu
				foreach (uint a; inarc[i]) { // dla kazdego luku wchodzacego do zrodla
					if (a < D.n && vStat[D.tail[a]] < 3) {
						S.length = S.length + 1;
						S[length - 1] = a;
					}
				}
				break;
			}
			if (D.pindeg(i) == 0) { // do wierzcholka wchodza tylko luki pozorne
				vStat[i] = 4;
				continue;
			}
			if (inarc[i].length > 1) {
				// jezeli jest wiele lukow wchodzacych do biezacego wierzcholka
				// tu wierzcholek moze byc oznaczony tylko jako silnie/slabo zakonczony
				bool ALLDUMMYFREE;
				if ((D.indeg(i) > D.pindeg(i)) || (D.outdeg(i) > D.poutdeg(i))) {
					ALLDUMMYFREE = false;
				} else {
					ALLDUMMYFREE = true;
					foreach (uint a; inarc[i]) {
						if (a < D.n && (vStat[D.tail[a]] == 2 || vStat[D.tail[a]] == 4)) {
							ALLDUMMYFREE = false;
							break;
						}
					}
				}
				uint[] X;
				foreach (uint a; inarc[i]) {
					if (a < D.n && (vStat[D.tail[a]] == 1 || vStat[D.tail[a]] == 3)) {
						X.length = X.length + 1;
						X[length - 1] = D.tail[a];
					}
				}
				foreach (uint a; inarc[i]) { // dla kazdego luku wchodzacego do wierzcholka
					if (a >= D.n) { // pomin wszystkie luki pozorne
						continue;
					}
					switch (vStat[D.tail[a]]) {
						case 4:		vStat[i] = 4;
									break;
						case 3:		if (vStat[i] != 4) vStat[i] = 3;
									break;
						case 2:		if (X.length == 0) {
										W.length = W.length + 1;
										W[length - 1] = a;
									} else {
										if ((D.indeg(i) > D.pindeg(i)) || (D.outdeg(i) > D.poutdeg(i))) {
											W.length = W.length + 1;
											W[length - 1] = a;
										} else {
											S.length = S.length + 1;
											S[length - 1] = a;
										}
									}
									vStat[i] = 4;
									break;
						case 1:		if ((D.indeg(i) == D.pindeg(i)) && (D.outdeg(i) == D.poutdeg(i))) {
										if ((contains(X, D.tail[a])) && (X.length - 1 > 0)) {
											S.length = S.length + 1;
											S[length - 1] = a;
										}
										if (ALLDUMMYFREE) {
											vStat[i] = 3;
										} else {
											vStat[i] = 4;
										}
									} else if ((D.indeg(i) == D.pindeg(i)) && (D.outdeg(i) > D.poutdeg(i))) {
										W.length = W.length + 1;
										W[length - 1] = a;
										vStat[i] = 4;
									} else {
										vStat[i] = 4;
									}
									break;
						default:	throw new Exception("updateGreedyPaths: Topologiczny poprzednik nieokreslony" ~ newline);
									break;
					}
				}
				X.length = 0;
			} else {
				/* jezeli jest dokladnie jeden luk wchodzacy do biezacego wierzcholka (diagram jest zwarty, zatem
					zawsze jest to luk posetu */
				assert(i > D.tail[inarc[i][0]]);
				//debug writefln(inarc[i][0]);
				//debug writefln("inarc[i][0] ok");
				//debug writefln(D.tail[inarc[i][0]]);
				//debug writefln("D.tail[inarc[i][0]] ok");
				//debug writefln(vStat[D.tail[inarc[i][0]]]);
				//debug writefln("vStat[D.tail[inarc[i][0]]] ok");
				vStat[i] = vStat[D.tail[inarc[i][0]]]; // skopiowanie stanu jedynego poprzednika
				if (D.outdeg(i) > D.poutdeg(i)) { // z wierzcholka wychodza luki pozorne
					if (vStat[i] == 1 || vStat[i] == 3) vStat[i] += 1;
					if (D.poutdeg(i) == 0) { // z wierzcholka wychodza tylko luki pozorne
						if (vStat[i] == 2) { // wierzcholek konczy sciezke slabo silnie zachlanna
							vStat[i] = 4;
							W.length = W.length + 1;
							W[length - 1] = inarc[i][0];
						}
					}
				}
			}
		}
	}
	
	bool isGreedy(uint path, ArcPoset D) {
		if (!D) throw new Exception("Fatal: inout object of ArcPoset become null during processing");
		uint[][] inarc = D.getInarc();
		/* input data validation */
		uint a = path;
		if (!(contains(D.tail.keys, a))) throw new Exception("No such arc");
		/+if (D.indeg(D.head[a]) < 2 && D.outdeg(D.head[a]) > 0) {
			debug writefln("isGreedy: bla bla bla");
			return false;
		}+/
		uint ta = D.tail[a];
		while (D.indeg(ta) > 0) {
			if (!((D.indeg(ta) == 1) && (D.pindeg(ta) == 1) && (D.outdeg(ta) >= 1) && (D.poutdeg(ta) >= 1))) return false;
			a = inarc[ta][0];
			ta = D.tail[a];
		}
		/* end of input data validation */
		return true;
	}
	uint[] extractGreedyPath(uint path, ArcPoset D) {
		/+try {
			if (!(isGreedy(path,D))) throw new Exception("Not a greedy path");
		} catch (Exception ex) {
			debug writefln("extractGreedyPath: isGreedy failure");
			throw ex;
		}+/
		
		uint[] result;
		uint[][] inarc = D.getInarc(), outarc = D.getOutarc();
		uint a = path, ta = D.tail[a];
		
		result.length = 1;
		result[0] = a;
		while (D.indeg(ta) > 0) {
			a = inarc[ta][0];
			ta = D.tail[a];
			result.length = result.length + 1;
			result[length - 1] = a;
		}
		result = result.reverse;
		return result;
	}
	/* subroutines as in Syslo' solution */
	/* S, W - queues */
	void removeOld(uint path, ArcPoset D, inout uint[] S, inout uint[] W) { // D is inout object
		if (!D) throw new Exception("Fatal: inout object of ArcPoset become null during processing");
		uint[][] inarc = D.getInarc(), outarc = D.getOutarc();
		/* input data validation */
		uint a = path;
		if (!(contains(D.tail.keys, a))) throw new Exception("No such arc");
		uint ta = D.tail[a];
		while (D.indeg(ta) > 0) {
			if (!((D.indeg(ta) == 1) && (D.pindeg(ta) == 1) && (D.outdeg(ta) >= 1) && (D.poutdeg(ta) >= 1))) throw new Exception("Not a greedy path");
			a = inarc[ta][0];
			ta = D.tail[a];
		}
		/* end of input data validation */
		a = path;
		ta = D.tail[a];
		uint ha = D.head[a];
		uint poutdeg, outdeg;
		while (D.indeg(ta) > 0) {
			poutdeg = D.poutdeg(ta);
			outdeg = D.outdeg(ta);
			/* usuwanie luku w diagramie */
			D.head.remove(a);
			D.tail.remove(a);
			/* usuwanie luku w zbiorze pomocniczym */
			structure.remove(inarc[ha], a);
			structure.remove(outarc[ta], a);
			a = inarc[ta][0];
			/* jezeli po usunieciu luku pozostaje wolny wierzcholek, trzeba go usunac z tablic pomocnicznych i diagramu */
			if ((inarc[ha].length == 0) && (outarc[ha].length == 0)) {
				inarc = inarc[0 .. ha] ~ inarc [(ha + 1) .. $];
				outarc = outarc[0 .. ha] ~ outarc[(ha + 1) .. $];
				foreach (uint key; D.tail.keys) {
					if (D.tail[key] > ha) D.tail[key] -= 1;
					if (D.head[key] > ha) D.head[key] -= 1;
				}
				D.verts -= 1;
			}
			ha = ta;
			if ((inarc[ta].length == 0) && (outarc[ta].length == 0)) {
				inarc = inarc[0 .. ta] ~ inarc [(ta + 1) .. $];
				outarc = outarc[0 .. ta] ~ outarc[(ta + 1) .. $];
				foreach (uint key; D.tail.keys) {
					if (D.tail[key] > ta) D.tail[key] -= 1;
					if (D.head[key] > ta) D.head[key] -= 1;
				}
				D.verts -= 1;
			}
			ta = D.tail[a];
		}
		/+debug writefln(path, " removed");+/
		D.compactize();
		D.topologize();
		updateGreedyPaths(D, S, W);
	}
	
	void remove(uint path, ArcPoset D, inout uint[] S, inout uint[] W) { // D is inout object
		/+debug writefln("D.tail: ", D.tail);
		debug writefln("D.head: ", D.head);+/
		if (!D) throw new Exception("Fatal: inout object of ArcPoset become null during processing");
		
		uint[][] inarc = D.getInarc(), outarc = D.getOutarc();
		uint[uint] newTail, newHead;
		uint[] greedyPath;
		
		greedyPath = extractGreedyPath(path, D);
		newTail = D.getTail();
		newHead = D.getHead();
		/+debug writefln("greedy path to remove: ", greedyPath);+/
		foreach (uint a; greedyPath) {
			newTail.remove(a);
			newHead.remove(a);
			if (a != path) {
				if (D.poutdeg(D.head[a]) < 2 && D.outdeg(D.head[a]) > 1) {
					foreach (uint i; outarc[D.head[a]]) {
						if (i >= D.n) {
							newTail.remove(i);
							newHead.remove(i);
						}
					}
				}
			} else {
				if (D.poutdeg(D.head[a]) == 0) {
					foreach (uint i; outarc[D.head[a]]) {
						newTail.remove(i);
						newHead.remove(i);
					}
				}
			}
		}
		D.setTailHead(newTail, newHead, D.n);
		D.compactize();
		D.topologize();
		updateGreedyPaths(D, S, W);
		/+debug writefln("D: ", D.tail, " ", D.head);+/
	}
	
	void subLineExt(uint path, inout uint[][] L, ArcPoset D, inout uint[] S, inout uint[] W) { // D is ind object - must be a clear copy
		/+try {
			if (!(isGreedy(path,D))) throw new Exception("Not a greedy path");
		} catch (Exception ex) {
			debug writefln("subLineExt: isGreedy failure");
			throw ex;
		}+/
		//L ~= extractGreedyPath(path, D);
		L.length = L.length + 1;
		L[length - 1] = extractGreedyPath(path, D);
		remove(path, D, S, W);
		while (S.length > 0) {
			//L = extractGreedyPath(S[0], D) ~ L;
			L.length = L.length + 1;
			L[length - 1] = extractGreedyPath(S[0], D);
			remove(S[0], D, S, W);
			//S = S[1 .. $]; - aktualizacja danych odbywa / (powinna odbywac) / sie w nested-funkcji remove
		}
		if (D.tail.length > 0) foreach (uint semipath; W) {
			// at first make a copy of D
			ArcPoset Di = new ArcPoset();
			Di.setTailHead(D.tail, D.head, D.n);
			uint[][] Li;
			Li.length = L.length;
			for (uint i = 0; i < L.length; i++) Li[i] = L[i].dup;
			subLineExt(semipath, Li, Di, S, W);
		}
		else if (L.length - 1 < r) {
			r = L.length - 1;
			Ls.length = 0;
			Ls.length = L.length;
			for (uint i = 0; i < L.length; i++) Ls[i] = L[i].dup;
		} // else if (if D contains arcs)
		// D.compactize(); - powinno wykonywac sie w funkcji remove
	} // subLineExt
	
	uint[][] inarc = D.getInarc(), outarc = D.getOutarc();
	uint n = D.n;
	
	updateGreedyPaths(D, S, W);
	/+writefln("1 S: ", S);
	writefln("1 W: ", W);+/
	
	uint[] greedyPath;
	
	while (S.length > 0) {
		/+writefln("S: ", S);
		writefln("Extracting greedy path ", S[0]);+/
		//L = extractGreedyPath(S[0], D) ~ L;
		greedyPath = extractGreedyPath(S[0], D);
		L.length = L.length + 1;
		L[length - 1] = greedyPath.dup;
		greedyPath.length = 0;
		
		/+writefln("Extracted. ", L.length, " Removing ", S[0]);
		writefln("L: ", L);+/
		remove(S[0], D, S, W);
		/+writefln("S: ", S);
		writefln("W: ", W);+/
		/+char[] buf;
		buf.length = 0;
		readln(stdin, buf);+/
		//S = S[1 .. $]; - aktualizacja danych odbywa / (powinna odbywac) / sie w nested-funkcji remove
	}
	
	if (D.tail.length == 0) {
		r = L.length - 1;
		Ls.length = 0;
		Ls.length = L.length;
		for (uint i = 0; i < L.length; i++) Ls[i] = L[i].dup;
	}
	else foreach (uint semipath; W) {
		// at first make a copy of D
		ArcPoset Di = new ArcPoset();
		Di.setTailHead(D.tail, D.head, D.n);
		uint[][] Li;
		Li.length = L.length;
		for (uint i = 0; i < L.length; i++) Li[i] = L[i].dup;
		subLineExt(semipath, Li, Di, S, W);
	}
	Lopt = Ls;
}


uint[][] arcOptLineExt(ArcPoset P) {
	if (!P) return [];
	uint[][] result;
	ArcPoset D = new ArcPoset();
	D.setTailHead(P.getTail(), P.getHead(), P.getN());
	optLineExt(D, result);
	debug writefln("wynik wg Sysly: ", result);
	debug writefln(result.length - 1, " skokow");
	return result;
}
