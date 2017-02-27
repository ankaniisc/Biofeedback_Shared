
function checkplot_time_2(EXPcount,handles,timeToPlot,datatoplot,freq,meanRawPower,BL)

    hf1 = handles.hRawTrace;
    hf2 = handles.hTF;
    runtimeDurationS  = handles.runtimeDurationS;
    blData = BL.blData;
    blPower = BL.blPower;
    
    % The idea is in the first count concatenate the bldata and the first
    % second of the data
    
%     if (EXPcount == 1)
      % concatenate the bldata and the first
      % second of the data
      
      
    
    datatoplot = data(2,:);
    plot(hf1,timetouse,datatoplot,'k');
    xlim(hf1,[1 runtimeDurationS]); 
    hold(hf1,'on');

    axes(hf2);
    hold(hf2,'on');
    if size(powertoplot)>1        
        pcolor(1:size(powertoplot,2), freq, powertoplot);
        colormap jet; shading interp;
        xlim(hf2,[1 fullDisplayDurationS]); 
        x = 1:fullDisplayDurationS;
        y1 = ones(1,fullDisplayDurationS)*8;
        y2 = ones(1,fullDisplayDurationS)*13;
      
   end
       plot(x,y1,'--k');
       plot(x,y2,'--k');
       title('Time Frequency Plot')
       xlabel(hf2, 'Time (s)'); ylabel(hf2, 'Frequency');
       drawnow;
      
end