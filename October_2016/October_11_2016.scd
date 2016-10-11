///////////////////////////////////
// October 11, 2016
// Darien Brito
// darienbrito.com
///////////////////////////////////

/*
IDEA: Make a synth using a sine wave as source and waveshaphing
*/

(
SynthDef(\shapedSine, { |freq = 60, t = 0.9, amp = 0.6, cRate = 0.5, trate = 10 |
	var f = Lag.kr([freq, freq + 0.1], 10);
	var sig = SinOsc.ar(f) * 10;
	var m = VarSaw.kr(trate);
	var mods = [VarSaw.ar(0.1).range(t * -1, 0.1), VarSaw.ar(0.1).range(0.1, t)];
	var ops = [
		sig.fold(mods[0], mods[1]),
		sig.wrap(mods[0], mods[1]),
		sig.clip(mods[0], mods[1]),
		sig.sin(mods[0], mods[1]),
	];
	var indexes = ops.size * 0.5;
	sig = SelectX.ar(VarSaw.kr(cRate, 0,  0.5, indexes, indexes), ops);
	sig = LeakDC.ar(sig, 0.99);
	sig = SVF.ar(sig, VarSaw.kr(0.25).range(400, 1000), 0.01, 0.2, 0.5, 0.2);
	sig = GVerb.ar(sig, 50, 5, 0.1, 0.5, 10, 0.1, 0.1 ,0.1);
	Out.ar(0, sig * amp);
}).add
)

(
x = Synth(\shapedSine, [\cRate, 0.1, \t, 0.9, \freq, 60]);
{
	inf.do {
		var newVal = rrand(5, 50);
		x.set(\freq, newVal);
		"Moving to: %hz".format(newVal).postln;
		11.wait;
	}
}.fork;
)