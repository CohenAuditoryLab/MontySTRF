function  reviewEEG;
% Function 
%             to review EEG of 16 channels, including
%             convertion original data to data that it 
%             is easy to read and analyze, data through 
%             Low pass filter or Band pass filter.
%relative files:
%openchannel,openlfilter,openbfilter,dat2dat,dat2dat_gui,
%filterconvert,convert_callback,filterdata,fdesign,
%h,lowpass,bandpass,showbf,stopshow,startshow.
%
%Copyright    Angel(ANQI QIU)
%             7/24/2001



clear;
figure(1);
h0=1;
set(1,'Color',[0.8 0.8 0.8], ...
	'FileName','reviewEEG.m', ...
	'MenuBar','none', ...
	'Name','Review EEG', ...
	'NumberTitle','off', ...
   'PaperPosition',[648 72 36000 57600],...
   'PaperUnits','points', ...
   'Position',[4 29 1593 1131],...	
   'Resize','off', ...
	'Tag','Review form', ...
	'ToolBar','none');
h1 = uimenu('Parent',h0, ...
	'Label','&File', ...
	'Tag','Filemenu');
h2 = uimenu('Parent',h1, ...
	'Callback','dat2dat_gui', ...
	'Label','Co&nvert', ...
	'Tag','Convert data');
h2 = uimenu('Parent',h1, ...
	'Callback','openchannel;', ...
	'Label','&Open', ...
	'Tag','Open file');
h2 = uimenu('Parent',h1, ...
	'Callback','close all', ...
	'Label','&Close', ...
   'Tag','Close all figure');
h1 = uimenu('Parent',h0, ...
	'Label','&Filter', ...
	'Tag','Filtermenu');
h2 = uimenu('Parent',h1, ...
	'Callback','filterconvert;clear Filename_Edit filename pathname;', ...
	'Label','Convert', ...
   'Tag','Convert data');
h2 = uimenu('Parent',h1, ...
	'Callback','openlfilter;', ...
	'Label','Open data through a Low pass filter', ...
	'Tag','Low pass filter data');
h2 = uimenu('Parent',h1, ...
	'Callback','openbfilter;', ...
	'Label','Open data through a Band pass filter', ...
	'Tag','Band pass filter data');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
   'BackgroundColor',[0.831372549019608 0.815686274509804 0.784313725490196], ...
  	'Callback','[fid,Fs,filesize,point]=showbf(1,fid,Fs,filesize,point,num);', ...
	'Enable','off', ...
	'FontSize',10, ...
	'ListboxTop',0, ...
	'Position',[238.5 823.5 29.25 15], ...
	'String','<---', ...
   'Tag','Back button');
Axeslist(18)=h1;
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
   'BackgroundColor',[0.831372549019608 0.815686274509804 0.784313725490196], ...
  	'Callback','[fid,Fs,filesize,point]=showbf(2,fid,Fs,filesize,point,num);', ...
	'Enable','off', ...
	'FontSize',10, ...
	'ListboxTop',0, ...
	'Position',[267.75 823.5 29.25 15], ...
	'String','--->', ...
   'Tag','Forward button');
Axeslist(19)=h1;
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
   'BackgroundColor',[0.831372549019608 0.815686274509804 0.784313725490196], ...
   'Callback','[fid,Fs,filesize,point]=startshow(Filenamelist,num);', ...
   'Enable','off',...
	'FontSize',10, ...
	'ListboxTop',0, ...
	'Position',[209.25 823.5 29.25 15], ...
	'String','Start', ...
   'Tag','Back button');
Axeslist(17)=h1;
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
   'BackgroundColor',[0.831372549019608 0.815686274509804 0.784313725490196], ...
   'Callback','stopshow(fid,num);', ...
   'Enable','off',...
	'FontSize',10, ...
	'ListboxTop',0, ...
	'Position',[297 823.5 29.25 15], ...
	'String','Stop', ...
   'Tag','Back button');
Axeslist(20)=h1;
h1 = axes('Parent',h0, ...
	'CameraUpVector',[0 1 0], ...
	'Color',[1 1 1], ...
	'FontSize',8, ...
	'Position',[0.0425    0.8563    0.4387    0.1005], ...
	'Tag','Channel 1', ...
	'XColor',[0 0 0], ...
	'YColor',[0 0 0], ...
   'ZColor',[0 0 0]);
Axeslist(1)=h1;
h2 = text('Parent',h1, ...
	'Color',[0 0 0], ...
	'HandleVisibility','off', ...
	'HorizontalAlignment','center', ...
	'Position',[0.4993   -0.1947    9.1603], ...
	'Tag','Axes1Text4', ...
	'VerticalAlignment','cap');
set(get(h2,'Parent'),'XLabel',h2);
h2 = text('Parent',h1, ...
	'Color',[0 0 0], ...
	'HandleVisibility','off', ...
	'HorizontalAlignment','center', ...
	'Position',[-0.0370898161198288 0.486725663716814 9.160254037844386], ...
	'Rotation',90, ...
	'Tag','Axes1Text3', ...
	'VerticalAlignment','baseline');
