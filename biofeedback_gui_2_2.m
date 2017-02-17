
% keeping a varibale count and using imagesc plot.
% important: this function calls the displayTFandPSDs_1.m for the ploting
% relevant graphs

% The subprogramme for the biofeedback_gui_2 to get the getrawdata right
% Update on 14th feb: AB: the get raw data is now correctly aquiring the
% data and calculating the powers in each frequency band

% 14th feb: AB: TOdays taks is to get the start and stop right using this
% programme only

% Subgoal is to get the 'start' right

function biofeedback_gui_2

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
    fullDisplayDurationS = 10;

    handles.fullDisplayDurationS = fullDisplayDurationS;

    trialNumber = 1;
    % Initializing the default variables 
    AlphaChans = [1 2 3 4 5];  % The chaneels from which the data is extracted
    AlphaMin = get(hAlphaMin,'String'); % Right now unused

    powerTemp = zeros(51,fullDisplayDurationS);
    
    while 1

    %   Collect data for 1 second    
    %     drawnow;                  % updates all the unprocessed callbacks  
        raw = getBRawData(AlphaChans); % function for aquiring one second of data
    %     drawnow;                 % updates the loop with the data  

    %     Get alpha Range
    %     Do time-frequency analysis to get PSD
    %     AB: Everything above can be done in a single function instead of
    %     passing the data from one to another. Get the data and get the psd
    %     also, but dont plot

        if state == 0 % Idle state
            timeStartS=0;
% %             powerTemp = zeros(size(raw.power,1),fullDisplayDurationS);
    %         pause(1);

        elseif state == 1 % Start
    %       Display PSD and T-F plot
    %       AB:  Also plot rawspectrum in each second

            timeToUse = timeStartS + timeValsS;
            timeStartS=timeStartS+sampleDurationS;
            
            %
%             timeforTF = 0:fullDisplayDurations;

           
    %         pause(1);

            
            powerTemp(:,timeStartS) = raw.meanRawPower;   
            raw.powerTemp = powerTemp;
            displayTFandPSDs_2_2(timeToUse,timeStartS,raw,handles); 
            
            if timeStartS==fullDisplayDurationS
                timeStartS=0;
                cla(hRawTrace);
                cla(hTF);
                powerTemp = zeros(size(raw.power,1),fullDisplayDurationS);
            end   
        elseif state == 2 % Stop
            timeStartS=0;
            cla(hRawTrace);
            cla(hTF);
            powerTemp = zeros(size(raw.power,1),fullDisplayDurationS);
%             powerTemp = zeros(51,fullDisplayDurationS);
    %         pause(1);

    %     elseif state == 3 % Calibrate
    %         if timeStartS<calibrationDurationS
    %         % Display PSD and T-F plot as before
    %         % Save PSD data in a larger array
    %         % compute alpha power
    %         
    %         elseif timeStartS==calibrationDurationS
    %             % compute the baseline values
    %             % display baseline in a separate
    %             % Save the entire calibarion data in a separate file
    %             timeStartS=timeStartS+sampleDurationS;
    %         end
    %         pause(1);
    %     elseif state == 4 % run Experiment
    %         disp('positive four');
    %         pause(1);

        elseif state == 5 % Exit the Experiment
            break
        end

        drawnow;
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



