
function [cfg,sock] = rda_open
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
end
