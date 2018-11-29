
SynthDef(\dxkCombNM, {| dry = 1, wet = 0.5, delaytime = 0.2, maxdelay = 1, decaytime = 1, in = 50, out = 0, amp = 1|
	var input, wetsig, outsig;
	input = In.ar(in,1);
	wetsig = CombL.ar(input, maxdelay, delaytime, decaytime, 1);
	outsig = (input*dry)+(wetsig*wet);
	outsig = outsig * amp;
	ReplaceOut.ar(out, outsig);
}, [0.5, 0.5, 0.5]).add;

SynthDef(\dxkCombLM, {| dry = 1, wet = 0.5, delaytime = 0.2, maxdelay = 1, decaytime = 1, in = 50, out = 0, amp = 1|
	var input, wetsig, outsig;
	input = In.ar(in,1);
	wetsig = CombN.ar(input, maxdelay, delaytime, decaytime, 1);
	outsig = (input*dry)+(wetsig*wet);
	outsig = outsig * amp;
	ReplaceOut.ar(out, outsig);
}, [0.5, 0.5, 0.5]).add;

SynthDef(\dxkCombCM, {| dry = 1, wet = 0.5, delaytime = 0.2, maxdelay = 1, decaytime = 1, in = 50, out = 0, amp = 1|
	var input, wetsig, outsig;
	input = In.ar(in,1);
	wetsig = CombC.ar(input, maxdelay, delaytime, decaytime, 1);
	outsig = (input*dry)+(wetsig*wet);
	outsig = outsig * amp;
	ReplaceOut.ar(out, outsig);
}, [0.5, 0.5, 0.5]).add;


SynthDef(\dxkCombNS, {| dry = 1, wet = 0.5, delaytime = 0.2, maxdelay = 1, decaytime = 1, in = 50, out = 0, amp = 1|
	var input, wetsig, outsig;
	input = In.ar(in,2);
	wetsig = CombL.ar(input, maxdelay, delaytime, decaytime, 1);
	outsig = (input*dry)+(wetsig*wet);
	outsig = outsig * amp;
	ReplaceOut.ar(out, outsig);
}, [0.5, 0.5, 0.5]).add;

SynthDef(\dxkCombLS, {| dry = 1, wet = 0.5, delaytime = 0.2, maxdelay = 1, decaytime = 1, in = 50, out = 0, amp = 1|
	var input, wetsig, outsig;
	input = In.ar(in,2);
	wetsig = CombN.ar(input, maxdelay, delaytime, decaytime, 1);
	outsig = (input*dry)+(wetsig*wet);
	outsig = outsig * amp;
	ReplaceOut.ar(out, outsig);
}, [0.5, 0.5, 0.5]).add;

SynthDef(\dxkCombCS, {| dry = 1, wet = 0.5, delaytime = 0.2, maxdelay = 1, decaytime = 1, in = 50, out = 0, amp = 1|
	var input, wetsig, outsig;
	input = In.ar(in,2);
	wetsig = CombC.ar(input, maxdelay, delaytime, decaytime, 1);
	outsig = (input*dry)+(wetsig*wet);
	outsig = outsig * amp;
	ReplaceOut.ar(out, outsig);
}, [0.5, 0.5, 0.5]).add;

SynthDef(\dxkAllpassNM, {| dry = 1, wet = 0.5, delaytime = 0.2, maxdelay = 1, decaytime = 1, in = 50, out = 0, amp = 1|
	var input, wetsig, outsig;
	input = In.ar(in,1);
	wetsig = AllpassL.ar(input, maxdelay, delaytime, decaytime, 1);
	outsig = (input*dry)+(wetsig*wet);
	outsig = outsig * amp;
	ReplaceOut.ar(out, outsig);
}, [0.5, 0.5, 0.5]).add;

SynthDef(\dxkAllpassLM, {| dry = 1, wet = 0.5, delaytime = 0.2, maxdelay = 1, decaytime = 1, in = 50, out = 0, amp = 1|
	var input, wetsig, outsig;
	input = In.ar(in,1);
	wetsig = AllpassN.ar(input, maxdelay, delaytime, decaytime, 1);
	outsig = (input*dry)+(wetsig*wet);
	outsig = outsig * amp;
	ReplaceOut.ar(out, outsig);
}, [0.5, 0.5, 0.5]).add;

SynthDef(\dxkAllpassCM, {| dry = 1, wet = 0.5, delaytime = 0.2, maxdelay = 1, decaytime = 1, in = 50, out = 0, amp = 1|
	var input, wetsig, outsig;
	input = In.ar(in,1);
	wetsig = AllpassC.ar(input, maxdelay, delaytime, decaytime, 1);
	outsig = (input*dry)+(wetsig*wet);
	outsig = outsig * amp;
	ReplaceOut.ar(out, outsig);
}, [0.5, 0.5, 0.5]).add;


SynthDef(\dxkAllpassNS, {| dry = 1, wet = 0.5, delaytime = 0.2, maxdelay = 1, decaytime = 1, in = 50, out = 0, amp = 1|
	var input, wetsig, outsig;
	input = In.ar(in,2);
	wetsig = AllpassL.ar(input, maxdelay, delaytime, decaytime, 1);
	outsig = (input*dry)+(wetsig*wet);
	outsig = outsig * amp;
	ReplaceOut.ar(out, outsig);
}, [0.5, 0.5, 0.5]).add;

SynthDef(\dxkAllpassLS, {| dry = 1, wet = 0.5, delaytime = 0.2, maxdelay = 1, decaytime = 1, in = 50, out = 0, amp = 1|
	var input, wetsig, outsig;
	input = In.ar(in,2);
	wetsig = AllpassN.ar(input, maxdelay, delaytime, decaytime, 1);
	outsig = (input*dry)+(wetsig*wet);
	outsig = outsig * amp;
	ReplaceOut.ar(out, outsig);
}, [0.5, 0.5]).add;

SynthDef(\dxkAllpassCS, {| dry = 1, wet = 0.5, delaytime = 0.2, maxdelay = 1, decaytime = 1, in = 50, out = 0, amp = 1|
	var input, wetsig, outsig;
	input = In.ar(in,2);
	wetsig = AllpassC.ar(input, maxdelay, delaytime, decaytime, 1);
	outsig = (input*dry)+(wetsig*wet);
	outsig = outsig * amp;
	ReplaceOut.ar(out, outsig);
}, [0.5, 0.5]).add;