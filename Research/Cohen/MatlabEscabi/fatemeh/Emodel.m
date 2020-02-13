% function [Emodel1,Emodel2,DataSeg,Callparameters]= Emodel(DataEnvSeg,dt,Noise)
%
%   FILE NAME   : EModel (Envelope model)
%   DESCRIPTION : Envelope for Model1 and Model2, DataSegment (Each Call),
%                 and Call parameters (Start Time, End Time, Duration,
%                 Interval, and Peak Amplitude)
%                 
%                 
%   Inputs: 
%           DataEnvSeg:     
%
%                       parameters:Parameters which used for Envelope
%                                  calculation
%                       E         :Envelope of signal calculated for 
%                                   segmentation
%                       Xa        :Filterd Signal
%                       
%           dt          :       minimum call duration in second  
%           Noise       :       Vector of signal selected as Noise
%
%   Output:
%           Emodel1       :       Envelope of Model1/ mactch Duration,
%                                 vector
%           Emodel2       :       Envelope of Model2/ mactch Duration and Amplitude
%                                 vector
%           DataSeg       : Call segments
%               Call    % Selected Call
%               W       % Selected Call Envelope
%               Wrec    % Model1 for each Call
%               WrecA   % Model2 (matched Amplitude) for each Call 
%
%           Parameters    : Parameters of Call segments
%               PeakAmplitude % Peak Amplitude of each Call
%               StartTimeSig  % Start Time of each Call based on
%                               Significancy (Threshold)
%               EndTimeSig    % End Time of each Call based on
%                               Significancy (Threshold)
%               StartTime50   % Start Time of each Call based on
%                               50% of maximum Amplitude
%               EndTime50     % End Time of each Call based on
%                               50% of maximum Amplitude
%               dt            % minimum call duration (sec)
%                           
%
% (C) Fatemeh Khatami, Feb. 2016
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [Emodel1,Emodel1norm,Emodel2,Emodel2norm,DataSeg,Callparameters]= Emodel(DataEnvSeg,dt,Noise)
% Extract DataSegments and parameters
[DataSeg parameters]=callsegmentparam(DataEnvSeg,dt,Noise);
parameters.Interval50=diff(parameters.StartTime50)./DataEnvSeg.parameters.Fs;
parameters.Durations50=(parameters.EndTime50-parameters.StartTime50)./DataEnvSeg.parameters.Fs;
parameters.DurationsSig=(parameters.EndTimeSig-parameters.StartTimeSig)./DataEnvSeg.parameters.Fs;
Callparameters=parameters;
    for k=1:length(DataSeg)
        
            A(k)=sqrt(sum((DataSeg(k).ECall).^2)./length(DataSeg(k).ECall));
            WW1(parameters.StartTimeSig(k):parameters.EndTimeSig(k))=A(k)*ones(1,parameters.EndTimeSig(k)-parameters.StartTimeSig(k)+1);
            WW(parameters.StartTimeSig(k):parameters.EndTimeSig(k))=ones(1,parameters.EndTimeSig(k)-parameters.StartTimeSig(k)+1);
                    
    end
Emodel1=WW;
Emodel1norm=WW./std(WW);
Emodel2=WW1;
Emodel2norm=WW1./std(WW1);
Callparameters.AdaptedAmp=A;
