function [ filtered_signal ] = gaussian_filtering( signal, sigma)
%GAUSSIAN_FILTERING Gaussian filtering of signal
%   sigma is the SD of the Gaussian
%   author: fjhheras@gmail.com

    N_filter = ceil(3*sigma); %width of filter -> truncated at 3*SD

    filterx = -N_filter:N_filter;
    gaussian_filter = @(x) exp(-(x.*x)/2/sigma/sigma); % not normalised, careful!
    filter = gaussian_filter(filterx);
    filtered_signal = conv(signal,filter,'valid')/sum(filter);

end

