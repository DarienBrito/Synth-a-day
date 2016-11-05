///////////////////////////////////
// October 27, 2016
// Darien Brito
// darienbrito.com
///////////////////////////////////

/*
IDEA: A self transformative step sequencer
*/

// A kick
(
SynthDef(\kick2, {|base = 50, envRatio = 3, freqDecay = 0.02, ampDecay  = 0.5,
	fbAmount = 0.99, cFreq = 120|
	var freqShift, env, out, fbEnv;
	freqShift = EnvGen.kr(Env([envRatio,1], [freqDecay], \exp), 1) * base;
	fbEnv = EnvGen.kr(Env([cFreq,base],[ampDecay]),1);
	env = EnvGen.kr(Env.perc(0.005, ampDecay), 1, doneAction:2);
	out = SinOscFB.ar(freqShift, fbAmount, env);
	out = LPF.ar(out, fbEnv,1);
	Out.ar(0,out!2)
}).add
)

(
~builGUI = { | steps = 12 |
	var buttonWidth = 25;
	var windowWidth = buttonWidth * 4;
	var win = Window("Sequencer", (windowWidth*4)@300);
	var decorator;
	~buttons = (\col1: Array.new(steps), \col2: Array.new(steps), \col3: Array.new(steps), \col4: Array.new(steps));
	win.view.decorator = FlowLayout(win.view.bounds);
	decorator = win.view.decorator;
	steps.do{|i|
		~buttons[\col1].add(
			Button(win, width - 5)
			.states_([[" ", Color.black, Color.black], ["x", Color.black, Color.red]])
		);
		~buttons[\col2].add(
			Button(win, width - 5)
			.states_([[" ", Color.black, Color.black], ["x", Color.black, Color.red]])
		);
		~buttons[\col3].add(
			Button(win, width - 5)
			.states_([[" ", Color.black, Color.black], ["x", Color.black, Color.red]])
		);
		~buttons[\col4].add(
			Button(win, width - 5)
			.states_([[" ", Color.black, Color.black], ["x", Color.black, Color.red]])

		);
	};
	win.front;
};

~checkStates = { | group, index, func |
	var btn = group[index % group.size];
	var last = group[(index-1) % group.size];
	if(btn.value > 0) {
		func.();
		if(last.value < 1) {
			last.states_([[" ", Color.black, Color.black], ["x", Color.black, Color.red]]);
		}
	} {
		btn.states_([[" ", Color.black, Color.red], ["x", Color.black, Color.red]]);
		if(last.value < 1) {
			last.states_([[" ", Color.black, Color.black], ["x", Color.black, Color.red]]);
		}
	};
};

~seq = Routine({
	var bpm = 180;
	inf.do{|i|
		~checkStates.(~buttons[\col1], i, { Synth(\kick2) });
		~checkStates.(~buttons[\col2], i, { Synth(\kick2) });
		~checkStates.(~buttons[\col3], i, { Synth(\kick2) });
		~checkStates.(~buttons[\col4], i, { Synth(\kick2) });
		(60/bpm).wait;
	}
});

~builGUI.(12);
AppClock.play(~seq);
)

Window.closeAll