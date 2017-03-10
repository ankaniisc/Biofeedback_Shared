
function checkplot_time_2(handles,timeToPlot,datatoplot,freq,powertoplot)

     hf1 = handles.hRawTrace;
     hf2 = handles.hRawTrace_2;
     hf3 = handles.hTF;
    calibrationDurationS = handles.calibrationDurationS ;
    runtimeDurationS  = handles.runtimeDurationS;
    totalTime = calibrationDurationS + runtimeDurationS;
%     blData = BL.blData;
%     blPower = BL.blPower;
    
    % The idea is in the first count concatenate the bldata and the first
    % second of the data
    
%     if (EXPcount == 1)
%       % concatenate the bldata and the first
%       % second of the data
%       Fs = 500;
%       
      
    datatoplot_1 = mean(datatoplot,1);
    datatoplot = mean(datatoplot,1);
    plot(hf1,timeToPlot,datatoplot_1,'k');
    plot(hf2,timeToPlot,datatoplot,'k');
    xlim(hf1,[0 totalTime]);
    xlim(hf2,[(timeToPlot(end)-5.998) (timeToPlot(end)+ 0.0020)]); 
    
    
    hold(hf1,'on');

    axes(hf3);
    hold(hf3,'on');
    if size(powertoplot)>1        
        pcolor(1:size(powertoplot,2), freq, powertoplot);
%         colorbar(hf3);
        colormap jet; shading interp;
        caxis(hf3,[-2 2]);
        xlim(hf3,[1 totalTime]); 
        x = 1:totalTime;
        y1 = ones(1,totalTime)*8;
        y2 = ones(1,totalTime)*13;
      
   end
       plot(x,y1,'--k');
       plot(x,y2,'--k');
       title('Time Frequency Plot')
       xlabel(hf3, 'Time (s)'); ylabel(hf3, 'Frequency');
       drawnow;
      
end