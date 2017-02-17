
% The aim of the programme is by getting the timetouse and rawdata and the
% calculated power data, plot all the necessary plots

function displayTFandPSDs_2(timeToUse,raw,powerTemp,handles)

    t = timeToUse;
    % unpacking the rawtrace and tf from the handles
    hRawTrace = handles.hRawTrace;
    hTF       = handles.hTF; 

    % unpacking the raw 
    % for 
    fullDisplayDurationS = handles.fullDisplayDurationS;
    rawdata = raw.data;
    rawPower = raw.power; % 1 second rawpower dat for all the frequencies
    rawFreq  = raw.freq;
    meanRawdataAlChan = mean(rawdata);
    meanRawPower = mean(rawPower,2);
    % Now we have the data, time, and the figure handle. Basically everything
    % we need. Now just plot.

    %% plotting
    
    % rawtrace
    axes(hRawTrace);

    plot(t,meanRawdataAlChan,'k'); 
    xlim([0 fullDisplayDurationS]);
    hold(hRawTrace,'on');

    % tfplot
    % right now just do the tf plot
    axes(hTF);
    t = 1:5;
%     y = size(rawfreq,2);
%     powerF;
    
    pcolor(1:size(powerTemp,2), rawFreq, powerTemp);
%     hold on;
    colormap jet; shading interp;
    hold(hTF,'on');
    % plot(1:size(dPower,1),alphaUpperLimit,'k'); hold on;
    % plot(1:size(dPower,1),alphaLowerLimit,'k'); hold off;
    % shading interp;
    title('Time Frequency Plot')
    xlabel(handles.hTF, 'Time (s)'); ylabel(handles.hTF, 'Frequency');
%     caxis(handles.hTF,[-10 10]);
    xlim(handles.hTF,[1 50]);
    ylim(handles.hTF, [0 51]); 

    drawnow;

    
end