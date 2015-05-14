%% Load ALL the images!
img1 = imread('20980008.jpg');
img2 = imread('20980035.jpg');
img3 = imread('20980060.jpg');
img4 = imread('20980065.jpg');
blue = imread('bluecar.jpg');
kings = imread('kingswood.jpg');

chosen = blue;

[bw, imgs] = match(chosen);
imshow(imgs{1});
% img = imfuse(bw,edge(pad(chosen,bw), 'canny'));
% imshow(img);

