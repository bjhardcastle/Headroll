
% PRE: in_vec, step

clear test_vec
clear test_std

mod_vec = 180/pi*angle(exp(1i*in_vec)); % phases of individual steps in deg.


    for g = 1:180/step+1
        phase_step = (g-1)*step;
        for k = 1:length(mod_vec)
            if (mod_vec(k) > phase_step)
                test_vec(k,g) = mod_vec(k)-360;
            else 
                test_vec(k,g) = mod_vec(k);
            end
        end
        
        test_std(g) = std(squeeze(test_vec(:,g)));
            
    end
    
    [value, final_g] = min(test_std);
    out_vec = test_vec(:,final_g);

