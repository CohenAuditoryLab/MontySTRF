%
%function [X,Env,Fm]=pnbjitsplinewinmodnoise(BW,Fm,j,gamma,fc,D,p,T,Fs)
%
%   FILE NAME   : PERIODIC JIT B SPLINE WIN MOD NOISE
%   DESCRIPTION : Generates a jittered periodic B-spline modulated noise signal for
%                 MTF experiments. The time of the pulses are jittered in time. 
%
%   BW          : Noise Bandwidth
%                 Default==inf (Flat Spectrum Noise)
%                 Otherwise BW=[F1 F2]
%                 where F1 is the lower cutoff and
%                 F2 is the upper cutoff frequencies
%   Fm          : Modulation Frequency (Hz)
%   j           : Applied random, uniform jitter (millisec)
%   gamma       : Modulation Index (0 < gamma < 1)
%   fc          : Cardinal B-Spline lowpass filter cutoff (Hz)
%   D           : Window Duration (msec)
%   p           : Cardinal B-Spline lowpass filter order
%   T           : Stimulus Duration (sec)
%   Fs          : Sampling frequency
%   seed        : Random seed - used to set the random number generator for
%                 creating the carrier noise signal. This is usefull if you
%                 want to create frozen noise carrier (OPTIONAL, randomized
%                 seed using clock and 'twizter' algorithm, see RAND)
%
%RETURNED VARIBLES
%
%   X       : Periodic B-Spline noise (PBS)
%             Normalized for a fixed energy per Hz
%   Env     : Periodic B-spline envelope
%   Fm      : Rounded off modulation frequency (Hz)
%
% (C) Monty A. Escabi and Timothy Nolan Jr, March 20018ffxszZZ ,     
%
function [X,Env,Fm]=pnbjitsplinewinmodnoise(BW,Fm,j,gamma,fc,D,p,T,Fs)

%Generating Burst Modulation Segment
N=round(Fs/Fm);

%Number of Modulation Cycles
L=floor(T*Fs/N);

%Number of Samples
NS=round(Fs*T);

%Filtering Periodic Pulse train with B-Spline lowpass filter - This
%generates the windowed B-spline envelope
h=bsplinelowpass(fc,p,Fs);
h=conv(ones(1,floor((D/1000)*Fs)),h);

%Generating jittered spike event time, and later impulse train
N1=ceil(j/1000/2*Fs);
spet=N1:N:round(L*Fs/Fm)-1;
spetj=spetaddjitterunif(spet,j,1,0,Fs);
impulse=spet2impulse(spetj,Fs,Fs,T+N1/Fs);
impulse2=spet2impulse(spet,Fs,Fs,T+N1/Fs);

%impulse=impulse(1:end-(Fm/2)*length(Y)+1);
%Env=conv(impulse,h);

%Normalizing Power Per Frequency Band
if BW~=inf
    N=N/std(N);
    N=N*sqrt(2*(BW(2)-BW(1))/Fs);
end

%Generating Modulated Noise
X=(Env*gamma+(1-gamma)).*N;