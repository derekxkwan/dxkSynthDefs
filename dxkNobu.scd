//sample chopper, loc = location between 0 and 1

//for use with patterns

SynthDef(\dxkPNobuM, {|buf, gate = 1, loc = 0, rate = 1, amp = 1, pan = 0,  ramp = 0.001, relabs = 0,  out = 0|
	var output, rdphs, rdphsfor, rdphsback, bufsize, trig, del_trig, real_loc, env;
	bufsize = BufFrames.ir(buf);
	real_loc = Select.kr(relabs % 2, [Clip.kr(loc*bufsize, 0, bufsize), Clip.kr(loc, 0, bufsize)]);
	rdphsfor = Phasor.ar(0, BufRateScale.kr(buf)*rate, real_loc, bufsize, real_loc);
	rdphsback = Phasor.ar(0, BufRateScale.kr(buf)*rate, 0, real_loc, real_loc);
	rdphs = Select.ar(rate >= 0, [rdphsback, rdphsfor]);
	env = EnvGen.ar(Env.asr(ramp,1,ramp),gate, doneAction: 2);
	output = BufRd.ar(1, buf, rdphs);
	output = output*env*amp;
	output = Pan2.ar(output, pan);
	Out.ar(out,output);
}).add;

SynthDef(\dxkPNobuS, {|buf, gate = 1, loc = 0,  ramp = 0.001, rate = 1, amp = 1, pan = 0, relabs = 0, out = 0|
	var output, rdphsfor,rdphsback, rdphs, bufsize, trig, del_trig, real_loc, env, panclip, panner, panout;
	bufsize = BufFrames.ir(buf);
	real_loc = Select.kr(relabs % 2, [Clip.kr(loc*bufsize, 0, bufsize), Clip.kr(loc, 0, bufsize)]);
	rdphsfor = Phasor.ar(0, BufRateScale.kr(buf)*rate, real_loc, bufsize, real_loc);
	rdphsback = Phasor.ar(0, BufRateScale.kr(buf)*rate, 0, real_loc, real_loc);
	rdphs = Select.ar(rate >= 0, [rdphsback, rdphsfor]);
	env = EnvGen.ar(Env.asr(ramp,1,ramp),gate, doneAction: 2);
	output = BufRd.ar(2, buf, rdphs);

	panclip = pan.clip(-1.0,1.0);
		//l-l, l-r, r-r, r-l
	panner = Select.ar(BinaryOpUGen('>=', panclip, 0),
			[
				K2A.ar([1, 0, panclip + 1, panclip * -1]),
				K2A.ar([(1 - panclip), panclip, 1, 0])
			]
			);
	panout = 	[
		(output[0] * panner[0]) +
		(output[1] * panner[3]),
		(output[0] * panner[1]) +
		(output[1] * panner[2])];

	
	output = panout*env*amp;
	//output = Pan2.ar(output,pan);
	Out.ar(out,output);
}).add;

