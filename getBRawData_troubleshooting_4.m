
% AB: 23rd Feb: 5.33 PM: This new code is meant to be final troubleshotting code for the
% Data loss. Hence removing any unnessary lines.

% AB: 23rd Feb: 5:03 PM: Remodifying the data aquisition code just only to aquire data as
% It is (means the sample no and teh form which teh recoder has been
% Sending
% Saving 
% For more updates on the functions see the below
  
function [data,SQN] = getBRawData_troubleshooting_4() % Calling the with the alphachans no

    %% Creating the cfg structure in which host and port name is specified
    cfg.host = '127.0.0.1';     % the local host server address ip reserevd meant for loopback ip
    cfg.port =(51244);           % this is login port for  32 bit IEEE floating point format code 

    %% If not specified, creating default cfg structure for the TCPIP connection
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

    %% Creating the TCPIP link or socket (its like a making a channel)  using the host and port address
    sock = pnet('tcpconnect', cfg.host, cfg.port);

    %% Getting the data and setting up the header information
    hdr  = []; % initializing header 

    while isempty(hdr)  % run when there is no header information preceeding the data 
    % read the RDA message header
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
    
   
    %% Getting information from the header
    Fs = hdr.Fs;  % getting the sampling frquency of the data   
    resolutions = hdr.resolutions;
    X = []; 
    SQN = [];
    col = 0;
%     for i = 1:1000
    while (col < Fs) % here check how brain people are doing/ solving the problem
    % read the message header
        msg       = [];
        msg.uid   = tcpread_new(sock, 16, 'uint8',0);
        msg.nSize = tcpread_new(sock, 1, 'int32',0);
        msg.nType = tcpread_new(sock, 1, 'int32',0);

        % read the message body
        switch msg.nType
            case 4
                % this is a 32 bit floating point data block
                msg.nChannels     = hdr.orig.nChannels;
                msg.nBlocks       = tcpread_new(sock, 1, 'int32',0);    % this we want to check fo rany potential data loss
                                                                           % as it specifies the curretn block number 
                                                                           % since the start of monitoring
                msg.nPoints       = tcpread_new(sock, 1, 'int32',0);
                msg.fData         = tcpread_new(sock, [msg.nChannels msg.nPoints], 'single',0);
                msg.nMarkers      = tcpread_new(sock, 1, 'int32',0);
            case 3
                display('acquisition has stopped');
                break

            otherwise
                % ignore all other message types
        end    

        %% Converting the data from the RDA message into data 
        dat     = []; % the main variable inside which the data will be stored
        seqno   = [];
        if msg.nType == 4 && msg.nPoints > 0
            % FIXME should I apply the calibration here?
            dat     = msg.fData(chanindx,:);
            seqno   = msg.nBlocks;
        end

        if ~isempty(dat) % if the dat is nonemepty then
             X  = [X dat]; 
             SQN = [SQN seqno];
            [~,col]= size(X);
        end
               
    end 
    
      % Closing the port when everything is done
      pnet(sock,'close'); % Closing the port specified durations of the data have been collected
      data = double(X)*resolutions(1,1);  % Converting to the double default data format   
      
end


%% Additional notes for using the function:

% Also removed any unncessary lines for checking the marker infromation
% which I dont currently need; and also removed the message data format 2 
% as beacuse we are logging int the rda server using the port id which
% is meant for 32  bit data format, keeping the evebnts meant for 16 bit
% data format is unnessary.