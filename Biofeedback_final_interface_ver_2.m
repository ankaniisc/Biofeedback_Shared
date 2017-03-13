
%% Start the interface after asking the subejct name date and session details from the experimenter.
%  take subject name, session as input and save them as variables to be used
%  later during saving the datas


%% Generate a list of randomly permuted 1 0 2 s. Take it as trailtypes and give the feedback accordingly. 


%% Make a long string to save the data accordingly. 



function Biofeedback_final_interface_ver_2
    
    % Inserting a resullt plot having change in alphapower from baseline 

    % Creating a figure to house the GUI
    figure; 

    % Defining basic positions
    xstart = 0.01; ystart = 0.05; boxwidth = 0.07; gap = 0.02; yini = 0.55;
    yControlStart = 0.3;

    % Creating editbox for taking the frequency components
    % Frequency Range for analysis 
    uicontrol('Style','text',...
                'Unit','Normalized',...
                'Position',[xstart  0.85  0.14  0.1],...
                'String','Subject Name');                  

    hsubjectname = uicontrol('style','edit',...
                        'String','test',...
                        'Unit','Normalized',...
                        'Position', [xstart   0.85-gap   boxwidth*2   boxwidth]);
    
    uicontrol('Style','text',...
                'Unit','Normalized',...
                'Position',[xstart  0.7  0.14  0.1],...
                'String','Session No');                  

    hsessionNo = uicontrol('style','edit',...
                        'String','1',...
                        'Unit','Normalized',...
                        'Position', [xstart   0.7-gap   boxwidth*2   boxwidth]);

    uicontrol('Style','text',...
                'Unit','Normalized',...
                'Position',[xstart  yini  0.12  0.1],...
                'String','Alpha Range');

    hAlphaMin = uicontrol('style','edit',...
                        'String','8',...
                        'Unit','Normalized',...
                        'Position', [xstart   yini-gap   boxwidth   boxwidth]);

    hAlphaMax = uicontrol('style','edit',...
                        'String','13',...
                        'Unit','Normalized',...
                        'Position', [xstart+(boxwidth)  yini-gap   boxwidth  boxwidth]);   
                    
  

                    
    % Creating pushbuttons 
    hStart = uicontrol('style', 'pushbutton',...
                        'string', 'Start',...
                        'Unit','Normalized',...
                        'Position', [xstart  yControlStart  boxwidth  boxwidth],...
                        'Callback',{@Callback_Start});

    hStop = uicontrol('style', 'pushbutton',...
                        'string', 'Stop',...
                        'Unit','Normalized',...
                        'Position', [xstart+(boxwidth)   yControlStart   boxwidth  boxwidth],...
                        'callback',{@Callback_Stop});

    hCalibrate = uicontrol('style', 'pushbutton',...
                        'string', 'Calibrate',...
                        'Unit','Normalized',...
                        'Position', [xstart  yControlStart-boxwidth  boxwidth  boxwidth],...
                        'Callback',{@Callback_Calibrate});

    hRun = uicontrol('style', 'pushbutton',...
                        'string', 'Run',...
                        'Unit','Normalized',...
                        'Position', [xstart+(boxwidth)   yControlStart-boxwidth   boxwidth  boxwidth],...
                        'Callback',{@Callback_Run}); 
    hExit = uicontrol('style', 'pushbutton',...
                        'string', 'Exit',...
                        'Unit','Normalized',...
                        'Position', [xstart   yControlStart-boxwidth*2   boxwidth  boxwidth],...
                        'Callback',{@Callback_Exit}); 

    % Creating plots
    plot_xstart = xstart+(boxwidth*2.5); plot_ystart = ystart;
    plot_delX = 1-ystart*4; plot_delY = 1-ystart*3;

    plotPos     =   [plot_xstart,plot_ystart,plot_delX,plot_delY];
    plotHandles =   getPlotHandles(2,1,plotPos,0.06,0.05,0); 

    % Getting plot handles
    hRawTrace   =  plotHandles(1,1);
    hRawTrace_2  =  plotHandles(2,1);
    hTF         =  plotHandles(3,1);

    % Creating a single handle structure which would contain both the rawtrace
    % and tf handles

    %?? Hopefully the handles becomes the global variables

    handles.hRawTrace   = hRawTrace;
    handles.hRawTrace_2 = hRawTrace_2;
    handles.hTF         = hTF;

    drawnow  % This drawnow updates the figure 

    
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    tot_trials = 4; % defining total number of trials in a session
    % creating the array of trialtypes
    % defining zero for the constant tone    (25% of the total trials),
    % defining one for the dependent tone   (50% of the total trials),
    % defining two for the independent tone (25% of the total trial)
    % generating ones, twos and zeros accordingly 
    trialtype = [zeros(tot_trials/4,1);ones(tot_trials/2,1);repmat(2,tot_trials/4,1)]';

    % randomizing the trialtype

    trialtype = trialtype(randperm(tot_trials));
    disp(trialtype);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    start_value = 1;
    end_value = tot_trials;
   
    trialNo = start_value;
        
    betaLowerLimit = 14;
    betaUpperLimit = 19;   
   subjectname = get(hsubjectname,'string');
   sessionNo = get(hsessionNo,'string');
   tag = [subjectname '_ses_'  sessionNo];
   
   
   
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
   % Initializing the parameters for the main programme

    state = 0; % by default state is zero which would be updated according to the case
    Fs = 500;
    sampleDurationS = 1;
    timeValsS = 0:1/Fs:sampleDurationS-1/Fs;
    timeStartS = 0;
    fullDisplayDurationS = 60;
    
    % defining default variables for the starttime
    stcount = 1;
    blcount = 1;
    EXPcount = 1;