SynthDef(\dxkPNobuStutM, {|buf, gate = 1, loc = 0, rate = 1, stut = 0,
	maxdelay = 1, stutlen = 0.1, amp = 1, pan = 0,  ramp = 0.001,  stutramp = 0.001, relabs = 0, out = 0|
	//stutlen is in real time seconds
	//regular nobu vars
	var output, rdphs, rdphsfor, rdphsback, bufsize, trig, del_trig, real_loc, env;
	//stutter vars
	var stutout, delptr, clock, stuttrig, stutenv;
	bufsize = BufFrames.ir(buf);
	real_loc = Select.kr(relabs % 2, [Clip.kr(loc*bufsize, 0, bufsize), Clip.kr(loc, 0, bufsize)]);
	rdphsfor = Phasor.ar(0, BufRateScale.kr(buf)*rate, real_loc, bufsize, real_loc);
	rdphsback = Phasor.ar(0, BufRateScale.kr(buf)*rate, 0, real_loc, real_loc);
	rdphs = Select.ar(rate >= 0, [rdphsback, rdphsfor]);
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
	var output, rdphs, rdphsfor, rdphsback, bufsize, trig, del_trig, real_loc, env;
	//stutter vars
	var stutout, delptr, clock, stuttrig, stutenv;
	var panclip, panout, panner;
	
	bufsize = BufFrames.ir(buf);
	real_loc = Select.kr(relabs % 2, [Clip.kr(loc*bufsize, 0, bufsize), Clip.kr(loc, 0, bufsize)]);
	rdphsfor = Phasor.ar(0, BufRateScale.kr(buf)*rate, real_loc, bufsize, real_loc);
	rdphsback = Phasor.ar(0, BufRateScale.kr(buf)*rate, 0, real_loc, real_loc);
	rdphs = Select.ar(rate >= 0, [rdphsback, rdphsfor]);
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

	
	panclip = pan.clip(-1.0,1.0);
		//l-l, l-r, r-r, r-l
	panner = Select.ar(BinaryOpUGen('>=', panclip, 0),
			[
				K2A.ar([1, 0, panclip + 1, panclip * -1]),
				K2A.ar([(1 - panclip), panclip, 1, 0])
			]
			);
	panout = 	[
		(output[0] * panner[0]) +
		(output[1] * panner[3]),
		(output[0] * panner[1]) +
		(output[1] * panner[2])];

	
	output = panout*env*amp;

	//output = Pan2.ar(output, pan);
	Out.ar(out,output);

}).add;

//for use outside of patterns
SynthDef(\dxkNobuM, {|buf, t_trig = 1, loc = -1, rate = 1, out = 0, amp = 1,  ramp = 0.001, relabs = 0|
	var output, rdphs, rdphsfor, rdphsback, bufsize, trig, del_trig, real_loc, env, gate;
	trig = HPZ1.kr(loc);
	trig = (trig < 0) + (trig > 0) +t_trig;
	del_trig = TDelay.kr(trig, ramp);
	gate = SetResetFF.kr(del_trig, trig);
	bufsize = BufFrames.ir(buf);
	real_loc = Select.kr(relabs % 2, [Clip.kr(loc*bufsize, 0, bufsize), Clip.kr(loc, 0, bufsize)]);
	rdphsfor = Phasor.ar(del_trig, BufRateScale.kr(buf)*rate, real_loc, bufsize, real_loc);
	rdphsback = Phasor.ar(del_trig, BufRateScale.kr(buf)*rate, 0, real_loc, real_loc);
	rdphs = Select.ar(rate >= 0, [rdphsback, rdphsfor]);
	env = EnvGen.ar(Env.asr(ramp,1,ramp),gate);
	output = BufRd.ar(1, buf, rdphs)*env;
	output = output * env * amp;
	Out.ar(out, output);
}).add;



