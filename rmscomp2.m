function [maxg,baz,evdist,evdep,SNR,msamp,record] = rmscomp2(CMT,mag,pmsec,f1,f2)
%rmscomp2 This function takes cuts and rotates x and y components of a
%     seismogram around the predicted P-wave arrival time to maximize energy on
%     the radial seismogram component. Specifically, this function calls cut2p to  
%     read in the seismograms, predict the P-wave arrival time, load header data
%     for the event, and cut both components to a window of 1/2 width pmsec
%     seconds around the predicted P-wave arrival. It then calls rotatevec to
%     rotate the cut seismograms into the direction of their back azimuth,
%     making the x-component the transverse and the y-component the radial
%     seismograms. I do the same for a vector of noise output from cut2p.
%     Again using rotatevec I rotate the radial and transverse seismograms 180 degrees at an
%     interval of 0.5 degrees and determine the mean squared value(refer to
%     rotatevec for the equation used) which maximizes the p-wave signal
%     amplitude on the radial component. This function then plots a variety of
%     outputs, and determines a signal to noise ratio of the variance of the
%     signal vector divided by the variance of a noise vector. It also defines a
%     value which is 1 if the Signal to Noise is greater than an indicated
%     value, or a 0 if it is below that value. 
% 
% Input
% CMT: CMT code of an event
% pmsec: The time interval defining the window you want to cut around the
% predicted P-wave arrival. The window will be pmsec seconds before and
% after the arrival time, for a total length of 2*pmsec
% f1: Lower corner of frequency filter
% f2: Upper corner of frequency filter
% 
% Output
% maxg: The angle at which the seismic energy is maximized on the radial
%   component
% baz: The event's backazimuth
% record: 1 if the Signal to Noise Ratio is above a given threshold, 0
%   otherwise
% Written by Anna van Brummen 03/05/2017

%C201703152219A 5.7

%Define default values for inputs
defval('CMT','C201703152219A')
defval('pmsec',30)
defval('f1',1)
defval('f2',2)
defval('mag',NaN)
%Break up the CMT code into date variables of the event
if ischar(CMT) == 1
    yyyy = CMT(2:5);
    mo = CMT(6:7);
    dd = CMT(8:9);
    hh = CMT(10:11);
    mm = CMT(12:13);
else
    yyyy = CMT{1}(2:5);
    mo = CMT{1}(6:7);
    dd = CMT{1}(8:9);
    hh = CMT{1}(10:11);
    mm = CMT{1}(12:13);
    CMT = num2str(CMT{1});
end

%Run cut2p
[vx,vy,vxf,vyf,evdep,evlat,evlong,baz,evdist,time,ptime,noisevecx,noisevecy,seismogram,seismot] = cut2p(CMT,pmsec,f1,f2);

evdistd = evdist/111; %(change km into degrees)
%Rotate the x and y components into the direction of the backazimuth to get
%the radial (from y) and transverse (from x) components
[vxrbaz,vyrbaz] = rotatevec(vxf,vyf,baz,0,0);

%Rotate the noise vector as well
[noisexbaz,noiseybaz] = rotatevec(noisevecx,noisevecy,baz,0,0);

%Rotate the whole seismogram as well- if loop is just making sure the value
%isn't NaN before rotating it
if length(seismogram) > 1
[seismoxbaz,seismoybaz] = rotatevec(seismogram(:,1),seismogram(:,2),baz,0,0);
end

%Here we rotate the radial and transverse plus and minus 90 degrees at an 
%interval of 0.5 degrees. We output which angle best captures all the
%energy on the radial component (maxg) the list of all angles (gamav), the
%list of all the mean squared values (msxy), the best mean squared values
%(maxms), and the rotated seismograms by maxg on top of baz
[vxr,vyr,maxg,maxms,msxy,gamav] = rotatevec(vxrbaz,vyrbaz,90,0.5,0);

msamp = max(msxy) - min(msxy);
%Calculate Signal to Noise Ratio on the radial direction where P-wave energy
%should be maximized
S = var(vyrbaz);
N = var(noiseybaz);
SNR = S/N;

% Strings and Things

str={sprintf('Transverse component')...
     sprintf('Radial component')...
     sprintf('Rotated')...
     sprintf('Rotated')};

maxaxes= max([max(vxrbaz); max(vyrbaz); max(vxr); max(vyr)]);
minaxes= min([min(vxrbaz); min(vyrbaz); min(vxr); min(vyr)]);

%values for plotting P wave arrival line
pya = (minaxes:1:maxaxes);
pxa = ones(length(pya),1).*datenum(ptime);


% PLOTTING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clf

%Plot the transverse direction Pwindow
a(1)=subplot(4,2,1);
p(1)=plot(time,vxrbaz,'Color','r');
ylabel('Unrotated');

%Plot the radial direction P window and predicted P-wave arrival time
a(2)=subplot(4,2,2);
p(2)=plot(time,vyrbaz,'Color','r');
hold all;
pw(1)=plot(pxa,pya,'Color',[0 0.75 0.75]);
legend('Seismogram','PREM P wave arrival','Location','Best')

%Plot the rotated transverse direction Pwindow
a(3)=subplot(4,2,3);
p(3)=plot(time,vxr,'Color',[0.5 0 0]);
ylabel('Rotated');

