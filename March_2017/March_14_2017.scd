/*_________________________

March 14

Weird noisy ambience

_________________________*/

(
Ndef(\k, { | freq = 500, wModFreq = 20, amp = 1 |
	var n = 4;
	var sig = Pulse.ar(freq, SinOsc.kr(wModFreq).range(0.1, 0.99), 1);
	n.do{|i| sig =  sig + AllpassL.ar(sig, 0.2, LFNoise1.kr((i+1) * 0.01).range(0.01, (i+1) * 0.125), 0.5) * 1/n};
	sig = Resonz.ar(sig, LFNoise1.kr(0.25).range(100, 18000), 0.2);
	sig = sig * 20;
	sig = sig.wrap(-0.9, 0.9);
	sig = sig.distort;
	sig = LeakDC.ar(sig);
	sig = sig * n;
	Pan2.ar(sig * amp, 0);
});
)

Ndef(\k).play;