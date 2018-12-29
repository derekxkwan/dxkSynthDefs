//sample chopper, loc = location between 0 and 1

//for use with patterns
SynthDef(\dxkPNobuM, {|buf, gate = 1, loc = 0, rate = 1, amp = 1, pan = 0,  ramp = 0.001, relabs = 0,  out = 0|
	var output, rdphs, bufsize, trig, del_trig, real_loc, env, bufrate, startend;
	bufsize = BufFrames.ir(buf);
	bufrate = BufRateScale.kr(buf)*rate;
	real_loc = Select.kr(relabs % 2, [loc*bufsize, loc]);
	real_loc = Clip.kr(real_loc, 0, bufsize);
	startend = Select.kr(rate >= 0, [[0, real_loc], [real_loc,bufsize]]);
	rdphs = Phasor.ar(0, bufrate, startend[0], startend[1], real_loc);
	env = EnvGen.ar(Env.asr(ramp,1,ramp),gate, doneAction: 2);
	output = BufRd.ar(1, buf, rdphs);
	output = output*env*amp;
	output = Pan2.ar(output, pan);
	Out.ar(out,output);
}).add;

SynthDef(\dxkPNobuS, {|buf, gate = 1, loc = 0,  ramp = 0.001, rate = 1, amp = 1, pan = 0, relabs = 0, out = 0|
	var output, rdphs, bufsize, trig, del_trig, real_loc, env, panner, panout, bufrate, startend;
	bufsize = BufFrames.ir(buf);
	bufrate = BufRateScale.kr(buf) * rate;
	real_loc = Select.kr(relabs % 2, [loc*bufsize, loc]);
	real_loc = Clip.kr(real_loc, 0, bufsize);
	startend = Select.kr(rate >= 0, [[0, real_loc], [real_loc,bufsize]]);
	rdphs = Phasor.ar(0, bufrate, startend[0], startend[1], real_loc);
	env = EnvGen.ar(Env.asr(ramp,1,ramp),gate, doneAction: 2);
	output = BufRd.ar(2, buf, rdphs);


	//l -> l: 1 : 1 -> 0
	//l -> r: 0 : 0 -> 1
	//r -> r: 0 -> 1 : 1
	//r -> l: 1->0 : 0

	panner = Clip.kr([ (1 - pan), pan, (1 + pan), (-1 * pan)], 0, 1);
	panout = [Mix.ar(output * [panner[0], panner[3]]), Mix.ar(output * [panner[1], panner[2]])];
	
	output = panout*env*amp;
	//output = Pan2.ar(output,pan);
	Out.ar(out,output);
}).add;


SynthDef(\dxkPNobuStutM, {|buf, gate = 1, loc = 0, rate = 1, stut = 0,
	maxdelay = 1, stutlen = 0.1, amp = 1, pan = 0,  ramp = 0.001,  stutramp = 0.001, relabs = 0, out = 0|
	//stutlen is in real time seconds
	//regular nobu vars
	var output, rdphs, bufsize, trig, del_trig, real_loc, env, bufrate, startend;
	//stutter vars
	var stutout, delptr, clock, stuttrig, stutenv;
	bufsize = BufFrames.ir(buf);
	bufrate = BufRateScale.kr(buf)*rate;
	real_loc = Select.kr(relabs % 2, [loc*bufsize, loc]);
	real_loc = Clip.kr(real_loc, 0, bufsize);
	startend = Select.kr(rate >= 0, [[0, real_loc], [real_loc,bufsize]]);
	rdphs = Phasor.ar(0, bufrate, startend[0], startend[1], real_loc);
	env = EnvGen.ar(Env.asr(ramp,1,ramp),gate, doneAction: 2);
	output = BufRd.ar(1, buf, rdphs);
	//now the stuttering stuff
	stuttrig = HPZ1.kr(stut);
	clock = Phasor.ar(stuttrig, stutlen.reciprocal/SampleRate.ir);
	clock = (clock - Delay1.ar(clock)) < 0;
	delptr = Clip.ar(Sweep.ar(stuttrig), 0, maxdelay);
	delptr = Latch.ar(delptr, clock);
	stutenv = EnvGen.ar(Env.asr(stutramp, 1, stutramp), clock);
	stutout = DelayL.ar(output, maxdelay, delptr);
	output = XFade2.ar(output, stutout, Lag.kr(stut*2-1, stutramp));
	output = output*env*amp;
	output = Pan2.ar(output, pan);
	Out.ar(out,output);

}).add;

