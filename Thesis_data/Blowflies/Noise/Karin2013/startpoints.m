resume_from_last_flag = 1;
close all

conditions{1} = '_WN_no-ocelli-';
conditions{2} = '_WN_dark-';
conditions{3} = '_WN_without-halteres_';
conditions{4} = '_WN_without-halteres_dark_';

fig1 = figure('Position', [200, 100, 1500, 800]);

if resume_from_last_flag == 0;
    last_fly = 1;
    last_cond = 1;
    last_trial = 1;
end

for fly = 1:9  
    fly_name = fly - 1;
    for cond = 1:4
        for trial = 1:10
            clear data
            clear body
            clear filtbody
            data_path = ['C:\Users\Ben\Dropbox\Work\Karin2013\Fly' int2str(fly_name) '\'];
            resp_file = ['Fly' int2str(fly_name),conditions{cond},int2str(trial),'resp.mat']; 
            stim_file = ['Fly' int2str(fly_name),conditions{cond},int2str(trial),'stim.mat'];  
            

            if exist(([data_path,resp_file]),'file') && exist([data_path,stim_file],'file')
                
                load([data_path,resp_file])
                skip_flag = 0;
                if size(data,2) == 9;
                    existingstimstart = data(1,9);
                    load([data_path,stim_file])
                    plot(data(1:1500,3));
                    hold on,
                    plot(existingstimstart,data(existingstimstart,3),'r*')
                    hold off
                    
                    skip_flag = waitforbuttonpress;
                    % Press any key to skip, click left mouse to choose new start point 

                end
                
                if skip_flag == 0;
            
                load([data_path,stim_file])
                    disp([fly_name,cond,trial])  
                    body = data(:,3);
                    bodyfilt = sgolayfilt(data(:,3),1,17);



                    f = find(bodyfilt>0.8);

                    if (length(body)>1500)
                        plotstop = 1800;
                    else
                        plotstop = 1500;
                    end

                    plot(body(1:plotstop)) 
                    hold on
                    plot(bodyfilt(1:plotstop),'r')
                    hold off

                    if f(1)>50
                        axis([f(1)-50 f(1)+50 -3 3])
                    else
                        axis([1 50 -3 3])
                    end

                    [est ~] = ginput(1);
                    est = round(est);


                    if est > 10
                        plot(body(1:plotstop))                    
                        axis([est-10 est+10 -0.2 0.5])
                        [s ~] = ginput(1);
                    else
                        plot(body(1:plotstop))
                        axis([1 10 -0.2 0.5])
                        [s ~] = ginput(1);
                    end


                    stimstart = round(s)   

                    clear data
                    load([data_path,resp_file])
                    data(1,9) = stimstart;
                    save([data_path,resp_file],'data','path')
                end
                
            end             
        end
    end
end
