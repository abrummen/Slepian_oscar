function [vxr,vyr,maxg,maxms,msxy,gamav] = rotatevec(vx,vy,gama,interval,plotit)

%%This function takes a series of vectors (like a seismogram)and
% rotates the vectors by the angle gama (in units of degrees) where positive gama is clockwise

% which way is x & y and specify what way positive gama turns it
exvector = [0,0; 0,1; 0,2; 0,3; 0,4; 0,5];

defval('vx',exvector(:,1));
defval('vy',exvector(:,2));
defval('gama',330);
defval('plotit',1)
defval('interval',1);

% Make sure they are column vectors
vx=vx(:);
vy=vy(:);

%convert gama into radians and account for direction (sign change - negative means )
gamar = -gama*(pi/180);

%What is our degree interval 
di = -interval*(pi/180);

if di == 0;
% figure(5)
% plot(vx,vy)
% xlim([-5 5])
% ylim([-5 5])
% hold all;

gamam =[cos(gamar) -sin(gamar); ...                                                                                     
	   sin(gamar)  cos(gamar)];
   
   % Check 
   gamam'-inv(gamam)

   
   
newv=[gamam*[vx' ; vy']]';
vxr = newv(:,1);
vyr = newv(:,2);
maxg = gama;
maxms = 0 ;
msxy = 0;
gamav = gama;


 % Check
 


% plot(vxr,vyr)
   
 else
 
%Create a vector filled with all the gama values
gamav = (-gamar:di:gamar);

%Create an empty vector the length of the gama vector that will be filled 
%with each gama's ms value
msxy=nan(length(gamav),1);

vxp = nan(length(gamav),length(vx));
vyp = nan(length(gamav),length(vy));

for index=1:length(gamav)
    %Create the rotation matrix for each value of gama
    gamam =[cos(gamav(index)) -sin(gamav(index)); ...
        sin(gamav(index))  cos(gamav(index))];
    
    % newv is composed of both componenets that have been rotated by gama
    newv=[gamam*[vx' ; vy']]';
    
    % the resulting rotated vectors divided into two separate variables
    vxp(index,:) = newv(:,1);
    vyp(index,:) = newv(:,2);
    
%     %ssx & ssy are the rotated components squared
%     ssx=vxp(index,:)*vxp(index,:)';
%     ssy=vyp(index,:)*vyp(index,:)';
    
    % the vector containing all the ms values
    msxy(index) = (mean([vxp(index,:).^2 - vyp(index,:).^2])/mean([vxp(index,:).^2 + vyp(index,:).^2]));
    
    
end

% returns minms- the smallest of the absolute value of all the terms in msxy
% and the index of that value
[maxms,maxin]=min((msxy));

%From the index return the value of gama in degrees, minus because we want
%to report the value clockwise
maxg=-(gamav(maxin))*(180/pi); 
vxr = vxp(maxin,:);
vyr = vyp(maxin,:);

end
    


if plotit==1
    figure(1)
    clf
    plot(vx,vy)
    axis equal
    
    figure(2)
    clf
    plot(vxr,vyr)
    axis equal
end

