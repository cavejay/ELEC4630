function [ value ] = segCheck( src, mask)
% Run this to compare 2 bw images and return a value from 1-100 showing how
% close they are to being the same. 100 implies a perfect match.

mask = logical(mask);
src = logical(src);

resrc = imresize(src, size(mask), 'box');
i = abs(resrc - mask);

pixInResrc = size(find(resrc),1);
pixInDiff = size(find(i),1);

value = 100-(pixInDiff/pixInResrc)*100;

end

