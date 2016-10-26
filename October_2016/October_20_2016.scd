///////////////////////////////////
// October 20, 2016
// Darien Brito
// darienbrito.com
///////////////////////////////////

/*
IDEA: Expanding FM with decay envelopes
*/
(
SynthDef(\alg1, {
	| op1Freq = 100, op2Freq = 200, op3Freq = 1, op4Freq = 20, op1Index = 1, op2Index = 4, op3Index = 10, op4Index = 2, pan = 0, amp = 1, rel = 1, pos = 0, out = 0 |
	var trig = Impulse.kr(0.1);
	var sig = SinOsc.ar(op1Freq,
		phase: SinOsc.ar(op2Freq,
			phase:SinOsc.ar(op3Freq,
				phase:SinOsc.ar(op4Freq, 0, mul: Decay.kr(trig, 1, op4Index)),
				mul: Decay.kr(trig, 1, op3Index)),
			mul: Decay.kr(trig, 1, op2Index)),
		mul: op1Index);
	sig = sig * EnvGen.kr(Env.perc(0.01, rel), doneAction: 2);
	sig = sig * amp;
	Out.ar(0, Pan2.ar(sig, pos));
}).add;)

(
Pbindef(\fm,
	\instrument, \alg1,
	\op1Freq, Pseq([60, 68, 62],inf).midicps,
	\op2Freq, 30,
	\op2Index, Pseq([100, 40, 20], inf),
	\op3Index, Pseq([1,2,3],inf),
	\rel, 1.25,
	\dur, Pn(Pstutter(Pseq([4, 2, 3]), Pseq([0.125, 0.25, 0.125, 0.25])), inf)
).quant_(1);
)

(
Tdef(\colors, {
	var vars = 	[Pseq([100, 40, 20], inf), Pseq([2, 4, 8], inf)];
	Pbindef(\fm).play;
	inf.do{|i|
		8.wait;
		Pbindef(\fm, \op4Index, Pseq([100, 30, 50],inf));
		8.wait;
		Pbindef(\fm, \op4Index, Pseq([0.5, 2, 0.1],inf));
		8.wait;
		Pbindef(\fm, \op2Index, vars[i%2]);
		8.wait;
	}
}).play;
)

Pbindef.clear