%     btcount = 1;
    dataTemp  = [];
    timeTemp  = [];
    
    % definigng default variables for the calibration 
    calibrationDurationS = 10;
    runtimeDurationS     = 50;

    handles.fullDisplayDurationS =  fullDisplayDurationS;
    handles.calibrationDurationS =  calibrationDurationS;
    handles.runtimeDurationS     =  runtimeDurationS;
%     trialNumber = 1;
    % Initializing the default variables 
    AlphaChans = [1 2 3 4 5];  % The chaneels from which the data is extracted
    AlphaMin = get(hAlphaMin,'String'); % Right now unused
    
    
    
    BDstart = 1;
    EXPstart = (calibrationDurationS + sampleDurationS); % which is the 11th second from which to start from 
    EXPcount = 1;
    dataExpBegin = (Fs*EXPstart)+1;
    
    powerTemp = zeros(51,fullDisplayDurationS);
    
    blDataTemp  = zeros(5,Fs*calibrationDurationS);
    EXPdataTemp = zeros(5,Fs*(calibrationDurationS+runtimeDurationS)) ;
    blPowerTemp = zeros(51,calibrationDurationS);
    EXPpowerTem = zeros(51,(calibrationDurationS+runtimeDurationS));
    
    % Initialization for the soundtone feedback
    smoothKernel = repmat(1/10,1,5);
    epochsToAvg = length(smoothKernel);  
