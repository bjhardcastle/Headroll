function [ cleaned, damned_souls ] = clean_trace( data, tol )
%CLEAN_TRACE Summary of this function goes here
%   Cleans and purifies the unwashed with righteosness of 'tol'
%   'damned_souls' marks the number of discarded frames
%   author: fjhheras@gmail.com
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
    end

   cleaned = (data(:,1)+data(:,2))/2;
   damned_souls = ugliness/(size(data,1)-2);
    
end

