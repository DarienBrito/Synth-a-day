///////////////////////////////////
// October 19, 2016
// Darien Brito
// darienbrito.com
///////////////////////////////////

/*
IDEA: Rework of day 17, variable envelopes for modulations
I have made a custom function to get an asr type envelope because
the one provided by SC behaves strangely... so.
*/

(
SynthDef(\alg1, {
	| op1Freq = 100, op2Freq = 200, op3Freq = 1, op4Freq = 20, op1Index = 1, op2Index = 4, op3Index = 10, op4Index = 2, pan = 0, amp = 0 rel = 1, pos = 0, out = 0 |
	var env1, env2, env3, env4, envCtrl1, envCtrl2, envCtrl3, envCtrl4, op1, op2,op3,op4;
	// Env 4
	envCtrl4 = \env4.kr(Env([0, 1, 1,0], [0.5, 0.1, 0.5]).asArray);
	env4 = EnvGen.kr(envCtrl4, levelScale: op4Index, doneAction: 0);
	op4 =  SinOsc.ar(op4Freq, 0, 1) * env4;
	// Env 3
	envCtrl3 = \env3.kr(Env([0, 1, 1,0], [0.5, 0.1, 0.5]).asArray);
	env3 = EnvGen.kr(envCtrl3, levelScale: op3Index, doneAction: 0);
	op3 =  SinOsc.ar(op3Freq, op4, 1) * env3;
	// Env 2
	envCtrl2 = \env2.kr(Env([0, 1, 1,0], [0.5, 0.1, 0.5]).asArray);
	env2 = EnvGen.kr(envCtrl2, levelScale: op2Index, doneAction: 0);
	op2 =  SinOsc.ar(op2Freq, op3, 1) * env2;
	// Env 1
	envCtrl1 = \env1.kr(Env([0, 1, 1,0], [0.5, 0.1, 0.5]).asArray);
	env1 = EnvGen.kr(envCtrl1, levelScale: op1Index, doneAction: 0);
	op1 =  SinOsc.ar(op1Freq, op2, 1) * env1;
	// Out:
	Out.ar(0, Pan2.ar(op1, pos));
}).add;
)

(
Synth(\alg1,[
	\op1Freq, 60,
	\env1, Env([0,1,1,0],[0.1,  1, 3]),\op1Index, 1,
	\env2, Env([0,1,1,0],[0.1, 1, 0.1]),\op2Index, 2,
	\env3, Env([0,1,1,0],[0.1, 1, 0.1]),\op3Index, 3,
	\env4, Env([0,1,1,0],[0.1, 0.1, 2]),\op4Index, 1
])
)
