%---------------------------------------------------------------------%
% Computes bids for each task. Returns bids, best index for task in
% the path, and times for the new path
%---------------------------------------------------------------------%

function o = CBBA_ComputeBids(o, sys, c)

nTarget = length(sys.sat.target);
% If the path is full then we cannot add any tasks to it
L = find(sys.ta.path == -1);
if( isempty(L) )
    return;
end

% Reset bids, best positions in path, and best times
sys.ta.bids = zeros(1,nTarget);
sys.ta.bestIdxs = zeros(1,nTarget);
sys.ta.taskTimes = zeros(1,nTarget);

% For each task
for i = 1:nTarget
    
    % extract targets which require searching
    if (sys.ta.bConsider(i) == 1)
        
        % Check for compatibility between agent and task
        if sys.ta.CM(sys.body.typeNum, sys.sat.target(i).typeNum) > 0
            
            % Check to make sure the path doesn't already contain task i
            if isempty(find(sys.ta.path(1,1:L(1,1)-1) == i))
                
                % Find the best score attainable by inserting the score into the
                % current path
                bestBid   = 0;
                bestIndex = 0;
                bestTime  = -1;
                
                % Try inserting task i in location j among other tasks and see if
                % it generates a better new_path.
                for j=1:L(1,1)
                    if sys.ta.feasibility(i,j) == 1
                        % Check new path feasibility
                        skip = 0;
                        
                        if j == 1 % insert at the beginning
                            sys.ta.taskPrev = [];
                            sys.ta.timePrev = [];
                        else
                            sys.ta.taskPrev = sys.sat.target(sys.ta.path(j-1));
                            sys.ta.timePrev = sys.ta.times(j-1);
                        end
                        
                        if j == L(1,1)  %insert at the end
                            sys.ta.taskNext = [];
                            sys.ta.timeNext = [];
                        else
                            sys.ta.taskNext = sys.sat.target(sys.ta.path(j));
                            sys.ta.timeNext = sys.ta.times(j);
                        end
                        
                        % Compute min and max start times and score
                        sys.ta.CBBA_ScoringCalcScore(sys,c,i);
                        
                        if(sys.ta.minStart > sys.ta.maxStart)
                            % Infeasible path
                            skip = 1;
                            sys.ta.feasibility(i,j) = 0;
                        end
                        
                        if ~skip
                            % Save the best score and task position
                            if sys.ta.score > bestBid
                                bestBid = sys.ta.score;
                                bestIndex = j;
                                bestTime = sys.ta.minStart; % Select min start time as optimal
                            end
                        end
                    end
                end
                
                % Save best bid information
                if bestBid > 0
                    sys.ta.bids(1,i) = bestBid;
                    sys.ta.bestIdxs(1,i) = bestIndex;
                    sys.ta.taskTimes(1,i) = bestTime;
                end
            end % this task is already in my bundle
        end % extract targets which require searching ends
    end % this task is incompatible with my type
    
end % end loop through tasks