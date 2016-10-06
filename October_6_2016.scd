///////////////////////////////////
// October 6, 2016
// Darien Brito
// darienbrito.com
///////////////////////////////////

/*
IDEA: Let's use a fair amount of feedback... beware of high frequencies!
*/

(
Ndef(\alx).play;
Ndef(\alx).fadeTime = 5;
Ndef(\alx, { | fbScale = 0.9, fbRate = 0.01, masterCfreq = 18000 |
	var freq = Lag.kr(TRand.kr(80, 300, Impulse.kr(0.1)), 2, 1);
	var a = WhiteNoise.ar(1) * 0.2;
	var b = Pulse.ar([freq, freq + 0.1]) * 0.1;
	var c = VarSaw.ar([freq * 2, freq * 2 + 0.1]) * 0.1;
	var filterProcess = { | input, fRate = 20, ringRate = 0.1, ring = 20, from = 200, to = 800 |
		var out = RLPF.ar(input, VarSaw.kr(fRate).range(from, to), LFSaw.kr(ringRate).range(0.01, 0.2));
		out = SinOsc.ar(ring) * out;
		out;
	};
	var siga = Pan2.ar(filterProcess.(a, fRate: 0.01, ringRate: 20, ring: 30, from: 60, to: 800) , LFNoise2.kr(0.01).range(-1, 1));
	var sigb = Fb({ |fb| fb * fbScale + filterProcess.(b, fRate: 0.1, ringRate: 1, ring: 400, from: 200, to: 12000)},
		maxdelaytime:0.2, delaytime:LFNoise2.kr(fbRate).range(0.01, 0.2));
	var sigc = Fb({|fb| fb * fbScale + filterProcess.(c, fRate: 0.11, ringRate: 2, ring: 400, from: 200, to: 12000) },
		maxdelaytime:0.2, delaytime:LFNoise2.kr(fbRate).range(0.01, 0.2));
	var sig = siga + sigb + sigc;
	sig = sig.sin(-0.9, 0.9);
	sig = LPF.ar(sig, masterCfreq);
	sig = Limiter.ar(sig);

}))



