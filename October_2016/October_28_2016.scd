///////////////////////////////////
// October 27, 2016
// Darien Brito
// darienbrito.com
///////////////////////////////////

/*
IDEA: A mutable step sequencer could be handy... (Different steps per track)

For this one you will need to install my GUIStyler Class, you can find it at:
"https://github.com/DarienBrito/Synth-a-day/blob/master/Resources/GUIStyler.sc"
*/

(
s.waitForBoot{
	var stepsArray = [4, 5, 7, 12];
	var bpm = 204;

	SynthDef(\kick0, { |out, bend = 120 pitchBend = 0.05, sustain=1, amp=0.8|
		var sig = SinOsc.ar(XLine.kr(bend,60,pitchBend,doneAction:2),2pi)!2;
		sig = sig * EnvGen.ar(Env.perc(0.001, 0.05), doneAction:2);
		OffsetOut.ar(out, sig * amp)
	}).add;

	SynthDef(\hat1, { |ffreq=200, rq=0.5, attack=0, release=0.025, amp=0.1, pan|
		var snd;
		snd = WhiteNoise.ar();
		snd = HPF.ar(snd, ffreq);
		snd = RHPF.ar(snd, ffreq*2, rq);
		snd = snd * EnvGen.ar(Env.perc(attack, release, 1, -10), doneAction:2);
		snd = Pan2.ar(snd, pan);
		OffsetOut.ar(0, snd * amp);
	}).add;

	SynthDef(\click, { |out, sus = 2, amp=0.1, gate = 1, cfreq = 200, pan = 0|
		var sig = Impulse.ar(1);
		EnvGen.ar(Env.perc(0.01, 0.1),gate, doneAction:2);
		sig = HPF.ar(sig, cfreq);
		OffsetOut.ar(out, Pan2.ar(sig * amp, pan))
	}).add;

	SynthDef(\laser, { |out, pan, amp=0.1, rel = 0.03|
		var snd, line;
		line = XLine.kr(Rand(8000, 12000), Rand(200, 40), rel);
		snd = SinOsc.ar(line) * EnvGen.ar(Env.perc(0.01, rel*1.1), doneAction:2);
		snd = Pan2.ar(snd, pan);
		OffsetOut.ar(out, snd * amp);
	}).add;

	~builGUI = { | stepsArray |
		var numberOfCols = 4;
		var buttonWidth = 25;
		var windowWidth = 250;
		var windowHeight = (12 + 3) * buttonWidth; //Default steps + offset * btnWidth
		var masterWindow = Window("Sequencer", windowWidth@windowHeight).background_(Color.gray(0.2, 1)).alpha_(0.9);
		var styler, sequencerSubStylers;
		var sequencerView, controlsView, columnsViews;
		var sequencerDecorator, controlsDecorator, masterDecorator, columnsDecorators;
		var colLabels = numberOfCols.collect{|i| (\col ++ (i+1)).asSymbol };
		var refreshColumns, makeColumns;
		var makeButtons;
		var stepsPerColumn = ();

		// -- Fill the dictionary with default lists;
		~buttons = ();
		colLabels.do{|label, i|
			~buttons.put(label, List.new(stepsArray[i]));
			stepsPerColumn.put(label, stepsArray[i]);
		};


		// -- Master Decorator --
		masterWindow.view.decorator = FlowLayout(masterWindow.view.bounds);
		masterDecorator = masterWindow.view.decorator;

		// --- Sequencer View ---------------------------------------------------------------------------|

		styler= GUIStyler(masterWindow);
		sequencerView = styler.getWindow("Sequencer", (buttonWidth*5)@windowHeight);
		sequencerView.decorator = FlowLayout(sequencerView.bounds);
		sequencerDecorator = sequencerView.decorator;
		styler.getSubtitleText(sequencerView, "Sequencer", sequencerDecorator);

		// --- A view per column --- (necessary to refresh only what we change)
		makeColumns = {
			sequencerSubStylers = numberOfCols.collect{ GUIStyler(sequencerView) };
			columnsViews = sequencerSubStylers.collect{|st, i| st.getWindow(i, buttonWidth@windowHeight) };
			columnsDecorators = columnsViews.collect{|view| view.decorator = FlowLayout(view.bounds) };
			columnsViews.do{|view, i|
				// Add as many buttons as desired steps
				~buttons[colLabels[i]] = List.new(stepsArray[i]); // Reformat for when we remake the window
				stepsPerColumn[colLabels[i]].do{|j|
					~buttons[colLabels[i]].add(
						Button(view, (buttonWidth-5)@(buttonWidth-5))
						.states_([[" ", Color.black, Color.black], ["x", Color.black, Color.red]])
				)};

				/*
				\\ This to make it refresh in real-time... I wasn't succesful with it so... for another day.
				sequencerSubStylers[i].getSizableNumberBox(view, (buttonWidth-5)@(buttonWidth-5), 1 )
				.value_(12)
				.action_({|num|
				var val = num.value.asInteger;
				stepsPerColumn[colLabels[i]] = val;
				columnsViews.do{|view| view.close }; // Close subwindows
				makeColumns.(); // Re-create;
				});
				*/
			};
		};

		makeColumns.();

		// ---------------------------------------------------------------------------------------------|

		// --- Controls View ---
		controlsView = styler.getWindow("Controls", (buttonWidth*3)@windowHeight);
		controlsView.decorator = FlowLayout(controlsView.bounds);
		controlsDecorator = controlsView.decorator;
		styler.getSubtitleText(controlsView, "Controls", controlsDecorator);

		// If OCD kicks in... use getSizableButton method to change butto size ;)
		styler.getNumberBox(controlsView, 1)
		.value_(bpm)
		.action({

		});

		styler.getButton(controlsView, "Start", "Pause")
		.action_({|btn| if(btn.value > 0) { ~seq.play } { ~seq.pause } });

		// For another day...
		/*

		styler.getButton(controlsView, "Rand")
		.action_({|btn|});

		styler.getButton(controlsView, "Store") // One state button
		.action_({|btn| if(btn.value > 0) {  } {  } });

		styler.getButton(controlsView, "Export")
		.action_({|btn| if(btn.value > 0) {  } {  } });
		*/

		masterWindow.front;
		masterWindow.onClose = { "Good bye!".postln; ~seq.stop };
	};

	~checkStates = { | group, index, func |
		var btn = group[index % group.size];
		var last = group[(index-1) % group.size];
		if(btn.value > 0) {
			func.();
			if(last.value < 1) {
				last.states_([[" ", Color.black, Color.black], ["x", Color.black, Color.red]]);
			}
		} {
			btn.states_([[" ", Color.black, Color.red], ["x", Color.black, Color.red]]);
			if(last.value < 1) {
				last.states_([[" ", Color.black, Color.black], ["x", Color.black, Color.red]]);
			}
		};
	};

	~seq = Task({
		inf.do{|i|
			defer{
				~checkStates.(~buttons[\col1], i, { Synth(\kick0) });
				~checkStates.(~buttons[\col2], i, { Synth(\hat1) });
				~checkStates.(~buttons[\col3], i, { Synth(\click) });
				~checkStates.(~buttons[\col4], i, { Synth(\laser) });
			};
			(60/bpm).wait;
		}
	});

	~builGUI.(stepsArray);

})

Window.closeAll
