
function rda_close(sock)
    pnet(sock,'close');
    pnet('closeall')
%     close all;
    clear all;
     % Display a message
    disp('connection closed');
end