Fs = 500;
sampleDurationS = 6;
timeValsS = 0:1/Fs:sampleDurationS-1/Fs;
datatoplot = rawdata(2,:);
plot(timeValsS,datatoplot,'.');