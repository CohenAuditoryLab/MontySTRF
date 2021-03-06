function  openlfilter;
%Function
%         GUI for open files that are named as *_A_Low.dat
%
%Copyright    Angel(ANQI QIU)
%             7/24/2001

clear;
h0=figure('Color',[0.8 0.8 0.8], ...
	'FileName','openlfilter.m', ...
	'MenuBar','none', ...
   'Name','Choose files', ...
   'NumberTitle','off',...
	'PaperPosition',[18 180 576 432], ...
	'PaperUnits','points', ...
	'Position',[565 445 520 556], ...
	'Tag','OpenFig', ...
   'ToolBar','none',...
   'Resize','off',...
   'WindowStyle','modal');  %modal
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[0.752941176470588 0.752941176470588 0.752941176470588], ...
	'FontSize',10, ...
	'ListboxTop',0, ...
	'Position',[14.25 383.2500000000001 54 15], ...
	'String','Channel 1', ...
	'Style','text', ...
	'Tag','Channel1');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[0.752941176470588 0.752941176470588 0.752941176470588], ...
	'FontSize',10, ...
	'ListboxTop',0, ...
	'Position',[14.25 360.4000000000001 54 15], ...
	'String','Channel 2', ...
	'Style','text', ...
	'Tag','Channel2');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[0.752941176470588 0.752941176470588 0.752941176470588], ...
	'FontSize',10, ...
	'ListboxTop',0, ...
	'Position',[14.25 337.5500000000001 54 15], ...
	'String','Channel 3', ...
	'Style','text', ...
	'Tag','Channel3');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[0.752941176470588 0.752941176470588 0.752941176470588], ...
	'FontSize',10, ...
	'ListboxTop',0, ...
	'Position',[14.25 314.7000000000001 54 15], ...
	'String','Channel 4', ...
	'Style','text', ...
	'Tag','Channel4');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[0.752941176470588 0.752941176470588 0.752941176470588], ...
	'FontSize',10, ...
	'ListboxTop',0, ...
	'Position',[14.25 291.85 54 15], ...
	'String','Channel 5', ...
	'Style','text', ...
	'Tag','Channel5');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[0.752941176470588 0.752941176470588 0.752941176470588], ...
	'FontSize',10, ...
	'ListboxTop',0, ...
	'Position',[14.25 269 54 15], ...
	'String','Channel 6', ...
	'Style','text', ...
	'Tag','Channel6');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[0.752941176470588 0.752941176470588 0.752941176470588], ...
	'FontSize',10, ...
	'ListboxTop',0, ...
	'Position',[14.2500  246.1500   54.0000   15.0000], ...
	'String','Channel 7', ...
	'Style','text', ...
	'Tag','Channel7');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[0.752941176470588 0.752941176470588 0.752941176470588], ...
	'FontSize',10, ...
	'ListboxTop',0, ...
	'Position',[14.2500  223.3000   54.0000   15.0000], ...
	'String','Channel 8', ...
	'Style','text', ...
	'Tag','Channel8');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[0.752941176470588 0.752941176470588 0.752941176470588], ...
	'FontSize',10, ...
	'ListboxTop',0, ...
	'Position',[14.25 200.45 54 15], ...
	'String','Channel 9', ...
	'Style','text', ...
	'Tag','Channel9');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[0.752941176470588 0.752941176470588 0.752941176470588], ...
	'FontSize',10, ...
	'ListboxTop',0, ...
	'Position',[14.25 177.6 54 15], ...
	'String','Channel 10', ...
	'Style','text', ...
	'Tag','Channel10');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[0.752941176470588 0.752941176470588 0.752941176470588], ...
	'FontSize',10, ...
	'ListboxTop',0, ...
	'Position',[14.25 154.75 54 15], ...
	'String','Channel 11', ...
	'Style','text', ...
	'Tag','Channel11');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[0.752941176470588 0.752941176470588 0.752941176470588], ...
	'FontSize',10, ...
	'ListboxTop',0, ...
	'Position',[14.25 131.9 54 15], ...
	'String','Channel 12', ...
	'Style','text', ...
	'Tag','Channel12');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[0.752941176470588 0.752941176470588 0.752941176470588], ...
	'FontSize',10, ...
	'ListboxTop',0, ...
	'Position',[14.25 109.05 54 15], ...
	'String','Channel 13', ...
	'Style','text', ...
	'Tag','Channel13');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[0.752941176470588 0.752941176470588 0.752941176470588], ...
	'FontSize',10, ...
	'ListboxTop',0, ...
	'Position',[14.25 86.19999999999999 54 15], ...
	'String','Channel 14', ...
	'Style','text', ...
	'Tag','Channel14');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[0.752941176470588 0.752941176470588 0.752941176470588], ...
	'FontSize',10, ...
	'ListboxTop',0, ...
	'Position',[14.25 63.35 54 15], ...
	'String','Channel 15', ...
	'Style','text', ...
	'Tag','Channel15');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[0.752941176470588 0.752941176470588 0.752941176470588], ...
	'FontSize',10, ...
	'ListboxTop',0, ...
	'Position',[14.25 40.5 54 15], ...
	'String','Channel 16', ...
	'Style','text', ...
	'Tag','Channel16');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[1 1 1], ...
	'ListboxTop',0, ...
	'Position',[83.25 383.2500000000001 194.25 15], ...
	'Style','edit', ...
   'Tag','Filename_Edit1');