SynthDef(\dxkPNobuStutS, {|buf, gate = 1, loc = 0, rate = 1, stut = 0,
	maxdelay = 1, stutlen = 0.1, amp = 1,  ramp = 0.001, stutramp = 0.001, relabs = 0, pan = 0, out = 0|
	//stutlen is in real time seconds
	//regular nobu vars
	var output, rdphs,bufsize, trig, del_trig, real_loc, env, bufrate, startend;
	//stutter vars
	var stutout, delptr, clock, stuttrig, stutenv;
	var panout, panner;
	
	bufsize = BufFrames.ir(buf);
	bufrate = BufRateScale.kr(buf) * rate;
	real_loc = Select.kr(relabs % 2, [loc*bufsize, loc]);
	real_loc = Clip.kr(real_loc, 0, bufsize);
	startend = Select.kr(rate >= 0, [[0, real_loc], [real_loc,bufsize]]);
	rdphs = Phasor.ar(0, bufrate, startend[0], startend[1], real_loc);
	env = EnvGen.ar(Env.asr(ramp,1,ramp),gate, doneAction: 2);
	output = BufRd.ar(2, buf, rdphs);
	//now the stuttering stuff
	stuttrig = HPZ1.kr(stut);
	clock = Phasor.ar(stuttrig, stutlen.reciprocal/SampleRate.ir);
	clock = (clock - Delay1.ar(clock)) < 0;
	delptr = Clip.ar(Sweep.ar(stuttrig), 0, maxdelay);
	delptr = Latch.ar(delptr, clock);
	stutenv = EnvGen.ar(Env.asr(stutramp, 1, stutramp), clock);
	stutout = DelayL.ar(output, maxdelay, delptr);
	output = XFade2.ar(output, stutout, Lag.kr(stut*2-1, stutramp));
	

	//l -> l: 1 : 1 -> 0
	//l -> r: 0 : 0 -> 1
	//r -> r: 0 -> 1 : 1
	//r -> l: 1->0 : 0

	panner = Clip.kr([ (1 - pan), pan, (1 + pan), (-1 * pan)], 0, 1);
	panout = [Mix.ar(output * [panner[0], panner[3]]), Mix.ar(output * [panner[1], panner[2]])];


	
	output = panout*env*amp;

	//output = Pan2.ar(output, pan);
	Out.ar(out,output);

}).add;

//for use outside of patterns
SynthDef(\dxkNobuM, {|buf, t_trig = 1, loc = -1, rate = 1, out = 0, amp = 1,  ramp = 0.001, relabs = 0|
	var output, rdphs, bufsize, trig, del_trig, real_loc, env, gate, bufrate, startend;
	trig = HPZ1.kr(loc);
	trig = (trig < 0) + (trig > 0) +t_trig;
	del_trig = TDelay.kr(trig, ramp);
	gate = SetResetFF.kr(del_trig, trig);
	bufsize = BufFrames.ir(buf);
	real_loc = Select.kr(relabs % 2, [loc*bufsize, loc]);
	real_loc = Clip.kr(real_loc, 0, bufsize);
	bufrate = BufRateScale.kr(buf) * rate;
	startend = Select.kr(rate >= 0, [[0, real_loc], [real_loc,bufsize]]);
	rdphs = Phasor.ar(0, bufrate, startend[0], startend[1], real_loc);
	env = EnvGen.ar(Env.asr(ramp,1,ramp),gate);
	output = BufRd.ar(1, buf, rdphs)*env;
	output = output * env * amp;
	Out.ar(out, output);
}).add;



