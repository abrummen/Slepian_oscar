function [segdeconbp,t,Ptime,Stime,pdp] = mccompmodes(yyyymoddHHMM,cmp,f1,f2,s)
%mccompsem(yyyymoddHHMM,cmp)
%UNTITLED3 Summary of this function goes here
%Detailed explanation goes here

%Data directory under which the yyyy/mm/dd directories are kept

diro='/Users/abrummen/Data';

% Hard things such as our station, channel, instrument name etc
STA='S0001';
CHA='HHA';  
DEV='MC-PH1_0248';

% example file name we would want to read in from inputs S0001.HHA_MC-PH1_0248_20151012_220000.mat
% is format sta.cha_dev_yyyymmdd_hhmmss.mat

defval('yyyymoddHHMM',201606261117)
str = num2str(yyyymoddHHMM)

yyyy = (str(1:4));
mo = (str(5:6));
dd = (str(7:8));
hh = (str(9:10));
mm = (str(11:12));
%ss is defined after reading in the file

defval('cmp','Y')
defval('f1',1)
defval('f2',2)
f0 = f1*0.8;
f3 = f2*1.2;

% s defines whether or not to write the figure- 1 is yes, 0 is no
defval('s',1)




if cmp == 'X'
  cmp2 = 'E';
elseif cmp == 'Y'
  cmp2 = 'N';
elseif cmp == 'Z'
  cmp2 = 'Z';
end

%This event's CMT code
semdiro='/Users/abrummen/Data/SEM';

CMT = sprintf('C%s%2.2s%2.2s%2.2s%sA',yyyy,mo,dd,hh,mm);

if exist(sprintf('%s/%s/',semdiro,CMT)) == 0
system(sprintf('smget %s',CMT))
end


SHAKENET = 'PN';
SHAKESTA = 'PPGUY';
COMP = sprintf('LX%s',cmp2);

semfile = fullfile(semdiro,CMT,sprintf('%s.%s.%s.modes.sac',SHAKENET,SHAKESTA,COMP));

[s,h]=readsac(semfile);
ss = h.NZSEC;
ssem = str2num(sprintf('%i.%i',h.NZSEC,h.NZMSEC));

pret = fix(abs(h.B));
postt = ceil(abs(h.E));

deltasem = h.DELTA;

yyyy = str2num(yyyy)
mo = str2num(mo)
dd = str2num(dd)
hh = str2num(hh)
mm = str2num(mm)

begtsemvec = [yyyy, mo, dd, hh, mm, ssem]; 

deltasemvec = [0, 0, 0, 0, 0, deltasem];

tsem = datenum(begtsemvec):datenum(deltasemvec):(datenum(begtsemvec) + datenum((length(s)-1)*deltasemvec));

%account for if pret and postt push you into the next hour or minute

begtvec = datevec(datenum(([yyyy mo dd hh mm ss]) - ([0 0 0 0 0 pret])));

endtvec = datevec(datenum(([yyyy mo dd hh mm ss]) + ([0 0 0 0 0 postt])));

cmp = lower(cmp)

if or((begtvec(4)) ~= (endtvec(4)),(begtvec(3)) ~= (endtvec(3)))
    tiseries = [];
    totalh = (ceil(pret/3600)+ceil(postt/3600));
    totald = length([(begtvec(3)):(endtvec(3))]);
    data = cell(2, totalh);

    %Ask if they want to downsample to save time
