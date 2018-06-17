
//adapted from ryan brown's sc-users 2007-08-25, retrieved from the synthdefpool repo
//reintroduced use of baseFreq and redefined time to remove time scaling

SynthDef(\cymbal808_ryan, {|out=0, freq = 300, time = 0.25, amp=0.1|


	var freqs = freq * [ 1, 1.4823959094229, 1.800048697346, 2.545458972486, 2.6322863403944, 3.9552471390309 ];
	var signal, pulseEnv;

	pulseEnv = EnvGen.ar(Env.new([1.0, 0.6], [time], [-0.5]));
	signal = Mix.new(LFPulse.ar(freqs * 4.09));
	signal = (BinaryOpUGen('==', signal, 6.0) * 0.6) + (BinaryOpUGen('==', signal, 2.0) * 0.2) + (BinaryOpUGen('==', signal, 1.0) * 0.9); // XOR
 	signal = (signal * pulseEnv) + (Mix.new(LFPulse.ar(freqs, width:0.55)) * 0.9);
	signal = RLPF.ar(signal, 7000, 0.6);
 	signal = RHPF.ar(signal, 6800, 1.5);
	signal = RHPF.ar(signal, 6800, 1.5);
	signal = RHPF.ar(signal, 1200, 1.5);
	signal = signal + FreeVerb.ar(signal);
	signal = signal * EnvGen.ar(Env.new([0, 1, 0.4, 0, 0], [0.002, time, 0.05, 0.5], [0, -0.5, 0, -50]), doneAction:2);
	signal = [signal, DelayN.ar(signal, 0.005, 0.005)];
	OffsetOut.ar(out, signal*4*amp);
}).add;


//fm-gong from http://varioussmallfires.blogspot.ca/2012/01/supercollider-gong.html
//but with some tweaks for panning, etc and matrixing variables
SynthDef("vsfFmGong", {|freq = 100, amp = 1, dr = 1, out = 0, pan = 0|

	var modsig, modf = freq * [1.16, 3.14, 1.005];
	var idx = [[0.01, 0.3],[0.01,0.38], [0.01, 0.5]] * modf;
	var idxscaler = Array.fill(idx.size, {|i| idx[i][1] - idx[i][0]});
	var modenv = Array.newClear(modf.size);
	var ampenv, carsig, lfo, output;

	lfo = SinOsc.ar(3, 0, XLine.kr(freq*0.005, freq*0.05, dr));

	modenv[0] = EnvGen.kr(
		Env(levels: [0,1,1,0], times: [0.75*dr, 0.24*dr, 0.01*dr]),
		doneAction: 2);

	modenv[1] = EnvGen.kr(
		Env(levels: [0,1,0], times: [0.02*dr, 0.98*dr]),
		doneAction: 2);

	modenv[2] = EnvGen.kr(
		Env(levels: [ 0, 0.3, 1, 0.5, 0], times: [0.15 * dr, 0.15 *dr, 0.45*dr, 0.25*dr]),
		doneAction: 2);

	// Exp curve...
	ampenv = EnvGen.kr(
		Env(levels: [ 0, 1, 0.001], times: [0.002, dr - 0.002], curve: \exp),
		doneAction: 2);

	modsig = Mix.new(SinOsc.ar(modf) * ((idx + idxscaler)*modenv));
	carsig = SinOsc.ar(freq + lfo + modsig)*modf.size.reciprocal;
	output = carsig * ampenv * amp;
	output = Pan2.ar(output, pan);
	Out.ar(out, output);

}).add;

//Detuned Synth Pad by coreyker from sccode.org http://sccode.org/1-4YS
//in turn taken from http://www.attackmagazine.com/technique/synth-secrets/detuned-pad/
//added amp, pan (instead of original Splay), changed some variables to args (lfo/lop/detune)

SynthDef(\coreyDesyp, {|gate = 1, freq = 440, att = 0.001, dec = 0.001, sus = 0.75, rel = 0.125, lfofreq = 3, lopfreq = 800, rq = 0.5,
	detune1 = 12, detune2 = 8, amp = 1, pan = 0, out = 0|
	var env = EnvGen.ar(Env.adsr(att, dec, sus, rel, amp), gate, doneAction:2);
	var nvoices1 = 5, nvoices2 = 7;

	var osc1 = {
		var m = 2**(detune1/1200).rand2;
		var lfo = SinOsc.ar(lfofreq.rand).range(0,1);
		DelayC.ar(LFSaw.ar(m * freq/2), 0.02, freq.reciprocal.rand * lfo);
	}.dup(nvoices1);

	var osc2 = {
		var m = 2**(detune2/1200).rand2;
		var lfo = SinOsc.ar(lfofreq.rand).range(0,1);
		DelayC.ar(LFSaw.ar(m * freq), 0.02, freq.reciprocal.rand * lfo);
	}.dup(nvoices2);

	var output = BLowPass4.ar(osc1, lopfreq, rq) + osc2 / 4;
	output = Pan2.ar(output*env, pan);
	Out.ar(out, output);
}).add;

