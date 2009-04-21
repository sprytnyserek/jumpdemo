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


/**
 * Szybki wybór fragmentów łańcuchów posetu - kandydatów do łańcucha szczytowego
 */
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
 * Sprawdzenie, czy tablica $(I a) zawiera element $(I elmt)
 */
private bool contains(bool[] a, bool elmt) {
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


/**
 * Wybór wszystkich elementów posetu większych od danego, z pominięciem dalszych relacji
 */
private uint[] buildCeiling(uint[][] inlist, uint[][] outlist, uint elmt) {
	uint[] result = [elmt];
	
	foreach (uint i; outlist[elmt]) {
		result ~= buildCeiling(inlist, outlist, i);
	}
	return unique(result);
}


/**
 * Wyznaczenie zbioru łańcuchów szczytowych dla danego posetu
 */
private uint[][] topChain(Poset P, bool[] gottenElmts = []) {
	uint[][] possTopChain = fastChoice(P), inlist = P.getInlist(), outlist = P.getOutlist(), result;
	uint[] maxAccess = P.maxAccessible();
	uint currentMaxAccess;
	
	if (gottenElmts.length == 0) {
		gottenElmts.length = inlist.length;
		for (uint i = 0; i < gottenElmts.length; i++) gottenElmts[i] = false;
	}
	foreach (uint[] chain; possTopChain) {
		uint[] currentChain = chain.dup;
		uint currentElmt = currentMaxAccess = currentChain[length - 1];
		if (gottenElmts[currentElmt]) continue; // if element is marked as already used
		if (inlist[currentElmt].length == 0) {
			result ~= currentChain;
			continue;
		}
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
				if (inlist[currentElmt].length == 0) {
					result ~= currentChain;
					}
			}
		}
		/*if (inlist[currentElmt].length == 0) {
			currentChain.length = currentChain.length + 1;
			currentChain[length - 1] = currentElmt;
			result ~= currentChain;
		}*/
	}
	return result;
}


/**
 * Wyznaczenie numeru elementu tablicy tablic $(I set), który zawiera największą liczbę elementów
 */
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


private uint index(uint[] a, uint elmt) {
	for (uint i = 0; i < a.length; i++) if (a[i] == elmt) return i;
	return a.length;
}


private void remove(inout uint[] a, uint i) {
	if (i < a.length) a = a[0 .. i] ~ a[(i + 1) .. $];
}


/**
 * Rozkład drabinowy danego posetu (o ile istnieje), według algorytmu McCartin
 */
uint[][] ladderDecomp(Poset Q) {
	uint[][] inlist = Q.getInlist(), outlist = Q.getOutlist(), result;
	Poset P = new Poset();
	bool[] gottenElmts;
	uint n = inlist.length;
	
	gottenElmts.length = inlist.length;
	P.setInOutList(inlist,outlist);
	for (uint i = 0; i < n; i++) gottenElmts[i] = false; // maybe redundant
	uint[][] topChains;
	while (contains(gottenElmts,false)) {
		topChains = topChain(P, gottenElmts);
		// there're can be no any top chains; if so, ladder decomposition does not exist
		if (topChains.length == 0) {
			return [];
			}
/* **************************vvvvvvvvvvvvvvv*********************************************************************** */
		/* leader */uint l = getLeaderNumber!(uint)(topChains); // we choose a chain with the greatest number of poset elements; instead of this WE CAN CHOOSE A STRONGLY GREEDY one (which is not a part of an N-pattern in Hasse diagram)
/* **************************^^^^^^^^^^^^^^^*********************************************************************** */
		result.length = result.length + 1;
		result[length - 1] = topChains[l].dup;
		debug writefln(topChains);
		debug writefln("chosen leader: ",topChains[l]); debug writefln();
		foreach (uint i; topChains[l]) {
			foreach (uint j; inlist[i]) remove(outlist[j], index(outlist[j], i));
			foreach (uint j; outlist[i]) remove(inlist[j], index(inlist[j], i));
		}
		foreach (uint i; topChains[l]) {
			gottenElmts[i] = true;
			inlist[i].length = 0;
			outlist[i].length = 0;
		}
		P.setInOutList(inlist,outlist);
	}
	for (uint i = 0; i < result.length; i++) result[i].reverse;
	result.reverse;
	return result;
}


/+uint[] expEvaluate(TreeElmt node) {
	
}


uint[] linearExtensionbyDecomp(Poset P, uint k = 0) {
	if (k == 0) k = P.maxAccessible().length - 1;
	bool[] gottenElmts;
	gottenElmts.length = P.getCurrency;
	for (uint i = 0; i < gottenElmts.length; i++) gottenElmts[i] = false;
	TreeElmt topNode = new TreeElmt(P, []);
	
}+/