% s4262468's Solution to Q1 Assignment2 of ELEC4630
close, clear, clc

i = imread('tajmahal2004.jpg');
ig = rgb2gray(i);

G = fspecial('gaussian',[5 5],2);
igb = imfilter(ig,G,'same');

ic = edge(igb,'canny');
is = edge(igb, 'sobel');

t = imfilter(double(is), G, 'same');

% find hough transform
[H,T,R] = hough(t,'RhoResolution',1,'Theta',-80:0.2:-40);

% Find the highest values in the transform and return their points
P = houghpeaks(H,4);
% Which is similar to:
% Htemp = H; P = [];
% for k = 1:4,
%     [x,y] = ind2sub(size(H),find(Htemp==max(Htemp(:)))); % find the best val
%     P(k,:) = [x y]; radius = round(size(H)/50); % store and make radius
%     Htemp(x-radius(1):x+radius(1), y-radius(2):y+radius(2)) = 0; % don't look near here again.
% end

%find the lines that are made from the points in the hough transform
lines = houghlines(t,T,R,P, 'FillGap', 30, 'MinLength', 200);

figure, imshow(i), hold on
max_len = 0;
for k = 1:length(lines)
    xy = [lines(k).point1; lines(k).point2];
   plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
end
