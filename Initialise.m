function o = Initialise( o, taProp, varargin )

if nargin < 3
    nPlatform = length(taProp);
else
    nPlatform = varargin{1};
end

for i = 1:nPlatform
    
    o(i) = TaskAllocation( );
    
    o(i).epsilon = taProp.epsilon;
    o(i).seeds = taProp(i).seeds;
    o(i).bundle = taProp(i).bundle;
    o(i).maxBundleDepth = taProp(i).maxBundleDepth;
    o(i).CM = taProp(i).CM;
    
    o(i).Graph = taProp(i).Graph;     
%     o(i).plot = taProp(i).plot;
    
end



end