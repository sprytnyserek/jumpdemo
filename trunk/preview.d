/*
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

private {
	import dfl.all;
	
	import structure;
	static import std.string;
	import std.random;
}


class Preview: dfl.panel.Panel
{
	// Do not modify or move this block of variables.
	//~Entice Designer variables begin here.
	dfl.picturebox.PictureBox pictureBox1;
	//~Entice Designer variables end here.
	
	
	this()
	{
		initializePreview();
		
		//@  Other Preview initialization code here.
		this.scrollSize(Size(this.right,this.bottom));
		this.vScroll(true);
		this.hScroll(true);
		
		//this.click ~= &this_click;
		
		//Bitmap b = new Bitmap("D:\\dokumenty\\zboqk1.bmp");
		//pictureBox1.image = b;
		//this.scrollSize(b.size);
		
	}
	
	
	private void initializePreview()
	{
		// Do not manually modify this function.
		//~Entice Designer 0.8.5.02 code begins here.
		//~DFL Panel
		name = "Preview";
		bounds = dfl.all.Rect(0, 0, 200, 200);
		//~DFL dfl.picturebox.PictureBox=pictureBox1
		pictureBox1 = new dfl.picturebox.PictureBox();
		pictureBox1.name = "pictureBox1";
		pictureBox1.backColor = dfl.all.Color(255, 255, 255);
		pictureBox1.dock = dfl.all.DockStyle.FILL;
		pictureBox1.bounds = dfl.all.Rect(0, 0, 200, 200);
		pictureBox1.parent = this;
		//~Entice Designer 0.8.5.02 code ends here.
		//this.scrollSize = Size(688, 352);
		//this.controls.add(pictureBox1);
	}
	
	
	/+
	void drawDiagram(Poset P, uint[2][] grid, uint[][] chains = []) {
		//Graphics g = pictureBox1.createGraphics();
		//Color c = Color.fromArgb(0,255,0,0);
		//g.drawLine(new Pen(c), Point(0,0), Point(100,100));
		Graphics g = pictureBox1.createGraphics();
		Color c = Color.fromArgb(0, 0, 0, 0);
		Pen p = new Pen(c);
		uint[][] outlist = P.getOutlist();
		for (uint i = 0; i < outlist.length; i++) {
			foreach (uint j; outlist[i]) {
				g.drawLine(p, Point(grid[i][0], grid[i][1]), Point(grid[j][0], grid[j][1]));
			}
		}
		Color wc = Color.fromArgb(0, 255, 255, 255);
		Pen wp = new Pen(wc);
		for (uint i = 0; i < outlist.length; i++) {
			g.drawEllipse(p, Rect(grid[i][0] - 5, grid[i][1] - 5, 10, 10));
			for (uint j = 0; j < 5; j++) g.drawEllipse(wp, Rect(grid[i][0] - j, grid[i][1] - j, 2 * j, 2 * j));
			/+g.drawLine(wp, Point(grid[i][0], grid[i][1]), Point(grid[i][0] + 1, grid[i][1] + 1));
			g.drawLine(wp, Point(grid[i][0], grid[i][1]), Point(grid[i][0] + 1, grid[i][1] - 1));
			g.drawLine(wp, Point(grid[i][0], grid[i][1]), Point(grid[i][0] - 1, grid[i][1] + 1));
			g.drawLine(wp, Point(grid[i][0], grid[i][1]), Point(grid[i][0] - 1, grid[i][1] - 1));
			g.drawLine(wp, Point(grid[i][0], grid[i][1]), Point(grid[i][0] + 1, grid[i][1]));
			g.drawLine(wp, Point(grid[i][0], grid[i][1]), Point(grid[i][0], grid[i][1] - 1));
			g.drawLine(wp, Point(grid[i][0], grid[i][1]), Point(grid[i][0] - 1, grid[i][1]));
			g.drawLine(wp, Point(grid[i][0], grid[i][1]), Point(grid[i][0], grid[i][1] + 1));+/
			g.drawRectangle(wp, Rect(grid[i][0], grid[i][1], 1, 1));
			g.drawRectangle(wp, Rect(grid[i][0] - 1, grid[i][1] - 1, 2, 2));
			g.drawRectangle(wp, Rect(grid[i][0], grid[i][1], 2, 2));
			g.drawRectangle(wp, Rect(grid[i][0] - 1, grid[i][1], 2, 2));
			g.drawRectangle(wp, Rect(grid[i][0], grid[i][1] - 1, 2, 2));
			g.drawRectangle(wp, Rect(grid[i][0] - 1, grid[i][1] - 1, 2, 2));
		}
		//pictureBox1.image = new Bitmap(g);
		//pictureBox1.redraw();
		g.flush();
		MemoryGraphics mg = new MemoryGraphics(100, 100);
		//mg.drawLine(p, Point(0, 0), Point(99, 99));
		Bitmap b = mg.toBitmap();
		pictureBox1.image = b;
	}
	+/
	
	
	void drawDiagram(Poset P, uint[2][] grid, uint[][] chains = []) {
		uint maxX, maxY;
		for (uint i = 0; i < grid.length; i++) {
			maxX = maxX < grid[i][0] ? grid[i][0] : maxX;
			maxY = maxY < grid[i][1] ? grid[i][1] : maxY;
		}
		maxX += 20;
		maxY += 20;
		maxX = maxX < this.width ? this.width : maxX;
		maxY = maxY < this.height ? this.height : maxY;
		//this.scrollSize(Size(this.width, this.height));
		uint[] groups;
		bool[] elmtInGroup;
		groups.length = elmtInGroup.length = grid.length;
		for (uint i = 0; i < groups.length; i++) groups[i] = uint.max;
		for (uint i = 0; i < chains.length; i++) {
			foreach (uint j; chains[i]) {
				groups[j] = i;
				elmtInGroup[j] = true;
			}
		}
		Color[] grpColors;
		grpColors.length = chains.length;
		for (uint i = 0; i < grpColors.length; i++) grpColors[i] = Color.fromArgb(0, rand() % 256, rand() % 256, rand() % 256);
		Pen[] grpPens;
		grpPens.length = chains.length;
		for (uint i = 0; i < grpPens.length; i++) grpPens[i] = new Pen(grpColors[i]);
		MemoryGraphics g = new MemoryGraphics(maxX, maxY);
		g.fillRectangle(Color.fromArgb(0, 255, 255, 255), 0, 0, g.width, g.height);
		Color black = Color.fromArgb(0, 0, 0, 0);
		Pen blackPen = new Pen(black);
		Color c;
		Pen p;
		//uint[][] inlist = P.getInlist();
		uint[][] outlist = P.getOutlist();
		for (uint i = 0; i < outlist.length; i++) {
			foreach (uint j; outlist[i]) {
				if ((groups[i] == groups[j]) && (groups[i] != uint.max)) p = grpPens[groups[i]];
				else p = blackPen;
				g.drawLine(p, Point(grid[i][0], grid[i][1]), Point(grid[j][0], grid[j][1]));
			}
		}
		Color wc = Color.fromArgb(0, 255, 255, 255);
		Pen wp = new Pen(wc);
		TextFormat frmt = new TextFormat();
		frmt.alignment(TextAlignment.CENTER);
		frmt.leftMargin(1);
		frmt.rightMargin(1);
		for (uint i = 0; i < outlist.length; i++) {
			//g.drawEllipse(p, Rect(grid[i][0] - 10, grid[i][1] - 5, 20, 10));
			//for (uint j = 0; j < 5; j++) g.drawEllipse(wp, Rect(grid[i][0] - j, grid[i][1] - j, 2 * j, 2 * j));
			Rect r = Rect(grid[i][0] - 15, grid[i][1] - 7, 30, 14);
			if (groups[i] != uint.max) p = grpPens[groups[i]]; else p = blackPen;
			g.drawRectangle(p, r);
			g.fillRectangle(Color.fromArgb(0, 255, 255, 255), grid[i][0] - 14, grid[i][1] - 6, 28, 12);
			//g.drawText(std.string.toString(i), font, c, r, frmt);
			/+g.drawLine(wp, Point(grid[i][0], grid[i][1]), Point(grid[i][0] + 1, grid[i][1] + 1));
			g.drawLine(wp, Point(grid[i][0], grid[i][1]), Point(grid[i][0] + 1, grid[i][1] - 1));
			g.drawLine(wp, Point(grid[i][0], grid[i][1]), Point(grid[i][0] - 1, grid[i][1] + 1));
			g.drawLine(wp, Point(grid[i][0], grid[i][1]), Point(grid[i][0] - 1, grid[i][1] - 1));
			g.drawLine(wp, Point(grid[i][0], grid[i][1]), Point(grid[i][0] + 1, grid[i][1]));
			g.drawLine(wp, Point(grid[i][0], grid[i][1]), Point(grid[i][0], grid[i][1] - 1));
			g.drawLine(wp, Point(grid[i][0], grid[i][1]), Point(grid[i][0] - 1, grid[i][1]));
			g.drawLine(wp, Point(grid[i][0], grid[i][1]), Point(grid[i][0], grid[i][1] + 1));+/
			g.drawRectangle(wp, Rect(grid[i][0], grid[i][1], 1, 1));
			g.drawRectangle(wp, Rect(grid[i][0] - 1, grid[i][1] - 1, 2, 2));
			g.drawRectangle(wp, Rect(grid[i][0], grid[i][1], 2, 2));
			g.drawRectangle(wp, Rect(grid[i][0] - 1, grid[i][1], 2, 2));
			g.drawRectangle(wp, Rect(grid[i][0], grid[i][1] - 1, 2, 2));
			g.drawRectangle(wp, Rect(grid[i][0] - 1, grid[i][1] - 1, 2, 2));
			if (groups[i] != uint.max) c = grpColors[groups[i]]; else c = black;
			g.drawText(std.string.toString(i), font, c, r, frmt);
		}
		g.flush();
		Bitmap b = g.toBitmap();
		pictureBox1.image = b;
		delete g;
	}
	
	
	private void this_click(Object sender, EventArgs lea) {
		//this.backColor = Color.fromArgb(0, 255, 0, 0);
		Graphics g = this.createGraphics();
		Color c = Color.fromArgb(0,255,0,0);
		Pen p = new Pen(c);
		g.drawLine(p, Point(this.left, this.top), Point(this.right, this.bottom));
		g.flush();
	}
	
	
}