SynthDef(\dxkNobuStutM, {|buf, t_trig = 1, loc = -1, rate = 1, stut = 0,
	maxdelay = 1, stutlen = 0.1, amp = 1, ramp = 0.001, stutramp = 0.001, relabs = 0, out = 0|
	//stutlen is in real time seconds
	//regular nobu vars
	var output, rdphs, bufsize, trig, del_trig, real_loc, env, gate, bufrate, startend;
	//stutter vars
	var stutout, delptr, clock, stuttrig, stutenv;
	trig = HPZ1.kr(loc);
	trig = (trig < 0) + (trig > 0) +t_trig;
	del_trig = TDelay.kr(trig, ramp);
	gate = SetResetFF.kr(del_trig, trig);
	bufsize = BufFrames.ir(buf);
	bufrate = BufRateScale.kr(buf) * rate;
	real_loc = Select.kr(relabs % 2, [loc*bufsize, loc]);
	real_loc = Clip.kr(real_loc, 0, bufsize);
	startend = Select.kr(rate >= 0, [[0, real_loc], [real_loc,bufsize]]);
	rdphs = Phasor.ar(0, bufrate, startend[0], startend[1], real_loc);
	env = EnvGen.ar(Env.asr(ramp,1,ramp),gate);
	output = BufRd.ar(1, buf, rdphs)*env;
	//now the stuttering stuff
	stuttrig = HPZ1.kr(stut);
	clock = Phasor.ar(stuttrig, stutlen.reciprocal/SampleRate.ir);
	clock = (clock - Delay1.ar(clock)) < 0;
	delptr = Clip.ar(Sweep.ar(stuttrig), 0, maxdelay);
	delptr = Latch.ar(delptr, clock);
	stutenv = EnvGen.ar(Env.asr(stutramp, 1, stutramp), clock);
	stutout = DelayL.ar(output, maxdelay, delptr);
	output = XFade2.ar(output, stutout, Lag.kr(stut*2-1, stutramp));
	output = output*env*amp;
	//output = Pan2.ar(output, pan);
	Out.ar(out,output);

}).add;


SynthDef(\dxkNobuS, {|buf, t_trig = 1, loc = -1, rate = 1, ramp = 0.001, relabs = 0, pan = 0, amp = 1, out = 0|
	var output, rdphs, bufsize, trig, del_trig, real_loc, env, gate, bufrate, startend;
	var panout, panner;
	
	trig = HPZ1.kr(loc);
	trig = (trig < 0) + (trig > 0) +t_trig;
	del_trig = TDelay.kr(trig, ramp);
	gate = SetResetFF.kr(del_trig, trig);
	bufsize = BufFrames.ir(buf);
	bufrate = BufRateScale.kr(buf) * rate;
	real_loc = Select.kr(relabs % 2, [loc*bufsize, loc]);
	real_loc = Clip.kr(real_loc, 0, bufsize);
	startend = Select.kr(rate >= 0, [[0, real_loc], [real_loc,bufsize]]);
	rdphs = Phasor.ar(0, bufrate, startend[0], startend[1], real_loc);
	env = EnvGen.ar(Env.asr(ramp,1,ramp),gate);
	output = BufRd.ar(2, buf, rdphs)*env;

	//l -> l: 1 : 1 -> 0
	//l -> r: 0 : 0 -> 1
	//r -> r: 0 -> 1 : 1
	//r -> l: 1->0 : 0

	panner = Clip.kr([ (1 - pan), pan, (1 + pan), (-1 * pan)], 0, 1);
	panout = [Mix.ar(output * [panner[0], panner[3]]), Mix.ar(output * [panner[1], panner[2]])];


	output = panout*env*amp;

	Out.ar(out, output);
}).add;



