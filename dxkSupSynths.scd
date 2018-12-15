//requires DxkFm class from dxkSup

SynthDef(\dxkFmASR, {|gate = 1, freq = 440, modharm = #[2,3,4,6], modidx = #[0.35, 0.3, 0.6, 0.1], att = 0.01, rel = 0.01, amp = 1, pan = 0, out = 0|
	var output, env;
	output = DxkFm.ar(freq, 1, modharm, modidx, amp);
	env = EnvGen.ar(Env.asr(att, 1, rel), gate, doneAction: 2);
	output = output * env;
	output = Pan2.ar(output, pan);
	Out.ar(out, output);
}).add;

SynthDef(\dxkFmPerc, {|t_trig = 1, freq = 440, modharm = #[2,3,4,6], modidx = #[0.35, 0.3, 0.6, 0.1], att = 0.01, rel = 1, amp = 1, pan = 0, out = 0|
	var output, env;
	output = DxkFm.ar(freq, 1, modharm, modidx, amp);
	env = EnvGen.ar(Env.perc(att, rel), t_trig, doneAction: 2);
	output = output * env;
	output = Pan2.ar(output, pan);
	Out.ar(out, output);
}).add;

SynthDef(\dxkFmADSR, {|gate = 1, freq = 440, modharm = #[2,3,4,6], modidx = #[0.35, 0.3, 0.6, 0.1], att = 0.01, decay = 0.3, sus = 0.5, rel = 1, amp = 1, pan = 0, out = 0|
	var output, env;
	output = DxkFm.ar(freq, 1, modharm, modidx, amp);
	env = EnvGen.ar(Env.adsr(att, decay, sus, rel), gate, doneAction: 2);
	output = output * env;
	output = Pan2.ar(output, pan);
	Out.ar(out, output);
}).add;



//fm drums
//ported from an infamous ae patch
SynthDef(\dxkFmHh1, {|t_trig = 1, carfreq = 1000, att = 0.003, rel = 0.05, amp =1, out = 0, pan = 0|
	var output, modidxenv, ampenv;
	modidxenv = EnvGen.ar(
		Env([20.63, 2, 0, 5,0],[att/3.0,2*att/3.0,rel/2.0, rel/2.0]),
		t_trig, doneAction: 0);
	output = DxkFm.ar(carfreq, 1, 45, modidxenv, amp);
	ampenv = EnvGen.ar(Env.perc(att, rel), t_trig, doneAction: 2);
	output = output * ampenv;
	output = Pan2.ar(output, pan);
	Out.ar(out, output);
}).add;

//ported from an infamous ae patch
SynthDef(\dxkFmBd1, {|t_trig = 1, basefreq = 3, att = 0.003, dec = 0.4632, rel = 0.3108, amp =1, out = 0, pan = 0|
	var output, modidxenv, ampenv, realatt;
	realatt = att+dec;
	modidxenv = EnvGen.ar(
		Env([7.5, 2, 0],[realatt/3.0,2*realatt/3.0,rel]),
		t_trig, doneAction: 0);
	output = DxkFm.ar(basefreq, 1, 12, modidxenv, amp);
	ampenv = EnvGen.ar(Env.perc(att, rel), t_trig, doneAction: 2);
	output = output * ampenv;
	output = Pan2.ar(output, pan);
	Out.ar(out, output);
}).add;

//ported from an infamous ae patch
SynthDef(\dxkFmSd1, {|t_trig = 1, basefreq = 110.8, att = 0.003, dec = 0.1602, rel = 0.1108, amp =1, out = 0, pan = 0|
	var output, modidxenv, ampenv, realatt;
	modidxenv = EnvGen.ar(
		Env([10.88, 0, 2, 3, 0, 5, 0.38],[att, dec/3.0, dec/3.0, dec/3.0, rel/3.0, 2*rel/3.0]),
		t_trig, doneAction: 0);
	output = DxkFm.ar(basefreq, 1, 709, modidxenv, amp);
	ampenv = EnvGen.ar(Env.perc(att, dec+rel), t_trig, doneAction: 2);
	output = output * ampenv;
	output = Pan2.ar(output, pan);
	Out.ar(out, output);
}).add;