set(get(h2,'Parent'),'YLabel',h2);
h2 = text('Parent',h1, ...
	'Color',[0 0 0], ...
	'HandleVisibility','off', ...
	'HorizontalAlignment','right', ...
	'Position',[-0.09843081312410842 1.424778761061947 9.160254037844386], ...
	'Tag','Axes1Text2', ...
	'Visible','off');
set(get(h2,'Parent'),'ZLabel',h2);
h2 = text('Parent',h1, ...
	'Color',[0 0 0], ...
	'HandleVisibility','off', ...
	'HorizontalAlignment','center', ...
	'Position',[0.4992867332382311 1.053097345132743 9.160254037844386], ...
	'Tag','Axes1Text1', ...
	'VerticalAlignment','bottom');
set(get(h2,'Parent'),'Title',h2);
h1 = axes('Parent',h0, ...
	'CameraUpVector',[0 1 0], ...
	'Color',[1 1 1], ...
	'FontSize',8, ...
	'Position',[0.5244    0.8563    0.4387    0.1005], ...
	'Tag','Channel 9', ...
	'XColor',[0 0 0], ...
	'YColor',[0 0 0], ...
   'ZColor',[0 0 0]);
Axeslist(9)=h1;
h2 = text('Parent',h1, ...
	'ButtonDownFcn','ctlpanel SelectMoveResize', ...
	'Color',[0 0 0], ...
	'HandleVisibility','off', ...
	'HorizontalAlignment','center', ...
	'Interruptible','off', ...
	'Position',[0.4993   -0.1947    9.1603], ...
	'Tag','Axes1Text4', ...
	'VerticalAlignment','cap');
set(get(h2,'Parent'),'XLabel',h2);
h2 = text('Parent',h1, ...
	'ButtonDownFcn','ctlpanel SelectMoveResize', ...
	'Color',[0 0 0], ...
	'HandleVisibility','off', ...
	'HorizontalAlignment','center', ...
	'Interruptible','off', ...
	'Position',[-0.03708987161198296 0.486725663716814 9.160254037844386], ...
	'Rotation',90, ...
	'Tag','Axes1Text3', ...
	'VerticalAlignment','baseline');
set(get(h2,'Parent'),'YLabel',h2);
h2 = text('Parent',h1, ...
	'ButtonDownFcn','ctlpanel SelectMoveResize', ...
	'Color',[0 0 0], ...
	'HandleVisibility','off', ...
	'HorizontalAlignment','right', ...
	'Interruptible','off', ...
	'Position',[-1.198288159771755 1.424778761061947 9.160254037844386], ...
	'Tag','Axes1Text2', ...
	'Visible','off');
set(get(h2,'Parent'),'ZLabel',h2);
h2 = text('Parent',h1, ...
	'ButtonDownFcn','ctlpanel SelectMoveResize', ...
	'Color',[0 0 0], ...
	'HandleVisibility','off', ...
	'HorizontalAlignment','center', ...
	'Interruptible','off', ...
	'Position',[0.4992867332382309 1.053097345132743 9.160254037844386], ...
	'Tag','Axes1Text1', ...
	'VerticalAlignment','bottom');
set(get(h2,'Parent'),'Title',h2);
h1 = axes('Parent',h0, ...
	'CameraUpVector',[0 1 0], ...
	'Color',[1 1 1], ...
	'FontSize',8, ...
	'Position',[0.5244    0.7375    0.4387    0.1005], ...
	'Tag','Channel 10', ...
	'XColor',[0 0 0], ...
	'YColor',[0 0 0], ...
   'ZColor',[0 0 0]);
Axeslist(10)=h1;
h2 = text('Parent',h1, ...
	'ButtonDownFcn','ctlpanel SelectMoveResize', ...
	'Color',[0 0 0], ...
	'HandleVisibility','off', ...
	'HorizontalAlignment','center', ...
	'Interruptible','off', ...
	'Position',[0.4992867332382309 -0.1946902654867255 9.160254037844386], ...
	'Tag','Axes1Text4', ...
	'VerticalAlignment','cap');
set(get(h2,'Parent'),'XLabel',h2);
h2 = text('Parent',h1, ...
	'ButtonDownFcn','ctlpanel SelectMoveResize', ...
	'Color',[0 0 0], ...
	'HandleVisibility','off', ...
	'HorizontalAlignment','center', ...
	'Interruptible','off', ...
	'Position',[-0.03708987161198296 0.4867256637168143 9.160254037844386], ...
	'Rotation',90, ...
	'Tag','Axes1Text3', ...
	'VerticalAlignment','baseline');
set(get(h2,'Parent'),'YLabel',h2);
h2 = text('Parent',h1, ...
	'ButtonDownFcn','ctlpanel SelectMoveResize', ...
	'Color',[0 0 0], ...
	'HandleVisibility','off', ...
	'HorizontalAlignment','right', ...
	'Interruptible','off', ...
	'Position',[-1.198288159771755 2.619469026548673 9.160254037844386], ...
	'Tag','Axes1Text2', ...
	'Visible','off');
set(get(h2,'Parent'),'ZLabel',h2);
h2 = text('Parent',h1, ...
	'ButtonDownFcn','ctlpanel SelectMoveResize', ...
	'Color',[0 0 0], ...
	'HandleVisibility','off', ...
	'HorizontalAlignment','center', ...
	'Interruptible','off', ...
	'Position',[0.4993    1.0531    9.1603], ...
	'Tag','Axes1Text1', ...
	'VerticalAlignment','bottom');
