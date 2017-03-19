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
