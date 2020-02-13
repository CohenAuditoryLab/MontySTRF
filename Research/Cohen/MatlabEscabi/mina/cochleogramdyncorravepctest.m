%
% function [k]=cochleogramdyncorravepctest(Data,var)
%   
%   FILE NAME   : COCHLEOGRAM DYN CORR AVE PC TEST
%   DESCRIPTION : Returns the minimum number of PCs required to explain 
%                 var% variability in data. 
%
%   Data        : Data to be analyzed
%   var         : Desired variance percentage explained by PCA 
%
% RETURNED VARIABLES
%
%   k           : Minimum number of PCs required to explain var% variability 
%                 in data 
%     
% (C) Mina, Dec 2017 

function [k]=cochleogramdyncorravepctest(Data,var)

XData=Data.X;
NCat=size(XData,1);  %Finding number of categories
X.ModelData=XData;

ModelData=[];

%Combining Data from different categories in order to take PCA 
Cat=cell2struct(X.ModelData,'ModelData',NCat);

for Counter=1:NCat
    xtemp=cell2mat(Cat(Counter).ModelData(:)); 
    ModelNtrial(Counter)=size(xtemp,1);         %Number of trials (rows) of each category's model matrix (needed to find gaussian mixture model for each category)
    ModelData=[ModelData; xtemp];         %Combining model data for different categories, Rows & Columns are corresponding to time points & features respectively
end

ModelDataMean=mean(ModelData,1);  %Vector containing mean of columns (features) of Model data 
ModelData=ModelData-repmat(ModelDataMean,size(ModelData,1),1);  %Subtracting the mean of model data from model data

%Computing k
eigenvalue=eig(cov(ModelData));  %The eigenvalues of the covariance matrix of ModelData
VarSum=cumsum(flipud(eigenvalue));  %Computes the cumulative sum of principal component variances
var=var/100;  %Converting var to var%
k=min(find((VarSum>(var*VarSum(end))),1));  %Finding the minimum principal component required to get var% variability in data