Filename_Edit(1)=h1;
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[1 1 1], ...
	'ListboxTop',0, ...
	'Position',[83.25 360.4000000000001 194.25 15], ...
	'Style','edit', ...
   'Tag','Filename_Edit2');
Filename_Edit(2)=h1;
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[1 1 1], ...
	'ListboxTop',0, ...
	'Position',[83.25 337.5500000000001 194.25 15], ...
	'Style','edit', ...
   'Tag','Filename_Edit3');
Filename_Edit(3)=h1;
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[1 1 1], ...
	'ListboxTop',0, ...
	'Position',[83.25 314.7000000000001 194.25 15], ...
	'Style','edit', ...
   'Tag','Filename_Edit4');
Filename_Edit(4)=h1;
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[1 1 1], ...
	'ListboxTop',0, ...
	'Position',[83.25 291.85 194.25 15], ...
	'Style','edit', ...
   'Tag','Filename_Edit5');
Filename_Edit(5)=h1;
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[1 1 1], ...
	'ListboxTop',0, ...
	'Position',[83.25 269 194.25 15], ...
	'Style','edit', ...
   'Tag','Filename_Edit6');
Filename_Edit(6)=h1;
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[1 1 1], ...
	'ListboxTop',0, ...
	'Position',[83.2500  246.1500  194.2500   15.0000], ...
	'Style','edit', ...
   'Tag','Filename_Edit7');
Filename_Edit(7)=h1;
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[1 1 1], ...
	'ListboxTop',0, ...
	'Position',[83.2500  223.3000  194.2500   15.0000], ...
	'Style','edit', ...
   'Tag','Filename_Edit8');
Filename_Edit(8)=h1;
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[1 1 1], ...
	'ListboxTop',0, ...
	'Position',[83.25 200.45 194.25 15], ...
	'Style','edit', ...
   'Tag','Filename_Edit9');
Filename_Edit(9)=h1;
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[1 1 1], ...
	'ListboxTop',0, ...
	'Position',[83.25 177.6 194.25 15], ...
	'Style','edit', ...
   'Tag','Filename_Edit10');
Filename_Edit(10)=h1;
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[1 1 1], ...
	'ListboxTop',0, ...
	'Position',[83.25 154.75 194.25 15], ...
	'Style','edit', ...
   'Tag','Filename_Edit11');
Filename_Edit(11)=h1;
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[1 1 1], ...
	'ListboxTop',0, ...
	'Position',[83.25 131.9 194.25 15], ...
	'Style','edit', ...
   'Tag','Filename_Edit12');
Filename_Edit(12)=h1;
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[1 1 1], ...
	'ListboxTop',0, ...
	'Position',[83.25 109.05 194.25 15], ...
	'Style','edit', ...
   'Tag','Filename_Edit13');
Filename_Edit(13)=h1;
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[1 1 1], ...
	'ListboxTop',0, ...
	'Position',[83.25 86.19999999999999 194.25 15], ...
	'Style','edit', ...
   'Tag','Filename_Edit14');
Filename_Edit(14)=h1;
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[1 1 1], ...
	'ListboxTop',0, ...
	'Position',[83.25 63.35 194.25 15], ...
	'Style','edit', ...
   'Tag','Filename_Edit15');
Filename_Edit(15)=h1;
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[1 1 1], ...
	'ListboxTop',0, ...
	'Position',[83.25 40.5 194.25 15], ...
	'Style','edit', ...
   'Tag','Filename_Edit16');