%    reply=input(sprintf('You are loading more than 1 hour. Downsample? [y/n]? '),'s');
%    if reply == 'y'; 
%    reply2=input(sprintf('You are loading %i hours. One hour takes approximately 1 minute when delta equals 0.01. Downsample by what factor? (enter whole number)',totalh));
%    end
reply = 'n';
             ddvec = [(begtvec(3):endtvec(3))];
             i = 1;
             for dd = ddvec
                 if length(ddvec) == 1
                     hstart = (begtvec(4));
                     hend = (endtvec(4));
                 elseif dd == (min(ddvec)) 
                     hstart = (begtvec(4));
                     hend = 23;
                 elseif dd == max(ddvec)
                     hstart = 0;
                     hend = (endtvec(4)); 
                 else
                     hstart = 0;
                     hend = 23;
                 end
                for hh = hstart:hend
                    dirx=fullfile(diro,datestr(datenum(yyyy,mo,dd),'yyyy/mm/dd'));
                    myfilename = fullfile(dirx,sprintf('%s.%s_%s_%i%2.2i%2.2i_%2.2i0000.mat',STA,CHA,DEV,yyyy,mo,dd,hh));
                    d = load((myfilename),sprintf('h%s',cmp),sprintf('s%s',cmp));
                    data(:,i) = struct2cell(d);
                    if reply == 'y'
                    data{2,i} = downsample(data{2,i},reply2);
                    data{1,i}.DELTA = data{1,i}.DELTA*reply2;
                    end
                    Deltacomp(i) = data{1,i}.DELTA;
                    Delta = unique(Deltacomp);
                    % make all Deltas the same 
                    if length(Delta) > 1
                        newDelta = max(Delta)
                        for j = 1:i
                        %downsample if necessary & change Delta
                            if data{1,j}.Delta ~= newDelta
                                samplingchange = newDelta/data{1,j}.Delta
                                data{2,j} = downsample(data{2,j},samplingchange);
                                data{1,j}.Delta = newDelta
                                Deltacomp(j) = newDelta
                            end
                        end
                    end
                    tiseries = [tiseries; data{2,i}];
                    i = i + 1
                end
             end
            
    
    %Find the second & datapoint where our segment begins
    begins = begtvec(5)*60 + begtvec(6); % this is the second in the first hour when our seg begins
    begindp = round(begins/Delta);
    Rangemin = begindp;

    %Find the second & datapoint where our segment ends
    ends = length(tiseries)*Delta - (endtvec(5))*60 - (endtvec(6));
    enddp = round(ends/Delta);
    Rangemax = enddp;
    
    %Find the input datapoint 
    datap = begindp + pret/Delta;
    
    %Define our segment
    segment = tiseries(begindp:enddp);
    
