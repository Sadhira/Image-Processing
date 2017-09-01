%% Practical 2

[X, map] = imread('croppedpeasondesk.jpg');
whos X;

% Name        Size                Bytes  Class    Attributes
% X         512x512x3            786432  uint8   

% size of 3 2D arrays, therefore in RGB format
% class of uint8 also indicates this, because a full 
% unsigned 8 bits needs to be used to give a full range

%% Task 1
% initialising and choosing threshold by eye

G = rgb2gray(X);   % converts RGB image or colormap to grayscale
imagesc(G);        % like image(), but scales values of X to colormap range
colormap(gray(256));

G = double(G);      %hist requires a doule type to work
g = G(:);           %converts 2D matrix to 1D array

hist(g);

figure()
hist(g,100);

T = 129;                %chose small plateau point as threshold
gbin = (G > T);
figure()
colormap(gray(256));
imagesc(gbin);

%% how to correct for spikey hist graphs

R = double(X(:,:,1));
figure()

subplot(1,3,1)
hist(R(:),100);
title('noninteger bins of fixed number');  
% divides range by given number, therefore bin sizes become non integers


[Count, intensity] = hist(R(:), 40:1:250);
subplot(1,3,2)
bar(intensity, Count);
title('integer bins of guessed range');


minR = min(R(:));       % = 3
maxR = max(R(:));       % = 255
[Count, intensity] = hist(R(:), 3:1:255);
subplot(1,3,3)
bar(intensity, Count);
title('integer bins with corrected range');



%% plotting each channel in greyscale
% 
% colramp = [0 : 1/255 : 1]';     % column of vals from 0 to 1
% 
% redmap = [colramp, zeros(256,1), zeros(256,1)];
% greenmap = [zeros(256,1), colramp, zeros(256,1)];
% bluemap = [zeros(256,1), zeros(256,1), colramp];
% 
% 
% figure()
% %colormap(redmap);
% colormap(gray(256));
% imagesc(X(:,:,1));
% colorbar;
% title('Red');
% 
% figure()
% %colormap(greenmap);
% colormap(gray(256));
% imagesc(X(:,:,2));
% colorbar;
% title('Green');
% 
% figure()
% %colormap(bluemap);
% colormap(gray(256));
% imagesc(X(:,:,3));
% colorbar;
% title('Blue');

%% the above in one plot (plotting each channel in greyscale):

figure()
subplot(1,3,1)
%colormap(redmap);
colormap(gray(256));
imagesc(X(:,:,1));
colorbar;
title('Red');

subplot(1,3,2)
%colormap(greenmap);
colormap(gray(256));
imagesc(X(:,:,2));
colorbar;
title('Green');

subplot(1,3,3)
%colormap(bluemap);
colormap(gray(256));
imagesc(X(:,:,3));
colorbar;
title('Blue');

%% plotting the histogram of each channel
% 
% %redG = rgb2gray(X(:,:,1));
% figure()
% redG = (X(:,:,1));
% redG = double(redG);
% hist(redG, 50)
% title('Red');
% 
% figure()
% greenG = (X(:,:,2));
% greenG = double(greenG);
% hist(greenG, 50)
% title('Green');
% 
% figure()
% blueG = (X(:,:,3));
% blueG = double(blueG);
% hist(blueG, 50)
% title('Blue');

%%  the above in one plot (plotting the histogram of each channel):

figure()
subplot(1,3,1)
redG = (X(:,:,1));
redG = double(redG(:));  % turning the array of the channel into a vector
hist(redG,50)
title('Red');

subplot(1,3,2)
greenG = (X(:,:,2));
greenG = double(greenG(:));
hist(greenG, 50)
title('Green');

subplot(1,3,3)
blueG = (X(:,:,3));
blueG = double(blueG(:));
hist(blueG, 50)
title('Blue');

%% plotting the histogram of each channel using normalised values:


R = double(X(:,:,1));
G = double(X(:,:,2));
B = double(X(:,:,3));

Rn = 256*R./(R + G + B);        % normalised values
Bn = 256*B./(R + G + B);
Gn = 256*G./(R + G + B);


figure()
subplot(1,3,1)
%redG = (X(:,:,1));
Rn = double(Rn(:));
hist(Rn,50)
title('Red');

subplot(1,3,2)
Gn = double(Gn(:));
hist(Gn, 50)
title('Green');

subplot(1,3,3)
Bn = double(Bn(:));
hist(Bn, 50)
title('Blue');

%%
% I will use the blue channel to determine the threshold, because it
% seems to have the best distinction between the classes and an
% identifiable plateau of 75.5


