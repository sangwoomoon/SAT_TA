%---------------------------------------------------------------------%
% Calculates marginal score of doing a task and returns the expected
% start time for the task.
%---------------------------------------------------------------------%

function o = CBBA_ScoringCalcScore(o, sys, c, targetIndex)

if sys.body.typeNum <= length(sys.body.typeList(:,1))
    
    if isempty(sys.ta.taskPrev) % First task in path
        dt = sqrt((sys.platform.pos(1)-sys.sat.target(targetIndex).x(1))^2+...
            (sys.platform.pos(2)-sys.sat.target(targetIndex).x(2))^2+...
            (sys.platform.pos(3)-sys.sat.target(targetIndex).x(3))^2)/sys.platform.cruiseSpeed;
        sys.ta.minStart = max(sys.sat.target(targetIndex).start, sys.platform.avail+dt);
    else % Not first task in path
        dt = sqrt((sys.ta.taskPrev.x(1)-sys.sat.target(targetIndex).x(1))^2+...
            (sys.ta.taskPrev.x(2)-sys.sat.target(targetIndex).x(2))^2+...
            (sys.ta.taskPrev.x(3)-sys.sat.target(targetIndex).x(3))^2)/sys.platform.cruiseSpeed;
        sys.ta.minStart = max(sys.sat.target(targetIndex).start, sys.ta.timePrev+sys.ta.taskPrev.duration+dt); %i have to have time to do task at j-1 and go to task i
    end
    
    if isempty(sys.ta.taskNext) % Last task in path
        sys.ta.maxStart = sys.sat.target(targetIndex).finish;
    else % Not last task, check if we can still make promised task
        dt = sqrt((sys.ta.taskNext.x(1)-sys.sat.target(targetIndex).x(1))^2+...
            (sys.ta.taskNext.x(2)-sys.sat.target(targetIndex).x(2))^2+...
            (sys.ta.taskNext.x(3)-sys.sat.target(targetIndex).x(3))^2)/sys.platform.cruiseSpeed;
        sys.ta.maxStart = min(sys.sat.target(targetIndex).finish, sys.ta.timeNext-sys.sat.target(targetIndex).duration-dt); %i have to have time to do task m and fly to task at j+1
    end
    
    % Compute score
    sys.ta.reward = sys.sat.target(targetIndex).value*exp(-sys.sat.target(targetIndex).lambda*(sys.ta.minStart-sys.sat.target(targetIndex).start));
    
    % Subtract fuel cost.  Implement constant fuel to ensure DMG.
    % NOTE: This is a fake score since it double counts fuel.  Should
    % not be used when comparing to optimal score.  Need to compute
    % real score of CBBA paths once CBBA algorithm has finished
    % running.
    sys.ta.penalty = sys.platform.fuel*...
        sqrt((sys.platform.pos(1)-sys.sat.target(targetIndex).x(1))^2+...
        (sys.platform.pos(2)-sys.sat.target(targetIndex).x(2))^2+...
        (sys.platform.pos(3)-sys.sat.target(targetIndex).x(3))^2);
    
    sys.ta.score = sys.ta.reward-sys.ta.penalty;
    
    % FOR USER TO DO:  Define score function for specialized agents, for example:
    % elseif(agent.type == CBBA_Params.AGENT_TYPES.NEW_AGENT), ...

    % Need to define score, minStart and maxStart
    
else
    disp('Unknown agent type')
end

end