// abstracted out from 08091500Acid309 by_otophilia
SynthDef("otoClap", {	|t_trig = 1, rel = 0.3, hip1 = 600, bp1 = 2000, brq1 = 3, hip2 = 1000, bp2 = 1200, brq2 = 0.7, ampn2 = 0.7, out = 0, pan = 0, amp = 1|
		var env1, env2, output, noise1, noise2;
		var env1lvl, env1time, env1curve;
		var env2lvl, env2time, env2curve;

		env1lvl = [0, 1, 0, 1, 0, 1, 0, 1, 0];
		env1time = [0.001, 0.013, 0, 0.01, 0, 0.01, 0, 0.03];
		env1curve = [0, -3, 0, -3, 0, -3, 0, -4];
		env2lvl = [0,1,0];
		env2time = [0.02, rel];
		env2curve = [0, -4];

	    env1 = EnvGen.ar(Env.new(env1lvl, env1time, env1curve), t_trig); //attack
     	env2 = EnvGen.ar(Env.new(env2lvl, env2time, env2curve), doneAction:2); //release

		noise1 = WhiteNoise.ar(env1);
		noise1 = HPF.ar(noise1, hip1);
		noise1 = BPF.ar(noise1, bp1, brq1);

		noise2 = WhiteNoise.ar(env2);
		noise2 = HPF.ar(noise2, hip2);
		noise2 = BPF.ar(noise2, bp2, brq2, ampn2);

		output = noise1 + noise2;
		output = output.softclip * amp;
		output = Pan2.ar(output, pan);

		Out.ar(out, output);
}).add;

// abstracted out from 08091500Acid309 by_otophilia
SynthDef("otoHh", {|t_trig =1, rel = 0.2, hip1 = 1000, bp2 = 6000, brq1 = 2, brq2 = 0.9, bls2 = 3000, brs2 = 0.5, hip2 = 1000, hrq2 = 1.5, out = 0, amp = 1, pan = 0|
		var env1, env2, output, oscs1, noise, n = 5, n2 = 8;

		thisThread.randSeed = 4;

		env1 = EnvGen.ar(Env.new([0, 1.0, 0], [0.001, rel], [0, -12]), t_trig, doneAction: 2);
		env2 = EnvGen.ar(Env.new([0, 1.0, 0.05, 0], [0.002, 0.25*rel, 0.15*rel], [0, -4, -4]), t_trig, doneAction:0);

	    //tone
		oscs1 = Mix.fill(n, {|i|
			SinOsc.ar(
				( i.linlin(0, n-1, 42, 74) + rand2(4.0) ).midicps,
				SinOsc.ar( (i.linlin(0, n-1, 78, 80) + rand2(4.0) ).midicps, 0.0, 12),
				1/n
			)
		});

	    oscs1 = BHiPass.ar(oscs1, hip1, brq1, env1);

	    //noise
		noise = WhiteNoise.ar;
		noise = Mix.fill(n2, {|i|
			var freq;
			freq = (i.linlin(0, n-1, 40, 50) + rand2(4.0) ).midicps.reciprocal;
			CombN.ar(noise, 0.04, freq, 0.1)
		}) * (1/n) + noise;
		noise = BPF.ar(noise, bp2, brq2, 0.5, noise);
		noise = BLowShelf.ar(noise, bls2, brs2, -6);
		noise = BHiPass.ar(noise, hip2, hrq2, env2);

		output = noise + oscs1;
		output = output.softclip;
		output = output * amp;
		output = Pan2.ar(output, pan);
		Out.ar(out, output);
	}).add;


// abstracted out from 08091500Acid309 by_otophilia
SynthDef("otoSd", {	|t_trig = 1, freq = 60, fglide = 1.83, fdip - 0.82, rel = 0.13, hipsn = 200, snrq1 = 2, bpsn = 6900, snrq2 = 0.6, amptone = 1, ampsnares = 0.2, out = 0, amp = 1, pan = 0|
		var env0, env1, env2, env1m, oscs, noise, output;

		env0 = EnvGen.ar(Env.new([0.5, 1, 0.5, 0], [0.005, rel*0.23, rel*0.77], [-4, -2, -4]), t_trig, amptone);
		env1 = EnvGen.ar(Env.new([freq*fglide, freq, freq*fdip], [0.005, rel*0.77], [-4, -5]), t_trig);
		env1m = env1.midicps;
		env2 = EnvGen.ar(Env.new([1, 0.4, 0], [0.05, rel], [-2, -2]), t_trig, doneAction:2);

		oscs = LFPulse.ar(env1m, 0, 0.5, 1, -0.5) + LFPulse.ar(env1m * 1.6, 0, 0.5, 0.5, -0.25);
		oscs = LPF.ar(oscs, env1m*1.2, env0);
		oscs = oscs + SinOsc.ar(env1m, 0.8, env0);

		noise = WhiteNoise.ar(0.2);
		noise = HPF.ar(noise, hipsn, snrq1);
		noise = BPF.ar(noise, bpsn, snrq2, 3) + noise;
		noise = noise * env2;

		output = oscs + noise;
	    output = output.clip2(1) * amp;
	    output = Pan2.ar(output, pan);

		Out.ar(out, output);
}).add;

