%---------------------------------------------------------------------%
% Main CBBA Function
%---------------------------------------------------------------------%

function o = CBBA_Main(o, system, c)

nSystem = length(system);
sys = system(1);    % possible because all info. is shared and known to each system

for i = 1 : nSystem
   system(i).ta.maxBundleDepth = sum(sys.ta.bConsider); % length(system(i).sat.target);
   system(i).ta.bundle = -ones(1,system(i).ta.maxBundleDepth);
   system(i).ta.path = -ones(1,system(i).ta.maxBundleDepth);
   system(i).ta.times = -ones(1,system(i).ta.maxBundleDepth);
   system(i).ta.scoreMatrix = -ones(1,system(i).ta.maxBundleDepth);
   system(i).ta.bids = zeros(1,length(system(i).sat.target));
   system(i).ta.winnerMatrix = zeros(1,length(system(i).sat.target));
   system(i).ta.winnerBids = zeros(1,length(system(i).sat.target));
   
   % for all agents (should be updated for all)
   % Initialize working variables
   system(i).ta.updateTime = zeros(nSystem,nSystem);  % Matrix of time of updates from the current winners
   system(i).ta.currentIter = 1;                      % Current iteration
   system(i).ta.lastTime = system(i).ta.currentIter-1;
end

doneFlag = 0;

while(doneFlag == 0)
    
    %---------------------------------------%
    % 1. Communicate
    %---------------------------------------%
    % Perform consensus on winning agents and bid values (synchronous)
    sys.ta.CBBA_Communicate(system, c);
    
    %---------------------------------------%
    % 2. Run CBBA bundle building/updating
    %---------------------------------------%
    % Run CBBA on each agent (decentralized but synchronous)
    for i = 1:nSystem
       sys.ta.CBBA_Bundle(system(i), c); 
       
       % Update last time things changed (needed for convergence but will
       % be removed in the final implementation)
       if(system(i).ta.newBid),
           for j = 1:nSystem
               system(j).ta.lastTime = system(i).ta.currentIter;
           end
       end
    end

    %---------------------------------------%
    % 3. Convergence Check
    %---------------------------------------%
    % Determine if the assignment is over (implemented for now, but later
    % this loop will just run forever)
    if(system(1).ta.currentIter-system(1).ta.lastTime > nSystem)
        doneFlag = 1;
    elseif(system(1).ta.currentIter-system(1).ta.lastTime > 2*nSystem)
        disp('Algorithm did not converge due to communication trouble');
        doneFlag = 1;
    else
        % Maintain loop
        for j = 1:nSystem
            system(j).ta.currentIter = system(j).ta.currentIter + 1;
        end
    end   
end

% Map path and bundle values to actual task indices
for i = 1:nSystem
    for j = 1:sys.ta.maxBundleDepth
%         if system(i).ta.bundle(j) == -1
%             break;
%         else
%             system(i).ta.bundle(j) = system(i).sat.target(system(i).ta.bundle(j)).id;
%         end

        if system(i).ta.path(j) == -1
            break;
        else
            system(i).ta.path(j) = system(i).sat.target(system(i).ta.path(j)).id;
        end
    end
end

% Compute the total score of the CBBA assignment
TotalScoreTemp = 0;
for i = 1 : nSystem
    for j = 1:sys.ta.maxBundleDepth
        if system(i).ta.scoreMatrix(j) > -1
            TotalScoreTemp = TotalScoreTemp+system(i).ta.scoreMatrix(j);
        else
            break;
        end
    end
end

for i = 1:nSystem
    system(i).ta.TotalScore = TotalScoreTemp;
end

end