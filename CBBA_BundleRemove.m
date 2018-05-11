%---------------------------------------------------------------------%
% Update bundles after communication
% For outbid agents, releases tasks from bundles
%---------------------------------------------------------------------%

function o = CBBA_BundleRemove(o, sys, c)

outbidForTask = 0;

for i = 1:sys.ta.maxBundleDepth
    % If bundle(i) < 0, it means that all tasks up to task i are
    % still valid and in paths, the rest (i to maxBundleDepth) are
    % released
    if( sys.ta.bundle(i) < 0 )
        % disp('Order is negative, breaking');
        break;
    else
        % Test if agent has been outbid for a task.  If it has,
        % release it and all subsequent tasks in its path.        
        if sys.ta.winnerMatrix(sys.ta.bundle(i)) ~= sys.id
            outbidForTask = 1;
        end
        
        if outbidForTask
            % The agent has lost a previous task, release this one too
            if sys.ta.winnerMatrix(sys.ta.bundle(i)) == sys.id
                % Remove from winner list if in there
                sys.ta.winnerMatrix(sys.ta.bundle(i)) = 0;
                sys.ta.winnerBids(sys.ta.bundle(i)) = 0;
            end
            % Clear from path and times vectors and remove from bundle
            idx = find(sys.ta.path == sys.ta.bundle(i));
            
            sys.ta.CBBA_RemoveFromList(sys, idx);
            sys.ta.bundle(i) = -1;
        end
    end
end
            

end