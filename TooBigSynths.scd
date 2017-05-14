//synths too big to send via UDP packet 

//miller puckette's phase vocoder ported from Pd
SynthDef(\dxkPvocM, {|buf, t_reset = 0, p_shift = 1, startpos = 0, amp = 1, out = 0, rate = 1, hopsize = 0.25, wintype = 1|
	//startpos: 0-1 -> startloc: 0 - BufSamples
	var winsize = 1024, input, grain_f, grain_b, readptr_f, readptr_b, grainptr, steptrig;
	var backhop = hopsize * winsize;
	var fft_f, fft_b, output, p_accum = 0;
	var ffthop = hopsize*2;
	var modamt = 1; //sounds better than 2pi for some reason?
	var bsamp = BufSamples.ir(buf);
	var startloc = startpos.mod(1) * bsamp;
	steptrig = Impulse.ar((winsize*SampleDur.ir).reciprocal);
	readptr_f = Stepper.ar(steptrig, t_reset, startloc, bsamp-winsize, winsize*rate, startloc);
	readptr_b = readptr_f - backhop;
	grainptr = Phasor.ar(steptrig, p_shift, 0, winsize, 0);
	grain_f = BufRd.ar(1, buf, readptr_f+grainptr, 1, 2);
	grain_b = BufRd.ar(1, buf, readptr_b+grainptr, 1, 2);
	fft_f = FFT(LocalBuf(winsize), grain_f, ffthop, wintype, winsize: winsize);
	fft_b = FFT(LocalBuf(winsize), grain_b, ffthop, wintype, winsize: winsize);
	fft_f = fft_f.pvcalc2(fft_b, winsize,
		{|mag_f, phase_f, mag_b, phase_b|
			var p_diff = phase_f-phase_b;
			var old_accum = p_accum;
			var new_accum = old_accum + p_diff;
			p_accum = new_accum.mod(modamt);
			[mag_f, old_accum]});
	output = IFFT(fft_f);
	Out.ar(out, output*amp);
}).add;