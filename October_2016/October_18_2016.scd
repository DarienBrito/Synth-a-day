///////////////////////////////////
// October 18, 2016
// Darien Brito
// darienbrito.com
///////////////////////////////////

/*
IDEA: A silly resonator? (be careful with the amplitude)
*/

(
SynthDef(\crackyResonator, { | freq = 80, step = 30, pan = 0, rel = 1 |
	var n = 8;
	var freqs = Array.series(n, freq, step);
	var amps = 0.1;
	var ringTimes = Array.rand(n, 0.1, 1);
	var specs = `[freqs * LFNoise2.ar(0.06).range(0.5,2), amps, ringTimes];
	var sig = DynKlank.ar(specs, Crackle.ar(1.2,1), 1, 0, 1);
	sig = LPF.ar(sig, 10000);
	sig = sig * EnvGen.kr(Env.perc(0.01, rel), doneAction: 2);
	Out.ar(0, Pan2.ar(sig * 0.1, pan));
}).add
)
Synth(\crackyResonator,[\freq, 100, \step, 40]);

(
Pbind(
	\instrument, \crackyResonator,
	\freq, 100,
	\step, Pwhite(100, 1000),
	\rel, Pn(Pstutter(Pseq([2,3,1,4],1), Pseq([0.25, 0.5, 1],1)),inf),
	\dur, 0.25
).play;
)

s.quit