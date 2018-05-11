function sat = Plot( sat, f )

if sat.isSearch && sat.search.plot.display
    % Plot search area grid
    sat.search.Plot( f );
end


if sat.isTrack 
    % Plot target belief
    if isempty(sat.target(1).id); return; end;
    sat.target.Plot( f );
    
    % Plot current lock target line
    plothdl = sat.plot.locktargetline;
    if plothdl.display 
        if isempty( plothdl.h ) || ~ishandle( plothdl.h )
            if strcmp(plothdl.visible,'on')
                set(0,'CurrentFigure',f);

                locktargetlinex = [plothdl.pos_s(1)*ones(1,size(plothdl.pos_e,2)),plothdl.pos_e(1,:)];
                locktargetliney = [plothdl.pos_s(2)*ones(1,size(plothdl.pos_e,2)),plothdl.pos_e(2,:)];
                locktargetlinez = [plothdl.pos_s(3)*ones(1,size(plothdl.pos_e,2)),plothdl.pos_e(3,:)];
                plothdl.h = line(locktargetliney,locktargetlinex,-locktargetlinez);
    
                set( plothdl.h, 'linestyle', plothdl.linestyle, 'linewidth', plothdl.linewidth, 'color', plothdl.color );
            end
        elseif strcmp(plothdl.visible,'on')
            locktargetlinex = [plothdl.pos_s(1)*ones(1,size(plothdl.pos_e,2)),plothdl.pos_e(1,:)];
            locktargetliney = [plothdl.pos_s(2)*ones(1,size(plothdl.pos_e,2)),plothdl.pos_e(2,:)];
            locktargetlinez = [plothdl.pos_s(3)*ones(1,size(plothdl.pos_e,2)),plothdl.pos_e(3,:)];
            set( plothdl.h, 'xdata', locktargetliney, 'ydata', locktargetlinex, 'zdata', -locktargetlinez, 'visible',plothdl.visible  );
        else
            set( plothdl.h,  'visible',plothdl.visible  );
        end
    end
    sat.plot.locktargetline = plothdl;
    
    
    % Plot group belief
    if isempty(sat.group); return; end;
    sat.group.Plot( f );
    
end

end