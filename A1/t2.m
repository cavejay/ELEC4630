
L = bwlabel(insl, 8);
STATS = regionprops(L,'BoundingBox');

thresh = 100;

imshow(L)
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

figure(2), imshow(L)

