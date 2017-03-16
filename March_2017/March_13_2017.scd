// kinda organ-like synth
(
SynthDef(\s, { | envDur = 1, freq = 120, mod = 0.5, cFreq = 12000, amp = 0.5, pan = 0 |
	var osc1, osc2, osc3;
	var sig;
	osc1 = SinOsc.ar(freq) * EnvGen.kr(Env.sine(envDur));
	osc2 = Saw.ar(freq * 0.5) * EnvGen.kr(Env.sine(envDur));
	osc3 = Pulse.ar(freq * 2, SinOsc.kr(mod).range(0.0, 1.0)) * EnvGen.kr(Env.sine(envDur));
	sig = Mix.ar([osc1, osc2, osc3] * 0.33);
	4.do{|i| sig = FreeVerb.ar(sig, (i+1) * 0.1, 0.3)};
	sig = SVF.ar(sig, XLine.kr(cFreq, 100, envDur), 0.1, 0.1, 0.6);
	DetectSilence.ar(sig, doneAction: 2);
	sig = Pan2.ar(sig, pan);
	Out.ar(0, sig * amp);
}).add
)

Synth(\s, [\cFreq, 20000, \envDur, 1]);

(
Pbindef(\player,
	\instrument, \s,
	\n, Pwhite(3, 10),
	\degree, Pstutter(Pkey(\n), Pwhite(-4, 11, inf)),
	\dur, Pstutter(Pkey(\n), Pwhite(0.05, 1.2, inf)),
	\envDur, 1,
	\legato, 0.1
).play;
)

(
Pbindef(\player,
	\instrument, \s,
	\envDur, Pkey(\dur),
);
)


(
Pbindef(\player,
	\instrument, \s,
	\scale, Scale.minor,
	\octave, 4
)
)

Pbindef.removeAll