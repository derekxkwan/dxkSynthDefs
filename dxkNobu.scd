//sample chopper, loc = location between 0 and 1
//relabs = relative: number between 0-1 for pos in buffer (0), absolute: sample number(1)
//revadj = for fixed-len triggering: adjust location when rate < 0 so sound is same chunk as forwards (just reversed) instead of starting at loc

//for use with patterns
SynthDef(\dxkPNobuM, {|buf, gate = 1, loc = 0, rate = 1, amp = 1, pan = 0,  ramp = 0.001, relabs = 0,  out = 0, revadj = 1, dur = 0.25|
	var output, rdphs, bufsize, trig, del_trig, real_loc, env, bufrate, startend, bufscaledsr;
	bufsize = BufFrames.kr(buf);
	bufrate = BufRateScale.kr(buf)*rate;

	bufscaledsr = abs(rate)*BufSampleRate.kr(buf);
	real_loc = Select.kr(relabs % 2, [loc*bufsize, loc]);
	real_loc = Select.kr(((-1*rate) * revadj) > 0, [real_loc, real_loc + (dur*bufscaledsr)]);
	real_loc = Clip.kr(real_loc, 0, bufsize);
	
	startend = Select.kr(rate >= 0, [[0, real_loc], [real_loc,bufsize]]);
	rdphs = Phasor.ar(0, bufrate, startend[0], startend[1], real_loc);
	env = EnvGen.ar(Env.asr(ramp,1,ramp),gate, doneAction: 2);
	output = BufRd.ar(1, buf, rdphs);
	output = output*env*amp;
	output = Pan2.ar(output, pan);
	Out.ar(out,output);
}).add;

