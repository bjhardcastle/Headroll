% clean_up_fran
% author: fjh31@cam.ac.uk
%
% I consider 1000/(tol+1) to be the variance of the data points
% and then do a wegthted average


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

filter = [1,2,3,2,1];
filterx = [-2 -1 0 1 2];
data_old = data;
var_data_1 = 1000./(data(:,4)+1);
var_data_2 = 1000./(data(:,5)+1);

    for n = 3:(size(data,1)-2)
      for i = 1:5
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

