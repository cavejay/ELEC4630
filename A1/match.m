function [ xcorr, imgs ] = match( image)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

%%
SPAMFIGURES = 0;

%% Load the numberplate array
 n = {imread('n.jpg'),
    imread('kings.jpg'),
    imread('n3.jpg'),
    imread('n4.jpg'),
    imread('n5.jpg'),
    imread('n6.jpg')};
num = size(n);

%% Cross-correlate
 imgs = {};
 for i = 1:6,
     if size(image, 3) == 3
        grayimg = rgb2gray(image);
     else
         grayimg = image;
     end 
     
     if size(n{i}, 3) == 3
         grayedge = rgb2gray(n{i});
     else 
         grayedge = n{i};
     end
     img = edge(grayimg, 'canny');
     nedg = edge(grayedge, 'canny');
     imgs{i} = normxcorr2(double(nedg),double(img));
     if SPAMFIGURES
         figure(i)
         subplot(1,3,1), imshow(img)
         subplot(1,3,2), imshow(nedg)
         subplot(1,3,3), imshow(imgs{i})
     end
 end
 
%% Check if there was a point found in the picture
xcorr = 0; 
for j = 1:num,
     bw = im2bw(imgs{j}, 0.5);
     blank = im2double(false(size(bw,1),size(bw,2)));
     if bw == blank % There was no number plate
         disp('NO NUMBERPLATE WAS FOUND')
         
     else % Numberplate was probably found
         disp('NUMBER PLATE FOUND')
         xcorr = bw;
     end
    % threshold images
    % remove images that are now black
    % find the point in the image that is bright
    % canny the image and find the area that the numberplate should take up
    
    
end

end
