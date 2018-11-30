
SynthDef(\dxkRCombNM, {| dry = 1, wet = 0.5, delaytime = 0.2, maxdelay = 1, decaytime = 1, in = 50, out = 0, amp = 1|
	var input, wetsig, outsig;
	input = In.ar(in,1);
	wetsig = CombL.ar(input, maxdelay, delaytime, decaytime, 1);
	outsig = (input*dry)+(wetsig*wet);
	outsig = outsig * amp;
	ReplaceOut.ar(out, outsig);
}, [0.5, 0.5, 0.5]).add;

SynthDef(\dxkRCombLM, {| dry = 1, wet = 0.5, delaytime = 0.2, maxdelay = 1, decaytime = 1, in = 50, out = 0, amp = 1|
	var input, wetsig, outsig;
	input = In.ar(in,1);
	wetsig = CombN.ar(input, maxdelay, delaytime, decaytime, 1);
	outsig = (input*dry)+(wetsig*wet);
	outsig = outsig * amp;
	ReplaceOut.ar(out, outsig);
}, [0.5, 0.5, 0.5]).add;

SynthDef(\dxkRCombCM, {| dry = 1, wet = 0.5, delaytime = 0.2, maxdelay = 1, decaytime = 1, in = 50, out = 0, amp = 1|
	var input, wetsig, outsig;
	input = In.ar(in,1);
	wetsig = CombC.ar(input, maxdelay, delaytime, decaytime, 1);
	outsig = (input*dry)+(wetsig*wet);
	outsig = outsig * amp;
	ReplaceOut.ar(out, outsig);
}, [0.5, 0.5, 0.5]).add;


SynthDef(\dxkRCombNS, {| dry = 1, wet = 0.5, delaytime = 0.2, maxdelay = 1, decaytime = 1, in = 50, out = 0, amp = 1|
	var input, wetsig, outsig;
	input = In.ar(in,2);
	wetsig = CombL.ar(input, maxdelay, delaytime, decaytime, 1);
	outsig = (input*dry)+(wetsig*wet);
	outsig = outsig * amp;
	ReplaceOut.ar(out, outsig);
}, [0.5, 0.5, 0.5]).add;

SynthDef(\dxkRCombLS, {| dry = 1, wet = 0.5, delaytime = 0.2, maxdelay = 1, decaytime = 1, in = 50, out = 0, amp = 1|
	var input, wetsig, outsig;
	input = In.ar(in,2);
	wetsig = CombN.ar(input, maxdelay, delaytime, decaytime, 1);
	outsig = (input*dry)+(wetsig*wet);
	outsig = outsig * amp;
	ReplaceOut.ar(out, outsig);
}, [0.5, 0.5, 0.5]).add;

SynthDef(\dxkRCombCS, {| dry = 1, wet = 0.5, delaytime = 0.2, maxdelay = 1, decaytime = 1, in = 50, out = 0, amp = 1|
	var input, wetsig, outsig;
	input = In.ar(in,2);
	wetsig = CombC.ar(input, maxdelay, delaytime, decaytime, 1);
	outsig = (input*dry)+(wetsig*wet);
	outsig = outsig * amp;
	ReplaceOut.ar(out, outsig);
}, [0.5, 0.5, 0.5]).add;

SynthDef(\dxkRAllpassNM, {| dry = 1, wet = 0.5, delaytime = 0.2, maxdelay = 1, decaytime = 1, in = 50, out = 0, amp = 1|
	var input, wetsig, outsig;
	input = In.ar(in,1);
	wetsig = AllpassL.ar(input, maxdelay, delaytime, decaytime, 1);
	outsig = (input*dry)+(wetsig*wet);
	outsig = outsig * amp;
	ReplaceOut.ar(out, outsig);
}, [0.5, 0.5, 0.5]).add;

SynthDef(\dxkRAllpassLM, {| dry = 1, wet = 0.5, delaytime = 0.2, maxdelay = 1, decaytime = 1, in = 50, out = 0, amp = 1|
	var input, wetsig, outsig;
	input = In.ar(in,1);
	wetsig = AllpassN.ar(input, maxdelay, delaytime, decaytime, 1);
	outsig = (input*dry)+(wetsig*wet);
	outsig = outsig * amp;
	ReplaceOut.ar(out, outsig);
}, [0.5, 0.5, 0.5]).add;

SynthDef(\dxkRAllpassCM, {| dry = 1, wet = 0.5, delaytime = 0.2, maxdelay = 1, decaytime = 1, in = 50, out = 0, amp = 1|
	var input, wetsig, outsig;
	input = In.ar(in,1);
	wetsig = AllpassC.ar(input, maxdelay, delaytime, decaytime, 1);
	outsig = (input*dry)+(wetsig*wet);
	outsig = outsig * amp;
	ReplaceOut.ar(out, outsig);
}, [0.5, 0.5, 0.5]).add;


SynthDef(\dxkRAllpassNS, {| dry = 1, wet = 0.5, delaytime = 0.2, maxdelay = 1, decaytime = 1, in = 50, out = 0, amp = 1|
	var input, wetsig, outsig;
	input = In.ar(in,2);
	wetsig = AllpassL.ar(input, maxdelay, delaytime, decaytime, 1);
	outsig = (input*dry)+(wetsig*wet);
	outsig = outsig * amp;
	ReplaceOut.ar(out, outsig);
}, [0.5, 0.5, 0.5]).add;

SynthDef(\dxkRAllpassLS, {| dry = 1, wet = 0.5, delaytime = 0.2, maxdelay = 1, decaytime = 1, in = 50, out = 0, amp = 1|
	var input, wetsig, outsig;
	input = In.ar(in,2);
	wetsig = AllpassN.ar(input, maxdelay, delaytime, decaytime, 1);
	outsig = (input*dry)+(wetsig*wet);
	outsig = outsig * amp;
	ReplaceOut.ar(out, outsig);
}, [0.5, 0.5]).add;

SynthDef(\dxkRAllpassCS, {| dry = 1, wet = 0.5, delaytime = 0.2, maxdelay = 1, decaytime = 1, in = 50, out = 0, amp = 1|
	var input, wetsig, outsig;
	input = In.ar(in,2);
	wetsig = AllpassC.ar(input, maxdelay, delaytime, decaytime, 1);
	outsig = (input*dry)+(wetsig*wet);
	outsig = outsig * amp;
	ReplaceOut.ar(out, outsig);
}, [0.5, 0.5]).add;