else
    
    %This does the same as above for one hour (Might be unnecessary- I can
    %probably work it into the above section)
    
    dirx=fullfile(diro,datestr(datenum(yyyy,mo,dd),'yyyy/mm/dd'));

    myfilename = fullfile(dirx,sprintf('%s.%s_%s_%i%2.2i%2.2i_%2.2i0000.mat',STA,CHA,DEV,yyyy,mo,dd,hh))

    data = load((myfilename),sprintf('h%s',cmp),sprintf('s%s',cmp));

    headers = data.hx;
    tiseries = data.sx;

    % now what is the second we are looking?
    sec = mm*60 + ss;

    % how many seconds is it from the beginning of the loaded data (important if this
    % hour doesn't start at zero)

    secB = sec - (headers.NZMIN*60+headers.NZSEC);

    %so what data point is this?

    datap = secB/headers.DELTA;

    %now we want to know pret datapoints before this and postt data points
    %after to set the range of th segment 
    Delta = headers.DELTA;

    Rangemin = datap - pret/headers.DELTA;   % here we are assuming that all the files have the same DELTA if 
    Rangemax = datap + postt/headers.DELTA;  % it bridges multiple hours- have to adjust later 

    segment = tiseries(Rangemin:Rangemax,1);

end

deltavec = [0, 0, 0, 0, 0, Delta];

t= datenum(begtvec):datenum(deltavec):(datenum(begtvec) + datenum((length(segment)-1)*deltavec));

%Save the segment to load it into sac
fileID = fopen('/Users/abrummen/Code/segment1.txt','w');
fprintf(fileID,'%i\n',segment);
fclose(fileID);

%Where do you keep your response files?
respdir='/Users/abrummen/Data/RESP';
respfile = 'RESP.XX.S0001.HHZ' ;
Segmentdir='/Users/abrummen/Data/Segments';

%NEED TO FIGURE OUT HOW TO FILTER MODES STILL
%freqlimits- f1 and f2 are function inputs

f0 = f1*0.8;
f3 = f2*1.2;

%bandpass corners
bpc1 = f1;
bpc2 = f2;
cd('/Users/abrummen/Code')
macroname = '/Users/abrummen/Code/somemacromc'

fID = fopen(macroname,'w+')
fprintf(fID,'setbb RESP %s \n',respdir)
fprintf(fID,'setbb SEGDIR %s \n',Segmentdir)
fprintf(fID,'setbb RESPF %s \n',respfile)
fprintf(fID,'setbb SEMF %s \n',semfile)
fprintf(fID,'setbb f0 %i; setbb f1 %i; setbb f2 %i; setbb f3 %i \n',f0,f1,f2,f3)
fprintf(fID,'setbb DELTA %i \n',Delta)
fprintf(fID,'setbb BPC1 %i; setbb BPC2 %i \n',bpc1,bpc2)
fprintf(fID,'readtable segment1.txt; chnhdr DELTA %s; rtr; rmean;cd %s; transfer from evalresp fname %s to none freqlimits %s %s %s %s; cd %s; w segmentdecon.sac; \n','%DELTA','%RESP','%RESPF','%f0','%f1','%f2','%f3','%SEGDIR')
fprintf(fID,'rtr; rmean; taper; bp butter co %s %s n 2 p 1; rtr; rmean; w segdeconbp.sac;  \n','%BPC1','%BPC2')
fprintf(fID,'r %s;rtr; rmean; taper; bp butter co %s %s n 2 p 1; rtr; rmean; w semdeconbp.sac; quit  \n','%SEMF','%BPC1','%BPC2')

system(sprintf('echo "m %s" | sac',macroname))

addpath(Segmentdir)
segdeconbp = readsac(sprintf('%s/segdeconbp.sac',Segmentdir));
semdeconbp = readsac(sprintf('%s/semdeconbp.sac',Segmentdir));

fclose(fID)
%plot both
clf;

f = figure(1);
hold all;
title(sprintf('%s',CMT))

subplot(2,1,1)
h1 = plot(t,segdeconbp);
datetick('x',13)
title('Observed Data from Princeton Seismogram')
subplot(2,1,2)
plot(tsem,semdeconbp);
datetick('x',13)
title('1D Modes Synthetics from ShakeMovie')

axH = findall(gcf,'type','axes');
set(axH,'xlim',[min(t) max(t)])


%Plot important points & arrivals using MatTauP

evdp = h.EVDP;
%full list of phases: phases = ['P','S','PcP','ScS','PKiKP','SKiKS']
phases = ['P','S'];
stalat = h.STLA;
stalong = h.STLO;
evlat = h.EVLA;
evlong = h.EVLO;
colors = ['r', 'k', 'm', 'o', 'c', 'g'];
n = 1;

addpath('/Users/abrummen/Code/MatTaup');
for i = 1:length(phases)
    
  tt = taupTime('prem',evdp,phases(i),'sta',[stalat stalong],'evt',[evlat evlong]);
  wavenumber(i) = length(tt) ;
    for j = 1:length(tt)
    phtime(n) = datenum(begtsemvec) + datenum([0 0 0 0 0 tt(j).time]);
    n = n+1;
    end

end

Ptime = phtime(1);
Stime = phtime(wavenumber(1)+1);

pdpvec = datevec(Ptime - datenum(begtsemvec));
pdp = (pdpvec(5)*60 + pdpvec(6))/Delta;
pdp = round(pdp);

%First phase entry
for i = 1:wavenumber(1)
    subplot(2,1,1)
    hold all
	  h2 = plot(phtime(i)*ones(length(min(segdeconbp):1:max(segdeconbp)),1),min(segdeconbp):1:max(segdeconbp),colors(1));
end
%Second phase entry
for i = wavenumber(1)+1:wavenumber(1)+wavenumber(2)
    subplot(2,1,1)
    hold all
	  h3 = plot(phtime(i)*ones(length(min(segdeconbp):1:max(segdeconbp)),1),min(segdeconbp):1:max(segdeconbp),colors(2));
end



%Etc for as many phases as you have

title(sprintf('%s',CMT))

subplot(2,1,1)
h1 = plot(t,segdeconbp);
datetick('x',13)
title('Observed Data from Princeton Seismogram')
subplot(2,1,2)
plot(tsem,semdeconbp);
datetick('x',13)
title('1D Modes Synthetics from ShakeMovie')

axH = findall(gcf,'type','axes');
set(axH,'xlim',[min(t) max(t)])

suptitle(sprintf('Event %s Filtered %.3f-%.3f Hz',CMT,f1,f2))

legend([h1 h2 h3], {'Seismogram', phases(1), phases(2)})

if s == 1
print('-dpdf',sprintf('/Users/abrummen/Documents/Event_Modes/%s',CMT));
end




 
%ACCOUNT FOR SEGMENTS BREECHING MORE THAN ONE MONTH

end
