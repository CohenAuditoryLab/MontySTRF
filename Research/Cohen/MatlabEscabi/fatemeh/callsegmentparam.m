%function [DataSeg Parameters]=callsegmentparam(DataEnv,dt)
%
%   FILE NAME   : Call Segment Parameter
%   DESCRIPTION : Find call segment and its Parameters, 
%   
% Inputs
%   DataEnv     :  
%            E  : Envelope of Data
%            Xa : Bandpass Filtered Signal
%        param  : parameters used for generationg envelope
%    
%
%    dt         % minimum call duration in second
%  
%
%RETURNED OUTPUT
%
% DataSeg       : Call segments
%               Call
%               W
%               Wrec
%               WrecA
% Parameters    : Parameters of Call segments
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
% (C) Fatemeh Khatami May 2015, 
%     Edited  Jan 2016


function [DataSeg Parameters]=callsegmentparam(DataEnv,dt,Noise)
E=DataEnv.Enorm;
wt=DataEnv.parameters.wt;
Fs=DataEnv.parameters.Fs;
dSFactor=DataEnv.parameters.dSFactor;
z=DataEnv.parameters.z;
Data=DataEnv.Xa;
mint=round(Fs*dt/dSFactor);
Parameters.dt=dt;
% Find background Noise based on mean value
if nargin<3
     Noise=noisedetect(E,wt,Fs);
    % Select the noise manually in case that it wasn't selected Aitomatically
    if isempty(Noise)
        CreateStruct.Interpreter = 'tex';
        CreateStruct.WindowStyle = 'modal';
        msgbox('Select Noise Segment Manually','Value',CreateStruct);
        pause(5)
        figure(1);plot(E);
        [x,y]=ginput(2);
        Noise=E(x(1):x(2));
        msgbox('Noise Segment Selected Successfully','Value',CreateStruct);
        pause(2)
        close all
    end
end
STD=std(Noise);
MU=mean(Noise);
% DownSample Envelope
E1=E(1:dSFactor:end);
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
%close all


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
   
    if I2(k+1)-I1(k)>mint   % && max(E1(I1(k):I2(k+1)))> 2*z*max(Noise) %8E-5 max(Noise); z*max(Noise)
            % Each Call Segment
            PeakAmplitude_1=max(E1(I1(k)-1:I2(k+1)+1));
            b1=find(E1(I1(k)-1:I2(k+1)+1)>0.5*PeakAmplitude_1);
            B1T=isempty(b1);
            if B1T==0  
            count=count+1;
            time=I1(k)-1:I2(k+1)+1;
            StartTime50_1=time(b1(1));
            EndTime50_1=time(b1(end));
            %
            Parameters.PeakAmplitude(count)=max(E1(I1(k)-1:I2(k+1)+1)); 
            Parameters.StartTimeSig(count)=dSFactor*(I1(k)-1);
            Parameters.EndTimeSig(count)=dSFactor*(I2(k+1)+1);
            Parameters.StartTime50(count)=StartTime50_1*dSFactor; % 
            Parameters.EndTime50(count)=EndTime50_1*dSFactor; % 
            %Parameters.CallDuration(count)=(Parameters.EndTimeSig(count)-Parameters.StartTimeSig(count))./Fs;
            %Parameters.CallDurations50(count)=(Parameters.EndTime50(count)-Parameters.StartTime50(count))./Fs;
            DataSegment(count).Call=Data(dSFactor*(I1(k)-1):dSFactor*(I2(k+1)+1));
            DataSegment(count).ECall=E(dSFactor*(I1(k)-1):dSFactor*(I2(k+1)+1));
            DataSegment(count).W=Z(I1(k)-1:I2(k+1)+1);
            %%Considering rectangular window
            m=find(DataSegment(count).W/max(DataSegment(count).W)>0.5);
            DataSegment(count).Wrec=zeros(size(DataSegment(count).W));
            DataSegment(count).Wrec(m(1):m(end))=ones(1,m(end)-m(1)+1);
            %%Considering rectangular window and Amplitude
            DataSegment(count).WrecA=DataSegment(count).Wrec/sum(DataSegment(count).Wrec)*sum(DataSegment(count).W);
            DataSegment(count).WrecA=DataSegment(count).Wrec/sqrt(sum(DataSegment(count).Wrec))*sqrt(sum((DataSegment(count).W).^2));
            end
            
    end
        
end

if  isempty(DataSegment)
    DataSeg=[];
    else
    DataSeg=DataSegment;
end