SynthDef(\dxkFbDellopNM, {
	|in = 10, maxdelay = 1, delaytime =1, fb = 0.75, lop = 1000, dry = 1, wet = 1, amp = 1, out = 0, drylag = 0.01, wetlag = 0.01, amplag = 0.01, delaylag = 0.01|
	var input = In.ar(in, 1);
	var realdry = Lag.ar(K2A.ar(dry), drylag);
	var realwet = Lag.ar(K2A.ar(wet), wetlag);
	var realamp = Lag.ar(K2A.ar(amp), amplag);
	var realdelay = Lag.ar(K2A.ar(delaytime), delaylag);
	var output = DxkFbdellopN.ar(input, maxdelay, realdelay, fb, lop, realdry, realwet);

	Out.ar(out, output * realamp);
}).add;

SynthDef(\dxkFbDellopLM, {|in = 10, maxdelay = 1, delaytime =1, fb = 0.75, lop = 1000, dry = 1, wet = 1, amp = 1, out = 0, drylag = 0.01, wetlag = 0.01, amplag = 0.01, delaylag = 0.01|
	var input = In.ar(in, 1);
	var realdry = Lag.ar(K2A.ar(dry), drylag);
	var realwet = Lag.ar(K2A.ar(wet), wetlag);
	var realamp = Lag.ar(K2A.ar(amp), amplag);
	var realdelay = Lag.ar(K2A.ar(delaytime), delaylag);
	var output = DxkFbdellopL.ar(input, maxdelay, realdelay, fb, lop, realdry, realwet);

	Out.ar(out, output * realamp);
}).add;


SynthDef(\dxkFbDellopCM, {|in = 10, maxdelay = 1, delaytime =1, fb = 0.75, lop = 1000, dry = 1, wet = 1, amp = 1, out = 0, drylag = 0.01, wetlag = 0.01, amplag = 0.01, delaylag = 0.01|
	var input = In.ar(in, 1);
	var realdry = Lag.ar(K2A.ar(dry), drylag);
	var realwet = Lag.ar(K2A.ar(wet), wetlag);
	var realamp = Lag.ar(K2A.ar(amp), amplag);
	var realdelay = Lag.ar(K2A.ar(delaytime), delaylag);
	var output = DxkFbdellopC.ar(input, maxdelay, realdelay, fb, lop, realdry, realwet);

	Out.ar(out, output * realamp);
}).add;


SynthDef(\dxkFbDellopNS, {|in = 10, maxdelay = 1, delaytime =1, fb = 0.75, lop = 1000, dry = 1, wet = 1, amp = 1, out = 0, drylag = 0.01, wetlag = 0.01, amplag = 0.01, delaylag = 0.01|
	var input = In.ar(in, 2);
	var realdry = Lag.ar(K2A.ar(dry), drylag);
	var realwet = Lag.ar(K2A.ar(wet), wetlag);
	var realamp = Lag.ar(K2A.ar(amp), amplag);
	var realdelay = Lag.ar(K2A.ar(delaytime), delaylag);
	var output = DxkFbdellopN.ar(input, maxdelay, realdelay, fb, lop, realdry, realwet);

	Out.ar(out, output * realamp);
}).add;

SynthDef(\dxkFbDellopLS, {
	|in = 10, maxdelay = 1, delaytime =1, fb = 0.75, lop = 1000, dry = 1, wet = 1, amp = 1, out = 0, drylag = 0.01, wetlag = 0.01, amplag = 0.01, delaylag = 0.01|
	var input = In.ar(in, 2);
	var realdry = Lag.ar(K2A.ar(dry), drylag);
	var realwet = Lag.ar(K2A.ar(wet), wetlag);
	var realamp = Lag.ar(K2A.ar(amp), amplag);
	var realdelay = Lag.ar(K2A.ar(delaytime), delaylag);
	var output = DxkFbdellopL.ar(input, maxdelay, realdelay, fb, lop, realdry, realwet);

	Out.ar(out, output * realamp);
}).add;


SynthDef(\dxkFbDellopCS, {
	|in = 10, maxdelay = 1, delaytime =1, fb = 0.75, lop = 1000, dry = 1, wet = 1, amp = 1, out = 0, drylag = 0.01, wetlag = 0.01, amplag = 0.01, delaylag = 0.01|
	var input = In.ar(in, 2);
	var realdry = Lag.ar(K2A.ar(dry), drylag);
	var realwet = Lag.ar(K2A.ar(wet), wetlag);
	var realamp = Lag.ar(K2A.ar(amp), amplag);
	var realdelay = Lag.ar(K2A.ar(delaytime), delaylag);
	var output = DxkFbdellopC.ar(input, maxdelay, realdelay, fb, lop, realdry, realwet);
	Out.ar(out, output * realamp);
}).add;
