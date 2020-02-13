%
%function [W]=bsplinewindowlowpass(Fs,p,dt,fc)
%
%       FILE NAME       : B SPLINE WINDOW LOWPASS
%       DESCRIPTION     : Ramped window desinged using Cardinal B-Spline derivation 
%                         by Roark and Escabi
%
%       Fs:     : Sampling Rate
%       p       : B-spline window transition region order
%       dt      : B-spline window width ( msec )
%       fc      : B-spline window lowpass cutoff frequency ( Hz )
%
%
%       Note that fc is inversely related to RT (see SPLINELOWPASS.m)
%       See also BSPLINEWINDOW.m for alternative formulation
%
%                 ______________________
%                /                      \
%               /                        \
%              /                          \
%             /|                          |\
%       _____/_|__________________________|_\_____
%              |                          |
%              |                          |
%              |<-----------dt----------->|
%            <-rt-> 
%            
% (C) Monty A. Escabi, 2018
%
function [W]=bsplinewindowlowpass(Fs,p,dt,fc)

%Generating Spline Window
[h]=bsplinelowpass(fc,p,Fs);
h=h/sum(h);

%Convolving Spline with Square Window
NW=floor(dt/1000*Fs)
W=ones(1,NW);
W=conv(W,h);
