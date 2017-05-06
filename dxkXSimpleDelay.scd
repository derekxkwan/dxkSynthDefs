
SynthDef(\dxkXCombNM, {| dry = 1, wet = 0.5, delaytime = 0.2, maxdelay = 1, decaytime = 1, in = 50, out = 0, amp = 1, gate = 1|
	var input, wetsig, outsig, env;
	env = Linen.kr(gate, 0.05, 1, 0.1, 2);
	input = In.ar(out,1);
	wetsig = CombL.ar(input, maxdelay, delaytime, decaytime, 1);
	outsig = (input*dry)+(wetsig*wet);
	outsig = outsig * amp;
	XOut.ar(out, env, outsig);
}, [0.5, 0.5, 0.5]).add;

SynthDef(\dxkXCombLM, {| dry = 1, wet = 0.5, delaytime = 0.2, maxdelay = 1, decaytime = 1,  out = 0, amp = 1, gate = 1|
	var input, wetsig, outsig, env;
	env = Linen.kr(gate, 0.05, 1, 0.1, 2);
	input = In.ar(out,1);
	wetsig = CombN.ar(input, maxdelay, delaytime, decaytime, 1);
	outsig = (input*dry)+(wetsig*wet);
	outsig = outsig * amp;
	XOut.ar(out, env, outsig);
}, [0.5, 0.5, 0.5]).add;

SynthDef(\dxkXCombCM, {| dry = 1, wet = 0.5, delaytime = 0.2, maxdelay = 1, decaytime = 1,  out = 0, amp = 1, gate = 1|
	var input, wetsig, outsig, env;
	env = Linen.kr(gate, 0.05, 1, 0.1, 2);
	input = In.ar(out,1);
	wetsig = CombC.ar(input, maxdelay, delaytime, decaytime, 1);
	outsig = (input*dry)+(wetsig*wet);
	outsig = outsig * amp;
	XOut.ar(out, env, outsig);
}, [0.5, 0.5, 0.5]).add;


SynthDef(\dxkXCombNS, {| dry = 1, wet = 0.5, delaytime = 0.2, maxdelay = 1, decaytime = 1,  out = 0, amp = 1, gate = 1|
	var input, wetsig, outsig, env;
	env = Linen.kr(gate, 0.05, 1, 0.1, 2);
	input = In.ar(out,2);
	wetsig = CombL.ar(input, maxdelay, delaytime, decaytime, 1);
	outsig = (input*dry)+(wetsig*wet);
	outsig = outsig * amp;
	XOut.ar(out, env, outsig);
}, [0.5, 0.5, 0.5]).add;

SynthDef(\dxkXCombLS, {| dry = 1, wet = 0.5, delaytime = 0.2, maxdelay = 1, decaytime = 1,  out = 0, amp = 1, gate = 1|
	var input, wetsig, outsig, env;
	env = Linen.kr(gate, 0.05, 1, 0.1, 2);
	input = In.ar(out,2);
	wetsig = CombN.ar(input, maxdelay, delaytime, decaytime, 1);
	outsig = (input*dry)+(wetsig*wet);
	outsig = outsig * amp;
	XOut.ar(out, env, outsig);
}, [0.5, 0.5, 0.5]).add;

SynthDef(\dxkXCombCS, {| dry = 1, wet = 0.5, delaytime = 0.2, maxdelay = 1, decaytime = 1,  out = 0, amp = 1, gate = 1|
	var input, wetsig, outsig, env;
	env = Linen.kr(gate, 0.05, 1, 0.1, 2);
	input = In.ar(out,2);
	wetsig = CombC.ar(input, maxdelay, delaytime, decaytime, 1);
	outsig = (input*dry)+(wetsig*wet);
	outsig = outsig * amp;
	XOut.ar(out, env, outsig);
}, [0.5, 0.5, 0.5]).add;

SynthDef(\dxkXAllpassNM, {| dry = 1, wet = 0.5, delaytime = 0.2, maxdelay = 1, decaytime = 1,  out = 0, amp = 1, gate = 1|
	var input, wetsig, outsig, env;
	env = Linen.kr(gate, 0.05, 1, 0.1, 2);
	input = In.ar(out,1);
	wetsig = AllpassL.ar(input, maxdelay, delaytime, decaytime, 1);
	outsig = (input*dry)+(wetsig*wet);
	outsig = outsig * amp;
	XOut.ar(out, env, outsig);
}, [0.5, 0.5, 0.5]).add;

SynthDef(\dxkXAllpassLM, {| dry = 1, wet = 0.5, delaytime = 0.2, maxdelay = 1, decaytime = 1,  out = 0, amp = 1, gate = 1|
	var input, wetsig, outsig, env;
	env = Linen.kr(gate, 0.05, 1, 0.1, 2);
	input = In.ar(out,1);
	wetsig = AllpassN.ar(input, maxdelay, delaytime, decaytime, 1);
	outsig = (input*dry)+(wetsig*wet);
	outsig = outsig * amp;
	XOut.ar(out, env, outsig);
}, [0.5, 0.5, 0.5]).add;

SynthDef(\dxkXAllpassCM, {| dry = 1, wet = 0.5, delaytime = 0.2, maxdelay = 1, decaytime = 1,  out = 0, amp = 1, gate = 1|
	var input, wetsig, outsig, env;
	env = Linen.kr(gate, 0.05, 1, 0.1, 2);
	input = In.ar(out,1);
	wetsig = AllpassC.ar(input, maxdelay, delaytime, decaytime, 1);
	outsig = (input*dry)+(wetsig*wet);
	outsig = outsig * amp;
	XOut.ar(out, env, outsig);
}, [0.5, 0.5, 0.5]).add;


SynthDef(\dxkXAllpassNS, {| dry = 1, wet = 0.5, delaytime = 0.2, maxdelay = 1, decaytime = 1,  out = 0, amp = 1, gate = 1|
	var input, wetsig, outsig, env;
	env = Linen.kr(gate, 0.05, 1, 0.1, 2);
	input = In.ar(out,2);
	wetsig = AllpassL.ar(input, maxdelay, delaytime, decaytime, 1);
	outsig = (input*dry)+(wetsig*wet);
	outsig = outsig * amp;
	XOut.ar(out, env, outsig);
}, [0.5, 0.5, 0.5]).add;

SynthDef(\dxkXAllpassLS, {| dry = 1, wet = 0.5, delaytime = 0.2, maxdelay = 1, decaytime = 1,  out = 0, amp = 1, gate = 1|
	var input, wetsig, outsig, env;
	env = Linen.kr(gate, 0.05, 1, 0.1, 2);
	input = In.ar(out,2);
	wetsig = AllpassN.ar(input, maxdelay, delaytime, decaytime, 1);
	outsig = (input*dry)+(wetsig*wet);
	outsig = outsig * amp;
	XOut.ar(out, env, outsig);
}, [0.5, 0.5]).add;

SynthDef(\dxkXAllpassCS, {| dry = 1, wet = 0.5, delaytime = 0.2, maxdelay = 1, decaytime = 1,  out = 0, amp = 1, gate = 1|
	var input, wetsig, outsig, env;
	env = Linen.kr(gate, 0.05, 1, 0.1, 2);
	input = In.ar(out,2);
	wetsig = AllpassC.ar(input, maxdelay, delaytime, decaytime, 1);
	outsig = (input*dry)+(wetsig*wet);
	outsig = outsig * amp;
	XOut.ar(out, env, outsig);
}, [0.5, 0.5]).add;