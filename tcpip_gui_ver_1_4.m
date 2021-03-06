function hc = tcpip_gui_ver_1_4

%% The new version of the TCP ip GUI

%% Fonts

hc = figure(1123);
fontSizeSmall = 10; fontSizeMedium = 12; fontSizeLarge = 16; fontSizeTiny = 8;

% baselineperiod = num2str(7); exp_runtime = 50;
% Make Panels

% Defining Basic positions

%% cap position
capStartPos = 0.005;  capStartHeight = 0.68; capWidth = 0.22;  capHeight = 0.3;
% control panel position, keeping the same as the cap width
controlStartPanelPos = 0.01; controlPanelWidth = capWidth/2;
controlPanelStartHeight = 0.015;  controlPanelHeight = 0.5/1.4;
% timing panel position
timingPanelWidth = 0.18; timingStartPos = controlStartPanelPos+controlPanelWidth;
% tf panel position
tfPanelWidth = 0.18; tfStartPos = timingStartPos+timingPanelWidth;
plotOptionsPanelWidth = 0.18; plotOptionsStartPos = tfStartPos+tfPanelWidth;
backgroundColor = 'w';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Topoplot %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Loading the channel location file
chanFile = 'biofeedback_5Ch';%'biofeedback_5ch.mat';
locpath=fullfile(pwd,chanFile);
chanLocFile = load(locpath);
chanlocs = chanLocFile.chanlocs;

% Position for the scalpmap on the GUI
electrodeCapPos = [capStartPos capStartHeight capWidth/2 capHeight];
capHandle = subplot('Position',electrodeCapPos);
subplot(capHandle); topoplot([],chanlocs,'electrodes','numbers','style','blank','drawaxis','off'); 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Control Panel %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Making The Panel

dynamicHeight = 0.09; dynamicGap=0.015; dynamicTextWidth = 0.5;
hDynamicPanel = uipanel('Title','Control Panel','fontSize', fontSizeLarge, ...
    'Unit','Normalized','Position',[controlStartPanelPos 0.30 controlPanelWidth controlPanelHeight]);

% Baseline

uicontrol('Parent',hDynamicPanel,'Unit','Normalized', ...
        'Position',[0 1-1*(dynamicHeight+dynamicGap) dynamicTextWidth-dynamicGap dynamicHeight], ...
        'Style','text','String','Baseline Period (s)','FontSize',fontSizeSmall);
hBLPeriod = uicontrol('Parent',hDynamicPanel,'Unit','Normalized', ...
        'BackgroundColor', backgroundColor, 'Position', ...
        [dynamicTextWidth 1-1*(dynamicHeight+dynamicGap) 1-dynamicTextWidth-dynamicGap dynamicHeight], ...
        'Style','edit','String','7','FontSize',fontSizeSmall);  % Creating the Handle for the Baseline period 

% Run-time

uicontrol('Parent',hDynamicPanel,'Unit','Normalized', ...
        'Position',[0 1-2*(dynamicHeight+dynamicGap) dynamicTextWidth-dynamicGap dynamicHeight], ...
        'Style','text','String','Run time (s)','FontSize',fontSizeSmall);
hRunTime = uicontrol('Parent',hDynamicPanel,'Unit','Normalized', ...
        'BackgroundColor', backgroundColor, 'Position', ...
        [dynamicTextWidth 1-2*(dynamicHeight+dynamicGap) 1-dynamicTextWidth-dynamicGap dynamicHeight], ...
        'Style','edit','String','50','FontSize',fontSizeSmall); % Handle for the experiment runtime
 
% Frequency Range for analysis 

uicontrol('Parent',hDynamicPanel,'Unit','Normalized', ...
        'Position',[0 1-3*(dynamicHeight+dynamicGap) dynamicTextWidth-dynamicGap dynamicHeight], ...
        'Style','text','String','Frequency Range','FontSize',fontSizeSmall);
hAlphaRangeMin = uicontrol('Parent',hDynamicPanel,'Unit','Normalized', ...
        'BackgroundColor', backgroundColor, 'Position', ...
        [dynamicTextWidth 1-3*(dynamicHeight+dynamicGap) (1-dynamicTextWidth-dynamicGap)/2 dynamicHeight], ...
        'Style','edit','String','7','FontSize',fontSizeSmall);
