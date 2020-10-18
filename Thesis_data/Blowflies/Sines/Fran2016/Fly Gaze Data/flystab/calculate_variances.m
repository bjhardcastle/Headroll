step = 5;

for fly = 1:length(fly_array)
    for cond = 1: length(cond_array)
        
        for freq = 2:num_freqs
            
            load_command_F = strcat('step_vector_F=','F_fly',int2str(fly_array(fly)),'C',int2str(cond_array(cond)),'.freq',int2str(freq),';');
            load_command_G = strcat('step_vector_G=','G_fly',int2str(fly_array(fly)),'C',int2str(cond_array(cond)),'.freq',int2str(freq),';');
            
            eval(load_command_F);
            eval(load_command_G);
            
            F_AdB_mean(fly,cond,freq) = mean(abs(step_vector_F));
            F_AdB_std(fly,cond,freq) = std(step_vector_F);
            
            F_Aab_mean(fly,cond,freq) = mean(abs(step_vector_F));
            F_Aab_std(fly,cond,freq) = std(abs(step_vector_F));
            
            in_vec = angle(step_vector_F);
            clean_phase_convert;
            
            F_p_mean(fly,cond,freq) = mean(out_vec);
            F_p_std(fly,cond,freq) = std(out_vec);
            

            
            %F_p_gauss(fly,cond,freq) = test_gaussianity(out_vec);
            %F_Aab_gauss(fly,cond,freq) = test_gaussianity(abs(step_vector_F));
            %F_AdB_gauss(fly,cond,freq) = test_gaussianity(20*log10(abs(step_vector_F)));
            

            
            G_AdB_mean(fly,cond,freq) = mean(abs(step_vector_G));
            G_AdB_std(fly,cond,freq) = std(abs(step_vector_G));
            
            G_Aab_mean(fly,cond,freq) = mean(abs(step_vector_G));
            G_Aab_std(fly,cond,freq) = std(abs(step_vector_G));
            
            in_vec = angle(step_vector_G);
            clean_phase_convert;
            
            G_p_mean(fly,cond,freq) = mean(out_vec);
            G_p_std(fly,cond,freq) = std(out_vec);
            
            %G_p_gauss(fly,cond,freq) = test_gaussianity(out_vec);
            %G_Aab_gauss(fly,cond,freq) = test_gaussianity(abs(step_vector_G));
            %G_AdB_gauss(fly,cond,freq) = test_gaussianity(20*log10(abs(step_vector_G)));

            
    
        end    
    end
end