///////////////////////////////////
// October 22, 2016
// Darien Brito
// darienbrito.com
///////////////////////////////////

/*
IDEA: Something with sawtooths
*/

// Declare funcs
(
~adsr = { | peak, att, dec, sus, rel, curve, tScale|
	EnvGen.kr(Env([0, peak, peak * sus, 0],
		[att, dec, rel],
		curve), timeScale: tScale)
};

~envs = {|n, tScale|
	var envs = n.collect{|i|
		~adsr.(
			peak: 1,
			att: [0.05, 0.1, 0.2].wchoose([0.25, 0.25, 0.5]),
			dec: rrand(0.1, 0.25),
			sus: 0.25,
			rel: rrand(0.2, 0.35),
			tScale: tScale
		);
	};
	envs;
};

~saws = {|n, freq = 60, fMul, modRate|
	var saws = n.collect{|i|
		var saw = VarSaw.ar(freq + (i* fMul), i*0.1, LFSaw.kr(modRate, mul: 0.5, add: 0.5)) * 1/n;
		saw = saw * 5;
		saw = saw.fold(-0.8, 0.8);
		LeakDC.ar(saw);
	};
	saws
};

~player = { |num = 10, baseFreq = 120, freqMult = 1.25, tScale = 1, modRate = 0.5, amp = 1 |
	{
		var n = num;
		var sig, free;
		free = EnvGen.kr(Env.perc(0.01, tScale) ,doneAction: 2); // Just a way to free the synth
		sig = Splay.ar(~saws.(n, baseFreq, freqMult, modRate) * ~envs.(n, tScale), 1);
		sig = sig * amp;
		Out.ar(0, sig);
	}.play;
};
)

~player.(num: 10, baseFreq: 60, freqMult: 1.25, tScale: 1, modRate: 0.5, amp: 1 );

// A hacky way to use a pbind to control our function:
(
var augmented = 8.collect{|i| i.degreeToKey(Scale.diminished) };
Pbind(
	\instrument, \default,
	\amp, 0,
	\baseFreq, Pn(Pshuf(augmented + 60), inf),
	\myPlayer, Pfunc({|ev| ~player.(num: rrand(4, 10), baseFreq: ev.baseFreq.midicps * 0.5, freqMult: rrand(0.8, 0.99), tScale: 1, modRate: rrand(0.5, 0.9), amp: 0.75 ) }),
	\dur, Pif(Pfunc({ 0.5.coin}), 0.25, 0.5),
).play
)
