///////////////////////////////////
// October 14, 2016
// Darien Brito
// darienbrito.com
///////////////////////////////////

/*
IDEA: Lines everywhere! Some metallic attacks...
*/

(
SynthDef(\wires, { | cFreq = 18000, envDur = 1, amp = 0.2, q = 0.2, mod = 20 |
	var lmod = Line.kr(mod, 10, envDur);
	var sig = WhiteNoise.ar(1) * (SinOsc.ar([lmod, lmod + 2 ]) * Line.kr(1, 0, envDur));
	sig = RLPF.ar(sig, XLine.kr(cFreq, 20, envDur), q);
	sig = sig * EnvGen.kr(Env.perc(0.01, envDur), doneAction: 2);
	2.do{|i| sig = AllpassC.ar(sig, 0.5, Rand(0.01, 0.05), 0.5) + sig }; // random times for delay times
	sig = sig * amp;
	Out.ar(0, sig) ;
}).add;
)

Synth(\wires); // <--- try me

// Different tastes progressively..
(
var reps = 20;
Pbind(
	\instrument, \wires,
	\mod, Pseries(10, 2, inf),
	\cFreq, Pseries(1000, 500),
	\envDur, Pseries(0.1, 0.15, reps),
	\amp, 0.2,
	\dur, Pkey(\envDur) * 0.5
).play
)