Filename_Edit(16)=h1;
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[0.831372549019608 0.815686274509804 0.784313725490196], ...
	'Callback','[filename,pathname]=uigetfile(''*_A_Low.dat'',''Open data file'');if filename~=0 Filename_Edit=get(gcf,''Userdata'');set(Filename_Edit(1),''String'',[pathname filename]);end;', ...
	'FontSize',12, ...
	'ListboxTop',0, ...
	'Position',[306.75 383.2500000000001 45 15], ...
	'String','...', ...
	'Tag','Open_Button1');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
   'BackgroundColor',[0.831372549019608 0.815686274509804 0.784313725490196], ...
  	'Callback','[filename,pathname]=uigetfile(''*_A_Low.dat'',''Open data file'');if filename~=0 Filename_Edit=get(gcf,''Userdata'');set(Filename_Edit(2),''String'',[pathname filename]);end;', ...
	'FontSize',12, ...
	'ListboxTop',0, ...
	'Position',[306.75 360.4000000000001 45 15], ...
	'String','...', ...
	'Tag','Open_Button2');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
   'BackgroundColor',[0.831372549019608 0.815686274509804 0.784313725490196], ...
  	'Callback','[filename,pathname]=uigetfile(''*_A_Low.dat'',''Open data file'');if filename~=0 Filename_Edit=get(gcf,''Userdata'');set(Filename_Edit(3),''String'',[pathname filename]);end;', ...
	'FontSize',12, ...
	'ListboxTop',0, ...
	'Position',[306.75 337.5500000000001 45 15], ...
	'String','...', ...
	'Tag','Open_Button3');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
   'BackgroundColor',[0.831372549019608 0.815686274509804 0.784313725490196], ...
 	'Callback','[filename,pathname]=uigetfile(''*_A_Low.dat'',''Open data file'');if filename~=0 Filename_Edit=get(gcf,''Userdata'');set(Filename_Edit(4),''String'',[pathname filename]);end;', ...
	'FontSize',12, ...
	'ListboxTop',0, ...
	'Position',[306.75 314.7000000000001 45 15], ...
	'String','...', ...
	'Tag','Open_Button4');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
   'BackgroundColor',[0.831372549019608 0.815686274509804 0.784313725490196], ...
  	'Callback','[filename,pathname]=uigetfile(''*_A_Low.dat'',''Open data file'');if filename~=0 Filename_Edit=get(gcf,''Userdata'');set(Filename_Edit(5),''String'',[pathname filename]);end;', ...
	'FontSize',12, ...
	'ListboxTop',0, ...
	'Position',[306.75 291.85 45 15], ...
	'String','...', ...
	'Tag','Open_Button5');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
   'BackgroundColor',[0.831372549019608 0.815686274509804 0.784313725490196], ...
  	'Callback','[filename,pathname]=uigetfile(''*_A_Low.dat'',''Open data file'');if filename~=0 Filename_Edit=get(gcf,''Userdata'');set(Filename_Edit(6),''String'',[pathname filename]);end;', ...
	'FontSize',12, ...
	'ListboxTop',0, ...
	'Position',[306.75 269 45 15], ...
	'String','...', ...
	'Tag','Open_Button6');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
   'BackgroundColor',[0.831372549019608 0.815686274509804 0.784313725490196], ...
  	'Callback','[filename,pathname]=uigetfile(''*_A_Low.dat'',''Open data file'');if filename~=0 Filename_Edit=get(gcf,''Userdata'');set(Filename_Edit(7),''String'',[pathname filename]);end;', ...
	'FontSize',12, ...
	'ListboxTop',0, ...
	'Position',[306.7500  246.1500   45.0000   15.0000], ...
	'String','...', ...
	'Tag','Open_Button7');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
   'BackgroundColor',[0.831372549019608 0.815686274509804 0.784313725490196], ...
  	'Callback','[filename,pathname]=uigetfile(''*_A_Low.dat'',''Open data file'');if filename~=0 Filename_Edit=get(gcf,''Userdata'');set(Filename_Edit(8),''String'',[pathname filename]);end;', ...
	'FontSize',12, ...
	'ListboxTop',0, ...
	'Position',[306.7500  223.3000   45.0000   15.0000], ...
	'String','...', ...
	'Tag','Open_Button8');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
   'BackgroundColor',[0.831372549019608 0.815686274509804 0.784313725490196], ...
  	'Callback','[filename,pathname]=uigetfile(''*_A_Low.dat'',''Open data file'');if filename~=0 Filename_Edit=get(gcf,''Userdata'');set(Filename_Edit(9),''String'',[pathname filename]);end;', ...
	'FontSize',12, ...
	'ListboxTop',0, ...
	'Position',[306.75 200.45 45 15], ...
	'String','...', ...
	'Tag','Open_Button9');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
   'BackgroundColor',[0.831372549019608 0.815686274509804 0.784313725490196], ...
  	'Callback','[filename,pathname]=uigetfile(''*_A_Low.dat'',''Open data file'');if filename~=0 Filename_Edit=get(gcf,''Userdata'');set(Filename_Edit(10),''String'',[pathname filename]);end;', ...
	'FontSize',12, ...
	'ListboxTop',0, ...
	'Position',[306.75 177.6 45 15], ...
	'String','...', ...
	'Tag','Open_Button10');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
   'BackgroundColor',[0.831372549019608 0.815686274509804 0.784313725490196], ...
	'Callback','[filename,pathname]=uigetfile(''*_A_Low.dat'',''Open data file'');if filename~=0 Filename_Edit=get(gcf,''Userdata'');set(Filename_Edit(11),''String'',[pathname filename]);end;', ...
   'FontSize',12, ...
	'ListboxTop',0, ...
	'Position',[306.75 154.75 45 15], ...
	'String','...', ...
	'Tag','Open_Button11');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
   'BackgroundColor',[0.831372549019608 0.815686274509804 0.784313725490196], ...
  	'Callback','[filename,pathname]=uigetfile(''*_A_Low.dat'',''Open data file'');if filename~=0 Filename_Edit=get(gcf,''Userdata'');set(Filename_Edit(12),''String'',[pathname filename]);end;', ...
	'FontSize',12, ...
	'ListboxTop',0, ...
	'Position',[306.75 131.9 45 15], ...
	'String','...', ...
	'Tag','Open_Button12');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
   'BackgroundColor',[0.831372549019608 0.815686274509804 0.784313725490196], ...
  	'Callback','[filename,pathname]=uigetfile(''*_A_Low.dat'',''Open data file'');if filename~=0 Filename_Edit=get(gcf,''Userdata'');set(Filename_Edit(13),''String'',[pathname filename]);end;', ...
	'FontSize',12, ...
	'ListboxTop',0, ...
	'Position',[306.75 109.05 45 15], ...
	'String','...', ...
	'Tag','Open_Button13');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
   'BackgroundColor',[0.831372549019608 0.815686274509804 0.784313725490196], ...
  	'Callback','[filename,pathname]=uigetfile(''*_A_Low.dat'',''Open data file'');if filename~=0 Filename_Edit=get(gcf,''Userdata'');set(Filename_Edit(14),''String'',[pathname filename]);end;', ...
	'FontSize',12, ...
	'ListboxTop',0, ...
	'Position',[306.75 86.19999999999999 45 15], ...
	'String','...', ...
	'Tag','Open_Button14');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
   'BackgroundColor',[0.831372549019608 0.815686274509804 0.784313725490196], ...
  	'Callback','[filename,pathname]=uigetfile(''*_A_Low.dat'',''Open data file'');if filename~=0 Filename_Edit=get(gcf,''Userdata'');set(Filename_Edit(15),''String'',[pathname filename]);end;', ...
	'FontSize',12, ...
	'ListboxTop',0, ...
	'Position',[306.75 63.35 45 15], ...
	'String','...', ...
	'Tag','Open_Button15');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
   'BackgroundColor',[0.831372549019608 0.815686274509804 0.784313725490196], ...
  	'Callback','[filename,pathname]=uigetfile(''*_A_Low.dat'',''Open data file'');if filename~=0 Filename_Edit=get(gcf,''Userdata'');set(Filename_Edit(16),''String'',[pathname filename]);end;', ...
	'FontSize',12, ...
	'ListboxTop',0, ...
	'Position',[306.75 40.5 45 15], ...
	'String','...', ...
	'Tag','Open_Button16');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
   'BackgroundColor',[0.831372549019608 0.815686274509804 0.784313725490196], ...
   'Callback','Filename_Edit=get(gcf,''Userdata'');Filenamelist=[''''];num=0;for n=1:16, filename=get(Filename_Edit(n),''String'');if ~isempty(filename) Filenamelist(n,1:length(filename))=filename;num=num+1;end;end;close(gcf);clear filename pathname Filename_Edit n;Axeslist=get(1,''Userdata'');set(Axeslist(17),''Enable'',''on'');',...
	'ListboxTop',0, ...
	'Position',[234.75 7.5 45 15], ...
	'String','OK', ...
	'Tag','Pushbutton2');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
   'BackgroundColor',[0.831372549019608 0.815686274509804 0.784313725490196], ...
   'Callback','Filenamelist=[];num=0;;clear filename pathname Filename_Edit n;close(gcf);',...
	'ListboxTop',0, ...
	'Position',[293.25 8.25 45 15], ...
	'String','Cancel', ...
	'Tag','Pushbutton3');
set(gcf,'Userdata',Filename_Edit);