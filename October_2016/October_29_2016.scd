///////////////////////////////////
// October 29, 2016
// Darien Brito
// darienbrito.com
///////////////////////////////////

// Idea: A proof of concept with a single particle inspired by an article by Inconvergent:
// "http://inconvergent.net/shepherding-random-numbers/"
// I will try to expand this idea in coming days to have a generative additive synth...

// Simple Synth;
(
SynthDef(\test, { | freq = 400, amp = 0.5 |
	var sig = SinOsc.ar(freq);
	sig = Limiter.ar(sig * amp);
	Out.ar(0, sig);
}).add;
)

// Create functions
(
n = ();
n.location = Point(0, 0.1); // freq, amp
n.velocity = Point(0, 0);
n.acceleration = Point(0, 0);
n.mass = 1;
n.topSpeed = 1;

n.applyForce = { |n, force |
	var f = force / n.mass;
	n.acceleration = n.acceleration  + f;
};

n.updateFunc = {|n|
	n.velocity = n.velocity  + n.acceleration;
	n.velocity = n.velocity.clip(-1, 1); //Limit the velocity
	n.location = n.location + n.velocity;
	n.velocity = n.velocity * 0.99; //easing
	n.acceleration = n.acceleration * 0.0;
};

n.sonify = {|n, synth|
	synth.set(\amp, n.location.y);
};

n.checkLimits = {|n|
	if(n.location.x > 12000) {
		n.location.x = 12000;
	} {
		if(n.location.x < 60) {
			n.location.x = 60;
		}
	};
	if(n.location.y >= 0.9) {
		n.location.y = 0.9;
	} {
		if(n.location.y <= 0.1) {
			n.location.y = 0.1;
		}
	};
};
)


(
Tdef(\tester, {
	x = Synth(\test);
	inf.do{
		n.applyForce(Point(0, rrand(-0.01, 0.01)));
		n.updateFunc();
		n.checkLimits();
		n.sonify(x);
		(1/24).wait; // At visual frameRate
	}
}).play;
)
