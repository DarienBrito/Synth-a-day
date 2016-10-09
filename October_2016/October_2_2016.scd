///////////////////////////////////
// October 2, 2016
// Darien Brito
// darienbrito.com
///////////////////////////////////

/*
IDEA: Make a double sawtooth synth with comb-filtering
*/

(
SynthDef(\sawer,{ | freq = 440, cFreq = 2000, del = 0.02, dec = 0.1, filDur = 0.2, envDur = 1, amp = 0.5|
	var difs = [-0.03, 0, 0.03];
	var oscs = 2.collect{|i| Saw.ar( [(freq - difs[i]), (freq + 0.1) - difs[i] ] + SinOsc.ar(3, 0, 1), 0.5) };
	var sig = LPF.ar(oscs, XLine.ar(cFreq, 100, filDur, doneAction: 0));
	sig = sig * EnvGen.ar(Env.sine(envDur, 1), doneAction: 2);
	2.do{|i| sig = sig + CombL.ar(sig, 0.2, del, dec)};
	sig = sig;
	sig = sig.fold(-0.9, 0.9);
	LeakDC.ar(sig);
	Out.ar(0, sig * amp);
}).add
)

// test it
Synth(\sawer, [\freq, 60.midicps, \cFreq, 7000, \envDur, 1]);

// Sequence it
(
Pbind(
	\instrument, \sawer,
	\scale, Scale.augmented,
	\degree, Pn(Pshuf((0..8), 1), inf),
	\cFreq, Pfunc({|f| (f.degree * 1000) + 500 }), // Higher cFreq if freq is higher
	\octave, Pstutter(Pseq([3, 2, 3],inf), Pseq([3, 2, 4],inf)),
	\filDur, 0.2,
	\dec, 0.1,
	\envDur, 1,
	\dur, 0.5,
	\amp, 1
).play
)

// RE-visit: Two in parallel with a triplet delay sounds interesting:
(
x = Pbind(
	\instrument, \sawer,
	\scale, Scale.augmented,
	\degree, Pn(Pshuf((0..8), 1), inf),
	\cFreq, Pfunc({|f| (f.degree * 1000) + 500 }), // Higher cFreq if freq is higher
	\octave, Pstutter(Pseq([3, 2, 3],inf), Pseq([3, 2, 4],inf)),
	\filDur, 0.25,
	\dec, 0.1,
	\envDur, 1,
	\dur, 0.5,
	\amp, 0.3,
);

Tdef(\delayed, {
	x.play;
	0.3.wait;
	x.play;
}).play;
)