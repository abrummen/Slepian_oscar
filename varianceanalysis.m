load('/Users/abrummen/Documents/varianceTot.mat')
load('/Users/abrummen/Documents/variance1ag.mat')
v2 = v4(:,73:144);

UTCvec1 = [5:1:23 0:1:4];



vjulx = v1(1:31,1:24);
vjuly = v1(1:31,25:48);
vjulz = v1(1:31,49:72);
vjulh = sqrt(vjulx.^2 + vjuly.^2);

vaugx = v1(32:62,1:24);
vaugy = v1(32:62,25:48);
vaugz = v1(32:62,49:72);
vaugh = sqrt(vaugx.^2 + vaugy.^2);

vsepx = v1(63:92,1:24);
vsepy = v1(63:92,25:48);
vsepz = v1(63:92,49:72);
vseph = sqrt(vsepx.^2 + vsepy.^2);

voctx = v1(93:116,1:24);
vocty = v1(93:116,25:48);
voctz = v1(93:116,49:72);
vocth = sqrt(voctx.^2 + vocty.^2);

vjanx = v2(1:31,1:24);
vjany = v2(1:31,25:48);
vjanz = v2(1:31,49:72);
vjanh = sqrt(vjanx.^2 + vjany.^2);

vfebx = v2(32:59,1:24);
vfeby = v2((32):(59),25:48);
vfebz = v2((32):(59),49:72);
vfebh = sqrt(vfebx.^2 + vfeby.^2);

vmarx = v2(60:90,1:24);
vmary = v2(60:90,25:48);
vmarz = v2(60:90,49:72);
vmarh = sqrt(vmarx.^2 + vmary.^2);

[julza2] = rmoutlier(vjulz);
[julza1] = rmoutlier(julza2);
[julza] = rmoutlier(julza1);

[julha] = rmoutlier(vjulh);

[augza1] = rmoutlier(vaugz);
[augza] = rmoutlier(augza1);

[augha1] = rmoutlier(vaugh);
[augha] = rmoutlier(augha1);

[sepza2] = rmoutlier(vsepz);
[sepza1] = rmoutlier(sepza2);
[sepza] = rmoutlier(sepza1);

[sepha1] = rmoutlier(vseph);
[sepha] = rmoutlier(sepha1);

[octza1] = rmoutlier(voctz);
[octza] = rmoutlier(octza1);

[octha] = rmoutlier(vocth);
 
[janza2] = rmoutlier(vjanz); 
[janza1] = rmoutlier(janza2); 
[janza] = rmoutlier(janza1); 

[janha1] = rmoutlier(vjanh);
[janha] = rmoutlier(janha1);

[febza4] = rmoutlier(vfebz); 
[febza3] = rmoutlier(febza4); 
[febza2] = rmoutlier(febza3); 
[febza1] = rmoutlier(febza2); 
[febza] = rmoutlier(febza1); 

[febha1] = rmoutlier(vfebh);
[febha] = rmoutlier(febha1);

[marza3] = rmoutlier(vmarz);
[marza2] = rmoutlier(marza3); 
[marza1] = rmoutlier(marza2);  
[marza] = rmoutlier(marza1); 

[marha2] = rmoutlier(vmarh);
[marha1] = rmoutlier(marha2);
[marha] = rmoutlier(marha1);
keyboard

for i = 1:24
    sumavjulz(i) = sum(julza(~isnan(julza(:,i)),i))/length(~isnan(julza(:,i)));
    sumavaugz(i) = sum(augza(~isnan(augza(:,i)),i))/length(~isnan(augza(:,i)));
    sumavsepz(i) = sum(sepza(~isnan(sepza(:,i)),i))/length(~isnan(sepza(:,i)));
    sumavoctz(i) = sum(octza(~isnan(octza(:,i)),i))/length(~isnan(octza(:,i)));
    sumavjanz(i) = sum(janza(~isnan(janza(:,i)),i))/length(~isnan(janza(:,i)));
    sumavfebz(i) = sum(febza(~isnan(febza(:,i)),i))/length(~isnan(febza(:,i)));
    sumavmarz(i) = sum(marza(~isnan(marza(:,i)),i))/length(~isnan(marza(:,i)));
    sumavjulh(i) = sum(julha(~isnan(julha(:,i)),i))/length(~isnan(julha(:,i)));
    sumavaugh(i) = sum(augha(~isnan(augha(:,i)),i))/length(~isnan(augha(:,i)));
    sumavseph(i) = sum(sepha(~isnan(sepha(:,i)),i))/length(~isnan(sepha(:,i)));
    sumavocth(i) = sum(octha(~isnan(octha(:,i)),i))/length(~isnan(octha(:,i)));
    sumavjanh(i) = sum(janha(~isnan(janha(:,i)),i))/length(~isnan(janha(:,i)));
    sumavfebh(i) = sum(febha(~isnan(febha(:,i)),i))/length(~isnan(febha(:,i)));
    sumavmarh(i) = sum(marha(~isnan(marha(:,i)),i))/length(~isnan(marha(:,i)));
