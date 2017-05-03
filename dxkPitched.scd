
//original work by jeff on 6/17/08 based on a James McCartney example
//found in the synthdefpool as cheappiano
//tweaked some things, like the trig for Decay2, various amp parameters, amp envelope
SynthDef(\dxkCheapPno, { |t_trig=1, freq=440, amp=1, dur=1, pan=0, out = 0|
	var output, n = 6, max = 0.04, min = 0.01, delay, pitch, detune, hammer;
	freq = freq.cpsmidi;
	hammer = Decay2.ar(Trig.ar(t_trig, SampleDur.ir), 0.08, 0.04, LFNoise2.ar([2000,4000].asSpec.map(amp), 0.25));
	output = Mix.ar(Array.fill(3, { arg i;
			detune = #[-0.04, 0, 0.03].at(i);
			delay = (1/(freq + detune).midicps);
			CombL.ar(hammer, delay, delay, 50*amp)
		}) );

	output = HPF.ar(output,freq.midicps) * EnvGen.ar(Env.perc(0.01,dur, amp, -1), doneAction:2);
	output = Pan2.ar(output, pan);
	Out.ar(out, output);
}).add;




