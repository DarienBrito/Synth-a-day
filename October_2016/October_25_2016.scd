///////////////////////////////////
// October 25, 2016
// Darien Brito
// darienbrito.com
///////////////////////////////////

/*
IDEA: Simple Multiwaveform
*/

// Declare Synth

(
SynthDef(\pad, {|
	sqFreq = 60, sawFreq = 60, triFreq = 60,
	sqOct = 1, sawOct = 1, triOct = 1, nCFreq = 60,
	triDev = 0, sqDev = 0, sawDev = 0,
	sqAmp = 0.25, sawAmp = 0.25, triAmp = 0.25,
	noiseAmp = 0.25 |
	var sq = Pulse.ar((sqFreq * sqOct) + sqDev, 0.5) * sqAmp;
	var saw = Saw.ar((sawFreq * sawOct) + sawDev) * sawAmp;
	var tri = VarSaw.ar((triFreq * triOct) + triDev) * triAmp;
	var noise = RLPF.ar(WhiteNoise.ar(1), LFTri.kr(0.1).range(100, 400), 0.1) * noiseAmp;
	var sig = Mix.ar([sq, saw, tri, noise]) * 0.5;
	sig = RLPF.ar(sig, LFTri.kr(0.1).range(100, 18000), 0.1);
	Out.ar(0, sig ! 2)
}).add
)

// Make GUI
(
var itemHeight = 20;
var winW = 400, winH = 17 * itemHeight + 25;
var win = Window(\controls, winW@winH);
var decorator, freqSliders, octaveSliders, ampSliders, devSliders, tags;
var slW = winW - 20, slH = 20;
var labels = [\square, \saw, \tri, \noise];
var fLabels = [\sqFreq, \sawFreq, \triFreq, \nCFreq];
var octLabels = [\sqOct, \sawOct, \triOct];
var devLabels = [\sqDev, \sawDev, \triDev];
var ampLables = [\sqAmp, \sawAmp, \triAmp, \noiseAmp];
var sound;
decorator = win.view.decorator = FlowLayout(win.view.bounds);
freqSliders = fLabels.collect{|label| EZSlider(win, slW@slH, label, \freq, {|sl| sound.set(label, sl.value )}, initVal: 120 )};
octaveSliders = octLabels.collect{|label| EZSlider(win, slW@slH, label, ControlSpec(0.1, 4, \lin, 0.1, 1), {|sl| sound.set(label.postln, sl.value.postln )}  )};
ampSliders = ampLables.collect{|label| EZSlider(win, slW@slH, label, \amp, {|sl| sound.set(label, sl.value )}, initVal: 0.25 )};
devSliders = devLabels.collect{|label| EZSlider(win, slW@slH, label, \amp, {|sl| sound.set(label, sl.value )}, initVal: 0 )}; // We use amp ControlSpec for convenience
Button(win, (winW-20)@20)
.states_([[\play, Color.red, Color.black], [\stop, Color.white, Color.black]])
.action_({ |btn|
	if(btn.value > 0) {
		sound = Synth(\pad);
	} {
		sound.free;
	}
});
win.front;
)

Window.closeAll