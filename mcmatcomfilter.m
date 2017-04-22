function [segmentdecon] = mcmatcom(yyyymoddHHMMSS,pret,postt,cmp,f1,f2)
%This function reads in a seismogram from a mat file that should have been
%generated via mcms2mat or some other method that originally takes in the
%miniseed format and ouputs a mat format which contains all three
%components and their headers. This function then cuts the seismogram,
%deconvolves it, and filters it. 
% 
% Data directory under which the yyyy/mm/dd directories are kept
diro='/Users/abrummen/Data';

% Default directory where the EPS files will go, best to set your own 'EPS'
setenv('EPS',getenv('EPS'))

% Hard things such as our station, channel, instrument name etc
STA='S0001';
CHA='HHA';  
DEV='MC-PH1_0248';

% example file name we would want to read in from inputs S0001.HHA_MC-PH1_0248_20151012_220000.mat
% is format sta.cha_dev_yyyymmdd_hhmmss.mat

defval('yyyymoddHHMMSS',20160924190001)
str = num2str(yyyymoddHHMMSS)
yyyy = str2num(str(1:4));
mo = str2num(str(5:6));
dd = str2num(str(7:8));
hh = str2num(str(9:10));
mm = str2num(str(11:12));
ss = str2num(str(13:14));
defval('pret',1)
defval('postt',3598)
defval('cmp','x')
defval('f1',1)
defval('f2',2)

%account for if pret and postt push you into the next hour or minute, this
%section is currently done pretty sloppily so 
ddless = fix(pret/(3600*24));
hhless = fix(pret/3600) - ddless*24;
minless = fix(pret/60) - hhless*60 - ddless*24*60;
secless = rem(pret,60);
ddmore = fix(postt/(3600*24));
hhmore = fix(postt/3600)- ddmore*24;
minmore = fix(postt/60) - hhmore*60 - ddmore*24*60;
secmore = rem(postt,60);

if ss-secless < 0
    mmadj = mm-1;
    ssadj = ss + 60;
else
    ssadj = ss;
    mmadj = mm;
end

if mmadj - minless < 0 
   hhadj = hh - 1;
   mmadj = mmadj + 60;
else
    hhadj = hh;
end

if hhadj - hhless < 0
    ddadj = dd - 1;
    hhadj = hhadj + 24;
else
    ddadj = dd;
end

begt = sprintf('%i/%i/%i %2.2i:%2.2i:%2.2i',yyyy,mo,(ddadj - ddless),(hhadj-hhless),(mmadj-minless),(ssadj-secless));
begtvec = [yyyy,mo,(ddadj - ddless),(hhadj-hhless),(mmadj-minless),(ssadj-secless)];


if ss+secmore >= 60
    madj = mm+1;
    sadj = ss - 60;
else
    sadj = ss;
    madj = mm;
end

if madj + minmore >= 60 
   hadj = hh + 1;
   madj = madj - 60;
else
    hadj = hh;
end

if hadj + hhmore >= 24
    dadj = dd + 1;
    hadj = hadj - 24;
else
    dadj = dd;
end

endt = sprintf('%i/%i/%i %2.2i:%2.2i:%2.2i',yyyy,mo,(dadj+ddmore),(hadj+hhmore),(madj+minmore),sadj+secmore);


%This is where it loads in the data and then cuts it to the input times
if or((hhadj-hhless) ~= (hadj+hhmore),(ddadj-ddless) ~= (dadj+ddmore))
    tiseries = [];
    totalh = (ceil(pret/3600)+ceil(postt/3600));
    totald = length([(ddadj-ddless):(dadj+ddmore)]);
    data = cell(2, totalh);
    
    %Ask if they want to downsample to save time
    reply=input(sprintf('You are loading more than 1 hour. Downsample? [y/n]? '),'s');
    if reply == 'y'; 
        reply2=input(sprintf('You are loading %i hours. One hour takes approximately 1 minute when delta equals 0.01. Downsample by what factor? (enter whole number)',totalh));
    end
             ddvec = [(ddadj-ddless):(dadj+ddmore)];
             i = 1;
             for dd = ddvec
                 if length(ddvec) == 1
                     hstart = (hhadj-hhless);
                     hend = (hadj + hhmore);
                 elseif dd == (min(ddvec)) 
                     hstart = (hhadj-hhless);
                     hend = 23;
                 elseif dd == max(ddvec)
                     hstart = 0;
                     hend = (hadj + hhmore); 
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
                        newDelta = max(Delta);
                        for j = 1:i
                        %downsample if necessary & change Delta
                        keyboard
                            if data{1,j}.Delta ~= newDelta
                                keyboard
                                samplingchange = newDelta/data{1,j}.Delta;
                                data{2,j} = downsample(data{2,j},samplingchange);
                                data{1,j}.Delta = newDelta ;
                                Deltacomp(j) = newDelta;
                            end
                        end
                    end
                    tiseries = [tiseries; data{2,i}];
                    i = i + 1;
                end
             end
             
    
    %Find the second & datapoint where our segment begins
    begins = (mmadj-minless)*60 + (ssadj-secless); % this is the second in the first hour when our seg begins
    begindp = begins/Delta;
    Rangemin = begindp;

    %Find the second & datapoint where our segment ends
    ends = length(tiseries)*Delta - (madj+minmore)*60 - (sadj+secmore);
    enddp = ends/Delta;
    Rangemax = enddp;
    
    %Find the input datapoint 
    datap = begindp + pret/Delta;
    
    %Define our segment
    segment = tiseries(begindp:enddp);
    