%     alphaLowFreq = 8;
%     alphaHighFreq = 13;
    Fsound = 44100;
    % need a high enough value so that alpha power below baseline can be played
    Fc = 500; 
    Fi = 800;
    
    % opeing the RDA port as the GUI is shown
    [cfg,sock] = rda_open;               % rda_open would pass the sokect information
    hdr = rda_header(cfg,sock);          % rda_header would pass the header details
    
    % Inserting the relaxation and sustainance quoteient
    analysisRange = 11:40;
    rawstpower  = [];
    
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    while 1

    %     Get alpha Range
    %     Do time-frequency analysis to get PSD
    %     AB: Everything above can be done in a single function instead of
    %     passing the data from one to another. 
    
    %     Get the data and get the psd
    %     also, but dont plot
    
        [raw, SQN] =     rda_message(sock,hdr);    % reading rda message
        alphaLowFreq =   str2num(get(hAlphaMin,'string'));
        alphaHighFreq =  str2num(get(hAlphaMax,'string'));
        subjectname = get(hsubjectname,'string');
        sessionNo = get(hsessionNo,'string');
        tag = [subjectname '_ses_'  sessionNo];
        
        
        if state == 0 % Idle state
            timeStartS=0; % dont do anything

        elseif state == 1 % Start
            % get the time axis and plot one second of the data
            if stcount==2
                cla(hRawTrace);
                cla(hRawTrace_2);
                cla(hTF);
            end
            stcount = 1;
            X = raw.data;           
            timeToUse = timeStartS + timeValsS;
            timeToPlot = [timeTemp timeToUse];
            datatoplot = [dataTemp X];
            timeStartS=timeStartS+sampleDurationS; 
            powerTemp(:,timeStartS) = raw.meanPower;
            ch_meanRawPower = powerTemp;
            ch_meanRawPower = ch_meanRawPower(:,any(ch_meanRawPower));
            freq = raw.freq;
            checkplot_time(state,handles,timeToPlot,datatoplot,freq,ch_meanRawPower); 
            dataTemp = X(:,end);
            timeTemp = timeToUse(end);
            if timeStartS==fullDisplayDurationS
                dataTemp = [];
                timeTemp = [];
                timeStartS=0;
                cla(hRawTrace);
                cla(hRawTrace_2);
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
            cla(hRawTrace);
            cla(hRawTrace_2);
            cla(hTF);
%             rda_close(sock); 
%             powerTemp = zeros(51,fullDisplayDurationS);
    %         pause(1);

        elseif state == 3 % Calibrate
            t_type  = trialtype(1,trialNo);
            str_trialno = num2str(trialNo);
            str_t_type = num2str(t_type);
            
            if blcount==2
                cla(hRawTrace);
                cla(hRawTrace_2);
                cla(hTF);
                BDstart = 1;
            end
            blcount = 1;
                        
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
                ch_meanRawPower = blPowerTemp;
                ch_meanRawPower = ch_meanRawPower(:,any(ch_meanRawPower));
                freq = raw.freq;
                checkplot_time(state,handles,timeToPlot,datatoplot,freq,ch_meanRawPower); 
                dataTemp = X(:,end);
                timeTemp = timeToUse(end);
                BDstart = BDstart+Fs;
            
            elseif timeStartS==calibrationDurationS
                % compute the baseline values display baseline in a
                % separate Save the entire calibarion data in a separate
                % file
%                 timeStartS=timeStartS+sampleDurationS;
                dataTemp = [];
                timeTemp = [];
%                 BL = [];
                blData = blDataTemp;
%                 BL.blData = blData;
                rawBlPower = blPowerTemp;
                meanBlPower = mean(rawBlPower,2);
                logMeanBLPower = conv2Log(meanBlPower);
                ch_blpower = (conv2Log(rawBlPower) - repmat(logMeanBLPower,1,10));
%                 BL.blPower = blPower; % not nedd of creating a structure
%                 for  passing the data as all the data structures are all
%                 within the same fucntion

                blDataTemp = zeros(5,Fs*calibrationDurationS);
                blPowerTemp = zeros(51,calibrationDurationS);
                blcount = blcount+1;
%                 cla(hRawTrace);   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
%                 cla(hTF);
                tagsave = [tag 'trial_' str_trialno 'ttype_' str_t_type];
                save(['BF_BlData_' tagsave],'blData','rawBlPower'); % in future include specific file name
                tag =  [subjectname '_ses_'  sessionNo];
                state = 0;
            end

        elseif state == 4 % run Experiment
%               if timeStartS < runtimeDurationS 
                % Display PSD and T-F plot as before Save PSD data in a
                % larger array compute alpha power
%                 EXPcount = EXPcount+1;
                
                 t_type  = trialtype(1,trialNo);
                 str_trialno = num2str(trialNo);
                 str_t_type = num2str(t_type);
