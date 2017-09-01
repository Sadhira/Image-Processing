%% differentional operator

input = [0 0 0 10 200 201 203 198 202 130 90 12];

diffvect = zeros(1,12);
%subtract the pervious val FROM the next

for i = 2:11
    %diffvect(1, i) = input(1, i+1)-(input(1, i));
    diffvect(1, i) = input(1, i)-(input(1, i-1));
end

for i = 1:12
    absvect(i) = abs(diffvect(i));
    
%     T = 100;
%     if absvect(i) > T
%         edgemap(i) = 1;
%     else edgemap(i) = 0;      %less elegant way to do the below
%     end
    
end

T = 100;
edgemap = absvect > T;




%% convolution operator 

input = [0 0 0 10 200 201 203 198 202 130 90 12];
input = [0, input, 0];  %concatanates a zero to each end

mask = [-1 0 1];

output = zeros(12);
convmask = [1 0 -1];    %mask for convolution is flipped

%this achieves the function d(n) = Sum(m=-1to1) h(m)I(n-m)

convect = zeros(1,14);

for i = 2:12
    for n = -1:1
        %val = input(1,i+n) * convmask(1,i-n);        %figure out why wrong
        val = input(1,i+n) * -n;
        convect(1,i) = convect(1,i) + val;
    end
end

hold on
plot(input);
plot(diffvect);
plot(convect);
legend('Input','Diff','Conv');    
hold off


%% phantom

load H:\MATLAB\phantom2;        %gets loaded into variable 'a'
imagesc(a);


mask2D = 1/6* [1 0 -1; 1 0 -1; 1 0 -1];

convphant = conv2(a, mask2D);
imagesc(convphant);
conv2vect = reshape(convphant, [1,130^2]);     
    %^ seems to read vals vertically when concatenating
figure()
plot(conv2vect);

% now using a transposed mask:
mask2DT = mask2D';
convphant2 = conv2(a, mask2DT)
figure()
imagesc(convphant2);
conv2vect2 = reshape(convphant2, [1,130^2]);
figure()
plot(conv2vect2);

%transposed mask acts at 90 degrees to the original



%% head 


fid = fopen('H:\MATLAB\ImageDataFiles\head.128','r');  %opens file to read

[x,npels] = fread(fid,[128,128],'uchar'); % Reads data values
                                          % into matrix x with 128 rows,
                                          % and 128 columns
                                          % npels = number of pixels
x = x';      % Matlab reads in arrays with a different index order [Ctd...]
             % to that of ‘C’ File was created using C, so transpose matrix
fclose(fid); % Close the file handle 


y = uint8(x); % converts x values to unsigned ints 
              % so that they require 8 bits instead of 16(type: double)
              
image(y);   % visualises image
colormap(gray(64));

















