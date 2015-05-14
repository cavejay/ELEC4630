function [ fin] = pad( i, i2)
%PAD Only use this on gray images, larger image goes second
%   Detailed explanation goes here

nPadr = (size(i2,1)-size(i,1))/2;
nPadc = (size(i2,2)-size(i,2))/2;

% padColor = uint8(0);
% c = size(i, 2);
% newImg = [repmat(padColor,floor(nPadr),c);i;repmat(padColor,floor(nPadr),c)];
% r = size(newImg, 1);
% newImg = [repmat(padColor,r,floor(nPadc)) newImg repmat(padColor,r,floor(nPadc))];
% 
% fin = im2double(newImg);
% 

fin = padarray(i, [floor(nPadr), floor(nPadc)], 0, 'both');

if size(fin,1) ~= size(i2,1) || size(fin,2) ~= size(i2,2)
    disp('Failed to evenly pad the image')
    if size(fin,1) < size(i2,1)
        fin = padarray(fin, [1 0], 0,'pre');
    end
    if size(fin,2) < size(i2,1)
        fin = padarray(fin, [0 1], 0, 'pre');
    end
end

end

