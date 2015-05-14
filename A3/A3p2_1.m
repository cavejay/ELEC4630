% s4262468's solution to Part1 of ELEC4630's 3rd Assessment task
close all, clear, clc;

% How long is a piece of string?

% Load the strings!
str1 = {struct()}; str2 = {struct()}; str3 = {struct()};
disp('Loading Strings');
addpath('string');
for itr = 1:15, 
    if itr <= 5, 
        disp(['String1_' int2str(itr) '.jpg']);
        str1{itr}.o = (rgb2gray(imread(['String1_' int2str(itr) '.jpg'])));
    elseif itr <= 10, 
        disp(['String2_' int2str(itr) '.jpg']);
        str2{itr-5}.o = (rgb2gray(imread(['String2_' int2str(itr-5) '.jpg'])));
    else
        disp(['String3_' int2str(itr) '.jpg']);
        str3{itr-10}.o = (rgb2gray(imread(['String3_' int2str(itr-10) '.jpg'])));
    end
end

% Loading saved lengths
str1{1}.len = 130; str2{1}.len = 155;
clc
disp('Pre-processing images')
% Crop all the images to the interesting bits by looking at edges.
buf = 3; f = fspecial('gaussian', [500 500], 50);
for itr = 1:15, 
    if itr <= 5, 
        disp(['> Str1_' int2str(itr)]);
        i = str1{itr}.o;
        i = i-(imfilter(i,f));
        [r, c] = ind2sub(size(i), find(edge(i, 'sobel')));
        rmin = min(r)-buf; rmax = max(r)+buf; cmin = min(c)-buf; cmax = max(c)+buf;
        % Make sure we don't try to go off the edge.
        if rmin<1, rmin=1; end, if rmax>size(i,1), rmax=size(i,1); end
        if cmin<1, cmin=1; end, if cmax>size(i,2), cmax=size(i,2); end
        t(:,:) = i(rmin:rmax, cmin:cmax);
        str1{itr}.p = t;
    elseif itr <= 10, 
        disp(['> Str2_' int2str(itr-5)]);
        i = str2{itr-5}.o;
        i = i-(imfilter(i,f));
        [r, c] = ind2sub(size(i), find(edge(i, 'sobel')));
        rmin = min(r)-buf; rmax = max(r)+buf; cmin = min(c)-buf; cmax = max(c)+buf;
        % Make sure we don't try to go off the edge.
        if rmin<1, rmin=1; end, if rmax>size(i,1), rmax=size(i,1); end
        if cmin<1, cmin=1; end, if cmax>size(i,2), cmax=size(i,2); end
        t(:,:) = i(rmin:rmax, cmin:cmax);
        str2{itr-5}.p = t;
    else
        disp(['> Str3_' int2str(itr-10)]);
        i = str3{itr-10}.o;
        i = i-(imfilter(i,f));
        [r, c] = ind2sub(size(i), find(edge(i, 'sobel', 0.02)));
        rmin = min(r)-buf; rmax = max(r)+buf; cmin = min(c)-buf; cmax = max(c)+buf;
        % Make sure we don't try to go off the edge.
        if rmin<1, rmin=1; end, if rmax>size(i,1), rmax=size(i,1); end
        if cmin<1, cmin=1; end, if cmax>size(i,2), cmax=size(i,2); end
        t(:,:) = i(rmin:rmax, cmin:cmax);
        str3{itr-10}.p = t;
    end
%      figure, imshow(t);
    clearvars t i
end

% First step is to find the pixel length of the str1&2 in the provided
% pictures
% This then gives us something to go with for the rest of the images

