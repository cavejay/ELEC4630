clc, clear, close all
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

% Gauss then canny, also sobel
G = fspecial('gaussian',[5 5],2);
ib = imfilter(ig,G,'same');
ibc = edge(ib, 'canny');
ibs = edge(ib, 'sobel');

% Add them all together
itot = ibc + ic + is;

% pre-proc for edge density
itot([1:50 end-50:end],:) = 0;
itot(:,[1:50 end-50:end]) = 0;
insl = bwareaopen(itot, 10);
L = bwlabel(insl, 8);
STATS = regionprops(logical(L),'BoundingBox');
thresh = 0;

% remove long & thin bb's probs straight lines
% imshow(L)
for p = 1:size(STATS),
    bb = STATS(p).BoundingBox;
    if bb(3) > thresh && bb(4) < bb(3)/10
        L(L==p) = 0;
%         rectangle('Position', bb, 'EdgeColor', 'green');
    elseif bb(4) > thresh && bb(3) < bb(4)/10
        L(L==p) = 0;
%         rectangle('Position', bb, 'EdgeColor', 'blue');
    else
%         rectangle('Position', bb, 'EdgeColor', 'red');
    end
end

% we also use edge density check
H = fspecial('gaussian',[round(rs/5) round(cs/5)],5); 
tm = imfilter(double(logical(L)), H,'same'); % blur it a tonne
maxV = max(max(tm)); % get the highest value
allMaxValsMask = tm==maxV;
[R,C] = ind2sub(size(allMaxValsMask), find(allMaxValsMask));

SE = strel('disk',5,4);
dx = imdilate(allMaxValsMask, SE);

% Finding the entire number plate
% Segmentation
sx = strel('line', 3, 0);
sy = strel('line', 3, 90);
ts = imclose(is, sx); % attempt to complete unfinished/broken lines
ts = imclose(ts, sy);
holes = imfill(ts, 'holes'); % find cut off areas
s1 = strel('disk', 5, 0);
t1 = imerode(holes, s1);
F = bwlabel(t1);
np = F(R,C);
Mask = F==np;
% imshow(Mask);

% We want a nice rectangle
stats = regionprops(Mask, 'BoundingBox');
cropper = i;
cropper = imcrop(cropper, stats(1).BoundingBox);
subplot(2,2,2), imshow(cropper);
subplot(2,2,1), imshow(i), rectangle('Position', stats(1).BoundingBox, 'EdgeColor', 'r');

% Now to try OCR?
% load all the alpha numeric character we have.
imgPath = 'Character Images/';
imgType = '*.bmp'; % change based on image type
images  = dir([imgPath imgType]);
for idx = 1:length(images)
    Seq{idx} = imread([imgPath images(idx).name]);
end

txt = imcomplement(im2bw(cropper, 0.6));
txt = bwareaopen(txt, 20);
statsofletters = regionprops(txt, 'BoundingBox');
subplot(2,2,3),imshow(txt);
lets = {};
for idx = 1:length(statsofletters),
    tmp = statsofletters(idx).BoundingBox;
    if tmp(3) < tmp(4)
        rectangle('Position', tmp, 'EdgeColor', 'r');
        bestLetter = Seq{1}; bestVal = 0;
        for template = 1:length(Seq),
            cross = normxcorr2(imcrop(txt, tmp),imresize(Seq{template},[tmp(4)+1 tmp(3)+1]));
            if max(max(cross)) > bestVal
                bestLetter = Seq{template};
                bestVal = max(max(cross));
                templateNum = template;
            end
        end
        lets = [lets; templateNum];
    end
end

String = '';
for idx = 1:length(lets),
    hemp = images(lets{idx}).name(1);
    String = [String hemp];
end

String
subplot(2,2,4), text(0,0.5,String,'fontsize',30,'color','k')
axis off
% close all
% imshow(imfuse(dx,imresize(ig,size(dx))))










