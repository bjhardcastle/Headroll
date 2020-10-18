%clean_up_fran
%author: fjh31@cam.ac.uk

%I consider 1000/(tol+1)-0.5 to be the variance of the data points
%and then do a weigthed average

%%% First eliminate the worst data points

for n = 2:(size(data,1)-1)
  if ( data(n,4) < tol && data(n,4) < data(n+1,4) && data(n,4) < data(n-1,4) )
     data(n,1) = (data(n-1,1)+data(n+1,1))/2; %left angle
     data(n,4) = (data(n-1,4)+data(n+1,4))/2; %tolerance left angle (1000 great, 500 bad, 0 worst)
  end
  if ( data(n,5) < tol && data(n,5) < data(n+1,5) && data(n,5) < data(n-1,5) )
     data(n,2) = (data(n-1,2)+data(n+1,2))/2; %right angle
     data(n,5) = (data(n-1,5)+data(n+1,5))/2; %tolerance right angle
  end
  data(:,3) = (data(:,1)+data(:,2))/2;
end


%%% Filtering phase

filterx = [-10 -9 -8 -7 -5 -4 -3 -2 -1 0 1 2 3 4 5 6 7 8 9 10];
gaussian_filter = @(x) exp(-(x.*x)/2/sigma/sigma); % not normalised, careful!
filter = gaussian_filter(filterx);
data_old = data;

var_data_1 = power(1000./(data(:,4)+1),power_tol)-0.5; %power_tol: 0-> data tolerance is not considered, 1-> it is considered as a variance
var_data_2 = power(1000./(data(:,5)+1),power_tol)-0.5;

    for n = 11:(size(data,1)-10)
        
      %%% Produce Gaussian weights
        
      for i = 1:length(filterx)
         weight_1(i)=filter(i)/var_data_1(n+filterx(i));
         weight_2(i)=filter(i)/var_data_2(n+filterx(i));
         data_1(i)=data_old(n+filterx(i),1);
         data_2(i)=data_old(n+filterx(i),2);
      end
      
      %%% Weight data with the Gaussians and then normalise
      
      %data(:,1) = data_1*weigth_1' / sum (weigth_1);
      %data(:,2) = data_2*weigth_2' / sum (weigth_2);
      data(n,3) = (data_1*weight_1' + data_2*weight_2')/(sum([weight_1, weight_2])); %I only use this one, so I only filter this one (call me lazy but it saves time)
    end
    


