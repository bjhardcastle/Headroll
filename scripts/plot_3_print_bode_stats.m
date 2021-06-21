%% cv
clearvars
load('..\mat\bodestats.mat','bodestats');
flyname = 'cv';
flyrange = 'A1:K12'; % excel file 
print_bode_stats

%% tb
clearvars
load('..\mat\bodestats.mat','bodestats');
flyname = 'tb';
flyrange = 'A13:K21'; % excel file 
print_bode_stats

%% ea
clearvars
load('..\mat\bodestats.mat','bodestats');
flyname = 'ea';
flyrange = 'A22:K34'; % excel file 
print_bode_stats