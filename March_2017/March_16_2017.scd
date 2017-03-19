AudioRouter(output: "Saffire");

/*_________________________

March 16

A modulating FM synth
with ever changing envelopes

_________________________*/

(
SynthDef(\m16, { | freq = 120, envDur = 2, amp = 1, harm = 2, index = 5|
	var maxBreakpoints = 8;
	var sig, a, b, c;
	// Declare properties
	var freqA = freq;
	var freqB = freq * 0.5;
	var freqC = freq * 2.0;
	var mod1 = freqA * harm;
	var mod2 = freqB * harm;
	var mod3 = freqC * harm;
	// Declare modulators
	var trig = Impulse.ar(120);
	var sampleAndHold = Latch.kr(WhiteNoise.kr(1).range(0.0, 1.0), trig);
	var envA = EnvGen.kr(Env(\env1V.kr(Array.fill(maxBreakpoints, 0.0)), \env1T.kr(Array.fill(maxBreakpoints - 1, 0.0))));
	var envB = EnvGen.kr(Env(\env2V.kr(Array.fill(maxBreakpoints, 0.0)), \env2T.kr(Array.fill(maxBreakpoints - 1, 0.0))));
	var envC = EnvGen.kr(Env(\env3V.kr(Array.fill(maxBreakpoints, 0.0)), \env3T.kr(Array.fill(maxBreakpoints - 1, 0.0))));
	var modOsc1 = Pulse.ar(mod1, 0.1);
	var modOsc2 = VarSaw.ar(mod2, 0.1, sampleAndHold);
	var modOsc3 = Pulse.ar(mod2, sampleAndHold); // This provides the granular aspect
	// FM modulated frequencies
	var finalFreqA = freqA + (modOsc1 * (mod1*index));
	var finalFreqB = freqB + (modOsc2 * (mod2*index));
	var finalFreqC = freqC + (modOsc3 * (mod3*index));
	// Apply to sine oscillators
	a = SinOsc.ar(finalFreqA) * envA;
	b = SinOsc.ar(finalFreqB) * envB;
	c = SinOsc.ar(finalFreqC) * envC;
	// Mix the signals
	sig = Mix.ar([a,b,c] * 0.33);
	sig = sig * EnvGen.kr(Env.perc(0, envDur), doneAction: 2);
	// we use cAmp to modulate delay times
	//sig = sig + Fb({|fb| (fb * fbA) + sig }, cAmp * 0.1, cAmp * 0.1);
	Out.ar(0, (sig ! 2) * amp);
}).add;

// Times and vals generators
~valGen = { | n |
	if(n > 2) {
		var peak = 1;
		var actual = n - 3;
		// Beta distribution
		var distribution = Pbeta(0, 1.0, 0.3, 0.7, inf).asStream;
		var vals = actual.collect{|i| distribution.next };
		[0, peak] ++ vals ++ [0]; //Start on 0, go to peak, end in 0
	} {
		"Minimum input mus be of 3 numbers unless quantum entanglement is implemented in SC!".postln;
	}
};

~timeGen = { | n, t |
	var actual = n - 1;
	// Beta distribution
	var distribution = Pwhite(0.1, 1.0).asStream;
	var times = actual.collect{|i| distribution.next };
	(t * times.normalizeSum); // Normalize so multiplying results in input t
};
)

// test
(
var vals = 3.collect{ ~valGen.(8) };
var times = 3.collect{ ~timeGen.(4, 9) };
Synth(\m16, [\env1V, vals[0], \env1T, times[0], \env2V, vals[1], \env2T, times[1], \env3V, vals[2], \env3T, times[2], \envDur, 0.5, \amp, 1, \index, 5, \harm, 3, \freq, 120]);
)

// In a pattern
(
Pbindef(\tester,
	\instrument, \m16,
	\n, Pwhite(2, 4),
	\degree, Pstutter(Pkey(\n), Pwhite(-7, 2)),
	\scale, Pstutter(Pseq([6, 8],inf), Pseq([Scale.minor, Scale.diminished],inf)),
	\octave, Pseq([7, 4, 4, 8], inf),
	\amp, Pfunc({|ev| ev[\octave].reciprocal * 0.5 }),
	\breakPoints, 5,
	\envDur, 3,
	\index, Pseq([1, 2, 3, 5], inf),
	\harm, Pseq([4, 2, 3, 1], inf),
	\env1V, Pfunc({|ev| ~valGen.(ev[\breakPoints]) }),
	\env2V, Pfunc({|ev| ~valGen.(ev[\breakPoints]) }),
	\env3V, Pfunc({|ev| ~valGen.(ev[\breakPoints]) }),
	\env1T, Pfunc({|ev| ~timeGen.(ev[\breakPoints], ev[\envDur]) }),
	\env2T, Pfunc({|ev| ~timeGen.(ev[\breakPoints], ev[\envDur]) }),
	\env3T, Pfunc({|ev| ~timeGen.(ev[\breakPoints], ev[\envDur]) }),
	\dur, Pstutter(Pkey(\n), Pwhite(1, 2) * 0.25)
).play;
)

