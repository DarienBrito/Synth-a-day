///////////////////////////////////
// October 2, 2016
// Darien Brito
// darienbrito.com
///////////////////////////////////

/*
IDEA: Make a double sawtooth synth with comb-filtering
*/

(
SynthDef(\sawer,{ | freq = 440, cFreq = 2000, del = 0.02, dec = 0.1, filDur = 0.2, envDur = 1, amp = 0.5|
	var difs = [-0.03, 0, 0.03];
	var oscs = 2.collect{|i| Saw.ar( [(freq - difs[i]), (freq + 0.1) - difs[i] ] + SinOsc.ar(3, 0, 1), 0.5) };
	var sig = LPF.ar(oscs, XLine.ar(cFreq, 100, filDur, doneAction: 0));
	sig = sig * EnvGen.ar(Env.sine(envDur, 1), doneAction: 2);
	2.do{|i| sig = sig + CombL.ar(sig, 0.2, del, dec)};
	sig = sig;
	sig = sig.fold(-0.9, 0.9);
	LeakDC.ar(sig);
	Out.ar(0, sig * amp);
}).add
)

// test it
Synth(\sawer, [\freq, 60.midicps, \cFreq, 7000, \envDur, 1]);

// Sequence it
(
Pbind(
	\instrument, \sawer,
	\scale, Scale.augmented,
	\degree, Pn(Pshuf((0..8), 1), inf),
	\cFreq, Pfunc({|f| (f.degree * 1000) + 500 }), // Higher cFreq if freq is higher
	\octave, Pstutter(Pseq([3, 2, 3],inf), Pseq([3, 2, 4],inf)),
	\filDur, 0.2,
	\dec, 0.1,
	\envDur, 1,
	\dur, 0.5,
	\amp, 1
).play
)

// Two in parallel with a triplet delay sounds great:
(
x = Pbind(
	\instrument, \sawer,
	\scale, Scale.augmented,
	\degree, Pn(Pshuf((0..8), 1), inf),
	\cFreq, Pfunc({|f| (f.degree * 1000) + 500 }), // Higher cFreq if freq is higher
	\octave, Pstutter(Pseq([3, 2, 3],inf), Pseq([3, 2, 4],inf)),
	\filDur, 0.25,
	\dec, 0.1,
	\envDur, 1,
	\dur, 0.5,
	\amp, 0.3,
);

Tdef(\delayed, {
	x.play;
	0.3.wait;
	x.play;
}).play;
)

s.quit

///////////////////////////////////
// October 3, 2016
// Darien Brito
// darienbrito.com
///////////////////////////////////

/*
IDEA: Make a textural synth? I have no clue of what to do today... let's see what happens...
*/

(
Ndef(\groma).play;
Ndef(\groma).fadeTime = 5;
Ndef(\groma, {|amp = 0.1, freq = 10, fbScale = 0.4, fbDel = 0.1|
	var num = 4;
	var sig = Pulse.ar([freq, freq + 0.01], LFSaw.kr(0.01).range(0.0, 0.5)).cos;
	//Resonator stuff
	var rmods = num.collect{|i| VarSaw.ar((i+1) * 2, i + 1 * (1/num)).range(800 * (i + 1))};
	var amps = num.collect{ rrand( 0.0, 0.01 )};
	sig = sig.distort(0.75);
	sig = sig * 20; //Overblow it
	sig = sig.fold(LFNoise0.kr(freq).range(0.1, 0.4)); //Some random waveshaping
	sig = Fb({|fb| fb * fbScale + sig}, 1.0, fbDel);
	sig = DynKlank.ar(`[rmods, nil, amps],sig);
	sig = Resonz.ar(sig, Demand.kr(Impulse.kr(freq), 0, Dwhite(20, 12000)), 0.5);
	sig = LeakDC.ar(sig * 0.01);
	sig = Compander.ar(sig, sig,
        thresh: 0.5,
        slopeBelow: 1,
        slopeAbove: 0.5,
        clampTime: 0.01,
        relaxTime: 0.01);
	sig = Limiter.ar(sig, 0.9);
	sig;
});
)

// Kinda makes me picture minced marbles...
(
Tdef(\test, {
	Ndef(\groma).xset(\freq, 4);
	7.yield;
	Ndef(\groma).xset(\freq, 10);
	7.wait;
	Ndef(\groma).xset(\freq, 60);
	7.wait;
	Ndef(\groma).xset(\freq, 1000);
}).play
)