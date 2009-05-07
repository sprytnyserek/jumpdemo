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
} // end of imports


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
} // fastChoice


/**
 * Sprawdzenie, czy tablica $(I a) zawiera element $(I elmt)
 */
private bool contains(uint[] a, uint elmt) {
	uint i;
	
	while (a.length > i) {
		if (a[i++] == elmt) return true;
		}
	return false;
} // contains


/**
 * Sprawdzenie, czy tablica $(I a) zawiera element $(I elmt)
 */
private bool contains(bool[] a, bool elmt) {
	uint i;
	
	while (a.length > i) {
		if (a[i++] == elmt) return true;
		}
	return false;
} // contains


/**
 * Zamiana danej tablicy na tablicę bez powtórzeń
 */
private uint[] unique(uint[] a) {
	uint[] result;
	
	foreach (uint i; a) {
		if (!(contains(result,i))) result ~= [i];
	}
	return result;
} // unique


/**
 * Wybór wszystkich elementów posetu większych od danego, z pominięciem dalszych relacji
 */
private uint[] buildCeiling(uint[][] inlist, uint[][] outlist, uint elmt) {
	uint[] result = [elmt];
	
	foreach (uint i; outlist[elmt]) {
		result ~= buildCeiling(inlist, outlist, i);
	}
	return unique(result);
} // buildCeiling


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
		/+if (inlist[currentElmt].length == 0) {
			currentChain.length = currentChain.length + 1;
			currentChain[length - 1] = currentElmt;
			result ~= currentChain;
		}+/
	}
	return result;
} // topChain


/**
 * Wyznaczenie numeru elementu tablicy tablic $(I set), który zawiera największą liczbę elementów
 */
private uint getLeaderNumber(uint[][] set) {
	uint r = 0, answer = 0;
	
	for (uint i = 0; i < set.length; i++) {
		if (set[i].length > r) {
			r = set[i].length;
			answer = i;
		}
	}
	return answer;
} // getLeaderNumber


/**
 * Znajduje pierwszy element w tablicy o podanej wartości i zwraca jego indeks
 */
private uint index(uint[] a, uint elmt) {
	for (uint i = 0; i < a.length; i++) if (a[i] == elmt) return i;
	return a.length;
} // index


/**
 * Usuwa pierwszy element z tablicy o podanej wartości
 */
private void remove(inout uint[] a, uint i) {
	if (i < a.length) a = a[0 .. i] ~ a[(i + 1) .. $];
} // remove


/**
 * Rozkład drabinowy danego posetu (o ile istnieje), według algorytmu McCartin
 */