set(get(h2,'Parent'),'Title',h2);
h1 = axes('Parent',h0, ...
	'CameraUpVector',[0 1 0], ...
	'Color',[1 1 1], ...
	'FontSize',8, ...
	'Position',[0.0425    0.7372    0.4388    0.1005], ...
	'Tag','Channel 2', ...
	'XColor',[0 0 0], ...
	'YColor',[0 0 0], ...
   'ZColor',[0 0 0]);
Axeslist(2)=h1;
h2 = text('Parent',h1, ...
	'ButtonDownFcn','ctlpanel SelectMoveResize', ...
	'Color',[0 0 0], ...
	'HandleVisibility','off', ...
	'HorizontalAlignment','center', ...
	'Interruptible','off', ...
	'Position',[0.4992867332382311 -0.1946902654867255 9.160254037844386], ...
	'Tag','Axes1Text4', ...
	'VerticalAlignment','cap');
set(get(h2,'Parent'),'XLabel',h2);
h2 = text('Parent',h1, ...
	'ButtonDownFcn','ctlpanel SelectMoveResize', ...
	'Color',[0 0 0], ...
	'HandleVisibility','off', ...
	'HorizontalAlignment','center', ...
	'Interruptible','off', ...
	'Position',[-0.03708987161198288 0.4867256637168143 9.160254037844386], ...
	'Rotation',90, ...
	'Tag','Axes1Text3', ...
	'VerticalAlignment','baseline');
set(get(h2,'Parent'),'YLabel',h2);
h2 = text('Parent',h1, ...
	'ButtonDownFcn','ctlpanel SelectMoveResize', ...
	'Color',[0 0 0], ...
	'HandleVisibility','off', ...
	'HorizontalAlignment','right', ...
	'Interruptible','off', ...
	'Position',[-0.09843081312410842 2.619469026548673 9.160254037844386], ...
	'Tag','Axes1Text2', ...
	'Visible','off');
set(get(h2,'Parent'),'ZLabel',h2);
h2 = text('Parent',h1, ...
	'ButtonDownFcn','ctlpanel SelectMoveResize', ...
	'Color',[0 0 0], ...
	'HandleVisibility','off', ...
	'HorizontalAlignment','center', ...
	'Interruptible','off', ...
	'Position',[0.4993    1.0531    9.1603], ...
	'Tag','Axes1Text1', ...
	'VerticalAlignment','bottom');
set(get(h2,'Parent'),'Title',h2);
h1 = axes('Parent',h0, ...
	'CameraUpVector',[0 1 0], ...
	'Color',[1 1 1], ...
	'FontSize',8, ...
	'Position',[0.5244    0.6187    0.4387    0.1005], ...
	'Tag','Channel 11', ...
	'XColor',[0 0 0], ...
	'YColor',[0 0 0], ...
   'ZColor',[0 0 0]);
Axeslist(11)=h1;
h2 = text('Parent',h1, ...
	'ButtonDownFcn','ctlpanel SelectMoveResize', ...
	'Color',[0 0 0], ...
	'HandleVisibility','off', ...
	'HorizontalAlignment','center', ...
	'Interruptible','off', ...
	'Position',[0.4992867332382309 -0.194690265486726 9.160254037844386], ...
	'Tag','Axes1Text4', ...
	'VerticalAlignment','cap');
set(get(h2,'Parent'),'XLabel',h2);
h2 = text('Parent',h1, ...
	'ButtonDownFcn','ctlpanel SelectMoveResize', ...
	'Color',[0 0 0], ...
	'HandleVisibility','off', ...
	'HorizontalAlignment','center', ...
	'Interruptible','off', ...
	'Position',[-0.03708987161198296 0.4867256637168143 9.160254037844386], ...
	'Rotation',90, ...
	'Tag','Axes1Text3', ...
	'VerticalAlignment','baseline');
set(get(h2,'Parent'),'YLabel',h2);
h2 = text('Parent',h1, ...
	'ButtonDownFcn','ctlpanel SelectMoveResize', ...
	'Color',[0 0 0], ...
	'HandleVisibility','off', ...
	'HorizontalAlignment','right', ...
	'Interruptible','off', ...
	'Position',[-1.198288159771755 3.805309734513275 9.160254037844386], ...
	'Tag','Axes1Text2', ...
	'Visible','off');
set(get(h2,'Parent'),'ZLabel',h2);
h2 = text('Parent',h1, ...
	'ButtonDownFcn','ctlpanel SelectMoveResize', ...
	'Color',[0 0 0], ...
	'HandleVisibility','off', ...
	'HorizontalAlignment','center', ...
	'Interruptible','off', ...
	'Position',[0.4993    1.0531    9.1603], ...
	'Tag','Axes1Text1', ...
	'VerticalAlignment','bottom');
set(get(h2,'Parent'),'Title',h2);
h1 = axes('Parent',h0, ...
	'CameraUpVector',[0 1 0], ...
	'Color',[1 1 1], ...
	'FontSize',8, ...
	'Position',[0.0425    0.6155    0.4388    0.1005], ...
	'Tag','Channel 3', ...
	'XColor',[0 0 0], ...
	'YColor',[0 0 0], ...
   'ZColor',[0 0 0]);
