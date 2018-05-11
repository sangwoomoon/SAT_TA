classdef TaskAllocation < handle
    properties ( SetAccess = public, GetAccess = public )
        
        bConsider   % bool constant for consideration of task allocation
        
        % CBBA Properties                  
        maxBundleDepth           % maximum bundle depth (remember to set it for each scenario)
        feasibility              % for BundleAdd Function
        
        CM                       % compatibility Matrix
              
        bundle
        path
        times
        
        epsilon
        seeds
        
        taskPrev
        timePrev
        taskNext
        timeNext
        
        scoreMatrix
        minStart
        maxStart
        bids
        reward                  % task reward (total calculation)
        penalty                 % task panalty (totla calculation for fuel @ platform class)
        score
        
        winnerMatrix
        winnerBids
        newBid
        
        bestIdxs                % for ComputeBid Fn. @ BundleAdd Fn.
        taskTimes               % for ComputeBid Fn. @ BundleAdd Fn.
        
        updateTime              % Matrix of time of updates from the current winners
        lastTime
        currentIter             % current iteration
        
        Graph
        TotalScore
               
        plot
    end 
    
    methods
        function o = TaskAllocation( )
            
        end
    end
    
end



