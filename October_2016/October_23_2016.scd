///////////////////////////////////
// October 14, 2016
// Darien Brito
// darienbrito.com
///////////////////////////////////

/*
IDEA: Sample and hold based synth...
*/

(
SynthDef(\sandhold, { |freq = 60, rate = 5, delSpeed = 12, phaseDif = 0.2, depth = 0.01, preDelay = 0.01 |
	var nDelays = 5;
	var trig = Impulse.kr(rate);
	var sig = Saw.ar([freq, freq + 0.1], 0.5);
	var mods;
	sig = RLPF.ar(sig, Latch.kr(WhiteNoise.kr, trig).range(100, 10000), 0.05, 1);
	sig = Mix.ar(sig);
	mods = nDelays.collect{|i| LFPar.kr(delSpeed * rrand(0.9, 1.06), phaseDif * i, depth, preDelay)};
	sig = DelayC.ar(sig, 0.5, mods) * (1/nDelays);
	sig = sig.sum.atan * 0.5;
	Out.ar(0, sig ! 2);
}).add
)

Synth(\sandhold, [\freq, 80, \rate, 8, \delSpeed, 0.02, \phaseDif, 0.3, \depth, 0.25]);