SynthDef(\dxkNobuStutS, {|buf, t_trig = 1, loc = -1, rate = 1,  stut = 0,
	maxdelay = 1, stutlen = 0.1, amp = 1, ramp = 0.001, stutramp = 0.001, relabs = 0, pan = 0, out = 0|
	//stutlen is in real time seconds
	//regular nobu vars
	var output, rdphs,bufsize, trig, del_trig, real_loc, env, gate, bufrate, startend;
	//stutter vars
	var stutout, delptr, clock, stuttrig, stutenv;

	var panout, panner;
	trig = HPZ1.kr(loc);
	trig = (trig < 0) + (trig > 0) +t_trig;
	del_trig = TDelay.kr(trig, ramp);
	gate = SetResetFF.kr(del_trig, trig);
	bufsize = BufFrames.ir(buf);
	bufrate = BufRateScale.kr(buf) * rate;
	real_loc = Select.kr(relabs % 2, [loc*bufsize, loc]);
	real_loc = Clip.kr(real_loc, 0, bufsize);
	startend = Select.kr(rate >= 0, [[0, real_loc], [real_loc,bufsize]]);
	rdphs = Phasor.ar(0, bufrate, startend[0], startend[1], real_loc);
	env = EnvGen.ar(Env.asr(ramp,1,ramp),gate);
	output = BufRd.ar(2, buf, rdphs)*env;
	//now the stuttering stuff
	stuttrig = HPZ1.kr(stut);
	clock = Phasor.ar(stuttrig, stutlen.reciprocal/SampleRate.ir);
	clock = (clock - Delay1.ar(clock)) < 0;
	delptr = Clip.ar(Sweep.ar(stuttrig), 0, maxdelay);
	delptr = Latch.ar(delptr, clock);
	stutenv = EnvGen.ar(Env.asr(stutramp, 1, stutramp), clock);
	stutout = DelayL.ar(output, maxdelay, delptr);
	output = XFade2.ar(output, stutout, Lag.kr(stut*2-1, stutramp));

	
	//l -> l: 1 : 1 -> 0
	//l -> r: 0 : 0 -> 1
	//r -> r: 0 -> 1 : 1
	//r -> l: 1->0 : 0

	panner = Clip.kr([ (1 - pan), pan, (1 + pan), (-1 * pan)], 0, 1);
	panout = [Mix.ar(output * [panner[0], panner[3]]), Mix.ar(output * [panner[1], panner[2]])];


	output = panout*env*amp;

	//output = Pan2.ar(output, pan);
	Out.ar(out,output);

}).add;



//for triggering

SynthDef(\dxkTNobuM, {|buf, t_trig = 1, dur = 0.25, loc = 0, rate = 1, amp = 1, pan = 0,  ramp = 0.001, relabs = 0,  out = 0|
	var output, rdphs,  bufsize, trig, del_trig, real_loc, env, bufrate, startend;
	var gate, delay_trig, clip_dur, trig_dur, ask_dur, buf_dur;
	
	bufsize = BufFrames.ir(buf);
	bufrate = BufRateScale.kr(buf) * rate;
	real_loc = Select.kr(relabs % 2, [loc*bufsize, loc]);
	real_loc = Clip.kr(real_loc, 0, bufsize);
	ask_dur = Select.kr(BinaryOpUGen('>=', rate, 0), [real_loc, bufsize - real_loc]) * (abs(rate*BufSampleRate.kr(buf)).reciprocal);
	clip_dur = Select.kr(dur > 0, [ask_dur, Clip.kr(dur, 0, ask_dur)]);
	delay_trig =  DelayN.kr(t_trig, clip_dur, clip_dur);
	gate = SetResetFF.kr(t_trig, delay_trig);
	startend = Select.kr(rate >= 0, [[0, real_loc], [real_loc,bufsize]]);
	rdphs = Phasor.ar(0, bufrate, startend[0], startend[1], real_loc);
	env = EnvGen.ar(Env.asr(ramp,1,ramp),gate, doneAction: 2);
	output = BufRd.ar(1, buf, rdphs);
	output = output*env*amp;
	output = Pan2.ar(output, pan);
	Out.ar(out,output);
}).add;

SynthDef(\dxkTNobuS, {|buf, t_trig = 1, dur = 0.25, loc = 0,  ramp = 0.001, rate = 1, amp = 1, pan = 0, relabs = 0, out = 0|
	var output, rdphs, bufsize, trig, del_trig, real_loc, env,  panner, panout, bufrate, startend;
	var gate, delay_trig, clip_dur, trig_dur, ask_dur, buf_dur;
	
	bufsize = BufFrames.ir(buf);
	bufrate = BufRateScale.kr(buf) * rate;
	real_loc = Select.kr(relabs % 2, [loc*bufsize, loc]);
	real_loc = Clip.kr(real_loc, 0, bufsize);
	ask_dur = Select.kr(BinaryOpUGen('>=', rate, 0), [real_loc, bufsize - real_loc]) * (abs(rate*BufSampleRate.kr(buf)).reciprocal);
	clip_dur = Select.kr(dur > 0, [ask_dur, Clip.kr(dur, 0, ask_dur)]);
	delay_trig = DelayN.kr(t_trig, clip_dur, clip_dur);
	gate = SetResetFF.kr(t_trig, delay_trig);
	startend = Select.kr(rate >= 0, [[0, real_loc], [real_loc,bufsize]]);
	rdphs = Phasor.ar(0, bufrate, startend[0], startend[1], real_loc);
	env = EnvGen.ar(Env.asr(ramp,1,ramp),gate, doneAction: 2);
	output = BufRd.ar(2, buf, rdphs);


	//l -> l: 1 : 1 -> 0
	//l -> r: 0 : 0 -> 1
	//r -> r: 0 -> 1 : 1
	//r -> l: 1->0 : 0

	panner = Clip.kr([ (1 - pan), pan, (1 + pan), (-1 * pan)], 0, 1);
	panout = [Mix.ar(output * [panner[0], panner[3]]), Mix.ar(output * [panner[1], panner[2]])];


	output = panout*env*amp;
	//output = Pan2.ar(output,pan);
	Out.ar(out,output);
}).add;

