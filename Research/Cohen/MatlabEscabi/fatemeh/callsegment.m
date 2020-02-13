%function [CallSegData,CallSegParam]=callsegment(DataEnv,DataEnvSeg,z,dt,dSFactor,N)
%
%   FILE NAME   : Call Segment
%   DESCRIPTION : Segments a vocalization sequence into the individual calls 
%   
% Inputs
%   DataEnv     : Data structure containing all of the extracted envelope
%                 information. Typically this is filtered at ~200-500 Hz.
%        .E     : Envelope of Data
%        .Enorm : Normalized envelope with unit standard deviation
%        .Xa    : Bandpass Filtered Signal
%        .Param : parameters used for generationg envelope
%   DataEnvSeg  : Data structure containing all of the extracted envelope
%                 information. Lowpass filtered at a very low frequency
%                 (~30 Hz) to allow detection of vocalization segments
%        .E     : Envelope of Data
%        .Enorm : Normalized envelope with unit standard deviation
%        .Xa    : Bandpass Filtered Signal
%        .Param : parameters used for generationg envelope   
%   z           : Detection threshold (in number of SD)
%   dt          : Minimum call duration in second
%   dSFactor    : Envelope Downsampling Factor
%   N           : Vector containg [N1 N2] where N1 is the start sample and 
%                 N2 is the end sample of the envelope noise signal
%
%RETURNED OUTPUT
%
% CallSegData   : Data structure array containing call segments
%
%         .Call     - original vocalization for each segment
%         .ECall    - Envelope of the vocalization for each segment
%         .ESegCall - Envelope used for segmentation for each segment
%
% CallSegParam  : Data structure containg Segementation parameter
%                 information
%
%               .PeakAmplitude % Peak Amplitude of each Call
%               .StartTimeSig  % Start Time of each Call based on
%                               Significancy (Threshold)
%               .EndTimeSig    % End Time of each Call based on
%                               Significancy (Threshold)
%               .StartTime50   % Start Time of each Call based on
%                               50% of maximum Amplitude
%               .EndTime50     % End Time of each Call based on
%                               50% of maximum Amplitude
%               .dt            % minimum call duration (sec)
%               .MuNoise       % Noise envelope mean value - required for
%                                model fitting
%               .Fs            % Sampling rate of sound
%
% (C) Fatemeh Khatami May 2015, 
%     Edited  Jan 2016
%
function [CallSegData,CallSegParam]=callsegment(DataEnv,DataEnvSeg,z,dt,dSFactor,N)

%Envelope and Noise Envelope
E=DataEnv.Enorm;
ESeg=DataEnvSeg.Enorm;
ENoise=DataEnvSeg.Enorm(N(1):N(2));

%Parameters
Fs=DataEnv.Param.Fs;
Data=DataEnv.Xa;
mint=round(Fs*dt/dSFactor);
CallSegParam.dt=dt;

% Find background Noise based on mean value
if nargin<3
     ENoise=noisedetect(E,wt,Fs);
    % Select the noise manually in case that it wasn't selected Aitomatically
    if isempty(ENoise)
        CreateStruct.Interpreter = 'tex';
        CreateStruct.WindowStyle = 'modal';
        msgbox('Select Noise Segment Manually','Value',CreateStruct);
        pause(5)
        figure(1);plot(E);
        [x,y]=ginput(2);
        ENoise=E(x(1):x(2));
        msgbox('Noise Segment Selected Successfully','Value',CreateStruct);
        pause(2)
        close all
    end
end
STD=std(ENoise);
MU=mean(ENoise);

% DownSample Envelope
E1=ESeg(1:dSFactor:end);
Zs=(E1-MU)/STD;

% find Start and End point of each call based on Z score
i=find(Zs>z);
n=find(diff(i)>1);% & i(1:end-1)>1 );
n2=n;
n1=n+1;
figure;
plot(Zs)
hold on
plot(i(n),Zs(i(n)),'r+')
plot(i(n+1),Zs(i(n+1)),'g+')

if rem(length(n),2)==0
   Endpoint=i(n);
  Startpoint=i(n+1);
  else
  Endpoint=i(n+1);
  Startpoint=i(n+2);
end
I1=Startpoint;
I2=Endpoint;
Z=Zs;



n1=length(I1);
DataSegment=[];
count=0;
for k=1:n1-1
   
    if I2(k+1)-I1(k)>mint   % && max(E1(I1(k):I2(k+1)))> 2*z*max(ENoise) %8E-5 max(ENoise); z*max(ENoise)
           
        % Each Call Segment
            PeakAmplitude_1=max(E1(I1(k)-1:I2(k+1)+1));
            b1=find(E1(I1(k)-1:I2(k+1)+1)>0.5*PeakAmplitude_1);
            B1T=isempty(b1);
            if B1T==0  
            count=count+1;
            time=I1(k)-1:I2(k+1)+1;
            StartTime50_1=time(b1(1));
            EndTime50_1=time(b1(end));
            
            %Data Start and End times
            CallSegParam.PeakAmplitude(count)=max(E1(I1(k)-1:I2(k+1)+1)); 
            CallSegParam.StartTimeSig(count)=dSFactor*(I1(k)-1);
            CallSegParam.EndTimeSig(count)=dSFactor*(I2(k+1)+1);
            CallSegParam.StartTime50(count)=StartTime50_1*dSFactor; % 
            CallSegParam.EndTime50(count)=EndTime50_1*dSFactor; % 
            CallSegParam.MuNoise=MU;
            CallSegParam.Fs=Fs; %Original sampling rate of sound
            
            %Extracting Call Segments
            DataSegment(count).Call=Data(dSFactor*(I1(k)-1):dSFactor*(I2(k+1)+1));
            DataSegment(count).ECall=E(dSFactor*(I1(k)-1):dSFactor*(I2(k+1)+1));
            DataSegment(count).ESegCall=ESeg(dSFactor*(I1(k)-1):dSFactor*(I2(k+1)+1));
            
            end
            
    end
        
end

if  isempty(DataSegment)
    CallSegData=[];
    else
    CallSegData=DataSegment;
end