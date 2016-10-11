///////////////////////////////////
// October 10, 2016
// Darien Brito
// darienbrito.com
///////////////////////////////////

/*
IDEA: Make a number of oscillators, each with its own filter
*/

(
SynthDef(\bunchaImpulses, { | freq = 60, amp = 0.1, rate = 40, rateMult = 2, freqMult = 2, fbScale = 0.75, del = 0.1 |
	var n = 4;
	var formletFunc = { |rate, cFreq|
		var out = Formlet.ar(Impulse.ar(rate), cFreq, 0.01, 0.1);
		out = Fb({|fb| fb * fbScale + out }, 0.5, del); // A tiny bit of depth
		out;
	};
	var sig = n.collect{|i|
		var r = rate + (i* rateMult);
		var c = freq + (i* freqMult);
		formletFunc.(r,c)
	};
	sig = Splay.ar(sig);
	sig = sig * amp;
	Out.ar(0, sig);
}).add
)

// Play with these later...
(
Synth(\bunchaImpulses,[\rate, 2, \freq, 500, \rateMult, 0.1, \freqMult, 100,\fbScale, 0.25, \del, 0.09]);
Synth(\bunchaImpulses,[\rate, 2, \freq, 1000, \rateMult, 0.1, \freqMult, 100,\fbScale, 0.25, \del, 0.09]);
)