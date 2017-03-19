///////////////////////////////////
// October 17, 2016
// Darien Brito
// darienbrito.com
///////////////////////////////////

/*
IDEA: Exploring some different phase modulation algorithms (lots of intersting possibilities here)
*/



1:       2:        3:        4:          5:          6:
---------------------------------------------------------------
[4]      [4]-[3]   [4]         [4]       [4]         [4]
 |          |       |           |         |           |
[3]        [2]     [3]-[2]   [3]-[2]     [3]         [3]
 |          |         |         |         |           |
[2]        [1]       [1]       [1]     [2]-[1]   [1]-[2]
 |
[1]


(
SynthDef(\fMalg1, {
	| op1Freq = 100, op2Freq = 200, op3Freq = 1, op4Freq = 20, op1Index = 1, op2Index = 4, op3Index = 10, op4Index = 2, pan = 0, amp = 1, rel = 1, pos = 0, out = 0 |
	var sig = SinOsc.ar(op1Freq,
		phase: SinOsc.ar(op2Freq,
			phase:SinOsc.ar(op3Freq,
				phase:SinOsc.ar(op4Freq, 0, mul: op4Index), mul: op3Index), mul: op2Index), mul: op1Index);
	sig = sig * EnvGen.kr(Env.perc(0.01, rel), doneAction: 2);
	sig = sig * amp;
	Out.ar(0, Pan2.ar(sig, pos));
}).add;

SynthDef(\fMalg2,{
	| op1Freq = 100, op2Freq = 200, op3Freq = 1, op4Freq = 20, op1Index = 1, op2Index = 4, op3Index = 10, op4Index = 2, pan = 0, amp = 1, rel = 1, pos = 0, out = 0 |
	var op4 = SinOsc.ar(op4Freq, 0, op4Index);
	var op3 = SinOsc.ar(op3Freq, 0, op3Index);
	var op2 = SinOsc.ar(op3Freq, phase: op4 + op3);
	var sig = SinOsc.ar(op1Freq, op2, op1Index);
	sig = sig * EnvGen.kr(Env.perc(0.01, rel), doneAction: 2);
	sig = sig * amp;
	Out.ar(0, Pan2.ar(sig, pos));
}).add;

SynthDef(\fMalg3, {
	| op1Freq = 100, op2Freq = 200, op3Freq = 1, op4Freq = 20, op1Index = 1, op2Index = 4, op3Index = 10, op4Index = 2, pan = 0, amp = 1, rel = 1, pos = 0, out = 0 |
	var op4 = SinOsc.ar(op4Freq, 0, op4Index);
	var op3 = SinOsc.ar(op3Freq, op4, op3Index);
	var op2 = SinOsc.ar(op2Freq, 0, op2Index);
	var sig = SinOsc.ar(op1Freq, op2 + op3, op1Index);
	sig = sig * EnvGen.kr(Env.perc(0.01, rel), doneAction: 2);
	sig = sig * amp;
	Out.ar(0, Pan2.ar(sig, pos));
}).add;

SynthDef(\fMalg4, {
	| op1Freq = 100, op2Freq = 200, op3Freq = 1, op4Freq = 20, op1Index = 1, op2Index = 4, op3Index = 10, op4Index = 2, pan = 0, amp = 1, rel = 1, pos = 0, out = 0 |
	var op4 = SinOsc.ar(op4Freq, 0, op4Index);
	var op3 = SinOsc.ar(op3Freq, op4, op3Index);
	var op2 = SinOsc.ar(op2Freq, op4, op2Index);
	var sig = SinOsc.ar(op1Freq, op2 + op3, op1Index);
	sig = sig * EnvGen.kr(Env.perc(0.01, rel), doneAction: 2);
	sig = sig * amp;
	Out.ar(0, Pan2.ar(sig, pos));
}).add;

SynthDef(\fMalg5, {
	| op1Freq = 100, op2Freq = 200, op3Freq = 1, op4Freq = 20, op1Index = 1, op2Index = 4, op3Index = 10, op4Index = 2, pan = 0, amp = 1, rel = 1, pos = 0, out = 0 |
	var op4 = SinOsc.ar(op4Freq, 0, op4Index);
	var op3 = SinOsc.ar(op3Freq, op4, op3Index);
	var op2 = SinOsc.ar(op2Freq, op3, op2Index.clip(0, 1)) * 0.5; // Limit to max 1 amp
	var sig = SinOsc.ar(op1Freq, op3, op1Index) * 0.5;
	sig = sig  + op2;
	sig = sig * EnvGen.kr(Env.perc(0.01, rel), doneAction: 2);
	sig = sig * amp;
	Out.ar(0, Pan2.ar(sig, pos));
}).add;

SynthDef(\fMalg6, {
	| op1Freq = 100, op2Freq = 200, op3Freq = 1, op4Freq = 20, op1Index = 1, op2Index = 4, op3Index = 10, op4Index = 2, pan = 0, amp = 1, rel = 1, pos = 0, out = 0 |
	var op4 = SinOsc.ar(op4Freq, 0, op4Index);
	var op3 = SinOsc.ar(op3Freq, op4, op3Index);
	var op2 = SinOsc.ar(op2Freq, op3, op2Index.clip(0, 1)) * 0.5; // Limit to max 1 amp
	var sig = SinOsc.ar(op1Freq, 0, op1Index) * 0.5;
	sig = sig  + op2;
	sig = sig * EnvGen.kr(Env.perc(0.01, rel), doneAction: 2);
	sig = sig * amp;
	Out.ar(0, Pan2.ar(sig, pos));
}).add;

// Tester function
~phaseModSynth = { |type = \fMalg1, b = 200, m1 = 100, m2 = 50, m3 = 25, amp = 1, i1 = 2, i2 = 3, i3 = 4, pos = 0, rel = 1|
	Synth(type, [\op1Freq, b,
		\op2Freq, m1, \op3Freq, m2, \op4Freq, m3,
		\op1Index, amp, \op2Index, i1, \op3Index, i2, \op4Index, i3,
		\pos, pos, \rel, rel
	]);
};
)

