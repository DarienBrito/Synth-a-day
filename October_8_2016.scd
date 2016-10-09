///////////////////////////////////
// October 8, 2016
// Darien Brito
// darienbrito.com
///////////////////////////////////

/*
IDEA: A nice and easy additive synthesis thingy
*/

(
~env = {|n, dur|
	var out = n.collect{|i| EnvGen.kr(Env.perc(0.01, rrand(dur - 0.5, dur)),doneAction:2)};
	out
};

~osc = {|n|
	var sig = n.collect{|i|
		var freq = Scale.minor.degrees.choose + (12 * (0..12).choose);
		SinOsc.ar(freq.midicps)
	};
	sig
};
)

(
a = {
	var n = 4;
	var vol = 0.6;
	var envs = ~env.value(n, 1);
	var sigs = ~osc.value(n);
	var out = sigs.collect{|sig, i| var fin = sig * envs[i]; fin * 1/n};
	out = Splay.ar(out);
	Out.ar(0,out * vol)
};

// sequence:
r = Routine({
	inf.do{
		var step = [1/2,1/4,1/8].wchoose([0.1,0.5,2].normalizeSum);
		step.postln;
		a.play;
		step.wait;
	}
}).play
)