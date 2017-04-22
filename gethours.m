function [ hours, days, months, cmt] = gethours(file)
%UNTITLED14 Summary of this function goes here
%   Detailed explanation goes here

defval('file','/Users/abrummen/Documents/Total.txt')

C = importdata(file);
cmt = C.textdata(:,1);
hours = nan(length(cmt),1);
days = nan(length(cmt),1);
months = nan(length(cmt),1);

for i = 1:length(cmt)
    hours(i) = str2num(cmt{i}(10:11));
 
    days(i) = str2num(cmt{i}(8:9));
    months(i) = str2num(cmt{i}(6:7));
end

end

