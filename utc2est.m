function [ est ] = utc2est( utc )
defval('utc',[1:1:24])
est = zeros(size(utc));
est(:,1:19) = utc(:,6:24);
est(:,20:24) = utc(:,1:5);


end


