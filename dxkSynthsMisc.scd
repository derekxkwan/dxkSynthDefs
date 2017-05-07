
SynthDef(\dxkDtmf, {|number = 0, mul = 1, pan = 0, out = 0, gate = 1, att = 0.001, decay = 0.001|
	var output, env, freqarr, freqs;
	//A = 10, B = 11, C = 12, D = 13, * =14, E = 15
	// freq pairs
	freqarr = [[941, 1336], [697, 1209], [697, 1336], [697, 1477],
		[770, 1209], [770, 1336], [770, 1477],
		[852, 1209], [852, 1336], [852, 1477],
		[697, 1633], [770, 1633], [852, 1633],
		[941, 1633], [941, 1209], [941, 1477]];
	
	freqs = Select.kr(number, freqarr);
	output = SinOsc.ar(freqs, 0, mul);
	output = Mix.new(output)*0.5;
	env = EnvGen.ar(Env.asr(att, 1, decay), gate, doneAction: 2);
	output = output * env;
	output = Pan2.ar(output, pan);
	Out.ar(out, output)}).add;

SynthDef(\dxkClik, {|t_trig = 1, samplen = 1,  amp = 1, pan = 0, out = 0|
	var output, filtput;
	output = Trig.ar(t_trig, samplen*SampleDur.ir);
	output = output * amp;
	DetectSilence.ar(output, doneAction: 2);
	output = Pan2.ar(output, pan);
	Out.ar(out, output);
}).add;

SynthDef(\dxkClikFilt, {|t_trig = 1, samplen = 1, freq = 440, rq = 0.1, amp = 1, pan = 0, out = 0|
	var output, filtput;
	output = Trig.ar(t_trig, samplen*SampleDur.ir);
	output = output * amp;
	output = BPF.ar(output, freq, rq);
	DetectSilence.ar(output, doneAction: 2);
	output = Pan2.ar(output, pan);
	Out.ar(out, output);
}).add;


SynthDef(\dxkWNoiseBPFADSR, {|gate = 1, freq= 440, rq = 0.1, att = 0.01, decay = 0.3, suslvl = 0.5, rel =1, amp = 1, pan = 0, out =0|
	var env, output, noise;

	noise = WhiteNoise.ar();
	env = EnvGen.ar(Env.adsr(att,decay,suslvl,rel),gate, doneAction: 2);
	output = BPF.ar(noise, freq, rq, amp);
	output = output * env;
	output = Pan2.ar(output, pan);
	Out.ar(out, output); 
}).add;
	

SynthDef(\dxkWNoizBPFASR, {|gate = 1, freq = 440, rq = 0.1, att = 0.001, rel = 0.001, amp = 1, pan =0, out = 0|
	var env, output, noise;
	noise = WhiteNoise.ar();
	env = EnvGen.ar(Env.asr(att, 1, rel), gate, doneAction: 2);
	output = BPF.ar(noise, freq, rq, amp);
	output = output * env;
	output = Pan2.ar(output, pan);
	Out.ar(out, output); 
}).add;

SynthDef(\dxkWNoizBPFPerc, {|gate = 1, freq = 440, rq = 0.1, att = 0.01, rel = 1, curve = -4, amp = 1, pan =0, out = 0|
	var env, output, noise;
	noise = WhiteNoise.ar();
	env = EnvGen.ar(Env.perc(att,rel, 1, curve),gate, doneAction: 2);
	output = BPF.ar(noise, freq, rq, amp);
	output = output * env;
	output = Pan2.ar(output, pan);
	Out.ar(out, output); 
}).add;