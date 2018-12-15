
//original work by jeff on 6/17/08 based on a James McCartney example
//found in the synthdefpool as cheappiano
//tweaked some things, like the trig for Decay2, various amp parameters, amp envelope
SynthDef(\dxkCheapPno, { |t_trig=1, freq=440, amp=1, dur=1, pan=0, out = 0|
	var output, n = 6, max = 0.04, min = 0.01, delay, pitch, detune, hammer;
	freq = freq.cpsmidi;
	hammer = Decay2.ar(Trig.ar(t_trig, SampleDur.ir), 0.08, 0.04, LFNoise2.ar([2000,4000].asSpec.map(amp), 0.25));
	output = Mix.ar(Array.fill(3, { arg i;
			detune = #[-0.04, 0, 0.03].at(i);
			delay = (1/(freq + detune).midicps);
			CombL.ar(hammer, delay, delay, 50*amp)
		}) );

	output = HPF.ar(output,freq.midicps) * EnvGen.ar(Env.perc(0.01,dur, amp, -1), doneAction:2);
	output = Pan2.ar(output, pan);
	Out.ar(out, output);
}).add;


//Detuned Synth Pad by coreyker from sccode.org http://sccode.org/1-4YS
//in turn taken from http://www.attackmagazine.com/technique/synth-secrets/detuned-pad/
//added amp, pan (instead of original Splay), changed some variables to args (lfo/lop/detune)

SynthDef(\dxkDesyp1, {|gate = 1, freq = 440, att = 0.001, dec = 0.001, sus = 0.75, rel = 0.125, lfofreq = 3, lopfreq = 800, rq = 0.5,
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
//changed env2 to multiplicative instead of additive
	SynthDef(\dxkAcid, {|gate = 1, freq = 440, rq = 0.3, out = 0, amp = 1, pan = 0|
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



//from FM Rhodes by snappizz found on sccode (synthdef as rhodey_sc)
//very minor tweaks (arg-izing matt, decay, rel)
SynthDef(\dxkRhodes1, {
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
SynthDef.new(\dxkSawIter, {|freq, gate = 1,att = 0.01, dec = 0.3, sus = 0.5, rel = 1,  out = 0, pan = 0, amp = 1|
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

// snappizz's kalimbda
SynthDef(\dxkKalimba1, {
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


SynthDef(\dxkHarpsi1, { |out = 0, freq = 440, amp = 0.1, pan = 0, dist=0, smooth=0, click=0,atk=0.01,rel=1, sus=0.3, ts=1, fb=0.3, detune=0|
    var env, snd;
	env = EnvGen.ar(Env.linen(atk,sus,rel),timeScale:ts,doneAction:2);
	snd = LFTri.ar(freq, click, 1) * SinOscFB.ar(freq*((detune/100)+1),fb,1);
	snd = CrossoverDistortion.ar(snd,dist,smooth,1).clip;
	snd = snd * env;
	Out.ar(out, Pan2.ar(LeakDC.ar(snd), pan, amp));
}).add;

//thor magnusson's portbass
SynthDef(\dxkPortBass, { |out = 0, freq = 440, gate = 1, amp = 0.5, slideTime = 0.17, ffreq = 1100, width = 0.15,
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

SynthDef(\dxkBpfSaw, {|
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