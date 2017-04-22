function [ julza ] = rmoutlier( vjulz )
% 
% S = mean(vjulz);
% M = mean(S(~isnan(S)))
% o = vjulz > M
% 
% for i = 1:24
%     MWJ(i) = mean(vjulz(~isnan(vjulz(:,i)),i));
%     MWA(i) = mean(vaugz(~isnan(vaugz(:,i)),i));
%     MWS(i) = mean(vsepz(~isnan(vsepz(:,i)),i));
%     MWO(i) = mean(voctz(~isnan(voctz(:,i)),i));
% end
% 
% %look into percentile
% 
%  MJ = mean(MWJ);
%  oij = vjulz > MJ;
%  julza = vjulz;
%  julza(oij) = NaN;
%  
%  MA = mean(MWA);
%  oia = vaugz > MJ;
%  augza = vaugz;
%  augza(oia) = NaN;
%  
%  MS = mean(MWS);
%  ois = vsepz > MJ;
%  sepza = vsepz;
%  sepza(ois) = NaN;
%  
%  MO = mean(MWJ);
%  oio = voctz > MJ;
%  octza = voctz;
%  octza(oio) = NaN;
% 
julza = vjulz;
 julza(julza>prctile(julza(:),99))=NaN;

end

