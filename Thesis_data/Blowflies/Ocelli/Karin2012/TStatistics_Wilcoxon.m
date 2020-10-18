close all
clear all
%%% load existing data:
load('TKarin2012data.mat')
startup;

%% Mann-whitney U test on C1 vs C2 phase. NOTE: Fly 1 does not exist
freqs = [1,3,6,10];
for f = 1:4
    
    fstr = strcat(['freq',num2str(freqs(f)),'']);
    c = Gunit.phaseA3C1.(fstr)(2:end,:);
    c1a = (reshape(c,[size(c,1)*size(c,2),1]));
    
    c = Gunit.phaseA3C2.(fstr)(2:end,:);
    c2a = (reshape(c,[size(c,1)*size(c,2),1]));
    
%     c1b = c1a(c1a~=0);
%     c2b = c2a(c1a~=0);
%     c1 = c1b(c2b~=0);
%     c2 = c2b(c2b~=0);
    c1=c1a;c2=c2a;
    [p(f),h(f)] = ranksum(c1,c2); % P-values: all <0.05 
 
    j1(f) = jbtest(c1); %shows that all distributions are NOT
    j2(f) = jbtest(c2); %normally distributed, so use median
%     figure, plot([c1,c2])
    m1(f) = median(c1);
    m2(f) = median(c2);
    
    a1(f) = mean(c1);
    a2(f) = mean(c2);
    
    delaydiff(f) = 1000*median(c1-c2)/(360*freqs(f)); % ms
    delay(f) = 1000*median(c1)/(360*freqs(f)); % ms

end

%% Same test for gains
for f = 1:4
    
    fstr = strcat(['freq',num2str(freqs(f)),'']);
    c = Gunit.A3C1.(fstr)(2:end,:);
    c1a = abs(reshape(c,[size(c,1)*size(c,2),1]));
    
    c = Gunit.A3C2.(fstr)(2:end,:);
    c2a = abs(reshape(c,[size(c,1)*size(c,2),1]));
    
%     c1b = c1a(c1a~=0);
%     c2b = c2a(c1a~=0);
%     c1 = c1b(c2b~=0);
%     c2 = c2b(c2b~=0);
    c1=c1a;c2=c2a;
    [p(f),h(f)] = ranksum(c1,c2); % P-values: all <0.05 
 
    j1(f) = jbtest(c1); %shows that all distributions are NOT
    j2(f) = jbtest(c2); %normally distributed, so use median
%     figure, plot([c1,c2])
    m1(f) = median(c1);
    m2(f) = median(c2);
    
    a1(f) = mean(c1);
    a2(f) = mean(c2);
    
    gaindiff(f) = median(c1-c2); % ms
    gain(f) = median(c1); % ms

end

