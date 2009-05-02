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

/* start of internal imports */
import structure;
import mccartinsol;
import preview;
import painter;
/* end of internal imports */

class MainWindow: dfl.form.Form
{
	// Do not modify or move this block of variables.
	//~Entice Designer variables begin here.
	dfl.button.Button spawnButton;
	dfl.button.Button exitButton;
	dfl.textbox.TextBox textBox1;
	dfl.picturebox.PictureBox pictureBox1;
	//~Entice Designer variables end here.
	//Preview panel1;
	Thread processing;
	Poset P;
	char[] filename;
	
	private int th() {
		P = new Poset();
		P.fromFile(filename);
		uint[][] result;
		//result = ladderDecomp(P);
		char[] resultString = "";
		//for (uint i = 0; i < result.length; i++) for (uint j = 0; j < result[i].length; j++) resultString ~= std.string.toString(result[i][j]) ~ " ";
		//textBox1.text(resultString);
		return 0;
	}
	
	this()
	{
		initializeMain();
		
		//@  Other main initialization code here.
		spawnButton.click ~= &spawnButton_click;
		exitButton.click ~= &exitButton_click;
		//Graphics g = pictureBox1.createGraphics();
		//Color c = Color.fromArgb(0,255,0,0);
		//g.drawLine(new Pen(c), Point(0,0), Point(100,100));
		//processing = new Thread(&(this.th));
		
	}
	
	
	~this() {
		if (processing) delete processing;
	}
	
	
	private void initializeMain()
	{
		// Do not manually modify this function.
		//~Entice Designer 0.8.5.02 code begins here.
		//~DFL Form
		text = "FPT Jump Demo";
		clientSize = dfl.all.Size(800, 600);
		//~DFL dfl.button.Button=spawnButton
		spawnButton = new dfl.button.Button();
		spawnButton.name = "spawnButton";
		spawnButton.text = "Otwórz";
		spawnButton.bounds = dfl.all.Rect(24, 40, 136, 31);
		spawnButton.parent = this;
		//~DFL dfl.button.Button=exitButton
		exitButton = new Button();
		exitButton.name = "exitButton";
		exitButton.text = "Zakończ";
		exitButton.bounds = dfl.all.Rect(176, 40, 136, 32);
		exitButton.parent = this;
		//~DFL dfl.textbox.TextBox=textBox1
		textBox1 = new dfl.textbox.TextBox();
		textBox1.name = "textBox1";
		textBox1.bounds = dfl.all.Rect(368, 40, 368, 40);
		textBox1.parent = this;
		//~DFL dfl.picturebox.PictureBox=pictureBox1
		pictureBox1 = new dfl.picturebox.PictureBox();
		pictureBox1.name = "pictureBox1";
		pictureBox1.bounds = dfl.all.Rect(24, 104, 712, 456);
		pictureBox1.parent = this;
		//~Entice Designer 0.8.5.02 code ends here.
		/+panel1 = new Preview();
		panel1.name = "panel2";
		panel1.bounds = dfl.all.Rect(200, 32, 216, 200);
		//panel1.dock = dfl.all.DockStyle.FILL;
		panel1.parent = this;+/
		textBox1.scrollBars(textBox1.scrollBars.HORIZONTAL);
	}
	
	private void spawnButton_click(Object sender, EventArgs ea) {
		OpenFileDialog dialog = new OpenFileDialog();
		dialog.multiselect = false;
		dialog.showDialog();
		filename = dialog.fileName();
		textBox1.text = "Processing...";
		if (processing) delete processing;
		processing = new Thread(&(this.th));
		processing.start();
	}
	
	private void exitButton_click(Object sender, EventArgs ea) {
		Application.exit();
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
		debug {
			P.setInOutList(inlist, outlist);
			PosetPainter painter = new PosetPainter(P);
			writefln("inlist: ", P.getInlist());
			writefln("outlist: ", P.getOutlist());
			uint[][] e = linearExtensionbyDecomp(P, 5);
			writefln("extension: ", e);
			//uint[] ceiling;
			//ceiling = P.managedBuildCeiling(20, ceiling);
			//writefln(ceiling);
		}
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