
% Need to repeat the process for each point up the edge.
allstarts = {};
for arb = 1:size(trel,1)-2,
    %start and end values are arb
    col = 3;
    
    % Setup
    path(:,2,1) = arb; % the 2nd step all came from arb
    for i = 1:size(trel,1), path(i,2,2) = vcost(trel, [arb 1], [i 2]); end % finding them costs
    
    while col <= size(trel,2),
        s = trel(:,col);
        for j = 1:size(s), % For each value in col
        % find the least costly point to move from in col-1
            temp = [];
            for i = 1:size(s),
                temp(i) = vcost(trel, [i, col-1], [j, col]);
            end
            % add this to path for col
            path(j,col,1) =  find(temp==min(temp),1, 'first');
            % record the cost for this move
            path(j,col,2) = vcost(trel, [path(j,col,1), col-1], [j, col]);
        end
        col = col + 1;
    end
    
    % Final bit of assigning cost.
    for j = 1:size(trel,1),  temp = []; % Find cost to rejoin at arb
        for i = 1:size(trel,1),
            temp(i) = vcost(trel, [i, size(trel,2)], [arb, 1]);
        end
        path(j,1,1) = find(temp==min(temp),1, 'first');
        path(j,1,2) = vcost(trel, [path(j,size(trel,2),1), size(trel,2)], [arb, 1]);
    end
    
    % Now we work backwards to the total cost of each path find a path and put it in pathv2
    totalcosts = [];
    for i = 1:size(trel,1);
        col = size(trel,2);
        cc = 0; % current cost
        next = 0;
        while col >= 1,
            cc = cc + path(i,col,2); % get the cost
            next = path(i,col,1); % find next point

            col=col-1;
        end
        totalcosts(i,1) = cc;
    end
    
    find(totalcosts==min(totalcosts));

    
end
% figure, imshow(imresize(uint8(trel),5));



% draw paths


