SynthDef(\dxkTNobuStutM, {|buf, t_trig = 1, dur = 0.25, loc = 0, rate = 1, stut = 0,
	maxdelay = 1, stutlen = 0.1, amp = 1, pan = 0,  ramp = 0.001,  stutramp = 0.001, relabs = 0, out = 0|
	//stutlen is in real time seconds
	//regular nobu vars
	var output, rdphs,  bufsize, trig, del_trig, real_loc, env, bufrate, startend;
	//stutter vars
	var stutout, delptr, clock, stuttrig, stutenv;
	var gate, delay_trig, clip_dur, trig_dur, ask_dur, buf_dur;
	
	bufsize = BufFrames.ir(buf);
	bufrate = BufRateScale.kr(buf) * rate;
	real_loc = Select.kr(relabs % 2, [loc*bufsize, loc]);
	real_loc = Clip.kr(real_loc, 0, bufsize);
	ask_dur = Select.kr(BinaryOpUGen('>=', rate, 0), [real_loc, bufsize - real_loc]) * (abs(rate*BufSampleRate.kr(buf)).reciprocal);
	clip_dur = Select.kr(dur > 0, [ask_dur, Clip.kr(dur, 0, ask_dur)]);
	delay_trig = DelayN.kr(t_trig, clip_dur, clip_dur);
	gate = SetResetFF.kr(t_trig, delay_trig);
	startend = Select.kr(rate >= 0, [[0, real_loc], [real_loc,bufsize]]);
	rdphs = Phasor.ar(0, bufrate, startend[0], startend[1], real_loc);
	env = EnvGen.ar(Env.asr(ramp,1,ramp),gate, doneAction: 2);
	output = BufRd.ar(1, buf, rdphs);
	//now the stuttering stuff
	stuttrig = HPZ1.kr(stut);
	clock = Phasor.ar(stuttrig, stutlen.reciprocal/SampleRate.ir);
	clock = (clock - Delay1.ar(clock)) < 0;
	delptr = Clip.ar(Sweep.ar(stuttrig), 0, maxdelay);
	delptr = Latch.ar(delptr, clock);
	stutenv = EnvGen.ar(Env.asr(stutramp, 1, stutramp), clock);
	stutout = DelayL.ar(output, maxdelay, delptr);
	output = XFade2.ar(output, stutout, Lag.kr(stut*2-1, stutramp));
	output = output*env*amp;
	output = Pan2.ar(output, pan);
	Out.ar(out,output);

}).add;

