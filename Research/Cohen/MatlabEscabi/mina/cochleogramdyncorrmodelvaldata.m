%
% function [SoundCat]=cochleogramdyncorrmodelvaldata(Data,PCNum,GMNum)
%   
%   FILE NAME   : COCHLEOGRAM DYN CORR MODEL VAL DATA
%   DESCRIPTION : Divides sounds into 2 groups: one sound will be used for 
%                 validation & the rest will be used for modeling. This will 
%                 be repeated for every single sound in each category.
%                 It receives Data from cochleogramdyncorrdata2cell.m & output 
%                 is used in cochleogramdyncorrbayesclassifierbatch.m
%                
%   Data        : Data to be sorted
%   PCNum       : Number of principal components to be used in analysis
%   GMNum       : Number of Gaussian components fitted to data
%
% RETURNED VARIABLES
%
%  SoundCat     :  Data structure containing
%
%                 .Sound : Data structure containing each validation sound information
%                          .XScore   : Principal Component scores of the
%                                      validation sound
%                          .OutputCat: Data structure containing
%                                      .P: Posteriori probability of the Validation
%                                          Sound belonging to each OutputCat
%                 
%                 .Param : Data structure containing SoundCat
%                          parameters(Note that it's the same for all different
%                          categories)
%                         .FreqChan   : Number of frequency channels used for
%                                       analysis (1st & 2nd dim of RxyN)
%                         .Tau        : Number of time lag(delay) points (3rd dim of RxyN)
%                         .Time       : Number of time points (4th dim of RxyN)
%                         .Analysis   : Analysis Type 
%                         .N          : Number of sound categories used
%                         .CorrParam  : Correlation parameters
%                         .PCNum      : Number of principal components used
%                         .GMNum      : Number of Gaussian components used
%
% (C) Mina, Sep 2016  

function [SoundCat]=cochleogramdyncorrmodelvaldata(Data,PCNum,GMNum)

XData=Data.X;

%Defining variables
NCat=size(XData,1);  %Finding number of categories 
NSounds=cellfun('length',XData);  %Vector containing the number of sounds in each category

%Removing one sound at a time from a given category - the sound removed
%is used for validation
for CatCounter=1:NCat %Going through all categories - used for pseudo jackknife for validation
    for SoundCounter=1:NSounds(CatCounter)  %Going through all sounds - pseudo jackknife for validation
        
        %Removing sound
        X.ValData=cell2mat(XData{CatCounter,1}(SoundCounter));  %Putting the validation sound data in a matrix 
        X.ModelData=XData;
        X.ModelData{CatCounter,1}(SoundCounter)=[];  %Omitting the validation sound from data to make the model

       %Combining Data from different categories in order to take PCA and build category models
       ModelData=[];
       Cat=cell2struct(X.ModelData,'ModelData',NCat);
       for Counter=1:NCat
           xtemp=cell2mat(Cat(Counter).ModelData(:)); 
           ModelNtrial(Counter)=size(xtemp,1);         %Number of trials (rows) of each category's model matrix (needed to find gaussian mixture model for each category)
           ModelData=[ModelData; xtemp];         %Combining model data for different categories, Rows & Columns are corresponding to time points & features respectively
       end
       
       %Normalizing data for zero mean - Finding the mean of model data & subtracting it from model & validation data
       ModelDataMean=mean(ModelData,1);  %Vector containing mean of columns (features) of Model data 
       X.ValData=X.ValData-repmat(ModelDataMean,size(X.ValData,1),1);  %Subtracting the mean of model data from validation data
       ModelData=ModelData-repmat(ModelDataMean,size(ModelData,1),1);  %Subtracting the mean of model data from model data
       
       %Computing PCA on model data
       [Modelcoeff,ModelScore]=pca(ModelData,'Algorithm','svd','Centered',false);  %Performing principal component analysis on model data

       %Fitting data from each category to gaussian mixture model
        for count=1:NCat
            index=(1:ModelNtrial(count)) + sum(ModelNtrial(1:count-1));         %Finding indices for data from each category - note that there may be multiple sounds per category
            %TRY / CATCH in case of convergence problems
            try
               Cat(count).GMModel = fitgmdist(ModelScore(index,1:PCNum),GMNum,'CovarianceType','diagonal','Options',statset('MaxIter',1000)); %Fitting Gaussian mixture dist to each category's principal component scores
               Cat(count).flag=1;
               SoundCat(CatCounter).Sound(SoundCounter).OutputCat(count).Flag=1;
            catch
               Cat(count).flag=-9999;
               SoundCat(CatCounter).Sound(SoundCounter).OutputCat(count).Flag=-9999;
            end
        end
      
        %Finding PC scores of the Validation Sound in each category
        SoundCat(CatCounter).Sound(SoundCounter).XScore=X.ValData/(Modelcoeff');  
        %Finding Posteriori probability of the Validation Sound belonging to each category
        for m=1:NCat %Output Category
            if Cat(m).flag == 1
            SoundCat(CatCounter).Sound(SoundCounter).OutputCat(m).P = pdf(Cat(m).GMModel,SoundCat(CatCounter).Sound(SoundCounter).XScore(:,1:PCNum));  
            end
        end
    end
    
    %Storing SoundCat Parameters as data structure
    SoundCat(CatCounter).Param = Data.Param;
    SoundCat(CatCounter).Param.PCNum = PCNum;
    SoundCat(CatCounter).Param.GMNum = GMNum;
end