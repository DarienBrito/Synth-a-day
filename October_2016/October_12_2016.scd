///////////////////////////////////
// October 12, 2016
// Darien Brito
// darienbrito.com
///////////////////////////////////

/*
IDEA: A slightly waveshaped synth with Pulses and a filter
*/


(
SynthDef(\glidy, { | freq = 60, envDur = 1, detune = 1.01, amp = 1 |
	var lFreq = Lag.kr(freq, 0.1);
	var pulses = Pulse.ar([ lFreq, lFreq * detune ]);
	var sig = RLPF.ar(pulses, Linen.kr(1, envDur * 0.3, envDur * 0.1, envDur * 0.6).range(100, 12000), 0.1);
//	var env = EnvGen.kr(Env.perc(envDur * 0.01, envDur * 0.99), doneAction: 2);
	var env = EnvGen.kr(Env([0, 1, 0], [envDur * 0.01, envDur * 0.98, envDur * 0.01]), doneAction: 2);
	sig = sig.distort;
	sig = sig * 5;
	sig = sig.fold(-0.9, 0.9);
	sig = LeakDC.ar(sig);
	sig = sig * env;
	Out.ar(0, sig * amp);
}).add
)

Synth(\glidy, [\freq, 30, \envDur, 1, \amp, 0.5]);


// Glided version
(
~seqs = (
	upwards: Pseries(0, 3, 12),
	downwards: Pseries(38, -2, 12),
	stepwise: Pslide((0..10), 10, 2),
	dstepwise: Pslide((10,9..0), 10, 2)
);

Pmono(
	\glidy,
	\scale, Pseq([Scale.augmented, Scale.diminished],inf),
	\degree, Pnsym(Pseq([\upwards, \downwards, \stepwise, \dstepwise], inf), ~seqs),
	\octave, Pseq([3,2,4],inf),
	\detune, 1.01,
	\envDur, 100,
	\legato, 1.1,
	\dur, 0.125
).play;
)

// Stepped version
(
~seqs = (
	upwards: Pseries(0, 3, 12),
	downwards: Pseries(38, -2, 12),
	stepwise: Pslide((0..10), 10, 2),
	dstepwise: Pslide((10,9..0), 10, 2)
);

Pbind(
	\instrument, \glidy,
	\scale, Pseq([Scale.augmented, Scale.diminished],inf),
	\degree, Pnsym(Pseq([\upwards, \downwards, \stepwise, \dstepwise], inf), ~seqs),
	\octave, Pseq([3,2,4],inf),
	\detune, 1.01,
	\envDur, 0.5,
	\legato, 0.9,
	\dur, 0.125
).play;
)