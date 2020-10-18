% clean_up_new
% author: das207@ic.ac.uk
%
% This routine interpolates both, score and angle, iff score is below a certain
% threshold. With each run (iteration of kk), the scores should
% generally increase.


for kk = 1:clean_runs

    for n = 2:size(resp_data,1)-1
      
        
        % left template
        
      if ( resp_data(n,4) < tol ) % if score is below the given tolerance
         resp_data(n,1) = (resp_data(n-1,1)+resp_data(n+1,1))/2; % interpolate angle with neighbouring angles   
         resp_data(n,4) = (resp_data(n-1,4)+resp_data(n+1,4))/2; % interpolate score with neighbouring scors
      end
      
      
        % right template
      
      if ( resp_data(n,5) < tol ) % if score is below the given tolerance
         resp_data(n,2) = (resp_data(n-1,2)+resp_data(n+1,2))/2; % interpolate angle with neighbouring angles  
         resp_data(n,5) = (resp_data(n-1,5)+resp_data(n+1,5))/2; % interpolate score with neighbouring scors
      end
      
      
      % average between angles estimated from left and right template
      
      resp_data(:,3) = (resp_data(:,1)+resp_data(:,2))/2; % this is the final response trace
      
      
    end
    
end


% Smooth the final response trace

filter_length = (length(sig_filter)-1)/2;  
filtered = conv(resp_data(:,3),sig_filter);
resp_data(:,3) = filtered(1+filter_length: end-filter_length);

