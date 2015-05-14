function [ fin ] = crop( i, i2)
%CROP Only use this on gray images, image to crop goes first
%   Detailed explanation goes here

diff = size(i) - size(i2)
size(i2)
fin = imcrop(i, [diff(1)/2 diff(2)/2  size(i2)]);


end

