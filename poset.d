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
		uint[][] inlist = this.inlist[];
		return inlist;
	}
	
	uint[][] getOutlist() {
		uint[][] outlist = this.outlist[];
		return outlist;
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
//			min.append(i)
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
//			min.append(i)
			min.length = min.length + 1;
			min[length - 1] = i;
		}
		foreach (uint i; min) this.maxAccessibleFrom(i);
		return result;
	}
	
}