Axeslist(3)=h1;
h2 = text('Parent',h1, ...
	'ButtonDownFcn','ctlpanel SelectMoveResize', ...
	'Color',[0 0 0], ...
	'HandleVisibility','off', ...
	'HorizontalAlignment','center', ...
	'Interruptible','off', ...
	'Position',[0.4992867332382311 -0.1946902654867251 9.160254037844386], ...
	'Tag','Axes1Text4', ...
	'VerticalAlignment','cap');
set(get(h2,'Parent'),'XLabel',h2);
h2 = text('Parent',h1, ...
	'ButtonDownFcn','ctlpanel SelectMoveResize', ...
	'Color',[0 0 0], ...
	'HandleVisibility','off', ...
	'HorizontalAlignment','center', ...
	'Interruptible','off', ...
	'Position',[-0.03708987161198288 0.4867256637168143 9.160254037844386], ...
	'Rotation',90, ...
	'Tag','Axes1Text3', ...
	'VerticalAlignment','baseline');
set(get(h2,'Parent'),'YLabel',h2);
h2 = text('Parent',h1, ...
	'ButtonDownFcn','ctlpanel SelectMoveResize', ...
	'Color',[0 0 0], ...
	'HandleVisibility','off', ...
	'HorizontalAlignment','right', ...
	'Interruptible','off', ...
	'Position',[-0.09843081312410842 3.84070796460177 9.160254037844386], ...
	'Tag','Axes1Text2', ...
	'Visible','off');
set(get(h2,'Parent'),'ZLabel',h2);
h2 = text('Parent',h1, ...
	'ButtonDownFcn','ctlpanel SelectMoveResize', ...
	'Color',[0 0 0], ...
	'HandleVisibility','off', ...
	'HorizontalAlignment','center', ...
	'Interruptible','off', ...
	'Position',[ 0.4993    1.0531    9.1603], ...
	'Tag','Axes1Text1', ...
	'VerticalAlignment','bottom');
set(get(h2,'Parent'),'Title',h2);
h1 = axes('Parent',h0, ...
	'CameraUpVector',[0 1 0], ...
	'Color',[1 1 1], ...
	'FontSize',8, ...
	'Position',[0.5250    0.5000    0.4388    0.1005], ...
	'Tag','Channel 12', ...
	'XColor',[0 0 0], ...
	'YColor',[0 0 0], ...
   'ZColor',[0 0 0]);
Axeslist(12)=h1;
h2 = text('Parent',h1, ...
	'ButtonDownFcn','ctlpanel SelectMoveResize', ...
	'Color',[0 0 0], ...
	'HandleVisibility','off', ...
	'HorizontalAlignment','center', ...
	'Interruptible','off', ...
	'Position',[0.4992867332382311 -0.1946902654867255 9.160254037844386], ...
	'Tag','Axes1Text4', ...
	'VerticalAlignment','cap');
set(get(h2,'Parent'),'XLabel',h2);
h2 = text('Parent',h1, ...
	'ButtonDownFcn','ctlpanel SelectMoveResize', ...
	'Color',[0 0 0], ...
	'HandleVisibility','off', ...
	'HorizontalAlignment','center', ...
	'Interruptible','off', ...
	'Position',[-0.03708987161198296 0.4867256637168147 9.160254037844386], ...
	'Rotation',90, ...
	'Tag','Axes1Text3', ...
	'VerticalAlignment','baseline');
set(get(h2,'Parent'),'YLabel',h2);
h2 = text('Parent',h1, ...
	'ButtonDownFcn','ctlpanel SelectMoveResize', ...
	'Color',[0 0 0], ...
	'HandleVisibility','off', ...
	'HorizontalAlignment','right', ...
	'Interruptible','off', ...
	'Position',[-1.1997    5.0000    9.1603], ...
	'Tag','Axes1Text2', ...
	'Visible','off');
set(get(h2,'Parent'),'ZLabel',h2);
h2 = text('Parent',h1, ...
	'ButtonDownFcn','ctlpanel SelectMoveResize', ...
	'Color',[0 0 0], ...
	'HandleVisibility','off', ...
	'HorizontalAlignment','center', ...
	'Interruptible','off', ...
	'Position',[0.4992867332382311 1.053097345132744 9.160254037844386], ...
	'Tag','Axes1Text1', ...
	'VerticalAlignment','bottom');
set(get(h2,'Parent'),'Title',h2);
h1 = axes('Parent',h0, ...
	'CameraUpVector',[0 1 0], ...
	'Color',[1 1 1], ...
	'FontSize',8, ...
	'Position',[0.0425    0.5000    0.4388    0.1005], ...
	'Tag','Channel 4', ...
	'XColor',[0 0 0], ...
	'YColor',[0 0 0], ...
   'ZColor',[0 0 0]);
Axeslist(4)=h1;
h2 = text('Parent',h1, ...
	'ButtonDownFcn','ctlpanel SelectMoveResize', ...
	'Color',[0 0 0], ...
	'HandleVisibility','off', ...
	'HorizontalAlignment','center', ...
	'Interruptible','off', ...
	'Position',[0.4992867332382311 -0.1946902654867255 9.160254037844386], ...
	'Tag','Axes1Text4', ...
	'VerticalAlignment','cap');
