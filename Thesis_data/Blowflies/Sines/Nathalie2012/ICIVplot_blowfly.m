%%%%%% Plot C1 vs C2 (without halteres) 
%%%%%% vs C3 (without halteres, without ocelli)

load('digitised_points.mat')

gain_error_mag = gain_error_mag./sqrt(12);
phase_error = phase_error./sqrt(12);

%GAIN
figure

figa1 = subplot(2,1,1);

%plot c1 flies
h1 = errorbar(round(freqs),gain_mag(1,:),gain_error_mag(1,:));
set(h1,'LineWidth', 3,'Color',[0.0431372549019608 0.517647058823529 0.780392156862745]); 
hold on

%%plot c2 flies
h2 = errorbar(round(freqs),gain_mag(2,:),gain_error_mag(2,:)); 
set(h2,'LineWidth', 3,'Color',[0.8 0.6 1]); 
hold on

%plot c3 flies
h3 = errorbar(round(freqs),gain_mag(3,:),gain_error_mag(3,:)); 
set(h3,'LineWidth', 3,'Color',[1 0.6 0.2]); 
hold on


title(['Blowfly head roll response, stimulus amplitude 40°, N = 12'],'fontsize',12)
ylabel('Gain [linear units]','FontSize',12)        
set(figa1,'XTick',[1,3,6,10],'XTickLabel',{'1','3','6','10'},'fontsize',12)
axis([0 11 0 1])
% legend('Compound eyes + ocelli','Compound eyes','Location','NorthEast')  
   
   

%PHASE
figa2 = subplot(2,1,2);

%plot c1 flies
 p1 = errorbar(round(freqs),phase(1,:),phase_error(1,:)); 
set(p1,'LineWidth', 3,'Color',[0.0431372549019608 0.517647058823529 0.780392156862745]); 
hold on
   
%plot c2 flies
 p2 = errorbar(round(freqs),phase(2,:),phase_error(2,:)); 
set(p2,'LineWidth', 3,'Color',[0.8 0.6 1]); 
hold on

% plot c3 flies
 p3 = errorbar(round(freqs),phase(3,:),phase_error(3,:)); 
set(p3,'LineWidth', 3,'Color',[1 0.6 0.2]); 
hold on

ylabel('Phase [°]','FontSize',12)
xlabel('Frequency [Hz]','FontSize',12)  
set(figa2,'XTick',[1,3,6,10],'XTickLabel',{'1','3','6','10'},'fontsize',12)
axis([0 11 -50 10]) 

