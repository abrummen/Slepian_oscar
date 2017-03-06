function [vx,vy,vxr,vyr,evdp,evlat,evlong,baz,time,ptime,noisevecx,noisevecy,seismogram,seismot] = cut2p(CMT,pmsec,f1,f2)
% cut2p This function loads an Event north-south (y) and east-west(x) seismogram and cuts it to an indicated time
% around the P wave arrival.
% Specifically, it loads two hours of seismogram data (which should be in
% a matlab file and the directory adjusted in the code below) including the
% hour when the event first started and the hour after. It deconvolves and filters the seismogram based on input f. It then downloads
% the synthetics for that event at Guyot from shakemovie. Using those
% location headers, it then runs MatTauP to calculate the predicted P-wave
% arrival time for that particular event at Guyot. It then uses this
% predicted time as the P-wave time around which it cuts a window of pmsec
% seconds to either side of the predicted P-wave time on both seismogram
% components and then exports them as an output vector along with their
% time vectors. It also exports the whole downloaded seismogram segment and
% a specific noise vector from 5*pmsec seconds before the P wave arrival.
%
% INPUT:
% CMT: CMT code of the event of interest
% pmsec: the number of seconds to either side of the Pwave arrival that you
% include in the portion
% f1: The lower (frequency) limit of the bandpass filter
% f2: The upper (frequency) limit of the bandpass filter
% 
% OUTPUT:
%
% vx- The seismogram x component vector, not deconvolved, not filtered, cut
% around the predicted P-wave arrival.
% vy- The seismogram y component vector, not deconvolved, not filtered, cut
% around the predicted P-wave arrival.
% vxr- The seismogram x component vector, deconvolved and filtered, cut
% around the predicted P-wave arrival.
% vyr- The seismogram x component vector, deconvolved and filtered, cut
% around the predicted P-wave arrival.
% evdp- Event Depth
% evlat- Event Latitude
% evlong- Event Longitude
% baz- Event Backazimuth
% time- time vector of the cut seismograms in datenum format with interval of Delta 
% ptime- time of predicted P-wave arrival in datenum format
% noisevecx- the x component seismogram that starts 4*pmsec before the cut
% interval and is the same length as the cut seismogram- for Signal to
% Noise calculations.
% noisevecy- the y component seismogram that starts 4*pmsec before the cut
% interval and is the same length as the cut seismogram- for Signal to
% Noise calculations.
% seismogram- the full two hour seismogram (both x & y) 
% seismot- the time vector for the full seismogram
%
%
% Anna van Brummen 03/04/2017

%Set default values for inputs
defval('CMT','C201609140158A')
defval('pmsec',30)
defval('f1',.02)
defval('f2',1)

%set path for data- diro is where all my data is kept, And semdiro is where
%I keep synthetics downloaded from shakemovie
diro='/Users/abrummen/Data';
semdiro='/Users/abrummen/Data/SEM';

%Indicate seismogram features
STA='S0001';
CHA='HHA';  
DEV='MC-PH1_0248';

%Test whether I have already downloaded the synthetics for this event, if
%not, download them.
if exist(sprintf('%s/%s/',semdiro,CMT)) == 0
  system(sprintf('smget %s',CMT))
end

%Components of the name of the data file downloaded from shakemovie
SHAKENET = 'PN';
SHAKESTA = 'PPGUY';
COMP = 'MXZ';

%Specify location and name for the synthetics 
semfile = fullfile(semdiro,CMT,sprintf('%s.%s.%s.sem.sac',SHAKENET,SHAKESTA,COMP));

%read in seismogram (s) and headers(h) from the synthetics
[s{1},h{1}]=readsac(semfile);

%define the seconds when the synthetics start- combing seconds and
%miliseconds into one number
ssem = str2num(sprintf('%i.%i',h{1}.NZSEC,h{1}.NZMSEC));

%Read different header data for the event
deltasem = h{1}.DELTA;
evdp = h{1}.EVDP;
stalat = h{1}.STLA;
stalong = h{1}.STLO;
evlat = h{1}.EVLA;
evlong = h{1}.EVLO;
baz = h{1}.BAZ;

%Set the wave arrival fo interest for taup
phase = 'P';

%extract date data from the input seismogram
yyyy = str2num(CMT(2:5));
mo = str2num(CMT(6:7));
dd = str2num(CMT(8:9));
hh = str2num(CMT(10:11));
mm = str2num(CMT(12:13));

