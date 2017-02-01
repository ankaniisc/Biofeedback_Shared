function contEEG_Callback(object_handle,event,hStop,hCalibrate,hRun)
        %% planning to pass on the arguments here in this function        
        
        while 1
%             AlphaChans = str2num(get(hPoolElecAlpha,'String'));
%     %         BLPeriod = str2num(get(hBLPeriod,'String'));
%             handles.hBLPeriod = hBLPeriod;
%             handles.hRunTime = hRunTime;
%             handles.AlphaChans = AlphaChans;

          monitorFlag = get(hStart,'Value');
          if monitorFlag == get(hStart,'Max'); 
          state = 1; end;

          stopFlag = get(hStop,'Value');
          if stopFlag == get(hStart,'Max');
              disp(stopFlag);
              state = 2;
          end;

          calibrateFlag = get(hCalibrate,'Value');
          if calibrateFlag == get(hCalibrate,'Max'); 
          state = 3;end;

          startFlag = get(hRun,'Value');
          if startFlag == get(hRun,'Max'); 
          state = 4;end; 
          if state ==2
              break
          end
          state = contEEG(state,hStart,hStop,hCalibrate,hRun,handles);
        end
    end