%%%%%% Plot C1 vs C2 (without halteres)


%GAIN
figure

figa1 = subplot(2,1,1);

%%plot c1 flies
for n = 1:4,
for f = 1:9,
 
    ta1(n,f) = resp_gain_mean(1,f,n,1,1);  
    
end
    st1(n) = std(ta1(n,:))/sqrt(9);
end
h1 = errorbar(round(freqs),mean(ta1,2),st1);
set(h1,'LineWidth', 3,'Color',[0.0431372549019608 0.517647058823529 0.780392156862745]); 
hold on

%%plot c2 flies
for n = 1:4,
for f = 1:9,
 
    ta2(n,f) = resp_gain_mean(1,f,n,1,2);  
   
end
    st2(n) = std(ta2(n,:))/sqrt(9);
end
h2 = errorbar(round(freqs),mean(ta2,2),st2); 
set(h2,'LineWidth', 3,'Color',[0.8 0.6 1]); 
hold on

%plot c3 flies
for n = 1:4,
for f = 1:9,
 
    ta3(n,f) = resp_gain_mean(2,f,n,1,3);    
end
    st3(n) = std(ta3(n,:))/sqrt(9);    
end
h3 = errorbar(round(freqs),mean(ta3,2),st3); 
set(h3,'LineWidth', 3,'Color',[1 0.6 0.2]); 
hold on


title(['Robberfly head roll response, stimulus amplitude 30°, N = 9'],'fontsize',12)
ylabel('Gain [linear units]','FontSize',12)        
set(figa1,'XTick',[1,3,6,10],'XTickLabel',{'1','3','6','10'},'fontsize',12)
axis([0 11 0 1])
% legend('Compound eyes + ocelli','Compound eyes','Location','NorthEast')  
   
   

%PHASE
figa2 = subplot(2,1,2);

%%plot c1 flies
for n = 1:4,
for f = 1:9,
    tb1(n,f) = resp_phase_mean(1,f,n,1,1);      
end
    pt1(n) = std(tb1(n,:))/sqrt(9);
end
p1 = errorbar(round(freqs),mean(tb1,2),pt1); 
set(p1,'LineWidth', 3,'Color',[0.0431372549019608 0.517647058823529 0.780392156862745]); 
hold on
   
%%plot c2 flies
for n = 1:4,
for f = 1:9,
    tb2(n,f) = resp_phase_mean(1,f,n,1,2);      
end
    pt2(n) = std(tb2(n,:))/sqrt(9);
end
p2 = errorbar(round(freqs),mean(tb2,2),pt2); 
set(p2,'LineWidth', 3,'Color',[0.8 0.6 1]); 
hold on

%plot c3 flies
for n = 1:4,
for f = 1:9,
    tb3(n,f) = resp_phase_mean(2,f,n,1,3);      
end
    pt3(n) = std(tb3(n,:))/sqrt(9);
end
p3 = errorbar(round(freqs),mean(tb3,2),pt3); 
set(p3,'LineWidth', 3,'Color',[1 0.6 0.2]); 
hold on

ylabel('Phase [°]','FontSize',12)
xlabel('Frequency [Hz]','FontSize',12)  
set(figa2,'XTick',[1,3,6,10],'XTickLabel',{'1','3','6','10'},'fontsize',12)
axis([0 11 -50 10]) 


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%% Plot C3 vs C4 (conditions with halteres)
% 
% figure    
% 
% %GAIN
% 
% figb1 = subplot(2,1,1);
% %plot c3 flies
% for n = 1:4,
% for f = 1:9,
%  
%     ta3(n,f) = resp_gain_mean(2,f,n,1,3);    
% end
%     st3(n) = std(ta3(n,:))/sqrt(9);    
% end
% h3 = errorbar(round(freqs),mean(ta3,2),st3,'b'); 
% set(h3,'LineWidth', 3); 
% hold on
% 
% %%plot c4 flies
% for n = 1:4,
% for f = 1:10,
%  
%     ta4(n,f) = resp_gain_mean(2,f,n,1,4);  
%     
% end
%     st4(n) = std(ta4(n,:))/sqrt(10);
% end
% h4 = errorbar(round(freqs),mean(ta4,2),st4,'r');
% set(h4,'LineWidth', 3); 
% hold on
% 
% 
% title(['Gain and phase of closed-loop head roll response, N = 9, stimulus amplitude 30°'],'FontSize',12)
% ylabel('Gain [linear units]','FontSize',12)        
% set(figb1,'XTick',[1,3,6,10],'XTickLabel',{'1','3','6','10'},'fontsize',12)
% axis([0 11 0 0.7]) 
% 
% 
% %PHASE
% 
% figb2 = subplot(2,1,2);
% %plot c3 flies
% for n = 1:4,
% for f = 1:9,
%     tb3(n,f) = resp_phase_mean(2,f,n,1,3);      
% end
%     pt3(n) = std(tb3(n,:))/sqrt(9);
% end
% p3 = errorbar(round(freqs),mean(tb3,2),pt3,'b'); 
% set(p3,'LineWidth', 3); 
% hold on
% 
% %%plot c4 flies
% for n = 1:4,
% for f = 1:9,
%     tb4(n,f) = resp_phase_mean(2,f,n,1,4);      
% end
%     pt4(n) = std(tb4(n,:))/sqrt(10);
% end
% p4 = errorbar(round(freqs),mean(tb4,2),pt4,'r'); 
% set(p4,'LineWidth', 3); 
% hold on
% 
% 
% ylabel('Phase [°]','FontSize',12)
% xlabel('Frequency [Hz]','FontSize',12)  
% set(figb2,'XTick',[1,3,6,10],'XTickLabel',{'1','3','6','10'},'fontsize',12)
% axis([0 11 -50 10]) 
% legend('Halteres + compound eyes + ocelli', 'Halteres + compound eyes','Location','SouthEast')
% 