// abstracted out from 08091500Acid309 by_otophilia
//changed env2 to multiplicative instead of additive
	SynthDef("otoAcid", {|gate = 1, freq = 440, rq = 0.3, out = 0, amp = 1, pan = 0|
		var env1, env2, output;
		freq = Lag.kr(freq, 0.12 * (1-Trig.kr(gate, 0.001)) * gate);
		env1 = EnvGen.ar(Env.new([0, 1.0, 0, 0], [0.001, 2.0, 0.04], [0, -4, -4], 2), gate, amp);
		env2 = EnvGen.ar(Env.adsr(0.001, 0.8, 1, 0.8, 1.4, -4), gate);
		output = LFPulse.ar(freq, 0.0, 0.51, 2, -1);

		output = RLPF.ar(output, freq * env2, rq);
		output = output * env1;
		output = Pan2.ar(output, pan);

		Out.ar(out, output);
	}).add;

// abstracted out from 08091500Acid309 by_otophilia

SynthDef("otoBd", {	|freq = 43, att = 0.005, ampnoise = 1, rel = 0.32, out = 0, pan = 0, amp = 1|
		var env0, env1, env1m, output;

		env0 =  EnvGen.ar(Env.new([0.5, 1, 0.5, 0], [att, 0.1875*rel, 0.8125*rel], [-4, -2, -4]), doneAction:2);
		env1 = EnvGen.ar(Env.new([2.52*freq, 1.35155167*freq, freq], [att, 0.90625*rel], [-4, -5]));


		output = LFPulse.ar(env1, 0, 0.5, 1, -0.5);
		output = output + WhiteNoise.ar(ampnoise);
		output = LPF.ar(output, env1*1.5, env0);
		output = output + SinOsc.ar(env1, 0.5, env0);

		output = output * 1.2;
		output = output.clip2(1)*amp;
	    output = Pan2.ar(output, pan);
		Out.ar(out, output);
	}).add;


//from FM Rhodes by snappizz found on sccode (synthdef as rhodey_sc)
//very minor tweaks (arg-izing matt, decay, rel)
SynthDef(\spRhodes, {
    |
    // standard meanings
    out = 0, freq = 440, gate = 1, pan = 0, amp = 0.1,
    // all of these range from 0 to 1
    vel = 0.8, modIndex = 0.2, mix = 0.2, lfoSpeed = 0.4, lfoDepth = 0.1,
	att = 0.001, decay = 1.5, rel = 0.1
    |
    var env1, env2, env3, env4;
    var osc1, osc2, osc3, osc4, snd;

    lfoSpeed = lfoSpeed * 12;

    env1 = EnvGen.ar(Env.adsr(att, 0.833*decay, 0.0, 0.04, curve: \lin),gate);
    env2 = EnvGen.ar(Env.adsr(att, 0.667*decay, 0.0, 0.04, curve: \lin),gate);
    env3 = EnvGen.ar(Env.adsr(att, decay, 0.0, 0.04, curve: \lin),gate);
    env4 = EnvGen.ar(Env.adsr(att, decay, 0.0, 0.04, curve: \lin),gate);

    osc4 = SinOsc.ar(freq) * 2pi * 2 * 0.535887 * modIndex * env4 * vel;
    osc3 = SinOsc.ar(freq * 2, osc4) * env3 * vel;
    osc2 = SinOsc.ar(freq * 30) * 2pi * 0.108819 * env2 * vel;
    osc1 = SinOsc.ar(freq * 2, osc2) * env1 * vel;
    snd = Mix((osc3 * (1 - mix)) + (osc1 * mix));
    snd = snd * (SinOsc.ar(lfoSpeed) * lfoDepth + 1);

    // using the doneAction: 2 on the other envs can create clicks (bc of the linear curve maybe?)
    snd = snd * EnvGen.ar(Env.asr(att, 1, rel), gate, doneAction: 2);
    snd = Pan2.ar(snd, pan, amp);

    Out.ar(out, snd);
}).add;

