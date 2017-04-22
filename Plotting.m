load('/Users/abrummen/Documents/ThesisData/badTotal30M.mat')
load('/Users/abrummen/Documents/ThesisData/goodTotal30m.mat')

gooddistdeg = km2deg(gooddist);
baddistdeg = km2deg(baddist);

% Define North, South, East, and West indexes
%for the 'goodangles'
Ni1 = goodbaz <= 45;
Ni2 = goodbaz >= 315;
Ei = goodbaz > 45 & goodbaz < 135;
Si = goodbaz >= 135 & goodbaz <= 225;
Wi = goodbaz > 225 & goodbaz < 315;

Nib1 = badbaz <= 45;
Nib2 = badbaz >= 315;
Eib = badbaz > 45 & badbaz < 135;
Sib = badbaz >= 135 & badbaz <= 225;
Wib = badbaz > 225 & badbaz < 315;

% Now apply the indexes to extract the data points fo each variable

N1a = goodangles(Ni1);
N2a = goodangles(Ni2);
Ea = goodangles(Ei);
Sa = goodangles(Si);
Wa = goodangles(Wi);

N1di = gooddistdeg(Ni1);
N2di = gooddistdeg(Ni2);
Edi = gooddistdeg(Ei);
Sdi = gooddistdeg(Si);
Wdi = gooddistdeg(Wi);

N1m = goodmag(Ni1);
N2m = goodmag(Ni2);
Em = goodmag(Ei);
Sm = goodmag(Si);
Wm = goodmag(Wi);

N1b = goodbaz(Ni1);
N2b = goodbaz(Ni2);
Edb = goodbaz(Ei);
Sdb = goodbaz(Si);
Wdb = goodbaz(Wi);

N1de = gooddep(Ni1);
N2de = gooddep(Ni2);
Ede = gooddep(Ei);
Sde = gooddep(Si);
Wde = gooddep(Wi);

Nde = [N1de N2de];
Nm = [N1m N2m];
Ndi = [N1di N2di];
Nb = [N1b N2b];
Na = [N1a N2a];

Nb1a = badangles1(Nib1);
Nb2a = badangles1(Nib2);
Eba = badangles1(Eib);
Sba = badangles1(Sib);
Wba = badangles1(Wib);

Nb1m = badmag(Nib1);
Nb2m = badmag(Nib2);
Ebm = badmag(Eib);
Sbm = badmag(Sib);
Wbm = badmag(Wib);

N1bb = badbaz(Nib1);
N2bb = badbaz(Nib2);
Edbb = badbaz(Eib);
Sdbb = badbaz(Sib);
Wdbb = badbaz(Wib);


Nb1di = baddistdeg(Nib1);
Nb2di = baddistdeg(Nib2);
Ebdi = baddistdeg(Eib);
Sbdi = baddistdeg(Sib);
Wbdi = baddistdeg(Wib);

Nb1s = badSNR(Nib1);
Nb2s = badSNR(Nib2);
Ebs = badSNR(Eib);
Sbs = badSNR(Sib);
Wbs = badSNR(Wib);

Nbm = [Nb1m Nb2m];
Nbdi = [Nb1di Nb2di];
Nba = [Nb1a Nb2a];
Nbs = [Nb1s Nb2s];


% Nb1de = baddep(Nib1);
% Nb2de = baddep(Nib2);
% Ebde = baddep(Ebi);
% Sbde = baddep(Sbi);
% Wbde = baddep(Wbi);

% Now do the same for SNR
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
       
indexSNR1 = goodSNR>= 3 & goodSNR < 10;
indexSNR2 = goodSNR >= 10 & goodSNR < 100;
indexSNR3 = goodSNR >= 100 & goodSNR < 1000;
indexSNR4 = goodSNR >= 1000;

good1 = gooddistdeg(indexSNR1);
good2 = gooddistdeg(indexSNR2);
good3 = gooddistdeg(indexSNR3);
good4 = gooddistdeg(indexSNR4);

goodm1 = goodmag(indexSNR1);
goodm2 = goodmag(indexSNR2);
goodm3 = goodmag(indexSNR3);
goodm4 = goodmag(indexSNR4);

indexbadf = isnan(badSNR);
indexbadp = ~isnan(badSNR); 

