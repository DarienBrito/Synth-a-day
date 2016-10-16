///////////////////////////////////
// October 14, 2016
// Darien Brito
// darienbrito.com
///////////////////////////////////

/*
IDEA: A resonant body with white noise
*/

(
SynthDef(\resona, { | envDur = 4, fbScale = 0.99, amp = 0.5, cFreq = 1000, start = -1, end = 1 |
	var iter = 5;
	var sig = WhiteNoise.ar(1) * EnvGen.kr(Env([0,1,0], [envDur/2, envDur/2]));
	iter.do{ sig = AllpassC.ar(sig, 0.5, Rand(0.01, 0.05), 0.5) + sig }; // random times for delay times
	iter.do{ sig = (sig.distort + sig) * 0.55 };
	sig = Fb({|fb| ((fb * fbScale) + sig) * 0.5 }, 0.01);
	sig = BPeakEQ.ar(sig, 120, 0.5, 24, 1); //Bost low end
	sig = sig * amp;
	sig = LPF.ar(sig, cFreq);
	sig = Pan2.ar(sig, Line.kr(start, end, envDur));
	DetectSilence.ar(sig, doneAction: 2);
	Out.ar(0, sig)
}).add
)


(
Pbind(
	\instrument, \resona,
	\envDur, 10,
	\fbScale, Pwhite(0.75, 0.99),
	\cFreq, 6000,
	\start, Pwhite(-1, 1),
	\end, Pwhite(-1, 1),
	\amp, 0.5,
	\dur, 5,
).play
)