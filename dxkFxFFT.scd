//fft effects

SynthDef(\dxkPV_MagGateM, {|thresh = 1, remove = 0, hop = 0.5, wintype = 0, winsize = 2048, in = 10, out = 0, amp = 1|
	var input, output, fft;
	input = In.ar(in, 1);
	fft = FFT(LocalBuf(winsize,1), input, hop, wintype, winsize: winsize);
	fft = PV_MagGate(fft, thresh, remove);
	output = IFFT(fft, wintype, winsize);
	ReplaceOut.ar(out, output*amp);
}).add;


SynthDef(\dxkPV_MagGateS, {|thresh = 1, remove = 0, hop = 0.5, wintype = 0, winsize = 2048, in = 10, out = 0, amp = 1|
	var input, output, fft;
	input = In.ar(in, 2);
	fft = FFT(LocalBuf(winsize, 2), input, hop, wintype, winsize: winsize);
	fft = PV_MagGate(fft, thresh, remove);
	output = IFFT(fft, wintype, winsize);
	ReplaceOut.ar(out, output*amp);
}).add;