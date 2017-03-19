///////////////////////////////////
// October 14, 2016
// Darien Brito
// darienbrito.com
///////////////////////////////////

/*
IDEA: Nice and easy granulator
*/

(
SynthDef(\sineGranules, { | grainDur = 0.01, freq = 1000, rate = 10, pRatio = 1, pDist = 1, tDisp = 2 |
	var n = 12;
	var trig = Impulse.kr(rate);
	var sig = SinGrain.ar(trig, Demand.kr(trig, 0, Dwhite(0.001, 0.01)), freq);
	sig = PitchShift.ar(sig, 0.1, pRatio, pDist, tDisp);
	sig = Pan2.ar(sig, Demand.kr(trig, 0, Dwhite(-1, 1)));
	sig = Resonz.ar(sig, Demand.kr(trig, 0, Dwhite(200, 18000)), 1);
//	4.do{|i| sig = sig + DelayL.ar(sig, 0.2, MouseX.kr(0.01, 0.1)); }; // Add some delay if wanted
	sig = Out.ar(0, sig);
}).add;
)

Synth(\sineGranules);