indexbadfN = isnan(Nbs);
indexbadpN = ~isnan(Nbs);
indexbadfE = isnan(Ebs);
indexbadpE = ~isnan(Ebs);
indexbadfS = isnan(Sbs);
indexbadpS = ~isnan(Sbs);
indexbadfW = isnan(Wbs);
indexbadpW = ~isnan(Wbs);

Nbfm = Nbm(indexbadfN); 
Ebfm = Ebm(indexbadfE);
Sbfm = Sbm(indexbadfS);
Wbfm = Wbm(indexbadfW);

Nbfdi = Nbdi(indexbadfN); 
Ebfdi = Ebdi(indexbadfE);
Sbfdi = Sbdi(indexbadfS);
Wbfdi = Wbdi(indexbadfW);

Nbpm = Nbm(indexbadpN); 
Ebpm = Ebm(indexbadpE);
Sbpm = Sbm(indexbadpS);
Wbpm = Wbm(indexbadpW);

Nbpdi = Nbdi(indexbadpN); 
Ebpdi = Ebdi(indexbadpE);
Sbpdi = Sbdi(indexbadpS);
Wbpdi = Wbdi(indexbadpW);

badf = (baddistdeg(indexbadf));
badp = (baddistdeg(indexbadp));

badmf = (badmag(indexbadf));
badmp = (badmag(indexbadp));


figure(1)
clf;
histogram(goodangles,25)
xlim([-55 15])
text(-22,5.5,'Peak BinEdges: -26.0, -23.4','Fontsize',18)
text(-22,5.2,'Total Data Points: 31','Fontsize',18)
xlabel('Degrees of Rotation','fontsize',16)
ylabel('Number of Events','fontsize',16)
hold all;

figure(2)
clf
scatter(goodm1,good1,50,'g','filled')
hold all;
scatter(goodm2,good2,80,'g','filled')
scatter(goodm3,good3,110,'g','filled')
scatter(goodm4,good4,140,'g','filled')

scatter(badmp,badp,20,'r','filled')
scatter(badmf,badf,20,'k','filled')
xlim([5 8.5]) 
xlabel('Event Magnitude','fontsize',16)
ylabel('Event Distance (degrees)','fontsize',16)
x = 5:0.1:8.5;
y = ones(length(5:0.1:8.5),1)*100;
plot(x,y,'--','Color','k')

[h,icons,plots,legend_text] = legend('3<SNR<10','10<SNR<100','100<SNR<1000','1000<SNR','SNR<3','no P arrival','Limit of P arrival');
set(h,'FontSize',12);
m = 6;
for k = 8:13
    if m == 14
        n = 4;
        icons(k).Children.MarkerSize = n;
    else
        icons(k).Children.MarkerSize = m;
        m = m + 2;
    end
end

figure(3)
clf;
hold all;
scatter(3,-20,'g','o','filled')
scatter(3,-20,'r','o','filled')
scatter(3,-20,'k','o','filled')

scatter(Nbfm,Nbfdi,'k','o')
scatter(Ebfm,Ebfdi,'k','x')
scatter(Sbfm,Sbfdi,'k','*')
scatter(Wbfm,Wbfdi,'k','d')
plot(x,y,'--','Color','k')
scatter(Nm,Ndi,'g','o')
scatter(Em,Edi,'g','x')
scatter(Sm,Sdi,'g','*')
scatter(Wm,Wdi,'g','d')
scatter(Nbpm,Nbpdi,'r','o')
scatter(Ebpm,Ebpdi,'r','x')
scatter(Sbpm,Sbpdi,'r','*')
scatter(Wbpm,Wbpdi,'r','d')

ylim([0 180])
xlim([5 8.5])

xlabel('Event Magnitude','fontsize',16)
ylabel('Event Distance (degrees)','fontsize',16)

h1 = legend('SNR>3','SNR<3','No P arrival','Northern Events','Eastern Events',...
    'Southern Events', 'Western Events','Limit of P arrival');
set(h1,'FontSize',12);
keyboard

figure(4)
clf
nin = goodangles < 0;
nangles = -goodangles(nin);
pin = goodangles > 0;
pangle = goodangles(pin);
goodbazpi = goodbaz*(pi/180);
pbaz = goodbazpi(pin);
nbaz = goodbazpi(nin);

x2 = (1:1:360)*(pi/180);
y2 = -23.4*(ones(length(1:1:360),1));
y1 = -26*(ones(length(1:1:360),1));

polarscatter(nbaz,nangles,'o','b')
hold all;
polarscatter(pbaz,pangle,'o','r')

