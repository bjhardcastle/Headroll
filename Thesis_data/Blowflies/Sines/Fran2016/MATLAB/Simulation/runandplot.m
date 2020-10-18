f = 10
gain_halteres=1
sim('noise.slx')
plothistograms
hold on

gain_halteres=0
sim('noise.slx')
plothistograms