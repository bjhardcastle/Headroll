% clean_up_fran
% author: fjh31@cam.ac.uk
%
% I no longer consider the variance of the data points
% for the weigthted average


%%% First eliminate the worse data points

    for n = 2:(size(data,1)-1)
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


%%% Filtering phase

filterx = [-10 -9 -8 -7 -5 -4 -3 -2 -1 0 1 2 3 4 5 6 7 8 9 10];
sigma = 6
gaussian_filter = @(x) exp(-(x.*x)/2/sigma/sigma);
filter = gaussian_filter(filterx);
data_old = data;
var_data_1 = 1000./(data(:,4)+1);
var_data_2 = 1000./(data(:,5)+1);

    for n = 11:(size(data,1)-10)
      for i = 1:length(filterx)
      if ( data(n,4) < tol )
         data(n,) 
         weight_1(i)=filter(i)*var_data_1(n+filterx(i));
         weight_2(i)=filter(i)*var_data_2(n+filterx(i));
         data_1(i)=data_old(n+filterx(i),1)
         data_2(i)=data_old(n+filterx(i),2)
      end
      %data(:,1) = data_1*weigth_1' / sum (weigth_1);
      %data(:,2) = data_2*weigth_2' / sum (weigth_2);
      data(:,3) = (data_1*weigth_1' + data_2*weigth_2')/(sum([weigth_1, weigth_2]))
    end