else
    
    %This does the same as above for one hour (Might be unnecessary- I can
    %probably work it into the above section)
    dirx=fullfile(diro,datestr(datenum(yyyy,mo,dd),'yyyy/mm/dd'));

    myfilename = fullfile(dirx,sprintf('%s.%s_%s_%i%2.2i%2.2i_%2.2i0000.mat',STA,CHA,DEV,yyyy,mo,dd,hh));
    try
        d = load((myfilename),sprintf('h%s',cmp),sprintf('s%s',cmp));
    catch ME
        if strcmp(ME.identifier,'MATLAB:load:couldNotReadFile')
           warning('No seismogram file to read in %s',myfilename)
           d = struct('headers',NaN,'timeseries',NaN);
        else
            rethrow(ME)
        end
    end
    data = struct2cell(d);
    
    headers = data{1};
    tiseries = data{2};

    % now what is the second we are looking?
    sec = mm*60 + ss;

    % how many seconds is it from the beginning of the loaded data (important if this
    % hour doesn't start at zero)
 
    if length(tiseries) < 360000
        segment = NaN;
        Delta = 0.01;
    else
        secB = sec - (headers.NZMIN*60+headers.NZSEC);
        
        %so what data point is this?
        
        datap = secB/headers.DELTA;
        
        %now we want to know pret datapoints before this and postt data points
        %after to set the range of th segment
        Delta = headers.DELTA;
        
        Rangemin = datap - pret/headers.DELTA;
        Rangemax = datap + postt/headers.DELTA;
        
        if Rangemin == 0
            Rangemin = 1;
        end
        
        segment = tiseries(Rangemin:Rangemax,1);
    end
end

%This creates a datenum for the input time
dataptime = datenum([begtvec(1), begtvec(2), begtvec(3), begtvec(4), begtvec(5), begtvec(6) + pret]);

deltavec = [0, 0, 0, 0, 0, Delta];

%Creates a time vector with datenum to use for the plot later
t= datenum(begtvec):datenum(deltavec):(datenum(begtvec) + datenum((length(segment)-1)*deltavec));

%Save the segment to load it into sac
fileID = fopen('segment.txt','w');
fprintf(fileID,'%i\n',segment);
fclose(fileID);

if cmp == 'x'
    cmpl = 'X';
elseif cmp == 'y'
    cmpl = 'Y';
else
    cmpl = 'Z';
end
%Where do you keep your response files?
respdir='/Users/abrummen/Data/RESP';
respfile = sprintf('RESP.XX.S0001.HH%s',cmpl) ;
Segmentdir='/Users/abrummen/Data/Segments';
Segdir = '/Users/abrummen/Data/Segments';
%freqlimits
%f1 = 1;
f0 = f1*0.8;
%f2 = 2;
f3 = f2*1.2;

%bandpass corners
bpc1 = f1;
bpc2 = f2;

macroname = 'somemacro1';

fid = fopen(macroname,'w+');
fprintf(fid,'setbb RESP %s \n',respdir)
fprintf(fid,'setbb SEGDIR %s \n',Segmentdir)
fprintf(fid,'setbb RESPF %s \n',respfile)
fprintf(fid,'setbb f0 %i; setbb f1 %i; setbb f2 %i; setbb f3 %i \n',f0,f1,f2,f3)
fprintf(fid,'setbb DELTA %i \n',Delta)
fprintf(fid,'setbb BPC1 %i; setbb BPC2 %i \n',bpc1,bpc2)
%fprintf(fid,'readtable segment.txt; chnhdr DELTA %s; rtr;rmean;cd %s; transfer from evalresp fname %s to none; cd %s; w segmentdecon.sac; quit \n',...
%    '%DELTA','%RESP','%RESPF','%SEGDIR')
fprintf(fid,'readtable segment.txt; chnhdr DELTA %s; rtr; rmean;cd %s; transfer from evalresp fname %s to none freqlimits %s %s %s %s; cd %s; w segmentdecon.sac; \n','%DELTA','%RESP','%RESPF','%f0','%f1','%f2','%f3','%SEGDIR')
fprintf(fid,'rtr; rmean; taper; bp butter co %s %s n 2 p 1; rtr; rmean; w segdeconbp.sac; quit  \n','%BPC1','%BPC2')

system(sprintf('echo "m %s" | sac',macroname))

addpath(Segdir)
segdeconbp = readsac(sprintf('%s/segdeconbp.sac',Segdir));
segmentdecon = readsac(sprintf('%s/segmentdecon.sac',Segdir));
fclose(fid);

if isnan(segment) == 1
    segmentdecon = NaN
end

%plot(t,segmentdecon);
%hold all;
%datetick('x',13)

%Save segment?

%save(sprintf('%s/%s',Segdir,yyyymoddHHMMSS),'segdeconbp','t')

%suptitle(sprintf('North Korea Nuclear Bomb test Filtered %.3f-%.3f Hz',f1,f2))


%STILL TO DO: MAKE HEADERS: START TIME, END TIME, INPUT TIME, DELTA
%make a save option 
%ACCOUNT FOR SEGMENTS BREECHING MORE THAN ONE MONTH
%MAKE THE PLOT LOOK NICE
end