a = 0:1:60;
eb = 45*(pi/180)*ones(length(ea),1);
sb = 135*(pi/180)*ones(length(ea),1);
wb = 225*(pi/180)*ones(length(ea),1);
nb = 315*(pi/180)*ones(length(ea),1);

polarplot(x2,y2,'k')
 polarplot(eb,a,'--','color','k');
polarplot(x2,y1,'k')
 
 polarplot(sb,a,'--','color','k');
 polarplot(wb,a,'--','color','k');
 polarplot(nb,a,'--','color','k');

h2 = legend('Events with negative rotation values','Events with positive rotation values',...
    'Peak Histogram BinEdges','Cardinal direction boundaries');

set(h2,'FontSize',12);

ax1 = gca;

ax1.ThetaDir = 'clockwise';

ax1.ThetaZeroLocation = 'top';



figure(5)
clf

gooddistn = gooddistdeg(nin);

indexdi1 = gooddistn <= 20;
indexdi2 = 20 < gooddistn & gooddistn <= 40;
indexdi3 = 40 < gooddistn & gooddistn <= 60;
indexdi4 = 60 < gooddistn & gooddistn <= 80;
indexdi5 = 80 < gooddistn & gooddistn <= 100;

goodad1 = nangles(indexdi1);
goodad2 = nangles(indexdi2);
goodad3 = nangles(indexdi3);
goodad4 = nangles(indexdi4);
goodad5 = nangles(indexdi5);

goodbd1 = nbaz(indexdi1);
goodbd2 = nbaz(indexdi2);
goodbd3 = nbaz(indexdi3);
goodbd4 = nbaz(indexdi4);
goodbd5 = nbaz(indexdi5);

polarscatter(goodbd1,goodad1,'o','b')
hold all;
polarscatter(goodbd2,goodad2,'.','b')
polarscatter(goodbd3,goodad3,'*','b')
polarscatter(goodbd4,goodad4,'x','b')
polarscatter(goodbd5,goodad5,'d','b')
polarplot(eb,a,'--','color','k');
polarscatter(goodbazpi(pin),goodangles(pin),'x','r')
polarplot(sb,a,'--','color','k');
polarplot(wb,a,'--','color','k');
polarplot(nb,a,'--','color','k');

h3 = legend('distance < 20 degrees','20 < distance < 40 degrees',...
    '40 < distance < 60 degrees','60 < distance < 80 degrees',...
    '80 < distance < 100 degrees','cardinal direction boundaries');
set(h3,'FontSize',12);
ax = gca;
d = ax.ThetaDir;
ax.ThetaDir = 'clockwise';
l = ax.ThetaZeroLocation;
ax.ThetaZeroLocation = 'top';

keyboard
figure(6)
scatter(Sdi,Sa,'filled')
xlabel('Event Distance','fontsize',16)
ylabel('Rotation Angle','fontsize',16)
h4 = legend('Southern Events');
set(h4,'FontSize',12);

figure(7)
scatter(Sde,Sa,'filled')
xlabel('Event Depth','fontsize',16)
ylabel('Rotation Angle','fontsize',16)
h5 = legend('Southern Events');
set(h5,'FontSize',12);

figure(8)
clf
nindexSNR1 = logical(indexSNR1(nin));
nindexSNR2 = logical(indexSNR2(nin));
nindexSNR3 = logical(indexSNR3(nin));
nindexSNR4 = logical(indexSNR4(nin));

ngoodbazpi = goodbazpi(nin);
polarscatter(ngoodbazpi(nindexSNR1),nangles(nindexSNR1),'.');
hold on
polarscatter(ngoodbazpi(nindexSNR2),nangles(nindexSNR2),'*');
polarscatter(ngoodbazpi(nindexSNR3),nangles(nindexSNR3),'o');
polarscatter(ngoodbazpi(nindexSNR4),nangles(nindexSNR4),'d');
polarscatter(goodbazpi(pin),goodangles(pin),'.','r');
polarplot(eb,a,'--','color','k');
polarplot(sb,a,'--','color','k');
polarplot(wb,a,'--','color','k');
polarplot(nb,a,'--','color','k');

h6 = legend('3<SNR<10','10<SNR<100','1000<SNR','100<SNR<1000','positive angle','cardinal direction boundaries');
set(h6,'FontSize',12);

ax2 = gca;
ax2.ThetaDir = 'clockwise';
ax2.ThetaZeroLocation = 'top';