end

for i = 1:24
   % sumtotalz(i) = sumavjulz(i) + sumavaugz(i) + sumavsepz(i) + sumavoctz(i)...
    %    + sumavjanz(i)+ sumavfebz + sumavmarz;
end

%     idx = false(31,1);
%     idx(1:7) = true;
%  augweek1(i) = sum(augza(~isnan(augza(:,i))& idx,i))/length(~isnan(augza(1:7,i)));


weekdatajulz = [julza(1,:); julza(4:8,:); julza(11:15,:); julza(18:22,:); julza(25:29,:)];
nweekdatajulz = [julza(2:3,:); julza(9:10,:); julza(16:17,:); julza(23:24,:); julza(30:31,:)];

weekdataaugz = [augza(1:5,:); augza(8:12,:); augza(15:19,:); augza(22:26,:); augza(29:31,:)];
nweekdataaugz = [augza(6:7,:); augza(13:14,:); augza(20:21,:); augza(27:28,:)];

weekdatasepz = [sepza(1:2,:); sepza(5:9,:); sepza(12:16,:); sepza(19:23,:); sepza(26:30,:)];
nweekdatasepz = [sepza(3:4,:); sepza(10:11,:); sepza(17:18,:); sepza(24:25,:)];

weekdataoctz = [octza(3:7,:); octza(10:14,:); octza(17:21,:)];
nweekdataoctz = [octza(1:2,:); octza(8:9,:); octza(15:16,:); octza(22:23,:)];

weekdatajanz = [janza(2:6,:); janza(9:13,:); janza(16:20,:); janza(23:27,:); janza(30:31,:)];
nweekdatajanz = [janza(1,:); janza(14:15,:); janza(21:22,:); janza(28:29,:)];

weekdatafebz = [ febza(6:10,:); febza(13:17,:); febza(20:24,:); febza(27:28,:)];
nweekdatafebz = [febza(4:5,:); febza(11:12,:); febza(18:19,:); febza(25:26,:)];
weekdatamarz = [marza(1:3,:); marza(6:10,:); marza(13:17,:); marza(20:24,:); marza(27:31,:)];
nweekdatamarz = [marza(4:5,:); marza(11:12,:); marza(18:19,:); marza(25:26,:)];

bfschoolwz = sepza(1:11,:);
afschoolwz = [sepza(12:16,:); sepza(19:23,:); sepza(26:30,:)];
cnbreakz = [janza(9:13,:); janza(16:20,:); janza(23:27,:); janza(30:31,:)];
cbreakz = janza(1:8,:);
sbreakz = marza(18:26,:);
snbreakz = [marza(1:3,:); marza(6:10,:); marza(13:17,:); marza(27:31,:)];
bdsavingz = [marza(1:3,:); marza(6:10,:)];
adsavingz = [marza(13:17,:); marza(18:26,:); marza(27:31,:)];

