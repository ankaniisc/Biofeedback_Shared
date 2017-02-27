
% 5:03 PM: Remodifying the data aquisition code just onky to aquire data as
% it is (means the sample no and teh form which teh recoder has been
% sending
% saving 

% Also removed any unncessary lines for checking the marker infromation
% which I dont currently need and also removed the message data format 2 
% as beacuse we are logging int o the rda server iusingf the port id which
% is meant for 32  bit data format, keeping the evebnts meant for 16 bit
% data format is unnessary.

    
function data = getBRawData_troubleshooting_3() % calling the with the alphachans no

    %% Creating the cfg structure in which host and port name is specified
%     pnet('closeall') % closing all the previously opens pnets connections

%     cfg.host=getIPv4Address;
%     cfg.host = '10.120.10.137';
    cfg.host = '127.0.0.1';
    cfg.port=(51244);           % this is login port for  32 bit IEEE floating point format code 

    %% If not specified, creating default cfg structure for the TCPIP connection

%     cfg.host=getIPv4Address; % host server is this port
    cfg.port=(51244); % from this port the data will aquired
    % defining th default parameters if not already exist    
    if ~isfield(cfg, 'host'),               cfg.host = 'eeg002';                              end
    if ~isfield(cfg, 'port'),               cfg.port = 51244;                                 end % 51244 is for 32 bit, 51234 is for 16 bit
    if ~isfield(cfg, 'channel'),            cfg.channel = 'all';                              end
    if ~isfield(cfg, 'feedback'),           cfg.feedback = 'no';                              end
    if ~isfield(cfg, 'target'),             cfg.target = [];                                  end
    if ~isfield(cfg.target, 'datafile'),    cfg.target.datafile = 'buffer://localhost:1972';  end
    if ~isfield(cfg.target, 'dataformat'),  cfg.target.dataformat = [];                       end % default is to use autodetection of the output format
    if ~isfield(cfg.target, 'eventfile'),   cfg.target.eventfile = 'buffer://localhost:1972'; end
    if ~isfield(cfg.target, 'eventformat'), cfg.target.eventformat = [];                      end % default is to use autodetection of the output format

    %% Creating the TCPIP link (its like a making a channel)  using the host and port address

    sock = pnet('tcpconnect', cfg.host, cfg.port);

    %% Getting the data and setting up the header information

    hdr = []; % header 

    while isempty(hdr)  % run when there is no header information preceeding the data 
    % read the message header
        msg       = [];
        msg.uid   = tcpread_new(sock, 16, 'uint8',1);
        msg.nSize = tcpread_new(sock, 1, 'int32',0);
        msg.nType = tcpread_new(sock, 1, 'int32',0);
    
        % read the message body
        switch msg.nType
            case 1
                % this is a message containing header details
                msg.nChannels            = tcpread_new(sock, 1, 'int32',0);
                msg.dSamplingInterval    = tcpread_new(sock, 1, 'double',0);
                msg.dResolutions         = tcpread_new(sock, msg.nChannels, 'double',0);
                for i=1:msg.nChannels
                    msg.sChannelNames{i} = tcpread_new(sock, char(0), 'char',0);
                end

                % convert to a fieldtrip-like header
                hdr.nChans      = msg.nChannels;
                hdr.Fs          = 1/(msg.dSamplingInterval/1e6);
                hdr.label       = msg.sChannelNames;
                hdr.resolutions = msg.dResolutions;

                % determine the selection of channels to be transmitted
                cfg.channel     = ft_channelselection(cfg.channel, hdr.label);
                chanindx        = match_str(hdr.label, cfg.channel);

                % remember the original header details for the next iteration
                hdr.orig        = msg;

            otherwise
                % skip unknown message types
                % error('unexpected message type from RDA (%d)', msg.nType);
        end
    end
    
    % if there exist the header information the get the necessary
    % information from the header itself and proceed
    
    %% Getting information for the header
    Fs = hdr.Fs;  % getting the sampling frquency of the data
    % setting parameters for the chronux toolbox function mtspectrumc for analysing power spectrum of the signal
    params.tapers   = [1 1]; % tapers [TW,K], K=<2TW-1
    params.pad      = -1; % no padding
    params.Fs       = Fs; % sampling frequency
    params.trialave = 0; % average over trials
    params.fpass    = [0 Fs/10]; % taking only the fist bandwidth of the data
    
    % that being said if the sampling frquency is 500 hz then taking only
    % the first 0 to 50 Hz frequency for the analysis

    %% Reading the data while the condition is being satisfied
    % but here as no condition is necessary commenting the logical
    % statement 
    % the only condition in this fucntion should be to proceed only one
    % second data has been aquired

    % Initializing paramneter for the while condition
    
%     col = 0;
    X = [];
    
%     while (col < Fs)
    for i = 1:100
    % read the message header
        msg       = [];
        msg.uid   = tcpread_new(sock, 16, 'uint8',0);
        msg.nSize = tcpread_new(sock, 1, 'int32',0);
        msg.nType = tcpread_new(sock, 1, 'int32',0);

        % read the message body
        switch msg.nType
%             case 2
%                 % this is a 16 bit integer data block
%                 msg.nChannels     = hdr.orig.nChannels;
%                 msg.nBlocks       = tcpread_new(sock, 1, 'int32',0);
%                 msg.nPoints       = tcpread_new(sock, 1, 'int32',0);
%                 %msg.nPoints       =hdr.Fs;
%                 msg.nMarkers      = tcpread_new(sock, 1, 'int32',0);
%                 msg.nData         = tcpread_new(sock, [msg.nChannels msg.nPoints], 'int16',0);
%                 for i=1:msg.nMarkers
%                     msg.Markers(i).nSize      = tcpread_new(sock, 1, 'int32',0);
%                     msg.Markers(i).nPosition  = tcpread_new(sock, 1, 'int32',0);
%                     msg.Markers(i).nPoints    = tcpread_new(sock, 1, 'int32',0);
%                     % msg.Markers(i).nPoints    =hdr.Fs;
%                     msg.Markers(i).nChannel   = tcpread_new(sock, 1, 'int32',0);
%                     msg.Markers(i).sTypeDesc  = tcpread_new(sock, char(0), 'char',0);
%                 end

            case 4
                % this is a 32 bit floating point data block
                msg.nChannels     = hdr.orig.nChannels;
                msg.nBlocks       = tcpread_new(sock, 1, 'int32',0); % this we want to check fo rany potential data loss
                                                                           % as it specifies the curretn block number 
                                                                           % since teh start of monitoring
                msg.nPoints       = tcpread_new(sock, 1, 'int32',0);
                % msg.nPoints       =hdr.Fs;
%                 msg.nMarkers      = tcpread_new(sock, 1, 'int32',0);
                msg.fData         = tcpread_new(sock, [msg.nChannels msg.nPoints], 'single',0);
%                 for i=1:msg.nMarkers
%                     msg.Markers(i).nSize      = tcpread_new(sock, 1, 'int32',0);
%                     msg.Markers(i).nPosition  = tcpread_new(sock, 1, 'int32',0);
%                     msg.Markers(i).nPoints    = tcpread_new(sock, 1, 'int32',0);
%                     %msg.Markers(i).nPoints   =hdr.Fs;
%                     msg.Markers(i).nChannel   = tcpread_new(sock, 1, 'int32',0);
%                     msg.Markers(i).sTypeDesc  = tcpread_new(sock, char(0), 'char',0);
%                 end

            case 3
                display('acquisition has stopped');
                break

            otherwise
                % ignore all other message types
        end    
        %%
        %% Converting the data from the RDA message into data 
        dat     = []; % the main variable inside which the data will be stored
        
%         if msg.nType==2 && msg.nPoints>0
%             % FIXME should I apply the calibration here?
%             dat = msg.nData(chanindx,:);
%         end

        if msg.nType==4 && msg.nPoints>0
            % FIXME should I apply the calibration here?
            dat = msg.fData(chanindx,:);
        end

%         if (msg.nType==2 || msg.nType==4) && msg.nMarkers>0
%             % FIXME convert the message to events
%         end

        if ~isempty(dat)
             X  = [X dat];  
%             [~,col]= size(X); % getting information about about the size of the rawdata X

%             if((col == Fs)) %% proceed only if the dta size matches 1 second of the data
                
                % commenting the code for plotting the rawdata which i
                % would plot in the main programme

%                 rawTrace = [rawTrace X(AlphaChans,:)];  % plotting EEG Trace of the channels
%                 if count>0; rawTrace(:,1:size(X,2)) = []; end;
%                 subplot(handles.rawTraceAlpha); plot(1:Fs,rawTrace);
%                 drawnow;
%                 count = count + 1;

%                 nextdat= single(X);  % Now the next variable where the data would be passed on is the nextdat 
%                 gain = single(hdr.resolutions');
%                 gain = repmat(gain,1,size(nextdat,2));
%                 nextdat = nextdat.*gain; % 
                
                
%                 nextdat=nextdat(AlphaChans,:);
%                 rawdata = [rawdata nextdat]; commenting the rawdata               
                 % AB: x can be restored into the initial point where the dat will be stored once more
%                [power(count,:,:),freq] = mtspectrumc(nextdat',params);  
%                 [power,freq] = mtspectrumc(nextdat',params);
%                  meanRawPower = mean(power,2);
%                 X=[];
                
                 
%              end
        end
    end 
    
        % Closing the port when exverything is done
      pnet(sock,'close'); % Closing the port after one second data has been aquired
    
    % Creating a structure where the datas would be kept upon
    % Its like a packet which would be opended in anotehr fucntion
%     data = double(nextdat);
      data = X ;
%     raw.power = power;
%     raw.freq = freq;
%     raw.meanRawPower = meanRawPower;
end