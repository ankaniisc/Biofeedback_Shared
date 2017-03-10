
function checkplot_time(state,handles,timetouse,data,freq,powertoplot)

    hf1 = handles.hRawTrace;
    hf2 = handles.hRawTrace_2;
    hf3 = handles.hTF;
    fullDisplayDurationS = handles.fullDisplayDurationS;
    calibrationDurationS = handles.calibrationDurationS;
    datatoplot_1 = mean(data,1);
    datatoplot = mean(data,1);
    timetoplot = timetouse ;
    plot(hf1,timetoplot,datatoplot_1,'k');
    xlim(hf1,[0 fullDisplayDurationS]);
    plot(hf2,timetoplot,datatoplot,'k');
    
%     if state == 1
        if timetouse>10
            xlim(hf2,[(timetoplot(end)-5.998) (timetoplot(end)+ 0.0020)]);
        else
            xlim(hf2,[0 10]);
        end
% %     elseif state == 3
%         xlim(hf1,[0 calibrationDurationS]);
%     end 
    hold(hf1,'on'); hold(hf2,'on');

    axes(hf3);
    hold(hf3,'on');
    if size(powertoplot)>1  
%         clims = [-20 20];
%         imagesc((1:size(powertoplot,2))-0.5, freq, powertoplot,clims);
        pcolor((1:size(powertoplot,2)), freq, powertoplot);
        colormap jet; shading interp;
        caxis(hf3,[-10 10]);
        
%         colorbar(hf2);
%         imagesc( freq, powertoplot);
        
%         colormap jet; shading interp;
%         x = 1:fullDisplayDurationS;
%         y1 = ones(1,fullDisplayDurationS)*8;
%         y2 = ones(1,fullDisplayDurationS)*13;
       
    %   caxis(handles.hTF,[-10 10]);
   if state == 1
        xlim(hf3,[1 fullDisplayDurationS]); 
        ylim(hf3,[0 50]);
        x = 1:60;
        y1 = ones(1,60)*8;
        y2 = ones(1,60)*13;
   else if state == 3
        xlim(hf3,[1 fullDisplayDurationS]);
        ylim(hf3,[0 50]);
        x = 1:60;
        y1 = ones(1,60)*8;
        y2 = ones(1,60)*13;
       end        
   end
       plot(x,y1,'--k');
       plot(x,y2,'--k');
       title('Time Frequency Plot')
       xlabel(hf2, 'Time (s)'); ylabel(hf2, 'Frequency');
    drawnow;
    end
end