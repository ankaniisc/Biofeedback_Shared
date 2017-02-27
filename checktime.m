        
%         tic 
%         data = getBRawData_troubleshooting_4();
%         toc

tic
A = rand(12000, 4400);
B = rand(12000, 4400);
toc
tic
C = A'.*B';
toc


% t = zeros(1,100);
% for n = 1:100
%     A = rand(n,n);
%     b = rand(n,1);
%     tic;
%     x = A\b;
%     t(n) = toc;
%     disp(t(n));
% end
% plot(t)