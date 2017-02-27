


function rawdata = troubleshooting_data_aquire

%     timetoaquire = 5;
    rawdata = zeros(5,2500);
    Fs = 500;
    Sstart = 1;
    sampleDurationS = 1;
    timeValsS = 0:1/Fs:sampleDurationS-1/Fs;
    timeStartS = 0;
    fullDisplayDurationS = 5;
    
    for i = 1:fullDisplayDurationS
        data = getBRawData_troubleshooting();        
        Sstop = ((Sstart+Fs)-1);
        rawdata(:,Sstart:Sstop) = data;
        Sstart = Sstart+Fs;
        
        timeToUse = timeStartS + timeValsS;
        timeStartS=timeStartS+sampleDurationS;
        checkplot_time(timeToUse,data);
    end
end

% Fs = 500;
% sampleDurationS = 5;
% timeValsS = 0:1/Fs:sampleDurationS-1/Fs;
% datatoplot = rawdata(2,:);
% plot(timeValsS,datatoplot);