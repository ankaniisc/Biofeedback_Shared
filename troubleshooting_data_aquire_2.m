


function  troubleshooting_data_aquire_2(rawdata)

%     timetoaquire = 5;
    rawdata = rawdata;
    Fs = 500;
    Sstart = 1;
    sampleDurationS = 1;
    timeValsS = 0:1/Fs:sampleDurationS-1/Fs;
    timeStartS = 0;
    fullDisplayDurationS = 5;
    
    for i = 1:fullDisplayDurationS
%         data = getBRawData_troubleshooting();        
        Sstop = ((Sstart+Fs)-1);
        data = rawdata(:,Sstart:Sstop); 
        Sstart = Sstart+Fs;
        
        timeToUse = timeStartS + timeValsS;
        timeStartS=timeStartS+sampleDurationS;
        checkplot_time(timeToUse,data);
    end
end

