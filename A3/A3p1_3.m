% s4262468's solution to Part1 of ELEC4630's 3rd Assessment task
close all, clear, clc;

% load images
hi = imread('hi_FITC.tif');
hi_m = imread('hi_Mask.tif');

bord = imread('borderline_FITC.tif');
bord_m = imread('borderline_Mask.tif');

i = hi; % make us a nice variable

disp('Pre-scaling images');
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

disp('Processing using submersion');

% Starting at the lowest level of pixelage
cur = levels{1};
dims = size(cur.p);

% Border matrices
cb(1, 1:dims(2)) = 1; rb(1:dims(1), 1) = 1;

% Submerge the lowest value
sub = zeros(dims);
depth = min(cur.p(:)); fdepth = depth;
[ty, tx] = ind2sub(dims, find(cur.p==depth));
sub(ty,tx) = 1;

% figure out how to look find when an area is closed off.
% if an area ia closed off paint it white in mask

% iteratively submerge until all local maxima are found.
mask = cur.p;
while min(min((mask==255) + (mask==0))) ~= 1, % while we still have nonbinary values
    depth = depth+1;
    disp(['Processing depth: ' int2str(depth)]);
%     mask = cur.p;
    % for each corner of the currently selected points tx,ty
    for newpt = 1:size(tx, 1),
        px = tx(newpt); py = ty(newpt); % shorthand points
        mask(py, px) = 0;
        % North
        if py>1 && mask(py-1,px)~=0 && mask(py-1,px)~=255 && cur.p(py-1, px)<=depth,
            mask = flood(px, py-1, mask, 0);
            mask(py-1, px) = 0;
        end
        % South
        if py<dims(1) && mask(py+1,px)~=0 && mask(py+1,px)~=255 && cur.p(py+1, px)<=depth,
            mask = flood(px, py+1, mask, 0);
            mask(py+1, px) = 0;
        end
        % East
        if px<dims(2) && mask(py,px+1)~=0 && mask(py,px+1)~=255 && cur.p(py, px+1)<=depth,
            mask = flood(px+1, py, mask, 0);
            mask(py, px+1) = 0;
        end
        % West
        if px>1 && mask(py,px-1)~=0 && mask(py,px-1)~=255 && cur.p(py, px-1)<=depth,
            mask = flood(px-1, py, mask, 0);
            mask(py, px-1) = 0;
        end
    end
    sub(mask==0 - sub>0) = depth-fdepth;
    
    % Look at the outermost pixels
    outerPixels = mask==0 - imerode(mask==0, strel('disk', 1));
    [ty, tx] = ind2sub(size(sub), find(outerPixels));
    
    % Check for enclosed areas
    enclosed = imfill([rb sub>0 rb], 'holes') - [rb sub>0 rb];
    enclosedRow = enclosed(:, 2:size(enclosed,2)-1);
    enclosed = imfill([cb;sub>0;cb], 'holes') - [cb;sub>0;cb];
    enclosedCol = enclosed(2:size(enclosed,1)-1, :);
    
%     imshow(enclosed)
    mask(logical(enclosedRow + enclosedCol)) = 255;
end
    
 % clean up the sub
sub = ~bwareaopen(~sub,5);
imshow(sub);

curlvl = 2; % we just did level 1
while curlvl <= 5 % for each level leading up to full size
    % setup all the vars for this time
    
    











end


final = 0;
disp('Checking seg value');
% segCheck(final, hi_m)





























