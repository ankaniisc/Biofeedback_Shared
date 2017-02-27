% AB : 7.30 PM 23rd Feb
% Function written 

function check_getBRawData_troubleshotting_4

%     timetoaquire = 5;
%     rawdata = rawdata;
    Fs = 500;
    Sstart = 1;
    sampleDurationS = 1;
    timeValsS = 0:1/Fs:sampleDurationS-1/Fs;
    timeStartS = 0;
    fullDisplayDurationS = 5;
    
    for i = 1:fullDisplayDurationS
        rawdata = getBRawData_troubleshooting_4();        
        Sstop = ((Sstart+Fs)-1);
%         data = rawdata(:,Sstart:Sstop); 
        data = rawdata;
        Sstart = Sstart+Fs;        
        timeToUse = timeStartS + timeValsS;
        timeStartS=timeStartS+sampleDurationS;
        checkplot_time(timeToUse,data);
    end
end
    

