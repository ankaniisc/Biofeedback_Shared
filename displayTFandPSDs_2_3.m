
% The aim of the programme is by getting the timetouse and rawdata and the
% calculated power data, plot all the necessary plots

function displayTFandPSDs_2_2(timeToUse,timeStartS,raw,handles)

    t = timeToUse;
    count = timeStartS;
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
    meanRawPower = raw.powerTemp;
%     A=A(:,any(A))
    meanRawPower = meanRawPower(:,any(meanRawPower));
    powertoplot = meanRawPower; 
    
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
%     t = 1:5;
%     imagesc(powertoplot);
%     set(hTF,'Ydir','Normal');
%     y = size(rawfreq,2);
%     powerF;
    
    if size(powertoplot)>1
        
        pcolor(1:size(powertoplot,2), rawFreq, powertoplot);
        colormap jet; shading interp;
        hold(hTF,'on');
        x = 1:fullDisplayDurationS;
        y1 = ones(1,fullDisplayDurationS)*8;
        y2 = ones(1,fullDisplayDurationS)*13;
        plot(x,y1,'--k');
        plot(x,y2,'--k');
%         plot(1:size(dPower,1),alphaUpperLimit,'k-'); hold on;
        % plot(1:size(dPower,1),alphaLowerLimit,'k'); hold off;
        title('Time Frequency Plot')
        xlabel(handles.hTF, 'Time (s)'); ylabel(handles.hTF, 'Frequency');
    %     caxis(handles.hTF,[-10 10]);
        xlim(handles.hTF,[1 fullDisplayDurationS]);
    %     ylim(handles.hTF, [0 51]); 

        drawnow;
    end
    
end