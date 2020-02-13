%
%function [y]=rectwinmodel3(beta,time,A1)
%
%
%   FILE NAME       : RECT WIN MODEL - 3 PARAMETERS
%   DESCRIPTION     : Generates a rectangular window with parameters as
%                     described below
%
%   beta    : Parameter vector where beta = [T1 T2 A] as defined and
%             illustrated below
%
%             T1 - on time (sec)
%             T2 - off time (sec)
%             A  - pulse amplitude
%
%            A2  |---------|
%                |         |
%    A1  ________|         |________
%                T1        T2
%
%	time	: Input time axis in sec
%
%OUTPUT VALUES
%
%	y		: Rectangular pulse output
%
function [y]=rectwinmodel3(beta,time,A1)

[y]=rectwinmodel([beta(1) beta(2) A1 beta(3)],time);

