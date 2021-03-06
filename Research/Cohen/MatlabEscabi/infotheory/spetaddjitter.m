%
%function [spet]=spetaddjitter(spet,sigma,p,lambdan,Fs,T)
%
%   FILE NAME   : SPET ADD JITTER
%   DESCRIPTION : Adds spike timming jitter, reproducibility noise
%                 and additive noise to a "spet" action potential
%                 sequence. Trial-to-trial reproducibility is modeled
%                 by a bernoulli process with probability p (p<1). For
%                 the case where p > 1, p represents the number of 
%                 "reliable" spikes and p follows a Poisson distribution
%                 with mean of p. Finally the timmming jitter is modeled by
%                 a gaussian distribution with standard deviation sigma. 
%                 Finally, the model also includes spontaneous Poisson 
%                 noise.
%
%   spet        : Spike Event Time Array
%   sigma       : Standard deviation of jitter distribution (msec).
%   p           : Trial-to-trial probability of producing an action
%                 potential.
%   lambdan     : Spike Rate for additive Noise component.
%   Fs          : Sampling frequency of spike train.
%   T           : Spike train duration in sec (optional)
%
%RETURNED VARIABLES
%
%   spet        : Noisy Spike Event Time Array
%
%   (C) Monty A. Escabi, Edit June 2014
%
function [spet]=spetaddjitter(spet,sigma,p,lambdan,Fs,T)

spetN=[];
for k=1:length(spet)
    if p>1
        Nspikes=poissrnd(p);    %p>=1, p corresponds to mean number of reliable spikes
    else
        Nspikes=1;              %If p<1 then we will later add reliability errors
    end
    for l=1:Nspikes
        %Adding spike timing Jitter
        dt=round(sigma/1000*Fs*randn);
        spetN=[spetN spet(k)+dt];
    end
end
spet=sort(spetN);
i=find(spet>=0);
spet=spet(i);

%Adding Reproducibility Noise
if p<=1
    X=bernoullirnd(p,1,length(spet));
    ii=find(X==1);
    spet=spet(ii);
end

%Adding Additive Spike Noise at Spike Rate of Lambdan
%Added only at time intervals with no spiking
if lambdan~=0
    if exist('T')
        X=spet2impulse(spet,Fs,Fs,T);
        index=find(X==0);,clear X
        N=poissrnd(lambdan*T); 
        i=1+round((length(index)-2)*rand(1,N));
        spet=sort([spet index(i)]);
    else
        X=spet2impulse(spet,Fs,Fs); 
        index=find(X==0);,clear X
        N=poissrnd(lambdan*max(spet)/Fs); 
        i=1+round((length(index)-2)*rand(1,N));
        spet=sort([spet index(i)]);
    end
end