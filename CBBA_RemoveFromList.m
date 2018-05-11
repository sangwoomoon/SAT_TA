%---------------------------------------------------------------------%
% Remove item from list at location specified by index
%---------------------------------------------------------------------%

function o = CBBA_RemoveFromList(o, sys, idx)

pathTemp = sys.ta.path;
timesTemp = sys.ta.times;
scoreMatrixTemp = sys.ta.scoreMatrix;

sys.ta.path = -ones(1,length(pathTemp));
sys.ta.path(1,1:idx-1) = pathTemp(1,1:idx-1);
sys.ta.path(1,idx:end-1) = pathTemp(1,idx+1:end);

sys.ta.times = -ones(1,length(timesTemp));
sys.ta.times(1,1:idx-1) = timesTemp(1,1:idx-1);
sys.ta.times(1,idx:end-1) = timesTemp(1,idx+1:end);

sys.ta.scoreMatrix = -ones(1,length(scoreMatrixTemp));
sys.ta.scoreMatrix(1,1:idx-1) = scoreMatrixTemp(1,1:idx-1);
sys.ta.scoreMatrix(1,idx:end-1) = scoreMatrixTemp(1,idx+1:end);

end