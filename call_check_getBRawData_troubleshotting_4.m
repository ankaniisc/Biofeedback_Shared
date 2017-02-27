
rawdata = [];
SLN     = [];

for i = 1:5
    tic
    [data,SQN] = getBRawData_troubleshooting_4();
    toc
    rawdata = [rawdata data];
    SLN     = [SLN SQN];
%     plot(data);
       
end

save('bfrawdata','data','SQN');