function o = CBBA_Bundle(o, sys, c)

% Update bundles after messaging to drop tasks that are outbid
sys.ta.CBBA_BundleRemove(sys, c);

% Bid on new tasks and add them to the bundle
sys.ta.CBBA_BundleAdd(sys, c);

end