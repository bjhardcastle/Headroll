for n = 2:size(data,1)-1
    if ( data(n,5) < tol )
        data(n,2) = (data(n-1,2)+data(n+1,2))/2;
    end
    if ( data(n,5) < tol )
        data(n,2) = (data(n-1,2)+data(n+1,2))/2;
    end
end
    