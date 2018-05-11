%---------------------------------------------------------------------%
% Create bundles for each agent
%---------------------------------------------------------------------%

function o = CBBA_BundleAdd(o, sys, c)

sys.ta.newBid = 0;
nTarget = length(sys.sat.target);

% Check if bundle is full
bundleFull = isempty(find(sys.ta.bundle == -1));

% Initialize feasibility matrix (to keep track of which j locations can be pruned)
sys.ta.feasibility = ones(nTarget,sys.ta.maxBundleDepth+1);

while bundleFull == 0
    
    % Update task values based on current assignment
    sys.ta.CBBA_ComputeBids(sys, c);
    
    % Determine which assignments are available
    
    state1 = sys.ta.bids-sys.ta.winnerBids > sys.ta.epsilon;
    state2 = abs(sys.ta.bids-sys.ta.winnerBids) <= sys.ta.epsilon;
    state3 = sys.id < sys.ta.winnerMatrix; % Tie-break based on agent index
    
    state = state1|(state2&state3);
    [value bestTask] = max(state.*sys.ta.bids);
    
    if value > 0
        
        % Set new bid flag
        sys.ta.newBid = 1;
        
        % Check for tie
        allvalues = find(state.*sys.ta.bids == value);
        if(length(allvalues) == 1),
            bestTask = allvalues;
        else
            % Tie-break by which task starts first
            earliest = realmax;
            for i = 1:length(allvalues),
                if ( sys.sat.target(allvalues(i)).start < earliest),
                    earliest = sys.sat.target(allvalues(i)).start;
                    bestTask = allvalues(i);
                end
            end
        end
        
        sys.ta.winnerMatrix(bestTask)    = sys.id;
        sys.ta.winnerBids(bestTask) = sys.ta.bids(bestTask);
        sys.ta.CBBA_InsertInList(sys,bestTask);
        len = length(find(sys.ta.bundle > -1));
        sys.ta.bundle(len+1) = bestTask;
        
    else
        % disp('Value is zero, breaking');
        break;
    end
    
    % Check if bundle is full
    bundleFull = isempty(find(sys.ta.bundle == -1));
end
    

end