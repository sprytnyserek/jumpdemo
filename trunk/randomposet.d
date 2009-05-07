﻿/*
	Generated by Entice Designer
	Entice Designer written by Christopher E. Miller
	www.dprogramming.com/entice.php
*/
module randomposet;

private {
	import dfl.all;
	
	import std.stdio;
	import std.conv;
}




class RandomPoset: dfl.form.Form
{
	// Do not modify or move this block of variables.
	//~Entice Designer variables begin here.
	dfl.label.Label label3;
	dfl.button.Button okButton;
	dfl.button.Button canButton;
	dfl.textbox.TextBox numberBox;
	//~Entice Designer variables end here.
	
	
	this()
	{
		initializeRandomPoset();
		
		//@  Other randomPoset initialization code here.
		numberBox.textChanged ~= &numberBox_textChanged;
		numberBox.visibleChanged ~= &numberBox_visibleChanged;
		okButton.click ~= &okButton_click;
		canButton.click ~= &canButton_click;
		this.acceptButton(okButton);
		this.cancelButton(canButton);
	}
	
	
	private void numberBox_textChanged(Object sender, EventArgs ea) {
		char[] content;
		bool good = true;
		if (numberBox.lines.length == 0) {
			okButton.enabled(false);
			return;
		}
		for (uint i = 0; i < numberBox.lines[0].length; i++) {
			if ((numberBox.lines[0][i] >= '0') && (numberBox.lines[0][i] <= '9')) {
				char[] got = numberBox.lines[0].dup;
				if (got.length > 9) {
					good = false;
					break;
				}
				content ~= numberBox.lines[0][i];
			}
			else good = false;
		}
		if (good) {
			if ((numberBox.lines.length > 0) && (numberBox.lines[0].length > 0)) okButton.enabled(true); else okButton.enabled(false);
			return;
		}
		//writefln(content);
		/+numberBox.clear;
		
		numberBox.lines[0] = content;
		numberBox.refresh();
		numberBox.redraw();+/
		numberBox.text = content;
		if (content.length > 0) okButton.enabled(true); else okButton.enabled(false);
	}
	
	
	private void okButton_click(Object sender, EventArgs ea) {
		this.dialogResult = DialogResult.OK;
		this.visible(false);
		//this.dispose();
	}
	
	
	private void canButton_click(Object sender, EventArgs ea) {
		this.dialogResult = DialogResult.CANCEL;
		this.visible(false);
		//this.dispose();
	}
	
	
	private void numberBox_visibleChanged(Object sender, EventArgs ea) {
		if (numberBox.visible == true) numberBox.focus();
	}
	
	
	private void initializeRandomPoset()
	{
		// Do not manually modify this function.
		//~Entice Designer 0.8.5.02 code begins here.
		//~DFL Form
		text = "Losuj poset";
		clientSize = dfl.all.Size(240, 100);
		//~DFL dfl.label.Label=label3
		label3 = new dfl.label.Label();
		label3.name = "label3";
		label3.text = "Liczba elementów";
		label3.bounds = dfl.all.Rect(16, 16, 96, 16);
		label3.parent = this;
		//~DFL dfl.button.Button=okButton
		okButton = new dfl.button.Button();
		okButton.name = "okButton";
		okButton.enabled = false;
		okButton.text = "OK";
		okButton.bounds = dfl.all.Rect(16, 72, 96, 24);
		okButton.parent = this;
		//~DFL dfl.button.Button=canButton
		canButton = new dfl.button.Button();
		canButton.name = "canButton";
		canButton.text = "Anuluj";
		canButton.bounds = dfl.all.Rect(128, 72, 96, 24);
		canButton.parent = this;
		//~DFL dfl.textbox.TextBox=numberBox
		numberBox = new dfl.textbox.TextBox();
		numberBox.name = "numberBox";
		numberBox.backColor = dfl.all.Color(255, 255, 255);
		numberBox.borderStyle = dfl.all.BorderStyle.FIXED_SINGLE;
		numberBox.bounds = dfl.all.Rect(16, 32, 208, 24);
		numberBox.parent = this;
		//~Entice Designer 0.8.5.02 code ends here.
	}
}

