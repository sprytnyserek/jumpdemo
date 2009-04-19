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
		foreach (i; this.outlist[node]) {
			if (this.inlist[i].length > 1) continue;
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
	
	public:
	this() {
		inlist = [];
		outlist = [];
		n = 0;
	}
	
	this(uint[][] inlist, uint[][] outlist) {
		if ((inlist.length == 0) || (inlist.length != inlist.length)) throw new Exception("inlist-outlist length mismatch");
		this.inlist[] = inlist[];
		this.outlist[] = outlist[];
		n = inlist.length;
	}
	
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
	
	void setInOutList(uint[][] inlist,uint[][] outlist) {
		if ((inlist.length == 0) || (inlist.length != inlist.length)) throw new Exception("inlist-outlist length mismatch");
		this.inlist.length = 0;
		this.outlist.length = 0;
		this.inlist = inlist[];
		this.outlist = outlist[];
		n = inlist.length;
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
	
}

unittest {
	Poset P = new Poset();
	P.setInOutList([[1],[2],[3],[4],[5],[6],[7],[8]],[[2],[4],[6],[8],[1],[3],[5],[7]]);
	assert(P.getInlist() == cast(uint[][])([[1],[2],[3],[4],[5],[6],[7],[8]]));
	assert(P.getOutlist() == cast(uint[][])([[2],[4],[6],[8],[1],[3],[5],[7]]));
}
