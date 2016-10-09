///////////////////////////////////
// October 4, 2016
// Darien Brito
// darienbrito.com
///////////////////////////////////

/*
IDEA: Kinda feel like an ambiency vibe...
*/

(
SynthDef(\flugger, { |freq = 100, modRatio = 0.5, ind = 1, maindur = 4 ring = 200, cFreq = 12000, amp = 1 |
	var comb;
	var n = 4;
	var delTimes = n.collect{|i| (i+1)* 0.1};
	var decTimes = n.collect{|i| 0.025};
	var sig = PMOsc.ar(freq, freq * modRatio, ind) * 0.75;
	var env = EnvGen.kr(Env([0, 1, 0.4, 0], [maindur * 0.25, maindur * 0.5, maindur * 0.25]), doneAction: 0);
	sig = sig * SinOsc.ar(ring);
	n.do{|i| comb = CombL.ar(sig, 0.2,  XLine.kr(0.01 * (i+1), 0.0001, maindur), decTimes[i]) };
	sig = (sig + comb) * env;
	sig = GVerb.ar(sig , 100, 5, 0.5, 0.6, 15, 0.7, 0.3, 0.1, 330);
	sig = Resonz.ar(sig, Line.kr(100, cFreq, maindur + 1), 0.2);
	sig = sig * amp;
	DetectSilence.ar(sig,  doneAction: 2);
	Out.ar(0, sig);
}).add
)

// Test if you may
Synth(\flugger, [\freq, 1000, \modRatio, 0.15, \ind, 5, \ring, 50, \maindur, 8, \amp, 0.5]);

// Silly sequence
(
Pbind(
	\instrument, \flugger,
	\scale, Scale.minor,
	\degree, Pseq([1, 3, 5, 1] - 1, 1),
	\octave, Pseq([4, 4, 4, [4,3,2,1]],1),
	\modRatio, 4,
	\ind, 2,
	\ring, 1200,
	\amp, 0.5,
	\maindur, Pseq( ({5}!3) ++ 10, 1),
	\dur, 4
).play;)