SynthDef(\dxkTNobuStutS, {|buf, t_trig = 1, dur = 0.25, loc = 0, rate = 1, stut = 0,
	maxdelay = 1, stutlen = 0.1, amp = 1,  ramp = 0.001, stutramp = 0.001, relabs = 0, pan = 0, out = 0|
	//stutlen is in real time seconds
	//regular nobu vars
	var output, rdphs,  bufsize, trig, del_trig, real_loc, env, bufrate, startend;
	//stutter vars
	var stutout, delptr, clock, stuttrig, stutenv;
	var panout, panner;
	var gate, delay_trig, clip_dur, trig_dur, ask_dur, buf_dur;

	bufsize = BufFrames.ir(buf);
	bufrate = BufRateScale.kr(buf) * rate;
	real_loc = Select.kr(relabs % 2, [loc*bufsize, loc]);
	real_loc = Clip.kr(real_loc, 0, bufsize);
	ask_dur = Select.kr(BinaryOpUGen('>=', rate, 0), [real_loc, bufsize - real_loc]) * (abs(rate*BufSampleRate.kr(buf)).reciprocal);
	clip_dur = Select.kr(dur > 0, [ask_dur, Clip.kr(dur, 0, ask_dur)]);
	delay_trig = DelayN.kr(t_trig, clip_dur, clip_dur);
	gate = SetResetFF.kr(t_trig, delay_trig);
	startend = Select.kr(rate >= 0, [[0, real_loc], [real_loc,bufsize]]);
	rdphs = Phasor.ar(0, bufrate, startend[0], startend[1], real_loc);
	env = EnvGen.ar(Env.asr(ramp,1,ramp),gate, doneAction: 2);
	output = BufRd.ar(2, buf, rdphs);
	//now the stuttering stuff
	stuttrig = HPZ1.kr(stut);
	clock = Phasor.ar(stuttrig, stutlen.reciprocal/SampleRate.ir);
	clock = (clock - Delay1.ar(clock)) < 0;
	delptr = Clip.ar(Sweep.ar(stuttrig), 0, maxdelay);
	delptr = Latch.ar(delptr, clock);
	stutenv = EnvGen.ar(Env.asr(stutramp, 1, stutramp), clock);
	stutout = DelayL.ar(output, maxdelay, delptr);
	output = XFade2.ar(output, stutout, Lag.kr(stut*2-1, stutramp));

	//l -> l: 1 : 1 -> 0
	//l -> r: 0 : 0 -> 1
	//r -> r: 0 -> 1 : 1
	//r -> l: 1->0 : 0

	panner = Clip.kr([ (1 - pan), pan, (1 + pan), (-1 * pan)], 0, 1);
	panout = [Mix.ar(output * [panner[0], panner[3]]), Mix.ar(output * [panner[1], panner[2]])];

	
	output = panout*env*amp;

	//output = Pan2.ar(output, pan);
	Out.ar(out,output);

}).add;


//gated version (getting to be complicated, i know)

SynthDef(\dxkGNobuM, {|buf, gate = 1, loc = 0, rate = 1, amp = 1, pan = 0,  ramp = 0.001, relabs = 0,  out = 0|
	var output, rdphs,  bufsize, trig, del_trig, real_loc, env, bufrate, startend;
	
	bufsize = BufFrames.ir(buf);
	bufrate = BufRateScale.kr(buf) * rate;
	real_loc = Select.kr(relabs % 2, [loc*bufsize, loc]);
	real_loc = Clip.kr(real_loc, 0, bufsize);
	startend = Select.kr(rate >= 0, [[0, real_loc], [real_loc,bufsize]]);
	rdphs = Phasor.ar(0, bufrate, startend[0], startend[1], real_loc);
	env = EnvGen.ar(Env.asr(ramp,1,ramp),gate, doneAction: 2);
	output = BufRd.ar(1, buf, rdphs);
	output = output*env*amp;
	output = Pan2.ar(output, pan);
	Out.ar(out,output);
}).add;


SynthDef(\dxkGNobuS, {|buf, gate = 1, loc = 0,  ramp = 0.001, rate = 1, amp = 1, pan = 0, relabs = 0, out = 0|
	var output, rdphs, bufsize, trig, del_trig, real_loc, env,  panner, panout, bufrate, startend;
	
	bufsize = BufFrames.ir(buf);
	bufrate = BufRateScale.kr(buf) * rate;
	real_loc = Select.kr(relabs % 2, [loc*bufsize, loc]);
	real_loc = Clip.kr(real_loc, 0, bufsize);
	startend = Select.kr(rate >= 0, [[0, real_loc], [real_loc,bufsize]]);
	rdphs = Phasor.ar(0, bufrate, startend[0], startend[1], real_loc);
	env = EnvGen.ar(Env.asr(ramp,1,ramp),gate, doneAction: 2);
	output = BufRd.ar(2, buf, rdphs);


	//l -> l: 1 : 1 -> 0
	//l -> r: 0 : 0 -> 1
	//r -> r: 0 -> 1 : 1
	//r -> l: 1->0 : 0

	panner = Clip.kr([ (1 - pan), pan, (1 + pan), (-1 * pan)], 0, 1);
	panout = [Mix.ar(output * [panner[0], panner[3]]), Mix.ar(output * [panner[1], panner[2]])];


	output = panout*env*amp;
	//output = Pan2.ar(output,pan);
	Out.ar(out,output);
}).add;