// A little test to hear the algorithms's different colours:
(
var algorithms = 6.collect{|i| (\fMalg ++ (i+1)).asSymbol};
Tdef(\test, {
	algorithms.do{|tag, i|
		var type = tag;
		var baseFreq = 400;
		var mod1Freq = baseFreq * 0.5;
		var mod2Freq = mod1Freq * 0.5;
		var mod3Freq = mod2Freq * 0.5;
		var baseAmp = 1;
		var mod1Index = 0.5;
		var mod2Index = 3;
		var mod3Index = 4;
		var pos = 0;
		var rel = 1;
		~phaseModSynth.(type, baseFreq, mod1Freq, mod2Freq, mod3Freq, baseAmp, mod1Index, mod2Index, mod3Index, pos, rel);
		"Algorithm: %".format(i+1).postln;
		rel.wait;
	}
}).quant_(0).play;
)

(
Pbind(
	//\instrument, Pseq([\fMalg1, \fMalg2, \fMalg3, \fMalg4, \fMalg5, \fMalg6],inf),
	\instrument, \fMalg1,
	\op1Freq, Pseq([100, 400, 300] * 5,inf),
	\op2Freq, Pkey(\op1Freq) * 0.5,
	\op3Freq, Pkey(\op2Freq) * 0.5,
	\op4Freq, Pkey(\op3Freq) * 0.5,
	\op2Index, Pn(Pseries(0, 1, 10),inf),
	\op3Index, Pn(Pseries(10, -1, 10),inf),
	\op4Index, Pn(Pseries(20, -2, 10),inf),
	\pos, Pwhite(-0.5, 0.5),
	\amp, 0.1,
	\dur, 0.25
).play;
)
