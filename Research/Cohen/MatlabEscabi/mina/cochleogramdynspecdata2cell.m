%
% function  [Data]=cochleogramdynspecdata2cell(N)
%   
%   FILE NAME   : COCHLEOGRAM DYN SPEC DATA 2 CELL
%   DESCRIPTION : Grabs different categories spectrum blocks in the 
%                 current directory & puts them in a cell called X.
%                 X is a cell containing cells.The output is used in 
%                 cochleogramdyncorrpctest.m.
%
%   N           : Number of different sound categories
%
%   RETURNED VARIABLES
%
%   Data        : Data structure containing X & its parameters
%                 .X      : Contains data (X is a cell containing cells)
%                 .Param  : Data structure containing X parameters
%                 .N          : Number of sound categories used
%
% (C) Mina, Aug 2018  

function [Data]=cochleogramdynspecdata2cell(N)

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
    CatList=dir([CatDir(count).name '/*_DynSpec.mat']);  %Grabbing spectrum blocks in the current directory
    X=cell(length(CatList),1);
    
    %Going through different sounds in each category
    for k=1:length(CatList)
        load([CatDir(count).name '/' CatList(k).name]); %Loading Spectrum blocks
        X(k)={DynSpectrum};  
    end
     XData(count)={X};  %Putting data in a cell
end
    
%Storing XData & its Parameters as data structure
Data.X = XData;
Data.Param.N = N;