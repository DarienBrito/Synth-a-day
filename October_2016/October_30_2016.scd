///////////////////////////////////
// October 30, 2016
// Darien Brito
// darienbrito.com
///////////////////////////////////

/*
Idea: Expanding on a proof of concept inspired by an article by Inconvergent:
"http://inconvergent.net/shepherding-random-numbers/"
We are creating a generative additive synth based on co-dependencies of randomness

For this you will need my class: "MyNode.sc"
"https://github.com/DarienBrito/Synth-a-day/blob/master/Resources/MyNode.sc"
*/

// ----------------------------------------------------
// Nodes with random velocity in the y Axis (amplitude)
// ----------------------------------------------------

(
~baseFreq = 50;
~nodes = 40.collect{|i| MyNode((i+1) * ~baseFreq) };

SynthDef(\test, { | freq = 400, amp = 0.5 |
	var sig = SinOsc.ar(freq);
	sig = Limiter.ar(sig * amp);
	sig = sig * AmpComp.kr(freq, ~baseFreq); // Basic psychoacoustic amplitude compensation.
	Out.ar(0, sig * (1/~nodes.size));
}).add;


Tdef(\loop,{
	var synths = 20.collect{ Synth(\test) };
	inf.do{
		~nodes.do{|node, i|
			node.applyForce(Point(0, rrand(-0.01, 0.01)));
			node.updateFunc();
			node.checkLimits();
			node.sonify(synths[i]);
			//node.debug(false, false);
		};
		(1/24).wait; // At visual framerate
	}
}).quant_(0).play;

// Listen, and observe it in the spectral monitor
FreqScope.new(1000, 200, 0, server: s);
)


// ----------------------------------------------------------------------
// Nodes with random velocity in the x and y axis (frequency, amplitude)
// ----------------------------------------------------------------------

(
~nodes = 40.collect{|i| MyNode((i+1) * 50) };

SynthDef(\test, { | freq = 400, amp = 0.5 |
	var sig = SinOsc.ar(freq);
	sig = Limiter.ar(sig * amp);
	Out.ar(0, sig * (1/~nodes.size));
}).add;


Tdef(\loop,{
	var synths = 20.collect{ Synth(\test) };
	inf.do{
		~nodes.do{|node, i|
			node.applyForce(Point(rrand(-1, 1), rrand(-0.01, 0.01)));
			node.updateFunc();
			node.checkLimits();
			node.sonify(synths[i]);
			//node.debug(false, false);
		};
		(1/24).wait; // At visual framerate
	}
}).quant_(0).play;

// Listen, and observe it in the spectral monitor
FreqScope.new(1000, 200, 0, server: s);
)


// ----------------------------------------------------------------------
// Nodes with random velocity in the x and y axis (frequency, amplitude)
// ----------------------------------------------------------------------
s.options.memSize = 2 ** 14;

(
var n = 100;
var samplingScale = 0.5;
var applianceScale = 0.25;
var computeSpecialForce;
~nodes = n.collect{|i| MyNode((i+1) * 50); };
~specialForce = Point(0,0);


SynthDef(\test, { | freq = 400, amp = 0.5 |
	var sig = SinOsc.ar(freq);
	sig = Limiter.ar(sig * amp);
	Out.ar(0, sig * (1/~nodes.size));
}).add;

computeSpecialForce = { | object, samplingScale, applianceScale  |
	(object.size * samplingScale).do{|i|
		~specialForce = ~specialForce + object[i].getVelocity();
	};

	(object.size * applianceScale).do{|i|
		object[i].applyForce(~specialForce);
	};
};

Tdef(\loop,{
	var synths = (~nodes.size).collect{ Synth(\test) };
	inf.do{
		~nodes.do{|node, i|
			node.applyForce( Point(0, rrand(-0.01, 0.01) ));
			node.updateFunc();
			node.checkLimits();
			node.sonify(synths[i]);
			//node.debug(true);
		};
		computeSpecialForce.(~nodes, samplingScale, applianceScale);
		(1/24).wait; // At visual framerate
	}
}).quant_(0).play;

// Listen, and observe it in the spectral monitor
FreqScope.new(1000, 200, 0, server: s);
)

