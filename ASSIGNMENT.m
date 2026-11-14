%[text]{"align":"center"} Lab course Scientific Computing 
%[text]{"align":"center"} Worksheet 1
%[text] completed by Group 8:
%[text]{"align":"right"} Manou Engel
%[text]{"align":"right"} Elina Kantseva
%[text]{"align":"right"} Samuele Vignoli
%[text] Disclaimer: the following live script is not supposed to run without errors and warnings. This is a report document and the code cells are there just to highlight the edited parts of the overall program. Not all of them are intended to run (see the first comment in each code cell).
%[text]{"align":"right"} 
%[text] Task a)
%[text] We have modified the file mchoice.m by filling in the implementation of the function predict1.
% will not run
function next = predict1(j, transm)
    global param_a param_b;
    transm % display/print transition matrix
    if isempty(param_a) || isempty(param_b) || param_a > param_b || param_a < 0 || param_b > 1
        error('parameters should satisfy 0 <= param a <= param b <= 1');
    end
    param_c = rand();
    if param_c < param_a
        hnext = mod(j, 3) + 1;
    elseif param_c < param_b
        hnext = mod(j+1, 3) + 1;
    else
        hnext = j;
    end
    next = winchoice(hnext);
end
%[text] Task b) 
%[text] Here we analyzed 3 policy functions predicting the player's next move. We have ultimately decided to interpret "Deterministic" as "Not using any kind of randomness, e.g. the rand() function", and "With memory" as "Using the transition matrix". Typically, "memoryless" in a Markov chain refers to only having access to the current step of the chain and to none of the previous steps. Although all three predict functions only have access to the current (j-th) step, two of them do employ the transition matrix, which is in practice a statistic derived from all previous steps. As such, we say that it represents a kind of "memory" as it encodes information from all previous steps.  
%[text:table]{"ignoreHeader":true}
%[text] | Method \\ Property | Deterministic | With memory |
%[text] | --- | --- | --- |
%[text] | predict1 | no | no |
%[text] | predict2 | yes | yes |
%[text] | predict3 | no | yes |
%[text:table]
%[text] 
%[text] Task c)
%[text] We have performed 3 experiments to determine the convergence limit of the transition matrix transm when using predict2 as the computer's strategy and get\_human\_move.m as the human's.
%[text] The results are stored in data\_2\_2\_10.m, data\_2\_2\_100.m, and data\_2\_2\_1000.mat for games of 10, 100, and 1000 rounds respectively. 
% runs
data10 = load('data_2_2_10.mat'); 
data100 = load('data_2_2_100.mat'); 
data1000 = load('data_2_2_1000.mat'); 
disp(data10.transm) 
disp(data100.transm) 
disp(data1000.transm) 
%[text] These results suggest the matrix transm converges to:
%[text:table]{"ignoreHeader":true}
%[text] | 0 | 1 | 0 |
%[text] | --- | --- | --- |
%[text] | 0 | 0 | 1 |
%[text] | 1 | 0 | 0 |
%[text:table]
%[text] 
%[text] Task d)
%[text] Also in the main function of the file mchoice.m, we implemented samplem2 and transm2 in an analogous way to samplem and transm
% will not run
% --- Main function ---
function next = mchoice(ng, i, j, i_comp, j_comp)
    % machine next move
    global samplem samplem2 transm transm2 policy
    if(ng == 1)
        % initialize matrices
        [samplem,transm]   = initmchoice;
        [samplem2, transm2] = initmchoice;
        next = randi(3);
    else
        samplem  = updatesamplem(i,j,samplem);
        samplem2 = updatesamplem(i_comp,j_comp,samplem2);
        transm   = updatetransm(samplem);
        transm2  = updatetransm(samplem2);
    
        switch policy
            case 1
                next = predict1(j,transm);
            case 2
                next = predict2(j,transm);
            case 3
                next = predict3(j,transm);
            otherwise
                error('Bad policy given!')
        end
    
    end
    transm2 % print transm2 at the end of mchoice
end

%[text] We have used i\_comp and j\_comp as with i, j. For this reason, we updated the function signature to include them. We have also added sample2 and transm2 as global variables, again as the existing implementation. We have printed the transm2 at the end of mchoice function. The file game.m needed updates to:
%[text] transm2 was added to global variables
% will not run
global transm transm2 results numrounds policy gametype % here we added transm2
%[text] In the function testChoice, in the instance of calling mchoice function, we have modified the call: either 
% will not run
next = mchoice(norounds,0,0,0,0); %added 2 zeros for i_comp, j_comp
%[text] for the first call, or
% will not run
next = mchoice(norounds,history(end-1,2),history(end,2),history(end-1,1),history(end,1));   % human same change
%[text] for later calls.
%[text] Task e)
%[text] Same as task c), but using predict3 and transm2. The results are stored in the files data\_2\_3\_10.m, data\_2\_3\_100.m, data\_2\_3\_1000.m for games of 10, 100, and 1000 rounds respectively.
% do run
data10 = load('data_2_3_10.mat'); 
data100 = load('data_2_3_100.mat'); 
data1000 = load('data_2_3_1000.mat'); 
disp(data10.transm2) 
disp(data100.transm2) 
disp(data1000.transm2)
%[text] These results suggest the matrix transm converges to:
%[text:table]{"ignoreHeader":true}
%[text] | 0 | 0 | 1 |
%[text] | --- | --- | --- |
%[text] | 1 | 0 | 0 |
%[text] | 0 | 1 | 0 |
%[text:table]
%[text] 

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"onright"}
%---
