function [ cost ] = vcost(trel, cur, next, yolo)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

skip = 0;
if nargin == 4, 
    skip = 1; end


cost = trel.d(next(1),next(2));

if abs(next(1)-cur(1)) > trel.l/4, cost = cost * 4; end

end

