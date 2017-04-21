SynthDef(\dxkLooperMono, {|recplay = 0, buf, writelevel = 1, overwrite = 0, ramp = 0.003, inBus =0, outBus = 0, amp = 1|
	//recplay: 0 = none, 1 = record, 2 = play
	var input, output, recording, rectrig, recofftrig, playing, playtrig, recenv, playenv, recdelayed, playdelayed, looplen, readpos;
	
	input = In.ar(inBus, 1);
	recording = BinaryOpUGen('==', recplay, 1);
	rectrig = Trig.kr(recording - 0.5);
	recofftrig = Trig.kr(0.5 - recording);
	recenv = EnvGen.ar(Env.asr(ramp, 1, ramp), recording);
	//delay off recording by ramp time to allow ramp
	recording = Select.kr(recording, [DelayN.kr(recording, ramp, ramp), recording]);
	RecordBuf.ar(input*recenv, buf, 0, writelevel, overwrite, recording, 1, rectrig);
	
	//record loop length
	looplen = Timer.kr(rectrig+recofftrig);
	
	playing = BinaryOpUGen('==', recplay, 2);
	playtrig = Trig.kr(playing - 0.5);
	//delay off recording by ramp time to allow ramp
	playenv = EnvGen.ar(Env.asr(ramp, 1, ramp), playing);
	playing = Select.kr(playing, [DelayN.kr(playing, ramp, ramp), playing]);
	readpos = Phasor.ar(playtrig, BufRateScale.kr(buf), 0, looplen * SampleRate.ir);
	
	output = BufRd.ar(1, buf, readpos, 1);
	output = output * playenv;
	Out.ar(outBus, output);
}).add;
