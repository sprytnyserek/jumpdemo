/**
 * Przedstawienie rozwiązania FPT problemu skoków w posecie według McCartin
 *
 * Author: Tomasz Polachowski, $(LINK2 mailto:sprytnyserek@gmail.com,sprytnyserek@gmail.com)
 * License: GNU General Public License 3, $(LINK http://www.gnu.org/licenses/gpl.html)
 * Version: 1.0
 */
module mccartinsol;

private {
	import std.math;
	import std.stdio;
	
	/* internal imports */
	import structure;
}

private uint[][] fastChoice(Poset P) {
	uint[][] inlist = P.getInlist();
	uint[][] outlist = P.getOutlist();
	uint[] maxAccess = P.maxAccessible();
	uint[][] result;
	foreach (uint i; maxAccess) {
		uint j = i;
		uint[] chain;
		chain.length = 1;
		chain[length - 1] = j;
		while (outlist[j].length > 0) {
			if (outlist[j].length > 1) {
				// discard a chain
				chain.length = 0;
				goto aftercheck;
			}
			j = outlist[j][0];
			chain.length = chain.length + 1;
			chain[length - 1] = j;
		}
		chain.reverse;
		result.length = result.length + 1;
		result[length - 1] = chain.dup;
		aftercheck:
		;
	}
	return result;
}

private bool contains(uint[] a, uint elmt) {
	uint i;
	while (a.length > i) {
		if (a[i++] == elmt) return true;
		}
	return false;
}

private uint[] unique(uint[] a) {
	uint[] result;
	foreach (uint i; a) {
		if (!(contains(result,i))) result ~= [i];
	}
	return result;
}

private uint[] buildCeiling(uint[][] inlist, uint[][] outlist, uint elmt) {
	uint[] result = [elmt];
	foreach (uint i; outlist[elmt]) {
		result ~= buildCeiling(inlist, outlist, i);
	}
	return unique(result);
}

private uint[][] topChain(Poset P) {
	uint[][] possTopChain = fastChoice(P), inlist = P.getInlist(), outlist = P.getOutlist(), result;
	uint[] maxAccess = P.maxAccessible();
	uint currentMaxAccess;
	foreach (uint[] chain; possTopChain) {
		uint[] currentChain = chain.dup;
		uint currentElmt = currentMaxAccess = currentChain[length - 1];
		while (inlist[currentElmt].length > 0) {
			uint newElmt = inlist[currentElmt][0];
			if (outlist[newElmt].length > 1) {
				uint[] ceiling;
				foreach (uint i; outlist[newElmt]) {
					if (i == currentElmt) continue;
					ceiling ~= buildCeiling(inlist,outlist,i);
					ceiling = unique(ceiling);
				}
				bool newMax = false;
				foreach (uint i; maxAccess) {
					if (i == currentMaxAccess) continue;
					if (contains(ceiling,i)) {
						newMax = true;
						break;
					}
				}
				if (newMax) result ~= currentChain;
				break;
			}
			else {
				currentChain.length = currentChain.length + 1;
				currentChain[length - 1] = newElmt;
				currentElmt = newElmt;
			}
		}
	}
	return result;
}

private uint getLeaderNumber(T)(T[][] set) {
	uint r = 0, answer = 0;
	for (uint i = 0; i < set.length; i++) {
		if (set[i].length > r) {
			r = set[i].length;
			answer = i;
		}
	}
	return answer;
}

uint[][] ladderDecomp(Poset Q) {
	uint[][] inlist = Q.getInlist(), outlist = Q.getOutlist(), result;
	Poset P = new Poset();
	P.setInOutList(inlist,outlist);
	bool[] gottenElmts;
	gottenElmts.length = inlist.length;
	uint n = gottenElmts.length;
	for (uint i = 0; i < n; i++) gottenElmts = false; // maybe redundant
	uint[][] topChains;
	while (contains(gottenElmts,false)) {
		topChains = topChain(P);
		// there're can be no any top chains; if so, first of all let's check whether there are any isolated elements
		uint leader = getLeaderNumber(uint)(topChains); // we choose a chain with the greatest number of poset elements; instead of this WE CAN CHOOSE A GREEDY one (which is not a part of an N-pattern in Hasse diagram)
		
	}
	return result;
}
