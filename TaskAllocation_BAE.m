function o = TaskAllocation_BAE(o, system, c)

% Description:-
% Just for BAE System demonstration


% Collect informations into the format specified by BAE

RMIN = 20;
RMAX = 120;
VMIN = 0.3;
VMAX = 1;
PREDICTDURATION = 50;   % unit : counter

SIGMA = 3;


allsystempos = zeros(3,length(system));
for i = 1:length(system)
    allsystempos(:,i) = system(i).platform.pos;
end

sys = system(1);
nSystem = length(system);
target = sys.sat.target;

% otherslocktargetid = sys.comm.receive.otherslocktargetid;
% sys.comm.receive.otherslocktargetid = [];

for i=1:length(system)
    system(i).sensor.PointDirection( sys, 'GLOBALDOWN' );
end

if ~isempty(target(1).id)
    
% previous method : flexible time (fn. of distance btw agent and target)
%     for i = 1:length(target)
%         tpos = target(i).x(1:3);
%         timedist(i) = norm(sys.platform.pos(1:2)-tpos(1:2))/sys.platform.cruiseSpeed;
% 
%         dpos = sys.platform.pos(1:2)-tpos(1:2);dpos(3)=0;
%         dpos = dpos./norm(dpos);
%         v1 = [cos(sys.platform.att(3));sin(sys.platform.att(3));0];
%         v2 = -dpos;
%         temp = cross(v1,v2); temp = temp(3);
%         offset = abs(asin( temp ))/pi*24 + 12;
%         %            offset = 24*1.2;
% 
%         timedist(i) = timedist(i) + offset;% account for half circumference of turning
%     end


    PPrevious = GetExpiryTimeLine( target, PREDICTDURATION*ones(1,length(target)) );
    
    % Extract all target id, idindex, pos, rmax, vmax
    id      = zeros(1,length(target));
    id_ind  = zeros(1,length(target));
    tpos    = zeros(3,length(target));
    rmax    = zeros(1,length(target));
    vmax    = zeros(1,length(target));
    rmin    = zeros(1,length(target));
    vmin    = zeros(1,length(target));
    
    for i = 1:length(target)
        id(i)       = target(i).id;
        id_ind(i)   = i;
        tpos(:,i)   = target(i).x(1:3);

        P = PPrevious(:,:,i);
        [v,d]=eig(P);
        targetStd = SIGMA*sqrt(eig(P));
        rmax(i) = max(targetStd(1:3));
        vmax(i) = max(targetStd(4:5));

        P = target(i).P;
        targetStd = SIGMA*sqrt(eig(P));
        rmin(i) = max(targetStd(1:3));
        vmin(i) = max(targetStd(4:5));
        
        % threshold for searching
        for j = 1:length(system)
            system(j).ta.bConsider = (rmax > RMAX) | (vmax > VMAX);
        end
    end

if sum(sys.ta.bConsider) ~= 0
    tic;
    sys.ta.CBBA_Main(system,c);
    time=toc;
    fprintf('CBBA act counter: %5.2f compute time: %5.2f\n',c.counter,time)

    % assign target id from CBBA algorithm to each system
    for j=1:length(system)
        if system(j).ta.path(1) ~= -1
            system(j).sat.mode = 1; % track
            system(j).sat.currenttracktargetid = system(j).ta.path(1);
%             index = system(j).ta.bundle(1);
        else
            if system(j).sat.mode == 1 % if previous mode was track
                system(j).sat.searchcounter = c.counter;
            end
            system(j).sat.mode = 0; % search
        end
    end
else  % all targets are estimated well so agents can search other targets
    % switch target mode as search mode
    for j=1:length(system)
        if system(j).sat.mode == 1
            system(j).sat.mode = 0; % search
            system(j).sat.searchcounter = c.counter;
        end
    end
end

else
    % all for search mode
    for j=1:length(system)
        system(j).sat.mode = 0; % search
    end
end





end


function PPrevious = GetExpiryTimeLine( target, timedist )

ntarget = length(target); % total number of target found

% prepare target previous state matrix for ForwardPredictionPDF
PPrevious = zeros(5,5,ntarget); % [5 by 5 cov matrix by number of target]
for i = 1:ntarget % for every target
    PPrevious(:,:,i) = target(i).P;
end

% prepare constants for ForwardPredictionPDF (assume all targets are the
% same)
% F = target(1).F;
% Q = target(1).Q;
% dt = target(1).dt;
     
dt = 0.2;

timedist = round(timedist)/dt;
for i = 1:ntarget % for every target
    for j = 1:timedist(i) 
    % forward predict PDF
        PPrevious(:,:,i) = target(i).F * PPrevious(:,:,i) * target(i).F' + target(i).Q;
    end
end    

end