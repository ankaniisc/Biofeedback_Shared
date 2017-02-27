function hdr = rda_header(cfg,sock)

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
                hdr.chanindx        = match_str(hdr.label, cfg.channel);

                % remember the original header details for the next iteration
                hdr.orig        = msg;

            otherwise
                % skip unknown message types
                % error('unexpected message type from RDA (%d)', msg.nType);
        end
    end
end
    