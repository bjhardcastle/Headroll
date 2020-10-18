%clean_up_fran
%author: fjh31@cam.ac.uk

%%% First eliminate the worst data points
% those will be those with data(,4) wore than tol and worse than the
% neighbor's data(,4)

ugliness = 0;
for n = 2:(size(data,1)-1)
  if ( data(n,4) < tol && data(n,4) < data(n+1,4) && data(n,4) < data(n-1,4) )
     ugliness = ugliness + 1;
     data(n,1) = (data(n-1,1)+data(n+1,1))/2; %left angle
     data(n,4) = (data(n-1,4)+data(n+1,4))/2; %tolerance left angle (1000 great, 500 bad, 0 worst)
  end
  if ( data(n,5) < tol && data(n,5) < data(n+1,5) && data(n,5) < data(n-1,5) )
     ugliness = ugliness + 1;
     data(n,2) = (data(n-1,2)+data(n+1,2))/2; %right angle
     data(n,5) = (data(n-1,5)+data(n+1,5))/2; %tolerance right angle
  end
  data(:,3) = (data(:,1)+data(:,2))/2;
end

ugly_fractions = [ugly_fractions, ugliness/2/(size(data,1)-2)];


%%% Filtering phase

filterx = -N_filter:N_filter;
gaussian_filter = @(x) exp(-(x.*x)/2/sigma/sigma); % not normalised, careful!
filter = gaussian_filter(filterx);
data_old = data;


% 
    for n = (N_filter+1):(size(data,1)-N_filter)
        
      %%% Produce Gaussian weights
        
      for i = 1:length(filterx)
         weight_1(i)=filter(i);
         weight_2(i)=filter(i);
         data_1(i)=data_old(n+filterx(i),1);
         data_2(i)=data_old(n+filterx(i),2);
      end
      
      %%% Weight data with the Gaussians and then normalise
      
      %data(:,1) = data_1*weigth_1' / sum (weigth_1);
      %data(:,2) = data_2*weigth_2' / sum (weigth_2);
      data(n,3) = (data_1*weight_1' + data_2*weight_2')/(sum([weight_1, weight_2])); %I only use this one, so I only filter this one (call me lazy but it saves time)
    end
    