for i = 1:24
    sumavweekjulz(i) = sum(weekdatajulz(~isnan(weekdatajulz(:,i)),i))/length(~isnan(weekdatajulz(:,i)));
    sumavnweekjulz(i) = sum(nweekdatajulz(~isnan(nweekdatajulz(:,i)),i))/length(~isnan(nweekdatajulz(:,i)));
    sumavweekaugz(i) = sum(weekdataaugz(~isnan(weekdataaugz(:,i)),i))/length(~isnan(weekdataaugz(:,i)));
    sumavnweekaugz(i) = sum(nweekdataaugz(~isnan(nweekdataaugz(:,i)),i))/length(~isnan(nweekdataaugz(:,i))); 
    sumavfbschoolwz(i) = sum(bfschoolwz(~isnan(bfschoolwz(:,i)),i))/length(~isnan(bfschoolwz(:,i)));
    sumavfaschoolwz(i) = sum(afschoolwz(~isnan(afschoolwz(:,i)),i))/length(~isnan(afschoolwz(:,i)));
    sumavweeksepz(i) = sum(weekdatasepz(~isnan(weekdatasepz(:,i)),i))/length(~isnan(weekdatasepz(:,i)));
    sumavnweeksepz(i) = sum(nweekdatasepz(~isnan(nweekdatasepz(:,i)),i))/length(~isnan(nweekdatasepz(:,i)));
    sumavweekoctz(i) = sum(weekdataoctz(~isnan(weekdataoctz(:,i)),i))/length(~isnan(weekdataoctz(:,i)));
    sumavnweekoctz(i) = sum(nweekdataoctz(~isnan(nweekdataoctz(:,i)),i))/length(~isnan(nweekdataoctz(:,i)));
    sumavweekjanz(i) = sum(weekdatajanz(~isnan(weekdatajanz(:,i)),i))/length(~isnan(weekdatajanz(:,i)));
    sumavnweekjanz(i) = sum(nweekdatajanz(~isnan(nweekdatajanz(:,i)),i))/length(~isnan(nweekdatajanz(:,i)));
    sumavcbreakz(i) = sum(cbreakz(~isnan(cbreakz(:,i)),i))/length(~isnan(cbreakz(:,i)));
    sumavcnbreakz(i) = sum(cnbreakz(~isnan(cnbreakz(:,i)),i))/length(~isnan(cnbreakz(:,i)));
    sumavweekfebz(i) = sum(weekdatafebz(~isnan(weekdatafebz(:,i)),i))/length(~isnan(weekdatafebz(:,i)));
    sumavnweekfebz(i) = sum(nweekdatafebz(~isnan(nweekdatafebz(:,i)),i))/length(~isnan(nweekdatafebz(:,i)));
    sumavweekmarz(i) = sum(weekdatamarz(~isnan(weekdatamarz(:,i)),i))/length(~isnan(weekdatamarz(:,i)));
    sumavnweekmarz(i) = sum(nweekdatamarz(~isnan(nweekdatamarz(:,i)),i))/length(~isnan(nweekdatamarz(:,i)));
    sumavsbreakz(i) = sum(sbreakz(~isnan(sbreakz(:,i)),i))/length(~isnan(sbreakz(:,i)));
    sumavsnbreakz(i) = sum(snbreakz(~isnan(snbreakz(:,i)),i))/length(~isnan(snbreakz(:,i)));
    sumavbdsavingz(i) = sum(bdsavingz(~isnan(bdsavingz(:,i)),i))/length(~isnan(bdsavingz(:,i)));
    sumavadsavingz(i) = sum(adsavingz(~isnan(adsavingz(:,i)),i))/length(~isnan(adsavingz(:,i)));

end

%Daylight savings
%Friday 17th March 11:47- Jessica and her class went down but not as the
%small interactions clearly dont mess it up
%do something like 10-20 Hz why not- see if signals coming through 

figure(1)
clf

subplot(4,2,1)
hold on
plot(prctile(utc2est(julza),[90]),'color',[0.9 0.9 .9]/0.9*0.7,'linewidth',1)
plot(prctile(utc2est(julza),[75]),'color',[0.9 0.9 .9],'linewidth',1)
plot(prctile(utc2est(julza),[50]),'color',[00  0 0],'linewidth',2)
plot(1:24,utc2est(sumavjulz))
%plot(prctile(julza,[25]),'color',[0.9 0.9 .9],'linewidth',1)
%plot(prctile(julza,[10]),'color',[0.9 0.9 .9]/0.9*0.7,'linewidth',1)
set(gca,'xtick',[0 6 8 18 20],'xlim',[1 24],'ylim',[0 15e15])
%set(gca,'yscale','log')
title('July (vertical)')

h = legend('95% of the variance','75% of the variance','50% of the variance','Mean');
set(h,'FontSize',12);


