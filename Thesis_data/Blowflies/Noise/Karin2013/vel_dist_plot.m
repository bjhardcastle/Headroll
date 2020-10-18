conditions{1} = '_WN_no-ocelli-';
conditions{2} = '_WN_without-halteres_';
clear trialhead_angle
load processed_stim_resp.mat

for fly = 1:size(resp,1)
    for cond = 1:size(resp,2)
        n=0;
        headabs = zeros(25000,1);
        for trial = 1:size(resp,3)
            data_path = ['C:\Users\Ben\Dropbox\Work\Karin2013\Fly' int2str(fly-1) '\'];
            resp_file = ['Fly' int2str(fly-1),conditions{cond},int2str(trial),'resp.mat'];
            stim_file = ['Fly' int2str(fly-1),conditions{cond},int2str(trial),'stim.mat'];
            if exist(([data_path,resp_file]),'file') && exist(([data_path,stim_file]),'file')
                headabs = resp{fly,cond,trial};
                trialhead_angle(:,fly,cond) = headabs + headabs;
                n = n+1;
            end
            trialhead_angle(:,fly,cond) = trialhead_angle(:,fly,cond)./n;
        end
    end
end
meanhead_angle = mean(trialhead_angle,2);
meanhead_velocity = gradient(meanhead_angle,1/500);

headmean_angle = nanmean(trialhead_angle,2);
headmean_velocity(:,1) = gradient(headmean_angle(:,1),1/500);
headmean_velocity(:,2) = gradient(headmean_angle(:,2),1/500);
bodymean_velocity = gradient(stim{1,1,1},1/500); % all runs use the same stimulus trace
[h1,h1i] = ksdensity(abs(headmean_velocity(:,1)));
[h2,h2i] = ksdensity(abs(headmean_velocity(:,2)));
[b,bi] = ksdensity(abs(bodymean_velocity));
plot(h1i,h1,h2i,h2,'r',bi,b,'LineWidth',1.5)
xlim([0 500])
legend('head, C1','head, C2','body')
xlabel('velocity, {\circ}s^{-1}')
ylabel('p(x)')