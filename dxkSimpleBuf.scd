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


// audio rate bus input for pointer
SynthDef(\dxkWarpInM,
	{
		arg in, out = 0, buf, pan = 0, amp = 1,
		freqscale = 1, overlaps = 8, winsize = 0.1, winrand = 0.5, interp = 2;

		var ipt = In.ar(in, 1);
		var snd = Warp1.ar(1, buf, ipt, freqscale, winsize, -1,
			overlaps, winrand, interp);
		snd = Pan2.ar(snd, pan, amp);
		Out.ar(out, snd);
	}).add;

SynthDef(\dxkWarpInS,
	{
		arg in, out = 0, buf, pan = 0, amp = 1,
		freqscale = 1, overlaps = 8, winsize = 0.1, winrand = 0.5, interp = 2;

		var panner, panout;
		var ipt = In.ar(in, 1);
		var output = Warp1.ar(2, buf, ipt, freqscale, winsize, -1,
			overlaps, winrand, interp);

		//l -> l: 1 : 1 -> 0
		//l -> r: 0 : 0 -> 1
		//r -> r: 0 -> 1 : 1
		//r -> l: 1->0 : 0

		panner = Clip.kr([ (1 - pan), pan, (1 + pan), (-1 * pan)], 0, 1);
		panout = [Mix.ar(output * [panner[0], panner[3]]), Mix.ar(output * [panner[1], panner[2]])];
		output = panout * amp;
		Out.ar(out, output);
	}).add;
