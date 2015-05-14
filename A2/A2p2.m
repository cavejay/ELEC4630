% s4262468's solution to Q2 of ELEC4620's Assignment2
close, clear, clc

% import all them images
mri = {};
mri{1} = imread('MRI1_01.png');
mri{2} = imread('MRI1_02.png');
mri{3} = imread('MRI1_03.png');
mri{4} = imread('MRI1_04.png');
mri{5} = imread('MRI1_05.png');
mri{6} = imread('MRI1_06.png');
mri{7} = imread('MRI1_07.png');
mri{8} = imread('MRI1_08.png');
mri{9} = imread('MRI1_09.png');
mri{10} = imread('MRI1_10.png');
mri{11} = imread('MRI1_11.png');
mri{12} = imread('MRI1_12.png');
mri{13} = imread('MRI1_13.png');
mri{14} = imread('MRI1_14.png');
mri{15} = imread('MRI1_15.png');
mri{16} = imread('MRI1_16.png');

h = {};
for j = 1:16, 
    h{j} = histeq(mri{j});
    G = fspecial('gaussian',[7 7],5);
    h{j} = imfilter(h{j},G,'same');
end

mid = round(size(h{1})/2);
mid = [mid(2), mid(1)];
cirSize = 100;
splitDegs = 36;
radialSplits = 15;

% Make the co-ordinates around the circle
cirx = [];
ciry = [];
for deg = 0:splitDegs:360-splitDegs,
    cirx = [cirx; (mid(1)+cirSize*cosd(deg))];
    ciry = [ciry; (mid(2)+cirSize*sind(deg))];
end

% Make the inside co-ords
fillx = [];
filly = [];
for j = 1:size(cirx),
    tempx = []; tempy = [];
    [tempx,tempy] = filllline(mid, [cirx(j), ciry(j)], radialSplits);
    fillx = [fillx;tempx];
    filly = [filly;tempy];
end

% % Show us the points
% figure(7), imshow(h{1});
% fillx = floor(fillx);
% filly = floor(filly);
% hold on
% for j = 1:size(cirx),
%     plot(cirx(j), ciry(j),'x');
%     for k = 1:size(fillx,2),
%         plot(fillx(j,k),filly(j,k),'xr')
%     end
% end
% hold off
% close(7)

% Lets show the trellis
img = h{1};
trel = []; % A collection of all the data :D

for i = 1:size(cirx),
    for j = 1:size(fillx,2),
        c = fillx(i,j);
        r = filly(i,j);
        b = img(floor(r),floor(c));
        trel(j,i) = b;
    end
end

trel = struct('d',trel,'l',size(trel,1),'w',size(trel,2));
trel.e = edge(uint8(trel.d),'canny');
% imshow(imresize(uint8(trel.d),4))

paths = [];
vals = [];
for arb = 1:trel.l,
    
    % Make the start and end costs first
    startv = []; endv = [];
    for i = 1:trel.l,
        t = vcost(trel, [arb,1], [i,2]);
        startv(i,1) = t;
        
        t = vcost(trel, [i,trel.w], [arb,1]);
        endv(i,1) = t;
    end
    
    % find the best solution for the last row back to arb
    startp(1:trel.l,1) = 0; endp(1:trel.l, 1) = arb;
    startp(arb,1) = find(startv(:,1)==min(startv(:,1)),1,'first');
    
    % Traverse the trellis and assign values and parents
    trel.p = startp; trel.v = startv;
    for col = 2:trel.w-1,
        s = trel.d(:,col); % our current column
        for curr = 1:trel.l, % for each point in our column
            minVal = vcost(trel, [curr col], [1 col+1], 'path');
            minPath = 1;
            for next = 2:trel.l, % look at each point in the last
                val = vcost(trel, [curr col], [next col+1],'path');
                if val < minVal, minVal = val; minPath = next; end                
            end
            trel.p(curr,col) = minPath;
            trel.v(curr,col) = minVal;
        end
    end
    trel.p = [trel.p endp];
    trel.v = [trel.v endv];
    
    % Find the total cost
    totalv = 0;
    col = 1;
    curr = arb;
    while col <= trel.w,
        paths(arb, col) = trel.p(curr,col);
        totalv = totalv + trel.v(curr,col);
        curr=trel.p(curr,col); col=col+1; 
    end
    vals(arb,1) = totalv;
end

best = find(vals==min(vals),1,'first');

figure(1), imshow(uint8(trel.d)), hold on;
for i = 2:trel.w,
    plot(i-1,paths(best,i), 'xr');
end
plot(i, best, 'xr');
hold off;

% draw on the original image
figure(2), imshow(img), hold on;
for i = 2:trel.w,
    pt1 = [fillx(i-1, paths(best,i-1)) filly(i-1, paths(best,i-1))];
    pt2 = [fillx(i, paths(best,i)) filly(i, paths(best,i))];
    x = [pt1(1) pt2(1)];
    y = [pt1(2) pt2(2)];
    plot(x(1), y(1), '*b');
    line(x,y);
end
plot(x(2), y(2), '*b'); % print last star
plot(mid(1), mid(2), '*k');


for j = 1:trel.w, plot(cirx(j), ciry(j),'xr'); end
hold off;
























