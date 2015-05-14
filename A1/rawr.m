clc, clear
%% Load ALL the images!
img1 = imread('20980008.jpg');
img2 = imread('20980035.jpg');
img3 = imread('20980060.jpg');
img4 = imread('20980065.jpg');
blue = imread('bluecar.jpg');
kings = imread('kingswood.jpg');

i = blue;
ig = i;

% get the size of the picture.
rs = size(ig, 1);
cs = size(ig, 2);

if size(i,3) == 3 % make sure it's gray
    ig = rgb2gray(i);
end

ig = histeq(ig);

% Normal edging
is = edge(ig, 'sobel');
ic = edge(ig, 'canny');

t = imread('n.jpg');
tc = edge(t,'canny');
ts = edge(t, 'sobel');
G = fspecial('gaussian',[10 10],2);
tcb = imfilter(double(tc),G,'same');
tsb = imfilter(double(ts),G,'same');

things = {};
%populate set with different shapes/angles
for j = 0:10,
    things = [things imresize(tcb,0.5 + j/10)];
end

for j = 0:10,
    things = [things imrotate(tcb,5 - j/10)];
end

% normxcorr2 with thing each element in that array and add together
result = normxcorr2(things{1}, ig);
for j = 2:size(things,2),
    result = result + normxcorr2(things{j}, ig);
end

imshow(result)

%imshow











