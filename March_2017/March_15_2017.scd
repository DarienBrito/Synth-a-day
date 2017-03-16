/*_________________________

March 15

A rolling percussive sound using a physical modelling UGen

_________________________*/

(
SynthDef(\m15, { | rel = 0.9, tension = 0.05, loss = 0.99, amp = 0.5, fbAmp = 0.99 |
	var trig =( WhiteNoise.ar(1) * LFPulse.kr(Line.kr(25, 2, rel))) * EnvGen.kr(Env.perc(releaseTime: rel), doneAction: 2);
	var sigA = MembraneCircle.ar(trig, XLine.kr(0.5, 0.1, rel), Line.kr(0.8, 0.9999, rel));
	var envFollow = Amplitude.ar(sigA);
	var sigB = SinOsc.ar(80, envFollow * 200.0, envFollow); //Phase modulation with amplitude form membrane
	var sig = sigA + sigB;
	Out.ar(0, (sig ! 2) * amp);
}).add
)

// Try me:
Synth(\m15);