//modified from jpdarago's synth with iteration in https://github.com/jpdarago/supercollider-sounds/
SynthDef.new(\jpdSawIter, {|freq, gate = 1,att = 0.01, dec = 0.3, sus = 0.5, rel = 1,  out = 0, pan = 0, amp = 1|
	var temp,sum, env, n_saw = 10;
	sum = 0;
	env = EnvGen.ar(Env.adsr(att, dec, sus, rel), gate, doneAction: 2);
	n_saw.do{|count|
		temp = SinOsc.ar(freq
			* (count+1)
			* LFNoise1.kr({Rand(0.05, 0.2)}).range(0.98, 1.02)
		);
		sum = sum + temp;
	};
	sum = sum * n_saw.reciprocal;
	sum = Pan2.ar(sum*env*amp, pan);
	Out.ar(out, sum);
}).add;

SynthDef(\spKalimba, {
    |out = 0, freq = 440, amp = 0.1, mix = 0.1, pan = 0|
    var snd, click;
    // Basic tone is a SinOsc
    snd = SinOsc.ar(freq) * EnvGen.ar(Env.perc(0.03, Rand(3.0, 4.0), 1, -7), doneAction: 2);
	snd = HPF.ar( LPF.ar(snd, 380), 120);
    // The "clicking" sounds are modeled with a bank of resonators excited by enveloped white noise
	click = DynKlank.ar(`[
        // the resonant frequencies are randomized a little to add variation
        // there are two high resonant freqs and one quiet "bass" freq to give it some depth
        [240*ExpRand(0.97, 1.02), 2020*ExpRand(0.97, 1.02), 3151*ExpRand(0.97, 1.02)],
        [-9, 0, -5].dbamp,
        [0.8, 0.07, 0.08]
	], BPF.ar(PinkNoise.ar, 6500, 0.1) * EnvGen.ar(Env.perc(0.001, 0.01))) * 0.1;
	snd = (snd*mix) + (click*(1-mix));
	snd = Pan2.ar(snd*amp, pan);
    Out.ar(out, snd);
}).add;


//harpsichord synth from theseanco


SynthDef(\tscHarpsi1, { |out = 0, freq = 440, amp = 0.1, pan = 0, dist=0, smooth=0, click=0,atk=0.01,rel=1, sus=0.3, ts=1, fb=0.3, detune=0|
    var env, snd;
	env = EnvGen.ar(Env.linen(atk,sus,rel),timeScale:ts,doneAction:2);
	snd = LFTri.ar(freq, click, 1) * SinOscFB.ar(freq*((detune/100)+1),fb,1);
	snd = CrossoverDistortion.ar(snd,dist,smooth,1).clip;
	snd = snd * env;
	Out.ar(out, Pan2.ar(LeakDC.ar(snd), pan, amp));
}).add;

//thor magnusson's portbass
SynthDef(\tmPortbass, { |out = 0, freq = 440, gate = 1, amp = 0.5, slideTime = 0.17, ffreq = 1100, width = 0.15,
        detune = 1.005, preamp = 4, pan = 0|
    var    sig,
        env = Env.adsr(0.01, 0.3, 0.4, 0.1);
	freq = Lag.kr(freq, slideTime);
    sig = Mix(VarSaw.ar([freq, freq * detune], 0, width, preamp)).distort
        * EnvGen.kr(env, gate, doneAction: 2);
    sig = LPF.ar(sig, ffreq);
	sig = Pan2.ar(sig, pan, amp);
    Out.ar(0, sig);
}).add;


//eli fieldsteel's bpfsaw

SynthDef(\efBpfSaw, {|
	out = 0, atk=2, sus=0, rel=3, ts=1, c1=1, c2=(-1), freq=500, detune=0.2, pan=0, cfhzmin=0.1, cfhzmax=0.3, cfmin=500, cfmax=2000, rqmin=0.1, rqmax=0.2, lsf=200, ldb=0, amp=1|
	var sig, env;
	env = EnvGen.kr(Env([0,1,1,0],[atk,sus,rel],[c1,0,c2]),timeScale:ts,doneAction:2);
	sig = Saw.ar(freq*{LFNoise1.kr(0.5,detune).midiratio}!2);
	sig = BPF.ar(
		sig,
		{LFNoise1.kr(
			LFNoise1.kr(4).exprange(cfhzmin,cfhzmax)
		).exprange(cfmin,cfmax)}!2,
		{LFNoise1.kr(0.1).exprange(rqmin,rqmax)}!2
	);
	sig = BLowShelf.ar(sig,lsf,0.5,ldb);
	sig = Balance2.ar(sig[0],sig[1],pan);
	sig = sig*env*amp;
	Out.ar(out,sig);
}).add;