% Plot comparison bode plots C1 vs. C2 for each amplitude
close all
clear all
%%% load existing data:
    load('TKarin2012data.mat')
    
    
%%  

startup

color_mat{2} = [0 241 130]/255;
color_mat{4} =[230 40 40]/255 ;
%[153 0 0]
% bodefig =  figure('Position', [   208   495   491   395]);
bodefig =  figure('Position', [   208 295 400 325]);

gainplot_pos = [0.15 0.55 0.8 0.38];
              % left bottom width height
phaseplot_pos = [0.15 0.123 0.8 0.38];
lineprops.width = 1;
num_amps = 1;
% 
% for amp_nr = 3
%         
% 
%         
%         
%         lineprops.col = {[color_mat{2}/255]};
%         lineprops.style = '-';
%         h1 = mseb(freqs,CLgm1,CLgs1,lineprops,1);
%         
%         hold on
%         lineprops.col = {[color_mat{4}/255]}; 
%         lineprops.style = '--';
%         h2 =  mseb(freqs,CLgm2,CLgs2,lineprops,1);
%         title(['Frequency response to horizon roll: blowfly'])
%         ylabel('|G|')
%         axis([0 10.5 0 0.6])
%         legend('CE + O','CE')
%         set(gainplot,'XTick',[1,3,6,10],'XTickLabel',[])
%         set(gca,'box','on')
% 
%         hold off
%         
%         lineprops.style = '-';
%         lineprops.col = {[color_mat{2}/255]};   
%         h3 =  mseb(freqs,CLpm1,CLps1,lineprops,1);      
%         hold on
%         
%         lineprops.col = {[color_mat{4}/255]};
%         lineprops.style = '--';
%         h4 =  mseb(freqs,CLpm2,CLps2,lineprops,1);
%         ylabel('\angle{G} [deg]')
%         xlabel('Frequency  [Hz]')
%         axis([0 10.5 -100 0])
%         set(phaseplot,'XTick',[1,3,6,10],'XTickLabel',{'1','3','6','10'})
%         set(phaseplot,'YTick',[-90,-45,0],'YTickLabel',{'-90','-45','0'})
%         set(gca,'box','on')
% 
%         hold off
% end

for amp_nr = 3
        
        CLg1  = squeeze(resp_gain_mean(:,:,amp_nr,1));
        C1gain = CLg1;
        
        CLp1  = squeeze(resp_phase_mean(:,:,amp_nr,1));
        C1phase = CLp1;
        
        C1 = C1gain.*exp(1i*C1phase*pi/180);
        
        CLg2  = squeeze(resp_gain_mean(:,:,amp_nr,2));
        C2gain = CLg2;
        
        CLp2  = squeeze(resp_phase_mean(:,:,amp_nr,2));
        C2phase = CLp2;
        
        C2 = C2gain.*exp(1i*C2phase*pi/180);
        
        CE = C2./(1-C2);
        CEgain = abs(CE);
        CEphase = angle(CE)*180/pi;
                
        OC =  (( C1./(1-C1)) ./ CE) - 1;
        OCgain = abs(OC);
        OCphase = angle(OC)*180/pi;
                
        gainplot=subplot('Position',gainplot_pos)
        
%         OCphase = OCphase - (OCphase>0)*360;
%         CEphase = CEphase - (CEphase>0)*360;
        
        h1 = plot(freqs,CEgain,'o');
        set(h1, 'MarkerSize', 4);
        set(h1, 'Color', color_mat{2});
                set(h1, 'MarkerFaceColor', color_mat{2}); 
       

        
        hold on
        
        h2 = plot(freqs,OCgain,'s');
        set(h2, 'MarkerSize', 4);
        set(h2, 'Color', color_mat{4});  
        set(h2, 'MarkerFaceColor', color_mat{4});   
 
%         title(['Average all flies, Condition ',int2str(conds(cond_nr)),' and Amplitude ',int2str(amps(amp_nr)),'°'])
        ylabel('Gain')
        %axis([0 11 0 0.5])
        legend('CE','OC')
        hold off
        
        xlim([0 10.5])
        legend([h1(1),h2(1)],'Compound eyes','Ocelli')
        set(gainplot,'XTick',[1,3,6,10],'XTickLabel',[])
        set(gainplot,'YTick',[0,0.25,0.5,0.75,1],'YTickLabel',{'0',[],'0.5',[],'1'})
        set(gca,'box','on')
        set(gca,'Layer','top')

        
        phaseplot=subplot('Position',phaseplot_pos)

        h3 = plot(freqs,CEphase,'o');
        set(h3, 'MarkerSize', 4);
        set(h3, 'Color', color_mat{2});
        set(h3, 'MarkerFaceColor', color_mat{2});
        hold on
        
        h4 = plot(freqs,OCphase,'s');
        set(h4, 'MarkerSize', 4);
        set(h4, 'Color', color_mat{4});  
        set(h4, 'MarkerFaceColor', color_mat{4});  
        ylabel('Phase (degrees)')
        xlabel('Frequency (Hz)')
%         axis([0 11 -360 20])
        hold off
        
        ylabel('Phase [deg]')
        xlabel('Frequency  [Hz]')
        xlim([0 10.5])
        ylim([-360 0])
        set(phaseplot,'XTick',[1,3,6,10],'XTickLabel',{'1','3','6','10'})
        set(phaseplot,'YTick',[-360,-270,-180,-90,0],'YTickLabel',{'-360','-270','-180','-90','0'})
        set(gca,'box','on')

        hold off

end
set(gcf,'renderer','painters')
set(gcf,'color','w');
% -opengl displays dashed lines correctly
% -painters displays transparency
% export_fig('C:\Users\Ben\Dropbox\Work\Thesis\Chapter_4\Figures\blowfly_openloop','-opengl','-transparent', '-eps','-q101')
% export_fig('C:\Users\Ben\Dropbox\Work\Thesis\Chapter_4\Figures\blowfly_openloop','-painters','-r660')    


