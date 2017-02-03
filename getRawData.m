% Please add to the path common program before executing the function
% Function for getting one second of the data using tcp ip port

function getRawData(AlphaChans)

    %% Creating the cfg structure in which host and port name is specified

    cfg.host=getIPv4Address;
    cfg.port=(51244);

    %% If not specified, creating default cfg structure for the TCPIP connection

    cfg.host=getIPv4Address;
    cfg.port=(51244);
    if ~isfield(cfg, 'host'),               cfg.host = 'eeg002';                              end
    if ~isfield(cfg, 'port'),               cfg.port = 51244;                                 end % 51244 is for 32 bit, 51234 is for 16 bit
    if ~isfield(cfg, 'channel'),            cfg.channel = 'all';                              end
    if ~isfield(cfg, 'feedback'),           cfg.feedback = 'no';                              end
    if ~isfield(cfg, 'target'),             cfg.target = [];                                  end
    if ~isfield(cfg.target, 'datafile'),    cfg.target.datafile = 'buffer://localhost:1972';  end
    if ~isfield(cfg.target, 'dataformat'),  cfg.target.dataformat = [];                       end % default is to use autodetection of the output format
    if ~isfield(cfg.target, 'eventfile'),   cfg.target.eventfile = 'buffer://localhost:1972'; end
    if ~isfield(cfg.target, 'eventformat'), cfg.target.eventformat = [];                      end % default is to use autodetection of the output format

    %% Creating the TCPIP connection using the pnet function

    sock = pnet('tcpconnect', cfg.host, cfg.port);

    %% Getting the data and setting up the header information

    hdr = []; % header 

    while isempty(hdr)
    % read the message header
        msg       = [];
        msg.uid   = tcpread_new(sock, 16, 'uint8',1);
        msg.nSize = tcpread_new(sock, 1, 'int32',0);
        msg.nType = tcpread_new(sock, 1, 'int32',0);
    
        % read the message body
        switch msg.nType
            case 1
                % this is a message containing header details
                msg.nChannels         = tcpread_new(sock, 1, 'int32',0);
                msg.dSamplingInterval = tcpread_new(sock, 1, 'double',0);
                msg.dResolutions      = tcpread_new(sock, msg.nChannels, 'double',0);
                for i=1:msg.nChannels
                    msg.sChannelNames{i} = tcpread_new(sock, char(0), 'char',0);
                end

                % convert to a fieldtrip-like header
                hdr.nChans  = msg.nChannels;
                hdr.Fs      = 1/(msg.dSamplingInterval/1e6);
                hdr.label   = msg.sChannelNames;
                hdr.resolutions = msg.dResolutions;

                % determine the selection of channels to be transmitted
                cfg.channel = ft_channelselection(cfg.channel, hdr.label);
                chanindx = match_str(hdr.label, cfg.channel);

                % remember the original header details for the next iteration
                hdr.orig = msg;

            otherwise
                % skip unknown message types
                % error('unexpected message type from RDA (%d)', msg.nType);
        end
    end
    
        
    %% Getting information for the header
    Fs = hdr.Fs;
    % setting parameters for the chronux toolbox function mtspectrumc for analysing power spectrum of the signal
    params.tapers = [1 1]; % tapers [TW,K], K=<2TW-1
    params.pad = -1; % no padding
    params.Fs = Fs; % sampling frequency
    params.trialave = 0; % average over trials
    params.fpass = [0 Fs/10]; 

    %% Reading the data while teh condition is being satisfied

    while (count < totPass)
    % read the message header
        msg       = [];
        msg.uid   = tcpread_new(sock, 16, 'uint8',0);
        msg.nSize = tcpread_new(sock, 1, 'int32',0);
        msg.nType = tcpread_new(sock, 1, 'int32',0);

        % read the message body
        switch msg.nType
            case 2
                % this is a 16 bit integer data block
                msg.nChannels     = hdr.orig.nChannels;
                msg.nBlocks       = tcpread_new(sock, 1, 'int32',0);
                msg.nPoints       = tcpread_new(sock, 1, 'int32',0);
                %msg.nPoints       =hdr.Fs;
                msg.nMarkers      = tcpread_new(sock, 1, 'int32',0);
                msg.nData         = tcpread_new(sock, [msg.nChannels msg.nPoints], 'int16',0);
                for i=1:msg.nMarkers
                    msg.Markers(i).nSize      = tcpread_new(sock, 1, 'int32',0);
                    msg.Markers(i).nPosition  = tcpread_new(sock, 1, 'int32',0);
                    msg.Markers(i).nPoints    = tcpread_new(sock, 1, 'int32',0);
                    % msg.Markers(i).nPoints    =hdr.Fs;
                    msg.Markers(i).nChannel   = tcpread_new(sock, 1, 'int32',0);
                    msg.Markers(i).sTypeDesc  = tcpread_new(sock, char(0), 'char',0);
                end

            case 4
                % this is a 32 bit floating point data block
                msg.nChannels     = hdr.orig.nChannels;
                msg.nBlocks       = tcpread_new(sock, 1, 'int32',0);
                msg.nPoints       = tcpread_new(sock, 1, 'int32',0);
                % msg.nPoints       =hdr.Fs;
                msg.nMarkers      = tcpread_new(sock, 1, 'int32',0);
                msg.fData         = tcpread_new(sock, [msg.nChannels msg.nPoints], 'single',0);
                for i=1:msg.nMarkers
                    msg.Markers(i).nSize      = tcpread_new(sock, 1, 'int32',0);
                    msg.Markers(i).nPosition  = tcpread_new(sock, 1, 'int32',0);
                    msg.Markers(i).nPoints    = tcpread_new(sock, 1, 'int32',0);
                    %msg.Markers(i).nPoints   =hdr.Fs;
                    msg.Markers(i).nChannel   = tcpread_new(sock, 1, 'int32',0);
                    msg.Markers(i).sTypeDesc  = tcpread_new(sock, char(0), 'char',0);
                end

            case 3
                % acquisition has stopped
                break

            otherwise
                % ignore all other message types
        end    
        %%
        %%    % convert the RDA message into data and/or events
        dat   = []; 
        if msg.nType==2 && msg.nPoints>0
            % FIXME should I apply the calibration here?
            dat = msg.nData(chanindx,:);
        end

        if msg.nType==4 && msg.nPoints>0
            % FIXME should I apply the calibration here?
            dat = msg.fData(chanindx,:);
        end

        if (msg.nType==2 || msg.nType==4) && msg.nMarkers>0
            % FIXME convert the message to events
        end

        if ~isempty(dat)
            X = [X dat];
            [~,col]= size(X); % getting information about about the size of the rawdata X

            if((col == Fs))

                rawTrace = [rawTrace X(AlphaChans,:)];  % plotting EEG Trace of the channels
                if count>0; rawTrace(:,1:size(X,2)) = []; end;
                subplot(handles.rawTraceAlpha); plot(1:Fs,rawTrace);
                drawnow;

                count = count + 1;

                nextdat= single(X);
                gain = single(hdr.resolutions');
                gain = repmat(gain,1,size(nextdat,2));
                nextdat = nextdat.*gain;
                nextdat=nextdat(AlphaChans,:);
                rawdata = [rawdata nextdat];
                X=[];
               [power(count,:,:),freq] = mtspectrumc(nextdat',params);                
                  
             end
        end
    end
end