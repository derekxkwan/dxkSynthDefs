SynthDef(\dxkBufM, {|t_trig = 1, buf, out = 0, amp = 1, rate = 1, loop = 1, interp = 2|
	var playptr,playbk;
	playptr = Phasor.ar(t_trig, rate, 0, BufFrames.ir(buf), 0);
	playbk = BufRd.ar(1, buf, playptr, loop, interp)*amp;
	Out.ar(out, playbk);
}).add;

SynthDef(\dxkBufS, {|t_trig = 1, buf, out = 0, amp = 1, rate = 1, loop = 1, interp = 2|
	var playptr,playbk;
	playptr = Phasor.ar(t_trig, rate, 0, BufFrames.ir(buf), 0);
	playbk = BufRd.ar(2, buf, playptr, loop, interp)*amp;
	Out.ar(out, playbk);
}).add;