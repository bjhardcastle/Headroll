% clean_up_new
% author: das207@ic.ac.uk
%
% This routine interpolates both, score and angle, iff score is below a certain
% threshold. With each run (iteration of kk), the scores should
% generally increase.
tol = 950;                       % score below which interpolation is run
sig_filter = [1 2 4 2 1]/10;     % smoothing filter     

for kk = 1:clean_runs

    for n = 2:size(data,1)-1
      
        
        % left template
        
      if ( data(n,4) < tol ) % if score is below the given tolerance
         data(n,1) = (data(n-1,1)+data(n+1,1))/2; % interpolate angle with neighbouring angles   
         data(n,4) = (data(n-1,4)+data(n+1,4))/2; % interpolate score with neighbouring scors
      end
      
      
        % right template
      
      if ( data(n,5) < tol ) % if score is below the given tolerance
         data(n,2) = (data(n-1,2)+data(n+1,2))/2; % interpolate angle with neighbouring angles  
         data(n,5) = (data(n-1,5)+data(n+1,5))/2; % interpolate score with neighbouring scors
      end
      
       
    end
    
        % average between angles estimated from left and right template
      
      data(:,3) = (data(:,1)+data(:,2))/2; % this is the final response trace

end


% Smooth the final response trace

filter_length = (length(sig_filter)-1)/2;  
filtered = conv(data(:,3),sig_filter);
data(:,3) = filtered(1+filter_length: end-filter_length);