set(get(h2,'Parent'),'XLabel',h2);
h2 = text('Parent',h1, ...
	'ButtonDownFcn','ctlpanel SelectMoveResize', ...
	'Color',[0 0 0], ...
	'HandleVisibility','off', ...
	'HorizontalAlignment','center', ...
	'Interruptible','off', ...
	'Position',[-0.03708987161198288 0.4867256637168147 9.160254037844386], ...
	'Rotation',90, ...
	'Tag','Axes1Text3', ...
	'VerticalAlignment','baseline');
set(get(h2,'Parent'),'YLabel',h2);
h2 = text('Parent',h1, ...
	'ButtonDownFcn','ctlpanel SelectMoveResize', ...
	'Color',[0 0 0], ...
	'HandleVisibility','off', ...
	'HorizontalAlignment','right', ...
	'Interruptible','off', ...
	'Position',[-0.09843081312410842 5 9.160254037844386], ...
	'Tag','Axes1Text2', ...
	'Visible','off');
set(get(h2,'Parent'),'ZLabel',h2);
h2 = text('Parent',h1, ...
	'ButtonDownFcn','ctlpanel SelectMoveResize', ...
	'Color',[0 0 0], ...
	'HandleVisibility','off', ...
	'HorizontalAlignment','center', ...
	'Interruptible','off', ...
	'Position',[0.4992867332382311 1.053097345132744 9.160254037844386], ...
	'Tag','Axes1Text1', ...
	'VerticalAlignment','bottom');
set(get(h2,'Parent'),'Title',h2);
h1 = axes('Parent',h0, ...
	'CameraUpVector',[0 1 0], ...
	'Color',[1 1 1], ...
	'FontSize',8, ...
	'Position',[0.5244    0.3811    0.4387    0.1005], ...
	'Tag','Channel 13', ...
	'XColor',[0 0 0], ...
	'YColor',[0 0 0], ...
   'ZColor',[0 0 0]);
Axeslist(13)=h1;
h2 = text('Parent',h1, ...
	'ButtonDownFcn','ctlpanel SelectMoveResize', ...
	'Color',[0 0 0], ...
	'HandleVisibility','off', ...
	'HorizontalAlignment','center', ...
	'Interruptible','off', ...
	'Position',[0.4992867332382309 -0.1946902654867255 9.160254037844386], ...
	'Tag','Axes1Text4', ...
	'VerticalAlignment','cap');
set(get(h2,'Parent'),'XLabel',h2);
h2 = text('Parent',h1, ...
	'ButtonDownFcn','ctlpanel SelectMoveResize', ...
	'Color',[0 0 0], ...
	'HandleVisibility','off', ...
	'HorizontalAlignment','center', ...
	'Interruptible','off', ...
	'Position',[-0.03708987161198296 0.4867256637168147 9.160254037844386], ...
	'Rotation',90, ...
	'Tag','Axes1Text3', ...
	'VerticalAlignment','baseline');
set(get(h2,'Parent'),'YLabel',h2);
h2 = text('Parent',h1, ...
	'ButtonDownFcn','ctlpanel SelectMoveResize', ...
	'Color',[0 0 0], ...
	'HandleVisibility','off', ...
	'HorizontalAlignment','right', ...
	'Interruptible','off', ...
	'Position',[-1.198288159771755 6.194690265486726 9.160254037844386], ...
	'Tag','Axes1Text2', ...
	'Visible','off');
set(get(h2,'Parent'),'ZLabel',h2);
h2 = text('Parent',h1, ...
	'ButtonDownFcn','ctlpanel SelectMoveResize', ...
	'Color',[0 0 0], ...
	'HandleVisibility','off', ...
	'HorizontalAlignment','center', ...
	'Interruptible','off', ...
	'Position',[0.4992867332382309 1.053097345132744 9.160254037844386], ...
	'Tag','Axes1Text1', ...
	'VerticalAlignment','bottom');
set(get(h2,'Parent'),'Title',h2);
h1 = axes('Parent',h0, ...
	'CameraUpVector',[0 1 0], ...
	'Color',[1 1 1], ...
	'FontSize',8, ...
	'Position',[0.0425    0.3783    0.4388    0.1005], ...
	'Tag','Channel 5', ...
	'XColor',[0 0 0], ...
	'YColor',[0 0 0], ...
   'ZColor',[0 0 0]);
Axeslist(5)=h1;
h2 = text('Parent',h1, ...
	'ButtonDownFcn','ctlpanel SelectMoveResize', ...
	'Color',[0 0 0], ...
	'HandleVisibility','off', ...
	'HorizontalAlignment','center', ...
	'Interruptible','off', ...
	'Position',[0.4992867332382311 -0.1946902654867255 9.160254037844386], ...
	'Tag','Axes1Text4', ...
	'VerticalAlignment','cap');
set(get(h2,'Parent'),'XLabel',h2);
h2 = text('Parent',h1, ...
	'ButtonDownFcn','ctlpanel SelectMoveResize', ...
	'Color',[0 0 0], ...
	'HandleVisibility','off', ...
	'HorizontalAlignment','center', ...
	'Interruptible','off', ...
	'Position',[-0.03708987161198288 0.4867256637168147 9.160254037844386], ...
	'Rotation',90, ...
	'Tag','Axes1Text3', ...
	'VerticalAlignment','baseline');
