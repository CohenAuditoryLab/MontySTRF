

function [X,V]=snn(T,B,Bext,Sext,Fs)

%Define basic parameters and variables
A=diag(1-1./(Fs*diag(T)));
%B=B/sum(B,2);                             %Normalize so that the summed contribution to each input is 1
%Bext=Bext./sum(Bext,2);  
Vt=10;
V=zeros(size(A,1),1);
X=zeros(size(Sext));
V=zeros(size(Sext));


%Computing Output
for k=2:size(Sext,2)
    
    %Estimating voltage at k-th time sample
    V(:,k)=A*V(:,k-1)+Bext*Sext(:,k-1)+B*X(:,k-1)+1*randn(size(V(:,1)));
    
    %Checking for voltages that exceed threshold
    index=find(V(:,k)>Vt);
    
    %Adding spikes and reseting mebrane potential - note that Vr=0
    V(index,k)=zeros(size(index));
    X(index,k)=ones(size(index));
    
end
