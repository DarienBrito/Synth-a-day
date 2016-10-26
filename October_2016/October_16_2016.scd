///////////////////////////////////
// October 16, 2016
// Darien Brito
// darienbrito.com
///////////////////////////////////

/*
IDEA: Let's create some wavetables: (Exploring VOsc3)
Functions ported from Golan Levin's Polynomial Shaping Functions
to be used for additive synthesis oscillators
*/

// Polynomial functions:
(
~bilinnWyvillCosineApproximation = { | x |
	var x2 = x*x;
	var x4 = x2*x2;
	var x6 = x4*x2;
	var fa = ( 4.0/9.0);
	var fb = (17.0/9.0);
	var fc = (22.0/9.0);
	var y = fa*x6 - fb*x4 + fc*x2;
	y;
};

~doubleCubicSeat = { | x,  a,  b |
	var epsilon = 0.00001;
	var min_param_a = 0.0 + epsilon;
	var max_param_a = 1.0 - epsilon;
	var min_param_b = 0.0;
	var max_param_b = 1.0;
	var y = 0;
	a = min(max_param_a, max(min_param_a, a));
	b = min(max_param_b, max(min_param_b, b));

	if (x <= a) {
		y = b - (b * pow( 1 - (x/a), 3.0) ); // Be aware of the order of operations.
	} {
		y = b + ( (1-b) * pow( (x-a)/(1-a), 3.0) );
	};

	y;
};

~doubleCubicSeatLinearBlend = { | x,  a,  b |
	var epsilon = 0.00001;
	var min_param_a = 0.0 + epsilon;
	var max_param_a = 1.0 - epsilon;
	var min_param_b = 0.0;
	var max_param_b = 1.0;
	var y = 0;
	a = min(max_param_a, max(min_param_a, a));
	b = min(max_param_b, max(min_param_b, b));
	b = 1.0 - b; //reverse for intelligibility.

	if ( x <= a){
		y = (b*x) + ( (1-b) * a * (1-pow(1-x/a, 3.0)) );
	} {
		y = (b*x) + ( (1-b) * (a +  ( (1-a) * pow((x-a)/(1-a), 3.0)) ) );
	};
	y
};

~doubleOddPolynomialSeat = { | x, a, b, n |
	var epsilon = 0.00001;
	var min_param_a = 0.0 + epsilon;
	var max_param_a = 1.0 - epsilon;
	var min_param_b = 0.0;
	var max_param_b = 1.0;
	var p = (2 * n) + 1;
	var y = 0;

	a = min(max_param_a, max(min_param_a, a));
	b = min(max_param_b, max(min_param_b, b));

	if (x <= a){
		y = b - (b * pow(1-x/a, p));
	} {
		y = b + ((1-b)*pow((x-a)/(1-a), p));
	};
	y
};

~doublePolynomialSigmoid = { | x,  a,  b,  n |
	var y = 0;
	if (n%2 == 0) {     // even polynomial
		if ( x <= 0.5){
			y = pow(2.0 * x, n)/2.0;
		} {
			y = 1.0 - pow( 2 * (x-1), n) /2.0;
		}
	}
	{    // odd polynomial
		if (x <= 0.5) {
			y = pow(2.0 * x, n) /2.0;
		}  {
			y = 1.0 + pow(2.0*(x-1), n)/2.0;
		}
	};
	y;
};

~quadraticThroughAGivenPoint = { | x,  aVal,  bVal |
	var epsilon = 0.00001;
	var min_param_a = 0.0 + epsilon;
	var max_param_a = 1.0 - epsilon;
	var min_param_b = 0.0;
	var max_param_b = 1.0;
	var a = min(max_param_a, max(min_param_a, aVal));
	var b = min(max_param_b, max(min_param_b, bVal));

	var finA = ((1-b)/(1-a)) - (b/a);
	var finB = ((finA * (a*a)) - b)/a;
	var y = (finA*(x*x)) - (finB*(x));
	y = min(1,max(0,y));
	y;
};

// Create Wavetables:
// Bilin Wyvill
~bilinWyvillWavetable = { |n = 8|
	var array = List();
	var amps;
	n.do{|i|
		var val = (i+1) * n.reciprocal; //Normalize
		var calc = ~bilinnWyvillCosineApproximation.(val);
		array.add(calc);
	};
	amps = array.asArray;
	//amps.plot;
	~bilinnWyvill.free; ~bilinnWyvill = Buffer.alloc(s,512,1, {|buf| buf.sine1Msg(amps)});
};

// Double-Cubic Seat
~doubleCubicWavetable = { |n = 8, a = 0.407, b = 0.720|
	var array = List();
	var amps;
	n.do{|i|
		var val = (i+1) * n.reciprocal;
		var calc = ~doubleCubicSeat.(val, a, b); // Change vals
		array.add(calc);
	};
	amps = array.asArray;
	//amps.plot;
	~doubleCubicS.free; ~doubleCubicS = Buffer.alloc(s,512,1, {|buf| buf.sine1Msg(amps)});
};


// Double-Cubic Seat with Linear Blend (looks not quite there though)
~doubleCubicSeatWavetable = { |n = 8, a = 0.407, b = 0.720|
	var array = List();
	var amps;
	n.do{|i|
		var val = (i+1) * n.reciprocal;
		var calc = ~doubleCubicSeatLinearBlend.(val, a, b); // Change vals
		array.add(calc);
	};
	amps = array.asArray;
	//amps.plot;
	~doubleCubicSLin.free; ~doubleCubicSLin = Buffer.alloc(s,512,1, {|buf| buf.sine1Msg(amps)});
};

// Double odd polynomial set
~doubleOddPolyWaveTable = { |n = 8, a = 0.407, b = 0.720, p = 0.5 |
	var array = List();
	var amps;
	n.do{|i|
		var val = (i+1) * n.reciprocal;
		var calc = ~doubleOddPolynomialSeat.(val, a, b, p); // Change vals
		array.add(calc);
	};
	amps = array.asArray;
	//amps.plot;
	~doubleOddPolySet.free; ~doubleOddPolySet = Buffer.alloc(s,512,1, {|buf| buf.sine1Msg(amps)});
};

// Double Polynomial Sygmoid
~doublePolySigWavetable = { |n = 100, a = 0.407, b = 0.720, p = 10|
	var array = List();
	var amps;
	n.do{|i|
		var val = (i+1) * n.reciprocal;
		var calc = ~doublePolynomialSigmoid.(val, a, b, p); // Change vals
		array.add(calc);
	};
	amps = array.asArray;
	//amps.plot;
	~doublePolySig.free; ~doublePolySig = Buffer.alloc(s,512,1, {|buf| buf.sine1Msg(amps)});
};

// Quadratic Through A Given Point
~quadraticPointWaveTable = { |n = 8, a = 0.233, b = 0.340|
	var array = List();
	var amps;
	n.do{|i|
		var val = (i+1) * n.reciprocal;
		var calc = ~quadraticThroughAGivenPoint.(val, a, b); // Change vals
		array.add(calc);
	};
	amps = array.asArray;
	~quadraticPoint.free; ~quadraticPoint = Buffer.alloc(s,512,1, {|buf| buf.sine1Msg(amps)});
};
)

