
SynthDef(\dxkCombNMono, {| dry = 1, wet = 0.5, delaytime = 0.2, maxdelay = 1, decaytime = 1, in = 50, out = 0, amp = 1|
	var input, wetsig, outsig;
	input = In.ar(in,1);
	wetsig = CombL.ar(input, maxdelay, delaytime, decaytime, 1);
	outsig = (input*dry)+(wetsig*wet);
	outsig = outsig * amp;
	Out.ar(out, outsig);
}, [0.5, 0.5, 0.5]).add;

SynthDef(\dxkCombLMono, {| dry = 1, wet = 0.5, delaytime = 0.2, maxdelay = 1, decaytime = 1, in = 50, out = 0, amp = 1|
	var input, wetsig, outsig;
	input = In.ar(in,1);
	wetsig = CombN.ar(input, maxdelay, delaytime, decaytime, 1);
	outsig = (input*dry)+(wetsig*wet);
	outsig = outsig * amp;
	Out.ar(out, outsig);
}, [0.5, 0.5, 0.5]).add;

SynthDef(\dxkCombCMono, {| dry = 1, wet = 0.5, delaytime = 0.2, maxdelay = 1, decaytime = 1, in = 50, out = 0, amp = 1|
	var input, wetsig, outsig;
	input = In.ar(in,1);
	wetsig = CombC.ar(input, maxdelay, delaytime, decaytime, 1);
	outsig = (input*dry)+(wetsig*wet);
	outsig = outsig * amp;
	Out.ar(out, outsig);
}, [0.5, 0.5, 0.5]).add;


SynthDef(\dxkCombNStereo, {| dry = 1, wet = 0.5, delaytime = 0.2, maxdelay = 1, decaytime = 1, in = 50, out = 0, amp = 1|
	var input, wetsig, outsig;
	input = In.ar(in,2);
	wetsig = CombL.ar(input, maxdelay, delaytime, decaytime, 1);
	outsig = (input*dry)+(wetsig*wet);
	outsig = outsig * amp;
	Out.ar(out, outsig);
}, [0.5, 0.5, 0.5]).add;

SynthDef(\dxkCombLStereo, {| dry = 1, wet = 0.5, delaytime = 0.2, maxdelay = 1, decaytime = 1, in = 50, out = 0, amp = 1|
	var input, wetsig, outsig;
	input = In.ar(in,2);
	wetsig = CombN.ar(input, maxdelay, delaytime, decaytime, 1);
	outsig = (input*dry)+(wetsig*wet);
	outsig = outsig * amp;
	Out.ar(out, outsig);
}, [0.5, 0.5, 0.5]).add;

SynthDef(\dxkCombCStereo, {| dry = 1, wet = 0.5, delaytime = 0.2, maxdelay = 1, decaytime = 1, in = 50, out = 0, amp = 1|
	var input, wetsig, outsig;
	input = In.ar(in,2);
	wetsig = CombC.ar(input, maxdelay, delaytime, decaytime, 1);
	outsig = (input*dry)+(wetsig*wet);
	outsig = outsig * amp;
	Out.ar(out, outsig);
}, [0.5, 0.5, 0.5]).add;

SynthDef(\dxkAllpassNMono, {| dry = 1, wet = 0.5, delaytime = 0.2, maxdelay = 1, decaytime = 1, in = 50, out = 0, amp = 1|
	var input, wetsig, outsig;
	input = In.ar(in,1);
	wetsig = AllpassL.ar(input, maxdelay, delaytime, decaytime, 1);
	outsig = (input*dry)+(wetsig*wet);
	outsig = outsig * amp;
	Out.ar(out, outsig);
}, [0.5, 0.5, 0.5]).add;

SynthDef(\dxkAllpassLMono, {| dry = 1, wet = 0.5, delaytime = 0.2, maxdelay = 1, decaytime = 1, in = 50, out = 0, amp = 1|
	var input, wetsig, outsig;
	input = In.ar(in,1);
	wetsig = AllpassN.ar(input, maxdelay, delaytime, decaytime, 1);
	outsig = (input*dry)+(wetsig*wet);
	outsig = outsig * amp;
	Out.ar(out, outsig);
}, [0.5, 0.5, 0.5]).add;

SynthDef(\dxkAllpassCMono, {| dry = 1, wet = 0.5, delaytime = 0.2, maxdelay = 1, decaytime = 1, in = 50, out = 0, amp = 1|
	var input, wetsig, outsig;
	input = In.ar(in,1);
	wetsig = AllpassC.ar(input, maxdelay, delaytime, decaytime, 1);
	outsig = (input*dry)+(wetsig*wet);
	outsig = outsig * amp;
	Out.ar(out, outsig);
}, [0.5, 0.5, 0.5]).add;


SynthDef(\dxkAllpassNStereo, {| dry = 1, wet = 0.5, delaytime = 0.2, maxdelay = 1, decaytime = 1, in = 50, out = 0, amp = 1|
	var input, wetsig, outsig;
	input = In.ar(in,2);
	wetsig = AllpassL.ar(input, maxdelay, delaytime, decaytime, 1);
	outsig = (input*dry)+(wetsig*wet);
	outsig = outsig * amp;
	Out.ar(out, outsig);
}, [0.5, 0.5, 0.5]).add;

SynthDef(\dxkAllpassLStereo, {| dry = 1, wet = 0.5, delaytime = 0.2, maxdelay = 1, decaytime = 1, in = 50, out = 0, amp = 1|
	var input, wetsig, outsig;
	input = In.ar(in,2);
	wetsig = AllpassN.ar(input, maxdelay, delaytime, decaytime, 1);
	outsig = (input*dry)+(wetsig*wet);
	outsig = outsig * amp;
	Out.ar(out, outsig);
}, [0.5, 0.5]).add;

SynthDef(\dxkAllpassCStereo, {| dry = 1, wet = 0.5, delaytime = 0.2, maxdelay = 1, decaytime = 1, in = 50, out = 0, amp = 1|
	var input, wetsig, outsig;
	input = In.ar(in,2);
	wetsig = AllpassC.ar(input, maxdelay, delaytime, decaytime, 1);
	outsig = (input*dry)+(wetsig*wet);
	outsig = outsig * amp;
	Out.ar(out, outsig);
}, [0.5, 0.5]).add;