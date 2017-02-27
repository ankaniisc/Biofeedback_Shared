
function checkplot_time(state,handles,timetouse,data,freq,powertoplot)

    hf1 = handles.hRawTrace;
    hf2 = handles.hTF;
    fullDisplayDurationS = handles.fullDisplayDurationS;
    calibrationDurationS = handles.calibrationDurationS;
    datatoplot = data(2,:);
    plot(hf1,timetouse,datatoplot,'k');
%     xlim(hf1,[0 fullDisplayDurationS]);
    if state == 1
        xlim(hf1,[1 fullDisplayDurationS]); 
    elseif state == 3
        xlim(hf1,[1 calibrationDurationS]);
    end 
    hold(hf1,'on');

    axes(hf2);
    hold(hf2,'on');
    if size(powertoplot)>1        
        pcolor(1:size(powertoplot,2), freq, powertoplot);
        colormap jet; shading interp;
%         x = 1:fullDisplayDurationS;
%         y1 = ones(1,fullDisplayDurationS)*8;
%         y2 = ones(1,fullDisplayDurationS)*13;
       
    %   caxis(handles.hTF,[-10 10]);
   if state == 1
        xlim(hf2,[1 fullDisplayDurationS]); 
        x = 1:fullDisplayDurationS;
        y1 = ones(1,fullDisplayDurationS)*8;
        y2 = ones(1,fullDisplayDurationS)*13;
   else if state == 3
        xlim(hf2,[1 calibrationDurationS]);
        x = 1:calibrationDurationS;
        y1 = ones(1,calibrationDurationS)*8;
        y2 = ones(1,calibrationDurationS)*13;
       end        
   end
       plot(x,y1,'--k');
       plot(x,y2,'--k');
       title('Time Frequency Plot')
       xlabel(hf2, 'Time (s)'); ylabel(hf2, 'Frequency');
    drawnow;
end