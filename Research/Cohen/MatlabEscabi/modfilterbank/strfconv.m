%
%   FILE NAME       : STRF 2D CONVOLUTION
%   DESCRIPTION     : STRF here is a 2D filterbank: 
%                     The convolution of each filter and the input
%                     spetrogram is 2D also, but the sharp edge of input
%                     may affect the result. 
%                     Fliped images are added to the edges to eliminate the
%                     effects of cutting edges. 
%
%   spectrogram     : the spectrogram to be analized
%   filter          : the receptive field of a filter (each time one filter)
%
%RETURNED VARIABLES
%
%   STC             : Spectrotemporal Convolution result (the same size as spectrogram)
%
% Apr 9, 2018

function [STC] = strfconv(spectrogram,filter)
[ny,nx]=size(spectrogram);
spectro = [flip(flip(spectrogram,1),2),flip(spectrogram,1),flip(flip(spectrogram,1),2);
           flip(spectrogram,2),        spectrogram,        flip(spectrogram,2);
           flip(flip(spectrogram,1),2),flip(spectrogram,1),flip(flip(spectrogram,1),2)];
tripleconv = conv2(filter, spectro);
STC = tripleconv(ny+1:end-ny,nx+1:end-nx);

