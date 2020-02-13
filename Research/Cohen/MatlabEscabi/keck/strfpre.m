%
%function [T,Y]=strfpre(S,taxis,faxis,STRF,Display)
%
%   FILE NAME       : STRF PRE
%   DESCRIPTION     : Predict neural response of a STRF to a
%                     spectro-temporal input (S).
%
%	S               : Spectro-temporal input
%   taxis           : Time Axis for STRF
%	faxis           : Frequency Axis for STRF
%	STRF            : Spectro-temporal receptive field
%	Disp            : Display : 'y' or 'n'
%                     Default : 'y' 
%
%OUTPUT VARIABLES
%	T		: Time Axis
%	Y		: Predicted Output
%
function [T,Y]=strfpre(S,taxis,faxis,STRF,Display)

%Preliminaries
if nargin<5
	Display='y';
end

%Dimensions
N1=length(STRF(:,1));
N2=length(STRF(1,:));

%Computing spectro-temporal output
Y=sum(convlinfft(STRF,S),1);

%Time Axis
T=(0:length(Y)-1)*taxis(2);

%Displaying if Desired
if strcmp(Display,'y')
	plot(T,Y,'b')
end