private uint[][] ladderDecomp(Poset Q, bool[] usedElmts = []) {
	uint[][] inlist = Q.getInlist(), outlist = Q.getOutlist(), result;
	Poset P = new Poset();
	bool[] gottenElmts;
	uint n = inlist.length;
	
	gottenElmts.length = inlist.length;
	P.setInOutList(inlist,outlist);
	if ((usedElmts.length == 0) || (usedElmts.length != gottenElmts.length)) for (uint i = 0; i < n; i++) gottenElmts[i] = false; // maybe redundant
	else gottenElmts[] = usedElmts[];
	uint[][] topChains;
	while (contains(gottenElmts,false)) {
		topChains = topChain(P, gottenElmts);
		// there're can be no any top chains; if so, ladder decomposition does not exist
		if (topChains.length == 0) {
			return [];
			}
/* **************************vvvvvvvvvvvvvvv*********************************************************************** */
		/* leader */uint l = getLeaderNumber(topChains); // we choose a chain with the greatest number of poset elements; instead of this WE CAN CHOOSE A STRONGLY GREEDY one (which is not a part of an N-pattern in Hasse diagram)
/* **************************^^^^^^^^^^^^^^^*********************************************************************** */
		result.length = result.length + 1;
		result[length - 1] = topChains[l].dup;
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
} // ladderDecomp


/**
 * Zwraca częściowe rozszerzenie liniowe posetu, dla podanego węzła drzewa wyszukiwań, z ustalonym ograniczeniem 
 * górnym dla liczby skoków
 */
private uint[][] expEvaluate(TreeElmt node, uint k) {
	uint[][] result;
	/* 1. find maximally accessible elements in node poset*/
	uint[] maxAccess = node.P.maxAccessible();
	{
		uint i = 0;
		while (i < maxAccess.length) {
			if (node.gottenElmts[maxAccess[i]]) maxAccess = maxAccess[0 .. i] ~ maxAccess[(i + 1) .. $];
			else i++;
		}
	}
	/* 2. Determine the nex step:
	 *(a) if more than k + 1, then discard this branch (return an empty array)
	 *(b) if exactly k + 1, then check whether node poset has a ladder decomposition; if so then return ladder chains
	 *(c) if less than k + 1, then create a child node for each od them; then run recursive calls on each of them
	 */
	if (maxAccess.length > k + 1) return [];
	if (maxAccess.length == k + 1) { // find the ladder decomposition
		result = ladderDecomp(node.P, node.gottenElmts);
		// sprawdzenie, czy wynik rozkladu drabinowego ma oczekiwana dlugosc
		if ((result.length > 0) && (result.length <= k + 1)) result = [node.chain] ~ result; else result.length = 0;
	}
	else {
		uint[][] branchResult;
		foreach (uint i; maxAccess) {
			branchResult.length = 0;
			node.children ~= new TreeElmt(new Poset(),[]);
			uint[] chain;
			uint[][] inlist = node.P.getInlist(), outlist = node.P.getOutlist();
			node.children[length - 1].gottenElmts.length = node.gottenElmts.length;
			node.children[length - 1].gottenElmts[] = node.gottenElmts[];
			chain ~= i;
			node.children[length - 1].gottenElmts[i] = true;
			// removing connections with covering elements (maybe more than one)
			foreach (uint l; outlist[i]) {
				uint z = index(inlist[l],i);
				inlist[l] = inlist[l][0 .. z] ~ inlist[l][(z + 1) .. $];
			}
			outlist[i].length = 0;
			uint j = i;
			while (inlist[j].length > 0) {
				j = inlist[j][0];
				chain ~= j;
				node.children[length - 1].gottenElmts[j] = true;
				foreach (uint l; outlist[j]) {
					uint z = index(inlist[l],j);
					inlist[l] = inlist[l][0 .. z] ~ inlist[l][(z + 1) .. $];
				}
				outlist[j].length = 0;
			}
			chain = chain.reverse;
			node.children[length - 1].chain.length = chain.length;
			node.children[length - 1].chain[] = chain[];
			node.children[length - 1].parent = node;
			node.children[length - 1].P.setInOutList(inlist, outlist);
			//if (!contains(node.children[length - 1].gottenElmts, false)) branchResult = [chain];
			if (!contains(node.children[length - 1].gottenElmts, false)) return [chain];
/* ****$%%^&^*&()&^%&*(**^&%*(*^&%$^&(*^%$(*&%%^&&^(*&*(^^&&%^%^%**** */
/* ****************************************************************** */
/* ****************************************************************** */
/* ****************************************************************** */
/* ****************************************************************** */
/* ****************************************************************** */
/* ****************************************************************** */
/* ****************** TU TRZEBA KONIECZNIE UWZGLEDNIC FAKT, ZE W ZADNEJ Z NIZSZYCH GALEZI NIE ZOSTANIE ZNALEZIONE ROZWIAZANIE ******* */
/* ****************************************************************** */
/* ****************************************************************** */
/* ****************************************************************** */
/* ****************************************************************** */
/* ****************************************************************** */
/* ****************************************************************** */
/* ****************************************************************** */
			else { // TEORETYCZNIE POPRAWIONE -- CO, JESLI k == 0 ??? NI MA ROZWIAZANIA Z DANYM OGRANICZENIEM
				if (k > 0) {
					branchResult = [chain] ~ expEvaluate(node.children[length - 1], k - 1);
					if (branchResult.length == 1) branchResult.length = 0;
				}
				else branchResult.length = 0;
			}
			// TU JEST COS NIE TAK
			if ((result.length == 0) || ((branchResult.length > 0) && (branchResult.length < k + 1) && (branchResult.length < result.length))) {
				result.length = 0;
				result.length = branchResult.length;
				result = branchResult[];
			}
		}
	}
	return result;
}


/**
 * Znajduje optymalne rozszerzenie liniowe posetu z liczbą skoków ograniczoną z góry
 * 
 * Zwraca: tablica łańcuchów tworzących optymalne rozszerzenie liniowe posetu z ograniczoną z góry liczbą skoków;
 *          albo pusta tablica, jeżeli nie istnieje rozszerzenie liniowe z taką liczbą skoków 
 *          if there's not any optimal linear extension with such a number of jumps
 */
uint[][] linearExtensionByDecomp(Poset P, uint k = uint.max) {
	if (k == uint.max) k = P.maxAccessible().length - 1;
	if (P.getCurrency() == 0) return [];
	bool[] gottenElmts;
	uint[][] result;
	TreeElmt topNode = new TreeElmt(P, []);
	result = expEvaluate(topNode, k);
	return result;
}