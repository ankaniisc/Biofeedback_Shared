
% using concatenation, checking if there is any dataloss


function rawdata = troubleshooting_data_aquire_3

%     timetoaquire = 5;
%     rawdata = zeros(5,2500);
    Fs = 500;
    Sstart = 1;
    sampleDurationS = 1;
    timeValsS = 0:1/Fs:sampleDurationS-1/Fs;
    timeStartS = 0;
    fullDisplayDurationS = 6;
    rawdata =[];
%     hf = plot
    
    for i = 1:fullDisplayDurationS
        data = getBRawData_troubleshooting();        
%         Sstop = ((Sstart+Fs)-1);
%         rawdata(:,Sstart:Sstop) = data;
%         Sstart = Sstart+Fs;
        rawdata = [rawdata data];
%         timeToUse = timeStartS + timeValsS;
%         timeStartS=timeStartS+sampleDurationS;
%         sampleDurationS = i;
%         timeToUse = 0:1/Fs:sampleDurationS-1/Fs;
%         checkplot_time(timeToUse,rawdata);
    end
end
