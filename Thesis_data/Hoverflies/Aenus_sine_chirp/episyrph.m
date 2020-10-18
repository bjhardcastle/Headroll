folderpath='Z:\Ben\Hoverflies_2015\ben\3_aug Chirp, need conditions from lab book\';

rerun = 0;
if rerun == 1
    

mat_files = dir([folderpath,'*resp.mat']);
freq = 51;
sig_filter = [1 2 4 2 1]/10;     % smoothing filter
     clean_runs = 3;
     tol = 800;
 for file_counter = 1:length(mat_files)/2
     respname = mat_files(2*(file_counter-1)+1).name;
     stimname = mat_files(2*(file_counter-1)+2).name;
     load([folderpath,respname]);     
     respdata = data;
     load([folderpath,stimname]);
     stimdata = data;
 
     clean_up;
     [refstim,resp,stim,fps] = hf_remove_prestim(stimdata,respdata,freq,0);
     if length(resp) < 8000
         resp(end+1:8000) = NaN;
     elseif length(resp) > 8000
         resp = resp(1:8000);
     end
%      figure(99), plot(resp),title(num2str(file_counter)),pause
     chirp(file_counter,:) = resp; 
 end
 for j = 2:6
chirp(j,:) = nan(1,8000);
 end
mean_selected_resp = nanmean(chirp);
figure, plot(nanmean(chirp(11:12,:))), hold on ,plot(mean_selected_resp)

save('episyrph_chirp')
else
    load('episyrph_chirp')
end
%%
startup;

figure(88)
set(gcf,'Position', [103 141 600 150]);
hold off
clear t

timesection = [1/800:1/800:10];

errbar = 1;
clear tvecs
tvecs(1,:) = [1:8000];
t(1,:)=0+timesection;
t(2,:)=24.5+timesection;
t(3,:)=4+timesection;
% for offset axes
xoffset(1) = 0.02;
xoffset(2) = 0.05;
xoffset(3) = 0.05;
% cmap = colormap(lines);
  
  plot(timesection,refstim,'Color',[0.6,0.6,0.6],'LineWidth',1)
  hold on
  plot(timesection,mean_selected_resp,'Color',hov_cols{3},'LineWidth',1)

    ylim([-32 40])


    set(gca,'ytick',[-30,0,30])

        
        set(gca,'yticklabel',{[-30],[0],[30]})
    ylabel('Amplitude [\circ]')

    xlabel('Time [s]')
set(gca,'box','off')
     offsetAxes(gca,xoffset(1),0.3);   


set(gcf,'color','w');
% export_fig('C:\Users\Ben\Dropbox\Work\Thesis\Chapter 2\Figures\chirpstim','-painters','-transparent', '-eps','-q101')
% export_fig('C:\Users\Ben\Dropbox\Work\Thesis\Chapter_3\Figures\episyrph_chirp','-openGL','-r660' )
