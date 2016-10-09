///////////////////////////////////
// October 9, 2016
// Darien Brito
// darienbrito.com
///////////////////////////////////

/*
IDEA: Just an FM synth
*/

// Envs for mod and amplitude are interconnected
(
SynthDef(\squareFM, { |freq = 100, modFreq = 20, index = 3, peak = 1, att = 0.1, dec = 0.5, sus = 0.2, rel = 0.2, harmo = 4, amp = 0.5, pos = 0 |
	var sig;
	var mod = SinOsc.ar(modFreq * harmo) * EnvGen.kr(Env([0.001, peak, peak * sus, 0.001], [att, dec, rel], -4));
	var hi = SinOsc.ar(freq + (mod * modFreq * index), VarSaw.kr(20).range(0.1, 0.5));
	var spice = Pulse.ar(freq * 0.5 + (mod * modFreq * index), 0.5);
	var env = EnvGen.kr(Env.adsr(att, dec, sus, rel), doneAction: 2);
	hi = hi * env * 0.5;
	spice = Resonz.ar(spice, XLine.ar(60, 4000, LFSaw.kr(0.01).range(0.5, 0.99)), 0.1) * 2; // A subtle extra spice in the mid-field
	spice = spice * env * 0.5;
	sig = Pan2.ar(hi + spice, pos);
	Out.ar(0, sig * amp);
}).add
)

(
Pbindef(\player,
	\instrument, \squareFM,
	\degree, Pseq([ Pseries(0, 2, 7), Pseries(14, -2, 7) - 1 ],inf),
	\scale, Pseq([ Pseq({Scale.augmented} ! 28, 1), Pseq({Scale.diminished} ! 28, 1)],inf),
	\modFreq, Pfunc({ (10, 11..30).choose }).trace,
	\octave, 6,
	\att, 0.01,
	\dec, 0.4,
	\sus, 0.2,
	\rel, 3,
	\pos, Pbeta(-1,1,0.5,0.5),
	\harmo, 5,
	\index, 3,
	\amp, 0.5,
	\dur, 0.5,
).play;
)