subplot(4,2,2)
hold on
plot(prctile(utc2est(augza),[90]),'color',[0.9 0.9 .9]/0.9*0.7,'linewidth',1)
plot(prctile(utc2est(augza),[75]),'color',[0.9 0.9 .9],'linewidth',1)
plot(prctile(utc2est(augza),[50]),'color',[00  0 0],'linewidth',2)
plot(1:24,utc2est(sumavaugz))
%plot(prctile(augza,[25]),'color',[0.9 0.9 .9],'linewidth',1)
%plot(prctile(augza,[10]),'color',[0.9 0.9 .9]/0.9*0.7,'linewidth',1)
set(gca,'xtick',[0 6 8 18 20],'xlim',[1 24],'ylim',[0 15e15])
%set(gca,'yscale','log')
title('August (vertical)')


subplot(4,2,3)

hold on
plot(prctile(utc2est(sepza),[90]),'color',[0.9 0.9 .9]/0.9*0.7,'linewidth',1)
plot(prctile(utc2est(sepza),[75]),'color',[0.9 0.9 .9],'linewidth',1)
plot(prctile(utc2est(sepza),[50]),'color',[00  0 0],'linewidth',2)
%plot(prctile(sepza,[25]),'color',[0.9 0.9 .9],'linewidth',1)
%plot(prctile(sepza,[10]),'color',[0.9 0.9 .9]/0.9*0.7,'linewidth',1)
set(gca,'xtick',[0 6 8 18 20],'xlim',[1 24],'ylim',[0 15e15])
%set(gca,'yscale','log')
title('September (vertical)')
plot(1:24,utc2est(sumavsepz))
ylabel('monthly variance of the daily variance','fontsize',14)

subplot(4,2,4)

hold on
plot(prctile(utc2est(octza),[90]),'color',[0.9 0.9 .9]/0.9*0.7,'linewidth',1)
plot(prctile(utc2est(octza),[75]),'color',[0.9 0.9 .9],'linewidth',1)
plot(prctile(utc2est(octza),[50]),'color',[00  0 0],'linewidth',2)
%plot(prctile(octza,[25]),'color',[0.9 0.9 .9],'linewidth',1)
%plot(prctile(octza,[10]),'color',[0.9 0.9 .9]/0.9*0.7,'linewidth',1)
set(gca,'xtick',[0 6 8 18 20],'xlim',[1 24],'ylim',[0 15e15])
%set(gca,'yscale','log')
title('October (vertical)')
plot(1:24,utc2est(sumavoctz))

subplot(4,2,5)

hold on
plot(prctile(utc2est(janza),[90]),'color',[0.9 0.9 .9]/0.9*0.7,'linewidth',1)
plot(prctile(utc2est(janza),[75]),'color',[0.9 0.9 .9],'linewidth',1)
plot(prctile(utc2est(janza),[50]),'color',[00  0 0],'linewidth',2)
%plot(prctile(janza,[25]),'color',[0.9 0.9 .9],'linewidth',1)
%plot(prctile(janza,[10]),'color',[0.9 0.9 .9]/0.9*0.7,'linewidth',1)
set(gca,'xtick',[0 6 8 18 20],'xlim',[1 24],'ylim',[0 15e15])
%set(gca,'yscale','log')
title('January (vertical)')
plot(1:24,utc2est(sumavjanz))
subplot(4,2,6)

hold on
plot(prctile(utc2est(febza),[90]),'color',[0.9 0.9 .9]/0.9*0.7,'linewidth',1)
plot(prctile(utc2est(febza),[75]),'color',[0.9 0.9 .9],'linewidth',1)
plot(prctile(utc2est(febza),[50]),'color',[00  0 0],'linewidth',2)
%plot(prctile(febza,[25]),'color',[0.9 0.9 .9],'linewidth',1)
%plot(prctile(febza,[10]),'color',[0.9 0.9 .9]/0.9*0.7,'linewidth',1);
set(gca,'xtick',[0 6 8 18 20],'xlim',[1 24],'ylim',[0 15e15])
%set(gca,'yscale','log')
title('February (vertical)')
plot(1:24,utc2est(sumavfebz))
xlabel('hours of the day (EST)','fontsize',14)

subplot(4,2,7)

