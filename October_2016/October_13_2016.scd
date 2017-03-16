///////////////////////////////////
// October 13, 2016
// Darien Brito
// darienbrito.com
///////////////////////////////////

/*
IDEA: A chromatic progression of chords with a simple Triangular wave synth
*/

(
SynthDef(\se, { | freq = 60, envDur = 0.5, cFreq = 1000, amp = 0.5, detune = 0.1 |
	var sig = VarSaw.ar([freq, freq + detune], 0, LFTri.kr(1).range(0, 1), 0.1);
	sig = sig * 10;
	sig = sig.clip;
	sig = sig.distort;
	sig = sig * SinOsc.ar(freq * 2).range(0, 1); // Add only + spectrum
	sig = LeakDC.ar(sig);
	sig = FbL({|fb| sig + LPF.ar(LeakDC.ar(fb), LFSaw.kr(1, 0.5).range(60, 13000)) * 0.9 }, 1/freq);
	sig = sig * EnvGen.kr(Env.perc(0.01, envDur), doneAction: 2);
	Out.ar(0, sig * amp);
}).add
)

(
~seqs = (
	odds: Pn(Pseries(0, 1, 10), 1).reject({|i| i.even }),
	evens: Pn(Pseries(0, 1, 10), 1).reject({|i| i.odd }),
);
Pbind(
	\instrument, \se,
	\degree, Pnsym(Pseq([\odds, \evens],inf), ~seqs),
	\scale, Scale.augmented,
	\octave, 4,
	\root, Pseq([3,2,1,0],inf),
	\envDur, 1,
	\dur, Pn(Pstutter(Pseq([1, 3, 2, 1]), Pseq([0.5, 0.25, 0.75])), inf),
).play;
)