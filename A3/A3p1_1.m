% s4262468's solution to Part1 of ELEC4630's 3rd Assessment task
close all, clear, clc;

% load images
hi = imread('hi_FITC.tif');
hi_m = imread('hi_Mask.tif');

bord = imread('borderline_FITC.tif');
bord_m = imread('borderline_Mask.tif');

i = hi; % make us a nice variable

disp('Pre-scaling image');
% Make a structure containing different the image at different scales.
levels = {};
levels{5} = struct('z', 1, 'p', i, 'm', mode(double(i(:))), 't', zeros(size(i)));
for j = 1:4,
    scale = 1/(2^j);
    tmp = struct('z', scale, 'p', imresize(i, scale));
    tmp.t = zeros(size(tmp.p));
    tmp.m = mode(double(tmp.p(:))); % find the most common value in the image
    levels{5-j} = tmp;
end

% until some condition is met, mark next highest points.
cur = levels{1};
cp = cur.p;
val = max(cp(:));       points = 0;
while points <= size(cp,1)*size(cp,2)/4, 
    [hiPoint(1) hiPoint(2)] = ind2sub(size(cp), find(cp==val, 1, 'first'));
    cur.t(hiPoint(1), hiPoint(2)) = 255;
    cp(hiPoint(1), hiPoint(2)) = 0;
    val = max(cp(:));
    points = points +1;
end
imshow(cur.t);

r = imresize(cur.t, size(i),'box');

final = cur.t;


disp('Checking seg value');
segCheck(final, hi_m)





























