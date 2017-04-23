
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