SynthDef(\dxkPNobuS, {|buf, gate = 1, loc = 0,  ramp = 0.001, rate = 1, amp = 1, pan = 0, relabs = 0, out = 0, revadj = 1, dur = 0.25|
	var output, rdphs, bufsize, trig, del_trig, real_loc, env, panner, panout, bufrate, startend, bufscaledsr;
	bufsize = BufFrames.kr(buf);
	bufrate = BufRateScale.kr(buf) * rate;
	bufscaledsr = abs(rate)*BufSampleRate.kr(buf);
	real_loc = Select.kr(relabs % 2, [loc*bufsize, loc]);
	real_loc = Select.kr(((-1*rate) * revadj) > 0, [real_loc, real_loc + (dur*bufscaledsr)]);
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
	maxdelay = 1, stutlen = 0.1, amp = 1, pan = 0,  ramp = 0.001,  stutramp = 0.001, relabs = 0, out = 0, revadj = 1, dur = 0.25|
	//stutlen is in real time seconds
	//regular nobu vars
	var output, rdphs, bufsize, trig, del_trig, real_loc, env, bufrate, startend, bufscaledsr;
	//stutter vars
	var stutout, delptr, clock, stuttrig, stutenv;
	bufsize = BufFrames.kr(buf);
	bufrate = BufRateScale.kr(buf)*rate;
	bufscaledsr = abs(rate)*BufSampleRate.kr(buf);
	real_loc = Select.kr(relabs % 2, [loc*bufsize, loc]);
	real_loc = Select.kr(((-1*rate) * revadj) > 0, [real_loc, real_loc + (dur*bufscaledsr)]);
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
	maxdelay = 1, stutlen = 0.1, amp = 1,  ramp = 0.001, stutramp = 0.001, relabs = 0, pan = 0, out = 0, revadj = 1, dur = 0.25|
	//stutlen is in real time seconds
	//regular nobu vars
	var output, rdphs,bufsize, trig, del_trig, real_loc, env, bufrate, startend, bufscaledsr;
	//stutter vars
	var stutout, delptr, clock, stuttrig, stutenv;
	var panout, panner;
	
	bufsize = BufFrames.kr(buf);
	bufrate = BufRateScale.kr(buf) * rate;
	bufscaledsr = abs(rate)*BufSampleRate.kr(buf);
	real_loc = Select.kr(relabs % 2, [loc*bufsize, loc]);
	real_loc = Select.kr(((-1*rate) * revadj) > 0, [real_loc, real_loc + (dur*bufscaledsr)]);
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
	bufsize = BufFrames.kr(buf);
	real_loc = Select.kr(relabs % 2, [loc*bufsize, loc]);
	real_loc = Clip.kr(real_loc, 0, bufsize);
	bufrate = BufRateScale.kr(buf) * rate;
	startend = Select.kr(rate >= 0, [[0, real_loc], [real_loc,bufsize]]);
	rdphs = Phasor.ar(trig, bufrate, startend[0], startend[1], real_loc);
	env = EnvGen.ar(Env.asr(ramp,1,ramp),gate);
	output = BufRd.ar(1, buf, rdphs);
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
	bufsize = BufFrames.kr(buf);
	bufrate = BufRateScale.kr(buf) * rate;
	real_loc = Select.kr(relabs % 2, [loc*bufsize, loc]);
	real_loc = Clip.kr(real_loc, 0, bufsize);
	startend = Select.kr(rate >= 0, [[0, real_loc], [real_loc,bufsize]]);
	rdphs = Phasor.ar(trig, bufrate, startend[0], startend[1], real_loc);
	env = EnvGen.ar(Env.asr(ramp,1,ramp),gate);
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
	bufsize = BufFrames.kr(buf);
	bufrate = BufRateScale.kr(buf) * rate;
	real_loc = Select.kr(relabs % 2, [loc*bufsize, loc]);
	real_loc = Clip.kr(real_loc, 0, bufsize);
	startend = Select.kr(rate >= 0, [[0, real_loc], [real_loc,bufsize]]);
	rdphs = Phasor.ar(trig, bufrate, startend[0], startend[1], real_loc);
	env = EnvGen.ar(Env.asr(ramp,1,ramp),gate);
	output = BufRd.ar(2, buf, rdphs);

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
	bufsize = BufFrames.kr(buf);
	bufrate = BufRateScale.kr(buf) * rate;
	real_loc = Select.kr(relabs % 2, [loc*bufsize, loc]);
	real_loc = Clip.kr(real_loc, 0, bufsize);
	startend = Select.kr(rate >= 0, [[0, real_loc], [real_loc,bufsize]]);
	rdphs = Phasor.ar(trig, bufrate, startend[0], startend[1], real_loc);
	env = EnvGen.ar(Env.asr(ramp,1,ramp),gate);
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



//for triggering

SynthDef(\dxkTNobuM, {|buf, t_trig = 1, len = 0.25, loc = 0, rate = 1, amp = 1, pan = 0,  ramp = 0.001, relabs = 0,  out = 0, revadj = 1|
	var output, rdphs,  bufsize, trig, del_trig, real_loc, env, bufrate, startend;
	var gate, delay_trig, clip_len, trig_len, ask_len, buf_len, bufscaledsr;
	
	bufsize = BufFrames.kr(buf);
	bufrate = BufRateScale.kr(buf) * rate;
	real_loc = Select.kr(relabs % 2, [loc*bufsize, loc]);
	bufscaledsr = abs(rate)*BufSampleRate.kr(buf);
	ask_len = Select.kr(BinaryOpUGen('>=', rate, 0), [real_loc, bufsize - real_loc]) * (bufscaledsr.reciprocal);
	clip_len = Select.kr(len > 0, [ask_len, Clip.kr(len, 0, ask_len)]);
	delay_trig =  DelayN.kr(t_trig, clip_len, clip_len);
	gate = SetResetFF.kr(t_trig, delay_trig);
	real_loc = Select.kr(((-1*rate) * revadj) > 0, [real_loc, real_loc + (len*bufscaledsr)]);
	real_loc = Clip.kr(real_loc, 0, bufsize);
	startend = Select.kr(rate >= 0, [[0, real_loc], [real_loc,bufsize]]);
	rdphs = Phasor.ar(t_trig, bufrate, startend[0], startend[1], real_loc);
	env = EnvGen.ar(Env.asr(ramp,1,ramp),gate, doneAction: 2);
	output = BufRd.ar(1, buf, rdphs);
	output = output*env*amp;
	output = Pan2.ar(output, pan);
	Out.ar(out,output);
}).add;

SynthDef(\dxkTNobuS, {|buf, t_trig = 1, len = 0.25, loc = 0,  ramp = 0.001, rate = 1, amp = 1, pan = 0, relabs = 0, out = 0, revadj = 1|
	var output, rdphs, bufsize, trig, del_trig, real_loc, env,  panner, panout, bufrate, startend;
	var gate, delay_trig, clip_len, trig_len, ask_len, buf_len, bufscaledsr;
	
	bufsize = BufFrames.kr(buf);
	bufrate = BufRateScale.kr(buf) * rate;
	real_loc = Select.kr(relabs % 2, [loc*bufsize, loc]);
	bufscaledsr = abs(rate)*BufSampleRate.kr(buf);
	ask_len = Select.kr(BinaryOpUGen('>=', rate, 0), [real_loc, bufsize - real_loc]) * (bufscaledsr.reciprocal);
	clip_len = Select.kr(len > 0, [ask_len, Clip.kr(len, 0, ask_len)]);
	delay_trig =  DelayN.kr(t_trig, clip_len, clip_len);
	gate = SetResetFF.kr(t_trig, delay_trig);
	real_loc = Select.kr(((-1*rate) * revadj) > 0, [real_loc, real_loc + (len*bufscaledsr)]);
	real_loc = Clip.kr(real_loc, 0, bufsize);
	startend = Select.kr(rate >= 0, [[0, real_loc], [real_loc,bufsize]]);
	rdphs = Phasor.ar(t_trig, bufrate, startend[0], startend[1], real_loc);
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

SynthDef(\dxkTNobuStutM, {|buf, t_trig = 1, len = 0.25, loc = 0, rate = 1, stut = 0,
	maxdelay = 1, stutlen = 0.1, amp = 1, pan = 0,  ramp = 0.001,  stutramp = 0.001, relabs = 0, out = 0, revadj = 1|
	//stutlen is in real time seconds
	//regular nobu vars
	var output, rdphs,  bufsize, trig, del_trig, real_loc, env, bufrate, startend;
	//stutter vars
	var stutout, delptr, clock, stuttrig, stutenv;
	var gate, delay_trig, clip_len, trig_len, ask_len, buf_len, bufscaledsr;
	
	bufsize = BufFrames.kr(buf);
	bufrate = BufRateScale.kr(buf) * rate;
	real_loc = Select.kr(relabs % 2, [loc*bufsize, loc]);
	bufscaledsr = abs(rate)*BufSampleRate.kr(buf);
	ask_len = Select.kr(BinaryOpUGen('>=', rate, 0), [real_loc, bufsize - real_loc]) * (bufscaledsr.reciprocal);
	clip_len = Select.kr(len > 0, [ask_len, Clip.kr(len, 0, ask_len)]);
	delay_trig =  DelayN.kr(t_trig, clip_len, clip_len);
	gate = SetResetFF.kr(t_trig, delay_trig);
	real_loc = Select.kr(((-1*rate) * revadj) > 0, [real_loc, real_loc + (len*bufscaledsr)]);
	real_loc = Clip.kr(real_loc, 0, bufsize);
	startend = Select.kr(rate >= 0, [[0, real_loc], [real_loc,bufsize]]);
	rdphs = Phasor.ar(t_trig, bufrate, startend[0], startend[1], real_loc);
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

SynthDef(\dxkTNobuStutS, {|buf, t_trig = 1, len = 0.25, loc = 0, rate = 1, stut = 0,
	maxdelay = 1, stutlen = 0.1, amp = 1,  ramp = 0.001, stutramp = 0.001, relabs = 0, pan = 0, out = 0, revadj = 1|
	//stutlen is in real time seconds
	//regular nobu vars
	var output, rdphs,  bufsize, trig, del_trig, real_loc, env, bufrate, startend;
	//stutter vars
	var stutout, delptr, clock, stuttrig, stutenv;
	var panout, panner;
	var gate, delay_trig, clip_len, trig_len, ask_len, buf_len, bufscaledsr;

	bufsize = BufFrames.kr(buf);
	bufrate = BufRateScale.kr(buf) * rate;
	real_loc = Select.kr(relabs % 2, [loc*bufsize, loc]);
	bufscaledsr = abs(rate)*BufSampleRate.kr(buf);
	ask_len = Select.kr(BinaryOpUGen('>=', rate, 0), [real_loc, bufsize - real_loc]) * (bufscaledsr.reciprocal);
	clip_len = Select.kr(len > 0, [ask_len, Clip.kr(len, 0, ask_len)]);
	delay_trig =  DelayN.kr(t_trig, clip_len, clip_len);
	gate = SetResetFF.kr(t_trig, delay_trig);
	real_loc = Select.kr(((-1*rate) * revadj) > 0, [real_loc, real_loc + (len*bufscaledsr)]);
	real_loc = Clip.kr(real_loc, 0, bufsize);
	startend = Select.kr(rate >= 0, [[0, real_loc], [real_loc,bufsize]]);
	rdphs = Phasor.ar(t_trig, bufrate, startend[0], startend[1], real_loc);
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
	
	bufsize = BufFrames.kr(buf);
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
	
	bufsize = BufFrames.kr(buf);
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
	
	bufsize = BufFrames.kr(buf);
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

SynthDef(\dxkGNobuStutS, {|buf, gate = 1, loc = 0, rate = 1, stut = 0,
	maxdelay = 1, stutlen = 0.1, amp = 1,  ramp = 0.001, stutramp = 0.001, relabs = 0, pan = 0, out = 0|
	//stutlen is in real time seconds
	//regular nobu vars
	var output, rdphs,  bufsize, trig, del_trig, real_loc, env, bufrate, startend;
	//stutter vars
	var stutout, delptr, clock, stuttrig, stutenv;
	var panout, panner;

	bufsize = BufFrames.kr(buf);
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


// WARPER VERSIONS ==================


//for use with patterns
SynthDef(\dxkPWNobuM, {|buf, gate = 1, loc = 0, rate = 1, amp = 1, pan = 0,  ramp = 0.001, relabs = 0,  out = 0, revadj = 1, dur = 0.25,
		freqscale = 1, winsize = 0.1, envbufnum = -1, overlap = 8, winrand = 0.5, interp = 2|

	var output, rdphs, bufsize, trig, del_trig, env, startend;

	var rel_loc, bufdur;
	
	bufsize = BufFrames.kr(buf);
	bufdur = BufDur.kr(buf);
	rel_loc = Select.kr(relabs % 2, [loc, loc/bufsize]);
	rel_loc = Select.kr(((-1*rate) * revadj) > 0, [rel_loc, rel_loc + (dur * rate/bufdur)]);
	rel_loc = Clip.kr(rel_loc, 0, 1);
	startend = Select.kr(rate >= 0, [[0, rel_loc], [rel_loc,1]]);
	rdphs = Phasor.ar(0, (rate * BufRateScale.kr(buf))/bufsize, startend[0], startend[1], rel_loc);
	env = EnvGen.ar(Env.asr(ramp,1,ramp),gate, doneAction: 2);
	output = Warp1.ar(1, buf, rdphs, freqscale, winsize, envbufnum, overlap, winrand, interp);
	output = output*env*amp;
	output = Pan2.ar(output, pan);
	Out.ar(out,output);
}).add;

SynthDef(\dxkPWNobuS, {|buf, gate = 1, loc = 0,  ramp = 0.001, rate = 1, amp = 1, pan = 0, relabs = 0, out = 0, revadj = 1, dur = 0.25,
			freqscale = 1, winsize = 0.1, envbufnum = -1, overlap = 8, winrand = 0.5, interp = 2|

	var output, rdphs, bufsize, trig, del_trig, env, panner, panout, startend;
	var rel_loc, bufdur;
	
	bufsize = BufFrames.kr(buf);
	bufdur = BufDur.kr(buf);
	rel_loc = Select.kr(relabs % 2, [loc, loc/bufsize]);
	rel_loc = Select.kr(((-1*rate) * revadj) > 0, [rel_loc, rel_loc + (dur * rate/bufdur)]);
	rel_loc = Clip.kr(rel_loc, 0, 1);
	startend = Select.kr(rate >= 0, [[0, rel_loc], [rel_loc,1]]);
	rdphs = Phasor.ar(0, (rate * BufRateScale.kr(buf))/bufsize, startend[0], startend[1], rel_loc);
	env = EnvGen.ar(Env.asr(ramp,1,ramp),gate, doneAction: 2);
	output = Warp1.ar(2, buf, rdphs, freqscale, winsize, envbufnum, overlap, winrand, interp);


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


SynthDef(\dxkPWNobuStutM, {|buf, gate = 1, loc = 0, rate = 1, stut = 0,
	maxdelay = 1, stutlen = 0.1, amp = 1, pan = 0,  ramp = 0.001,  stutramp = 0.001, relabs = 0, out = 0, revadj = 1, dur = 0.25,
	freqscale = 1, winsize = 0.1, envbufnum = -1, overlap = 8, winrand = 0.5, interp = 2|

	//stutlen is in real time seconds
	//regular nobu vars
	var output, rdphs, bufsize, trig, del_trig, env,startend;
	//stutter vars
	var stutout, delptr, clock, stuttrig, stutenv;

	var rel_loc, bufdur;
	
	bufsize = BufFrames.kr(buf);
	bufdur = BufDur.kr(buf);
	rel_loc = Select.kr(relabs % 2, [loc, loc/bufsize]);
	rel_loc = Select.kr(((-1*rate) * revadj) > 0, [rel_loc, rel_loc + (dur * rate/bufdur)]);
	rel_loc = Clip.kr(rel_loc, 0, 1);
	startend = Select.kr(rate >= 0, [[0, rel_loc], [rel_loc,1]]);
	rdphs = Phasor.ar(0, (rate * BufRateScale.kr(buf))/bufsize, startend[0], startend[1], rel_loc);
	env = EnvGen.ar(Env.asr(ramp,1,ramp),gate, doneAction: 2);
	output = Warp1.ar(1, buf, rdphs, freqscale, winsize, envbufnum, overlap, winrand, interp);
	
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

SynthDef(\dxkPWNobuStutS, {|buf, gate = 1, loc = 0, rate = 1, stut = 0,
	maxdelay = 1, stutlen = 0.1, amp = 1,  ramp = 0.001, stutramp = 0.001, relabs = 0, pan = 0, out = 0, revadj = 1, dur = 0.25,
	freqscale = 1, winsize = 0.1, envbufnum = -1, overlap = 8, winrand = 0.5, interp = 2|

	//stutlen is in real time seconds
	//regular nobu vars
	var output, rdphs,bufsize, trig, del_trig, env, startend;
	//stutter vars
	var stutout, delptr, clock, stuttrig, stutenv;
	var panout, panner;

	var rel_loc, bufdur;
	
	bufsize = BufFrames.kr(buf);
	bufdur = BufDur.kr(buf);
	rel_loc = Select.kr(relabs % 2, [loc, loc/bufsize]);
	rel_loc = Select.kr(((-1*rate) * revadj) > 0, [rel_loc, rel_loc + (dur * rate/bufdur)]);
	rel_loc = Clip.kr(rel_loc, 0, 1);
	startend = Select.kr(rate >= 0, [[0, rel_loc], [rel_loc,1]]);
	rdphs = Phasor.ar(0, (rate * BufRateScale.kr(buf))/bufsize, startend[0], startend[1], rel_loc);
	env = EnvGen.ar(Env.asr(ramp,1,ramp),gate, doneAction: 2);
	output = Warp1.ar(2, buf, rdphs, freqscale, winsize, envbufnum, overlap, winrand, interp);
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
SynthDef(\dxkWNobuM, {|buf, t_trig = 1, loc = -1, rate = 1, out = 0, amp = 1,  ramp = 0.001, relabs = 0,
	freqscale = 1, winsize = 0.1, envbufnum = -1, overlap = 8, winrand = 0.5, interp = 2|

	var output, rdphs, bufsize, trig, del_trig,  env, gate, startend;

	var rel_loc, bufdur;
	
	
	trig = HPZ1.kr(loc);
	trig = (trig < 0) + (trig > 0) +t_trig;
	del_trig = TDelay.kr(trig, ramp);
	gate = SetResetFF.kr(del_trig, trig);
	bufsize = BufFrames.kr(buf);
	bufdur = BufDur.kr(buf);
	rel_loc = Select.kr(relabs % 2, [loc, loc/bufsize]);
	rel_loc = Clip.kr(rel_loc, 0, 1);
	startend = Select.kr(rate >= 0, [[0, rel_loc], [rel_loc,1]]);
	rdphs = Phasor.ar(trig, (rate * BufRateScale.kr(buf))/bufsize, startend[0], startend[1], rel_loc);
	env = EnvGen.ar(Env.asr(ramp,1,ramp),gate);
	output = Warp1.ar(1, buf, rdphs, freqscale, winsize, envbufnum, overlap, winrand, interp);
	
	output = output * env * amp;
	Out.ar(out, output);
}).add;



SynthDef(\dxkWNobuStutM, {|buf, t_trig = 1, loc = -1, rate = 1, stut = 0,
	maxdelay = 1, stutlen = 0.1, amp = 1, ramp = 0.001, stutramp = 0.001, relabs = 0, out = 0,
	freqscale = 1, winsize = 0.1, envbufnum = -1, overlap = 8, winrand = 0.5, interp = 2|

	//stutlen is in real time seconds
	//regular nobu vars
	var output, rdphs, bufsize, trig, del_trig, env, gate, startend;
	//stutter vars
	var stutout, delptr, clock, stuttrig, stutenv;

	var rel_loc, bufdur;
	
	
	trig = HPZ1.kr(loc);
	trig = (trig < 0) + (trig > 0) +t_trig;
	del_trig = TDelay.kr(trig, ramp);
	gate = SetResetFF.kr(del_trig, trig);
	bufsize = BufFrames.kr(buf);
	bufdur = BufDur.kr(buf);
	rel_loc = Select.kr(relabs % 2, [loc, loc/bufsize]);
	rel_loc = Clip.kr(rel_loc, 0, 1);
	startend = Select.kr(rate >= 0, [[0, rel_loc], [rel_loc,1]]);
	rdphs = Phasor.ar(trig, (rate * BufRateScale.kr(buf))/bufsize, startend[0], startend[1], rel_loc);
	env = EnvGen.ar(Env.asr(ramp,1,ramp),gate);
	output = Warp1.ar(1, buf, rdphs, freqscale, winsize, envbufnum, overlap, winrand, interp);
	
	
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


SynthDef(\dxkWNobuS, {|buf, t_trig = 1, loc = -1, rate = 1, ramp = 0.001, relabs = 0, pan = 0, amp = 1, out = 0,
	freqscale = 1, winsize = 0.1, envbufnum = -1, overlap = 8, winrand = 0.5, interp = 2|

	var output, rdphs, bufsize, trig, del_trig, env, gate, startend;
	var panout, panner;
	
	var rel_loc, bufdur;
	
	
	trig = HPZ1.kr(loc);
	trig = (trig < 0) + (trig > 0) +t_trig;
	del_trig = TDelay.kr(trig, ramp);
	gate = SetResetFF.kr(del_trig, trig);
	bufsize = BufFrames.kr(buf);
	bufdur = BufDur.kr(buf);
	rel_loc = Select.kr(relabs % 2, [loc, loc/bufsize]);
	rel_loc = Clip.kr(rel_loc, 0, 1);
	startend = Select.kr(rate >= 0, [[0, rel_loc], [rel_loc,1]]);
	rdphs = Phasor.ar(trig, (rate * BufRateScale.kr(buf))/bufsize, startend[0], startend[1], rel_loc);
	env = EnvGen.ar(Env.asr(ramp,1,ramp),gate);
	output = Warp1.ar(2, buf, rdphs, freqscale, winsize, envbufnum, overlap, winrand, interp);

	//l -> l: 1 : 1 -> 0
	//l -> r: 0 : 0 -> 1
	//r -> r: 0 -> 1 : 1
	//r -> l: 1->0 : 0

	panner = Clip.kr([ (1 - pan), pan, (1 + pan), (-1 * pan)], 0, 1);
	panout = [Mix.ar(output * [panner[0], panner[3]]), Mix.ar(output * [panner[1], panner[2]])];


	output = panout*env*amp;

	Out.ar(out, output);
}).add;



SynthDef(\dxkWNobuStutS, {|buf, t_trig = 1, loc = -1, rate = 1,  stut = 0,
	maxdelay = 1, stutlen = 0.1, amp = 1, ramp = 0.001, stutramp = 0.001, relabs = 0, pan = 0, out = 0,
	freqscale = 1, winsize = 0.1, envbufnum = -1, overlap = 8, winrand = 0.5, interp = 2|

	//stutlen is in real time seconds
	//regular nobu vars
	var output, rdphs,bufsize, trig, del_trig, env, gate, startend;
	//stutter vars
	var stutout, delptr, clock, stuttrig, stutenv;

	var panout, panner;

	var rel_loc, bufdur;
	
	trig = HPZ1.kr(loc);
	trig = (trig < 0) + (trig > 0) +t_trig;
	del_trig = TDelay.kr(trig, ramp);
	gate = SetResetFF.kr(del_trig, trig);
	bufsize = BufFrames.kr(buf);
	bufdur = BufDur.kr(buf);
	rel_loc = Select.kr(relabs % 2, [loc, loc/bufsize]);
	rel_loc = Clip.kr(rel_loc, 0, 1);
	startend = Select.kr(rate >= 0, [[0, rel_loc], [rel_loc,1]]);
	rdphs = Phasor.ar(trig, (rate * BufRateScale.kr(buf))/bufsize, startend[0], startend[1], rel_loc);
	env = EnvGen.ar(Env.asr(ramp,1,ramp),gate);
	output = Warp1.ar(2, buf, rdphs, freqscale, winsize, envbufnum, overlap, winrand, interp);
	
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



//triggered versions


SynthDef(\dxkTWNobuM, {|buf, t_trig = 1, len = 0.25, loc = 0, rate = 1, amp = 1, pan = 0,  ramp = 0.001, relabs = 0,  out = 0, revadj = 1,
	freqscale = 1, winsize = 0.1, envbufnum = -1, overlap = 8, winrand = 0.5, interp = 2|
	
	var output, rdphs,  bufsize, trig, del_trig, env, bufrate, startend;
	var gate, delay_trig, clip_len, trig_len, ask_len, buf_len;
	var rel_loc, bufdur;
	
	bufsize = BufFrames.kr(buf);
	bufdur = BufDur.kr(buf);
	rel_loc = Select.kr(relabs % 2, [loc, loc/bufsize]);
	ask_len = Select.kr(BinaryOpUGen('>=', rate, 0), [rel_loc, 1 - rel_loc]) * bufdur/abs(rate);
	clip_len = Select.kr(len > 0, [ask_len, Clip.kr(len, 0, ask_len)]);
	delay_trig =  DelayN.kr(t_trig, clip_len, clip_len);
	gate = SetResetFF.kr(t_trig, delay_trig);
	rel_loc = Select.kr(((-1*rate) * revadj) > 0, [rel_loc, rel_loc + (len * rate/bufdur)]);
	rel_loc = Clip.kr(rel_loc, 0, 1);
	startend = Select.kr(rate >= 0, [[0, rel_loc], [rel_loc,1]]);
	rdphs = Phasor.ar(t_trig, (rate * BufRateScale.kr(buf))/bufsize, startend[0], startend[1], rel_loc);
	env = EnvGen.ar(Env.asr(ramp,1,ramp),gate, doneAction: 2);
	output = Warp1.ar(1, buf, rdphs, freqscale, winsize, envbufnum, overlap, winrand, interp);
	output = output*env*amp;
	output = Pan2.ar(output, pan);
	Out.ar(out,output);
}).add;

SynthDef(\dxkTWNobuS, {|buf, t_trig = 1, len = 0.25, loc = 0,  ramp = 0.001, rate = 1, amp = 1, pan = 0, relabs = 0, out = 0, revadj = 1,
		freqscale = 1, winsize = 0.1, envbufnum = -1, overlap = 8, winrand = 0.5, interp = 2|
	
	var output, rdphs, bufsize, trig, del_trig,  env,  panner, panout, bufrate, startend;
	var gate, delay_trig, clip_len, trig_len, ask_len, buf_len;	
	var rel_loc, bufdur;
	
	bufsize = BufFrames.kr(buf);
	bufdur = BufDur.kr(buf);
	rel_loc = Select.kr(relabs % 2, [loc, loc/bufsize]);
	ask_len = Select.kr(BinaryOpUGen('>=', rate, 0), [rel_loc, 1 - rel_loc]) * bufdur/abs(rate);
	clip_len = Select.kr(len > 0, [ask_len, Clip.kr(len, 0, ask_len)]);
	delay_trig =  DelayN.kr(t_trig, clip_len, clip_len);
	gate = SetResetFF.kr(t_trig, delay_trig);
	rel_loc = Select.kr(((-1*rate) * revadj) > 0, [rel_loc, rel_loc + (len * rate/bufdur)]);
	rel_loc = Clip.kr(rel_loc, 0, 1);
	startend = Select.kr(rate >= 0, [[0, rel_loc], [rel_loc,1]]);
	rdphs = Phasor.ar(t_trig, (rate * BufRateScale.kr(buf))/bufsize, startend[0], startend[1], rel_loc);
	env = EnvGen.ar(Env.asr(ramp,1,ramp),gate, doneAction: 2);
	output = Warp1.ar(2, buf, rdphs, freqscale, winsize, envbufnum, overlap, winrand, interp);


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


SynthDef(\dxkTWNobuStutM, {|buf, t_trig = 1, len = 0.25, loc = 0, rate = 1, stut = 0,
	maxdelay = 1, stutlen = 0.1, amp = 1, pan = 0,  ramp = 0.001,  stutramp = 0.001, relabs = 0, out = 0, revadj = 1,
	freqscale = 1, winsize = 0.1, envbufnum = -1, overlap = 8, winrand = 0.5, interp = 2|

	//stutlen is in real time seconds
	//regular nobu vars
	var output, rdphs,  bufsize, trig, del_trig,  env, bufrate, startend;
	//stutter vars
	var stutout, delptr, clock, stuttrig, stutenv;
	var gate, delay_trig, clip_len, trig_len, ask_len, buf_len;

	var rel_loc, bufdur;
	
	bufsize = BufFrames.kr(buf);
	bufdur = BufDur.kr(buf);
	rel_loc = Select.kr(relabs % 2, [loc, loc/bufsize]);
	ask_len = Select.kr(BinaryOpUGen('>=', rate, 0), [rel_loc, 1 - rel_loc]) * bufdur/abs(rate);
	clip_len = Select.kr(len > 0, [ask_len, Clip.kr(len, 0, ask_len)]);
	delay_trig =  DelayN.kr(t_trig, clip_len, clip_len);
	gate = SetResetFF.kr(t_trig, delay_trig);
	rel_loc = Select.kr(((-1*rate) * revadj) > 0, [rel_loc, rel_loc + (len * rate/bufdur)]);
	rel_loc = Clip.kr(rel_loc, 0, 1);
	startend = Select.kr(rate >= 0, [[0, rel_loc], [rel_loc,1]]);
	rdphs = Phasor.ar(t_trig, (rate * BufRateScale.kr(buf))/bufsize, startend[0], startend[1], rel_loc);
	env = EnvGen.ar(Env.asr(ramp,1,ramp),gate, doneAction: 2);
	output = Warp1.ar(1, buf, rdphs, freqscale, winsize, envbufnum, overlap, winrand, interp);

	
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

SynthDef(\dxkTWNobuStutS, {|buf, t_trig = 1, len = 0.25, loc = 0, rate = 1, stut = 0,
	maxdelay = 1, stutlen = 0.1, amp = 1,  ramp = 0.001, stutramp = 0.001, relabs = 0, pan = 0, out = 0, revadj = 1,
		freqscale = 1, winsize = 0.1, envbufnum = -1, overlap = 8, winrand = 0.5, interp = 2|

	//stutlen is in real time seconds
	//regular nobu vars
	var output, rdphs,  bufsize, trig, del_trig, env, bufrate, startend;
	//stutter vars
	var stutout, delptr, clock, stuttrig, stutenv;
	var panout, panner;
	var gate, delay_trig, clip_len, trig_len, ask_len, buf_len;
	var rel_loc, bufdur;
	
	bufsize = BufFrames.kr(buf);
	bufdur = BufDur.kr(buf);
	rel_loc = Select.kr(relabs % 2, [loc, loc/bufsize]);
	ask_len = Select.kr(BinaryOpUGen('>=', rate, 0), [rel_loc, 1 - rel_loc]) * bufdur/abs(rate);
	clip_len = Select.kr(len > 0, [ask_len, Clip.kr(len, 0, ask_len)]);
	delay_trig =  DelayN.kr(t_trig, clip_len, clip_len);
	gate = SetResetFF.kr(t_trig, delay_trig);
	rel_loc = Select.kr(((-1*rate) * revadj) > 0, [rel_loc, rel_loc + (len * rate/bufdur)]);
	rel_loc = Clip.kr(rel_loc, 0, 1);
	startend = Select.kr(rate >= 0, [[0, rel_loc], [rel_loc,1]]);
	rdphs = Phasor.ar(t_trig, (rate * BufRateScale.kr(buf))/bufsize, startend[0], startend[1], rel_loc);
	env = EnvGen.ar(Env.asr(ramp,1,ramp),gate, doneAction: 2);
	output = Warp1.ar(2, buf, rdphs, freqscale, winsize, envbufnum, overlap, winrand, interp);

	
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


SynthDef(\dxkGWNobuM, {|buf, gate = 1, loc = 0, rate = 1, amp = 1, pan = 0,  ramp = 0.001, relabs = 0,  out = 0,
			freqscale = 1, winsize = 0.1, envbufnum = -1, overlap = 8, winrand = 0.5, interp = 2|

	var output, rdphs,  bufsize, trig, del_trig,  env, bufrate, startend;

	var rel_loc, bufdur;
	
	bufsize = BufFrames.kr(buf);
	bufdur = BufDur.kr(buf);
	rel_loc = Select.kr(relabs % 2, [loc, loc/bufsize]);
	rel_loc = Clip.kr(rel_loc, 0, 1);
	startend = Select.kr(rate >= 0, [[0, rel_loc], [rel_loc,1]]);
	rdphs = Phasor.ar(0, (rate * BufRateScale.kr(buf))/bufsize, startend[0], startend[1], rel_loc);
	env = EnvGen.ar(Env.asr(ramp,1,ramp),gate, doneAction: 2);
	output = Warp1.ar(1, buf, rdphs, freqscale, winsize, envbufnum, overlap, winrand, interp);
	output = output*env*amp;
	output = Pan2.ar(output, pan);
	//output = Pan2.ar(output,pan);
	Out.ar(out,output);
}).add;

SynthDef(\dxkGWNobuS, {|buf, gate = 1, loc = 0, rate = 1, amp = 1, pan = 0,  ramp = 0.001, relabs = 0,  out = 0,
			freqscale = 1, winsize = 0.1, envbufnum = -1, overlap = 8, winrand = 0.5, interp = 2|

	var output, rdphs,  bufsize, trig, del_trig,  env, bufrate, startend;

	var rel_loc, bufdur;

	var panner, panout;
	
	bufsize = BufFrames.kr(buf);
	bufdur = BufDur.kr(buf);
	rel_loc = Select.kr(relabs % 2, [loc, loc/bufsize]);
	rel_loc = Clip.kr(rel_loc, 0, 1);
	startend = Select.kr(rate >= 0, [[0, rel_loc], [rel_loc,1]]);
	rdphs = Phasor.ar(0, (rate * BufRateScale.kr(buf))/bufsize, startend[0], startend[1], rel_loc);
	env = EnvGen.ar(Env.asr(ramp,1,ramp),gate, doneAction: 2);
	output = Warp1.ar(2, buf, rdphs, freqscale, winsize, envbufnum, overlap, winrand, interp);


	//output = Pan2.ar(output,pan);

		//l -> l: 1 : 1 -> 0
	//l -> r: 0 : 0 -> 1
	//r -> r: 0 -> 1 : 1
	//r -> l: 1->0 : 0

	panner = Clip.kr([ (1 - pan), pan, (1 + pan), (-1 * pan)], 0, 1);
	panout = [Mix.ar(output * [panner[0], panner[3]]), Mix.ar(output * [panner[1], panner[2]])];


	output = panout*env*amp;
	Out.ar(out,output);
}).add;



SynthDef(\dxkGWNobuStutM, {|buf, gate = 1,loc = 0, rate = 1, stut = 0,
	maxdelay = 1, stutlen = 0.1, amp = 1, pan = 0,  ramp = 0.001,  stutramp = 0.001, relabs = 0, out = 0,
	freqscale = 1, winsize = 0.1, envbufnum = -1, overlap = 8, winrand = 0.5, interp = 2|

	//stutlen is in real time seconds
	//regular nobu vars
	var output, rdphs,  bufsize, trig, del_trig, env, bufrate, startend;
	//stutter vars
	var stutout, delptr, clock, stuttrig, stutenv;
	
	var rel_loc, bufdur;
	
	bufsize = BufFrames.kr(buf);
	bufdur = BufDur.kr(buf);
	rel_loc = Select.kr(relabs % 2, [loc, loc/bufsize]);
	rel_loc = Clip.kr(rel_loc, 0, 1);
	startend = Select.kr(rate >= 0, [[0, rel_loc], [rel_loc,1]]);
	rdphs = Phasor.ar(0, (rate * BufRateScale.kr(buf))/bufsize, startend[0], startend[1], rel_loc);
	env = EnvGen.ar(Env.asr(ramp,1,ramp),gate, doneAction: 2);
	output = Warp1.ar(1, buf, rdphs, freqscale, winsize, envbufnum, overlap, winrand, interp);
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

SynthDef(\dxkGWNobuStutS, {|buf, gate = 1, loc = 0, rate = 1, stut = 0,
	maxdelay = 1, stutlen = 0.1, amp = 1,  ramp = 0.001, stutramp = 0.001, relabs = 0, pan = 0, out = 0,
	freqscale = 1, winsize = 0.1, envbufnum = -1, overlap = 8, winrand = 0.5, interp = 2|

	//stutlen is in real time seconds
	//regular nobu vars
	var output, rdphs,  bufsize, trig, del_trig, env, bufrate, startend;
	//stutter vars
	var stutout, delptr, clock, stuttrig, stutenv;
	var panout, panner;

	var rel_loc, bufdur;
	
	bufsize = BufFrames.kr(buf);
	bufdur = BufDur.kr(buf);
	rel_loc = Select.kr(relabs % 2, [loc, loc/bufsize]);
	rel_loc = Clip.kr(rel_loc, 0, 1);
	startend = Select.kr(rate >= 0, [[0, rel_loc], [rel_loc,1]]);
	rdphs = Phasor.ar(0, (rate * BufRateScale.kr(buf))/bufsize, startend[0], startend[1], rel_loc);
	env = EnvGen.ar(Env.asr(ramp,1,ramp),gate, doneAction: 2);
	output = Warp1.ar(2, buf, rdphs, freqscale, winsize, envbufnum, overlap, winrand, interp);

		//l -> l: 1 : 1 -> 0
	//l -> r: 0 : 0 -> 1
	//r -> r: 0 -> 1 : 1
	//r -> l: 1->0 : 0

	panner = Clip.kr([ (1 - pan), pan, (1 + pan), (-1 * pan)], 0, 1);
	panout = [Mix.ar(output * [panner[0], panner[3]]), Mix.ar(output * [panner[1], panner[2]])];

	output = output*env*amp;
	
	Out.ar(out,output);
}).add;
