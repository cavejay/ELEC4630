function [ bw ] = numberplate(i)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

%% Process for edges yo
g = rgb2gray(i);
edg = edge(g, 'canny');
%bw = im2bw(gry, 0.7);
imshow(edg);
end