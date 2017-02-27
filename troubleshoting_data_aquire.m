

timetoaquire = 5;
rawdata = zeros(5,2500);

for i = 1:timetoaquire
    data = getBRawData_troubleshooting()
    rawdata = [rawdata data];
end