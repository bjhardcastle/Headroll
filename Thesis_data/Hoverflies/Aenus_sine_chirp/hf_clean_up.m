% clean_up_new
% author: das207@ic.ac.uk
%
% This routine interpolates both, score and angle, iff score is below a certain
% threshold. With each run (iteration of kk), the scores should
% generally increase.



% subplot(2,1,1)
% plot(data(:,3))
% hold on
% subplot(2,1,2)
% plot(data(:,4))

for kk = 1:clean_runs

    for n = 2:size(trimmed_data,1)-1
      
        
        % left template
        
      if ( trimmed_data(n,4) < tol ) % if score is below the given tolerance
         trimmed_data(n,1) = (trimmed_data(n-1,1)+trimmed_data(n+1,1))/2; % interpolate angle with neighbouring angles   
         trimmed_data(n,4) = (trimmed_data(n-1,4)+trimmed_data(n+1,4))/2; % interpolate score with neighbouring scors
      end
      
      
        % right template
      
      if ( trimmed_data(n,5) < tol ) % if score is below the given tolerance
         trimmed_data(n,2) = (trimmed_data(n-1,2)+trimmed_data(n+1,2))/2; % interpolate angle with neighbouring angles  
         trimmed_data(n,5) = (trimmed_data(n-1,5)+trimmed_data(n+1,5))/2; % interpolate score with neighbouring scors
      end
      
      
      % average between angles estimated from left and right template
      
      trimmed_data(:,3) = (trimmed_data(:,1)+trimmed_data(:,2))/2; % this is the final response trace
      
      
    end
    
end


% Smooth the final response trace

filter_length = (length(sig_filter)-1)/2;  
filtered = conv(trimmed_data(:,3),sig_filter);
trimmed_data(:,3) = filtered(1+filter_length: end-filter_length);

% hold on,
% subplot(2,1,1)
% plot(data(:,3),'r')
% subplot(2,1,2)
% plot(data(:,4),'r')
% 
