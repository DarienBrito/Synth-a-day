MyNode {
	var location;
	var velocity;
	var acceleration;
	var mass;
	var topSpeed;
	var limits;

	*new{ |x = 120, y = 0.1, m = 1, speedlimLo = -1, speedlimHi = 1|
		^super.new.init(x, y, m, speedlimLo, speedlimHi);
	}

	init { |x, y, m, speedlimLo, speedlimHi|
		location = Point(x, y);
		velocity = Point(0, 0);
		acceleration = Point(0, 0);
		mass = m ? 1;
		topSpeed = 1;
		limits = Point(speedlimLo, speedlimHi);
	}

	applyForce {|force|
		var f = force / mass;
		acceleration = acceleration + f;
	}

	// We need velocityX accelerationX to make this work
	updateFunc {
		velocity = velocity + acceleration;
		velocity = velocity.clip(limits.x, limits.y);
		location = location + velocity;
		velocity = velocity * 0.99; //easing
		acceleration = acceleration * 0.0;
	}


	// The synth we pass must have amp and freq arguments
	sonify{|synth|
		synth.set(\freq, location.x);
		synth.set(\amp, location.y);
	}

	checkLimits {
		if(location.x > 12000) {
			location.x = 12000;
		} {
			if(location.x < 60) {
				location.x = 60;
			}
		};
		if (location.y >= 0.9) {
			location.y = 0.9;
		} {
			if(location.y <= 0.1) {
				location.y = 0.1;
			}
		};
	}

	debug { |x = false, y = true |
		if(x) {
			location.x.format("location x: %").postln;
		};
		if(y){
			location.y.format("location y: %").postln;
		}
	}

}
