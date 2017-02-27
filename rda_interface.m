
% Complete rda interface

[cfg,sock] = rda_open;               % rda_open would pass the sokect information
hdr = rda_header(cfg,sock);          % rda_header would pass the header details
data = [];
SLN  = [];

% Initializing the variables for plotting
fullDisplayDurationS = 5;
sampleDurationS = 1;
Fs = hdr.Fs;
timeValsS = 0:1/Fs:sampleDurationS-1/Fs;
timeStartS = 0;
dataTemp  = [];
timeTemp  = [];
powerTemp = zeros(51,fullDisplayDurationS);

for i = 1:fullDisplayDurationS       
    [raw, SQN] = rda_message(sock,hdr);    % reading rda message
    X = raw.data;
    
    timeToUse = timeStartS + timeValsS;
    timeToPlot = [timeTemp timeToUse];
    
    datatoplot = [dataTemp X];
    
    timeStartS=timeStartS+sampleDurationS;  
    
    powerTemp(:,timeStartS) = raw.meanPower;   
    meanRawPower = powerTemp;
    meanRawPower = meanRawPower(:,any(meanRawPower));
    freq = raw.freq;
    checkplot_time(timeToPlot,datatoplot,freq,meanRawPower,fullDisplayDurationS);    
    
    dataTemp = X(:,end);
    timeTemp = timeToUse(end);
    
    SLN  = [SLN SQN];
    data = [data X];
    
      
end
rda_close(sock);                     % closing the socket when done
disp(unique(diff(SQN)));                    % display uin
save('ardadata','X','SLN');