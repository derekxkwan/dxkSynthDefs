SynthDef(\dxkFreeVerbM, {|in = 10, out = 0, mix = 0.33, room = 0.5, damp = 0.5, amp = 1, in_pan = 0|
	var input, input2, output;
	input = In.ar(in, 1);
	input = Pan2.ar(input, in_pan);
	output = FreeVerb.ar(input, mix, room, damp, amp);
	Out.ar(out, output)
}).add;

SynthDef(\dxkFreeVerbS, {|in = 10, out = 0, mix = 0.33, room = 0.5, damp = 0.5, amp = 1|
	var input, input2, output;
	input = In.ar(in, 2);
	output = FreeVerb.ar(input, mix, room, damp, amp);
	Out.ar(out, output)
}).add;

SynthDef(\dxkFreeVerb2, {|in = 10, in2 = 11, out = 0, mix = 0.33, room = 0.5, damp = 0.5, amp = 1|
	var input, input2, output;
	input = In.ar(in, 1);
	input2 = In.ar(in2, 1);
	output = FreeVerb2.ar(input, input2, mix, room, damp, amp);
	Out.ar(out, output)
}).add;

SynthDef(\dxkFVerbFiltM, {|in = 10, out = 0, mix = 0.33, room = 0.5, damp = 0.5, amp = 1, hip_in = 0, hip_out = 0, lop_out = 20000, lop_in = 20000|
	var input, input2, output;
	input = In.ar(in, 1);
	input = HPF.ar(LPF.ar(input, lop_in), hip_in);
	output = FreeVerb.ar(input, mix, room, damp);
	output = HPF.ar(LPF.ar(output, lop_out), hip_out);

	Out.ar(out, output * amp)
}).add;

SynthDef(\dxkFVerbFiltS, {|in = 10, out = 0, mix = 0.33, room = 0.5, damp = 0.5, amp = 1, hip_in = 0, hip_out = 0, lop_out = 20000, lop_in = 20000|
	var input, input2, output;
	input = In.ar(in, 2);
	input = HPF.ar(LPF.ar(input, lop_in), hip_in);
	output = FreeVerb.ar(input, mix, room, damp);
	output = HPF.ar(LPF.ar(output, lop_out), hip_out);

	Out.ar(out, output * amp)
}).add;

SynthDef(\dxkGVerbM, {|in = 10, room =  10, revtime = 3, damp = 0.5, inputbw = 0.5, spread = 15, dry = 1, earlyref = 0.7, tail = 0.5, maxroom = 300, amp = 1, in_pan = 0, out = 0|
	var input, input2, output;
	input = In.ar(in, 1);
	input = Pan2.ar(input, in_pan);
	output = GVerb.ar(input, room, revtime, damp, inputbw, spread, dry, earlyref, tail, maxroom, amp);
	Out.ar(out, output);
}).add;

SynthDef(\dxkGVerbS, {|in = 10, room =  10, revtime = 3, damp = 0.5, inputbw = 0.5, spread = 15, dry = 1, earlyref = 0.7, tail = 0.5, maxroom = 300, amp = 1, out = 0|
	var input, input2, output;
	input = In.ar(in, 2);
	output = GVerb.ar(input, room, revtime, damp, inputbw, spread, dry, earlyref, tail, maxroom, amp);

	Out.ar(out, output);
}).add;