% T = 129;                %chose small plateau point as threshold
% T = 135;
% gbin = (G > T);
% figure()
% colormap(gray(256));
% imagesc(gbin);

Rn = 256*R./(R + G + B);        
Bn = 256*B./(R + G + B);
Gn = 256*G./(R + G + B);
% recreating normalised vals as arrays instead of a single double vector


Tn = 75.5; 
figure()

subplot(1,3,1)
Rnbin = (Rn < Tn);
colormap(gray(256));
imagesc(Rnbin);
%imagesc(Rn);
title('Red');

subplot(1,3,2)
Gnbin = (Gn < Tn);
colormap(gray(256));
imagesc(Gnbin);
%imagesc(Gn);
title('Green');

subplot(1,3,3)
Bnbin = (Bn < Tn);  
colormap(gray(256));
imagesc(Bnbin);
%imagesc(Bn);
title('Blue');
colorbar;

%there is no need for RG in this, so here is only the binary blue channel:
imagesc(Bnbin);


%% binary image out of blue channel (completely redundant)
% 
% figure()
% Bnbinary = Bn;
% N = size(Bn);
% colormap(gray(256));
% 
% count1 = 0;
% 
% for i = 1:N
%     j = 1:N
%         if Bnbinary(i,j) > Tn
%             Bnbinary(i,j) = 1;
%             count1 = count1 + 1;
%         else Bnbinary(i,j) = 0;
%         end
% end
% 
% imagesc(Bnbinary);
% colorbar;

%     end
% end

%% Task 2: labelling of peas


L4 = bwlabel(Bnbin, 4);
L8 = bwlabel(Bnbin, 8);

colormap(gray(256));
imagesc(L8);            %produces gradiented image where each different
                        %shade of grey is recognised as a pea ie
                        %non background region
                        
%Regions = regionprops(L8, 'centroid');  
Props = regionprops(L8, 'Area', 'Centroid', 'BoundingBox');  
maxL8 = max(L8(:));

%the max value in L8 is the same as the number of rows in the 
%Props column vector (127x1 struct). this means that there is a stuct
%for each seperate region, presumabley denoting the pixels in each

% for i=1:127
% Area(i,1) = Props(i).Area;
% end
% cannot do Area = Props.Area(:,1);

Area = cat(1, Props.Area);
Centroid = cat(1, Props.Centroid);
Box = cat(1, Props.BoundingBox);


length(Props)               % = 127, so 127 objects have been found
mean(Area)                  % = 501.9134
std(Area)                   % = 633.6419

% areas not likely to be peas would be outside the std
% the values for the BoundingBox are, in order, the bottom left corner, 
% the width, and the height

imagesc(X);
for i = 1:127
    h = rectangle('Position', [Box(i,1) Box(i,2) Box(i,3) Box(i,4)]);
    
    set(h, 'EdgeColor', [1 0 0]);
    
    h = text(Box(i,1), Box(i,2), 'P');
    
    set(h, 'Color', 'r');
end

% the above loop creates my bounding boxes


%% Task 3: average pea

figure()
imagesc(Bnbin)

valid = (Area > 100 & Area < 1100);      
% creates indices where regions with area of <100 are assigned 0

boxWidth = zeros(117,1);
boxHeight = zeros(117,1);

figure()
imagesc(X);
for i = 1:127
    if valid (i)== 1
        h = rectangle('Position', [Box(i,1) Box(i,2) Box(i,3) Box(i,4)]);
        set(h, 'EdgeColor', [1 0 0]);
        h = text(Centroid(i,1), Centroid(i,2), 'P');
        set(h, 'Color', 'r');
   
        boxWidth(i,1) = Box(i,3);
        boxHeight(i,1) = Box(i,4);
    
    end
end

validN = sum(valid);        % = 52

maxWidth = max(boxWidth)    % = 39
maxHeight = max(boxHeight)   % = 40


% maxWidth = max(Box(:,3))    % = 119
% maxHeight = max(Box(:,4))   % = 99

% boxArea = 127:1;
% 
% for i = 1:127
%     boxArea(i) = Box(i,3) * Box(1,4);
% end
% 
% sqrt(max(boxArea))  % = 59.7495

% BoxWidth = (Box(:,3));
% BoxHeight = (Box(:,4));

%%

imagestack = zeros(maxHeight, maxWidth, 3, validN);   
                       % creates 4D array to stack 3D images for all peas
% 
% for i = 1:validN
%     imagestack(:,:,:,i) = getPatch







        
