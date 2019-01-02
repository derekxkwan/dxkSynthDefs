SynthDef(\dxkLooperM2S, {|recplay = 0, buf, writelevel = 1, overwrite = 0, ramp = 0.003, in =0, out = 0, amp = 1, pan = 0|
	//recplay: 0 = none, 1 = record, 2 = play
	var input, output, recording, rectrig, recofftrig, playing, playtrig, recenv, playenv, recdelayed, playdelayed, looplen, readenv, readpos, readtrig;
	
	input = In.ar(in, 1);
	recording = BinaryOpUGen('==', recplay, 1);
	rectrig = Trig.kr(recording - 0.5);
	recofftrig = Trig.kr(0.5 - recording);
	recenv = EnvGen.ar(Env.asr(ramp, 1, ramp), recording);
	//delay off recording by ramp time to allow ramp
	//recording = Select.kr(recording, [DelayN.kr(recording, ramp, ramp), recording]);
	RecordBuf.ar(input*recenv, buf, 0, writelevel, overwrite, recording, 0, rectrig);
	
	//record loop length
	looplen = Clip.kr(Timer.kr(rectrig+recofftrig), 0, BufDur.kr(buf));
	
	playing = BinaryOpUGen('==', recplay, 2);
	playtrig = Trig.kr(playing - 0.5);
	//delay off recording by ramp time to allow ramp
	playenv = EnvGen.ar(Env.asr(ramp, 1, ramp), playing);
	//playing = Select.kr(playing, [DelayN.kr(playing, ramp, ramp), playing]);
	readpos = Phasor.ar(playtrig, BufRateScale.kr(buf), 0, looplen * SampleRate.ir * playing, 0);


	//looping envelope
	readtrig = Trig.ar(BinaryOpUGen('>', readpos, 0), looplen - ramp);
	readenv = EnvGen.ar(Env.asr(ramp, 1, ramp), readtrig);

	
	output = BufRd.ar(1, buf, readpos, 1);
	output = output * playenv * readenv;
	output = Pan2.ar(output,pan, amp);
	Out.ar(out, output);
}).add;

SynthDef(\dxkLooperS2S, {|recplay = 0, buf, writelevel = 1, overwrite = 0, ramp = 0.003, in =0, out = 0, amp = 1, pan = 0|
	//recplay: 0 = none, 1 = record, 2 = play
	var input, output, recording, rectrig, recofftrig, playing, playtrig, recenv, playenv, recdelayed, playdelayed, looplen, readenv, readpos, readtrig;
	var panner, panout;
	input = In.ar(in, 2);
	recording = BinaryOpUGen('==', recplay, 1);
	rectrig = Trig.kr(recording - 0.5);
	recofftrig = Trig.kr(0.5 - recording);
	recenv = EnvGen.ar(Env.asr(ramp, 1, ramp), recording);
	//delay off recording by ramp time to allow ramp
	//recording = Select.kr(recording, [DelayN.kr(recording, ramp, ramp), recording]);
	RecordBuf.ar(input*recenv, buf, 0, writelevel, overwrite, recording, 0, rectrig);
	
	//record loop length
	looplen = Clip.kr(Timer.kr(rectrig+recofftrig), 0, BufDur.kr(buf));
	
	playing = BinaryOpUGen('==', recplay, 2);
	playtrig = Trig.kr(playing - 0.5);
	//delay off recording by ramp time to allow ramp
	playenv = EnvGen.ar(Env.asr(ramp, 1, ramp), playing);
	//playing = Select.kr(playing, [DelayN.kr(playing, ramp, ramp), playing]);
	readpos = Phasor.ar(playtrig, BufRateScale.kr(buf), 0, looplen * SampleRate.ir * playing, 0);


	//looping envelope
	readtrig = Trig.ar(BinaryOpUGen('>', readpos, 0), looplen - ramp);
	readenv = EnvGen.ar(Env.asr(ramp, 1, ramp), readtrig);

	
	output = BufRd.ar(1, buf, readpos, 1);
	output = output * playenv * readenv;
	panner = Clip.kr([ (1 - pan), pan, (1 + pan), (-1 * pan)], 0, 1);
	panout = [Mix.ar(output * [panner[0], panner[3]]), Mix.ar(output * [panner[1], panner[2]])];
	output = panout * amp;
	Out.ar(out, output);
}).add;