set(get(h2,'Parent'),'YLabel',h2);
h2 = text('Parent',h1, ...
	'ButtonDownFcn','ctlpanel SelectMoveResize', ...
	'Color',[0 0 0], ...
	'HandleVisibility','off', ...
	'HorizontalAlignment','right', ...
	'Interruptible','off', ...
	'Position',[-0.09843081312410842 6.221238938053097 9.160254037844386], ...
	'Tag','Axes1Text2', ...
	'Visible','off');
set(get(h2,'Parent'),'ZLabel',h2);
h2 = text('Parent',h1, ...
	'ButtonDownFcn','ctlpanel SelectMoveResize', ...
	'Color',[0 0 0], ...
	'HandleVisibility','off', ...
	'HorizontalAlignment','center', ...
	'Interruptible','off', ...
	'Position',[0.4992867332382311 1.053097345132744 9.160254037844386], ...
	'Tag','Axes1Text1', ...
	'VerticalAlignment','bottom');
set(get(h2,'Parent'),'Title',h2);
h1 = axes('Parent',h0, ...
	'CameraUpVector',[0 1 0], ...
	'Color',[1 1 1], ...
	'FontSize',8, ...
	'Position',[0.5244    0.2623    0.4387    0.1005], ...
	'Tag','Channel 14', ...
	'XColor',[0 0 0], ...
	'YColor',[0 0 0], ...
   'ZColor',[0 0 0]);
Axeslist(14)=h1;
h2 = text('Parent',h1, ...
	'ButtonDownFcn','ctlpanel SelectMoveResize', ...
	'Color',[0 0 0], ...
	'HandleVisibility','off', ...
	'HorizontalAlignment','center', ...
	'Interruptible','off', ...
	'Position',[0.4992867332382309 -0.1946902654867255 9.160254037844386], ...
	'Tag','Axes1Text4', ...
	'VerticalAlignment','cap');
set(get(h2,'Parent'),'XLabel',h2);
h2 = text('Parent',h1, ...
	'ButtonDownFcn','ctlpanel SelectMoveResize', ...
	'Color',[0 0 0], ...
	'HandleVisibility','off', ...
	'HorizontalAlignment','center', ...
	'Interruptible','off', ...
	'Position',[-0.03708987161198296 0.4867256637168147 9.160254037844386], ...
	'Rotation',90, ...
	'Tag','Axes1Text3', ...
	'VerticalAlignment','baseline');
set(get(h2,'Parent'),'YLabel',h2);
h2 = text('Parent',h1, ...
	'ButtonDownFcn','ctlpanel SelectMoveResize', ...
	'Color',[0 0 0], ...
	'HandleVisibility','off', ...
	'HorizontalAlignment','right', ...
	'Interruptible','off', ...
	'Position',[-1.198288159771755 7.389380530973451 9.160254037844386], ...
	'Tag','Axes1Text2', ...
	'Visible','off');
set(get(h2,'Parent'),'ZLabel',h2);
h2 = text('Parent',h1, ...
	'ButtonDownFcn','ctlpanel SelectMoveResize', ...
	'Color',[0 0 0], ...
	'HandleVisibility','off', ...
	'HorizontalAlignment','center', ...
	'Interruptible','off', ...
	'Position',[0.4992867332382309 1.053097345132744 9.160254037844386], ...
	'Tag','Axes1Text1', ...
	'VerticalAlignment','bottom');
set(get(h2,'Parent'),'Title',h2);
h1 = axes('Parent',h0, ...
	'CameraUpVector',[0 1 0], ...
	'Color',[1 1 1], ...
	'FontSize',8, ...
	'Position',[0.0425    0.2584    0.4388    0.1005], ...
	'Tag','Channel 6', ...
	'XColor',[0 0 0], ...
	'YColor',[0 0 0], ...
   'ZColor',[0 0 0]);
Axeslist(6)=h1;
h2 = text('Parent',h1, ...
	'ButtonDownFcn','ctlpanel SelectMoveResize', ...
	'Color',[0 0 0], ...
	'HandleVisibility','off', ...
	'HorizontalAlignment','center', ...
	'Interruptible','off', ...
	'Position',[0.4992867332382311 -0.1946902654867255 9.160254037844386], ...
	'Tag','Axes1Text4', ...
	'VerticalAlignment','cap');
set(get(h2,'Parent'),'XLabel',h2);
h2 = text('Parent',h1, ...
	'ButtonDownFcn','ctlpanel SelectMoveResize', ...
	'Color',[0 0 0], ...
	'HandleVisibility','off', ...
	'HorizontalAlignment','center', ...
	'Interruptible','off', ...
	'Position',[-0.03708987161198288 0.4867256637168147 9.160254037844386], ...
	'Rotation',90, ...
	'Tag','Axes1Text3', ...
	'VerticalAlignment','baseline');