%Define the start time and the sampling rate for the synthetics in vector
%form
begtsemvec = [yyyy, mo, dd, hh, mm, ssem]; 
deltasemvec = [0, 0, 0, 0, 0, deltasem];

%run taup for the event using PREM model, can change to other options (read
%about taup)
tt = taupTime('prem',evdp,phase,'sta',[stalat stalong],'evt',[evlat evlong]);

%if the event is too far away for any P-wave arrival, fill in the outputs
%with NaN values. otherwise calculate them below
if isempty(tt)
[vx,vy,vxr,vyr,evdp,evlat,evlong,baz,time,ptime,noisevecx,noisevecy,seismogram,seismot]=deal(NaN);
 else

%Round the predicted first Pwave arrival time and the seconds from the beginning 
%time vector of the synthetics to two decimal points since
%my sampling rate is 0.01- if yours is different change this rounding value
tmsec = round((tt(1).time)*10^2)/10^2;
begtsemvecs = round((begtsemvec(6))*10^2)/10^2;
begtsemvec(6) = begtsemvecs;     

%Define the time when the Pwave arrives in actual time, not just from the
%beginning of the event
ptime = begtsemvec + [0 0 0 0 0 tmsec];
%Define the seconds into the data set when the Pwave arrival happens
psec = ptime(5)*60 + ptime(6);

%define the directories where my seismometer data is kept- the second
%directory is defined in case the second hour pushes into the next day
dirx=fullfile(diro,datestr(datenum(yyyy,mo,dd),'yyyy/mm/dd'));
dirx1=fullfile(diro,datestr(datenum(yyyy,mo,dd+1),'yyyy/mm/dd'));

% Define the names and locations of the files we will be loading
matstr='%s.%s_%s_%i%2.2i%2.2i_%2.2i0000.mat';
fname=sprintf(matstr,STA,CHA,DEV,yyyy,mo,dd,hh);
fname2=sprintf(matstr,STA,CHA,DEV,yyyy,mo,dd,hh+1);
fname3=sprintf(matstr,STA,CHA,DEV,yyyy,mo,dd+1,00);
%hvar are headers of each component, s is the seismogram
hvarx=sprintf('h%s','x');
svarx=sprintf('s%s','x');
hvary=sprintf('h%s','y');
svary=sprintf('s%s','y');

%load the xcomponent seismogrm files
myfilename = fullfile(dirx,fname);
d = load(myfilename,hvarx,svarx);
data(:,1) = struct2cell(d);
%Define loop in case it breeches a day
if (hh+1) < 24
    myfilename = fullfile(dirx,fname2);
    d = load(myfilename,hvarx,svarx);
    data(:,2) = struct2cell(d);
else 
    myfilename = fullfile(dirx1,fname3);
    d = load(myfilename,hvarx,svarx);
    data(:,2) = struct2cell(d);
end 

%Put the data from both hours together into one vector 
tiseriesx = [data{2,1}; data{2,2}];

%Now load the ycomponent seismogram files 
myfilename = fullfile(dirx,fname);
d = load(myfilename,hvary,svary);
data(:,1) = struct2cell(d);
%Define loop in case it breeches a day
if (hh+1) < 24
    myfilename = fullfile(dirx,fname2);
    d = load(myfilename,hvary,svary);
    data(:,2) = struct2cell(d);
else
    myfilename = fullfile(dirx1,fname3);
    d = load(myfilename,hvary,svary);
    data(:,2) = struct2cell(d);
end

%Put the data from both hours together into one vector 
tiseriesy = [data{2,1}; data{2,2}];

%define Delta
Delta = 0.01;

%Define the data point which corresponds to the predicted P-wave arrival
%time
pdp = psec/Delta;

%Define the time range which defines the window we want to cut out and
%export
t1 = ptime - [0 0 0 0 0 pmsec];
t2 = ptime + [0 0 0 0 0 pmsec];
time =  datenum(t1):datenum([0 0 0 0 0 Delta]):datenum(t2);

%Define where to save segments, save the segments to load them into sac
Segmentdir='/Users/abrummen/Data/Segments';

fileID = fopen(sprintf('%s/segmentx.txt',Segmentdir),'w');

fprintf(fileID,'%i\n',tiseriesx);
fclose(fileID);


