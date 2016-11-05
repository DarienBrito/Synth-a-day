////////////////////////////////////////////////////////////////////////////////////////////////////
//
// GUIStyler
//
// * Minimal fancy looks for GUIs
//
// Copyright (C) <2016>
//
// by Darien Brito
// http://www.darienbrito.com
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program. If not, see <http://www.gnu.org/licenses/>.

GUIStyler {
	var <master;
	var <alpha, <backgroundColor, <stringColor;
	var <buttonSize, <textSize, <sliderSize;
	var <gadgetWidth, <gadgetHeight, <font;
	var window, <marginW, <marginH, <decorator;
	var <stdFactor; //standard factor for spacing
	var <highlightColor, <knobSize, <thumbSize;
	var <backgroundSl, <onColor, <flowLayout;
	var <buttonWidth, <ezSizeVert, <ezSizeHorz;
	var <ezSizeW, <ezSizeH, fontType;

	*new {|master|
		^super.newCopyArgs(master).init;
	}

	init {
		alpha = 1;//0.85;
		backgroundColor = Color.gray(0.2, 1);//Color.black;
		stringColor = Color.white;
		gadgetWidth = 25;
		gadgetHeight = 20;
		buttonWidth = gadgetWidth * 2;
		buttonSize = buttonWidth@gadgetHeight;
		textSize = gadgetWidth@gadgetHeight;
		ezSizeW = 280;
		ezSizeH = 220;
		sliderSize = gadgetWidth@180;
		ezSizeVert = gadgetWidth@ezSizeH;
		ezSizeHorz = ezSizeW@gadgetHeight;
		fontType = "Helvetica";
		font = Font(fontType, 10);
		marginW = 2;
		marginH = 2;
		stdFactor = 32;
		highlightColor = Color.blue(0.5,0.2);
		knobSize = 0;
		thumbSize = 10;
		backgroundSl = Color.white;
		onColor = Color.gray(0.4, 1);
	}

	getWindow { | name = "My window", bounds, border = false, scroll = false |
		window = View(master, bounds)
		.alpha_(alpha)
		.alwaysOnTop_(true)
		.background = backgroundColor;
		^window;
	}

	getButton { |parent, labelOn, labelOff = nil|
		var button = Button(parent, buttonSize)
		.font_(font);
		if(labelOff.isNil){
			^button.states_([ [labelOn, stringColor, backgroundColor] ]);
		}{
			^button.states_([ [labelOn, stringColor, backgroundColor], [labelOff,stringColor, onColor] ])
		}
		^button
	}

	getSizableButton { |parent, labelOn, labelOff = nil, size|
		var button = Button(parent, size)
		.font_(font);
		if(labelOff.isNil){
			^button.states_([ [labelOn, stringColor, backgroundColor] ]);
		}{
			^button.states_([ [labelOn, stringColor, backgroundColor], [labelOff,stringColor, onColor] ])
		}
		^button
	}

	getSubtitleText { |parent, text, decorator, fontSize = 10, bold = true,align=\center,width = nil|
		if(width == nil){width = decorator.indentedRemaining.width};
		^StaticText(parent, (width)@gadgetHeight )
		.align_(align)
		.font_(Font(fontType, fontSize, bold))
		.string_(text)
		.stringColor_(stringColor)
		.background_(backgroundColor);
	}

	getText { |parent, text|
		^StaticText(parent, textSize)
		.align_(\center)
		.font_(font)
		.string_( text )
		.stringColor_(stringColor)
		.background_(backgroundColor);
	}

	getMultiLineText {|parent, bounds, fontSize = 10|
		^TextView(parent, bounds)
		.font_(Font(fontType, fontSize))
		.stringColor_(stringColor)
		.background_(backgroundColor)
		.hasVerticalScroller_(true)
		.editable_(false)
	}

	getSizableText { |parent, text, width, align = \center, fontSize = 10, bold = false|
		^StaticText(parent, width@gadgetHeight)
		.align_(align)
		.font_(Font(fontType, fontSize, bold))
		.string_( text )
		.stringColor_(stringColor)
		.background_(backgroundColor);
	}

	getSlider { |parent|
		^SmoothSlider( parent, sliderSize)
		.orientation_(\v)
		.knobSize_(knobSize).thumbSize_(thumbSize)
		.hilightColor_(highlightColor)
		.value_(0.5)
		.background_(backgroundSl)
		.align_(\left)
		.font_(font);
	}

	getRangeSlider { |parent|
		^SmoothRangeSlider(parent, sliderSize)
		.knobSize_(knobSize).thumbSize_(thumbSize)
		.hilightColor_(highlightColor)
		.value_(0.5)
		.background_(backgroundSl)
		.align_(\left)
		.value_([0, 0])
	}

	getEZSlider { |parent, label, spec, orientation = \vert|
		var ezSmooth;
		if(orientation == \vert) {
			ezSmooth = EZSmoothSliderAntialias(parent, ezSizeVert, label, spec, layout: orientation)
		} {
			ezSmooth = EZSmoothSliderAntialias(parent, ezSizeHorz, label, spec, layout: orientation)
		};
		ezSmooth.sliderView
		.knobSize_(knobSize).thumbSize_(thumbSize)
		.hilightColor_(highlightColor)
		.value_(0.5)
		.background_(backgroundSl)
		.align_(\center)
		.value_([0, 0]);
		ezSmooth.numberView
		.font_(font)
		.stringColor_(stringColor)
		.normalColor_(stringColor)
		.align_(\center)
		.background_(backgroundColor);
		ezSmooth.labelView
		.align_(\center)
		.font_(font)
		.stringColor_(stringColor)
		.background_(backgroundColor);
		^ezSmooth;
	}

	getEZRanger { |parent, label, spec, orientation = \vert|
		var ezSmooth;
		if(orientation == \vert) {
			ezSmooth = EZSmoothRangerAntialias(parent, ezSizeVert, label, spec, layout: orientation)
		} {
			ezSmooth = EZSmoothRangerAntialias(parent, ezSizeHorz, label, spec, layout: orientation)
		};
		ezSmooth.rangeSlider
		.knobSize_(knobSize).thumbSize_(thumbSize)
		.hilightColor_(highlightColor)
		.value_(0.5)
		.background_(backgroundSl)
		.align_(\center)
		.value_([0, 0]);
		ezSmooth.loBox
		.font_(font)
		.stringColor_(stringColor)
		.normalColor_(stringColor)
		.align_(\center)
		.background_(backgroundColor);
		ezSmooth.hiBox
		.font_(font)
		.stringColor_(stringColor)
		.normalColor_(stringColor)
		.align_(\center)
		.background_(backgroundColor);
		ezSmooth.labelView
		.align_(\center)
		.font_(font)
		.stringColor_(stringColor)
		.background_(backgroundColor);
		^ezSmooth;
	}

	getPopUpMenu { |parent, width|
		var pop = PopUpMenu(parent, width@gadgetHeight)
		.background_(backgroundColor)
		.stringColor_(stringColor)
		.font_(font);
		^pop
	}

	// How to make this a method?
	getButtonStack {| num, labels, offsetX, offsetY |
		/*
		decorator.top = offsetY;
		decorator.nextLine;
		decorator.left = offsetX;
		randBtn = Button(win, buttonSize).states = [["rand", stringColor, backgroundColor]];

		decorator.nextLine;
		decorator.left = offsetX;
		storeBtn = Button(win, buttonSize).states = [["store", stringColor, backgroundColor]];

		decorator.nextLine;
		decorator.left = offsetX;
		printBtn = Button(win, buttonSize).states = [["print", stringColor, backgroundColor]];

		decorator.nextLine;
		decorator.left = offsetX;
		uniformBtn = Button(win, buttonSize).states = [["even", stringColor, backgroundColor]];
		*/
	}

	getCheckBox{ |parent,text|
		var check = CheckBox(parent,20@20,text)
		.background_(backgroundColor)
		.font_(font);
		^check;
	}

	getColoredRect{|parent,color,align=\left|
		^StaticText(parent, 2@20)
		.align_(align)
		.string_( "" )
		.background_(color);
	}
}