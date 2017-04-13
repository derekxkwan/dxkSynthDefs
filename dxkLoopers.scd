//untested so far...

SynthDef(\dxkLooperMono, {|recplay = 0, buf, writelevel = 1, overwrite = 0, ramp = 0.003, inBus =0, outBus = 0, amp = 1|
	//recplay: 0 = none, 1 = record, 2 = play
	var input, output, recording, rectrig, playing, playtrig, recenv, playenv, recdelayed, playdelayed;
	input = In.ar(buf, 1);
	recording = BinaryOpUGen('==', recplay, 1);
	rectrig = recording - 0.5;
	recenv = EnvGen.ar(Env.asr(ramp, 1, ramp), rectrig);
	//delay off recording by ramp time to allow ramp
	recording = Select.kr(recording, [DelayN.kr(recording, ramp, ramp), recording]);
	RecordBuf(0, buf, 0, writelevel, overwrite, recording, 1, rectrig);
	playing = BinaryOpUGen('==', recplay, 2);
	playtrig = playing - 0.5;
	playenv = EnvGen.ar(Env.asr(ramp, 1, ramp), playtrig);
	//delay off recording by ramp time to allow ramp
	playing = Select.kr(playing, [DelayN.kr(playing, ramp, ramp), playing]);
	output = PlayBuf.ar(1, buf, 1, playtrig, 0, 1, 0);
	output = output * playenv;
	Out.ar(outBus, output);
}).add;

