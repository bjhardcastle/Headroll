
%%
function fitted_sine = FitSine(raw_trace,period)

 pa = period; 
 ta = (1:length(raw_trace))';
 X = ones(length(ta),3);
 X(:,2) = cos((2*pi)/pa*ta);
 X(:,3) = sin((2*pi)/pa*ta);
 
 Y = raw_trace;
 Y = Y(:);
 beta = X\Y;
 
 fitted_sine = beta(1)+beta(2)*cos((2*pi)/pa*ta)+beta(3)*sin((2*pi)/pa*ta);
 
    