%Plot the rotated radial direction P window
a(4)=subplot(4,2,4);
p(4)=plot(time,vyr,'Color',[0.5 0 0]);

%Plot the maxms values versus angle, indicate which had the best fit
a(5)=subplot(4,2,5);
p(5)=plot(gamav*(180/pi),msxy,'Color',[0 0.75 0.75]);
hold all;
scatter(maxg,maxms,'MarkerFaceColor','g','MarkerEdgeColor','g')
legend('mean squared values','maximum ms value','Location','Best')
t(5)=title('Angle of rotation vs. Mean squared values');
xlabel('Degrees rotated')
ylabel('(y^2-x^2/y^2+x^2)')

%define a vector of colors to write the signal to noise ratio in - the
%first color is if it's below the indicated threshold, the second is if
%above
color =[ 'r'; 'g'];

%This is where you define the signal to noise threshold and msamp threshold
if SNR > 3
colorind1 = 2;
else 
colorind1 = 1;
end

if msamp > 0.5
colorind2 = 2;
else 
colorind2 = 1;
end
%Plot various event and rotation data
hold all;
a(6)=subplot(4,2,6);
text(-0.35,1.2,'Event Information','FontSize',12,'Color','r')
text(-1,0.85,sprintf('%s/%s/%s at %s:%s',mo,dd,yyyy,hh,mm))
text(.25,0.85,sprintf('Magnitude %1.1f',mag))
text(-1,0.5,sprintf('Location %3.3f%c lat',evlat,char(176)))
text(.25,0.5,sprintf('%3.3f%c long',evlong,char(176)))
text(-1,0.15,sprintf('Depth %2.2f km',evdep))
text(.25,0.15,sprintf('Backazimuth %2.2f%c',baz,char(176)))
text(-1,-0.2,sprintf('Filter range %1.2f - %1.2f Hz',f1,f2 ))
text(.25,-0.2,sprintf('Distance %4.0f%c',evdistd,char(176)))
text(-1,-0.55,sprintf('MSV amplitude %2.2f',msamp),'Color',color(colorind2))
text(0.25,-0.55,sprintf('Signal/Noise %2.2f',SNR),'Color',color(colorind1))

text(-0.55,-1.4,sprintf('%2.2f%c',maxg,char(176)),'FontSize',40,'Color',[0 0.75 0.75])
axis([-1 1 -1 1])
axis off

%below I plot the whole two hour seismogram also outpu from cut2p. The if
%statements make sure that seismogram isn't NaN and also that the machine
%didn't mess up and record too few data points- it did this on a few days.
%In those cases this plot will just say ISSUE because the length of the
%seimogram is not the length of its time interval.
if length(seismogram)>1
   pys = min(seismoybaz):1:max(seismoybaz);
   pxa = ones(length(pys),1).*datenum(ptime);
end

if length(seismogram) >1 && length(seismogram) == length(seismot)
    a(7)=subplot(4,2,7:8);
    p(7)=plot(seismot,seismoybaz,'Linewidth',0.25,'Color','r');
    hold all;
    pw(2)=plot(pxa,pys,'Color',[0 0.75 0.75]);
    datetick('x',13)
    xlim([min(seismot) max(seismot)]);
    xlabel('Full two hour radial seismogram segment');
    movev(a(7),-.05)
else
    a(7)=subplot(4,2,7:8);
    text(.45,.5,'ISSUE','FontSize',20,'Color','r')
  
end

%Turn the color ind value of 1 or 2 into the output record value of 1 or 0
if colorind1 == 2 && colorind2 ==2
    record = 1;
else
    record = 0;
end

% LABELING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for in=1:4
    axes(a(in))
    datetick('x',13)
    t(in)=title(str{in});
  grid on
end

% Cosmetics
suptitle(sprintf('Event %s',CMT));

if length(vxr) > 1 && length(seismogram)>1;
set(a(1),'ylim',[minaxes maxaxes])
set(a(1),'xlim',([min(time) max(time)]));

set(a(2),'ylim',get(a(1),'ylim'))
set(a(2),'xlim',get(a(1),'xlim'))

set(a(3),'ylim',get(a(1),'ylim'))
set(a(4),'xlim',get(a(1),'xlim'))

set(a(4),'ylim',get(a(1),'ylim'))
set(a(4),'xlim',get(a(1),'xlim'))
set(a(1:4),'xlim',[min(time) max(time)])
axes(a(5)); box on
set(a(5),'ylim',[-1.1 1.1])
end

set(t,'FontWeight','normal')
longticks(a)
nolabels(a([2 4]),2)
nolabels(a([1 2]),1)
serre(a([1 2]),1/2,'across')
serre(a([3 4]),1/2,'across')
serre(a([5 6]),1/2,'across')


set(p(1:4),'LineWidth',1.5)
set(p(5),'LineWidth',2)

movev(a(6),-0.02)
xlabh = get(gca,'XLabel');
set(xlabh,'Position',get(xlabh,'Position')- [0 .2 0]);

% Last-minute things
delete(t(5))
delete(t(3))
delete(t(4))
print('-dpdf',sprintf('/Users/abrummen/Documents/Event_PDFs_30/%s',CMT))

end
