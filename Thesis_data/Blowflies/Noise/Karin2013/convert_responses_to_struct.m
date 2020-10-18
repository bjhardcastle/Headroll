function convert_responses_to_struct(fly_resp)

load processed_stim_resp.mat

resp = permute(resp, [2, 1, 3]);
c1 = squeeze(resp(1,:,:));
c2 = squeeze(resp(2,:,:));

for c = 1:2
    for a = 1:9,
     for b = 1:10
        
         r = [];
         if c ==1 
             r = c1{a,b};
         elseif c==2
             r = c2{a,b};
         end
         
%          % Remove baseline drift by filtering freqs <0.5Hz
%          % Only to be used for looking at ratio of amplitudes..
%                         resp_DC = r;
%                         dt_s = 1/500;
%                         f0_hz = 1/dt_s;
%                         fcut_hz = 0.5;
%                         [x,y] = butterhigh1(fcut_hz/f0_hz);
%                         resp_AC = filtfilt(x,y,resp_DC);
%                         % Find offset of response baseline
%                         os = mean(resp_AC);
%                         r_filt = resp_AC - os;

r_filt = r;
         wnresp(a).cond(c).trial(b,:) = r_filt';
         
     end
    end
end



assignin('base','wnresp',wnresp);


stim = permute(stim, [2, 1, 3]);
c1 = squeeze(resp(1,:,:));
c2 = squeeze(resp(2,:,:));

for c = 1:2
    for a = 1:9,
     for b = 1:10
        
         r = [];
         if c ==1 
             r = c1{a,b};
         elseif c==2
             r = c2{a,b};
         end
         
r_filt = r;
         wnstim(a).cond(c).trial(b,:) = r_filt';
         
     end
    end
end

assignin('base','wnstim',wnstim);


