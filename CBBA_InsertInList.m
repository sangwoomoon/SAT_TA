function o = CBBA_InsertInList(o, sys, bestTask)

index = sys.ta.bestIdxs(1,bestTask);
pathTemp = sys.ta.path;
timesTemp = sys.ta.times;
scoreMatrixTemp = sys.ta.scoreMatrix;
feasibilityTemp = sys.ta.feasibility;

sys.ta.path = -ones(1,length(pathTemp));
sys.ta.path(1,1:index-1) = pathTemp(1,1:index-1);
sys.ta.path(1,index) = bestTask;
sys.ta.path(1,index+1:end) = pathTemp(1,index:end-1);

sys.ta.times = -ones(1,length(timesTemp));
sys.ta.times(1,1:index-1) = timesTemp(1,1:index-1);
sys.ta.times(1,index) = sys.ta.taskTimes(1,bestTask);
sys.ta.times(1,index+1:end) = timesTemp(1,index:end-1);

sys.ta.scoreMatrix = -ones(1,length(scoreMatrixTemp));
sys.ta.scoreMatrix(1,1:index-1) = scoreMatrixTemp(1,1:index-1);
sys.ta.scoreMatrix(1,index) = sys.ta.bids(bestTask);
sys.ta.scoreMatrix(1,index+1:end) = scoreMatrixTemp(1,index:end-1);

% Update feasibility
% This inserts the same feasibility boolean into the feasibilty
% matrix- Ask Andy for details
for i = 1:length(sys.sat.target)
    sys.ta.feasibility(i,:) = -ones(1,length(feasibilityTemp(i,:)));
    sys.ta.feasibility(i,1:index-1) = feasibilityTemp(i,1:index-1);
    sys.ta.feasibility(i,index) = feasibilityTemp(i,index);
    sys.ta.feasibility(i,index+1:end) = feasibilityTemp(i,index:end-1);
end

end