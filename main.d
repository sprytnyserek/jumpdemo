﻿/*
	Generated by Entice Designer
	Entice Designer written by Christopher E. Miller
	www.dprogramming.com/entice.php
*/
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
 * Główny moduł aplikacji
 *
 * Author: Tomasz Polachowski, $(LINK2 mailto:sprytnyserek@gmail.com,sprytnyserek@gmail.com)
 * License: GNU General Public License 3, $(LINK http://www.gnu.org/licenses/gpl.html)
 * Version: 1.0
 */
module main;

import dfl.all;

import std.stdio;
import std.process;
import std.thread;
import std.string;
import std.format;
import std.conv;

/* start of internal imports */
import structure;
import mccartinsol;
import syslosol;
import preview;
import painter;
import randomposet;
/* end of internal imports */

class MainWindow: dfl.form.Form
{
	// Do not modify or move this block of variables.
	//~Entice Designer variables begin here.
	dfl.label.Label statusBar;
	dfl.panel.Panel controlPanel;
	dfl.label.Label parameterLabel;
	dfl.textbox.TextBox parameterBox;
	dfl.button.Button runButton;
	dfl.label.Label label2;
	dfl.button.Button stopButton;
	//~Entice Designer variables end here.
	Preview panel1;
	Thread processing;
	Poset P;
	ArcPoset aP;
	uint[][] result;
	uint n;
	char[] filename;
	MenuItem mpop, mi;
	Label previewLabel;
	
	private int thOpen() {
		P = new Poset();
		statusBar.text("Otwieranie...");
		menu.menuItems[0].menuItems[0].enabled(false);
		menu.menuItems[1].menuItems[0].enabled(false);
		P.fromFile(filename);
		if (this.aP) delete this.aP;
		this.aP = new ArcPoset();
		this.aP.setInOutList(P.getInlist(), P.getOutlist());
		//uint[][] result;
		//result = ladderDecomp(P);
		//char[] resultString = "";
		//for (uint i = 0; i < result.length; i++) for (uint j = 0; j < result[i].length; j++) resultString ~= std.string.toString(result[i][j]) ~ " ";
		//textBox1.text(resultString);
		PosetPainter painter = new PosetPainter(P);
		//uint[][] ext = linearExtensionByDecomp(P, 7);
		uint[2][] pos = painter.getGrid(30, 50, panel1.right, panel1.bottom);
		panel1.drawDiagram(P, pos);
		menu.menuItems[1].menuItems[0].enabled(true);
		menu.menuItems[0].menuItems[0].enabled(true);
		this.P = P;
		parameterBox.enabled(true);
		statusBar.text("Gotowy");
		parameterBox.focus();
		return 0;
	}
	
	
	private int thRunMcCartin() {
		if (!(this.P)) return 1;
		statusBar.text("Przetwarzanie...");
		parameterBox.enabled(false);
		runButton.enabled(false);
		menu.menuItems[0].menuItems[0].enabled(false);
		menu.menuItems[1].menuItems[0].enabled(false);
		this.result.length = 0;
		uint k;
		k = toUint(parameterBox.lines[0]);
		this.result = linearExtensionByDecomp(P, k);
		PosetPainter painter = new PosetPainter(P);
		uint[2][] pos = painter.getGrid(30, 50, panel1.right, panel1.bottom);
		panel1.drawDiagram(P, pos, this.result);
		menu.menuItems[1].menuItems[0].enabled(true);
		menu.menuItems[0].menuItems[0].enabled(true);
		parameterBox.enabled(true);
		runButton.enabled(true);
		statusBar.text("Zakończono");
		return 0;
	}
	
	
	private int thRandomPoset() {
		statusBar.text("Losowanie...");
		menu.menuItems[0].menuItems[0].enabled(false);
		menu.menuItems[1].menuItems[0].enabled(false);
		parameterBox.text = "";
		runButton.enabled(false);
		Poset P;
		P = Poset.randomPoset(n);
		this.P = P;
		if (this.aP) delete this.aP;
		this.aP = new ArcPoset();
		this.aP.setInOutList(P.getInlist(), P.getOutlist());
		PosetPainter painter = new PosetPainter(P);
		uint[2][] pos = painter.getGrid(30, 50, panel1.right, panel1.bottom);
		panel1.drawDiagram(P, pos);
		menu.menuItems[1].menuItems[0].enabled(true);
		menu.menuItems[0].menuItems[0].enabled(true);
		parameterBox.enabled(true);
		statusBar.text("Gotowy");
		parameterBox.focus();
		return 0;
	}
	
	
	this()
	{
		initializeMain();
		
		//@  Other main initialization code here.
		parameterBox.textChanged ~= &parameterBox_textChanged;
		runButton.click ~= &runButton_click;
		stopButton.click ~= &stopButton_click;
		//spawnButton.click ~= &spawnButton_click;
		//exitButton.click ~= &exitButton_click;
		//Graphics g = pictureBox1.createGraphics();
		//Color c = Color.fromArgb(0,255,0,0);
		//g.drawLine(new Pen(c), Point(0,0), Point(100,100));
		//processing = new Thread(&(this.th));
		previewLabel = new Label();
		previewLabel.text = "Podgląd";
		previewLabel.dock = DockStyle.BOTTOM;
		previewLabel.height = 15;
		previewLabel.parent = controlPanel;
		controlPanel.redraw();
		menu = new MainMenu();
		with (mpop = new MenuItem) {
			text = "&Plik";
			index = 0;
			this.menu.menuItems.add(mpop);
		}
		with (mi = new MenuItem) {
			text = "&Otwórz";
			index = 0;
			click ~= &fileOpenMenu_click;
			mpop.menuItems.add(mi);
		}
		with (mi = new MenuItem) {
			text = "-";
			index = 1;
			mpop.menuItems.add(mi);
		}
		with (mi = new MenuItem) {
			text = "Za&kończ";
			index = 2;
			click ~= &fileExitMenu_click;
			mpop.menuItems.add(mi);
		}
		
		with (mpop = new MenuItem) {
			text = "&Dane";
			index = 1;
			this.menu.menuItems.add(mpop);
		}
		with (mi = new MenuItem) {
			text = "&Losuj";
			index = 0;
			click ~= &dataMenuRandom_click;
			mpop.menuItems.add(mi);
		}
		
	}
	
	
	~this() {
		if (processing !is null) delete processing;
	}
	
	
	private void initializeMain()
	{
		// Do not manually modify this function.
		//~Entice Designer 0.8.5.02 code begins here.
		//~DFL Form
		text = "FPT Jump Demo";
		clientSize = dfl.all.Size(800, 600);
		//~DFL dfl.panel.Panel=controlPanel
		controlPanel = new Panel();
		controlPanel.name = "controlPanel";
		controlPanel.dock = dfl.all.DockStyle.TOP;
		controlPanel.bounds = dfl.all.Rect(0, 0, 800, 128);
		controlPanel.parent = this;
		//~DFL dfl.label.Label=parameterLabel
		parameterLabel = new Label();
		parameterLabel.name = "parameterLabel";
		parameterLabel.text = "Parametr ustalony";
		parameterLabel.bounds = dfl.all.Rect(72, 24, 100, 23);
		parameterLabel.parent = controlPanel;
		//~DFL dfl.button.Button=stopButton
		stopButton = new Button();
		stopButton.name = "stopButton";
		stopButton.text = "Zatrzymaj";
		stopButton.bounds = dfl.all.Rect(552, 24, 123, 23);
		stopButton.parent = controlPanel;
		//~DFL dfl.button.Button=runButton
		runButton = new dfl.button.Button();
		runButton.name = "runButton";
		runButton.enabled = false;
		runButton.text = "Uruchom";
		runButton.bounds = dfl.all.Rect(416, 24, 123, 23);
		runButton.parent = controlPanel;
		//~DFL dfl.label.Label=label2
		label2 = new Label();
		label2.name = "label2";
		label2.text = "Algorytm McCartin";
		label2.bounds = dfl.all.Rect(72, 0, 100, 23);
		label2.parent = controlPanel;
		//~DFL dfl.textbox.TextBox=parameterBox
		parameterBox = new TextBox();
		parameterBox.name = "parameterBox";
		parameterBox.enabled = false;
		parameterBox.bounds = dfl.all.Rect(176, 24, 120, 23);
		parameterBox.parent = controlPanel;
		//~DFL dfl.label.Label=statusBar
		statusBar = new Label();
		statusBar.name = "statusBar";
		statusBar.dock = dfl.all.DockStyle.BOTTOM;
		statusBar.borderStyle = dfl.all.BorderStyle.FIXED_3D;
		statusBar.textAlign = dfl.all.ContentAlignment.BOTTOM_LEFT;
		statusBar.bounds = dfl.all.Rect(0, 577, 800, 23);
		statusBar.parent = this;
		//~Entice Designer 0.8.5.02 code ends here.
		panel1 = new Preview();
		panel1.name = "panel1";
		panel1.bounds = dfl.all.Rect(24, 104, 712, 456);
		panel1.dock = DockStyle.FILL;
		panel1.scrollSize(Size(panel1.right, panel1.bottom));
		panel1.vScroll(true);
		panel1.hScroll(true);
		panel1.parent = this;
		//textBox1.scrollBars(textBox1.scrollBars.HORIZONTAL);
	}
	
	private void fileOpenMenu_click(Object sender, EventArgs ea) {
		/+OpenFileDialog dialog = new OpenFileDialog();
		dialog.multiselect = false;
		dialog.showDialog();
		filename = dialog.fileName();
		//textBox1.text = "Processing...";
		if (processing) delete processing;
		processing = new Thread(&(this.th));
		processing.start();+/
		/+Poset P = new Poset();
		//uint[][] inlist = [[1,7,11,16,21/* */,20/* */], [2], [3], [4], [5], [6], [], [8], [9], [10], [5], [12], [13], [14], [15], [6], [17], [18], [19], [20], [], [22], [23], [24], [20]];
		//uint[][] outlist = [cast(uint[])([]), [0], [1], [2], [3], [4,10], [5,15], [0], [7], [8], [9], [0], [11], [12], [13], [14], [0], [16], [17], [18], [/* */0,/* */19,24], [0], [21], [22], [23]];
		uint[][] inlist = [[1], cast(uint[])[], [3, 1], cast(uint[])[], [3]];
		uint[][] outlist = [cast(uint[])[], [0, 2], cast(uint[])[], [2, 4], cast(uint[])[]];
		P.setInOutList(inlist, outlist);
		PosetPainter painter = new PosetPainter(P);
		uint[2][] pos = painter.getGrid(30, 50, panel1.right, panel1.bottom);
		//for (uint i = 0; i < pos.length; i++) writefln("%4d%5d :%5d", i, pos[i][0], pos[i][1]);
		panel1.drawDiagram(P, pos);+/
		OpenFileDialog dialog = new OpenFileDialog();
		dialog.multiselect = false;
		dialog.showDialog();
		filename = dialog.fileName();
		if ((!filename) || (filename.length == 0)) return;
		if (processing) delete processing;
		processing = new Thread(&(this.thOpen));
		processing.start();
	}
	
	
	private void runButton_click(Object sender, EventArgs ea) {
		if (processing) delete processing;
		processing = new Thread(&(this.thRunMcCartin));
		processing.start();
	}
	
	
	private void stopButton_click(Object sender, EventArgs ea) {
		if (processing) {
			//processing.pause();
			delete processing;
			processing = null;
		}
		menu.menuItems[0].menuItems[0].enabled(true);
		menu.menuItems[1].menuItems[0].enabled(true);
		parameterBox.text = "";
		parameterBox.enabled(true);
		runButton.enabled(true);
		statusBar.text("Przerwano");
	}
	
	
	private void fileExitMenu_click(Object sender, EventArgs ea) {
		Application.exit();
	}
	
	
	private void dataMenuRandom_click(Object sender, EventArgs ea) {
		RandomPoset dialog = new RandomPoset();
		dialog.showDialog();
		if ((dialog.dialogResult == DialogResult.OK) && (dialog.numberBox.lines.length > 0)) {
			n = toUint(dialog.numberBox.lines[0]);
			if (processing) delete processing;
			processing = new Thread(&(this.thRandomPoset));
			processing.start();
		}
		dialog.dispose();
		delete dialog;
	}
	
	
	private void parameterBox_textChanged(Object sender, EventArgs ea) {
		char[] content;
		bool good = true;
		if (parameterBox.lines.length == 0) {
			runButton.enabled(false);
			return;
		}
		for (uint i = 0; i < parameterBox.lines[0].length; i++) {
			if ((parameterBox.lines[0][i] >= '0') && (parameterBox.lines[0][i] <= '9')) {
				char[] got = parameterBox.lines[0].dup;
				if (got.length > 5) {
					good = false;
					break;
				}
				content ~= parameterBox.lines[0][i];
			}
			else good = false;
		}
		if (good) {
			//char[] got = parameterBox.lines[0].dup;
			if ((parameterBox.lines.length > 0) && (parameterBox.lines[0].length > 0)) runButton.enabled(true); else runButton.enabled(false);
			return;
		}
		//writefln(content);
		/+numberBox.clear;
		
		numberBox.lines[0] = content;
		numberBox.refresh();
		numberBox.redraw();+/
		parameterBox.text = content;
		if (content.length > 0) runButton.enabled(true); else runButton.enabled(false);
	}
	
}


int main()
{
	int result = 0;
	
	try
	{
		Application.enableVisualStyles();
		
		//@  Other application initialization code here.
		
		Poset P = new Poset();
		uint[][] inlist = [[1,7,11,16,21/* */,20/* */], [2], [3], [4], [5], [6], [], [8], [9], [10], [5], [12], [13], [14], [15], [6], [17], [18], [19], [20], [], [22], [23], [24], [20]];
		uint[][] outlist = [cast(uint[])([]), [0], [1], [2], [3], [4,10], [5,15], [0], [7], [8], [9], [0], [11], [12], [13], [14], [0], [16], [17], [18], [/* */0,/* */19,24], [0], [21], [22], [23]];
		//uint[][] inlist = [[1], cast(uint[])[], [3], cast(uint[])[], cast(uint[])[]];
		//uint[][] outlist = [cast(uint[])[], [0], cast(uint[])[], [2], cast(uint[])[]];
		//uint[][] inlist = [[1], [2], cast(uint[])[], [5], cast(uint[])[], [1]];
		//uint[][] outlist = [cast(uint[])[], [0], [1], cast(uint[])[], [3], [3]];
		/+debug {
			P.setInOutList(inlist, outlist);
			PosetPainter painter = new PosetPainter(P);
			writefln("inlist: ", P.getInlist());
			writefln("outlist: ", P.getOutlist());
			uint[][] e = linearExtensionbyDecomp(P, 5);
			writefln("extension: ", e);
			//uint[] ceiling;
			//ceiling = P.managedBuildCeiling(20, ceiling);
			//writefln(ceiling);
		}+/
		Application.run(new MainWindow());
	}
	catch(Object o)
	{
		msgBox(o.toString(), "Fatal Error", MsgBoxButtons.OK, MsgBoxIcon.ERROR);
		result = 1;
	}
	
	return result;
}
/* standard compile command: build -cleanup -nodef -D -unittest -debug main.d candy.ddoc modules.ddoc */
/*  release compile command: build -cleanup -nodef -D -O -release -L/EXET:NT -L/SU:windows main.d candy.ddoc modules.ddoc */