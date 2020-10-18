% clean_up_new
% author: das207@ic.ac.uk
%
% This routine interpolates both, tol and angle, iff tol is below a certain
% threshold. With each run (iteration of kk), the tolerances should
% generally increase.


for kk = 1:clean_runs

    for n = 2:size(data,1)-1
      if ( data(n,4) < tol )
         data(n,1) = (data(n-1,1)+data(n+1,1))/2;
         data(n,4) = (data(n-1,4)+data(n+1,4))/2;
      end
      if ( data(n,5) < tol )
         data(n,2) = (data(n-1,2)+data(n+1,2))/2;
         data(n,5) = (data(n-1,5)+data(n+1,5))/2;
      end
      data(:,3) = (data(:,1)+data(:,2))/2;
    end
    
end



