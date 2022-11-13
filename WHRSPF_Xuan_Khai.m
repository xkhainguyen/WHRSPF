% Active contour driven by weighted hybrid region-based signed pressure force (WHRSPF)

clc;clear all;close all;

addpath 'image'

image = 14;  % choose image to segment
%Init image, contour, sigma, radius, wg, wl, small for each image
[Img,stat,sigma,rad,wg,wl,small]=selectImage(image);    


if size(Img,3)>1    % convert to gray image if colored
    Img = rgb2gray(Img);
end

[row,col] = size(Img);  

% Img = imnoise(Img,'speckle',0.01);    % add noise
% Img = imnoise(Img,'salt & pepper',0.03);

phi = ones(row,col);
phi(stat:row-stat,stat:col-stat) = -1;  % initialize binary LSF +-1

phi = - phi;
figure, subplot(2,2,1);imshow(Img);hold on;
[c, h] = contour(phi, [0 0], 'r','LineWidth',2);  % contour - zero LSF
title('Initial Contour');
hold off;
Img = double(Img);  % convert to datatype double

G = fspecial('gaussian',rad, sigma); % initialize gaussian filter G with radius and std deviation

IterNum = 100; % number of IterNumation

% the weights of weighted global and local region-based SPF to balance
subplot(2,2,2);
for n = 1:IterNum
    [phix, phiy] = gradient(phi);     % u(X); X=(x,y)
    grad = sqrt(phix.^2 + phiy.^2);   % |grad u|
    
    %% Weighted global region-based SPF (GRSPF)    
    c1 = sum(sum(Img.*(phi<0)))/(sum(sum(phi<0)));      % average intensity of inner C
    c2 = sum(sum(Img.*(phi>=0)))/(sum(sum(phi>=0)));    % average intensity of outer C
    m = median(Img(phi<0));      % median of inner C                      
    wg1= sum(sum((phi>0)))/(row*col);     % adaptive weight = S_in/S
    wg2= sum(sum((phi<0)))/(row*col);     % adaptive weight = S_out/S

    grspf=Img-((wg1*c1^2+wg2*m^2-c2^2)/(wg1*2*c1+wg2*2*m-2*c2));    % Eq. (10)

    %% Weighted local region-based SPF (GLSPF)    
    gImg = conv2(Img,G,'same');             % apply Gaus filter to image
    u1=conv2(double(phi>0),G,'same');         % 1 inside 0 outside curve
    s1=conv2(Img.*(phi>0),G,'same');          % inside curve in local region
    u2=conv2(double(phi<0),G,'same');         % 1 outside 0 inside curve
    s2=conv2(double(Img.*(phi<0)),G,'same');  % outside curve in local region
    
    wl1= sum(sum((gImg-s1)>0))/(row*col);     % wl1 = d_in/d
    wl2= sum(sum((gImg-s2)>0))/(row*col);     % wl2 = d_out/d
  
    f1 = sum(s1(:))./sum(u1(:));        % average intensity of inner local region
    f2 = sum(s2(:))./sum(u2(:));        % average intensity of outer local region
    lrspf = gImg - (wl1*f1 + wl2*f2);       % Eq. (14)
    
    %% Weighted hybrid region-based SPF (WHSPF)    
    gmax=max(abs(grspf(:)));
    lmax=max(abs(lrspf(:)));
%     if gmax>lmax
%         grspf=grspf/gmax*lmax;
%     else 
%         lrspf=lrspf/lmax*gmax;
%     end
%     hrspf = wg.*grspf+wl.*lrspf;        %Eq. (18)
    
    maxspf=max(gmax,lmax);
    hrspf = wg*min(1,gmax/maxspf)*grspf+wl*min(1,lmax/maxspf)*lrspf;        %Eq. (18)
    
    %% Computing the level set function (LSF)    
    phi = phi + abs(c1+m-2*c2).*hrspf.*grad*1;
    
    %% Display process
    if mod(n,10)==0
    imshow(Img,[0 255]); colormap(gray);hold on;
    [c, h] = contour(phi, [0 0], 'r');
    title([num2str(n), ' Iterations']);
    pause(0.02);
    end
    
    %% Make it pretty
    phi = (phi >= 0) - ( phi< 0);   %  binary LSF
    objPos=bwareaopen(phi>0,small);	% Remove small objects from final curves
    objPos=imclose(objPos,strel('disk',3));     % Morphologically close image     
    objNeg = ~objPos;  
    phi = objPos - objNeg;
    phi = conv2(phi, G, 'same');
end
%imshow(Img,[0 255]);colormap(gray);hold on;
[c, h] = contour(phi, [0 0], 'r','LineWidth',2);

