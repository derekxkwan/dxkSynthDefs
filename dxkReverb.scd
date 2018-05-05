//1-in,4-out Schroeder Reverberator from Julius O. Smith's Physical Audio Signal Processing
//(the first example given)
SynthDef(\dxkSchroeder1L, {|amp = #[1,1,1,1], in = 10, out = 0|
	var apdel, apcoef, apdecay, fbdel, fbcoef, fbdecay, numap, numfb;
	var input, ap, fboutput;
	var s1, s2, outA, outB, outC, outD, output;
	apdel = [347,113,37]*SampleDur.ir; //delay in samp -> delay in s
	apcoef = 0.7; //gain coeff
	apdecay = apdel * (log(0.001)/log(apcoef)); //mapping to decay times
	numap = apdel.size;
	fbdel = [1687, 1601, 2053, 2251] * SampleDur.ir;
	numfb = fbdel.size;
	fbcoef = [0.773, 0.802, 0.753, 0.733];
	fbdecay = fbdel * (log(0.001)/log(fbcoef));
	input = In.ar(in, 1);
	ap = input;
	numap.do({|i|
		ap = AllpassL.ar(ap, apdel[i], apdel[i], apdecay[i]);
	});
	fboutput = Array.fill(numfb, {|i|
		CombL.ar(ap, fbdel[i], fbdel[i], fbdecay[i]);
	});
	s1 = fboutput[0] + fboutput[2];
	s2 = fboutput[1] + fboutput[3];
	outA = s1+s2;
	outD = s1-s2;
	outB = -1*outA;
	outC = -1*outD;
	output = [outA, outB, outC, outD];
	output = output * amp;
	ReplaceOut.ar(out, output);
}).add;

//1-in,2-out Schroeder Reverberator from Julius O. Smith's Physical Audio Signal Processing
//(satrev chowning)
SynthDef(\dxkSchroeder2L, {| amp = 1, in = 10, out = 0|
	var fbdel, fbcoef, fbdecay;
	var apdel, apcoef, apdecay;
	var input, ap, fboutput, output;
	var numap, numfb;
	fbdel = [901,778,1011,1123]*SampleDur.ir; //delay in samp -> delay in s
	fbcoef = [0.805, 0.827, 0.783, 0.764]; //gain coeff
	fbdecay = fbdel * (log(0.001)/log(fbcoef)); //mapping to decay times
	numfb = fbdel.size;
	apdel = [125, 42, 12] * SampleDur.ir;
	apcoef = 0.7;
	apdecay = apdel * (log(0.001)/log(apcoef));
	numap = apdel.size;

	input = In.ar(in, 1);
	fboutput = Array.fill(numfb, {|i|
		CombL.ar(input, fbdel[i], fbdel[i], fbdecay[i]);
	});
	ap = fboutput;
	numap.do({|i|
		ap = AllpassL.ar(ap, apdel[i], apdel[i], apdecay[i]);
	});
	output = ap * [1, -1];
	output = ap * amp;
	ReplaceOut.ar(out, output);
}).add;
	