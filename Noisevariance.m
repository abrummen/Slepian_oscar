%first for hour 1 of every day extract the info and 
%For dates 07/01/2016- 10/24/2016, 01/01/2017 - 02/28/2017
%

YYYY = 2016;

cmp = ['x','y','z'];
%postt = 59*60 + 58;
%l = 1;
l = 1;
%m = 1;
m = 1;
n = 0;


v1 = zeros(31*2+30+24,24*3);
% v2 = zeros(31*2+30+24,24*3);
% v3 = zeros(31*2+30+24,24*3);
% v4 = zeros(31*2+28,24*3);
% v5 = zeros(31*2+28,24*3);
% v6 = zeros(31*2+28,24*3);


for i = 1:3
    for mo = 7:10
        if mo == 9
            for dd = 1:30
                for HH = 00:23
                    yyyymoddHHMMSS = sprintf('%02d%02d%02d%02d0001',YYYY,mo,dd,HH);
                    [segmentdecon] = mcmatcom(yyyymoddHHMMSS,1,3598,cmp(i));
                    v1(m,l + 24*n) = var(segmentdecon);
                    l = l + 1
                    
                end
                m = m + 1
                l = 1
                
            end
        elseif mo == 10
            for dd = 01:24
                for HH = 00:23
                    yyyymoddHHMMSS = sprintf('%02d%02d%02d%02d0001',YYYY,mo,dd,HH);
                    [segmentdecon] = mcmatcom(yyyymoddHHMMSS,1,3598,cmp(i));
                    v1(m,l + 24*n) = var(segmentdecon);
                    l = l + 1
                    
                end
                m = m + 1
                l = 1
                
             end
        else 
            for dd = 01:31
                for HH = 00:23
                    yyyymoddHHMMSS = sprintf('%02d%02d%02d%02d0001',YYYY,mo,dd,HH);
                    [segmentdecon] = mcmatcom(yyyymoddHHMMSS,1,3598,cmp(i));
                    v1(m,l + 24*n) = var(segmentdecon);
                    l = l + 1
                    
                end
                m = m + 1
                l = 1
                
            end
        end
    end
    n = n + 1;
    m = 1;
end

% YYYY = 2017;
% l = 1;
% m = 1;
% n = 0;
% 
% for i = 1:3
%     for mo = 1:3
%         if mo == 2
%             for dd = 1:28
%                 for HH = 00:23
%                     yyyymoddHHMMSS = sprintf('%02d%02d%02d%02d0001',YYYY,mo,dd,HH);
%                     [segmentdecon] = mcmatcom(yyyymoddHHMMSS,1,3598,cmp(i));
%                     v4(m,l + 24*n) = var(segmentdecon);
%                     l = l + 1
%                     
%                 end
%                 m = m + 1
%                 l = 1
%                 
%             end
% 
%         else 
%             for dd = 01:31
%                 for HH = 00:23
%                     yyyymoddHHMMSS = sprintf('%02d%02d%02d%02d0001',YYYY,mo,dd,HH);
%                     [segmentdecon] = mcmatcom(yyyymoddHHMMSS,1,3598,cmp(i));
%                     v4(m,l + 24*n) = var(segmentdecon);
%                     l = l + 1
%                     
%                 end
%                 m = m + 1
%                 l = 1
%                 
%             end
%         end
%     end
%     n = n + 1;
%     m = 1;
% end
save('/Users/abrummen/Code/variance1ag.mat','v1')
