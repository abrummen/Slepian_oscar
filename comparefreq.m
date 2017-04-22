function [segdeconbp1,segdeconbp2,segdeconbp3,segdeconbp4,Ptime,pdp] = comparefreq(CMT,f1,f2,f3,f4,f5,f6,f7,f8,cmp,pmsec)
% UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
%
% INPUT:
%
%
% OUTPUT:
%
%
%
% Written by date

defval('CMT','C201609140158A')
defval('f1',.01)
defval('f2',.05)

defval('f3',.025)
defval('f4',.1)

defval('f5',.025)
defval('f6',.5)

defval('f7',1)
defval('f8',2)
defval('cmp','Y')
defval('pmsec',30)

yyyy = str2num(CMT(2:5));
mo = str2num(CMT(6:7));
dd = str2num(CMT(8:9));
hh = str2num(CMT(10:11));
mm = str2num(CMT(12:13));

mcinput = sprintf('%s%s%s%s%s',CMT(2:5),CMT(6:7),CMT(8:9),CMT(10:11),CMT(12:13));  

[segdeconbp1,t1,Ptime,Stime,pdp] = mccompmodes(mcinput,cmp,f1,f2,0);

[segdeconbp2,t2] = mccompmodes(mcinput,cmp,f3,f4,0);

[segdeconbp3,t3] = mccompmodes(mcinput,cmp,f5,f6,0);

[segdeconbp4,t4] = mccompmodes(mcinput,cmp,f7,f8,0);

py = min(segdeconbp1):1:max(segdeconbp1);
px = ones(1,length(py))*Ptime;

sy = min(segdeconbp1):1:max(segdeconbp1);
sx = ones(1,length(py))*Stime;

%Signal Window

windowlefts = (Ptime) - datenum([0 0 0 0 0 pmsec]);
windowrights = (Ptime) + datenum([0 0 0 0 0 pmsec]);

%%noisewindow?
windowleftn = (Ptime) - datenum([0 0 0 0 0 5*pmsec]);
windowrightn = (Ptime) - datenum([0 0 0 0 0 3*pmsec]);

% PLOTTING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clf;

a(1) = subplot(4,1,1);
p(1) = plot(t1,segdeconbp1,'k');
hold all;
pp(1)=plot(px,py);
%ps(1)=plot(sx,sy);
pwls(1)=plot(ones(1,length(py))*windowlefts,sy,'b');
pwrs(1)=plot(ones(1,length(py))*windowrights,sy,'b');
pwln(1)=plot(ones(1,length(py))*windowleftn,sy,'g');
pwrn(1)=plot(ones(1,length(py))*windowrightn,sy,'g');
datetick('x',13)

%Signal to Noise

Sig1 = segdeconbp1((pdp-(pmsec/0.01)):(pdp+(pmsec/0.01)));
Noise1 = segdeconbp1((pdp-5*pmsec/0.01):(pdp-3*pmsec/0.01))

SNR1 = var(Sig1)/var(Noise1);
title(sprintf('Seismogram Filtered between %2.2f - %2.2f Hz, %2.2f - %2.2f s, SNR %2.2f',f1,f2,(1/f2),(1/f1),SNR1));

%%%%%%%%%%
py2 = min(segdeconbp2):1:max(segdeconbp2);
px2 = ones(1,length(py2))*Ptime;

a(2) = subplot(4,1,2);
pp(2)=plot(px2,py2);
hold all;
p(2) = plot(t2,segdeconbp2,'k');
pwls(2)=plot(ones(1,length(py2))*windowlefts,py2,'b');
pwrs(2)=plot(ones(1,length(py2))*windowrights,py2,'b');
pwln(2)=plot(ones(1,length(py2))*windowleftn,py2,'g');
pwrn(2)=plot(ones(1,length(py2))*windowrightn,py2,'g');
datetick('x',13)


legend('PREM P wave arrival','Seismogram','Signal Window Left Bound','Signal Window Right Bound','Noise Window Left Bound','Noise Window  Right Bound','Location','southeast')

Sig2 = segdeconbp2((pdp-(pmsec/0.01)):(pdp+(pmsec/0.01)));
Noise2 = segdeconbp2((pdp-5*pmsec/0.01):(pdp-3*pmsec/0.01));

SNR2 = var(Sig2)/var(Noise2);
title(sprintf('Seismogram Filtered between %2.2f - %2.2f Hz, %2.2f - %2.2f s, SNR %2.2f',f3,f4,(1/f4),(1/f3),SNR2));

%%%%%%%%%%%
py3 = min(segdeconbp3):1:max(segdeconbp3);
px3 = ones(1,length(py3))*Ptime;

a(3) = subplot(4,1,3);
pp(3)=plot(px3,py3);
hold all;
p(3) = plot(t3,segdeconbp3,'k');
pwls(3)=plot(ones(1,length(py3))*windowlefts,py3,'b');
pwrs(3)=plot(ones(1,length(py3))*windowrights,py3,'b');
pwln(3)=plot(ones(1,length(py3))*windowleftn,py3,'g');
pwrn(3)=plot(ones(1,length(py3))*windowrightn,py3,'g');
datetick('x',13)

Sig3 = segdeconbp3((pdp-(pmsec/0.01)):(pdp+(pmsec/0.01)));
Noise3 = segdeconbp3((pdp-5*pmsec/0.01):(pdp-3*pmsec/0.01));

SNR3 = var(Sig3)/var(Noise3);
title(sprintf('Seismogram Filtered between %2.2f - %2.2f Hz, %2.2f - %2.2f s, SNR %2.2f',f5,f6,(1/f6),(1/f5),SNR3));

%%%%%%%%%%%
py4 = min(segdeconbp4):1:max(segdeconbp4);
px4 = ones(1,length(py4))*Ptime;

a(4) = subplot(4,1,4);
pp(4)=plot(px4,py4);
hold all;
p(4) = plot(t4,segdeconbp4,'k');
pwls(4)=plot(ones(1,length(py4))*windowlefts,py4,'b');
pwrs(4)=plot(ones(1,length(py4))*windowrights,py4,'b');
pwln(4)=plot(ones(1,length(py4))*windowleftn,py4,'g');
pwrn(4)=plot(ones(1,length(py4))*windowrightn,py4,'g');
xlabel('Time')
ylabel('Amplitude')
datetick('x',13)

Sig4 = segdeconbp4((pdp-(pmsec/0.01)):(pdp+(pmsec/0.01)));
Noise4 = segdeconbp4((pdp-5*pmsec/0.01):(pdp-3*pmsec/0.01));

SNR4 = var(Sig4)/var(Noise4);
title(sprintf('Seismogram Filtered between %2.2f - %2.2f Hz, %2.2f - %2.2f s, SNR %2.2f',f7,f8,(1/f8),(1/f7),SNR4));

suptitle(sprintf('Different Filter Bands for Event %s',CMT))

print('-dpdf',sprintf('/Users/abrummen/Documents/Event_Filters/%s',CMT))

keyboard




end
