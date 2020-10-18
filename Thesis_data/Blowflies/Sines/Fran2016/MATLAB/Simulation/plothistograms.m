h1 = histogram(abs(simout.signal1.Data))
hold on
h2 = histogram(abs(simout.signal2.Data))
h1.Normalization = 'probability';
%h1.BinWidth = 0.05;
h2.Normalization = 'probability';
h1.BinWidth = h2.BinWidth;