//Instantiate Wavetables with +/- partials:
(
~bilinWyvillWavetable.(8);
~doubleCubicWavetable.(8,0.1,0.9);
~doubleCubicSeatWavetable.(8,0.8,0.2);
~doubleOddPolyWaveTable.(8, 0.2,0.2, 0.1);
~doublePolySigWavetable.(8);
~quadraticPointWaveTable.(8);
)

// Assign labels
(
var labels = [\bilin, \doubleCubic, \doubleCubicS, \doubleeOdd, \doublePoly, \quadraticPoint];
var buffers = [~bilinnWyvill, ~doubleCubicS, ~doubleCubicSLin, ~doubleOddPolySet, ~doublePolySig, ~quadraticPoint];
~arrays = ();
labels.do{|label, i| ~arrays.put(label, buffers[i].loadToFloatArray(action: { arg array; a = array; }))};
)

// Visualize
~arrays[\doubleCubicS].plot

(
Ndef(\across).play;
Ndef(\across).fadeTime = 2;
Ndef(\across, { VOsc3.ar(LFTri.kr([0.1,0.2]).range(0.01, 4.99), 61, 120, 242, 0.3)});
Ndef(\across).mold(2);
)

Ndef(\across).clear(2)

// Test them:
(
Ndef(\tester).play;
Ndef(\tester).fadeTime = 2;
)

Ndef(\tester, { COsc.ar(~bilinnWyvill, 60 )});
Ndef(\tester, { Osc.ar(~doubleCubicS, 60)});
Ndef(\tester, { Osc.ar(~doubleCubicSLin, 60)});
Ndef(\tester, { Osc.ar(~doubleOddPolySet, 60)});
Ndef(\tester, { Osc.ar(~doublePolySig, 30)}); // This is nice for low base freqs (100 partials)
Ndef(\tester, { Osc.ar(~quadraticPoint, 30)}); // This is nice for low base freqs


