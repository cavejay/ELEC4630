% s4262468's 'Easymode' solution for Part2
clear, close all, clc

% import all them images
mri = {};
mri{1} = imread('MRI1_01.png');
mri{2} = imread('MRI1_02.png');
mri{3} = imread('MRI1_03.png');
mri{4} = imread('MRI1_04.png');
mri{5} = imread('MRI1_05.png');
mri{6} = imread('MRI1_06.png');
mri{7} = imread('MRI1_07.png');
mri{8} = imread('MRI1_08.png');
mri{9} = imread('MRI1_09.png');
mri{10} = imread('MRI1_10.png');
mri{11} = imread('MRI1_11.png');
mri{12} = imread('MRI1_12.png');
mri{13} = imread('MRI1_13.png');
mri{14} = imread('MRI1_14.png');
mri{15} = imread('MRI1_15.png');
mri{16} = imread('MRI1_16.png');

areas = [];
for j = 1:16,
    i = mri{j};
    
    % get value of center of image.
    mid = round(size(mri{1})/2);
    midval = i(mid(1), mid(2));

    offset = 55; % the offset of the values to look at.

    imin = i<=midval-offset;
    imax = i<=midval+offset;
    isel = imax - imin;
    
    ifil = imfill(isel, 'holes'); % Fill in holes
    G = strel('ball',6,2,4); 
    iclo = imclose(ifil, G); % use closing to in hooks
    iclo = imfill(iclo, 'holes'); % fill in any holes made by closed hooks
    
    % Show area overlaid on original image
%     figure, imshow(uint8(iclo)*50 + i); 
    F = bwlabel(iclo); % Label the regions
    region = F(mid(1), mid(2)); % found our region
    areas(j,1) = size(find(F==region),1); % Find the area of our region
    
    edg = edge(uint8(F==region),'sobel'); % Find the outline of our region

    % Find the points that make up the outline
    v = []; [v(:,1), v(:,2)] = ind2sub(size(edg), find(edg));
    
    t(:,:,1) = i; t(:,:,2) = i; t(:,:,3) = i; % Make a colour copy
    
    % Make the outline points in the colour copy red
    for k = 1:size(v,1), t(v(k,1), v(k,2), :) = [255 0 0]; end
    
    figure, imshow(t) % Show or save the images :D
%     imwrite(t,['im' int2str(j) '.png']);
end











