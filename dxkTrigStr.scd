SynthDef(\dxkTrigStr1M, {|t_trig = 1, buf, in = 10, out = 0,  amp = 1, rate = 1, bufsec = 1, freqScale = 1, windowSize = 0.05, overlaps = 8, windowRandRatio = 0.25, interp = 2|
	var input, bufsz,playbk, playptr, recptr;
	bufsz = BufFrames.ir(buf);
	input = In.ar(in, 1);
	recptr = Phasor.ar(t_trig, 1, 0, bufsz, 0);
	//BufWr.ar(input, buf, recptr, 1);
	RecordBuf.ar(input, buf, 0, 1, 0, 1, 0, t_trig);
	playptr = Phasor.ar(t_trig, rate/bufsz, 0, 1, 0);
	playbk = Warp1.ar(1, buf, playptr, freqScale, windowSize, -1, overlaps, windowRandRatio, interp, amp);
	Out.ar(out, playbk);
	}).add;

SynthDef(\dxkTrigStr1S, {|t_trig = 1, buf, in = 10, out = 0,  amp = 1, rate = 1, bufsec = 1, freqScale = 1, windowSize = 0.05, overlaps = 8, windowRandRatio = 0.25, interp = 2|
	var input, bufsz,playbk, playptr, recptr;
	bufsz = BufFrames.ir(buf);
	input = In.ar(in, 2);
	recptr = Phasor.ar(t_trig, 1, 0, bufsz, 0);
	//BufWr.ar(input, buf, recptr, 1);
	RecordBuf.ar(input, buf, 0, 1, 0, 1, 0, t_trig);
	playptr = Phasor.ar(t_trig, rate/bufsz, 0, 1, 0);
	playbk = Warp1.ar(2, buf, playptr, freqScale, windowSize, -1, overlaps, windowRandRatio, interp, amp);
	Out.ar(out, playbk);
	}).add;
	)