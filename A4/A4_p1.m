% Script made by s4262468 as the solution to part 1 of the 4th assessment
% task of ELEC4630

close all, clear, clc

% Load all the images from all the folders
disp('load the pictures')
imgType = '*.jpg'; % change based on image type
addpath('dino');
imgPath = ['dino/'];
images  = dir([imgPath imgType]);
for idx = 1:length(images)
    [img, map] = imread([imgPath images(idx).name], 'jpg');
    cam{idx}.img = im2double(img);
end
disp('...done')

disp('adding the camera data')
Dino_projection_matrices()
for idx = 1:length(images)
    cam{idx}.p = eval(['P' int2str(idx-1)]);
end

clearvars -except cam
disp('...done')

disp('Finding the outline of the dinosaur in each image')
for i = 1:length(cam),
    disp(['Cutting out the dinosaur! View #' int2str(i)])
    t = rgb2hsv(cam{i}.img);
    cam{i}.cut = t(:,:,1)>0.7 | t(:,:,1)<0.3; %super-simple cutting
    cam{i}.cut = imclearborder(cam{i}.cut);
    cam{i}.cut = imfill(cam{i}.cut, 'holes');
%     figure, imshow(cam{i}.cut)
end
disp('...done')

disp('Setting up for carving')
minX = -180; maxX = 90;
minY = -80; maxY = 70;
minZ = 20; maxZ = 460;

% Volume of space
vol = dist(minX,maxX) * dist(minY,maxY) * dist(minZ,maxZ);

% Number of voxels. if vol==numVox then it's full resolution
numVox = vol/5;
V.res = (vol/numVox)^(1/3); % should be 1 if full res

% create the meshgrid
x = minX:V.res:maxX;
y = minY:V.res:maxY;
z = minZ:V.res:maxZ;

% V is going to be the shape we carve out to make the dino.
[V.X, V.Y, V.Z] = meshgrid(x, y, z);
V.val = ones(numel(V.X),1);
disp('...done')

disp('Starting the carving')
for i = 1:length(cam),
    c = cam{i}; % 
    
    z = c.p(3,1) * V.X + c.p(3,2) * V.Y ...
      + c.p(3,3) * V.Z + c.p(3,4);

    % Make the flat 'image' seen by the camera.
    y_plane = round((c.p(2,1) * V.X + c.p(2,2) * V.Y ...
    + c.p(2,3) * V.Z + c.p(2,4)) ./ z);

    x_plane = round( (c.p(1,1) * V.X + c.p(1,2) * V.Y ...
    + c.p(1,3) * V.Z + c.p(1,4)) ./ z);

    % Points could be outside of the image we just constructed.
    % Let's get rid of them. >:D
    [h,w,d] = size(c.img);
    keep = find( (x_plane>=1) & (x_plane<=w) & (y_plane>=1) & (y_plane<=h) );
    x_plane = x_plane(keep); % this then masks the image to only be inside w&h
    y_plane = y_plane(keep);
    
    % Now clear any that are not inside the silhouette
    ind = sub2ind([h,w], round(y_plane), round(x_plane) );
    keep = keep(c.cut(ind) >= 1); % Indices come in hand as the coordinate system here

    V.X = V.X(keep);
    V.Y = V.Y(keep);
    V.Z = V.Z(keep);
    V.val = V.val(keep);
    
    disp(['Camera #' int2str(i) ' carved!'])
end
disp('...done')

disp('Preparing to and then printing: ')

% First grid the data
ux = unique(V.X); uy = unique(V.Y); uz = unique(V.Z);

% Expand the model by one voxel in each direction
ux = [ux(1)-V.res; ux; ux(end)+V.res];
uy = [uy(1)-V.res; uy; uy(end)+V.res];
uz = [uz(1)-V.res; uz; uz(end)+V.res];

[X,~,~] = meshgrid( ux, uy, uz ); % we only need X here

% Create an empty voxel grid, then fill only those elements in voxels
v = zeros(size(X));

% Here we flip the model
% This is the most computationally intensive part of the code as we must
% move every single voxel in order to mirror the dino.
for ii=1:numel(V.X)
    ix = (ux == V.X(ii));
    iy = flipud(uy == V.Y(ii));
    iz = flipud(uz == V.Z(ii));
    v(iy,ix,iz) = V.val(ii);
end

% Now draw it :D
figure; p = patch(isosurface(v, 0.5));
set( p, 'FaceColor', 'b', 'EdgeColor', 'none' );
set(gca,'DataAspectRatio',[1 1 1]);
xlabel('X'); ylabel('Y'); zlabel('Z');
view(-140,22); axis('tight')
lighting('gouraud')
camlight(0,22); camlight(180,22);
disp('...done')
























