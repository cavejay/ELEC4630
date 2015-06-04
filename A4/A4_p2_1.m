% Script made by s4262468 as the solution to part 2 of the 4th assessment
% task of ELEC4630

close all, clear, clc

% Load all the images from all the folders
disp('load the faces')
imgType = '*.bmp'; % change based on image type
addpath('faces');
for j = 1:6, 
    imgPath = ['Faces/' int2str(j) '/'];
    images  = dir([imgPath imgType]);
    for idx = 1:length(images)
        [img, map] = imread([imgPath images(idx).name], 'bmp');
        f{j}{idx} = rgb2gray(ind2rgb(img, map));
    end
end
disp('...done')

disp('load the trainging faces')
% Make the mean image
imgType = '*.bmp'; % change based on image type
addpath('faces');
images  = dir(['Faces/eig/' imgType]);
for idx = 1:length(images)
    [i,m] = imread(['Faces/eig/' images(idx).name], 'bmp');
    tmp= im2double(rgb2gray( ind2rgb(i, m)));
    trn(:,:,idx) = tmp/max(max(tmp));
end
disp('...done')

disp('Find difference images')
[h,w,d] = size(trn); n = h*w;
trn = reshape(trn,[n d]);
for i = 1:length(images), dif(:,i) = trn(:,i) - mean(trn,2); end
disp('...done')

disp('Covariance time and eigenfaces')
C = (dif'*dif)/length(images);
[V,D] = eig(C);
U = dif*V;

% normalise?
for i=1:length(images), 
    U(:,i) = U(:,i)/(D(i,i)^0.5);
end

wght = U'*dif % find the weights
faces={};
for i=1:length(images), 
    faces{i} = reshape(U(:,i), [h,w]);
    figure, imshow(reshape(U(:,i), [h,w])),
end
close all
disp('...done')

face = 5;
disp(['Reconstructing face #' int2str(face)])
re = mean(trn,2);
for i = 1:length(images),
    weighting = wght(i,face)
    re = re + weighting * U(:,i);
    figure, imshow(reshape(re, [h,w]))
end
re = reshape(re, [h,w]);


min_re = min(min(re))
re = re + abs(min_re);
max_re = max(max(re));
re = re/max_re;

imshow(re)

disp('...done')

























