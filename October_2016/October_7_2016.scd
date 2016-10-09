///////////////////////////////////
// October 7, 2016
// Darien Brito
// darienbrito.com
///////////////////////////////////

/*
IDEA: Some silly bubbly thing

NOTE: .adsr behaved strangely in my SC version (3.7.0). I had to comment a line from the source of Env.sc to "fix it":

	*adsr { arg attackTime=0.01, decayTime=0.3,
			sustainLevel=0.5, releaseTime=1.0,
				peakLevel=1.0, curve = -4.0, bias = 0.0;
		^this.new(
			[0, peakLevel, peakLevel * sustainLevel, 0] + bias,
			[attackTime, decayTime, releaseTime],
			curve//,
			//2 //<---------------------------------------------- SEE HERE?
		)
	}

*/

(
SynthDef(\transients, { | freq = 120, freqMult = 3, cFreqMul = 4, noiseQ = 0.1, sawQ = 0.2|
	var filtering = { |sig, att, dec, sus, rel, q, cFreq = 400|
		var out = Resonz.ar(sig, EnvGen.kr(Env.adsr(att, dec, sus, rel),levelScale: cFreq, doneAction: 0), q);
		out;
	};
	var enveloping = {|sig, att, dec, sus, rel, envDur|
		var out = sig * EnvGen.kr(Env.adsr(att, dec, sus, rel), doneAction: 0);
		out;
	};
	var osc1 = WhiteNoise.ar(1);
	var osc3 = Saw.ar(freq);
	var sig;
	//Osc1
	osc1 = filtering.(osc1, att:0.01, dec:0.5, sus:0.2, rel:0.29, q: noiseQ, cFreq: freq * cFreqMul); // Filter
	osc1 = enveloping.(osc1, att:0.01, dec:0.2, sus:0.5, rel:0.29) * 0.5; // Amplitude
	//Osc3
	osc3 = filtering.(osc3, att:0.3, dec:0.01, sus: 0.01, rel: 0.2, q: sawQ, cFreq: freq * cFreqMul) * 0.5;
	sig = Mix.ar([osc1, osc3]);
	//Osc3
	DetectSilence.ar(sig, doneAction: 2);
	Out.ar(0, sig ! 2);
}).add;
)

Synth(\transients,[\freq, 80, \cFreqMul, 40]);

(
var tempo = 110;
Pbind(
	\instrument, \transients,
	\degree, Pn(Pshuf((0..7),1),inf),
	\noiseQ, Pwhite(0.01, 0.1),
	\sawQ, Pwhite(0.01, 0.2),
	\freqMult, Pbeta(30, 40, 0.7, 0.3),
	\cFreqMul, Pbeta(2, 30, 0.2, 0.8),
	\octave, Pseq([2,3,4],inf),
	\stretch, 60/tempo,
	\dur, Pseq([0.25, 0.5, 0.25, 0.5],inf)
).play;
)