set(get(h2,'Parent'),'YLabel',h2);
h2 = text('Parent',h1, ...
	'ButtonDownFcn','ctlpanel SelectMoveResize', ...
	'Color',[0 0 0], ...
	'HandleVisibility','off', ...
	'HorizontalAlignment','right', ...
	'Interruptible','off', ...
	'Position',[-0.09843081312410842 7.424778761061947 9.160254037844386], ...
	'Tag','Axes1Text2', ...
	'Visible','off');
set(get(h2,'Parent'),'ZLabel',h2);
h2 = text('Parent',h1, ...
	'ButtonDownFcn','ctlpanel SelectMoveResize', ...
	'Color',[0 0 0], ...
	'HandleVisibility','off', ...
	'HorizontalAlignment','center', ...
	'Interruptible','off', ...
	'Position',[0.4992867332382311 1.053097345132744 9.160254037844386], ...
	'Tag','Axes1Text1', ...
	'VerticalAlignment','bottom');
set(get(h2,'Parent'),'Title',h2);
h1 = axes('Parent',h0, ...
	'CameraUpVector',[0 1 0], ...
	'Color',[1 1 1], ...
	'FontSize',8, ...
	'Position',[0.5244    0.1429    0.4388    0.1005], ...
	'Tag','Channel 15', ...
	'XColor',[0 0 0], ...
	'YColor',[0 0 0], ...
   'ZColor',[0 0 0]);
Axeslist(15)=h1;
h2 = text('Parent',h1, ...
	'ButtonDownFcn','ctlpanel SelectMoveResize', ...
	'Color',[0 0 0], ...
	'HandleVisibility','off', ...
	'HorizontalAlignment','center', ...
	'Interruptible','off', ...
	'Position',[0.4992867332382309 -0.1946902654867273 9.160254037844386], ...
	'Tag','Axes1Text4', ...
	'VerticalAlignment','cap');
set(get(h2,'Parent'),'XLabel',h2);
h2 = text('Parent',h1, ...
	'ButtonDownFcn','ctlpanel SelectMoveResize', ...
	'Color',[0 0 0], ...
	'HandleVisibility','off', ...
	'HorizontalAlignment','center', ...
	'Interruptible','off', ...
	'Position',[-0.03708987161198296 0.4867256637168129 9.160254037844386], ...
	'Rotation',90, ...
	'Tag','Axes1Text3', ...
	'VerticalAlignment','baseline');
set(get(h2,'Parent'),'YLabel',h2);
h2 = text('Parent',h1, ...
	'ButtonDownFcn','ctlpanel SelectMoveResize', ...
	'Color',[0 0 0], ...
	'HandleVisibility','off', ...
	'HorizontalAlignment','right', ...
	'Interruptible','off', ...
	'Position',[-1.198288159771755 8.584070796460177 9.160254037844386], ...
	'Tag','Axes1Text2', ...
	'Visible','off');
set(get(h2,'Parent'),'ZLabel',h2);
h2 = text('Parent',h1, ...
	'ButtonDownFcn','ctlpanel SelectMoveResize', ...
	'Color',[0 0 0], ...
	'HandleVisibility','off', ...
	'HorizontalAlignment','center', ...
	'Interruptible','off', ...
	'Position',[0.4992867332382309 1.053097345132742 9.160254037844386], ...
	'Tag','Axes1Text1', ...
	'VerticalAlignment','bottom');
set(get(h2,'Parent'),'Title',h2);
h1 = axes('Parent',h0, ...
	'CameraUpVector',[0 1 0], ...
	'Color',[1 1 1], ...
	'FontSize',8, ...
	'Position',[0.0425    0.1402    0.4388    0.1005], ...
	'Tag','Channel 7', ...
	'XColor',[0 0 0], ...
	'YColor',[0 0 0], ...
   'ZColor',[0 0 0]);
Axeslist(7)=h1;
h2 = text('Parent',h1, ...
	'ButtonDownFcn','ctlpanel SelectMoveResize', ...
	'Color',[0 0 0], ...
	'HandleVisibility','off', ...
	'HorizontalAlignment','center', ...
	'Interruptible','off', ...
	'Position',[0.4992867332382311 -0.1946902654867255 9.160254037844386], ...
	'Tag','Axes1Text4', ...
	'VerticalAlignment','cap');
set(get(h2,'Parent'),'XLabel',h2);
h2 = text('Parent',h1, ...
	'ButtonDownFcn','ctlpanel SelectMoveResize', ...
	'Color',[0 0 0], ...
	'HandleVisibility','off', ...
	'HorizontalAlignment','center', ...
	'Interruptible','off', ...
	'Position',[-0.03708987161198288 0.4867256637168147 9.160254037844386], ...
	'Rotation',90, ...
	'Tag','Axes1Text3', ...
	'VerticalAlignment','baseline');
set(get(h2,'Parent'),'YLabel',h2);
h2 = text('Parent',h1, ...
	'ButtonDownFcn','ctlpanel SelectMoveResize', ...
	'Color',[0 0 0], ...
	'HandleVisibility','off', ...
	'HorizontalAlignment','right', ...
	'Interruptible','off', ...
	'Position',[-0.09843081312410842 8.610619469026549 9.160254037844386], ...
	'Tag','Axes1Text2', ...
	'Visible','off');
