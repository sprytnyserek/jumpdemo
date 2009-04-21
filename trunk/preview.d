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

import dfl.all;


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
	}
}