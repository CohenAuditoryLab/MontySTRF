function  eegcorr;
%Function
%         GUI for correlation of data that come from two files at the same time
% 
%Copyright     Angel(ANQI QIU)
%              7/24/2001

h0 = figure('Color',[0.8 0.8 0.8], ...
   'FileName','eegcorr.m', ...
   'MenuBar','none',...
	'Name','EEG Correlation', ...
	'NumberTitle','off', ...
	'PaperPosition',[18 180 576 432], ...
	'PaperUnits','points', ...
	'Position',[511 492 480 343], ...
	'Tag','Figcorr', ...
	'ToolBar','none');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[1 1 1], ...
	'ListboxTop',0, ...
	'Position',[37.5 196.5 213.75 15], ...
	'Style','edit', ...
   'Tag','FileEdit1');
handlelist(1)=h1;
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
   'BackgroundColor',[0.831372549019608 0.815686274509804 0.784313725490196], ...
   'Callback','[filename,pathname]=uigetfile(''*_A*.dat'',''Open data file'');if filename~=0 handlelist=get(gcf,''Userdata'');set(handlelist(1),''String'',[pathname filename]);end;', ...
	'ListboxTop',0, ...
	'Position',[277.5 196.5 45 15], ...
	'String','...', ...
	'Tag','Fileopenbutton1');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[0.831372549019608 0.815686274509804 0.784313725490196], ...
   'Callback','[filename,pathname]=uigetfile(''*_A*.dat'',''Open data file'');if filename~=0 handlelist=get(gcf,''Userdata'');set(handlelist(2),''String'',[pathname filename]);end;', ...
	'ListboxTop',0, ...
	'Position',[277.5 165.75 45 15], ...
	'String','...', ...
	'Tag','Fileopenbutton2');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[1 1 1], ...
	'ListboxTop',0, ...
	'Position',[37.5 165.75 213.75 15], ...
	'Style','edit', ...
   'Tag','FileEdit2');
handlelist(2)=h1;
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[1 1 1], ...
	'ListboxTop',0, ...
	'Position',[83.25 90 45 15], ...
	'Style','edit', ...
   'Tag','TimeEdit1');
handlelist(3)=h1;
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[1 1 1], ...
	'ListboxTop',0, ...
	'Position',[203.25 90 45 15], ...
	'Style','edit', ...
   'Tag','TimeEdit2');
handlelist(4)=h1;
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[0.784313725490196 0.784313725490196 0.784313725490196], ...
	'FontSize',10, ...
	'FontWeight','bold', ...
	'ListboxTop',0, ...
	'Position',[37.5 219.75 100.5 17.25], ...
	'String','Choose two files:', ...
	'Style','text', ...
	'Tag','File choose');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[0.784313725490196 0.784313725490196 0.784313725490196], ...
	'FontSize',10, ...
	'FontWeight','bold', ...
	'ListboxTop',0, ...
	'Position',[37.5 127.5 69 17.25], ...
	'String','Choose time:', ...
	'Style','text', ...
	'Tag','File choose');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[0.784313725490196 0.784313725490196 0.784313725490196], ...
	'FontSize',10, ...
	'FontWeight','bold', ...
	'ListboxTop',0, ...
	'Position',[37.5 87.75 37.5 17.25], ...
	'String','From', ...
	'Style','text', ...
	'Tag','File choose');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[0.784313725490196 0.784313725490196 0.784313725490196], ...
	'FontSize',10, ...
	'FontWeight','bold', ...
	'ListboxTop',0, ...
	'Position',[128.25 87.75 13.5 17.25], ...
	'String','s', ...
	'Style','text', ...
	'Tag','File choose');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[0.784313725490196 0.784313725490196 0.784313725490196], ...
	'FontSize',10, ...
	'FontWeight','bold', ...
	'ListboxTop',0, ...
	'Position',[158.25 87.75 37.5 17.25], ...
	'String','to', ...
	'Style','text', ...
	'Tag','File choose');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[0.784313725490196 0.784313725490196 0.784313725490196], ...
	'FontSize',10, ...
	'FontWeight','bold', ...
	'ListboxTop',0, ...
	'Position',[248.25 87.75 13.5 17.25], ...
	'String','s', ...
	'Style','text', ...
	'Tag','File choose');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
   'BackgroundColor',[0.831372549019608 0.815686274509804 0.784313725490196], ...
   'Callback','ploteegcorr;',...
	'ListboxTop',0, ...
	'Position',[202.5 39.75 45 15], ...
	'String','Plot', ...
	'Tag','Plotbutton');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
   'BackgroundColor',[0.831372549019608 0.815686274509804 0.784313725490196], ...
   'Callback','clear;close all;',...
	'ListboxTop',0, ...
	'Position',[275.25 39.75 45 15], ...
	'String','Close', ...
	'Tag','Closebutton');
set(gcf,'Userdata',handlelist);