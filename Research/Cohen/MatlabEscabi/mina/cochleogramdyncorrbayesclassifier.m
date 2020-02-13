%
% function [Data]=cochleogramdyncorrbayesclassifier(SoundCat,M)
%   
%   FILE NAME   : COCHLEOGRAM DYN CORR BAYES CLASSIFIER
%   DESCRIPTION : Does classification using bayes classifier.
%                 It receives SoundCat from cochleogramdyncorrmodelvaldata.m 
%                 & output is used in cochleogramdyncorrbayesclassifierbatch.m
%                 
%   SoundCat    : Data to be analyzed  
%   M           : Number of consecutive samples used for validation       
%
% RETURNED VARIABLES
%
%   Data : Data structure containing sounds information
%
%          .SoundCat   : Data structure containing each category's validation sounds information
%
%                        .Sound : Data structure containing each validation sound information
%                                 .XScore   : Principal Component scores of the
%                                             validation sound
%                                 .OutputCat: Data structure containing
%                                             .P: Posteriori probability of the Validation
%                                                 Sound belonging to each OutputCat
%                                             .Prob: probability of each Validation Sound belonging to OutputCat 
%
%          .InputCat   : A vector containing validation sounds' category numbers
%          .OutputCat  : A vector containing bayesian resulted category
%                        numbers
%          .Sound      : A vector containing validation sounds' numbers
%          .Prob       : A matrix containing probablity of each validation sound
%                       (column number) belonging to each category (row number) 
%
%     
% (C) Mina, Sep 2016  

function [Data]=cochleogramdyncorrbayesclassifier(SoundCat,M)

%Defining variables
NCat=size(SoundCat,2);  %Finding number of categories
NSounds=cellfun(@length,{SoundCat(1:NCat).Sound});  %Vector containing the number of sounds in each category
Pprior=NSounds/sum(NSounds);  %Vector containing prior probability of each category 

TestCounter=1;
%Bayesian Classification                
    for count=1:NCat %Input Category
        for k=1:NSounds(count)
            for i=1:M:size(SoundCat(count).Sound(k).XScore,1)-M+1
                for m=1:NCat %Output Category 
                    %Vector containg time indices for selected data
                    TimeIndex=i:i+M-1;
                    
                    if SoundCat(count).Sound(k).OutputCat(m).Flag==1
                        %Finding probability of each Validation Sound belonging to each category
                        SoundCat(count).Sound(k).Prob(m)=log10(Pprior(m)) + sum(log10(SoundCat(count).Sound(k).OutputCat(m).P(TimeIndex)));
                    elseif SoundCat(count).Sound(k).OutputCat(m).Flag==-9999
                           SoundCat(count).Sound(k).Prob(m)=log10(Pprior(m));
                    end
                    
                end
        
                    %Finding the category number with maximum probability 
                    [~,index]= max([SoundCat(count).Sound(k).Prob]);
                    InputCat(TestCounter)=count;

                    %Returning the category number with maximum probability as OutputCat
                    OutputCat(TestCounter)=index;
                    Sound(TestCounter)=k;
                    Prob(:,TestCounter)=[SoundCat(count).Sound(k).Prob];
                    TestCounter=TestCounter+1;
            end
        end
    end

%Storing as data structure
Data.SoundCat=SoundCat;
Data.InputCat=InputCat;
Data.OutputCat=OutputCat;
Data.Sound=Sound;
Data.Prob=Prob;