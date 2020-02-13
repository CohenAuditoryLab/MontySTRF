%
%function []=filerectify(infile,outfile,ftype,M,NLType)
%
%       FILE NAME   : FILE RECTIFY
%       DESCRIPTION : Rectifies the data in a file using either half, full
%                     wave or squared rectification.
%                     The output is stored in a single file of the same type.
%
%       infile1     : Input File
%       outfile		: Output File
%       ftype		: File Type : 'int16', 'float', etc ...
%                     Default - 'int16'
%       M           : Buffer Length - Optional (1024*512 Default)
%       NLType      : Nonlinearity used to rectify 
%
%                 1 - abs() - absolute value - full wave rectification
%                 2 - max(X,0) - half wave rectification
%                 3 - ().^2 - squared rectification
%
%                 Default == 1 (Full Wavew)
%
function []=filerectify(infile,outfile,ftype,M,NLType)

%Checking Input Arguments
if nargin<3
	ftype='int16';
end
if nargin<4
        M=1024*512;
end
if nargin<5
   NLType=1; 
end

%Opening Infile
fid=fopen(infile,'r');
fidout=fopen(outfile,'w');

%Rectifying
while ~( feof(fid) )
	X=fread(fid,M,ftype);
    if NLType==1
        fwrite(fidout,abs(X),ftype);
    elseif NLType==2
        fwrite(fidout,max(X,0),ftype);
    elseif NLType==3
        fwrite(fidout,X.^2,ftype);
    end
end

%Closing Files
fclose('all');