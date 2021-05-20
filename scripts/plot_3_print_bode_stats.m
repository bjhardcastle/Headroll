%% cv
clearvars
load('..\mat\bodestats.mat','bodestats');
flyname = 'cv';
flyrange = 'A2:H12'; % excel file 
print_bode_stats

%% tb
clearvars
load('..\mat\bodestats.mat','bodestats');
flyname = 'tb';
flyrange = 'A13:H20'; % excel file 
print_bode_stats

%% ea
clearvars
load('..\mat\bodestats.mat','bodestats');
flyname = 'ea';
flyrange = 'A21:H32'; % excel file 
print_bode_stats