///////////////////////////////////
// October 5, 2016
// Darien Brito
// darienbrito.com
///////////////////////////////////

/*
IDEA: Need some bassy stuff?
*/


(
SynthDef(\wooble, { | freq = 140, dur = 2, amp = 1, cFreq = 9000, del = 0.01, fbScale = 0.75 |
	var sig;
	var sig1 = VarSaw.ar([freq, freq + 0.11], 0, VarSaw.kr(dur * 0.25, mul: 0.5, add: 0.5)) * 0.5;
	var sig2 = Pulse.ar([freq * 0.5, (freq * 0.5) + 0.11], 0.25) * 0.5;
	var env1 = EnvGen.kr(Env([0, 1, 0], [dur * 0.75, dur * 0.25]), doneAction: 2);
	var env2 = EnvGen.kr(Env([0,1,0], [dur * 0.25, dur * 0.75]));
	sig1 = sig1 * env1;
	sig2 = sig2 * env2;
	sig = sig1 + sig2;
	sig = RLPF.ar(sig, XLine.kr(200, cFreq), LFSaw.kr(0.5).range(0.1, 0.5));
	//sig = Fb({|fb| sig + fb * fbScale}, del, del); // Add some FB if you want...
	sig = sig * amp;
	Out.ar(0, sig);
}).add
)

(
Pbindef(\player,
	\instrument, \wooble,
	\degree, Pseq([0, 2, 1, 4],inf),
	\octave, 3,
	\scale, Scale.diminished,
	\cFreq, Pfunc({|ev| (ev.degree + 1) * 400}),
	\amp, 1,
	\dur, 2
).play;
)
