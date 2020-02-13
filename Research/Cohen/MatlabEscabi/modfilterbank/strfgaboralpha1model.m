%
%function [STRFm]=strfgaboralpha1model(beta,input)
%
%   FILE NAME       : STRF GABOR ALPHA 1
%   DESCRIPTION     : Separable STRF model. The spectral receptive field
%                     is modeled as a gabor function while the temporal
%                     receptive field is modeled as the product of an alpha
%                     fucntion and a cosine.
%
%   beta            : STRF parameter vector
%                     beta(1): Response latency (msec)
%                     beta(2): Fm: Character Modulation Frequency (Hz)
%                     beta(3): Temporal modulation bandwidth (Hz)
%                     beta(4): Temporal phase (0-2*pi)/defual as pi/4
%
%                     beta(5): Best octave frequency, xo
%                     beta(6): Spectral Modulation Bandwidth (cycles/octaves)
%                     beta(7): Best spectral modulation frequency (cycles/octaves)
%                     beta(8): Spectral phase (0-2*pi)
%                     beta(9): Peak Amplitude
%   input.taxis     : Time axis (msec)
%   input.X         : Octave frequency axis (octaves)
%
%RETURNED VARIABLES
%
%   STRFm           : Speraable STRF model
%
% Feb 2, 2018

function [STRFm]=strfgaboralpha1model(beta,input)

betat=beta(1:4);% for trfalpha1model
betas=beta(5:9);% for srfgabormodel
betas(2)=1/betas(2);%/4/pi;   %Convert spectral modulation bandwidth (cycles/oct) to Receptive Field Bandwidth (oct)
[TRF]=trfalpha1model(betat,input.taxis);
[SRF]=srfgabormodel(betas,input.X);

STRFm = SRF'*TRF;

end