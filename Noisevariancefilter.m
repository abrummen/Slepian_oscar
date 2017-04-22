%first for hour 1 of every day extract the info and 
%For dates 07/01/2016- 10/24/2016, 01/01/2017 - 02/28/2017
%

YYYY = 2016;

cmp = ['x','y','z'];

l = 1;
m = 1;
n = 0;


v1 = zeros(31*2+30+24,24*3);
v2 = zeros(31*2+30+24,24*3);
v3 = zeros(31*2+30+24,24*3);
v4 = zeros(31*2+28,24*3);
v5 = zeros(31*2+28,24*3);
v6 = zeros(31*2+28,24*3);


for i = 1:3
    for mo = 7:10
        if mo == 9
            for dd = 1:30
                for HH = 00:23
                    yyyymoddHHMMSS = sprintf('%02d%02d%02d%02d0001',YYYY,mo,dd,HH);
                    [segmentdecon1] = mcmatcomfilter(yyyymoddHHMMSS,1,3598,cmp(i),1,2);
                    v1(m,l + 24*n) = var(segmentdecon1);
                    [segmentdecon2] = mcmatcomfilter(yyyymoddHHMMSS,1,3598,cmp(i),0.03,0.5);
                    v2(m,l + 24*n) = var(segmentdecon2);
                    [segmentdecon3] = mcmatcomfilter(yyyymoddHHMMSS,1,3598,cmp(i),10,20);
                    v3(m,l + 24*n) = var(segmentdecon3);
                    l = l + 1
                    
                end
                m = m + 1
                l = 1
                
            end
        elseif mo == 10
            for dd = 01:24
                for HH = 00:23
                    yyyymoddHHMMSS = sprintf('%02d%02d%02d%02d0001',YYYY,mo,dd,HH);
                    [segmentdecon1] = mcmatcomfilter(yyyymoddHHMMSS,1,3598,cmp(i),1,2);
                    v1(m,l + 24*n) = var(segmentdecon1);
                    [segmentdecon2] = mcmatcomfilter(yyyymoddHHMMSS,1,3598,cmp(i),0.03,0.5);
                    v2(m,l + 24*n) = var(segmentdecon2);
                    [segmentdecon3] = mcmatcomfilter(yyyymoddHHMMSS,1,3598,cmp(i),10,20);
                    v3(m,l + 24*n) = var(segmentdecon3);
                    l = l + 1
                    
                end
                m = m + 1
                l = 1
                
             end
        else 
            for dd = 01:31
                for HH = 00:23
                    yyyymoddHHMMSS = sprintf('%02d%02d%02d%02d0001',YYYY,mo,dd,HH);
                    [segmentdecon1] = mcmatcomfilter(yyyymoddHHMMSS,1,3598,cmp(i),1,2);
                    v1(m,l + 24*n) = var(segmentdecon1);
                    [segmentdecon2] = mcmatcomfilter(yyyymoddHHMMSS,1,3598,cmp(i),0.03,0.5);
                    v2(m,l + 24*n) = var(segmentdecon2);
                    [segmentdecon3] = mcmatcomfilter(yyyymoddHHMMSS,1,3598,cmp(i),10,20);
                    v3(m,l + 24*n) = var(segmentdecon3);
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

YYYY = 2017;

l = 1;
%m = 1;
m = 1;
n = 0;

for i = 1:3
    for mo = 1:3
        if mo == 2
            for dd = 1:28
                for HH = 00:23
                    yyyymoddHHMMSS = sprintf('%02d%02d%02d%02d0001',YYYY,mo,dd,HH);
                    [segmentdecon1] = mcmatcomfilter(yyyymoddHHMMSS,1,3598,cmp(i),1,2);
                    v4(m,l + 24*n) = var(segmentdecon1);
                    [segmentdecon2] = mcmatcomfilter(yyyymoddHHMMSS,1,3598,cmp(i),0.03,0.5);
                    v5(m,l + 24*n) = var(segmentdecon2);
                    [segmentdecon3] = mcmatcomfilter(yyyymoddHHMMSS,1,3598,cmp(i),10,20);
                    v6(m,l + 24*n) = var(segmentdecon3);
                    l = l + 1
                    
                end
                m = m + 1
                l = 1
                
            end

        else 
            for dd = 01:31
                for HH = 00:23
                    yyyymoddHHMMSS = sprintf('%02d%02d%02d%02d0001',YYYY,mo,dd,HH);
                    [segmentdecon1] = mcmatcomfilter(yyyymoddHHMMSS,1,3598,cmp(i),1,2);
                    v4(m,l + 24*n) = var(segmentdecon1);
                    [segmentdecon2] = mcmatcomfilter(yyyymoddHHMMSS,1,3598,cmp(i),0.03,0.5);
                    v5(m,l + 24*n) = var(segmentdecon2);
                    [segmentdecon3] = mcmatcomfilter(yyyymoddHHMMSS,1,3598,cmp(i),10,20);
                    v6(m,l + 24*n) = var(segmentdecon3);
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
save('/Users/abrummen/Code/varianceTotf.mat','v1','v2','v3','v4','v5','v6')
