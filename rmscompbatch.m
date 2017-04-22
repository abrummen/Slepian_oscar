function [angles] = rmscompbatch(file)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

defval('file','/Users/abrummen/Documents/Total.txt')

%fileID = fopen(sprintf('%s',file));
%C = textscan(fileID,'%s');
%fclose(fileID);

C = importdata(file);
cmt = C.textdata(:,1);
mag = C.data(:,1);

j = 1;
k = 1;

for i = 1:length(cmt)   
	  [maxg,baz,evdist,evdep,SNR,msamp,record] = rmscomp2(cmt(i),mag(i),30,1,2);

    if record == 1
        angles(i,1) = maxg;
        angles(i,2) = baz;
        angles(i,3) = evdist;
        angles(i,4) = SNR;
        angles(i,5) = msamp;
        angles(i,6) = mag(i);
        angles(i,7) = record;
        badangles(i,1) = NaN;
        badangles(i,2) = NaN;
        badangles(i,3) = NaN;
        badangles(i,4) = NaN;
        badangles(i,5) = NaN;
        badangles(i,6) = NaN;
        badangles(i,7) = NaN;
        
        goodangles(j) = maxg;
        goodbaz(j) = baz;
        gooddist(j) = evdist;
        gooddep(j) = evdep;
        goodSNR(j) = SNR;
        goodmsamp(j) = msamp;
        goodmag(j) = mag(i); 
        goodindex(j) = i;
        
        j = j+1;
    else
          angles(i,1) = NaN;
          angles(i,2) = NaN;
          angles(i,3) = NaN;
          angles(i,4) = NaN;
          angles(i,5) = NaN;
          angles(i,6) = NaN;
          angles(i,7) = NaN;
          badangles(i,1) = maxg;
          badangles(i,2) = baz;
          badangles(i,3) = evdist;
          badangles(i,4) = SNR;
          badangles(i,5) = msamp;
          badangles(i,6) = mag(i);
          badangles(i,7) = record;
          
           
        badangles1(k) = maxg;
        badbaz(k) = baz;
        baddist(k) = evdist;
        baddep(j) = evdep;
        badSNR(k) = SNR;
        badmsamp(k) = msamp;
        badmag(k) = mag(i);
        badindex(k) = i;
        
        k = k+1;
    
    end

end
%Correct for the few days when 
for j = 137:145
   angles(j,1) = angles(j,1) + 24.9; 
end

dlmwrite('/Users/abrummen/Data/anglesTotal30m.csv',angles,'delimiter',',', ...
    'precision','%.2f');
dlmwrite('/Users/abrummen/Data/badanglesTotal30m.csv',badangles,'delimiter',',', ...
    'precision','%.2f');

% Any components we have, save them together in a MAT file
save('/Users/abrummen/Data/goodTotal30.mat','goodangles','goodbaz','gooddist', ...
    'gooddep','goodSNR','goodmsamp','goodmag','goodindex')
save('/Users/abrummen/Data/badTotal30.mat','badangles1','badbaz','baddist', ...
    'baddep','badSNR','badmsamp','badmag','badindex')

figure(1)
clf
hist(goodangles);

al = 1;
b = 1;
c = 1;
d = 1;

for i = 1:length(goodangles)
    if goodSNR(i) >= 3 && goodSNR(i) < 10
        indexSNR1(al) = i;
        al = al+1;
    elseif goodSNR(i) >= 10 && goodSNR(i) < 100
        indexSNR2(b) = i;
        b = b+1;
     elseif goodSNR(i) >= 100 && goodSNR(i) < 1000
        indexSNR3(c) = i;
        c = c+1;
     elseif goodSNR(i) >= 1000
        indexSNR4(d) = i;
        d = d+1;
    end
end
        

figure(2)
clf
scatter(goodmag(indexSNR1),gooddist(indexSNR1),50,'g','filled')
hold all;
scatter(goodmag(indexSNR2),gooddist(indexSNR2),80,'g','filled')
scatter(goodmag(indexSNR3),gooddist(indexSNR3),110,'g','filled')
scatter(goodmag(indexSNR4),gooddist(indexSNR4),140,'g','filled')

scatter(badmag,baddist,20,'r','filled')
xlim([4.5 9]) 


%plot distance vs. mag vs. SNR

keyboard

end