hAlphaRangeMax = uicontrol('Parent',hDynamicPanel,'Unit','Normalized', ...
        'BackgroundColor', backgroundColor, 'Position', ...
        [dynamicTextWidth+(1-dynamicTextWidth-dynamicGap)/2 1-3*(dynamicHeight+dynamicGap) (1-dynamicTextWidth-dynamicGap)/2 dynamicHeight], ...
        'Style','edit','String','13','FontSize',fontSizeSmall);
    
% Defining the electrodes to pool

uicontrol('Parent',hDynamicPanel,'Unit','Normalized', ...
        'Position',[0 1-5*(dynamicHeight+dynamicGap) (dynamicTextWidth*2-dynamicGap)/2 dynamicHeight], ...
        'Style','text','String','Elecs to pool','FontSize',fontSizeSmall);
hPoolElecAlpha = uicontrol('Parent',hDynamicPanel,'Unit','Normalized', ...
        'BackgroundColor', backgroundColor, 'Position', ...
        [(dynamicTextWidth*2-dynamicGap)/2 1-5*(dynamicHeight+dynamicGap) (dynamicTextWidth*2-dynamicGap)/2 dynamicHeight], ...
        'Style','edit','String','1 2 3 4 5','FontSize',fontSizeSmall);

%% Buttons associated with specific function callbacks

% Callback baseline function for analysis
hStart = uicontrol('Parent',hDynamicPanel,'Unit','Normalized', ...
    'Position',[0 1-8*(dynamicHeight+dynamicGap) (dynamicTextWidth*2-dynamicGap)/2 dynamicHeight*2],...
    'Style','pushbutton','String','Start','FontSize',fontSizeSmall,'Callback',{@contEEG_Callback});
% Callback stimulus function for analysis
hStop = uicontrol('Parent',hDynamicPanel,'Unit','Normalized', ...
    'Position',[(dynamicTextWidth*2-dynamicGap)/2 1-8*(dynamicHeight+dynamicGap) (dynamicTextWidth*2-dynamicGap)/2 dynamicHeight*2],...
    'Style','togglebutton','String','Stop','FontSize',fontSizeSmall);
hCalibrate = uicontrol('Parent',hDynamicPanel,'Unit','Normalized', ...
    'Position',[0 1-9.6*(dynamicHeight+dynamicGap) (dynamicTextWidth*2-dynamicGap)/2 dynamicHeight*2],...
    'Style','togglebutton','String','Calibrate','FontSize',fontSizeSmall);
hRun = uicontrol('Parent',hDynamicPanel,'Unit','Normalized', ...
    'Position',[(dynamicTextWidth*2-dynamicGap)/2 1-9.6*(dynamicHeight+dynamicGap) (dynamicTextWidth*2-dynamicGap)/2 dynamicHeight*2],...
    'Style','togglebutton','String','Run','FontSize',fontSizeSmall);

% uicontrol('Parent',hDynamicPanel,'Unit','Normalized', ...
%     'Position',[(dynamicTextWidth*1-dynamicGap)/2 1-8*(dynamicHeight+dynamicGap) (dynamicTextWidth*2-dynamicGap)/2 dynamicHeight],...
%     'Style','pushbutton','String','START','FontSize',fontSizeSmall,'Callback',{@run_Callback});


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                      Plots                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Getting handles for the plots 
plotsStartPos = capStartPos*9+controlPanelWidth; plotsStartHeight = controlPanelStartHeight; plotsWidth = 1-(plotsStartPos+capStartPos*2); plotsHeight = 1-plotsStartHeight*3;

plotsPosOne     =   [plotsStartPos (0.18+0.05+0.06)+(0.18+0.06)+(0.18+0.06) plotsWidth 0.18];
plotsPosTwo     =   [plotsStartPos (0.18+0.05+0.06)+(0.18+0.06)  plotsWidth 0.18];
plotsPosThree   =   [plotsStartPos (0.18+0.05)+0.06 plotsWidth 0.18];
plotsPosFour    =   [0.05 0.05 0.9 0.18];