SynthDef(\dxkNobuStutM, {|buf, t_trig = 1, loc = -1, rate = 1, stut = 0,
	maxdelay = 1, stutlen = 0.1, amp = 1, ramp = 0.001, stutramp = 0.001, relabs = 0, out = 0|
	//stutlen is in real time seconds
	//regular nobu vars
	var output, rdphs, rdphsfor, rdphsback, bufsize, trig, del_trig, real_loc, env, gate;
	//stutter vars
	var stutout, delptr, clock, stuttrig, stutenv;
	trig = HPZ1.kr(loc);
	trig = (trig < 0) + (trig > 0) +t_trig;
	del_trig = TDelay.kr(trig, ramp);
	gate = SetResetFF.kr(del_trig, trig);
	bufsize = BufFrames.ir(buf);
	real_loc = Select.kr(relabs % 2, [Clip.kr(loc*bufsize, 0, bufsize), Clip.kr(loc, 0, bufsize)]);
	rdphsfor = Phasor.ar(del_trig, BufRateScale.kr(buf)*rate, real_loc, bufsize, real_loc);
	rdphsback = Phasor.ar(del_trig, BufRateScale.kr(buf)*rate, 0, real_loc, real_loc);
	rdphs = Select.ar(rate >= 0, [rdphsback, rdphsfor]);
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
	var output, rdphs, rdphsfor, rdphsback, bufsize, trig, del_trig, real_loc, env, gate;
	var panout, panclip, panner;
	
	trig = HPZ1.kr(loc);
	trig = (trig < 0) + (trig > 0) +t_trig;
	del_trig = TDelay.kr(trig, ramp);
	gate = SetResetFF.kr(del_trig, trig);
	bufsize = BufFrames.ir(buf);
	real_loc = Select.kr(relabs % 2, [Clip.kr(loc*bufsize, 0, bufsize), Clip.kr(loc, 0, bufsize)]);
	rdphsfor = Phasor.ar(del_trig, BufRateScale.kr(buf)*rate, real_loc, bufsize, real_loc);
	rdphsback = Phasor.ar(del_trig, BufRateScale.kr(buf)*rate, 0, real_loc, real_loc);
	rdphs = Select.ar(rate >= 0, [rdphsback, rdphsfor]);
	env = EnvGen.ar(Env.asr(ramp,1,ramp),gate);
	output = BufRd.ar(2, buf, rdphs)*env;

	
	
	panclip = pan.clip(-1.0,1.0);
		//l-l, l-r, r-r, r-l
	panner = Select.ar(BinaryOpUGen('>=', panclip, 0),
			[
				K2A.ar([1, 0, panclip + 1, panclip * -1]),
				K2A.ar([(1 - panclip), panclip, 1, 0])
			]
			);
	panout = 	[
		(output[0] * panner[0]) +
		(output[1] * panner[3]),
		(output[0] * panner[1]) +
		(output[1] * panner[2])];

	
	output = panout*env*amp;

	Out.ar(out, output);
}).add;



SynthDef(\dxkNobuStutS, {|buf, t_trig = 1, loc = -1, rate = 1,  stut = 0,
	maxdelay = 1, stutlen = 0.1, amp = 1, ramp = 0.001, stutramp = 0.001, relabs = 0, pan = 0, out = 0|
	//stutlen is in real time seconds
	//regular nobu vars
	var output, rdphs, rdphsfor, rdphsback, bufsize, trig, del_trig, real_loc, env, gate;
	//stutter vars
	var stutout, delptr, clock, stuttrig, stutenv;

	var panout, panclip, panner;
	trig = HPZ1.kr(loc);
	trig = (trig < 0) + (trig > 0) +t_trig;
	del_trig = TDelay.kr(trig, ramp);
	gate = SetResetFF.kr(del_trig, trig);
	bufsize = BufFrames.ir(buf);
	real_loc = Select.kr(relabs % 2, [Clip.kr(loc*bufsize, 0, bufsize), Clip.kr(loc, 0, bufsize)]);
	rdphsfor = Phasor.ar(del_trig, BufRateScale.kr(buf)*rate, real_loc, bufsize, real_loc);
	rdphsback = Phasor.ar(del_trig, BufRateScale.kr(buf)*rate, 0, real_loc, real_loc);
	rdphs = Select.ar(rate >= 0, [rdphsback, rdphsfor]);
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

	
	
	panclip = pan.clip(-1.0,1.0);
		//l-l, l-r, r-r, r-l
	panner = Select.ar(BinaryOpUGen('>=', panclip, 0),
			[
				K2A.ar([1, 0, panclip + 1, panclip * -1]),
				K2A.ar([(1 - panclip), panclip, 1, 0])
			]
			);
	panout = 	[
		(output[0] * panner[0]) +
		(output[1] * panner[3]),
		(output[0] * panner[1]) +
		(output[1] * panner[2])];

	
	output = panout*env*amp;

	//output = Pan2.ar(output, pan);
	Out.ar(out,output);

}).add;
