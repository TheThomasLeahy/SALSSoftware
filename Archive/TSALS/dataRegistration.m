function [ bitmap ,regHeaders] = dataRegistration(imagesize,bitmap,R,XandY,maxI_J)
    %UNTITLED3 Summary of this function goes here
    %   Detailed explanation goes here
    
    %create headers for registered something
    regHeaders='Xn \tYn \tH1n \tH2n \tH3n \tH4n \tH5n \tH6n';
    %get original image dimensions
    Xpixels=imagesize(1,2);
    Ypixels=imagesize(1,1);
    %get transform matrix dimensions
    tsize = size(R);
    %get size of bitmap containing allData for a single slice
    s=XandY;

    %S size of SALS scan
    N=XandY(1,1);
    %Y size of SALS scan
    M=XandY(1,2);

%     %%  Tensor stuff
%     %declare H
%     H=zeros(N*M,2,2,2,2);
%     %declare rotation of H
%     Hrot=zeros(N*M,2,2,2,2);
%     %fill in values for H
%     H(:,1,1,1,1)=bitmap(11,:);
%     H(:,2,2,2,2)=bitmap(16,:);
% 
%     H(:,2,2,1,1)=bitmap(12,:);
%     H(:,2,1,2,1)=bitmap(12,:);
%     H(:,1,2,2,1)=bitmap(12,:);
%     H(:,1,1,2,2)=bitmap(15,:);
%     H(:,2,1,1,2)=bitmap(12,:);
%     H(:,1,2,1,2)=bitmap(12,:);
% 
%     H(:,1,1,1,2)=bitmap(13,:);
%     H(:,1,2,1,1)=bitmap(13,:);
%     H(:,2,1,1,1)=bitmap(13,:);
%     H(:,1,1,2,1)=bitmap(13,:);
% 
%     H(:,2,2,1,2)=bitmap(14,:);
%     H(:,1,2,2,2)=bitmap(14,:);
%     H(:,2,2,2,1)=bitmap(14,:);
%     H(:,2,1,2,2)=bitmap(14,:);

    %%
    s2=size(bitmap);    %get size of regbitmap
    
    
    X = bitmap(2,:);  %X is x values from bitmap
    Y = bitmap(3,:); %Y is y values from bitmap

    origPrefDir = bitmap(8,:);

    maxXmm=max(X);
    minXmm=min(X);
    maxYmm=max(Y);
    minYmm=min(Y);
    Xrangemm=maxXmm-minXmm;
    YRangemm=maxYmm-minYmm;

    %Flip to fiji coordinates
    Y = Y - YRangemm; 
    Y = Y*(-1);
    
    
    tx=R(5)*(Xrangemm)/Xpixels;
    ty=R(6)*(YRangemm)/Ypixels;

    %{
    cosTheta = R(1);
    sinTheta = R(2);
    
    a = YRangemm*sinTheta*cosTheta;
    b = YRangemm * (sinTheta^2);
    
    tx = xPrime + a;
    ty = b-yPrime;
    
    %}
    
    %determine T1 (first transformation)
    % flip the sin's and the ty to account for positive y in
    % pixel coordinates being downardly oriented
    T1 = [R(1)    R(3)    tx;
          R(2)    R(4)    -ty;
          0       0       1];

    % again, flip sign to account for flipped y coord
    theta = -asind(R(2)); % could be acos(R(1))...etc

    for node_num = 1:length(X)
        %vector which represents the x and y values in mm of the node
        x_y_mm = [X(node_num); Y(node_num); 1];
        % vector post-tranformation
        x_y_prime = T1*x_y_mm;

        %Flip back to our coordinates
        x_y_prime(2) = -1*x_y_prime(2);
        x_y_prime(2) = x_y_prime(2) + YRangemm;
        
        bitmap(2, node_num) = x_y_prime(1); % x position (mm)
        bitmap(3, node_num) = x_y_prime(2); % y position (mm)

        bitmap(8, node_num) = origPrefDir(node_num) + theta;
    end

%     for n=1:N*M
%         regOUT(3,n)=Hrot(n,1,1,1,1);
%         regOUT(4,n)=Hrot(n,2,2,1,1);
%         regOUT(5,n)=Hrot(n,1,1,1,2);
%         regOUT(6,n)=Hrot(n,2,2,1,2);
%         regOUT(7,n)=Hrot(n,1,1,2,2);
%         regOUT(8,n)=Hrot(n,2,2,2,2);
%     end

    

    bitmap = padarray(bitmap, [0 prod(maxI_J) - size(bitmap,2)], 'post');

end