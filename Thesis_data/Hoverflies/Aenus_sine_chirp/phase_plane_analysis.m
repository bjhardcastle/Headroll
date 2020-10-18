% % % % fly_array = [2,3,4,5,6,7];    % numbers of flies to be included in study (remove fly8, no publishable data)
% % % % cond_array = [2,3];                     % numbers of conditions to be included
% % % % freq = [0.03,0.06,0.1,0.3,0.6,1,3,6.00,10.0,15,20,25];
p = 7;
fly = 7;
cond = 2;
stim_diff = result(1,1,1).thoraxvel;
resp_diff = result(1,1,1).headvel;
Fs = result(1,1,1).Fs;
F = freq(p);
period = round(Fs/F);
figure(99)
secL = period; %length of data section plot in each loop
for secN = 0:floor(length(resp_diff)-2)/secL,
    sec_0 = 1 + secN*secL;
%     sec_1 = 1 + secL + secN*secL; %overlaps to keep line continuous with last
        sec_1 =  secL + secN*secL; % no overlap
    stimsecs(secN+1,1:period)= stim_diff(sec_0:sec_1);
    respsecs(secN+1,1:period)= resp_diff(sec_0:sec_1);
end
    
%                         plot(stim_diff(2:length(resp_diff))*Fs,resp_diff(2:length(resp_diff))*Fs,'.')
plot(median(stimsecs(:,1:33),2),median(respsecs(:,1:33),2))
% plot(stim_diff(sec_0:sec_1)*Fs,resp_diff(sec_0:sec_1)*Fs, 'k')
hold on
ax = get(gca);
ax.xlabel = 'thorax velocity (deg/s)';
ax.ylabel = 'head velocity (deg/s)';
ylim([-4000 4000])
xlim([-4000 4000])
ax.XAxisLocation = 'origin';
ax.YAxisLocation = 'origin';
ax.style = 'equal';
% pause(0.1)
%                     plot(stim_diff(2:length(resp_diff))*Fs,resp_diff(2:length(resp_diff))*Fs)
% end