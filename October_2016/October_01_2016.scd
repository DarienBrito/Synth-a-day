///////////////////////////////////
// October 1, 2016
// Darien Brito
// darienbrito.com
///////////////////////////////////

/*
IDEA: Make a simple PM synth with various oscillators spread across the stereo field,
with a dynamic amount of oscillators (No SynthDef solution for that one)
*/

(
var oscs, modEnvs;
~makeModEnvs = {|n, dur|
	var att, dec, sus, rel, envs;
	envs = n.collect{|i|
		EnvGen.kr(Env.perc(0.01, dur), levelScale: rrand(40, 200),doneAction: 2);
	};
	envs
};

~makeOscs = {|n, baseFreq = 200, modEnvs, dur|
	var freqs, oscs;
	freqs = n.collect{|i| baseFreq * (i + 1) };
	oscs = n.collect{|i| PMOsc.ar(freqs[i], modEnvs[i], 1, mul: 1/n) * EnvGen.kr(Env.perc(0.01, dur))};
	oscs;
};

~player = {	|n = 10, baseFreq = 60, duration = 3|
	{
		var sig;
		modEnvs = ~makeModEnvs.(n, duration);
		oscs = ~makeOscs.(n, baseFreq, modEnvs, duration);
		sig = Resonz.ar(oscs, Line.ar(20, 10000, duration), 0.1);
		DetectSilence.ar(sig, doneAction:2);
		Out.ar(0, Splay.ar(sig));
	}.play;
}
)

// Test it
~player.(n: 2, baseFreq: rrand(60, 1120), duration: 3)

// Automate it:
(
TempoClock(127/60);
Tdef(\player, {
	var seq = [72, 67, 68, 65, 67, 63, 65, 62];
	var times = [1, 1, 3, 1, 3, 1, 1, 1];
	inf.do{|i|
		// The rand is for changing the amount of oscillators per run
		~player.(rrand(5, 10), seq[i % seq.size].midicps, 3);
		times[i % times.size].wait;
	}
}).play;
)

// Hook to MIDI
(
MIDIClient.init;
MIDIIn.connectAll;
MIDIFunc.noteOn({arg ...args;
	var freq = args[1].midicps.postln;
	~player.(rrand(5, 10), freq, 3)
});
)