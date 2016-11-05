///////////////////////////////////
// October 27, 2016
// Darien Brito
// darienbrito.com
///////////////////////////////////

/*
IDEA: A GUI for a very simple (silly) sequencer
*/

// Our weird synthesizer
(
SynthDef(\siny, {| freq = 120, fb = 0.99, modFreq = 10, modRate = 12, phaseGap = 0.01, amp = 0.25 |
	var delays = 12;
	var mod = SinOscFB.ar(modFreq, fb);
	var sin = SinOsc.ar(freq, mod, 1) * delays.reciprocal;
	var delMods = delays.collect{|i| LFSaw.kr(modRate * rrand(0.9, 1.1), i * phaseGap).range(0.01, 0.19) };
	var sig = DelayC.ar(sin, 0.2, delMods);
	sig = Mix.ar(sig);
	sig = sig * EnvGen.kr(Env.perc(0.01, 1), doneAction: 2);
	sig = sig * amp;
	Out.ar(0, sig ! 2);
}).add
)

(
var width = 25;
var n = 12;
var win = Window("Sequencer", width@300);
var decorator, buttons;
var rateVals = n.collect{|i| if((i+1).odd){ 10 } { rrand(50.0, 80) } };
var seq;
win.view.decorator = FlowLayout(win.view.bounds);
decorator = win.view.decorator;
buttons = n.collect{|i|
	Button(win, width - 5)
	.states_([[" ", Color.black, Color.gray], ["x", Color.black, Color.gray]])
	.action_({|btn|
		if(btn.value > 0) {
			Synth(\siny, [\freq, 50, \fb, 0.9, \modFreq, 120, \modRate, rateVals[i], \phaseGap, 0.01]);
		};
	})
};
win.front;

seq = Routine({
	var bpm = 180;
	inf.do{|i|
		buttons[i % 12].valueAction_(1);
		buttons[(i-1) % 12].valueAction_(0);
		(60/bpm).wait;
	}
});

AppClock.play(seq);
)

Window.closeAll
