%
% function shadeerrbar(x,data,color,marker)
%
%	FILE NAME 	: SHADE ERR BAR
%	DESCRIPTION : Generates a continuous shaded error region (std) 
%                 around the mean of the data.
%
%	x           : X-axis data of the plot.                  
%   data        : Data of which mean and std will be calculated and plotted
%                 as y-axis data
%   color       : Color of the line (mean) and the shaded area (std). 
%                 'r', 'k', or 'b'.
%   marker      : Display the markers of the mean data 
%                 'y' (default) or 'n'.


function shadeerrbar(x,data,color,marker)

if nargin<4
    marker='y';
end

y=mean(data);
e=std(data);
errorbar(x,y,e,'w');
lo=y-e;
hi=y+e;

hp=patch([x x(end:-1:1) x(1)], [lo hi(end:-1:1) lo(1)], color);
hold on;
hl = line(x,y);

if color=='r'
    fc=[1 0.8 0.8];
end

if color=='k'
    fc=[0.85 0.85 0.85];
end

if color=='b'
    fc=[0.8 0.8 1];
end

set(hp,'facecolor',fc,'edgecolor','none');

if marker=='y'
    set(hl,'color',color,'marker','.','MarkerSize',10);
else
    set(hl,'color',color);
end
end

