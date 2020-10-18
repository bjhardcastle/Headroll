close all 
for cidx = 1:5
zsu = iddata( (nanmean(condmeanstim(cidx).fly(:,1:4000)) - nanmean(condmean(cidx).fly(:,1:4000)))',  nanmean(condmeanstim(cidx).fly(:,1:4000))', 1/800 );
zsd = iddata( (nanmean(condmeanstim(cidx).fly(:,4001:8000)) - nanmean(condmean(cidx).fly(:,4001:8000)))',  nanmean(condmeanstim(cidx).fly(:,4001:8000))', 1/800 );

% Change limit of freq range to >> 20 (actual max freq) 
% Model fit gives data for limitless frequencies 
% This isn't very convincing... 

% zf_su = spa(zsu,800,[1:0.5:85]);
% zf_sd = spa(zsd,800,[1:0.5:85]);

zf_su = spafdr(zsu,[],{1,200,200});
zf_sd = spafdr(zsu,[],{1,200,200});

% [mag,ph,w,sdmag,sdphase] = bode(zf_su);
[mag,ph,w,sdmag,sdphase] = bode(zf_sd);

% figure
% bode(zf_sw);

figure(1)
hold on
mag = squeeze(mag);
plot(w,mag)
ylim([0,1])

% sdmag = squeeze(sdmag);
% figure(2)
% hold on
% semilogx(w,mag,w,mag+3*sdmag/sqrt(8),':',w,mag-3*sdmag/sqrt(8),':');
% ylim([0,1])

end