fileID = fopen(sprintf('%s/segmenty.txt',Segmentdir),'w');
fprintf(fileID,'%i\n',tiseriesy);
fclose(fileID);

%Where do you keep your response files? and where will we save our
%segments?
respdir='/Users/abrummen/Data/RESP';
respfilex = 'RESP.XX.S0001.HHX' ;
respfiley = 'RESP.XX.S0001.HHY' ;

%freqlimits
%f1 and f2 are inputs into the function
f0 = f1*0.8;
f3 = f2*1.2;

%Create a macroname which you will open and write all the SAC commands to
macroname = 'sacmacro';

%Go into the macro and write the SAC commands
fid = fopen('sacmacro','w+');
%Set variable names
fprintf(fid,'setbb RESP %s \n',respdir);
fprintf(fid,'setbb SEGDIR %s \n',Segmentdir);
fprintf(fid,'setbb SEGX %s/segmentx.txt \n',Segmentdir);
fprintf(fid,'setbb SEGY %s/segmenty.txt \n',Segmentdir);
fprintf(fid,'setbb RESPFX %s \n',respfilex);
fprintf(fid,'setbb RESPFY %s \n',respfiley);
fprintf(fid,'setbb f0 %i; setbb f1 %i; setbb f2 %i; setbb f3 %i \n',f0,f1,f2,f3);
fprintf(fid,'setbb DELTA %i \n',Delta);
%Deconvolve and filter x segment
fprintf(fid,'readtable %s; chnhdr DELTA %s; rtr; rmean; cd %s;','%SEGX','%DELTA','%RESP');
fprintf(fid,'transfer from evalresp fname %s to none freqlimits %s %s %s %s;','%RESPFX','%f0','%f1','%f2','%f3');
fprintf(fid,'cd %s; w segdeconx.sac; \n','%SEGDIR');
%Deconvolve and filter y segment
fprintf(fid,'readtable %s; chnhdr DELTA %s; rtr; rmean; cd %s;','%SEGY','%DELTA','%RESP');
fprintf(fid,'transfer from evalresp fname %s to none freqlimits %s %s %s %s;','%RESPFY','%f0','%f1','%f2','%f3');
fprintf(fid,'cd %s; w segdecony.sac; quit \n','%SEGDIR');

%Pipe the macro through SAC
system(sprintf('echo "m %s" | sac',macroname))

%make sure wherever you saved the files from SAC is in your path
addpath(Segmentdir)

%read in the files you saved 
segdeconx = readsac(sprintf('%s/segdeconx.sac',Segmentdir));
segdecony = readsac(sprintf('%s/segdecony.sac',Segmentdir));

%Define the time vectors that begin and end all the seismic data that you
%loaded 
seismoti = [begtsemvec(1) begtsemvec(2) begtsemvec(3) begtsemvec(4) 0 0];
seismote = [begtsemvec(1) begtsemvec(2) begtsemvec(3) begtsemvec(4)+1 59 59.99]; 

%Save the window of desired cut length both unfiltered and not deconvolved
vx = tiseriesx((pdp-pmsec/Delta):(pdp+pmsec/Delta));
vy = tiseriesy((pdp-pmsec/Delta):(pdp+pmsec/Delta));

%Make sure the event wasn't too far away and the seismogram isn't NaN- if
%it is define the whole two hour time vector and put the components of the
%seismogram deconvolved and filtered into one variable
if length(segdeconx) >1 
    if length(segdeconx) == length(segdecony)
       seismot = datenum(seismoti):datenum([0 0 0 0 0 Delta]):datenum(seismote);
       seismogram(:,1) = segdeconx;
       seismogram(:,2) = segdecony;
    else 
        seismogram = NaN;
        seismot = NaN;
    end
end

%The good stuff- this is the deconvolved and filtered seismogram cut to the
%indicated length around the predicted P-wave arrival
vxr = segdeconx((pdp-pmsec/Delta):(pdp+pmsec/Delta));
vyr = segdecony((pdp-pmsec/Delta):(pdp+pmsec/Delta));

%Also cut a window the same length as the vxr of noise data starting
%5*pmsec seconds before the predicted P-wave arrival
noisevecx = segdeconx((pdp-5*pmsec/Delta):(pdp-3*pmsec/Delta));
noisevecy = segdecony((pdp-5*pmsec/Delta):(pdp-3*pmsec/Delta));

end

end


