

function openday_17

    % Creating a figure to house the GUI
    figure

    % Defining basic positions
    xstart = 0.01; ystart = 0.05; boxwidth = 0.07; gap = 0.02; yini = 0.7;

    % Creating editbox for taking the frequency components
    % Frequency Range for analysis 

    uicontrol('Style','text',...
                'Unit','Normalized',...
                'Position',[xstart  yini  0.12  0.1],...
                'String','Alpha Range');

    hAlphaMin = uicontrol('style','edit',...
                        'Unit','Normalized',...
                        'Position', [xstart   yini-gap   boxwidth   boxwidth]);

    hAlphaMax = uicontrol('style','edit',...
                        'Unit','Normalized',...
                        'Position', [xstart+(boxwidth)  yini-gap   boxwidth  boxwidth]);                

    % Creating pushbuttons 
    hStart = uicontrol('style', 'pushbutton',...
                        'string', 'Start',...
                        'Unit','Normalized',...
                        'Position', [xstart  0.5  boxwidth  boxwidth],...
                        'Callback',{@Callback_Start});

    hStop = uicontrol('style', 'pushbutton',...
                        'string', 'Stop',...
                        'Unit','Normalized',...
                        'Position', [xstart+(boxwidth)   0.5   boxwidth  boxwidth],...
                        'callback',{@Callback_Stop});

    hCalibrate = uicontrol('style', 'pushbutton',...
                        'string', 'Calibrate',...
                        'Unit','Normalized',...
                        'Position', [xstart  0.5-boxwidth  boxwidth  boxwidth],...
                        'Callback',{@Callback_Calibrate});

    hRun = uicontrol('style', 'pushbutton',...
                        'string', 'Run',...
                        'Unit','Normalized',...
                        'Position', [xstart+(boxwidth)   0.5-boxwidth   boxwidth  boxwidth],...
                        'Callback',{@Callback_Run}); 
    hExit = uicontrol('style', 'pushbutton',...
                        'string', 'Exit',...
                        'Unit','Normalized',...
                        'Position', [xstart   0.5-boxwidth*2   boxwidth  boxwidth],...
                        'Callback',{@Callback_Exit}); 

    % Creating plots
    plot_xstart = xstart+(boxwidth*2.5); plot_ystart = ystart;
    plot_delX = 1-ystart*4; plot_delY = 1-ystart*3;

    plotPos     =   [plot_xstart,plot_ystart,plot_delX,plot_delY];
    plotHandles =   getPlotHandles(2,1,plotPos,0.06,0.05,0); 

    % Getting plot handles
    hRawTrace   =  plotHandles(1,1);
    hTF         =  plotHandles(2,1);

    % Creating a single handle structure which would contain both the rawtrace
    % and tf handles

    %?? Hopefully the handles becomes the global variables

    handles.hRawTrace = hRawTrace;
    handles.hTF       = hTF;

    drawnow  % This drawnow updates the figure 

    % Initializing the parameters for the main programme

    state = 0; % by default state is zero which would be updated according to the case
    Fs = 500;
    sampleDurationS = 1;
    timeValsS = 0:1/Fs:sampleDurationS-1/Fs;
    timeStartS = 0;
    fullDisplayDurationS = 5;
    
    % defining default variables for the starttime
    stcount = 1;
    EXPcount = 1;
%     btcount = 1;
    dataTemp  = [];
    timeTemp  = [];
    
    % definigng default variables for the calibration 
    calibrationDurationS = 10;
    runtimeDurationS     = 50;

    handles.fullDisplayDurationS = fullDisplayDurationS;
    handles.calibrationDurationS =calibrationDurationS;
    handles.runtimeDurationS = runtimeDurationS;
%     trialNumber = 1;
    % Initializing the default variables 
    AlphaChans = [1 2 3 4 5];  % The chaneels from which the data is extracted
    AlphaMin = get(hAlphaMin,'String'); % Right now unused
    
    BDstart = 1;
    EXPstart = calibrationDurationS+sampleDurationS;
    EXPcount = 1;

    powerTemp = zeros(51,fullDisplayDurationS);
    
    blDataTemp  = zeros(5,Fs*calibrationDurationS);
    EXPdataTemp = zeros(5,Fs*runtimeDurationS) ;
    blPowerTemp = zeros(51,calibrationDurationS);
    EXPpowerTemp = zeros(51,runtimeDurationS);
    % opeing the RDA port as the GUI is shown
    [cfg,sock] = rda_open;               % rda_open would pass the sokect information
    hdr = rda_header(cfg,sock);          % rda_header would pass the header details
    
    
    while 1

    %     Get alpha Range
    %     Do time-frequency analysis to get PSD
    %     AB: Everything above can be done in a single function instead of
    %     passing the data from one to another. 
    
    %     Get the data and get the psd
    %     also, but dont plot
    
    [raw, SQN] = rda_message(sock,hdr);    % reading rda message
        
        
        if state == 0 % Idle state
            timeStartS=0; % dont do anything

        elseif state == 1 % Start
            % get the time axis and plot one second of the data
            if stcount==2
                cla(hRawTrace);
                cla(hTF);
            end
            stcount = 1;
            X = raw.data;           
            timeToUse = timeStartS + timeValsS;
            timeToPlot = [timeTemp timeToUse];
            datatoplot = [dataTemp X];
            timeStartS=timeStartS+sampleDurationS; 
            powerTemp(:,timeStartS) = raw.meanPower;
            meanRawPower = powerTemp;
            meanRawPower = meanRawPower(:,any(meanRawPower));
            freq = raw.freq;
            checkplot_time(state,handles,timeToPlot,datatoplot,freq,meanRawPower); 
            dataTemp = X(:,end);
            timeTemp = timeToUse(end);
            if timeStartS==fullDisplayDurationS
                dataTemp = [];
                timeTemp = [];
                timeStartS=0;
                cla(hRawTrace);
                cla(hTF);
                powerTemp = zeros(51,fullDisplayDurationS);
                
            end   
        elseif state == 2 % Stop
            dataTemp = [];
            timeTemp = [];
            stcount = 1;
            timeStartS=0;           
            powerTemp = zeros(51,fullDisplayDurationS);
            stcount = stcount+1;