plotHandlesOne   =    getPlotHandles(1,1,plotsPosOne,   0.05,0.05,0); 
plotHandlesTwo   =    getPlotHandles(1,2,plotsPosTwo,   0.05,0.05,0);      % two long plot of 10 seconds having raw spectrum and psd plot
plotHandlesThree =    getPlotHandles(1,2,plotsPosThree, 0.05,0.05,0);    % two plot during the baseline and the runtime
plotHandlesFour  =    getPlotHandles(1,3,plotsPosFour,  0.05,0.05,0);     % three plot for the results
 
% plotHandles = getPlotHandles(6,1,plotsPos,0.05,0.05,0);

% Creating plots and geeting the handles 

%% plot handles of the three experimental plots
hRawTrace                =  plotHandlesOne(1,1);
hContTfRawTrace          =  plotHandlesTwo(1,1);
hContPsdRawTrace         =  plotHandlesTwo(1,2);

%% plot handles for the plots during the exeperiment
hTFSpectrum              =  plotHandlesThree(1,1);
hPSD                     =  plotHandlesThree(1,2);

%% plot handles for the three result plot
hAlphaPowerWtime         =  plotHandlesFour(1,1);
hAlpahPowerWtno          =  plotHandlesFour(1,2);
hAlphapowerBlWtno        =  plotHandlesFour(1,3);

%% creating handles for passing on

handles                     = [];
handles.hRawTrace           = hRawTrace;
handles.hContTfRawTrace     = hContTfRawTrace;
handles.hContPsdRawTrace    = hContPsdRawTrace ;
handles.chanlocs            = chanlocs;

handles.hTFSpectrum         = hTFSpectrum ;
handles.hPSD                = hPSD ; 

handles.hAlphaPowerWtime     = hAlphaPowerWtime;
handles.hAlpahPowerWtno      = hAlpahPowerWtno ;
handles.hAlphapowerBlWtno    = hAlphapowerBlWtno;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


    function contEEG_Callback(~,~)
        %% planning to pass on the arguments here in this function        
        
        while 1
            AlphaChans = str2num(get(hPoolElecAlpha,'String'));
    %         BLPeriod = str2num(get(hBLPeriod,'String'));
            handles.hBLPeriod = hBLPeriod;
            handles.hRunTime = hRunTime;
            handles.AlphaChans = AlphaChans;

          monitorFlag = get(hStart,'Value');
          if monitorFlag == get(hStart,'Max'); 
          state = 1; end;

          stopFlag = get(hStop,'Value');
          if stopFlag == get(hStart,'Max');
              disp(stopFlag);
              state = 2;
          end;

          calibrateFlag = get(hCalibrate,'Value');
          if calibrateFlag == get(hCalibrate,'Max'); 
          state = 3;end;

          startFlag = get(hRun,'Value');
          if startFlag == get(hRun,'Max'); 
          state = 4;end; 
          if state ==2
              break
          end
          state = contEEG(state,hStart,hStop,hCalibrate,hRun,handles);
        end
    end




% Baseline callback
%% Commenting the baseline code

%     function rawbldata = calcBL_Callback(~,~)
%         BLPeriod = get(hBLPeriod,'String');
%         AlphaChans = get(hPoolElecAlpha,'String');
% 
%         handles.AlphaChans = AlphaChans;
%         handles.BLPeriod = BLPeriod;
%         
%         [rawbldata,~,mLogBL,~,dPowerBL] = calculateBaseline(BLPeriod,handles);
%         savefile = 'rawbldata.mat';
%         handles.mLogBL=mLogBL;
%         handles.dPowerBL=dPowerBL;
%         save(savefile,'rawbldata');
%     end

% Runtime callback

%     function [data,trialtype,tag]= run_Callback(~,~)   
%         warning('off','MATLAB:hg:willberemoved');        
%         
%         %% Including more necessary handles
%         
%         BLPeriod = get(hBLPeriod,'String');
%         AlphaChans = get(hPoolElecAlpha,'String');
%         handles.AlphaChans = AlphaChans;
%         handles.BLPeriod = BLPeriod;
%         
%         handles.totPass= str2num(get(hRunTime,'String'));
%         alphaRangeMin =  str2num(get(hAlphaRangeMin,'string'));
%         alphaRangeMax =  str2num(get(hAlphaRangeMax,'string'));
% 
%         [data,trialtype,tag] = runprotocol_biofeedback(handles,alphaRangeMin,alphaRangeMax,hc);
% %         save(['biofeedback_' tag],'data','trialtype');
%     end



end