disp('Clearing console');
% input('Press enter to clear the console and continue');
clc, close all
strs = {str1, str2, str3}; 
for numstr = 1:3,
    str = strs{numstr};
    for itr = 1:5,
        str{itr}.bw = imclearborder(~(str{itr}.p>30));
        str{itr}.bw = str{itr}.bw | (edge(str{itr}.p, 'sobel'));
        str{itr}.bw = bwareaopen(str{itr}.bw, 10, 8);
        
        factor = 2;
        str{itr}.bw = imresize(str{itr}.bw, factor);
        str{itr}.bw = imdilate(str{itr}.bw, strel('disk', 1));
        str{itr}.bw = imresize(str{itr}.bw, 1/factor, 'box');
        str{itr}.bw = ~bwareaopen(~str{itr}.bw, 10, 4);
        
        % Skeletonisation Starts here
        sk = str{itr}.bw;
        el1 = [-1 -1 -1;
                0  1  0;
                1  1  1]; 

        el2 = [0 -1 -1;
               1  1 -1;
               0  1  0];
        el = el1; before = zeros(size(sk));
        while(1),
            before = sk;
            counter = 8;
            while(1),
                tmp = imerode(sk, el==1) & imerode(~sk, el==-1);
                sk = sk & ~logical(tmp);

                % Switch between the 2 rotating elements
                if el==el1, el1 = rot90(el); el = el2; 
                else el2 = rot90(el); el = el1; end
                
                counter = counter-1;
                % break if we've been through this 8 times
                if counter == 0, break; end
            end
            if isequal(before, sk), break; end
        end

        % Commence pruning!
        pr1 = [-1 -1 -1;
               -1  1 -1;
               -1  0  0]; 

        pr2 = [-1 -1 -1;
               -1  1 -1;
                0  0 -1];
        pr = el1;
        reps = 2; 
        counter = 8;
        while(1),
            tmp = imerode(sk, pr==1) & imerode(~sk, pr==-1);
            sk = sk & ~logical(tmp);

            if pr==pr1, pr1 = rot90(pr); pr = pr2; 
            else pr2 = rot90(pr); pr = pr1; end

            counter=counter-1;
            if counter==0, reps=reps-1; counter = 8; end;
            if reps==0, break; end
        end
        
        % Make an image of just "ending" points 
        % and look for closest for joining
        ends = zeros(size(sk)); used = ends;
        el = [-1 -1 -1;
              -1  1 -1;
               0  0  0]; 
        
        while(1), r = 4;
            while r>0, % Find the ends
                ends = ends | imerode(sk, el==1) & imerode(~sk, el==-1);
                el = rot90(el); r=r-1;
            end
            ends = ends & ~used; % ignore the ones we've used already
            % break if we have less than 4 end points
            if size(find(ends),1)<4, break; end
            
            % if we have enough, lets connect the 2 points closest to
            % eachother
            [r,c] = ind2sub(size(ends), find(ends));
            closest = struct('d', 1000000);
            for j = 1:size(r,1),
                for k = 1:size(r,1),
                    if j==k, continue, end;
                    d = pdist([r(j) c(j); r(k) c(k)]);
                    if d<closest.d,
                        closest.d = d;
                        closest.a = [r(j) c(j)];
                        closest.b = [r(k) c(k)];
                    end
                end
            end
            % Mark used points
            used(closest.a(1), closest.a(2)) = 1; 
            used(closest.b(1), closest.b(2)) = 1;

            % connect the 2 closest ends for reasons
            sk = func_Drawline(sk, closest.a(1), closest.a(2), ...
                closest.b(1), closest.b(2),1);
        end
        
        % Count diagonals for Operation: #totes_precise length measurement
        el = [ 0  0 0; % this will trigger for every point that has a 
              -1  1 0; % diagonally adjacent point.
               1 -1 0]; 
        tmp1 = imerode(sk, el==1) & imerode(~sk, el==-1);
        tmp2 = imerode(sk, rot90(el)==1) & imerode(~sk, rot90(el)==-1);
        diagCount = size(find(tmp1 | tmp2), 1);
         
        % Wrap-up
        % strLen = (diagCount * 2^0.5 + (numpx - diagCount)) * r 
        numpx = size(find(sk),1); % Count pixels in foreground
        if numstr ~= 3 && itr == 1, % store the length to px ratio
            str{1}.r = str{1}.len / (diagCount * 2^0.5 + (numpx - diagCount));
            
        % if third string use average of last 2 ratios to find length
        elseif numstr == 3 && itr == 1, 
            str{1}.r = strs{1}{1}.r/2 + strs{2}{1}.r/2;
            str{1}.len = (diagCount * 2^0.5 + (numpx - diagCount)) * str{1}.r;
        else
            str{itr}.r = str{1}.r;
            str{itr}.len = (diagCount * 2^0.5 + (numpx - diagCount)) * str{itr}.r;
        end
        
        t = str{itr}.p; t(sk)=255;
        figure
        
        subplot(141), imshow(t);
        title(['String' int2str(numstr) '-#' int2str(itr)]);
        subplot(142), imshow(str{itr}.p);
        subplot(143), imshow(str{itr}.bw); 
        title(['Pixel Length: ' int2str(numpx) ' - Est. Length: ' int2str(str{itr}.len)]);       
        subplot(144), imshow(sk);
        print(['str' int2str(numstr) '-' int2str(itr)], '-djpeg90')
        disp(['Actual len of str#' int2str(itr) ' is:  ' int2str(str{itr}.len) ' -- d:' int2str(diagCount)]);
        
    end
    
    strs{numstr} = str;
    avg = 0; for j = 1:5, avg = str{j}.len + avg; end; avg=avg/5;
    disp(['      Average Length: ' int2str(avg)]);
    print(['str' int2str(numstr) '-' int2str(itr)], '-djpeg90')
    clearvars -except strs numstr itr 
    disp('.')
end

i = input('enterkey with no input to close all figures');
close all;










































