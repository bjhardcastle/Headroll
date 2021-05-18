% re-load and process e.tenax chirp data (single example
chirp_range = 504:8503;
stimdata = load('..\Thesis_data\Hoverflies\Eristalis Sines\Hoverflies_2015\nov_23__Cam_v211_CineF44stim (2).mat');
stim = clean_data(stimdata.data);
stim = stim(chirp_range,:);

respdata = load('..\Thesis_data\Hoverflies\Eristalis Sines\Hoverflies_2015\nov_23__Cam_v211_CineF44resp (2).mat');
resp = clean_data(respdata.data);
resp = resp(chirp_range,:);

resp = resp - resp(1);
save('..\Thesis_data\Hoverflies\Eristalis Sines\Hoverflies_2015\eristalis_chirp_example.mat','resp','stim')

function dataFiltered = clean_data(data,plotResults)

if nargin<2
    plotResults = 0;
end

tol = 700;                     % Matching score below which interpolation is performed - 600
ugly_fractions = [];           % fractions of points removed
N_sigma_in_a_cycle = 25;       % how many sigmas per oscillation cycle - 12,25,50

% for freqs > 15
sig_filter = [1 2 4 2 1]/10;     % smoothing filter
clean_runs = 3;

if plotResults   
    figure
    plot(data(:,3),'k')
    hold on
end

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
      
      
      % average between angles estimated from left and right template
      
      data(:,3) = (data(:,1)+data(:,2))/2; % this is the final response trace
      
      
    end
    
end


% Smooth the final response trace

filter_length = (length(sig_filter)-1)/2;  
filtered = conv(data(:,3),sig_filter);
data(:,3) = filtered(1+filter_length: end-filter_length);

dataFiltered = data;

if plotResults
    hold on,
    plot(data(:,3),'r')
end
end