set(get(h2,'Parent'),'ZLabel',h2);
h2 = text('Parent',h1, ...
	'ButtonDownFcn','ctlpanel SelectMoveResize', ...
	'Color',[0 0 0], ...
	'HandleVisibility','off', ...
	'HorizontalAlignment','center', ...
	'Interruptible','off', ...
	'Position',[0.4992867332382311 1.053097345132743 9.160254037844386], ...
	'Tag','Axes1Text1', ...
	'VerticalAlignment','bottom');
set(get(h2,'Parent'),'Title',h2);
h1 = axes('Parent',h0, ...
	'CameraUpVector',[0 1 0], ...
	'Color',[1 1 1], ...
	'FontSize',8, ...
	'Position',[0.0425    0.0247    0.4387    0.1005], ...
	'Tag','Channel 8', ...
	'XColor',[0 0 0], ...
	'YColor',[0 0 0], ...
   'ZColor',[0 0 0]);
Axeslist(8)=h1;
h2 = text('Parent',h1, ...
	'ButtonDownFcn','ctlpanel SelectMoveResize', ...
	'Color',[0 0 0], ...
	'HandleVisibility','off', ...
	'HorizontalAlignment','center', ...
	'Interruptible','off', ...
	'Position',[0.4992867332382311 -0.1946902654867255 9.160254037844386], ...
	'Tag','Axes1Text4', ...
	'VerticalAlignment','cap');
set(get(h2,'Parent'),'XLabel',h2);
h2 = text('Parent',h1, ...
	'ButtonDownFcn','ctlpanel SelectMoveResize', ...
	'Color',[0 0 0], ...
	'HandleVisibility','off', ...
	'HorizontalAlignment','center', ...
	'Interruptible','off', ...
	'Position',[-0.03708987161198288 0.4867256637168147 9.160254037844386], ...
	'Rotation',90, ...
	'Tag','Axes1Text3', ...
	'VerticalAlignment','baseline');
set(get(h2,'Parent'),'YLabel',h2);
h2 = text('Parent',h1, ...
	'ButtonDownFcn','ctlpanel SelectMoveResize', ...
	'Color',[0 0 0], ...
	'HandleVisibility','off', ...
	'HorizontalAlignment','right', ...
	'Interruptible','off', ...
	'Position',[-0.09843081312410842 9.76991150442478 9.160254037844386], ...
	'Tag','Axes1Text2', ...
	'Visible','off');
set(get(h2,'Parent'),'ZLabel',h2);
h2 = text('Parent',h1, ...
	'ButtonDownFcn','ctlpanel SelectMoveResize', ...
	'Color',[0 0 0], ...
	'HandleVisibility','off', ...
	'HorizontalAlignment','center', ...
	'Interruptible','off', ...
	'Position',[0.4992867332382311 1.053097345132745 9.160254037844386], ...
	'Tag','Axes1Text1', ...
	'VerticalAlignment','bottom');
set(get(h2,'Parent'),'Title',h2);
h1 = axes('Parent',h0, ...
	'CameraUpVector',[0 1 0], ...
	'Color',[1 1 1], ...
	'FontSize',8, ...
	'Position',[0.5244    0.0247    0.4387    0.1005], ...
	'Tag','Channel 16', ...
	'XColor',[0 0 0], ...
	'YColor',[0 0 0], ...
   'ZColor',[0 0 0]);
Axeslist(16)=h1;
h2 = text('Parent',h1, ...
	'ButtonDownFcn','ctlpanel SelectMoveResize', ...
	'Color',[0 0 0], ...
	'HandleVisibility','off', ...
	'HorizontalAlignment','center', ...
	'Interruptible','off', ...
	'Position',[0.4992867332382309 -0.1946902654867255 9.160254037844386], ...
	'Tag','Axes1Text4', ...
	'VerticalAlignment','cap');
set(get(h2,'Parent'),'XLabel',h2);
h2 = text('Parent',h1, ...
	'ButtonDownFcn','ctlpanel SelectMoveResize', ...
	'Color',[0 0 0], ...
	'HandleVisibility','off', ...
	'HorizontalAlignment','center', ...
	'Interruptible','off', ...
	'Position',[-0.03708987161198296 0.4867256637168147 9.160254037844386], ...
	'Rotation',90, ...
	'Tag','Axes1Text3', ...
	'VerticalAlignment','baseline');
set(get(h2,'Parent'),'YLabel',h2);
h2 = text('Parent',h1, ...
	'ButtonDownFcn','ctlpanel SelectMoveResize', ...
	'Color',[0 0 0], ...
	'HandleVisibility','off', ...
	'HorizontalAlignment','right', ...
	'Interruptible','off', ...
	'Position',[-1.198288159771755 9.76991150442478 9.160254037844386], ...
	'Tag','Axes1Text2', ...
	'Visible','off');
set(get(h2,'Parent'),'ZLabel',h2);
h2 = text('Parent',h1, ...
	'ButtonDownFcn','ctlpanel SelectMoveResize', ...
	'Color',[0 0 0], ...
	'HandleVisibility','off', ...
	'HorizontalAlignment','center', ...
	'Interruptible','off', ...
	'Position',[0.4992867332382309 1.053097345132745 9.160254037844386], ...
	'Tag','Axes1Text1', ...
	'VerticalAlignment','bottom');
set(get(h2,'Parent'),'Title',h2);
set(h0,'Userdata',Axeslist);