SynthDef(\dxkGNobuStutM, {|buf, gate = 1,loc = 0, rate = 1, stut = 0,
	maxdelay = 1, stutlen = 0.1, amp = 1, pan = 0,  ramp = 0.001,  stutramp = 0.001, relabs = 0, out = 0|
	//stutlen is in real time seconds
	//regular nobu vars
	var output, rdphs,  bufsize, trig, del_trig, real_loc, env, bufrate, startend;
	//stutter vars
	var stutout, delptr, clock, stuttrig, stutenv;
	
	bufsize = BufFrames.ir(buf);
	bufrate = BufRateScale.kr(buf) * rate;
	real_loc = Select.kr(relabs % 2, [loc*bufsize, loc]);
	real_loc = Clip.kr(real_loc, 0, bufsize);
	startend = Select.kr(rate >= 0, [[0, real_loc], [real_loc,bufsize]]);
	rdphs = Phasor.ar(0, bufrate, startend[0], startend[1], real_loc);
	env = EnvGen.ar(Env.asr(ramp,1,ramp),gate, doneAction: 2);
	output = BufRd.ar(1, buf, rdphs);
	//now the stuttering stuff
	stuttrig = HPZ1.kr(stut);
	clock = Phasor.ar(stuttrig, stutlen.reciprocal/SampleRate.ir);
	clock = (clock - Delay1.ar(clock)) < 0;
	delptr = Clip.ar(Sweep.ar(stuttrig), 0, maxdelay);
	delptr = Latch.ar(delptr, clock);
	stutenv = EnvGen.ar(Env.asr(stutramp, 1, stutramp), clock);
	stutout = DelayL.ar(output, maxdelay, delptr);
	output = XFade2.ar(output, stutout, Lag.kr(stut*2-1, stutramp));
	output = output*env*amp;
	output = Pan2.ar(output, pan);
	Out.ar(out,output);

}).add;

SynthDef(\dxkTNobuStutS, {|buf, gate = 1, loc = 0, rate = 1, stut = 0,
	maxdelay = 1, stutlen = 0.1, amp = 1,  ramp = 0.001, stutramp = 0.001, relabs = 0, pan = 0, out = 0|
	//stutlen is in real time seconds
	//regular nobu vars
	var output, rdphs,  bufsize, trig, del_trig, real_loc, env, bufrate, startend;
	//stutter vars
	var stutout, delptr, clock, stuttrig, stutenv;
	var panout, panner;

	bufsize = BufFrames.ir(buf);
	bufrate = BufRateScale.kr(buf) * rate;
	real_loc = Select.kr(relabs % 2, [loc*bufsize, loc]);
	real_loc = Clip.kr(real_loc, 0, bufsize);
	startend = Select.kr(rate >= 0, [[0, real_loc], [real_loc,bufsize]]);
	rdphs = Phasor.ar(0, bufrate, startend[0], startend[1], real_loc);
	env = EnvGen.ar(Env.asr(ramp,1,ramp),gate, doneAction: 2);
	output = BufRd.ar(2, buf, rdphs);
	//now the stuttering stuff
	stuttrig = HPZ1.kr(stut);
	clock = Phasor.ar(stuttrig, stutlen.reciprocal/SampleRate.ir);
	clock = (clock - Delay1.ar(clock)) < 0;
	delptr = Clip.ar(Sweep.ar(stuttrig), 0, maxdelay);
	delptr = Latch.ar(delptr, clock);
	stutenv = EnvGen.ar(Env.asr(stutramp, 1, stutramp), clock);
	stutout = DelayL.ar(output, maxdelay, delptr);
	output = XFade2.ar(output, stutout, Lag.kr(stut*2-1, stutramp));

	//l -> l: 1 : 1 -> 0
	//l -> r: 0 : 0 -> 1
	//r -> r: 0 -> 1 : 1
	//r -> l: 1->0 : 0

	panner = Clip.kr([ (1 - pan), pan, (1 + pan), (-1 * pan)], 0, 1);
	panout = [Mix.ar(output * [panner[0], panner[3]]), Mix.ar(output * [panner[1], panner[2]])];

	
	output = panout*env*amp;

	//output = Pan2.ar(output, pan);
	Out.ar(out,output);

}).add;