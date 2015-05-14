function [ cost ] = vcost1(trel, cur, point, path)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

skip = 0;
if nargin < 4, skip = 1; else path = trel.p; end

cost = 0;

% points close to the center have a higher weight
cost = cost + (point(1)-size(trel,1))*10;

% if there is a large gap between points it is undesirable
gapweight = 5;
cost = cost + gapweight * abs(cost(1) - point(1));

% if there is a change in value then it is undesirable
valweight = 10;
cost = cost + valweight * abs(trel(cur(1), cur(2)) - trel(point(1), point(2)))^2;

% if there is a small gradient change between this point and the next then
% reduce the cost.
% if the gradiant between this and the last line is too different make the
% move impossible >:D
if skip ~= 1,
%     if size(path,2) ~= 1,
        gradweight = 2;
        prev = [path(cur(1),cur(2)-1) cur(2)-1]; %first cur(2)-1 is due to path's offset
%     else
        
%     end
    grad1 = (cur(1)-prev(1))/(cur(2)-prev(2));
    grad2 = (point(1)-cur(1))/(point(2)-cur(2));
    deltaGrad = grad2 - grad1;
    if deltaGrad ~= 0, 
        cost = cost +  gradweight * abs(deltaGrad/grad1)*100;
    end
    if abs(deltaGrad) > size(trel,1)/4,
        cost = 100000000000000;
end

end

% %% Gradiant Cost Calc
% % smaller change in gradiant means smaller cost.
% % if deltagrad is too large make the cost obscene
% if skip ~= 1,
%     gradweight = 2;
%     prev = [path(cur(1),cur(2)-1) cur(2)-1]; %first cur(2)-1 is due to path's offset
%     grad1 = (cur(1)-prev(1))/(cur(2)-prev(2));
%     grad2 = (point(1)-cur(1))/(point(2)-cur(2));
%     deltaGrad = grad2 - grad1;
%     if deltaGrad ~= 0, 
%         cost = cost +  gradweight * abs(deltaGrad/grad1)*100;
%     end
%     if abs(deltaGrad) > size(trel,1)/4, % we're jumping 1/4 of the trellis :(
%         cost = 100000000000000;
% end
% 
% % The point just before a large delta in values
% cost = cost + abs(point(1) - trel(1)/2);
% 
% % canny and subtract cost if on a white point.
% if edg(point(1), point(2)) == 1,
%     cost = cost/2;
% end