hold on
plot(prctile(utc2est(marza),[90]),'color',[0.9 0.9 .9]/0.9*0.7,'linewidth',1)
plot(prctile(utc2est(marza),[75]),'color',[0.9 0.9 .9],'linewidth',1)
plot(prctile(utc2est(marza),[50]),'color',[00  0 0],'linewidth',2)
%plot(prctile(marza,[25]),'color',[0.9 0.9 .9],'linewidth',1)
%plot(prctile(marza,[10]),'color',[0.9 0.9 .9]/0.9*0.7,'linewidth',1)
set(gca,'xtick',[0 6 8 18 20],'xlim',[1 24],'ylim',[0 15e15])
%set(gca,'yscale','log')
title('March (vertical)')
plot(1:24,utc2est(sumavmarz))




figure(2)
clf
plot(1:24,utc2est(sumavfbschoolwz),'linewidth',2)
hold on
plot(1:24,utc2est(sumavfaschoolwz),'linewidth',2)
h1 = legend('variance before school starts','variance from first week of school');
set(h1,'fontsize',12)
set(gca,'xtick',[0 6 8 18 20],'xlim',[1 24],'ylim',[0 6e15])
xlabel('hours of the day (EST)','fontsize',14)
ylabel('monthly variance of the daily variance','fontsize',14)


figure(3)
clf
plot(1:24,utc2est(sumavbdsavingz),'linewidth',2)
hold on
plot(1:24,utc2est(sumavadsavingz),'linewidth',2)
h2 = legend('variance before turning clocks forward','variance after time change');
set(h2,'fontsize',12)
set(gca,'xtick',[0 6 9 10 18 20],'xlim',[1 24],'ylim',[0 5e15])
y = 0:1e10:5e15;
x1 = ones(length(y),1)*9;
x2 = ones(length(y),1)*10;
plot(x1,y,'--','color','k','linewidth',0.1)
plot(x2,y,'--','color','k','linewidth',0.1)
xlabel('hours of the day (EST)','fontsize',14)
ylabel('monthly variance of the daily variance','fontsize',14)

figure(4)
clf
subplot(4,2,1)
title('July')
plot(1:24,utc2est(sumavweekjulz),'linewidth',1)
hold on
plot(1:24,utc2est(sumavnweekjulz),'linewidth',1)
title('July')
h3 = legend('variance Mon-Fri','variance Sat-Sun');
set(h3,'fontsize',12);
set(gca,'xtick',[0 6 8 18 20],'xlim',[1 24],'ylim',[0 4e15])

subplot(4,2,2)
title('August')
plot(1:24,utc2est(sumavweekaugz),'linewidth',1)
hold on
plot(1:24,utc2est(sumavnweekaugz),'linewidth',1)
title('August')
set(gca,'xtick',[0 6 8 18 20],'xlim',[1 24],'ylim',[0 4e15])

subplot(4,2,3)
title('September')
plot(1:24,utc2est(sumavweeksepz),'linewidth',1)
hold on
plot(1:24,utc2est(sumavnweeksepz),'linewidth',1)
title('September')
set(gca,'xtick',[0 6 8 18 20],'xlim',[1 24],'ylim',[0 4e15])
ylabel('monthly variance of the daily variance','fontsize',14)

subplot(4,2,4)
title('October')
plot(1:24,utc2est(sumavweekoctz),'linewidth',1)
hold on
plot(1:24,utc2est(sumavnweekoctz),'linewidth',1)
title('October')
set(gca,'xtick',[0 6 8 18 20],'xlim',[1 24],'ylim',[0 4e15])

subplot(4,2,5)
title('January')
plot(1:24,utc2est(sumavweekjanz),'linewidth',1)
hold on
plot(1:24,utc2est(sumavnweekjanz),'linewidth',1)
title('January')
set(gca,'xtick',[0 6 8 18 20],'xlim',[1 24],'ylim',[0 4e15])

subplot(4,2,6)
title('February')
plot(1:24,utc2est(sumavweekfebz),'linewidth',1)
hold on
plot(1:24,utc2est(sumavnweekfebz),'linewidth',1)
title('February')
set(gca,'xtick',[0 6 8 18 20],'xlim',[1 24],'ylim',[0 4e15])
xlabel('hours of the day (EST)','fontsize',14)

subplot(4,2,7)
title('March')
plot(1:24,utc2est(sumavweekmarz),'linewidth',1)
hold on
plot(1:24,utc2est(sumavnweekmarz),'linewidth',1)
title('March')
set(gca,'xtick',[0 6 8 18 20],'xlim',[1 24],'ylim',[0 4e15])


