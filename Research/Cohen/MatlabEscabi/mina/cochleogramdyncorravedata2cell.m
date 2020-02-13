%
% function  [Data]=cochleogramdyncorravedata2cell(N)
%   
%   FILE NAME   : COCHLEOGRAM DYN CORR AVE DATA 2 CELL
%   DESCRIPTION : Grabs different categories average correlation blocks in the 
%                 current directory & puts them in a cell called X.
%
%   N           : Number of different sound categories
%
%   RETURNED VARIABLES
%
%   Data        : Data structure containing X & its parameters
%                 .X      : Contains data (X is a cell containing cells)
%                 .Param  : Data structure containing X parameters
%                           .FreqChan   : Number of frequency channels used for
%                                         analysis (1st & 2nd dim of Rxy or RxyN)
%                           .Tau        : Number of time lag(delay) points (3rd dim of Rxy or RxyN)
%                           .N          : Number of sound categories used
%
% (C) Mina, Jan 2017  

function [Data]=cochleogramdyncorravedata2cell(N)

Files = dir('.');
%Getting rid of . & .. in MAC machines
if strcmp(Files(1).name,'.') && strcmp(Files(2).name,'..') 
   Files(1).isdir=~Files(1).isdir; 
   Files(2).isdir=~Files(2).isdir;
end
FolderIndex=find([Files.isdir]);  %Finding indices of existing folders in the current directory
CatDir=Files(FolderIndex(1:end));
XData=cell(N,1);

for count=1:N  %Going through different categories
    CatList=dir([CatDir(count).name '/*_Corr.mat']);  %Grabbing correlation blocks in the current directory
    X=cell(length(CatList),1);
    
    %Going through different sounds in each category
    for k=1:length(CatList)
        load([CatDir(count).name '/' CatList(k).name]); %Loading Corr blocks
          
        [dim1,~,dim3] = size(MeanCorr);
        Mask=triu(ones(dim1));
        [index]=find(Mask);  %Finding upper triangular indices
        XTemporary=MeanCorr(index)';  %Taking only the upper triangular part of Corr matrix  

        Mask=diag(ones(1,dim1));
       [index]=find(Mask);  %Finding diagonal indices

        Xtemp=[];
       %Going through each point of time lag axis
       for i= 1:dim3
           mat=MeanCorr(:,:,i);
           Xtemp=[Xtemp mat(index)'];  %Taking only the diagonal of Corr matrix 
       end
       XTemp=[XTemporary Xtemp];

       X(k)={XTemp};
    end
    XData(count)={X};  %Putting data in a cell
end

%Storing XData & its Parameters as data structure
Data.X = XData;
Data.Param.FreqChan = dim1;
Data.Param.Tau = dim3;
Data.Param.N = N;