%                  tag = [tag 'trial' str_t_type];
                if (EXPcount==1)
                    % Getting current loop data: PN: teh power data is
                    % already in log format
                    
                    X = raw.data; 
                    freq = raw.freq;
                    power = raw.meanPower;
                    rawstpower = power;
                    logPower = conv2Log(power);
                    ch_stPower = logPower - logMeanBLPower;
                    
                    % Getting the baseline power and data from the previous loop run    
                    % Now: Making sure that the basline saves and passes me
                    % the data for the baselineperiod seconds
                    
%                     blpower = blpower; 
%                     blData = BL.blData;
                    combData = [blData X];                % concatenating the bldata with  the data in that loop
                    combPower = [ch_blpower ch_stPower];  % similarly for the blpower
                    % Substracting the meanpower of the baseline from the
                    % baseline raw power
                    % Initialization for plotting:
                    
%                     EXPRange = EXPstart*Fs;
%                     EXPdataTemp(:,1:EXPRange) = combData; 
                    
                    for i = 1:size(combData,2)
                        EXPdataTemp(:,i) = combData(:,i);                         
                    end
                  
                    EXPpowerTem(:,1:EXPstart)= combPower;
                    total_time = 11;
                    ExptimeValsS = 0:1/Fs:total_time-1/Fs;
                    ExptimeTemp = ExptimeValsS(end);
                    ExptempData = X(:,end);
                    
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    if(t_type == 1)
                        disp('playing alpha dependent tone');
                        incrFact(EXPcount) = mean(mean(combPower(alphaLowFreq:alphaHighFreq,end-epochsToAvg+1:end)'*smoothKernel(1,1)));
                        stFreq = round(Fc + incrFact(EXPcount) * Fi);
                        soundTone = sine_tone(Fsound ,1,stFreq);
                        sound(soundTone,Fsound);
                    elseif(t_type == 0)
                        disp('playing constant tone');
                        stFreq = Fc;
                        soundTone = sine_tone(Fsound ,1,stFreq);
                        sound(soundTone,Fsound);
                    elseif(t_type ==2) 
                        disp('playing alpha independent tone');
                        incrFact(EXPcount) = mean(mean(combPower(betaLowerLimit:betaUpperLimit,end-epochsToAvg+1:end)'*smoothKernel(1,1)));
                        stFreq = round(Fc + incrFact(EXPcount) * Fi);
                        soundTone = sine_tone(Fsound ,1,stFreq);
                        sound(soundTone,Fsound);
                    end
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
                    
                    checkplot_time_2(handles,ExptimeValsS,combData,freq,combPower); % plotting the total baselinedurationS+1 seconds of data
%                     EXPcount = EXPcount+1; % I can potentially insert this here itself and aquire the data in the expcount 
                   
                    
                elseif (EXPcount<51)
                    
                    % getting and pltting rawdata
                    X = raw.data; % get the rawdata
                    % get the time axis which starts from baselineDurations
                    % + 1 sec
                    
                     dataExpEnd = ((dataExpBegin+Fs)-1);
                     timeToUse = EXPstart + timeValsS;
                     timeToPlot = [ExptimeTemp timeToUse];
                     EXPstart = EXPstart + sampleDurationS;
                     datatoplot = [ExptempData X]; % contatenating recnet loops data weith the just previosu loops data 
                                     
                    EXPdataTemp(:,dataExpBegin:dataExpEnd) = X;
                    % getting and plotting powerdata
                    % here in each loop the power dat is collected 
                    exp_power = raw.meanPower;
                    rawstpower = [rawstpower exp_power];
                    ch_power = conv2Log(exp_power)- logMeanBLPower; % being conver
                    EXPpowerTem(:,EXPstart) = ch_power;
                    ch_meanRawPower = EXPpowerTem;
                    ch_meanRawPower = ch_meanRawPower(:,any(ch_meanRawPower));
                    freq = raw.freq;
                    
                    
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                
                    if(t_type == 1)
                        disp('playing alpha dependent tone');
                        incrFact(EXPcount) = mean(mean(ch_meanRawPower(alphaLowFreq:alphaHighFreq,end-epochsToAvg+1:end)'*smoothKernel(1,1)));
                        stFreq = round(Fc + incrFact(EXPcount) * Fi);
                        soundTone = sine_tone(Fsound ,1,stFreq);
                        disp(incrFact(EXPcount));
                        disp(stFreq);
                        sound(soundTone,Fsound);
                    elseif(t_type == 0)
                        disp('playing constant tone');
                        stFreq = Fc;
                        soundTone = sine_tone(Fsound ,1,stFreq);
                        sound(soundTone,Fsound);
                    elseif(t_type ==2) 
                        disp('playing alpha independent tone');
                        incrFact(EXPcount) = mean(mean(combPower(betaLowerLimit:betaUpperLimit,end-epochsToAvg+1:end)'*smoothKernel(1,1)));
                        stFreq = round(Fc + incrFact(EXPcount) * Fi);
                        soundTone = sine_tone(Fsound ,1,stFreq);
                        sound(soundTone,Fsound);
                    end
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    
                    checkplot_time_2(handles,timeToPlot,datatoplot,freq,ch_meanRawPower); 
                    dataExpBegin = dataExpBegin+Fs;
%                     dataTemp = X(:,end);
                    ExptempData = X(:,end);
                    ExptimeTemp = timeToUse(end);
                    
                elseif(EXPcount==51) % whenever teh calibration has been done 
                    % All the previous variables should be returned to
                    % initial stage
                    ExptempData = [];
                    ExptimeTemp = [];
                    CombExpRawData = EXPdataTemp;
                    CombExpPowerData = EXPpowerTem;
                    EXPdataTemp = zeros(5,Fs*(calibrationDurationS+runtimeDurationS)); % returned back to the initial dataterm
                    EXPpowerTem = zeros(51,(calibrationDurationS+runtimeDurationS));  % returned back to initial powerterm
                    
                    %% Inserting the relaxation and sustainace quotient
                    
                    blPowerArray = mean(rawBlPower(alphaLowFreq:alphaHighFreq,3:10),2);
                    stPowerArray = mean(rawstpower(alphaLowFreq:alphaHighFreq,analysisRange),2);
                    changeArray = stPowerArray/mean(blPowerArray) - 1;
                    quot = 100*mean(changeArray);
                    fluct = std(stPowerArray)/mean(stPowerArray);
                    susqut = (int64(100*(1/fluct)));
                    % show a message box
                    msgbox(['Your relaxation quotient is ' num2str(quot) ' % and your sustenance quotient is ' num2str(susqut)], 'EEG Demo', 'help');
%                     set(h,'Position',[160 300 700 80]);
%                     ah = get( h, 'CurrentAxes' );
%                     ch = get( ah, 'Children' );
%                     set( ch, 'FontSize', 20 );
%                   EXPcount==1  
                    tagsave = [tag 'trial_' str_trialno 'ttype_' str_t_type];
                    save(['BF_ExData_' tagsave],'CombExpRawData','CombExpPowerData');              % save the data 
                    state = 0;                                                          % returing to the default state                       
                    tag =  [subjectname '_ses_'  sessionNo];   
                    
                end
                
                if(EXPcount==51)
                    EXPcount = 1;
                    EXPstart = 11;
                    combData = [];
                    combPower = [];
                    trialNo = trialNo+1;
                else
                    EXPcount = EXPcount+1; 
                end
                
                if(trialNo == (end_value+1))
                    disp('Session is succesfully completed');
                    state = 5; % Exit the experiment
                end
                
        elseif state == 5 % Exit the Experiment
            rda_close(sock);
            save 'alphacontrol.mat';
            clear all;
            break
        end

        drawnow;
        
    end
    

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
%% Callback functions

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



