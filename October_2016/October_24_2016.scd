///////////////////////////////////
// October 24, 2016
// Darien Brito
// darienbrito.com
///////////////////////////////////

/*
IDEA: Additive synth with interactive envelopes (a primitive example)
*/

// GUI functions
(
// Create default envelopes
~default = [0, 1, 0.5, 0] ! 4; //ADSR type envelope
// Create simple GUI
~makeGui = { | default |
	var win = Window("Envs", Rect(0, 600, 330, 720));
	var envWidth = 310, envHeight = 150;
	var width = win.bounds.width; var height = win.bounds.height;
	var makePlotter = {|x, y, i|
		var plotter = Plotter("Envelope", bounds:Rect(x, y, envWidth, envHeight), parent:win)
		.plotMode_(\plines)
		.value_(default[i].copy); //Non-destructive
		plotter.setProperties(
			\plotColor, (10..0).normalize(0.1, 1).collect { |i| Color.rand(i) },
			\backgroundColor, Color.black ,
			\gridColorX, Color.yellow(0.5),
			\gridColorY, Color.yellow(0.5),
			\fontColor, Color(0.5, 1, 0),
		)
		.editMode_(true)
		.editFunc_({ |plt|
			default[i] = plt.value; //update array
		});
	};
	var labels = [\op1, \op2, \op3, \op4];
	var freqs  = [50, 100, 40, 80];

	// Use these instead if you prefer x/y positioning:
	//var coords = [ [0,0], [1,0], [0,1], [1,1]];
	//4.do{|i| makePlotter.(coords[i][0] * envWidth, coords[i][1] * envHeight, i)};

	// But If you are like me:
	win.view.decorator = FlowLayout(win.view.bounds);
	win.view.decorator.gap=2@2;
	4.do{|i|
		makePlotter.(0,0, i);
		EZNumber(win, envWidth@20, labels[i], \freq, action: { |v|
			freqs[i] = v.value;
		}, initVal: freqs[i], unitWidth:30, numberWidth:60,layout:\horz)
	};
	// Make buttons
	Button(win, (width*0.5)@20)
	.states_([["play", Color.grey, Color.white]])
	.action_({|btn|
		Synth(\alg1, [\op1Freq, freqs[0], \op2Freq, freqs[1], \op3Freq, freqs[2], \op4Freq, freqs[3], \envelopes, default ]);
	});
	win.front;
};

// Envelopes
~envs = {|collection|
	var envs = collection.collect{|env| EnvGen.kr(Env(env, 0.25 ! 4 ), doneAction: 2)}; // Evenly distributed timing for now
	envs;
};

// FM synth
SynthDef(\alg1, {| op1Freq = 100, op2Freq = 200, op3Freq = 300, op4Freq = 400,
	pan = 0, amp = 1, rel = 1, pos = 0, out = 0 |
	var envs = ~envs.(Control.names(\envelopes).kr([0,1,1,0] ! 4));
	var sig = SinOsc.ar(op1Freq,
		phase: SinOsc.ar(op2Freq,
			phase:SinOsc.ar(op3Freq,
				phase:SinOsc.ar(op4Freq, 0, mul: envs[3]), mul: envs[2]), mul: envs[1]), mul: envs[0]);
	sig = sig * EnvGen.kr(Env.perc(0.01, rel), doneAction: 2);
	sig = sig * amp;
	Out.ar(0, Pan2.ar(sig, pos));
}).add;
)

// Execute (if window closed, it will remember values)
(
~makeGui.(~default);
)