%             rda_close(sock); 
%             powerTemp = zeros(51,fullDisplayDurationS);
    %         pause(1);

        elseif state == 3 % Calibrate
            if timeStartS < calibrationDurationS
                % Display PSD and T-F plot as before
                % Save PSD data in a larger array
                % compute alpha power
                X = raw.data; 
                BDstop = ((BDstart+Fs)-1);
                timeToUse =  timeStartS + timeValsS;
                timeToPlot = [timeTemp timeToUse];
                datatoplot = [dataTemp X];
                timeStartS = timeStartS+sampleDurationS; 
                blDataTemp(:,BDstart:BDstop) = X; 

                blPowerTemp(:,timeStartS) = raw.meanPower;
                meanRawPower = blPowerTemp;
                meanRawPower = meanRawPower(:,any(meanRawPower));
                freq = raw.freq;
                checkplot_time(state,handles,timeToPlot,datatoplot,freq,meanRawPower); 
                dataTemp = X(:,end);
                timeTemp = timeToUse(end);
                BDstart = BDstart+Fs;
            
            elseif timeStartS==calibrationDurationS
                % compute the baseline values
                % display baseline in a separate
                % Save the entire calibarion data in a separate file
%                 timeStartS=timeStartS+sampleDurationS;
                dataTemp = [];
                timeTemp = [];
                BL = [];
                blData = blDataTemp;
                BL.blData = blData;
                blPower = blPowerTemp;
                BL.blPower = blPower;
                blDataTemp = zeros(5,Fs*calibrationDurationS);
                blPowerTemp = zeros(51,calibrationDurationS);
                cla(hRawTrace);
                cla(hTF);
                save('BfBlData','blData','blPower'); % in future include specific file name
                state = 0;
            end

        elseif state == 4 % run Experiment
              if timeStartS < runtimeDurationS
                % Display PSD and T-F plot as before
                % Save PSD data in a larger array
                % compute alpha power
%                 EXPcount = EXPcount+1;
                if (EXPcount==1)
                    X = raw.data; 
                    freq = raw.freq;
                    power = raw.meanPower;
                    blpower = blpower; 
                    blData = BL.blData;
                    combData = [blData X];
                    combPower = [blPower power];
                    % plot the data using the already set timeaxis
                    % and holdon
                end
                    
                if (EXPcount>1)
                    X = raw.data; 
                    EXPstop = ((EXPstart+Fs)-1);
                    timeToUse =  EXPtimeStartS + timeValsS;
                    timeToPlot = [timeTemp timeToUse];
                    datatoplot = [dataTemp X];
                    EXPtimeStartS = EXPtimeStartS+sampleDurationS; 
                    EXPdataTemp(:,EXPstart:EXPstop) = X; 

                    EXPpowerTemp(:,EXPtimeStartS) = raw.meanPower;
                    meanRawPower = blPowerTemp;
                    meanRawPower = meanRawPower(:,any(meanRawPower));
                    freq = raw.freq;
                    checkplot_time_2(EXPcount,handles,timeToPlot,datatoplot,freq,meanRawPower,BL); 
                    dataTemp = X(:,end);
                    timeTemp = timeToUse(end);
                    EXPstart = EXPstart+Fs;
                end
                EXPcount = EXPcount+1;
                
            
            elseif timeStartS==runtimeDurationS
                % compute the baseline values
                % display baseline in a separate
                % Save the entire calibarion data in a separate file
%                 timeStartS=timeStartS+sampleDurationS;
                dataTemp = [];
                timeTemp = [];
                EXPData = EXPdataTemp;
                EXPPower = EXPpowerTemp;
                EXPdataTemp = zeros(5,Fs*runtimeDurationS) ;
                EXPpowerTemp = zeros(51,runtimeDurationS);
                cla(hRawTrace);
                cla(hTF);
                save('EXPBlData','EXPData','EXPPower'); % in future include specific file name
                state = 0;
            
        elseif state == 5 % Exit the Experiment
            rda_close(sock); 
            break
        end

        drawnow;
        end
end

% Callback functions

    function Callback_Start(~,~)
        state = 1;
    end

    function Callback_Stop(~,~)
            state = 2;
    end

    function Callback_Calibrate(~,~)
            state = 3;
    end

    function Callback_Run(~,~)
            state = 4;
    end
         
    function Callback_Exit(~,~)
            state = 5;
    end
end



