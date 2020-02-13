
%function [PsychoData]=psychosoundab(X,Fs,NReps,NChan,Order,Volume,MinMaxDelay,SubjectIdentifier)
%
%   FILE NAME       : PSYCHO SOUND A/B
%   DESCRIPTION     : Delivers two sounds, A or B, and requires that one
%                     identify the sound delivered using key presses or key
%                     pad. This routine is useful for categorical
%                     perception experiments. The routines receive a
%                     matrix countaining all of the sounds to be delivered
%                     and plays them back in block randomized order
%
%   X               - NxM Matrix containing all sounds. N is the number of
%                     sounds and M is the number of samples
%   MinMaxDelay     - Vector of form [Min Max] containing the minimum 
%                     and maximum delay used to play a sound
%   SubjectIdenfier - Subject Information String
%
% RETURNED VALUES
%
%   PsychoData  : Data structure containing experiment results
%
%               .ResponseTime       - in seconds
%               .Response           - Enmerated as a keypress.
%               .Param.NReps        - Number of repetitions
%               .Param.NChan        - Number of audio channels
%               .Param.Fs           - Sampling rate (Hz)
%               .Param.Order        - Parameter order used 
%               .Param.Volume       - Volume
%               .MinMaxDelay        - Maximum and Minimum delay vector
%               .SubjectIdentifier  - Subject information
%               .Date               - Experiment Data
%               .DateTimeBegin      - Experiment Start Time
%               .DateTimeEnd        - Experiment End Time
%
% (C) Monty A. Escabi, March 2018
%
function [PsychoData]=psychosoundab(X,Fs,NReps,NChan,Order,Volume,MaxMinDelay,SubjectIdentifier)

%Date Time Begin
DateTimeBegin=datetime;

% Initialize Sounddriver
InitializePsychSound(1);

% Start immediately (0 = immediately)
startCue = 0;

% Should we wait for the device to really start (1 = yes)
% INFO: See help PsychPortAudio
waitForDeviceStart = 1;

% Open Psych-Audio port, with the follow arguements
% (1) [] = default sound device
% (2) 1 = sound playback only
% (3) 1 = default level of latency
% (4) Requested frequency in samples per second
% (5) 2 = stereo putput
pahandle = PsychPortAudio('Open', [], 1, 1, Fs, NChan);

% Set the volume to half for this demo
PsychPortAudio('Volume', pahandle, 0.5);

%Sound Delivery Order
NSounds=size(X,1);
Order = randperm(NSounds,NSounds);

%Keyboard Input Keys
 g=KbName('g');
 r=KbName('r');
        
%Delivering sounds for all conditions
clc
VarDelay=MaxMinDelay(1)+rand(1,NReps*NSounds)*(MaxMinDelay(2)-MaxMinDelay(1));
for k=1:NReps
    for l=1:NSounds
    
    % Fill the audio playback buffer with the audio data, doubled for stereo
    % presentation
    PsychPortAudio('FillBuffer', pahandle, [X(Order(l),:); X(Order(l),:)]);
    %PsychPortAudio('DeleteBuffer'[, bufferhandle] [, waitmode]);
    %PsychPortAudio('RefillBuffer', pahandle [, bufferhandle=0], bufrrferdata [, startIndex=0]);

    % Start audio playback
    PsychPortAudio('Start', pahandle, NReps, startCue, waitForDeviceStart);

    %Obtain Response and Response Time
    t0=GetSecs;
    [KeyIsDown,secs,keyCode]=KbCheck;    
    while keyCode(g)==0 && keyCode(r)==0
        [keyIsDown,secs,keyCode] = KbCheck;
    end
    ResponseTime(l) = secs-t0;
    Response(l) = find(keyCode==1);
    
    %Variable Delay between last sound and next
    WaitSecs(VarDelay(l+(k-1)*NReps));
    
    end
end

%Close Audio Port
PsychPortAudio('Close', pahandle);

%Storing Experiment Results in Data Strucuture

PsychoData.Response=Response;
PsychoData.ResponseTime=ResponseTime;
PsychoData.VarDelay=VarDelay;
PsychoData.Param.NReps=NReps;
PsychoData.Param.NChan=NChan;
PsychoData.Param.Fs=Fs;
PsychoData.Param.Order=Order;
PsychoData.Param.Volume=Volume;
PsychoData.MaxMinDelay=MaxMinDelay;
PsychoData.SubjectIdentifier=SubjectIdentifier;
PsychoData.DateTimeBegin=DateTimeBegin;
PsychoData.DateTimeEnd=datetime;

